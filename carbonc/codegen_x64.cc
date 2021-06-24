#include <fstream>
#include <cstdarg>
#include <cassert>
#include <variant>
#include "codegen.hh"
#include "codegen_x64.hh"
#include "emitter_x64_windows.hh"
#include "common.hh"
#include "type_system.hh"
#include <stack>
#include <optional>
#include <set>

namespace carbon {

using local_index = int;

using instr_dest = std::variant<gen_register, local_index>;

struct instr_data {
    instr_dest dest;
};

struct var_data {
    std::optional<gen_register> reg;
    std::int32_t frame_offset;
};

struct func_data {
    std::string end_label;
    std::vector<var_data> arg_data;
    std::vector<var_data> local_data;
    std::vector<instr_data> instr_data;
    std::set<gen_register> used_temp_registers;
    int call_arg_size = 0;
};

constexpr gen_register reg_result = rax;
constexpr gen_register reg_intermediate = r10;

gen_destination adjust_for_type(gen_destination dest, type_id tid) {
    auto tdef = tid.scope->type_defs[tid.type_index];
    if (std::holds_alternative<gen_register>(dest)) {
        auto reg = std::get<gen_register>(dest);
        std::size_t sz = std::min(tdef->size, std::size_t{ 8 });
        switch (sz) {
        case 1:
            return gen_register(reg + 16*3);
        case 2:
            return gen_register(reg + 16*2);
        case 4:
            return gen_register(reg + 16);
        case 8:
            return reg;
        }
    }
    else if (std::holds_alternative<gen_offset>(dest)) {
        gen_offset offs = std::get<gen_offset>(dest);
        offs.op_size = tdef->size;
        return offs;
    }
    return dest;
}

gen_operand toop(gen_destination dest) {
    if (std::holds_alternative<gen_register>(dest)) {
        return std::get<gen_register>(dest);
    }
    if (std::holds_alternative<gen_offset>(dest)) {
        return std::get<gen_offset>(dest);
    }
    if (std::holds_alternative<gen_data_offset>(dest)) {
        return std::get<gen_data_offset>(dest);
    }
    assert(!"toop not handled!");
}

gen_destination todest(gen_operand op) {
    if (std::holds_alternative<gen_register>(op)) {
        return std::get<gen_register>(op);
    }
    if (std::holds_alternative<gen_offset>(op)) {
        return std::get<gen_offset>(op);
    }
    if (std::holds_alternative<gen_data_offset>(op)) {
        return std::get<gen_data_offset>(op);
    }
    assert(!"todest not handled!");
}

template <typename T> bool is_mem(const T& op) {
    return std::holds_alternative<gen_offset>(op) || std::holds_alternative<gen_data_offset>(op);
}

template <typename T> bool is_reg(const T& op) {
    return std::holds_alternative<gen_register>(op);
}

template <typename T> bool is_lit(const T& op) {
    return std::holds_alternative<int_type>(op) || std::holds_alternative<char>(op);
}

struct generator {
    using finalizer_func = std::function<void(const gen_destination&, const gen_operand&)>;

    std::string_view filename;
    std::unique_ptr<emitter> em;
    std::vector<gen_register> arg_registers;
    std::vector<gen_register> temp_registers;
    std::vector<func_data> funcdata;
    std::stack<gen_operand> opstack;
    std::int32_t current_temp_regs_offset = 0;
    type_system* ts;
    int used_temp_registers = 0;
    int used_temp_locals = 0;
    int temp_locals_base = 0;

    // points to the current function being generated
    ir_func* fn;
    func_data* fndata;

    explicit generator(std::unique_ptr<emitter>&& em, type_system* ts, std::string_view fn) {
        this->em = std::move(em);
        this->ts = ts;
        this->filename = fn;
        arg_registers = em->get_argument_registers();
        temp_registers = em->get_temp_registers();
    }

    // Section: helpers

    void push(const gen_operand& op) {
        opstack.push(op);
    }

