#include <fstream>
#include <cstdarg>
#include <cassert>
#include <variant>
#include "codegen.hh"
#include "codegen_x64.hh"
#include "codegen_x64_windows_nasm.hh"
#include "codegen_x64_linux_gas.hh"
#include "common.hh"
#include "type_system.hh"
#include "ast.hh"
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
    std::vector<instr_data> instrdata;
    std::set<gen_register> used_temp_registers;
    int call_arg_size = 0;
};

constexpr gen_register reg_result = rax;
constexpr gen_register reg_intermediate = r10;
constexpr gen_register reg_intermediate_xmm = xmm7;

const char* register_names[] = {
    "invalid",

    "xmm0",
    "xmm1",
    "xmm7",
    "rip",

    "rax",
    "rbx",
    "rcx",
    "rdx",
    "rdi",
    "rsi",
    "rbp",
    "rsp",
    "r8",
    "r9",
    "r10",
    "r11",
    "r12",
    "r13",
    "r14",
    "r15",
    "eax",
    "ebx",
    "ecx",
    "edx",
    "edi",
    "esi",
    "ebp",
    "esp",
    "r8d",
    "r9d",
    "r10d",
    "r11d",
    "r12d",
    "r13d",
    "r14d",
    "r15d",
    "ax",
    "bx",
    "cx",
    "dx",
    "di",
    "si",
    "bp",
    "sp",
    "r8",
    "r9w",
    "r10w",
    "r11w",
    "r12w",
    "r13w",
    "r14w",
    "r15w",
    "al",
    "bl",
    "cl",
    "dl",
    "dil",
    "sil",
    "bpl",
    "spl",
    "r8b",
    "r9b",
    "r10b",
    "r11b",
    "r12b",
    "r13b",
    "r14b",
    "r15b",
};

std::size_t get_size(const gen_destination& v) {
    return std::visit(overload{
        [](gen_register r) -> std::size_t {
            if (r >= al) return 1;
            if (r >= ax) return 2;
            if (r >= eax) return 4;
            if (r >= rax) return 8;
            return 0;
        },
        [](gen_data_offset r) -> std::size_t {
            return sizeof(void*);
        },
        [](gen_addr r) -> std::size_t {
            return r.op_size;
        }
    }, v);
}

std::size_t get_size(const gen_operand& v) {
    return std::visit(overload{
        [](gen_register r) -> std::size_t {
            if (r >= al) return 1;
            if (r >= ax) return 2;
            if (r >= eax) return 4;
            if (r >= rax) return 8;
            return 0;
        },
        [](gen_data_offset r) -> std::size_t {
            return sizeof(void*);
        },
        [](gen_addr r) -> std::size_t {
            return r.op_size;
        },
        [](comp_int_type v) -> std::size_t {
            return 4;
        },
        [](char v) -> std::size_t {
            return 1;
        }
        }, v);
}

gen_destination adjust_for_type(gen_destination dest, type_id tid) {
    auto tdef = tid.scope->tdefs[tid.type_index];
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
    else if (std::holds_alternative<gen_addr>(dest)) {
        auto offs = std::get<gen_addr>(dest);
        offs.op_size = tdef->size;
        return offs;
    }
    return dest;
}

