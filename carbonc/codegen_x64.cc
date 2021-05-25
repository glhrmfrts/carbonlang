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

struct gen_node_data {
    std::optional<gen_register> bin_temp_register{};
    std::string bin_self_label;
    std::string bin_target_label;
    bool bin_invert_jump;

    std::set<gen_register> func_used_temp_registers{};
    bool func_calls_extern_c = false;
    std::int32_t func_call_arg_size;

    std::string if_body_label;
    std::string if_else_label;
    std::string if_end_label;
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

template <typename T> T align(T number, T alignment) {
    T offset = number % alignment;
    if (offset) {
        number = number - offset + alignment;
    }

    return number;
}

void find_max_call_arg_size(ast_node& node, std::int32_t& sz) {
    if (node.type == ast_type::call_expr) {
        std::int32_t args_size = 0;
        for (auto& arg : node.call.args) {
            auto tdef = arg->type_id.get();
            std::int32_t asize = 8;// std::min(8, std::int32_t(tdef.size));
            args_size += asize;
            args_size = align(args_size, 8);//align(args_size, std::int32_t(tdef.alignment));
        }
        sz = std::max(sz, args_size);
    }
    for (auto& child : node.children) {
        if (child) {
            find_max_call_arg_size(*child, sz);
        }
    }
}

struct generator {
    using finalizer_func = std::function<void(const gen_destination&, const gen_operand&)>;

    std::string_view filename;
    std::unique_ptr<emitter> em;
    std::vector<gen_register> arg_registers;
    std::vector<gen_register> temp_registers;
    std::vector<std::pair<std::string_view, std::string>> global_strings;
    std::stack<std::pair<gen_operand, finalizer_func>> operand_stack;
    std::unordered_map<std::size_t, gen_node_data> node_data;
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

    std::string find_or_add_global_string_data(std::string_view data) {
        for (const auto& str : global_strings) {
            if (data == str.first) {
                return str.second;
            }
        }

        auto label = "$cbstr" + std::to_string(global_strings.size());
        auto new_pair = std::make_pair(data, label);
        global_strings.push_back(new_pair);
        em->add_string_data(label, data);
        return label;
    }

    std::pair<std::int32_t, std::int32_t> get_func_stack_frame_size(ast_node& node) {
        assert(node.type == ast_type::func_decl);

        std::int32_t call_arg_size = 0;
        find_max_call_arg_size(*node.scope.body_node, call_arg_size);

        if (node_data[node.node_id].func_calls_extern_c) {
            call_arg_size = std::max(call_arg_size, 32);
        }

        // NOTE: on windows, it seems arguments are always 8 bytes aligned, no matter their sizes

        std::int32_t own_arg_size = 0;
        std::int32_t local_size = 0;
        for (auto& local : node.scope.local_defs) {
            auto& tdef = local->self->type_id.get();
            if (local->is_argument) {
                local->frame_offset = own_arg_size + 8; // offset from rbp + space for the return-instruction pointer
                own_arg_size += 8;// std::int32_t(tdef.size);
                own_arg_size = align(own_arg_size, 8);// align(own_arg_size, std::int32_t(tdef.alignment));
            }
            else {
                local->frame_offset = -(local_size + 8); // offset from rbp + space for pushed rbp
                local_size += std::int32_t(tdef.size);
                local_size = align(local_size, std::int32_t(tdef.alignment));
            }
        }

        local_size = align(local_size, 16);
        call_arg_size = align(call_arg_size, 16);
        return std::make_pair(local_size, call_arg_size);
    }

    void provide_operand(const gen_operand& op, finalizer_func&& f) {
        operand_stack.push({ op, std::move(f) });
    }

    void finalize_expr(const gen_destination& dest, finalizer_func&& f = {}) {
        if (!operand_stack.empty()) {
            auto op = std::move(operand_stack.top());
            operand_stack.pop();

            if (f) {
                f(dest, op.first);
            }
            else {
                // call default finalizer
                op.second(dest, op.first);
            }
        }
    }

    void discard_expr() {
        while (!operand_stack.empty()) {
            operand_stack.pop();
        }
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
        auto& ndata = node_data[func_node->node_id];
        ndata.func_used_temp_registers.insert(next_reg);
        return next_reg;
    }

    void free_temp_register() {
        used_temp_registers--;
    }

    // Section: pre analysis

    void pre_analysis(ast_node& node) {
        for (auto& unit : node.children) {
            ts->enter_scope(*unit);
            analyse_node(*unit);
            ts->leave_scope();
        }
    }

    void analyse_children(ast_node& node) {
        for (auto& child : node.pre_children) {
            if (child) { analyse_node(*child); }
        }
        for (auto& child : node.children) {
            if (child) { analyse_node(*child); }
        }
    }