    gen_operand pop() {
        auto res = opstack.top();
        opstack.pop();
        return res;
    }

    std::pair<std::int32_t, bool> find_max_call_arg_size(const ir_func& func) {
        std::int32_t sz = 0;
        bool calls_ever_made = false;
        for (const auto& inst : func.instrs) {
            if (inst.op == ir_call) {
                std::int32_t args_size = 0;

                std::size_t i = 0;
                for (auto& arg : inst.operands) {
                    if (i++ == 0) continue;

                    auto optype = get_ir_operand_type(arg);
                    auto& tdef = optype.get();
                    std::int32_t asize = 8;// std::min(8, std::int32_t(tdef.size));
                    args_size += asize;
                    args_size = align(args_size, 8);//align(args_size, std::int32_t(tdef.alignment));
                }

                sz = std::max(sz, args_size);
                calls_ever_made = true;
            }
            else if (inst.op == ir_copy) {
                // ir_copy uses rcx as well
                calls_ever_made = true;
            }
        }
        return std::make_pair(sz, calls_ever_made);
    }

    std::tuple<std::int32_t, std::int32_t, bool> get_func_stack_frame_size(ir_func& func) {
        auto [call_arg_size, calls_ever_made] = find_max_call_arg_size(func);

        if (func.calls_extern_c) {
            call_arg_size = std::max(call_arg_size, 32);
        }

        // NOTE: on windows, it seems arguments are always 8 bytes aligned, no matter their sizes

        std::int32_t own_arg_size = 0;
        std::int32_t local_size = 0;
        int ai = 0;
        for (auto& arg : func.args) {
            auto& tdef = arg.type.get();
            
            own_arg_size += 8;// std::int32_t(tdef.size);
            own_arg_size = align(own_arg_size, 8);// align(own_arg_size, std::int32_t(tdef.alignment));
            funcdata[func.index].arg_data[ai].frame_offset = own_arg_size;
            ai++;
        }

        int li = 0;
        for (auto& local : func.locals) {
            auto& tdef = local.type.get();
            //funcdata[func.index].local_data[li].frame_offset = -align(local_size + 8, std::int32_t(tdef.alignment)); // offset from rbp + space for pushed rbp
            local_size += std::int32_t(tdef.size);
            local_size = align(local_size, std::int32_t(tdef.alignment));
            funcdata[func.index].local_data[li].frame_offset = -local_size;
            li++;
        }

        local_size = align(local_size, 16);
        call_arg_size = align(call_arg_size, 16);
        return std::make_tuple(local_size, call_arg_size, calls_ever_made);
    }

    gen_destination local_var_destination(std::int32_t frame_offset) {
        bool is_negative = (frame_offset < 0);
        std::vector<gen_offset_expr> expr{ rbp };
        if (is_negative) {
            expr.push_back('-');
            expr.push_back(-int_type(frame_offset));
        }
        else {
            expr.push_back('+');
            expr.push_back(int_type(frame_offset));
        }
        return gen_offset{ 0, expr };
    }

    std::optional<gen_register> use_temp_register() {
        if (used_temp_registers >= temp_registers.size()) {
            return {};
        }
        
        auto next_reg = temp_registers[used_temp_registers];
        used_temp_registers++;
        fndata->used_temp_registers.insert(next_reg);
        return next_reg;
    }

    int use_temp_local(type_id tid) {
        int available = fn->locals.size() - temp_locals_base - used_temp_locals;
        if (available == 0) {
            used_temp_locals++;
            fn->locals.push_back(ir_local_data{ "codegentemp", tid });
            return fn->locals.size() - 1;
        }
        else {
            int idx = temp_locals_base + used_temp_locals;
            used_temp_locals++;
            return idx;
        }
    }

    instr_dest use_temp_destination(type_id tid) {
        auto reg = use_temp_register();
        if (reg) {
            return *reg;
        }
        return use_temp_local(tid);
    }

    void free_temp_destination() {
        if (used_temp_locals) {
            used_temp_locals--;
        }
        else {
            used_temp_registers--;
        }
    }