gen_operand toop(gen_destination dest) {
    if (std::holds_alternative<gen_register>(dest)) {
        return std::get<gen_register>(dest);
    }
    if (std::holds_alternative<gen_addr>(dest)) {
        return std::get<gen_addr>(dest);
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
    if (std::holds_alternative<gen_addr>(op)) {
        return std::get<gen_addr>(op);
    }
    if (std::holds_alternative<gen_data_offset>(op)) {
        return std::get<gen_data_offset>(op);
    }
    assert(!"todest not handled!");
}

template <typename T> bool is_mem(const T& op) {
    return std::holds_alternative<gen_addr>(op) || std::holds_alternative<gen_data_offset>(op);
}

template <typename T> bool is_reg(const T& op) {
    return std::holds_alternative<gen_register>(op);
}

template <typename T> bool is_lit(const T& op) {
    return std::holds_alternative<comp_int_type>(op) || std::holds_alternative<char>(op);
}

struct tup {
    size_t a;
    bool b;
};

struct generator {
    using finalizer_func = std::function<void(const gen_destination&, const gen_operand&)>;

    std::string_view filename;
    std::unique_ptr<codegen_x64_emitter> em;
    std::vector<func_data> funcdata;
    std::vector<gen_register> register_temp;
    std::vector<gen_register> register_args;
    std::stack<gen_operand> opstack;
    std::int32_t current_temp_regs_offset = 0;
    type_system* ts;
    int used_temp_registers = 0;
    int used_temp_locals = 0;
    int temp_locals_base = 0;
    gen_addr cmp16selector_addr = {};

    // points to the current function being generated
    ir_func* fn = nullptr;
    func_data* fndata = nullptr;

    explicit generator(std::unique_ptr<codegen_x64_emitter>&& em, type_system* ts, std::string_view fn) {
        this->ts = ts;
        this->filename = fn;
        this->register_args = em->args_registers();
        this->register_temp = em->temp_registers();
        this->em = std::move(em);

        cmp16selector_addr.base = invalid;
        cmp16selector_addr.offset = gen_data_offset{ this->em->special_label("cmp16selector") };
        cmp16selector_addr.op_size = 16;
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

    bool is_const_reg(gen_operand op) {
        if (std::holds_alternative<gen_register>(op)) {
            auto reg = std::get<gen_register>(op);
            for (const auto& areg : this->register_args) {
                if (areg == reg) {
                    return true;
                }
            }
        }
        return false;
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
            else if (inst.op == ir_copy || inst.op == ir_store) {
                // ir_copy uses rcx as well
                calls_ever_made = true;
            }
            else if (inst.op == ir_shl || inst.op == ir_shr) {
                // shifting uses rcx
                calls_ever_made = true;
            }
            else if (inst.op == ir_div) {
                // ir_div uses rdx
                if (func.args.size() >= 2) {
                    calls_ever_made = true;
                }
            }
        }
        return std::make_pair(sz, calls_ever_made);
    }

    std::tuple<std::int32_t, std::int32_t, bool> get_func_stack_frame_size(ir_func& func) {
        auto [call_arg_size, calls_ever_made] = find_max_call_arg_size(func);

        if (func.calls_extern_c) {
#ifdef _WIN32
            call_arg_size = std::max(call_arg_size, 32);
#else
            call_arg_size = std::max(call_arg_size, 48);
#endif
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
            if (tdef.size > 8) {
                local_size = align(local_size, 16);
            }
            else {
                local_size = align(local_size, std::int32_t(tdef.alignment));
            }

            funcdata[func.index].local_data[li].frame_offset = -local_size;
            li++;
        }

        local_size = align(local_size, 16);
        call_arg_size = align(call_arg_size, 16);
        return std::make_tuple(local_size, call_arg_size, calls_ever_made);
    }

    gen_destination local_var_destination(std::int32_t frame_offset) {
        gen_addr expr{ };
        expr.base = rbp;
        expr.offset = comp_int_type(frame_offset);
        return expr;
    }

    std::optional<gen_register> use_temp_register() {
        if (used_temp_registers >= register_temp.size()) {
            return {};
        }
        
        auto next_reg = register_temp[used_temp_registers];
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
        return em->special_label("cbstr" + std::to_string(idx));
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

            fndata->instrdata[instr.index].dest = reg_result;
            if (next_instr) {
                if (instr_pushes_to_stack(instr) && instr_opstack_consumption(*next_instr) == 0) {
                    fndata->instrdata[instr.index].dest = use_temp_destination(instr.result_type);
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
            if (func->is_extern) {
                em->add_extern_func_decl(func->name.c_str());
            }
            else {
                em->add_global_func_decl(func->name.c_str());
                if (func->visibility == decl_visibility::public_) {
                    em->add_export_func_decl(func->name.c_str());
                }
            }
        }

        em->begin_data_segment();

        auto bytes = std::vector<std::uint8_t>{ 0, 1, 8, 9, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80 };
        em->add_global_bytes(em->special_label("cmp16selector"), bytes);

        for (const auto& g : prog.globals) {
            generate_global_var(g);
        }

        em->begin_readonly_data_segment();

        int si = 0;
        for (const auto& str : prog.strings) {
            em->add_string_data(get_string_label(si), str);
            si++;
        }

        if (prog.errors.size() > 0) { em->begin_error_segment(); }
        for (const auto& e : prog.errors) {
            generate_error(e);
        }

        em->begin_code_segment();
        
        for (auto& func : prog.funcs) {
            if (func->is_extern) continue;

            generate_func_code(*func);
        }

        em->end();
    }

    // Section: code generators

    void generate_global_var(const ir_global_data& gd) {
        if (gd.linkage != func_linkage::local_carbon) {
            em->add_extern_var_decl(gd.name.c_str());
            return;
        }

        if (gd.type.get().kind == type_kind::integral) {
            comp_int_type value = 0;
            if (gd.value && std::holds_alternative<ir_int>(*gd.value)) {
                auto& integer = std::get<ir_int>(*gd.value);
                value = integer.val;
            }

            if (value == 0) {
                em->add_global(gd.name, gd.type, gd.visibility);
            }
            else if (gd.type.get().size == 2) {
                em->add_global_int16(gd.name, (int16_t)value);
            }
            else if (gd.type.get().size == 4) {
                em->add_global_int32(gd.name, (int32_t)value);
            }
            else if (gd.type.get().size == 8) {
                em->add_global_int64(gd.name, (int64_t)value);
            }
        }
        else if (gd.type.get().kind == type_kind::ptr) {
            if (gd.value && std::holds_alternative<ir_int>(*gd.value)) {
                em->add_global(gd.name, ts->opaque_ptr_type, gd.visibility);
            }
            // TODO: handle globals pointing to other globals
        }
        else if (is_aggregate_type(gd.type)) {
            em->align(gd.type.get().alignment);
            em->label(gd.name.c_str());
            for (const auto& val : gd.aggregate_values) {
                if (val.first.get().size == 8) {
                    ir_int ival = std::get<ir_int>(val.second);
                    em->add_int64(ival.val);
                }
            }
        }
        else {
            assert(!"generate_global_var: type not handled");
        }
    }

    void generate_error(const ir_error_data& err) {
        em->align(16);
        em->add_int32(err.code);
        em->add_stringz(err.name);
    }

    void generate_func_code(ir_func& func) {
        auto& fdata = funcdata[func.index];
        fdata.end_label = "." + func.name + "$end";
        fdata.instrdata.resize(func.instrs.size());
        fdata.arg_data.resize(func.args.size());
        fdata.local_data.resize(func.locals.size());

        this->fn = &func;
        this->fndata = &fdata;

        determine_instrs_destination();
        fdata.local_data.resize(func.locals.size()); // resize for any created temps

        // std::cout << func.demangled_name << std::endl;

        em->begin_func(func.name.c_str());
        em->comment("%s", func.demangled_name.c_str());

        auto [local_size, call_arg_size, calls_ever_made] = get_func_stack_frame_size(func);
        std::int32_t stack_size = local_size + call_arg_size;

        std::int32_t temp_regs_offset = fdata.used_temp_registers.size() * 8;
        current_temp_regs_offset = temp_regs_offset;

        bool needs_rbp = (!(stack_size == 0 && func.args.empty()));

        std::size_t num_pushes = fdata.used_temp_registers.size();
        if (needs_rbp) {
            num_pushes += 1;
        }

        // +8 to re-align the stack because of the CALL made to us (see below why this is commented)
        // stack_size += (num_pushes % 2 == 0) ? 8 : 0;

        if (num_pushes % 2 == 0) {
            temp_regs_offset += 8;
        }

        if (!func.args.empty()) {
            if (calls_ever_made) {
                std::size_t max_reg_args = std::min(register_args.size(), func.args.size());
                for (std::size_t i = max_reg_args; i > 0; i--) {
                    auto& arg = func.args[i - 1];
                    auto frame_offset = fdata.arg_data[i - 1].frame_offset;

                    auto src = adjust_for_type(gen_register{ register_args[i - 1] }, arg.type);
                    auto dest = adjust_for_type(gen_addr{ 0, rsp, comp_int_type(frame_offset) }, arg.type);
                    em->mov(dest, toop(src));
                }
            }
            else {
                std::size_t max_reg_args = std::min(register_args.size(), func.args.size());
                for (std::size_t i = 0; i < max_reg_args; i++) {
                    fndata->arg_data[i].reg = register_args[i];
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

        // instead of adding +8 to the stack_size, subtract from %rsp so we can have %rbp aligned
        if (num_pushes % 2 == 0) { em->sub(rsp, comp_int_type(8)); }

        if (needs_rbp)           { em->mov(rbp, rsp); }
        if (stack_size > 0)      { em->sub(rsp, (comp_int_type)(stack_size)); }

        // now we add +8 to the stack_size so the epilogue is correct
        if (num_pushes % 2 == 0) { stack_size += 8; }

        em->comment("prolog end\n");

        for (auto& instr : func.instrs) {
            generate_ir_instr(instr);
        }

        em->label(fdata.end_label.c_str());

        if (stack_size > 0) { em->add(rsp, (comp_int_type)(stack_size)); }
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
        auto& idata = fndata->instrdata[instr.index];

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
        case ir_cmp_gt:
            emit_cmp_set(instr, idata, "g");
            break;
        case ir_cmp_lt:
            emit_cmp_set(instr, idata, "l");
            break;
        case ir_cmp_lteq:
            emit_cmp_set(instr, idata, "le");
            break;
        case ir_cmp_gteq:
            emit_cmp_set(instr, idata, "ge");
            break;
        case ir_cmp_eq:
            emit_cmp_set(instr, idata, "e");
            break;
        case ir_cmp_neq:
            emit_cmp_set(instr, idata, "ne");
            break;
        case ir_call: {
            bool is_fptr = !std::holds_alternative<ir_label>(instr.operands[0]);

            std::size_t num_args = instr.operands.size() - 1;
            if (num_args > register_args.size()) {
                for (std::size_t i = num_args; i > register_args.size(); i--) {
                    comp_int_type offs = (i - 1) * 8;
                    auto [op, optype] = transform_ir_operand(instr.operands[i]);
                    auto dest = gen_addr{ optype.get().size, rsp, offs };
                    move(dest, optype, op, optype);
                }
            }

            std::size_t max_reg_args = std::min(register_args.size(), num_args);
            for (std::size_t i = max_reg_args; i > 0; i--) {
                auto [op, optype] = transform_ir_operand(instr.operands[i]);
                auto dest = adjust_for_type(register_args[i - 1], optype);
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

            if (instr.result_type != ts->opaque_type) {
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

            if (instr.result_type != ts->opaque_type) {
                auto regres = adjust_for_type(reg_result, instr.result_type);

                if (std::holds_alternative<gen_register>(a)) {
                    if (!(todest(a) == regres)) {
                        move(regres, instr.result_type, a, atype);
                    }
                }
                else {
                    move(regres, instr.result_type, a, atype);
                }
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

            move(reg_intermediate, ts->int_type, b, btype);

            std::size_t elem_size = instr.result_type.get().size;
            std::size_t esize_offs = elem_size > 8 ? 1 : elem_size;

            if (is_mem(a)) {
                //move(reg_result, ts->opaque_ptr_type, toop(adjust_for_type(todest(a), ts->opaque_ptr_type)), ts->opaque_ptr_type);
            }

            if (elem_size > 8) {
                em->imul(reg_intermediate, comp_int_type(elem_size));
            }

            if (is_reg(a)) {
                auto expr = gen_addr{};
                expr.op_size = elem_size;
                expr.base = std::get<gen_register>(a);
                expr.index = reg_intermediate;
                expr.mult = comp_int_type(esize_offs);
                load_address(dest, expr, ts->opaque_ptr_type);
            }
            else if (is_mem(a)) {
                auto expr = gen_addr{};
                if (std::holds_alternative<gen_addr>(a)) {
                    auto org_expr = std::get<gen_addr>(a);
                    expr.base = org_expr.base;
                    expr.offset = org_expr.offset;
                }
                else {
                    auto org_expr = std::get<gen_data_offset>(a);
                    load_address(rax, org_expr, ts->opaque_ptr_type);
                    expr.base = rax;
                    expr.offset = 0;
                }
                expr.op_size = elem_size;
                expr.index = reg_intermediate;
                expr.mult = comp_int_type(esize_offs);
                load_address(dest, expr, ts->opaque_ptr_type);
            }

            gen_operand result;
            if (is_reg(dest)) {
                auto roffs = gen_addr{};
                roffs.op_size = elem_size;
                roffs.base = std::get<gen_register>(dest);

                result = roffs;
            }
            else {
                assert(!"ir_index: dest as memory not handled");
            }

            push(result);
            break;
        }
        case ir_deref: {
            auto [a, atype] = transform_ir_operand(instr.operands[0]);
            auto dest = adjust_for_type(instr_dest_to_gen_dest(idata.dest), ts->int_type);

            gen_destination op;
            bool needs_move = true;
            bool rax_check = false;
            if (is_reg(dest)) {
                move(dest, ts->int_type, a, ts->int_type);
                auto offs = gen_addr{};
                offs.op_size = instr.result_type.get().size;
                offs.base = std::get<gen_register>(dest);
                offs.offset = comp_int_type(0);
                op = offs;
            }
            else if (is_mem(dest)) {
                move(reg_intermediate, ts->int_type, a, ts->int_type);
                move(dest, ts->int_type, reg_intermediate, ts->int_type);
                op = dest;
            }
            push(toop(op));
            break;
        }
        case ir_load_addr: {
            auto [a, atype] = transform_ir_operand(instr.operands[0]);
            auto dest = adjust_for_type(instr_dest_to_gen_dest(idata.dest), instr.result_type);
            load_address(dest, todest(a), atype);
            push(toop(dest));
            break;
        }
        case ir_load:
        case ir_load_ptr: {
            auto [b, btype] = transform_ir_operand(instr.operands[1]);
            auto [a, atype] = transform_ir_operand(instr.operands[0]);
            if (is_mem(b)) {
                (instr.op == ir_load_ptr)
                    ? load_address(reg_intermediate, todest(b), btype)
                    : move(adjust_for_type(reg_intermediate, atype), atype, b, btype);

                b = toop(adjust_for_type(reg_intermediate, atype));
                btype = atype;
            }
            else if (!is_reg(b)) {
                (instr.op == ir_load_ptr)
                    ? load_address(reg_intermediate, todest(b), btype)
                    : move(adjust_for_type(reg_intermediate, btype), btype, b, btype);

                b = toop(adjust_for_type(reg_intermediate, atype));
                btype = atype;
            }
            move(todest(a), atype, b, btype);
            break;
        }
        case ir_store: {
            auto [d, dtype] = transform_ir_operand(instr.operands[3]);
            auto [c, ctype] = transform_ir_operand(instr.operands[2]);
            auto [b, btype] = transform_ir_operand(instr.operands[1]);
            auto [a, atype] = transform_ir_operand(instr.operands[0]);

            comp_int_type offs = std::get<comp_int_type>(c);
            comp_int_type sz = std::get<comp_int_type>(d);

            assert(is_mem(a) || !"ir_store requires a memory destination");

            gen_addr addr = std::get<gen_addr>(a);
            if (std::holds_alternative<comp_int_type>(addr.offset)) {
                addr.offset = std::get<comp_int_type>(addr.offset) + offs;
            }

            if (sz <= 128 && sz % 8 == 0) {
                if (btype.get().size != 8) {
                    em->xor_(reg_intermediate, reg_intermediate);
                }
                move(adjust_for_type(reg_intermediate, btype), btype, b, btype);

                while (sz > 0) {
                    move(addr, atype, toop(adjust_for_type(reg_intermediate, atype)), atype);
                    if (std::holds_alternative<comp_int_type>(addr.offset)) {
                        addr.offset = std::get<comp_int_type>(addr.offset) + 8;
                    }
                    sz -= 8;
                }
            }
            else {
                em->push(rdi);
                move(adjust_for_type(rax, btype), btype, b, btype);
                em->mov(rcx, comp_int_type(sz / btype.get().size));
                load_address(rdi, todest(a), atype);
                switch (btype.get().size) {
                case 1:
                    em->emitln(" rep stosb");
                    break;
                case 2:
                    em->emitln(" rep stosw");
                    break;
                case 4:
                    em->emitln(" rep stosl");
                    break;
                case 8:
                    em->emitln(" rep stosq");
                    break;
                }
                em->pop(rdi);
            }
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
                move(rdi, ts->opaque_ptr_type, a, atype);
            }

            if (is_mem(b)) {
                load_address(rsi, todest(b), btype);
            }
            else {
                move(rsi, ts->opaque_ptr_type, b, btype);
            }

            move(rcx, ts->int_type, c, ctype);

            em->emitln(" rep movsb");

            em->pop(rsi);
            em->pop(rdi);
            break;
        }
        case ir_add:
        case ir_sub:
        case ir_mul:
        case ir_div: 
        case ir_and:
        case ir_or: 
        case ir_xor: {
            auto [b, btype] = transform_ir_operand(instr.operands[1]);
            auto [a, atype] = transform_ir_operand(instr.operands[0]);
            auto dest = adjust_for_type(instr_dest_to_gen_dest(idata.dest), instr.result_type);

            if (instr.op == ir_div) {
                move(adjust_for_type(rax, atype), atype, a, atype);
                em->cdq(atype);

                if (is_lit(b) || (btype.get().size != atype.get().size)) {
                    move(adjust_for_type(reg_intermediate, atype), atype, b, btype);
                    b = toop(adjust_for_type(reg_intermediate, atype));
                }
                em->idiv(todest(b));

                a = toop(adjust_for_type(rax, atype));
            } else {
                if (!is_reg(a) || is_const_reg(a)) {
                    move(adjust_for_type(reg_intermediate, instr.result_type), instr.result_type, a, atype);
                    a = toop(adjust_for_type(reg_intermediate, instr.result_type));
                }

                emit_binary_math_op(instr.op, todest(a), b);
            }

            if (!(dest == todest(a))) {
                move(dest, instr.result_type, a, atype);
            }

            push(toop(dest));
            break;
        }
        case ir_shr:
        case ir_shl: {
            auto [b, btype] = transform_ir_operand(instr.operands[1]);
            auto [a, atype] = transform_ir_operand(instr.operands[0]);
            auto dest = adjust_for_type(instr_dest_to_gen_dest(idata.dest), instr.result_type);

            gen_operand op = a;

            if (!is_reg(a) || is_const_reg(a)) {
                auto reg = adjust_for_type(reg_intermediate, atype);
                move(reg, atype, a, atype);
                op = toop(reg);
            }

            if (!is_lit(b)) {
                auto reg = adjust_for_type(rcx, btype);
                move(reg, btype, b, btype);
                b = toop(adjust_for_type(rcx, ts->int8_type));
            }

            if (instr.op == ir_shl) {
                em->sal(todest(op), b);
            }
            else if (instr.op == ir_shr) {
                em->sar(todest(op), b);
            }

            move(dest, instr.result_type, op, atype);

            push(toop(dest));
            break;
        }
        case ir_neg:
        case ir_not: {
            auto [a, atype] = transform_ir_operand(instr.operands[0]);
            auto dest = adjust_for_type(instr_dest_to_gen_dest(idata.dest), instr.result_type);

            auto op = adjust_for_type(rax, atype);

            move(op, atype, a, atype);

            if (instr.op == ir_neg) {
                em->neg(op);
            }
            else {
                em->not_(op);
            }

            move(dest, instr.result_type, toop(op), atype);

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
        case ir_stack_dup: {
            push(opstack.top());
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
            em->comment("%s", sprint_ir_instr(instr).c_str());
        }
    }

    // Compares 16 bytes aligned aggregate types.
    void cmp_aggregate_16(gen_operand a, gen_operand b, type_id atype, const ir_instr& instr, std::string jumplabel = "") {
        std::string label = "";
        if (!jumplabel.empty()) {
            label = jumplabel;
        }
        else {
            label = em->special_label(fn->name + "_cmp16end_" + std::to_string(instr.index));
        }

        // TODO: handle more ops?
        const char* jmpop;
        if (instr.op == ir_cmp_eq || instr.op == ir_jmp_neq) {
            jmpop = "jne";
        }
        else if (instr.op == ir_cmp_neq || instr.op == ir_jmp_eq) {
            jmpop = "je";
        }

        size_t sz = atype.get().size;

        em->movdqa(xmm0, cmp16selector_addr);

        gen_addr opa = std::get<gen_addr>(a);
        gen_addr opb = std::get<gen_addr>(b);
        while (sz > 0) {
            em->movdqa(reg_intermediate_xmm, opa);
            em->psadbw(reg_intermediate_xmm, opb); // Compute the absolute difference between 2 128-bit values
            em->pshufb(reg_intermediate_xmm, xmm0); // Shuffle the bytes to get the 2 words together
            em->movq(reg_intermediate, reg_intermediate_xmm); // Store the difference in the intermediate register
            auto cmpa = toop(adjust_for_type(reg_intermediate, ts->int32_type)); // The result is a 32-bit value
            auto cmpb = comp_int_type(0); // Compare it to zero
            em->cmp(cmpa, cmpb);
            if (sz > 16) {
                em->emitln(" %s %s", jmpop, label.c_str());
            }

            opa.offset = std::get<comp_int_type>(opa.offset) + 16;
            opb.offset = std::get<comp_int_type>(opb.offset) + 16;
            sz -= 16;
        }

        if (atype.get().size > 16 && jumplabel.empty()) { em->label(label.c_str()); }
    }

    void emit_cmp_jmp(const ir_instr& instr, const char* j) {
        auto label = std::get<ir_label>(instr.operands.back());
        auto [b, btype] = transform_ir_operand(instr.operands[1]);
        auto [a, atype] = transform_ir_operand(instr.operands[0]);
        if (is_aggregate_type(atype) && (atype.get().size % 16 == 0)) {
            cmp_aggregate_16(a, b, atype, instr, label.name);
        }
        else {
            if (!is_reg(a)) {
                move(adjust_for_type(reg_intermediate, atype), atype, a, atype);
                a = toop(adjust_for_type(reg_intermediate, atype));
            }
            em->cmp(a, b);
        }
        em->emitln(" %s %s", j, label.name.c_str());
    }

    void emit_cmp_set(const ir_instr& instr, const instr_data& idata, const char* set) {
        auto [b, btype] = transform_ir_operand(instr.operands[1]);
        auto [a, atype] = transform_ir_operand(instr.operands[0]);

        auto dest = instr_dest_to_gen_dest(idata.dest);
        auto bytedest = adjust_for_type(dest, ts->uint8_type);
        auto realdest = adjust_for_type(dest, instr.result_type);

        if (is_aggregate_type(atype) && (atype.get().size % 16 == 0)) {
            cmp_aggregate_16(a, b, atype, instr);
            em->set(set, bytedest);
        }
        else {
            if (!is_reg(a)) {
                move(adjust_for_type(reg_intermediate, atype), atype, a, atype);
                a = toop(adjust_for_type(reg_intermediate, atype));
            }
            em->cmp(a, b);
            em->set(set, bytedest);
        }

        if (get_size(realdest) > get_size(bytedest)) {
            // Just in case bool size is > 1
            em->movzx(realdest, toop(bytedest));
        }
        push(toop(realdest));
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
        case ir_and:
            em->and_(a, b);
            break;
        case ir_or:
            em->or_(a, b);
            break;
        case ir_xor:
            em->xor_(a, b);
            break;
        }
    }

    std::pair<gen_operand, type_id> transform_ir_field_ref(const ir_field* arg) {
        if (std::holds_alternative<ir_local>(arg->ref)) {
            int li = std::get<ir_local>(arg->ref).index;

            auto stype = std::get<ir_local>(arg->ref).type;
            if (stype.get().kind == type_kind::ptr) {
                stype = stype.get().elem_type;
            }
            auto& field = stype.get().structure.fields[arg->field_index];

            auto dest = get_local_destination(li, field.type);
            auto& offs = std::get<gen_addr>(dest);
            offs.op_size = field.type.get().size;
            offs.offset = std::get<comp_int_type>(offs.offset) + comp_int_type(field.offset);
            return std::make_pair(toop(dest), field.type);
        }
        else if (std::holds_alternative<ir_arg>(arg->ref)) {
            assert(!"field from ir_arg not handled!");
            
            int ai = std::get<ir_arg>(arg->ref).index;
            auto type = std::get<ir_arg>(arg->ref).type;
            auto& field = type.get().structure.fields[arg->field_index];

            auto dest = get_arg_destination(ai, field.type);
            auto& offs = std::get<gen_addr>(dest);
            offs.op_size = field.type.get().size;
            offs.offset = std::get<comp_int_type>(offs.offset) + comp_int_type(field.offset);
            return std::make_pair(toop(dest), field.type);
        }
        else if (std::holds_alternative<ir_stackpop>(arg->ref)) {
            auto op = pop();
            auto type = std::get<ir_stackpop>(arg->ref).type;
            auto& field = type.get().structure.fields[arg->field_index];

            if (is_reg(op)) {
                auto dest = gen_addr{};
                dest.op_size = field.type.get().size;
                dest.base = std::get<gen_register>(op);
                dest.offset = comp_int_type(field.offset);
                return std::make_pair(toop(dest), field.type);
            }
            else if (std::holds_alternative<gen_addr>(op)) {
                auto& offs = std::get<gen_addr>(op);
                offs.op_size = field.type.get().size;
                if (std::holds_alternative<comp_int_type>(offs.offset)) {
                    offs.offset = std::get<comp_int_type>(offs.offset) + comp_int_type(field.offset);
                }
                else {
                    offs.offset = comp_int_type(field.offset);
                }
                return std::make_pair(op, field.type);
            }
        }
        else if (std::holds_alternative<std::shared_ptr<ir_field>>(arg->ref)) {
            auto [op, type] = transform_ir_field_ref(std::get<std::shared_ptr<ir_field>>(arg->ref).get());
            auto& field = type.get().structure.fields[arg->field_index];
            auto& offs = std::get<gen_addr>(op);
            offs.op_size = field.type.get().size;
            offs.offset = std::get<comp_int_type>(offs.offset) + comp_int_type(field.offset);
            return std::make_pair(op, field.type);
        }
        assert(!"transform_ir_field_ref unhandled");
        return {};
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
        else if (auto arg = std::get_if<ir_global>(&opr); arg) {
            return std::make_pair(gen_data_offset{ arg->name }, arg->type);
        }
        else if (auto arg = std::get_if<ir_stackpop>(&opr); arg) {
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
        return {};
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
        else if (std::holds_alternative<ir_stackpop>(arg->ref)) {
            auto type = std::get<ir_stackpop>(arg->ref).type;
            auto& field = type.get().structure.fields[arg->field_index];
            return field.type;
        }
        else if (std::holds_alternative<std::shared_ptr<ir_field>>(arg->ref)) {
            auto type = get_ir_field_type(std::get<std::shared_ptr<ir_field>>(arg->ref).get());
            auto& field = type.get().structure.fields[arg->field_index];
            return field.type;
        }
        assert(!"get_ir_field_type unhandled");
        return {};
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
        else if (auto arg = std::get_if<ir_global>(&opr); arg) {
            return arg->type;
        }
        else if (auto arg = std::get_if<ir_stackpop>(&opr); arg) {            
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
        return {};
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
        if (toop(dest) == op && (dest_tid == tid)) {
            return;
        }

        if (std::holds_alternative<gen_addr>(dest) && std::holds_alternative<gen_addr>(op)) {
            auto areg = adjust_for_type(reg_intermediate, tid);
            move(areg, tid, op, tid);
            move(dest, dest_tid, toop(areg), tid);
            return;
        }

        if (dest_tid.get().size > tid.get().size && !is_lit(op)) {
            auto ireg = adjust_for_type(reg_intermediate, tid);

            if (dest_tid.get().is_signed) {
                em->movsx(ireg, op);
            }
            else {
                em->movzx(ireg, op);
            }

            em->mov(dest, toop(adjust_for_type(reg_intermediate, dest_tid)));
        }
        else if (dest_tid.get().size < tid.get().size && !is_lit(op)) {
            em->mov(adjust_for_type(reg_intermediate, tid), op);
            em->mov(dest, toop(adjust_for_type(reg_intermediate, dest_tid)));
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
#ifdef _WIN32
    generator gen{make_x64_windows_nasm_emitter(filename), ts, filename};
#else
    generator gen{make_x64_linux_gas_emitter(filename), ts, filename};
#endif
    gen.pre_analysis(prog);
    gen.generate_program(prog);
}

}