    void analyse_node(ast_node& node) {
        switch (node.type) {
        case ast_type::func_decl: {
            auto name = node.type_def.mangled_name.str.c_str();
            if (node.scope.body_node) {
                if (node.local.id_node->id_parts.front() == "main") {
                    em->add_global_func_decl(node.local.id_node->id_parts.front().c_str());
                }
                else {
                    em->add_global_func_decl(name);
                }

                ts->enter_scope(node);
                analyse_children(node);
                ts->leave_scope();
            }
            else {
                em->add_extern_func_decl(name);
            }
            break;
        }
        case ast_type::if_stmt: {
            auto scope = ts->find_nearest_scope(scope_kind::func_body);
            auto& funcname = scope->self->type_def.mangled_name.str;
            auto& ndata = node_data[node.node_id];
            ndata.if_body_label = funcname + "_if" + std::to_string(node.node_id) + "_body";
            ndata.if_else_label = funcname + "_if" + std::to_string(node.node_id) + "_else";

            if (node.children.size() == 3) {
                ndata.if_end_label = funcname + "_if" + std::to_string(node.node_id) + "_end";
            }

            set_bool_op_targets(*node.children[0], ndata.if_body_label, ndata.if_else_label);

            analyse_children(node);
            break;
        }
        case ast_type::call_expr: {
            auto func_node = node.call.func_type_id.get().self;
            if (func_node->func.linkage == func_linkage::external_c) {
                auto curscope = ts->find_nearest_scope(scope_kind::func_body);
                node_data[curscope->self->node_id].func_calls_extern_c = true;
            }

            analyse_children(node);

            // Generate temp variables for nested calls
            if (node.call.args.size() > 1) {
                for (std::size_t i = 0; i < node.call.args.size(); i++) {
                    auto arg = node.call.args[i];

                    // If the call expression is at the end of the parent call,
                    // there is no problem.
                    if (arg->type == ast_type::call_expr && i < node.call.args.size() - 1) {
                        ts->create_temp_variable_for_call_arg(node, *arg, i);
                    }
                }
            }
            break;
        }
        case ast_type::index_expr: {
            analyse_children(node);

            // Generate temp variables for index expressions
            if (!is_primary_expr(*node.children[0])) {
                ts->create_temp_variable_for_index_expr(node);
            }
            break;
        }
        case ast_type::binary_expr: {
            // create temporary variables for nested expressions
            auto& left = node.children[0];
            auto& right = node.children[1];
            std::optional<gen_register> temp_reg;

            if (!is_primary_expr(*right) && !is_cmp_binary_op(*left) && !is_logic_binary_op(*left)) {
                temp_reg = use_temp_register();
                if (!temp_reg) {
                    ts->create_temp_variable_for_binary_expr(node);
                }
                else {
                    node_data[node.node_id].bin_temp_register = temp_reg;
                }
            }

            analyse_children(node);

            if (temp_reg) {
                free_temp_register();
            }
            break;
        }
        default:
            analyse_children(node);
            break;
        }
    }

    std::string generate_label_for_short_circuit(ast_node& node) {
        auto scope = ts->find_nearest_scope(scope_kind::func_body);
        auto& funcname = scope->self->type_def.mangled_name.str;
        auto& ndata = node_data[node.node_id];
        ndata.bin_self_label = funcname + "_short" + std::to_string(node.node_id);
        return ndata.bin_self_label;
    }

    void set_bool_op_target(ast_node& node, bool invert_jump, const std::string& label) {
        auto& ndata = node_data[node.node_id];
        ndata.bin_invert_jump = invert_jump;
        ndata.bin_target_label = label;
    }

    // (a>5) && (b<4)
    //
    // (a>5) || (b<4)
    //
    // ((a<5 || a>5) && a<10) && (b<4)
    //
    // ((a<5 && a>5) && a<10) || (b<4)

    void set_bool_op_targets(ast_node& node, const std::string& true_label, const std::string& false_label) {
        if (node.type == ast_type::binary_expr && node.op == token_type::andand) {
            set_bool_op_target(*node.children[0], true, false_label);
            if (is_logic_binary_op(*node.children[0])) {
                if (node.children[0]->op == token_type::oror) {
                    auto right_label = generate_label_for_short_circuit(*node.children[1]);
                    set_bool_op_targets(*node.children[0], right_label, false_label);
                }
                else {
                    set_bool_op_targets(*node.children[0], true_label, false_label);
                }
            }
            set_bool_op_targets(*node.children[1], true_label, false_label);
        }
        else if (node.type == ast_type::binary_expr && node.op == token_type::oror) {
            set_bool_op_target(*node.children[0], false, true_label);
            if (is_logic_binary_op(*node.children[0])) {
                if (node.children[0]->op == token_type::andand) {
                    auto right_label = generate_label_for_short_circuit(*node.children[1]);
                    set_bool_op_targets(*node.children[0], true_label, right_label);
                }
                else {
                    set_bool_op_targets(*node.children[0], true_label, false_label);
                }
            }
            set_bool_op_targets(*node.children[1], true_label, false_label);
        }
        else if (node.type == ast_type::unary_expr && node.op == token_type::not_) {
            if (is_logic_binary_op(*node.children[0])) {
                // invert the labels
                set_bool_op_targets(*node.children[0], false_label, true_label);
            }
            else if (is_cmp_binary_op(*node.children[0])) {
                // invert the jump
                set_bool_op_target(node, false, false_label);
            }
        }
        else {
            set_bool_op_target(node, true, false_label);
        }
    }