    std::string get_string_label(int idx) {
        return "$cbstr" + std::to_string(idx);
    }

    void determine_instrs_destination() {
        temp_locals_base = fn->locals.size();
        used_temp_locals = 0;
        used_temp_registers = 0;

        for (std::size_t i = 0; i < fn->instrs.size(); i++) {
            auto& instr = fn->instrs[i];

            ir_instr* next_instr = nullptr;
            if (i < fn->instrs.size() - 1) {
                next_instr = &fn->instrs[i + 1];
            }

            int mysc = instr_opstack_consumption(instr);
            for (int sc = 1; sc < mysc; sc++) { // begins at one to skip rax
                free_temp_destination();
            }

            fndata->instr_data[instr.index].dest = reg_result;
            if (next_instr) {
                if (instr_pushes_to_stack(instr) && instr_opstack_consumption(*next_instr) == 0) {
                    if (instr.index == 19 && instr.op == ir_sub) {
                        printf("asd\n");
                    }
                    fndata->instr_data[instr.index].dest = use_temp_destination(instr.result_type);
                }
            }
        }
    }

    // Section: pre analysis

    void pre_analysis(ir_program& prog) {
    }

    // Section: generators

    void generate_program(ir_program& prog) {
        funcdata.resize(prog.funcs.size());

        for (const auto& func : prog.funcs) {
            if (func.is_extern) {
                em->add_extern_func_decl(func.name.c_str());
            }
            else {
                em->add_global_func_decl(func.name.c_str());
            }
        }
        em->begin_data_segment();

        int si = 0;
        for (const auto& str : prog.strings) {
            em->add_string_data(get_string_label(si), str);
            si++;
        }

        em->begin_code_segment();
        
        for (auto& func : prog.funcs) {
            if (func.is_extern) continue;

            generate_func_code(func);
        }

        em->end();
    }

    // Section: code generators

    void generate_func_code(ir_func& func) {
        auto& fdata = funcdata[func.index];
        fdata.end_label = func.name + "$end";
        fdata.instr_data.resize(func.instrs.size());
        fdata.arg_data.resize(func.args.size());
        fdata.local_data.resize(func.locals.size());

        this->fn = &func;
        this->fndata = &fdata;

        determine_instrs_destination();
        fdata.local_data.resize(func.locals.size()); // resize for any created temps

        em->begin_func(func.name.c_str());
        em->emitln(" ;%s", func.demangled_name.c_str());

        auto [local_size, call_arg_size, calls_ever_made] = get_func_stack_frame_size(func);
        std::int32_t stack_size = local_size + call_arg_size;

        std::int32_t temp_regs_offset = fdata.used_temp_registers.size() * 8;
        current_temp_regs_offset = temp_regs_offset;

        bool needs_rbp = (!(stack_size == 0 && func.args.empty()));

        std::size_t num_pushes = fdata.used_temp_registers.size();
        if (needs_rbp) {
            num_pushes += 1;
        }

        // +8 to re-align the stack because of the CALL made to us
        stack_size += (num_pushes % 2 == 0) ? 8 : 0;

        if (!func.args.empty()) {
            if (calls_ever_made) {
                std::size_t max_reg_args = std::min(arg_registers.size(), func.args.size());
                for (std::size_t i = max_reg_args; i > 0; i--) {
                    auto& arg = func.args[i - 1];
                    auto frame_offset = fdata.arg_data[i - 1].frame_offset;

                    auto src = adjust_for_type(gen_register{ arg_registers[i - 1] }, arg.type);
                    auto dest = adjust_for_type(gen_offset{ 0, {rsp, '+', int_type(frame_offset)} }, arg.type);
                    em->mov(dest, toop(src));
                }
            }
            else {
                std::size_t max_reg_args = std::min(arg_registers.size(), func.args.size());
                for (std::size_t i = 0; i < max_reg_args; i++) {
                    fndata->arg_data[i].reg = arg_registers[i];
                }
            }

            for (auto& arg : fndata->arg_data) {
                arg.frame_offset += temp_regs_offset; // space for the rbp about to be pushed + temp registers
                if (needs_rbp) {
                    arg.frame_offset += 8;
                }
            }
        }

        if (needs_rbp) { em->push(rbp); }

        std::vector<gen_register> temp_regs;
        for (const auto& reg : fdata.used_temp_registers) {
            em->push(reg);
            temp_regs.push_back(reg);
        }

        if (needs_rbp) { em->mov(rbp, rsp); }
        if (stack_size > 0) { em->sub(rsp, (int_type)(stack_size)); }

        em->emitln(" ;prolog end\n");

        for (auto& instr : func.instrs) {
            generate_ir_instr(instr);
        }

        em->label(fdata.end_label.c_str());

        if (stack_size > 0) { em->add(rsp, (int_type)(stack_size)); }
        for (std::size_t i = temp_regs.size(); i > 0; i--) {
            em->pop(temp_regs[i - 1]);
        }
        if (needs_rbp) { em->pop(rbp); }

        em->ret();
        em->end_func();
        em->emitln("\n");

        this->fn = nullptr;
        this->fndata = nullptr;
    }

