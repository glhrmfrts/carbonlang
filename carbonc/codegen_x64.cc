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

struct var_data {
    std::int32_t frame_offset;
};

struct func_data {
    std::vector<var_data> arg_data;
    std::vector<var_data> local_data;

    int call_arg_size = 0;
    int used_temp_registers = 0;
};

gen_destination adjust_for_type(gen_destination dest, type_id tid) {
    auto tdef = tid.scope->type_defs[tid.type_index];
    if (std::holds_alternative<gen_register>(dest)) {
        auto reg = std::get<gen_register>(dest);
        switch (tdef->size) {
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
}

gen_destination todest(gen_operand op) {
    if (std::holds_alternative<gen_register>(op)) {
        return std::get<gen_register>(op);
    }
    if (std::holds_alternative<gen_offset>(op)) {
        return std::get<gen_offset>(op);
    }
}

void find_max_call_arg_size(ir_func& func, std::int32_t& sz) {
    for (const auto& inst : func.instrs) {
        if (inst.op == ir_call) {
            std::int32_t args_size = 0;
            for (auto& arg : inst.operands) {
                auto& tdef = get_operand_type(arg);
                std::int32_t asize = 8;// std::min(8, std::int32_t(tdef.size));
                args_size += asize;
                args_size = align(args_size, 8);//align(args_size, std::int32_t(tdef.alignment));
            }
            sz = std::max(sz, args_size);
        }
    }
}

template <typename T> bool is_mem(const T& op) {
    return std::holds_alternative<gen_offset>(op) || std::holds_alternative<gen_data_offset>(op);
}

template <typename T> bool is_reg(const T& op) {
    return std::holds_alternative<gen_register>(op);
}

struct generator {
    using finalizer_func = std::function<void(const gen_destination&, const gen_operand&)>;

    std::string_view filename;
    std::unique_ptr<emitter> em;
    std::vector<gen_register> arg_registers;
    std::vector<gen_register> temp_registers;
    std::vector<func_data> func_data;
    std::int32_t current_temp_regs_offset = 0;
    type_system* ts;
    int used_temp_registers = 0;

    explicit generator(std::unique_ptr<emitter>&& em, type_system* ts, std::string_view fn) {
        this->em = std::move(em);
        this->ts = ts;
        this->filename = fn;
        arg_registers = em->get_argument_registers();
        temp_registers = em->get_temp_registers();
    }

    // Section: helpers

    std::pair<std::int32_t, std::int32_t> get_func_stack_frame_size(ir_func& func) {
        std::int32_t call_arg_size = 0;
        find_max_call_arg_size(func, call_arg_size);

        if (func.calls_extern_c) {
            call_arg_size = std::max(call_arg_size, 32);
        }

        // NOTE: on windows, it seems arguments are always 8 bytes aligned, no matter their sizes

        std::int32_t own_arg_size = 0;
        std::int32_t local_size = 0;
        int ai = 0;
        for (auto& arg : func.args) {
            auto& tdef = arg.type.get();
            
            func_data[func.index].arg_data[ai].frame_offset = own_arg_size + 8; // offset from rbp + space for the return-instruction pointer
            own_arg_size += 8;// std::int32_t(tdef.size);
            own_arg_size = align(own_arg_size, 8);// align(own_arg_size, std::int32_t(tdef.alignment));
            ai++;
        }

        int li = 0;
        for (auto& local : func.locals) {
            auto& tdef = local.type.get();
            func_data[func.index].local_data[li].frame_offset = -(local_size + 8); // offset from rbp + space for pushed rbp
            local_size += std::int32_t(tdef.size);
            local_size = align(local_size, std::int32_t(tdef.alignment));
            li++;
        }

        local_size = align(local_size, 16);
        call_arg_size = align(call_arg_size, 16);
        return std::make_pair(local_size, call_arg_size);
    }

    gen_destination local_var_destination(local_def& local) {
        bool is_negative = (local.frame_offset < 0);
        std::vector<gen_offset_expr> expr{ rbp };
        if (is_negative) {
            expr.push_back('-');
            expr.push_back(-local.frame_offset);
        }
        else {
            expr.push_back('+');
            expr.push_back(local.frame_offset);
        }
        return gen_offset{ 0, expr };
    }

    std::optional<gen_register> use_temp_register() {
        if (used_temp_registers >= temp_registers.size()) {
            return {};
        }
        
        auto next_reg = temp_registers[used_temp_registers];
        used_temp_registers++;

        auto func_node = ts->find_nearest_scope(scope_kind::func_body)->self;
        //auto& ndata = node_data[func_node->node_id];
        //ndata.func_used_temp_registers.insert(next_reg);
        return next_reg;
    }

    void free_temp_register() {
        used_temp_registers--;
    }

    std::string get_string_label(int idx) {
        return "$cbstr" + std::to_string(si);
    }

    // Section: pre analysis

    void pre_analysis(ir_program& prog) {

    }

    // Section: generators

    void generate_program(ir_program& prog) {
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
            generate_func_code(func);
        }

        em->end();
    }

    // Section: code generators

    void generate_func_code(ir_func& func) {
        em->begin_func(func.name.c_str());
        auto [local_size, call_arg_size] = get_func_stack_frame_size(func);

        em->end_func();
    }

    void generate_func(ast_node& node) {
        if (!node.scope.body_node) return;

        auto& ndata = node_data[node.node_id];

        auto [local_size,call_arg_size] = get_func_stack_frame_size(node);
        std::int32_t stack_size = local_size + call_arg_size;
        ndata.func_call_arg_size = call_arg_size;

        if (node.local.id_node->id_parts.front() == "main") {
            em->begin_func(node.local.id_node->id_parts.front().c_str());
        }
        else {
            em->begin_func(node.type_def.mangled_name.str.c_str());
        }

        std::int32_t temp_regs_offset = node_data[node.node_id].func_used_temp_registers.size() * 8;
        current_temp_regs_offset = temp_regs_offset;

        if (!node.func.arguments.empty()) {
            // move arguments from registers to stack
            std::size_t max_reg_args = std::min(arg_registers.size(), node.func.arguments.size());
            for (std::size_t i = max_reg_args; i > 0; i--) {
                auto arg = node.func.arguments[i - 1];
                auto src = adjust_for_type(gen_register{ arg_registers[i - 1] }, arg->type_id);
                auto dest = adjust_for_type(gen_offset{ 0, {rsp, '+', arg->local.frame_offset} }, arg->type_id);
                em->mov(dest, toop(src));
            }

            for (auto arg : node.func.arguments) {
                arg->local.frame_offset += 8 + temp_regs_offset; // space for the rbp about to be pushed + temp registers
            }
        }

        bool needs_rbp = (!(stack_size == 0 && node.func.arguments.empty()));

        if (needs_rbp) em->push(rbp);

        std::vector<gen_register> temp_regs;
        for (const auto& reg : ndata.func_used_temp_registers) {
            em->push(reg);
            temp_regs.push_back(reg);
        }

        if (needs_rbp) em->mov(rbp, rsp);

        if (stack_size > 0) {
            // resize buffer
            em->sub(rsp, stack_size);
        }

        for (auto& child : node.scope.body_node->children) {
            if (child) {
                generate_node(*child);
            }
        }

        em->label(ndata.func_end_label.c_str());

        if (stack_size > 0) {
            em->add(rsp, stack_size);
        }

        for (std::size_t i = temp_regs.size(); i > 0; i--) {
            em->pop(temp_regs[i - 1]);
        }

        if (needs_rbp) em->pop(rbp);

        em->ret();
        em->end_func();
    }

    void generate_var(ast_node& node) {
        if (node.local.value_node) {
            generate_node(*node.local.value_node);

            auto op = adjust_for_type(local_var_destination(node.local), node.type_id);
            finalize_expr(op);
        }
    }

    void generate_while_stmt(ast_node& node) {
        auto& ndata = node_data[node.node_id];

        em->label(ndata.while_cond_label.c_str());
        generate_node(*node.children[0]);

        em->label(ndata.if_body_label.c_str());
        generate_node(*node.children[1]);

        em->jmp(ndata.while_cond_label.c_str());

        em->label(ndata.if_end_label.c_str());
    }

    void generate_if_stmt(ast_node& node) {
        auto& ndata = node_data[node.node_id];

        generate_node(*node.children[0]);

        if (!ndata.if_body_label.empty()) {
            em->label(ndata.if_body_label.c_str());
        }
        generate_node(*node.children[1]);
        if (node.children.size() == 3) {
            em->jmp(ndata.if_end_label.c_str());

            em->label(ndata.if_else_label.c_str());
            generate_node(*node.children[2]);

            em->label(ndata.if_end_label.c_str());
        }
        else {
            em->label(ndata.if_else_label.c_str());
        }
    }

    void generate_return_stmt(ast_node& node) {
        auto& expr = node.children[0];
        if (expr) {
            generate_node(*expr);
            finalize_expr(rax);
        }
        else {
            em->mov(eax, 0);
        }
        
        if (node.call.funcdef) {
            auto& funcdata = node_data[node.call.funcdef->self->node_id];
            em->jmp(funcdata.func_end_label.c_str());
        }
    }

    void generate_asm_stmt(ast_node& node) {
        em->emitln("%s", node.string_value.data());
    }

    void generate_index_expr(ast_node& node) {
        generate_node(*node.children[1]);
        finalize_expr(rax);

        generate_node(*node.children[0]);
        finalize_expr(rcx);

        std::size_t elem_size = node.type_id.get().size;
        auto offset_expr = gen_offset{ elem_size, std::vector<gen_offset_expr>{
            rcx, '+', rax, '*', std::int32_t(elem_size)
        } };
        push_operand(offset_expr, [this, &node, offset_expr](auto&& dest, auto&&) {
            move(adjust_for_type(dest, node.type_id), offset_expr, node.type_id);
        });
    }

    void generate_call_expr(ast_node& node) {
        if (!node.call.args.empty()) {
            if (node.call.args.size() > arg_registers.size()) {
                for (std::size_t i = node.call.args.size(); i > arg_registers.size(); i--) {
                    std::int32_t offs = (i - 1) * 8;
                    auto dest = gen_offset{ 0, { rsp, '+', offs } };
                    generate_node(*node.call.args[i - 1]);
                    finalize_expr(dest);
                }
            }

            std::size_t max_reg_args = std::min(arg_registers.size(), node.call.args.size());
            for (std::size_t i = max_reg_args; i > 0; i--) {
                auto dest = gen_register{ arg_registers[i - 1] };
                generate_node(*node.call.args[i - 1]);
                finalize_expr(dest);
            }
        }
        em->call(node.call.mangled_name.str.c_str());

        auto op = toop(adjust_for_type(gen_destination{ rax }, node.type_id));
        push_operand(op, [this, &node, op](auto&& dest, auto&&) {
            auto adest = adjust_for_type(dest, node.type_id);
            if (!(toop(adest) == op)) {
                move(adest, op, node.type_id);
            }
        });
    }

    void generate_assignment(ast_node& node) {
        auto& ndata = node_data[node.node_id];
        if (node.local.self || ndata.bin_temp_register) {
            gen_destination rightdest = rax;
            if (node.local.self) {
                // needs spill temp variable
                rightdest = local_var_destination(node.local);
            }
            else if (ndata.bin_temp_register) {
                rightdest = *ndata.bin_temp_register;
            }
            generate_node(*node.children[1]);
            finalize_expr(rightdest);

            generate_node(*node.children[0]);
            auto dest = operand_stack.top().first;
            operand_stack.pop();

            move(todest(dest), toop(adjust_for_type(rightdest, node.children[1]->type_id)), node.children[1]->type_id);
        }
        else {
            generate_node(*node.children[0]);
            auto dest = operand_stack.top();
            operand_stack.pop();

            generate_node(*node.children[1]);
            finalize_expr(todest(dest.first));
        }
    }

    void emit_jump_for_bool_op(token_type op, bool invert, const std::string& label) {
        std::string inst;
        switch (token_to_char(op)) {
        case '>':
            if (invert) inst = "jle";
            else inst = "jg";
            break;
        case '<':
            if (invert) inst = "jge";
            else inst = "jl";
            break;
        }

        switch (op) {
        case token_type::gteq:
            if (invert) inst = "jl";
            else inst = "jge";
            break;
        case token_type::lteq:
            if (invert) inst = "jg";
            else inst = "jle";
            break;
        case token_type::eqeq:
            if (invert) inst = "jne";
            else inst = "je";
            break;
        case token_type::neq:
            if (invert) inst = "je";
            else inst = "jne";
            break;
        }

        if (!inst.empty()) {
            em->emitln(" %s %s", inst.c_str(), label.c_str());
        }
        else {
            assert(!"unreachable emit_jump_for_if_op");
        }
    }

    void emit_binary_op(ast_node& node, const gen_destination& dest, const gen_operand& operand) {
        auto& ndata = node_data[node.node_id];
        switch (token_to_char(node.op)) {
        case '+':
            em->add(dest, operand);
            break;
        case '-':
            em->sub(dest, operand);
            break;
        case '*':
            em->imul(dest, operand);
            break;
        default:
            if (is_cmp_binary_op(node.op)) {
                em->cmp(toop(dest), operand);
                emit_jump_for_bool_op(node.op, ndata.bin_invert_jump, ndata.bin_target_label);
            }
            break;
        }
    }

    void generate_binary_expr(ast_node& node) {
        if (token_to_char(node.op) == '=') {
            generate_assignment(node);
            return;
        }

        auto& left = node.children[0];
        auto& right = node.children[1];
        auto& ndata = node_data[node.node_id];

        if (!ndata.bin_self_label.empty()) {
            em->label(ndata.bin_self_label.c_str());
        }

        gen_destination leftdest = rax;

        if (node.local.self) {
            // needs spill temp variable
            leftdest = local_var_destination(node.local);
        }
        else if (ndata.bin_temp_register) {
            leftdest = *ndata.bin_temp_register;
        }

        generate_node(*left);
        finalize_expr(leftdest);

        generate_node(*right);
        finalize_expr(rax, [this, &node, &ndata, leftdest](auto&&, auto&& op) {
            auto atype = (is_cmp_binary_op(node.op)) ? node.children[0]->type_id : node.type_id;
            auto arax = adjust_for_type(rax, atype);
            auto arcx = adjust_for_type(rcx, atype);
            auto atemp = adjust_for_type(leftdest, node.children[0]->type_id);
            auto aop = op;

            if (node.local.self || ndata.bin_temp_register) {
                if (!is_reg(op)) {
                    move(arax, aop, node.children[1]->type_id); // reload temp variable
                    aop = toop(arax);
                }
                emit_binary_op(node, todest(aop), toop(atemp));
            }
            else {
                auto brax = arax;
                if (is_reg(op) || is_mem(op)) {
                    if (node.children[0]->type_id.get().size < node.children[1]->type_id.get().size) {
                        brax = adjust_for_type(rax, node.children[1]->type_id);
                        move(brax, toop(arax), node.children[0]->type_id); // extend the value
                    }
                    else if (node.children[0]->type_id.get().size > node.children[1]->type_id.get().size) {
                        auto brcx = adjust_for_type(rcx, node.children[0]->type_id);
                        move(brcx, aop, node.children[1]->type_id); // extend the value
                        aop = toop(brcx);
                    }
                }
                emit_binary_op(node, brax, aop);
            }

#if 0
            if (!(op == toop(arax))) {
                auto actual_op = op;
                /*
                if (std::holds_alternative<gen_offset>(op)) {
                    auto arcx = adjust_for_type(rcx, node.children[1]->type_id);
                    move(arcx, actual_op, node.children[1]->type_id); // reload temp variable
                    actual_op = toop(arcx);
                }
                */
                emit_binary_op(node, arax, actual_op);
            }
            else {
                auto actual_temp = adjust_for_type(leftdest, node.children[0]->type_id);
                /*
                if (std::holds_alternative<gen_offset>(leftdest)) {
                    auto arcx = adjust_for_type(rcx, node.children[0]->type_id);
                    move(arcx, actual_op, node.children[0]->type_id); // reload temp variable
                    actual_temp = arcx;
                }
                */
                emit_binary_op(node, arax, toop(actual_temp));
            }
        */
#endif
        });

        auto op = toop(adjust_for_type(rax, node.type_id));
        push_operand(op, [this, &node, op](auto&& dest, auto&&) {
            auto adest = adjust_for_type(dest, node.type_id);
            if (!(toop(adest) == op)) {
                move(adest, op, node.type_id);
            }
        });
    }

    void generate_deref_expr(ast_node& node) {
        generate_node(*node.children[0]);
        finalize_expr(rax);

        auto op = gen_offset{ node.type_id.get().size, { rax } };
        push_operand(op, [this, &node, op](auto&& dest, auto&&) {
            move(adjust_for_type(dest, node.type_id), op, node.type_id);
        });
    }

    void generate_addr_expr(ast_node& node) {
        generate_node(*node.children[0]);
        auto op = operand_stack.top().first;
        operand_stack.pop();

        push_operand(op, [this, op, &node](auto&& dest, auto&&) {
            if (!std::holds_alternative<gen_register>(dest)) {
                em->lea(rax, todest(op));
                em->mov(adjust_for_type(dest, node.type_id), rax);
            }
            else {
                em->lea(adjust_for_type(dest, node.type_id), todest(op));
            }
        });
    }

    void generate_unary_expr(ast_node& node) {
        if (token_to_char(node.op) == '*') {
            generate_deref_expr(node);
        }
        else if (token_to_char(node.op) == '&') {
            generate_addr_expr(node);
        }
        else if (token_to_char(node.op) == '!') {
            generate_node(*node.children[0]);
        }
    }

    void generate_identifier(ast_node& node) {
        if (node.lvalue.symbol->kind == symbol_kind::local) {
            auto local = node.lvalue.symbol->scope->local_defs[node.lvalue.symbol->local_index];
            auto op = toop(adjust_for_type(local_var_destination(*local), node.type_id));
            push_operand(op, [this, &node, op](auto&& dest, auto&&) {
                move(adjust_for_type(dest, node.type_id), op, node.type_id);
            });
        }
    }

    void generate_int_literal(ast_node& node) {
        push_operand(gen_operand{ std::int32_t(node.int_value) }, [this, &node](const gen_destination& dest, auto&&) {
            auto adest = adjust_for_type(dest, node.type_id);
            if (node.int_value == 0 && std::holds_alternative<gen_register>(dest)) {
                em->xor(adest, toop(adest));
            }
            else {
                move(adest, std::int32_t(node.int_value), node.type_id);
            }
        });
    }

    void generate_char_literal(ast_node& node) {
        push_operand(gen_operand{ char(node.int_value) }, [this, &node](const gen_destination& dest, auto&&) {
            auto adest = adjust_for_type(dest, node.type_id);
            if (node.int_value == 0 && std::holds_alternative<gen_register>(dest)) {
                em->xor(adest, toop(adest));
            }
            else {
                move(adest, char(node.int_value), node.type_id);
            }
        });
    }

    void generate_string_literal(ast_node& node) {
        auto op = gen_data_offset{ node.global_data.label };
        push_operand(op, [this, op, &node](const gen_destination& dest, auto&&) {
            load_address(adjust_for_type(dest, node.type_id), op, node.type_id);
        });
    }

    void move(const gen_destination& dest, const gen_operand& op, type_id tid) {
        if (std::holds_alternative<gen_offset>(dest) && std::holds_alternative<gen_offset>(op)) {
            auto arax = adjust_for_type(rax, tid);
            move(arax, op, tid);
            move(dest, toop(arax), tid);
            return;
        }

        if (tid.get().is_signed) {
            em->movsx(dest, op);
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
            auto arax = adjust_for_type(rax, tid);
            em->lea(arax, op);
            em->mov(dest, toop(arax));
        }
    }
};

void codegen(ir_program& prog, type_system* ts, std::string_view filename) {
    generator gen{std::make_unique<emitter>(filename), ts, filename};
    gen.generate_program(prog);
}

}