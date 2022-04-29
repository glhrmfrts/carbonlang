/**
 * An IR that generates code for a imaginary Hybrid Stack-machine. Instruction results are
 * not always pushed to the stack. Similarly, instruction operands are not always provided
 * by the stack. Only complex instructions push their results to the stack.
 */


#include "ir.hh"
#include "ast.hh"
#include <cassert>
#include <stack>
#include <fstream>
#include <sstream>

namespace carbon {

namespace {

static const std::string opnames[] = {
    "ir_load",
    "ir_copy",
    "ir_cast",
    "ir_add",
    "ir_sub",
    "ir_mul",
    "ir_div",
    "ir_neg",
    "ir_and",
    "ir_or",
    "ir_shr",
    "ir_shl",
    "ir_call",
    "ir_return",
    "ir_index",
    "ir_deref",
    "ir_load_addr",
    "ir_make_label",
    "ir_asm",
    "ir_cmp_lt",
    "ir_cmp_gt",
    "ir_cmp_lteq",
    "ir_cmp_gteq",
    "ir_cmp_eq",
    "ir_cmp_neq",
    "ir_jmp",
    "ir_jmp_eq",
    "ir_jmp_neq",
    "ir_jmp_gt",
    "ir_jmp_gte",
    "ir_jmp_lt",
    "ir_jmp_lte",
    "ir_stack_dup",
    "ir_noop",
};

static ir_program* prog;
static ir_func* currentfunc;
static type_system* ts;
static std::stack<ir_operand> operand_stack;
static std::unordered_map<std::string, int> string_map;

// The target labels for any continue or break statements
struct control_labels {
    std::string continue_label;
    std::string break_label;
};
static std::stack<control_labels> ctrl_labels;

void generate_ir_defer_stmt(ast_node& node);

void generate_ir_node(ast_node& node);

void analyse_node(ast_node& node);

// section: helpers

void push(const ir_operand& val) {
    operand_stack.push(val);
}

ir_operand pop() {
    auto res = operand_stack.top();
    operand_stack.pop();
    return res;
}

void push_control_labels(const control_labels& lb) {
    ctrl_labels.push(lb);
}

void pop_control_labels() {
    ctrl_labels.pop();
}

template <typename... Args> size_t emit(ir_op op, Args&&... args) {
    currentfunc->instrs.push_back({ op, {}, std::vector<ir_operand>{ std::forward<Args>(args)... }, (int)currentfunc->instrs.size() });
    return currentfunc->instrs.size() - 1;
}

template <typename... Args> size_t temit(ir_op op, type_id t, Args&&... args) {
    currentfunc->instrs.push_back({ op, t, std::vector<ir_operand>{ std::forward<Args>(args)... }, (int)currentfunc->instrs.size() });
    return currentfunc->instrs.size() - 1;
}

size_t emitops(ir_op op, type_id t, const std::vector<ir_operand>& args) {
    currentfunc->instrs.push_back({ op, t, args, (int)currentfunc->instrs.size() });
    return currentfunc->instrs.size() - 1;
}

void discard_opstack(std::size_t tosize) {
    // discard any effect on the opstack
    if (operand_stack.size() > tosize) {
        std::vector<ir_operand> args;
        for (std::size_t i = tosize; i < operand_stack.size(); i++) {
            args.push_back(pop());
        }
        emitops(ir_noop, ts->void_type, args);
    }
}

int find_or_add_global_string_data(std::string data) {
    auto it = string_map.find(data);
    if (it == string_map.end()) {
        int i = prog->strings.size();
        string_map[data] = i;
        prog->strings.push_back(std::move(data));
        return i;
    }

    return it->second;
}

ir_ref toref(const ir_operand& opr) {
    if (auto arg = std::get_if<ir_arg>(&opr); arg) {
        return *arg;
    }
    if (auto arg = std::get_if<ir_local>(&opr); arg) {
        return *arg;
    }
    if (auto arg = std::get_if<ir_stackpop>(&opr); arg) {
        return *arg;
    }
    if (auto arg = std::get_if<ir_field>(&opr); arg) {
        return std::make_shared<ir_field>(*arg);
    }
}

// Section: analysis

std::string generate_label_for_short_circuit(ast_node& node) {
    auto scope = ts->find_nearest_scope(scope_kind::func_body);
    auto& funcname = scope->self->tdef.mangled_name.str;
    node.ir.bin_self_label = funcname + "_short" + std::to_string(node.node_id);
    return node.ir.bin_self_label;
}

void set_bool_op_target(ast_node& node, bool invert_jump, const std::string& label) {
    node.ir.bin_invert_jump = invert_jump;
    node.ir.bin_target_label = label;
}

void distribute_bool_op_targets(ast_node& node, const std::string& true_label, const std::string& false_label) {
    if (node.type == ast_type::binary_expr && node.op == token_type::andand) {
        set_bool_op_target(*node.children[0], true, false_label);
        if (is_logic_binary_op(*node.children[0])) {
            if (node.children[0]->op == token_type::oror) {
                auto right_label = generate_label_for_short_circuit(*node.children[1]);
                distribute_bool_op_targets(*node.children[0], right_label, false_label);
            }
            else {
                distribute_bool_op_targets(*node.children[0], true_label, false_label);
            }
        }
        distribute_bool_op_targets(*node.children[1], true_label, false_label);
    }
    else if (node.type == ast_type::binary_expr && node.op == token_type::oror) {
        set_bool_op_target(*node.children[0], false, true_label);
        if (is_logic_binary_op(*node.children[0])) {
            if (node.children[0]->op == token_type::andand) {
                auto right_label = generate_label_for_short_circuit(*node.children[1]);
                distribute_bool_op_targets(*node.children[0], true_label, right_label);
            }
            else {
                distribute_bool_op_targets(*node.children[0], true_label, false_label);
            }
        }
        distribute_bool_op_targets(*node.children[1], true_label, false_label);
    }
    else if (node.type == ast_type::unary_expr && token_to_char(node.op) == '!') {
        if (is_logic_binary_op(*node.children[0])) {
            // invert the labels
            distribute_bool_op_targets(*node.children[0], false_label, true_label);
        }
        else if (is_cmp_binary_op(*node.children[0])) {
            // invert the jump
            set_bool_op_target(*node.children[0], false, false_label);
        }
    }
    else {
        set_bool_op_target(node, true, false_label);
    }
}

void send_locals_to_func_scope(ast_node& node) {
    auto fscope = ts->find_nearest_scope(scope_kind::func_body);
    auto scope = &node.scope;
    for (auto& sym : scope->symbols) {
        if (sym.second->kind == symbol_kind::local) {
            auto local = scope->local_defs[sym.second->local_index];
            sym.second->scope = fscope;
            sym.second->local_index = fscope->local_defs.size();
            fscope->local_defs.push_back(local);
        }
    }
}

void analyse_children(ast_node& node) {
    for (auto& child : node.pre_nodes) {
        if (child) { analyse_node(*child); }
    }
    for (auto& child : node.children) {
        if (child) { analyse_node(*child); }
    }
}

void analyse_node(ast_node& node) {
    switch (node.type) {
    case ast_type::func_decl: {
        if (node.scope.body_node) {
            ts->enter_scope(node);
            for (auto& child : node.scope.body_node->children) {
                if (child) {
                    analyse_node(*child);
                }
            }
            ts->leave_scope();
        }
        break;
    }
    case ast_type::for_numeric_stmt: {
        auto scope = ts->find_nearest_scope(scope_kind::func_body);
        auto& funcname = scope->self->tdef.mangled_name.str;

        node.ir.if_body_label = funcname + "$f" + std::to_string(node.node_id) + "$body";
        node.ir.if_end_label = funcname + "$f" + std::to_string(node.node_id) + "$end";
        node.ir.while_cond_label = funcname + "$f" + std::to_string(node.node_id) + "$cond";

        distribute_bool_op_targets(*node.forinfo.compare_elem_to_range_end, node.ir.if_body_label, node.ir.if_end_label);

        ts->enter_scope(node);
        send_locals_to_func_scope(node);
        analyse_node(*node.children[2]);
        ts->leave_scope();
        break;
    }
    case ast_type::for_cond_stmt: {
        auto scope = ts->find_nearest_scope(scope_kind::func_body);
        auto& funcname = scope->self->tdef.mangled_name.str;

        node.ir.if_body_label = funcname + "$w" + std::to_string(node.node_id) + "$body";
        node.ir.if_end_label = funcname + "$w" + std::to_string(node.node_id) + "$end";
        node.ir.while_cond_label = funcname + "$w" + std::to_string(node.node_id) + "$cond";

        distribute_bool_op_targets(*node.children[0], node.ir.if_body_label, node.ir.if_end_label);

        ts->enter_scope(node);
        send_locals_to_func_scope(node);
        analyse_node(*node.children[1]);
        ts->leave_scope();
        break;
    }
    case ast_type::if_stmt: {
        auto scope = ts->find_nearest_scope(scope_kind::func_body);
        auto& funcname = scope->self->tdef.mangled_name.str;

        node.ir.if_body_label = funcname + "$if" + std::to_string(node.node_id) + "$body";
        node.ir.if_else_label = funcname + "$if" + std::to_string(node.node_id) + "$else";

        if (node.children.size() == 3) {
            node.ir.if_end_label = funcname + "$if" + std::to_string(node.node_id) + "$end";
        }

        distribute_bool_op_targets(*node.children[0], node.ir.if_body_label, node.ir.if_else_label);

        ts->enter_scope(node);
        send_locals_to_func_scope(node);
        analyse_children(node);
        ts->leave_scope();
        break;
    }
    case ast_type::compound_stmt: {
        ts->enter_scope(node);
        send_locals_to_func_scope(node);
        analyse_children(node);
        ts->leave_scope();
        break;
    }
    case ast_type::call_expr: {
        analyse_children(node);

/*
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
        */
        break;
    }
    case ast_type::index_expr: {
        analyse_children(node);

/*
        // Generate temp variables for index expressions
        if (!is_primary_expr(*node.children[0])) {
            ts->create_temp_variable_for_index_expr(node);
        }
*/
        break;
    }
    case ast_type::binary_expr: {
        analyse_children(node);
        /*
        // create temporary variables for nested expressions
        auto& left = node.children[0];
        auto& right = node.children[1];
        std::optional<gen_register> temp_reg;

        bool should_use_temp = !is_primary_expr(*right) && !is_cmp_binary_op(*left) && !is_logic_binary_op(*left);
        if (token_to_char(node.op) == '=') {
            // on assignments, if the left side is an identifier, there is no need for a temp on the right-side
            if (left->type == ast_type::identifier) {
                should_use_temp = false;
            }
        }

        if (should_use_temp) {
            temp_reg = use_temp_register();
            if (!temp_reg) {
                ts->create_temp_variable_for_binary_expr(node);
            }
            else {
                node_data[node.node_id].bin_temp_register = temp_reg;
            }
        }

        if (temp_reg) {
            free_temp_register();
        }
        */
        break;
    }
    default:
        analyse_children(node);
        break;
    }
}

// Section: generators

void generate_ir_children(ast_node& node) {
    for (auto& child : node.children) {
        if (child) {
            generate_ir_node(*child);
        }
    }
}

void generate_ir_func(ast_node& node) {
    ir_func* funcptr = nullptr;
    for (auto& f : prog->funcs) {
        if (f.name == node.tdef.mangled_name.str) {
            funcptr = &f;
        }
    }

    ir_func& func = funcptr ? *funcptr : prog->funcs.emplace_back();
    if (!funcptr) {
        func.index = prog->funcs.size() - 1;
    }

    currentfunc = &func;

    auto mangled_name = node.tdef.mangled_name.str;
    auto orig_name = node.tdef.name.str;

    func.visibility = node.visibility;
    func.demangled_name = orig_name;
    func.ret_type = node.tdef.func.ret_type;
    func.name = mangled_name;

    if (!funcptr && !node.scope.body_node) {
        // First declaration of function is extern
        func.is_extern = true;
        return;
    }
    else if (!node.scope.body_node) {
        // Definition already exists, this was the extern declaration
        return;
    }

    // We have the function definition here
    func.is_extern = false;

    for (auto& arg : node.func_args()) {
        ir_arg_data iarg;
        iarg.type = arg->tid;
        iarg.name = build_identifier_value(arg->var_id()->id_parts);

        arg->local.ir_index = func.args.size();
        func.args.push_back(iarg);
    }
    for (auto& local : node.scope.local_defs) {
        if (local->flags & local_flag::is_argument) continue;

        ir_local_data ilocal;
        ilocal.type = local->self->tid;
        ilocal.name = build_identifier_value(local->self->var_id()->id_parts);

        local->ir_index = func.locals.size();
        func.locals.push_back(ilocal);
    }

    ts->enter_scope(node);
    for (auto& child : node.scope.body_node->children) {
        if (child) {
            generate_ir_node(*child);
        }
    }

    if (node.func.return_statements.empty()) {
        for (std::size_t i = node.ir.scope_defer_statements.size(); i > 0; i--) {
            auto dstmt = node.ir.scope_defer_statements[i - 1];
            generate_ir_defer_stmt(*dstmt->children[0]);
        }
    }

    ts->leave_scope();
}

void generate_for_stmt(ast_node& node) {
    // assign elem to starting value
    generate_ir_node(*node.forinfo.declare_for_iter);
    generate_ir_node(*node.forinfo.declare_elem_to_range_start);

    // check if the elem is still inside the range
    emit(ir_make_label, ir_label{ node.ir.while_cond_label });
    generate_ir_node(*node.forinfo.compare_elem_to_range_end);

    push_control_labels({ node.ir.while_cond_label, node.ir.if_end_label });

    // evaluate the body
    emit(ir_make_label, ir_label{ node.ir.if_body_label });
    generate_ir_node(*node.children[2]);

    // increase the elem
    generate_ir_node(*node.forinfo.increase_elem);

    // jump to elem < range.end
    emit(ir_jmp, ir_label{ node.ir.while_cond_label });

    // end
    emit(ir_make_label, ir_label{ node.ir.if_end_label });

    pop_control_labels();
}

void generate_while_stmt(ast_node& node) {
    emit(ir_make_label, ir_label{ node.ir.while_cond_label });
    generate_ir_node(*node.children[0]);

    push_control_labels({ node.ir.while_cond_label, node.ir.if_end_label });

    emit(ir_make_label, ir_label{ node.ir.if_body_label });
    generate_ir_node(*node.children[1]);

    emit(ir_jmp, ir_label{ node.ir.while_cond_label });

    emit(ir_make_label, ir_label{ node.ir.if_end_label });

    pop_control_labels();
}

void generate_if_stmt(ast_node& node) {
    generate_ir_node(*node.children[0]);

    if (!node.ir.if_body_label.empty()) {
        emit(ir_make_label, ir_label{ node.ir.if_body_label });
    }
    generate_ir_node(*node.children[1]);
    if (node.children.size() == 3) {
        emit(ir_jmp, ir_label{ node.ir.if_end_label });

        emit(ir_make_label, ir_label{ node.ir.if_else_label });
        generate_ir_node(*node.children[2]);

        emit(ir_make_label, ir_label{ node.ir.if_end_label });
    }
    else {
        emit(ir_make_label, ir_label{ node.ir.if_else_label });
    }
}

void generate_ir_continue_stmt(ast_node& node) {
    assert(!ctrl_labels.empty());
    emit(ir_jmp, ir_label{ ctrl_labels.top().continue_label });
}

void generate_ir_break_stmt(ast_node& node) {
    assert(!ctrl_labels.empty());
    emit(ir_jmp, ir_label{ ctrl_labels.top().break_label });
}

std::vector<ast_node*> collect_defer_statements_for_return() {
    std::vector<ast_node*> result;
    auto scope = ts->current_scope;
    while (scope) {
        for (std::size_t i = scope->self->ir.scope_defer_statements.size(); i > 0; i--) {
            auto dstmt = scope->self->ir.scope_defer_statements[i - 1];
            result.push_back(dstmt);
        }

        if (scope->kind == scope_kind::func_body) { break; }

        scope = scope->parent;
    }
    return result;
}

void generate_ir_defer_stmt(ast_node& node) {
    std::size_t begin_opstack_size = operand_stack.size();
    generate_ir_node(node);
    discard_opstack(begin_opstack_size);
}

void generate_ir_return_stmt(ast_node& node) {
    auto defer_stmts = collect_defer_statements_for_return();
    auto& expr = node.children[0];
    if (expr) {
        generate_ir_node(*expr);
        auto val = pop();
        for (auto s : defer_stmts) { generate_ir_defer_stmt(*s->children[0]); }
        temit(ir_return, node.tid, val);
    }
    else {
        for (auto s : defer_stmts) { generate_ir_defer_stmt(*s->children[0]); }
        temit(ir_return, node.tid, 0);
    }
}

void generate_ir_asm_stmt(ast_node& node) {
    emit(ir_asm, std::string{node.string_value});
}

void generate_ir_field_expr(ast_node& node) {
    assert(node.field.self);

    generate_ir_node(*node.field_struct());
    auto a = pop();
    
    if (is_pointer_type(node.field_struct()->tid)) {
        auto stype = node.field_struct()->tid.get().elem_type;
        temit(ir_deref, stype, a);
        push(ir_field{ ir_stackpop{ stype }, node.field.field_index });
    }
    else if (std::holds_alternative<ir_field>(a)) {
        auto stype = node.field_struct()->tid;
        temit(ir_load_addr, node.tid, a);
        push(ir_field{ ir_stackpop{ stype }, node.field.field_index });
    }
    else {
        push(ir_field{ toref(a), node.field.field_index });
    }
}

void generate_ir_index_expr(ast_node& node) {
    generate_ir_node(*node.children[0]);
    auto a = pop();

    if (is_pointer_type(node.children[0]->tid)) {
        auto ptype = node.children[0]->tid.get().elem_type;
        temit(ir_deref, ptype, a);
        a = ir_stackpop{ ptype };
    }

    generate_ir_node(*node.children[1]);
    auto b = pop();

    temit(ir_index, node.tid, a, b);
    push(ir_stackpop{ node.tid });
}

void generate_ir_call_expr(ast_node& node) {
    std::vector<ir_operand> args;

    if (node.call.func_type_id.get().kind == type_kind::func) {
        auto func_node = node.call.func_type_id.get().self;
        if (func_node->func.linkage == func_linkage::external_c) {
            currentfunc->calls_extern_c = true;
        }
        args.push_back(ir_label{ node.call.mangled_name.str });
    }
    else if (node.call.func_type_id.get().kind == type_kind::func_pointer) {
        generate_ir_node(*node.call_func());
        args.push_back(pop());
    }
    else {
        assert(!"generate_ir_call_expr: invalid call func type");
    }

    for (std::size_t i = 0; i < node.call_args().size(); i++) {
        auto& arg = node.call_args()[i];
        generate_ir_node(*arg);
        args.push_back(pop());
    }

    bool pushes = node.tid != ts->void_type;
    if (node.call.flags & call_flag::is_aggregate_return) {
        pushes = false;
    }

    if (pushes) {
        emitops(ir_call, node.tid, args);
        push(ir_stackpop{ node.tid });
    }
    else {
        emitops(ir_call, ts->void_type, args);
    }
}

void generate_ir_func_overload_selector_expr(ast_node& node) {
    temit(ir_load_addr, node.tid, ir_funclabel{ node.call.mangled_name.str, node.tid });
    push(ir_stackpop{ node.tid });
}

void generate_ir_assignment(ast_node& node) {
    if (node.children[0] && node.children[1]) {
        if (is_aggregate_type(node.tid) && node.children[1]->type == ast_type::init_expr) {
            generate_ir_node(*node.children[1]);
        }
        else if (is_aggregate_type(node.tid) && node.tid.get().size > sizeof(std::size_t)) {
            generate_ir_node(*node.children[0]);
            auto dest = pop();

            generate_ir_node(*node.children[1]);
            auto src = pop();

            emit(ir_copy, dest, src, ir_int{ int_type(node.tid.get().size), ts->uintptr_type });
        }
        else {
            generate_ir_node(*node.children[0]);
            auto dest = pop();

            generate_ir_node(*node.children[1]);
            auto src = pop();

            emit(ir_load, dest, src);
        }
    }
}

void generate_ir_binary_expr(ast_node& node) {
    if (token_to_char(node.op) == '=') {
        generate_ir_assignment(node);
        return;
    }

    if (!node.ir.bin_self_label.empty()) {
        emit(ir_make_label, ir_label{ node.ir.bin_self_label });
    }

    if (is_logic_binary_op(node)) {
        generate_ir_node(*node.children[0]);
        generate_ir_node(*node.children[1]);
        return;
    }

    generate_ir_node(*node.children[0]);
    auto a = pop();

    generate_ir_node(*node.children[1]);
    auto b = pop();
    
    switch (token_to_char(node.op)) {
    case '+':
        temit(ir_add, node.tid, a, b);
        push(ir_stackpop{ node.tid });
        break;
    case '-':
        temit(ir_sub, node.tid, a, b);
        push(ir_stackpop{ node.tid });
        break;
    case '*':
        temit(ir_mul, node.tid, a, b);
        push(ir_stackpop{ node.tid });
        break;
    case '/':
        temit(ir_div, node.tid, a, b);
        push(ir_stackpop{ node.tid });
        break;
    case '<':
        if (!node.ir.bin_target_label.empty()) {
            emit((node.ir.bin_invert_jump) ? ir_jmp_gte : ir_jmp_lt, a, b, ir_label{ node.ir.bin_target_label });
        }
        else {
            temit((node.ir.bin_invert_jump) ? ir_cmp_gteq : ir_cmp_lt, node.tid, a, b);
            push(ir_stackpop{ node.tid });
        }
        break;
    case '>':
        if (!node.ir.bin_target_label.empty()) {
            emit((node.ir.bin_invert_jump) ? ir_jmp_lte : ir_jmp_gt, a, b, ir_label{ node.ir.bin_target_label });
        }
        else {
            temit((node.ir.bin_invert_jump) ? ir_cmp_lteq : ir_cmp_gt, node.tid, a, b);
            push(ir_stackpop{ node.tid });
        }
        break;
    case '&':
        temit(ir_and, node.tid, a, b);
        push(ir_stackpop{ node.tid });
        break;
    case '|':
        temit(ir_or, node.tid, a, b);
        push(ir_stackpop{ node.tid });
        break;
    }

    switch (node.op) {
    case token_type::eqeq:
        if (!node.ir.bin_target_label.empty()) {
            emit((node.ir.bin_invert_jump) ? ir_jmp_neq : ir_jmp_eq, a, b, ir_label{ node.ir.bin_target_label });
        }
        else {
            temit((node.ir.bin_invert_jump) ? ir_cmp_neq : ir_cmp_eq, node.tid, a, b);
            push(ir_stackpop{ node.tid });
        }
        break;
    case token_type::neq:
        if (!node.ir.bin_target_label.empty()) {
            emit((node.ir.bin_invert_jump) ? ir_jmp_eq : ir_jmp_neq, a, b, ir_label{ node.ir.bin_target_label });
        }
        else {
            temit((node.ir.bin_invert_jump) ? ir_cmp_eq : ir_cmp_neq, node.tid, a, b);
            push(ir_stackpop{ node.tid });
        }
        break;
    case token_type::lteq:
        if (!node.ir.bin_target_label.empty()) {
            emit((node.ir.bin_invert_jump) ? ir_jmp_gt : ir_jmp_lte, a, b, ir_label{ node.ir.bin_target_label });
        }
        else {
            temit((node.ir.bin_invert_jump) ? ir_cmp_gt : ir_cmp_lteq, node.tid, a, b);
            push(ir_stackpop{ node.tid });
        }
        break;
    case token_type::gteq:
        if (!node.ir.bin_target_label.empty()) {
            emit((node.ir.bin_invert_jump) ? ir_jmp_lt : ir_jmp_gte, a, b, ir_label{ node.ir.bin_target_label });
        }
        else {
            temit((node.ir.bin_invert_jump) ? ir_cmp_lt : ir_cmp_gteq, node.tid, a, b);
            push(ir_stackpop{ node.tid });
        }
        break;
    case token_type::shr:
        temit(ir_shr, node.tid, a, b);
        push(ir_stackpop{ node.tid });
        break;
    case token_type::shl:
        temit(ir_shl, node.tid, a, b);
        push(ir_stackpop{ node.tid });
        break;
    }
}

void generate_ir_deref_expr(ast_node& node) {
    // check if it's a transformed aggregate argument pointer
    if (node.children[0]->type == ast_type::unary_expr && node.children[0]->op == token_from_char('&')) {
        generate_ir_node(*node.children[0]->children[0]);
        return;
    }

    generate_ir_node(*node.children[0]);
    temit(ir_deref, node.tid, pop());
    push(ir_stackpop{ node.tid });
}

void generate_ir_addr_expr(ast_node& node) {
    // check if it's a transformed aggregate argument pointer
    bool noop = node.children[0]->type == ast_type::unary_expr && node.children[0]->op == token_from_char(DEREF_OP);
    noop = noop || (node.children[0]->slice.self != nullptr);
    if (noop) {
        generate_ir_node(*node.children[0]->children[0]);
        return;
    }

    generate_ir_node(*node.children[0]);
    temit(ir_load_addr, node.tid, pop());
    push(ir_stackpop{ node.tid });
}

void generate_ir_unary_expr(ast_node& node) {
    if (token_to_char(node.op) == DEREF_OP) {
        generate_ir_deref_expr(node);
    }
    else if (token_to_char(node.op) == ADDR_OP) {
        generate_ir_addr_expr(node);
    }
    else if (token_to_char(node.op) == '!') {
        if (is_cmp_binary_op(*node.children[0]) && node.children[0]->ir.bin_target_label.empty()) {
            node.children[0]->ir.bin_invert_jump = true;
        }
        generate_ir_node(*node.children[0]);
    }
    else if (token_to_char(node.op) == '-') {
        generate_ir_node(*node.children[0]);
        temit(ir_neg, node.tid, pop());
        push(ir_stackpop{ node.tid });
    }
}

void generate_ir_var(ast_node& node) {
    if (node.op != token_type::let) {
        return;
    }

    if (node.func.linkage != func_linkage::local_carbon) {
        prog->globals.push_back(ir_global_data{
            node.local.mangled_name.str, node.tid, {}, node.func.linkage, node.visibility
        });
        return;
    }

    if (node.var_value()) {
        generate_ir_node(*node.var_value());

        // Check if global
        if (ts->current_scope->kind == scope_kind::code_unit && !node.local.mangled_name.str.empty()) {
            if (is_primary_expr(*node.var_value()) && node.var_value()->type != ast_type::identifier) {
                // TODO: what if it's an identifier ?
                prog->globals.push_back(ir_global_data{
                    node.local.mangled_name.str, node.tid, pop(), func_linkage::local_carbon, node.visibility
                });
                return;
            }
            else if (node.tid.get().kind == type_kind::ptr) {
                prog->globals.push_back(ir_global_data{
                    node.local.mangled_name.str, node.tid, pop(), func_linkage::local_carbon, node.visibility
                });
                return;
            }
            assert(!"generate_ir_var: non primary global");
        }

        // Check noop conditions.
        if (node.var_value()->type == ast_type::init_expr) {
            // Already handled in init list assignments
            return;
        }
        if (node.var_value()->type == ast_type::unary_expr && node.var_value()->children[0]->slice.self) {
            // Mutable slice case, already handled in init list assignments.
            return;
        }

        if (is_aggregate_type(node.tid) && node.tid.get().size > 8) {
            emit(ir_copy, ir_local{ node.local.ir_index, node.tid }, pop(), ir_int{ int_type(node.tid.get().size), ts->uintptr_type });
        }
        else {
            emit(ir_load, ir_local{ node.local.ir_index, node.tid }, pop());
        }
    }
}

void generate_ir_init_expr(ast_node& node) {
    for (auto& assign : node.initlist.assignments) {
        generate_ir_node(*assign);
    }
}

void generate_ir_cast_expr(ast_node& node) {
    generate_ir_node(*node.children[1]);
    if (node.tid.get().size != node.children[1]->tid.get().size && node.children[1]->type != ast_type::int_literal) {
        temit(ir_cast, node.tid, pop());
        push(ir_stackpop{ node.tid });
    }
}

void generate_ir_nullcast_expr(ast_node& node) {
    generate_ir_node(*node.children[1]->children[0]);

#if 0
    auto a = pop();

    push(ir_int{ 0, ts->uintptr_type });
    auto b = pop();

    emit(ir_jmp_neq, a, b, ir_label{ node.ir.if_body_label });

    // TODO: here goes panic code

    emit(ir_make_label, ir_label{ node.ir.if_body_label });
#endif
}

void generate_ir_identifier(ast_node& node) {
    if (node.lvalue.symbol->kind == symbol_kind::comptime) {
        auto value = node.lvalue.symbol->ctvalue;
        auto type = node.lvalue.symbol->cttype;
        if (std::holds_alternative<int_type>(value)) {
            push(ir_int{ std::get<int_type>(value), type });
        }
        return;
    }

    auto local = node.lvalue.symbol->scope->local_defs[node.lvalue.symbol->local_index];
    if (local->flags & local_flag::is_argument) {
        push(ir_arg{ local->ir_index, node.tid });
    }
    else if (node.lvalue.symbol->kind == symbol_kind::global) {
        push(ir_global{ local->mangled_name.str, node.tid });
    }
    else {
        push(ir_local{ local->ir_index, node.tid });
    }
}

void generate_ir_string_literal(ast_node& node) {
    int index = find_or_add_global_string_data(std::string{node.string_value});
    temit(ir_load_addr, ts->raw_string_type, ir_string{index});
    push(ir_stackpop{ ts->raw_string_type });
}

void generate_ir_int_literal(ast_node& node) {
    push(ir_int{ node.int_value, node.tid });
}

void generate_ir_char_literal(ast_node& node) {
    push(char(node.int_value));
}

void generate_ir_node(ast_node& node) {
    if (node.disabled) return;

    for (auto& child : node.pre_nodes) {
        if (child) {
            generate_ir_node(*child);
        }
    }

    switch (node.type) {
    case ast_type::import_decl:
    case ast_type::type_decl:
    case ast_type::type_expr:
    case ast_type::type_constructor_decl:
    case ast_type::ternary_expr:
    case ast_type::error_decl:
        break;
    case ast_type::func_decl:
        if (!node.func.is_generic) {
            generate_ir_func(node);
        }
        break;
    case ast_type::var_decl:
        generate_ir_var(node);
        break;
    case ast_type::for_numeric_stmt:
        ts->enter_scope(node);
        generate_for_stmt(node);
        ts->leave_scope();
        break;
    case ast_type::for_cond_stmt:
        ts->enter_scope(node);
        generate_while_stmt(node);
        ts->leave_scope();
        break;
    case ast_type::if_stmt:
        ts->enter_scope(node);
        generate_if_stmt(node);
        ts->leave_scope();
        break;
    case ast_type::continue_stmt:
        generate_ir_continue_stmt(node);
        break;
    case ast_type::break_stmt:
        generate_ir_break_stmt(node);
        break;
    case ast_type::compound_stmt:
        ts->enter_scope(node);
        generate_ir_children(node);
        for (std::size_t i = node.ir.scope_defer_statements.size(); i > 0; i--) {
            auto dstmt = node.ir.scope_defer_statements[i - 1];
            generate_ir_node(*dstmt->children[0]);
        }
        ts->leave_scope();
        break;
    case ast_type::return_stmt:
        generate_ir_return_stmt(node);
        break;
    case ast_type::defer_stmt:
        ts->current_scope->self->ir.scope_defer_statements.push_back(&node);
        break;
    case ast_type::asm_stmt:
        generate_ir_asm_stmt(node);
        break;
    case ast_type::field_expr:
        generate_ir_field_expr(node);
        break;
    case ast_type::index_expr:
        generate_ir_index_expr(node);
        break;
    case ast_type::call_expr:
        generate_ir_call_expr(node);
        break;
    case ast_type::func_overload_selector_expr:
        generate_ir_func_overload_selector_expr(node);
        break;
    case ast_type::binary_expr:
        generate_ir_binary_expr(node);
        break;
    case ast_type::unary_expr:
        generate_ir_unary_expr(node);
        break;
    case ast_type::init_expr:
        generate_ir_init_expr(node);
        break;
    case ast_type::identifier:
        generate_ir_identifier(node);
        break;
    case ast_type::cast_expr:
        generate_ir_cast_expr(node);
        break;
    case ast_type::nullcast_expr:
        generate_ir_nullcast_expr(node);
        break;
    case ast_type::int_literal:
    case ast_type::bool_literal:
    case ast_type::nil_literal:
        generate_ir_int_literal(node);
        break;
    case ast_type::char_literal:
        generate_ir_char_literal(node);
        break;
    case ast_type::string_literal:
        generate_ir_string_literal(node);
        break;
    case ast_type::stmt_list:
        for (auto& child : node.children) {
            if (child) {
                std::size_t opsize = operand_stack.size();
                generate_ir_node(*child);
                discard_opstack(opsize);
            }
        }
        break;
    default:
        for (auto& child : node.children) {
            if (child) {
                generate_ir_node(*child);
            }
        }
    }
}

void print_ref(std::ostream& f, const ir_ref& opr) {
    if (auto arg = std::get_if<ir_arg>(&opr); arg) {
        f << "A" << arg->index;
    }
    if (auto arg = std::get_if<ir_local>(&opr); arg) {
        f << "L" << arg->index;
    }
    if (auto arg = std::get_if<ir_stackpop>(&opr); arg) {
        f << "POP()";
    }
    if (auto arg = std::get_if<std::shared_ptr<ir_field>>(&opr); arg) {
        auto field = arg->get();
        f << "[";
        print_ref(f, field->ref);
        f << " . " << field->field_index << "]";
    }
}

void print_opr(std::ostream& f, const ir_operand& opr) {
    if (auto str = std::get_if<std::string>(&opr); str) {
        f << *str;
    }
    if (auto lab = std::get_if<ir_label>(&opr); lab) {
        f << lab->name;
    }
    if (auto lab = std::get_if<ir_funclabel>(&opr); lab) {
        f << "func(" << lab->name << ")";
    }
    if (auto arg = std::get_if<ir_field>(&opr); arg) {
        f << "[";
        print_ref(f, arg->ref);
        f << " . " << arg->field_index << "]";
    }
    if (auto arg = std::get_if<ir_arg>(&opr); arg) {
        f << "A" << arg->index;
    }
    if (auto arg = std::get_if<ir_local>(&opr); arg) {
        f << "L" << arg->index;
    }
    if (auto arg = std::get_if<ir_stackpop>(&opr); arg) {
        f << "POP()";
    }
    if (auto arg = std::get_if<ir_string>(&opr); arg) {
        f << "STR" << arg->index;
    }
    if (auto arg = std::get_if<ir_int>(&opr); arg) {
        f << arg->val;
    }
    if (auto arg = std::get_if<ir_float>(&opr); arg) {
        f << arg->val;
    }
    if (auto arg = std::get_if<char>(&opr); arg) {
        f << "#" << (int)*arg;
    }
}

void print_instr(std::ostream& f, const ir_instr& instr) {
    f << opnames[instr.op];
    for (auto& opr : instr.operands) {
        f << " ";
        print_opr(f, opr);
    }
    f << ";";
    if (instr_pushes_to_stack(instr)) {
        f << " (push)";
    }
    f << "\n";
}

void print_ir() {
    std::ofstream f{ "out.ir" };

    for (std::size_t i = 0; i < prog->strings.size(); i++) {
        f << "string #" << i << ": \"" << prog->strings[i] << "\";\n";
    }

    for (std::size_t i = 0; i < prog->funcs.size(); i++) {
        auto& func = prog->funcs[i];
        f << "func " << func.name << " -> " << func.ret_type.get().mangled_name.str << "\n";
        for (std::size_t ai = 0; ai < func.args.size(); ai++) {
            auto& arg = func.args[ai];
            f << "    arg #" << ai << " " << arg.name << ": " << arg.type.get().mangled_name.str << ";\n";
        }
        for (std::size_t ai = 0; ai < func.locals.size(); ai++) {
            auto& arg = func.locals[ai];
            f << "    local #" << ai << " " << arg.name << ": " << arg.type.get().mangled_name.str << ";\n";
        }
        for (std::size_t ai = 0; ai < func.instrs.size(); ai++) {
            auto& instr = func.instrs[ai];
            f << "    ";
            print_instr(f, instr);
        }
        f << "endf\n\n";
    }
}

}

int ref_opstack_consumption(const ir_ref& ref) {
    int i = 0;
    if (std::holds_alternative<ir_stackpop>(ref)) {
        i++;
    }
    else if (std::holds_alternative<std::shared_ptr<ir_field>>(ref)) {
        auto& ptr = std::get<std::shared_ptr<ir_field>>(ref);
        i += ref_opstack_consumption(ptr->ref);
    }
    return i;
}

int operand_opstack_consumption(const ir_operand& opr) {
    int i = 0;
    if (std::holds_alternative<ir_stackpop>(opr)) {
        i++;
    }
    else if (std::holds_alternative<ir_field>(opr)) {
        auto& ptr = std::get<ir_field>(opr);
        i += ref_opstack_consumption(ptr.ref);
    }
    return i;
}

int instr_opstack_consumption(const ir_instr& instr) {
    int i = 0;
    for (const auto& opr : instr.operands) {
        i += operand_opstack_consumption(opr);
    }
    return i;
}

bool instr_pushes_to_stack(const ir_instr& instr) {
    switch (instr.op) {
    case ir_add:
    case ir_sub:
    case ir_mul:
    case ir_div:
    case ir_and:
    case ir_or:
    case ir_shr:
    case ir_shl:
    case ir_deref:
    case ir_index:
    case ir_load_addr:
    case ir_cast:
    case ir_stack_dup:
    case ir_neg:
    case ir_cmp_gt:
    case ir_cmp_lt:
    case ir_cmp_lteq:
    case ir_cmp_gteq:
    case ir_cmp_eq:
    case ir_cmp_neq:
        return true;
    case ir_call:
        return instr.result_type != ts->void_type;
    default:
        return false;
    }
}

bool instr_has_side_effect(const ir_instr& instr) {
    switch (instr.op) {
    case ir_call:
    case ir_stack_dup:
        return true;
    default:
        return false;
    }
}

bool instr_can_be_replaced(const ir_instr& instr) {
    return instr_pushes_to_stack(instr) && (instr_opstack_consumption(instr) == 0) && !instr_has_side_effect(instr);
}

std::string sprint_ir_instr(const ir_instr& instr) {
    std::ostringstream s;
    print_instr(s, instr);
    return s.str();
}

static void opt_replace_duplicates(ir_func& func) {
    for (size_t i = 0; i < func.instrs.size(); i++) {
        auto& self = func.instrs[i];
        int stack_effect = 0;

        for (size_t j = i + 1; j < func.instrs.size(); j++) {
            auto& next = func.instrs[j];

            if (stack_effect != 0) { break; }

            if (self.contents_equal(next) && instr_can_be_replaced(next)) {
                auto newinstr = ir_instr{};
                newinstr.op = ir_stack_dup;
                newinstr.index = j;
                newinstr.result_type = func.instrs[j].result_type;
                func.instrs[j] = newinstr;
            }
            else {
                stack_effect += instr_opstack_consumption(next);
                stack_effect += instr_pushes_to_stack(next) ? 1 : 0;
            }
        }
    }
}

static void optimize_func(ir_func& func) {
    opt_replace_duplicates(func);
}

static void optimize() {
    for (std::size_t i = 0; i < prog->funcs.size(); i++) {
        auto& func = prog->funcs[i];
        optimize_func(func);
    }
}

ir_program generate_ir(type_system& tsystem, ast_node& program_node) {
    ir_program p;
    prog = &p;
    ts = &tsystem;

    for (auto& unit : program_node.children) {
        ts->enter_scope(*unit);
        analyse_node(*unit);
        ts->leave_scope();
    }
    
    for (auto& unit : program_node.children) {
        ts->enter_scope(*unit);
        generate_ir_node(*unit);
        ts->leave_scope();
    }

    if (true) {
        optimize();
    }

    print_ir();

    prog = nullptr;
    //ts = nullptr;
    return p;
}

}