    void generate_ir_instr(ir_instr& instr) {
        auto& idata = fndata->instr_data[instr.index];

        switch (instr.op) {
        case ir_asm: {
            em->emitln("%s", std::get<std::string>(instr.operands[0]).c_str());
            break;
        }
        case ir_make_label: {
            auto label = std::get<ir_label>(instr.operands.front());
            em->label(label.name.c_str());
            break;
        }
        case ir_jmp: {
            auto label = std::get<ir_label>(instr.operands.front());
            em->jmp(label.name.c_str());
            break;
        }
        case ir_jmp_eq: {
            emit_cmp_jmp(instr, "je");
            break;
        }
        case ir_jmp_neq: {
            emit_cmp_jmp(instr, "jne");
            break;
        }
        case ir_jmp_lt: {
            emit_cmp_jmp(instr, "jl");
            break;
        }
        case ir_jmp_lte: {
            emit_cmp_jmp(instr, "jle");
            break;
        }
        case ir_jmp_gt: {
            emit_cmp_jmp(instr, "jg");
            break;
        }
        case ir_jmp_gte: {
            emit_cmp_jmp(instr, "jge");
            break;
        }
        case ir_call: {
            bool is_fptr = !std::holds_alternative<ir_label>(instr.operands[0]);

            std::size_t num_args = instr.operands.size() - 1;
            if (num_args > arg_registers.size()) {
                for (std::size_t i = num_args; i > arg_registers.size(); i--) {
                    int_type offs = (i - 1) * 8;
                    auto [op, optype] = transform_ir_operand(instr.operands[i]);
                    auto dest = gen_offset{ optype.get().size, { rsp, '+', offs } };
                    move(dest, optype, op, optype);
                }
            }

            std::size_t max_reg_args = std::min(arg_registers.size(), num_args);
            for (std::size_t i = max_reg_args; i > 0; i--) {
                auto [op, optype] = transform_ir_operand(instr.operands[i]);
                auto dest = adjust_for_type(arg_registers[i - 1], optype);
                move(dest, optype, op, optype);
            }

            if (!is_fptr) {
                ir_label funclabel = std::get<ir_label>(instr.operands[0]);
                em->call(funclabel.name.c_str());
            }
            else {
                auto [f, ftype] = transform_ir_operand(instr.operands[0]);
                if (!is_reg(f)) {
                    auto arax = adjust_for_type(reg_result, ftype);
                    move(arax, ftype, f, ftype);
                    f = toop(arax);
                }
                em->calldest(todest(f));
            }

            if (instr.result_type != ts->void_type) {
                auto dest = adjust_for_type(instr_dest_to_gen_dest(idata.dest), instr.result_type);
                auto arax = adjust_for_type(reg_result, instr.result_type);
                if (!(dest == arax)) {
                    move(dest, instr.result_type, toop(arax), instr.result_type);
                }
                push(toop(dest));
            }
            break;
        }
        case ir_return: {
            auto [a, atype] = transform_ir_operand(instr.operands[0]);
            auto arax = adjust_for_type(reg_result, instr.result_type);

            if (std::holds_alternative<gen_register>(a)) {
                if (!(todest(a) == arax)) {
                    move(arax, instr.result_type, a, atype);
                }
            }
            else {
                move(arax, instr.result_type, a, atype);
            }

            if (instr.index < fn->instrs.size() - 1) {
                em->jmp(fndata->end_label.c_str());
            }
            break;
        }
        case ir_index: {
            auto [b, btype] = transform_ir_operand(instr.operands[1]);
            auto [a, atype] = transform_ir_operand(instr.operands[0]);
            auto dest = instr_dest_to_gen_dest(idata.dest);

            move(reg_intermediate, ts->raw_ptr_type, b, btype);

            std::size_t elem_size = instr.result_type.get().size;
            std::size_t esize_offs = elem_size > 8 ? 1 : elem_size;

            if (elem_size > 8) {
                em->imul(reg_intermediate, int_type(elem_size));
            }

            if (is_reg(a)) {
                auto offset_expr = gen_offset{ elem_size, std::vector<gen_offset_expr>{
                    std::get<gen_register>(a), '+', reg_intermediate, '*', int_type(esize_offs)
                } };
                load_address(dest, offset_expr, ts->raw_ptr_type);
            }
            else if (is_mem(a)) {
                auto& offs = std::get<gen_offset>(a);
                offs.expr.push_back('+');
                offs.expr.push_back(reg_intermediate);
                offs.expr.push_back('*');
                offs.expr.push_back(int_type(esize_offs));
                load_address(dest, todest(a), ts->raw_ptr_type);
            }

            gen_operand result;
            if (is_reg(dest)) {
                result = gen_offset{ elem_size, std::vector<gen_offset_expr>{
                    std::get<gen_register>(dest), '+', int_type(0)
                } };
            }
            else {
                assert(!"ir_index: dest as memory not handled");
            }

            push(result);
            break;
        }
        case ir_deref: {
            auto [a, atype] = transform_ir_operand(instr.operands[0]);
            auto dest = adjust_for_type(instr_dest_to_gen_dest(idata.dest), ts->uintptr_type);

            gen_destination op;
            bool needs_move = true;
            bool rax_check = false;
            if (is_reg(dest)) {
                move(dest, ts->uintptr_type, a, ts->uintptr_type);
                op = gen_offset{ instr.result_type.get().size, { std::get<gen_register>(dest) } };
            }
            else if (is_mem(dest)) {
                move(reg_intermediate, ts->uintptr_type, a, ts->uintptr_type);
                move(dest, ts->uintptr_type, reg_intermediate, ts->uintptr_type);
                op = dest;
            }
            push(toop(op));
            break;
        }
        case ir_load_addr: {
            auto [a, atype] = transform_ir_operand(instr.operands[0]);
            auto dest = instr_dest_to_gen_dest(idata.dest);
            load_address(dest, todest(a), atype);
            push(toop(dest));
            break;
        }
        case ir_load: {
            auto [b, btype] = transform_ir_operand(instr.operands[1]);
            auto [a, atype] = transform_ir_operand(instr.operands[0]);

            if (is_mem(b)) {
                move(adjust_for_type(reg_intermediate, atype), atype, b, btype);
                b = toop(adjust_for_type(reg_intermediate, atype));
                btype = atype;
            }
            else if (!is_reg(b)) {
                move(adjust_for_type(reg_intermediate, btype), btype, b, btype);
                b = toop(adjust_for_type(reg_intermediate, atype));
                btype = atype;
            }
            move(todest(a), atype, b, btype);
            break;
        }
        case ir_copy: {
            auto [c, ctype] = transform_ir_operand(instr.operands[2]);
            auto [b, btype] = transform_ir_operand(instr.operands[1]);
            auto [a, atype] = transform_ir_operand(instr.operands[0]);

            em->push(rdi);
            em->push(rsi);

            if (is_mem(a)) {
                load_address(rdi, todest(a), atype);
            }
            else {
                move(rdi, ts->raw_ptr_type, a, atype);
            }

            if (is_mem(b)) {
                load_address(rsi, todest(b), btype);
            }
            else {
                move(rsi, ts->raw_ptr_type, b, btype);
            }

            move(rcx, ts->uintptr_type, c, ctype);

            em->emitln(" rep movsb");

            em->pop(rsi);
            em->pop(rdi);
            break;
        }
        case ir_add:
        case ir_sub:
        case ir_mul: {
            auto [b, btype] = transform_ir_operand(instr.operands[1]);
            auto [a, atype] = transform_ir_operand(instr.operands[0]);
            auto dest = adjust_for_type(instr_dest_to_gen_dest(idata.dest), instr.result_type);

            if (!is_reg(a)) {
                move(adjust_for_type(reg_intermediate, instr.result_type), instr.result_type, a, atype);
                a = toop(adjust_for_type(reg_intermediate, instr.result_type));
            }

            emit_binary_math_op(instr.op, todest(a), b);

            if (!(dest == todest(a))) {
                move(dest, instr.result_type, a, atype);
            }

            push(toop(dest));
            break;
        }
        case ir_cast: {
            auto [a, atype] = transform_ir_operand(instr.operands[0]);
            auto dest = adjust_for_type(instr_dest_to_gen_dest(idata.dest), instr.result_type);

            if (is_mem(a) && is_mem(dest)) {
                move(adjust_for_type(reg_intermediate, instr.result_type), instr.result_type, a, atype);
                a = toop(adjust_for_type(reg_intermediate, instr.result_type));
            }

            move(dest, instr.result_type, a, atype);

            push(toop(dest));
            break;
        }
        case ir_noop: {
            for (std::size_t i = 0; i < instr.operands.size(); i++) {
                (void)transform_ir_operand(instr.operands[i]);
            }
            break;
        }
        }

        if (instr.op != ir_asm) {
            em->emitln(" ;%s", sprint_ir_instr(instr).c_str());
        }
    }