    // Section: generators

    void generate_program(ast_node& node) {
        arg_registers = em->get_argument_registers();

        em->begin_data_segment();
        generate_node_data(node);

        em->begin_code_segment();
        generate_node(node);

        em->end();
    }

    // Section: data generators

    void generate_node_data(ast_node& node) {
        switch (node.type) {
        case ast_type::string_literal:
            generate_string_literal_data(node);
            break;
        default:
            for (auto& child : node.children) {
                if (child) {
                    generate_node_data(*child);
                }
            }
        }
    }

    void generate_string_literal_data(ast_node& node) {
        node.global_data.label = find_or_add_global_string_data(node.string_value);
    }

    // Section: code generators

    void generate_node(ast_node& node) {
        for (auto& child : node.pre_children) {
            if (child) {
                generate_node(*child);
            }
        }

        switch (node.type) {
        case ast_type::import_decl:
        case ast_type::type_expr:
            break;
        case ast_type::func_decl:
            generate_func(node);
            break;
        case ast_type::var_decl:
            generate_var(node);
            break;
        case ast_type::if_stmt:
            generate_if_stmt(node);
            break;
        case ast_type::return_stmt:
            generate_return_stmt(node);
            break;
        case ast_type::asm_stmt:
            generate_asm_stmt(node);
            break;
        case ast_type::index_expr:
            generate_index_expr(node);
            break;
        case ast_type::call_expr:
            generate_call_expr(node);
            break;
        case ast_type::binary_expr:
            generate_binary_expr(node);
            break;
        case ast_type::unary_expr:
            generate_unary_expr(node);
            break;
        case ast_type::identifier:
            generate_identifier(node);
            break;
        case ast_type::int_literal:
        case ast_type::bool_literal:
            generate_int_literal(node);
            break;
        case ast_type::char_literal:
            generate_char_literal(node);
            break;
        case ast_type::string_literal:
            generate_string_literal(node);
            break;
        case ast_type::stmt_list:
            for (auto& child : node.children) {
                if (child) {
                    generate_node(*child);
                    discard_expr();
                }
            }
            break;
        default:
            for (auto& child : node.children) {
                if (child) {
                    generate_node(*child);
                }
            }
        }
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
        provide_operand(offset_expr, [this, &node, offset_expr](auto&& dest, auto&&) {
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
        provide_operand(op, [this, &node, op](auto&& dest, auto&&) {
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
        finalize_expr(rax, [this, &node, leftdest](auto&&, auto&& op) {
            auto atype = (is_cmp_binary_op(node.op)) ? node.children[0]->type_id : node.type_id;
            auto arax = adjust_for_type(rax, atype);
            if (!(op == toop(arax))) {
                auto actual_op = op;
                if (std::holds_alternative<gen_offset>(op)) {
                    auto arcx = adjust_for_type(rcx, node.children[1]->type_id);
                    move(arcx, actual_op, node.children[1]->type_id); // reload temp variable
                    actual_op = toop(arcx);
                }
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
        });

        auto op = toop(adjust_for_type(rax, node.type_id));
        provide_operand(op, [this, &node, op](auto&& dest, auto&&) {
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
        provide_operand(op, [this, &node, op](auto&& dest, auto&&) {
            move(adjust_for_type(dest, node.type_id), op, node.type_id);
        });
    }

    void generate_addr_expr(ast_node& node) {
        generate_node(*node.children[0]);
        auto op = operand_stack.top().first;
        operand_stack.pop();

        provide_operand(op, [this, op, &node](auto&& dest, auto&&) {
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
    }

    void generate_identifier(ast_node& node) {
        if (node.lvalue.symbol.kind == symbol_kind::local) {
            auto local = node.lvalue.symbol.scope->local_defs[node.lvalue.symbol.local_index];
            auto op = toop(adjust_for_type(local_var_destination(*local), node.type_id));
            provide_operand(op, [this, &node, op](auto&& dest, auto&&) {
                move(adjust_for_type(dest, node.type_id), op, node.type_id);
            });
        }
    }

    void generate_int_literal(ast_node& node) {
        provide_operand(gen_operand{ std::int32_t(node.int_value) }, [this, &node](const gen_destination& dest, auto&&) {
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
        provide_operand(gen_operand{ char(node.int_value) }, [this, &node](const gen_destination& dest, auto&&) {
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
        provide_operand(op, [this, op, &node](const gen_destination& dest, auto&&) {
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

void codegen(ast_node& node, type_system* ts, std::string_view filename) {
    generator gen{std::make_unique<emitter>(filename), ts, filename};
    gen.pre_analysis(node);
    gen.generate_program(node);
}

}