    void emit_cmp_jmp(const ir_instr& instr, const char* j) {
        auto label = std::get<ir_label>(instr.operands.back());
        auto [b, btype] = transform_ir_operand(instr.operands[1]);
        auto [a, atype] = transform_ir_operand(instr.operands[0]);
        if (!is_reg(a)) {
            move(adjust_for_type(reg_intermediate, atype), atype, a, atype);
            a = toop(adjust_for_type(reg_intermediate, atype));
        }
        em->cmp(a, b);
        em->emitln(" %s %s", j, label.name.c_str());
    }

    void emit_binary_math_op(ir_op op, gen_destination a, gen_operand b) {
        switch (op) {
        case ir_add:
            em->add(a, b);
            break;
        case ir_sub:
            em->sub(a, b);
            break;
        case ir_mul:
            em->imul(a, b);
            break;
        }
    }

    std::pair<gen_operand, type_id> transform_ir_field_ref(const ir_field* arg) {
        if (std::holds_alternative<ir_local>(arg->ref)) {
            int li = std::get<ir_local>(arg->ref).index;
            auto type = std::get<ir_local>(arg->ref).type;
            auto& field = type.get().structure.fields[arg->field_index];

            auto dest = get_local_destination(li, field.type);
            auto& offs = std::get<gen_offset>(dest);
            offs.op_size = field.type.get().size;
            offs.expr[2] = std::get<int_type>(offs.expr[2]) - int_type(field.offset);
            return std::make_pair(toop(dest), field.type);
        }
        else if (std::holds_alternative<ir_arg>(arg->ref)) {
            assert(!"field from ir_arg not handled!");
            
            int ai = std::get<ir_arg>(arg->ref).index;
            auto type = std::get<ir_arg>(arg->ref).type;
            auto& field = type.get().structure.fields[arg->field_index];

            auto dest = get_arg_destination(ai, field.type);
            auto& offs = std::get<gen_offset>(dest);
            offs.op_size = field.type.get().size;
            offs.expr[2] = std::get<int_type>(offs.expr[2]) - int_type(field.offset);
            return std::make_pair(toop(dest), field.type);
        }
        else if (std::holds_alternative<ir_stack>(arg->ref)) {
            auto op = pop();
            auto type = std::get<ir_stack>(arg->ref).type;
            auto& field = type.get().structure.fields[arg->field_index];

            if (is_reg(op)) {
                std::vector<gen_offset_expr> expr{ std::get<gen_register>(op), '+', int_type(field.offset) };
                auto dest = gen_offset{ field.type.get().size, expr };
                return std::make_pair(toop(dest), field.type);
            }
            else if (std::holds_alternative<gen_offset>(op)) {
                auto& offs = std::get<gen_offset>(op);
                offs.op_size = field.type.get().size;
                offs.expr.push_back('+'); offs.expr.push_back(int_type(field.offset));
                return std::make_pair(op, field.type);
            }
        }
        else if (std::holds_alternative<std::shared_ptr<ir_field>>(arg->ref)) {
            auto [op, type] = transform_ir_field_ref(std::get<std::shared_ptr<ir_field>>(arg->ref).get());
            auto& field = type.get().structure.fields[arg->field_index];
            auto& offs = std::get<gen_offset>(op);
            offs.op_size = field.type.get().size;
            offs.expr[2] = std::get<int_type>(offs.expr[2]) - int_type(field.offset);
            return std::make_pair(op, field.type);
        }
    }

    std::pair<gen_operand, type_id> transform_ir_operand(const ir_operand& opr) {
        if (auto arg = std::get_if<ir_field>(&opr); arg) {
            return transform_ir_field_ref(arg);
        }
        else if (auto arg = std::get_if<ir_arg>(&opr); arg) {
            return std::make_pair(
                toop(get_arg_destination(arg->index, arg->type)),
                arg->type
            );
        }
        else if (auto arg = std::get_if<ir_local>(&opr); arg) {
            return std::make_pair(
                toop(get_local_destination(arg->index, arg->type)),
                arg->type
            );
        }
        else if (auto arg = std::get_if<ir_stack>(&opr); arg) {
            auto cgop = pop();
            return std::make_pair(cgop, arg->type);
        }
        else if (auto arg = std::get_if<ir_funclabel>(&opr); arg) {
            return std::make_pair(gen_data_offset{ arg->name }, arg->type);
        }
        else if (auto arg = std::get_if<ir_string>(&opr); arg) {
            return std::make_pair(gen_data_offset{ get_string_label(arg->index) }, ts->raw_string_type);
        }
        else if (auto arg = std::get_if<ir_int>(&opr); arg) {
            return std::make_pair(arg->val, arg->type);
        }
        else if (auto arg = std::get_if<ir_float>(&opr); arg) {
            // TODO:
        }
        else if (auto arg = std::get_if<char>(&opr); arg) {
            return std::make_pair(*arg, ts->raw_string_type.get().elem_type);
        }
        else {
            assert(!"transform_ir_operand unhandled");
        }
    }

    type_id get_ir_field_type(const ir_field* arg) {
        if (std::holds_alternative<ir_local>(arg->ref)) {
            int li = std::get<ir_local>(arg->ref).index;
            auto type = std::get<ir_local>(arg->ref).type;
            auto& field = type.get().structure.fields[arg->field_index];
            return field.type;
        }
        else if (std::holds_alternative<ir_arg>(arg->ref)) {
            int ai = std::get<ir_arg>(arg->ref).index;
            auto type = std::get<ir_arg>(arg->ref).type;
            auto& field = type.get().structure.fields[arg->field_index];
            return field.type;
        }
        else if (std::holds_alternative<ir_stack>(arg->ref)) {
            auto type = std::get<ir_stack>(arg->ref).type;
            auto& field = type.get().structure.fields[arg->field_index];
            return field.type;
        }
        else if (std::holds_alternative<std::shared_ptr<ir_field>>(arg->ref)) {
            auto type = get_ir_field_type(std::get<std::shared_ptr<ir_field>>(arg->ref).get());
            auto& field = type.get().structure.fields[arg->field_index];
            return field.type;
        }
    }

    type_id get_ir_operand_type(const ir_operand& opr) {
        if (auto arg = std::get_if<ir_field>(&opr); arg) {
            return get_ir_field_type(arg);
        }
        else if (auto arg = std::get_if<ir_arg>(&opr); arg) {
            return arg->type;
        }
        else if (auto arg = std::get_if<ir_local>(&opr); arg) {
            return arg->type;
        }
        else if (auto arg = std::get_if<ir_stack>(&opr); arg) {            
            return arg->type;
        }
        else if (auto arg = std::get_if<ir_funclabel>(&opr); arg) {
            return arg->type;
        }
        else if (auto arg = std::get_if<ir_string>(&opr); arg) {
            return ts->raw_string_type;
        }
        else if (auto arg = std::get_if<ir_int>(&opr); arg) {
            return arg->type;
        }
        else if (auto arg = std::get_if<ir_float>(&opr); arg) {
            // TODO:
        }
        else if (auto arg = std::get_if<char>(&opr); arg) {
            return ts->raw_string_type.get().elem_type;
        }
        else {
            assert(!"transform_ir_operand unhandled");
        }
    }

    gen_destination get_arg_destination(int index, type_id ttid) {
        auto& arg = fn->args[index];
        type_id tid = ttid.valid() ? ttid : arg.type;
        if (fndata->arg_data[index].reg) {
            return adjust_for_type(*fndata->arg_data[index].reg, tid);
        }
        return adjust_for_type(local_var_destination(fndata->arg_data[index].frame_offset), tid);
    }

    gen_destination get_local_destination(int index, type_id ttid) {
        auto& l = fn->locals[index];
        type_id tid = ttid.valid() ? ttid : l.type;
        return adjust_for_type(local_var_destination(fndata->local_data[index].frame_offset), tid);
    }

    gen_destination instr_dest_to_gen_dest(const instr_dest& id) {
        if (std::holds_alternative<gen_register>(id)) {
            return std::get<gen_register>(id);
        }
        return get_local_destination(std::get<local_index>(id), {});
    }

    void move(const gen_destination& dest, type_id dest_tid, const gen_operand& op, type_id tid) {
        if (std::holds_alternative<gen_offset>(dest) && std::holds_alternative<gen_offset>(op)) {
            auto areg = adjust_for_type(reg_intermediate, tid);
            move(areg, tid, op, tid);
            move(dest, dest_tid, toop(areg), tid);
            return;
        }

        if (dest_tid.get().size > tid.get().size && !is_lit(op)) {
            if (tid.get().is_signed) {
                em->movsx(dest, op);
            }
            else {
                em->movzx(dest, op);
            }
        }
        else if (dest_tid.get().size < tid.get().size && !is_lit(op)) {
            em->mov(adjust_for_type(reg_intermediate, tid), op);
            em->mov(dest, toop(adjust_for_type(reg_intermediate, dest_tid)));
            //em->mov(dest, op);
        }
        else {
            em->mov(dest, op);
        }
    }

    void load_address(const gen_destination& dest, const gen_destination& op, type_id tid) {
        if (std::holds_alternative<gen_register>(dest)) {
            em->lea(dest, op);
        }
        else {
            auto arax = adjust_for_type(reg_result, tid);
            em->lea(arax, op);
            em->mov(dest, toop(arax));
        }
    }
};

void codegen(ir_program& prog, type_system* ts, std::string_view filename) {
    generator gen{std::make_unique<emitter>(filename), ts, filename};
    gen.pre_analysis(prog);
    gen.generate_program(prog);
}

}