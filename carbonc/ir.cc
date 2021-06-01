#include "ir.hh"
#include "ast.hh"
#include <stack>
#include <fstream>

namespace carbon {

namespace {

static const std::string opnames[] = {
    "ir_load",
    "ir_add",
    "ir_sub",
    "ir_mul",
    "ir_div",
    "ir_call",
    "ir_return",
    "ir_index",
    "ir_deref",
    "ir_load_addr",
    "ir_make_label",
    "ir_asm",
    "ir_jmp",
    "ir_jmp_eq",
    "ir_jmp_neq",
    "ir_jmp_gt",
    "ir_jmp_gte",
    "ir_jmp_lt",
    "ir_jmp_lte",
};

static ir_program* prog;
static ir_func* fn;
static type_system* ts;
static std::stack<ir_operand> operand_stack;
static std::unordered_map<std::string, int> string_map;

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

template <typename... Args> void emit(ir_op op, Args&&... args) {
    fn->instrs.push_back({ op, {}, std::vector<ir_operand>{ std::forward<Args>(args)... }, (int)fn->instrs.size() });
}

template <typename... Args> void temit(ir_op op, type_id t, Args&&... args) {
    fn->instrs.push_back({ op, t, std::vector<ir_operand>{ std::forward<Args>(args)... }, (int)fn->instrs.size() });
}

void emitops(ir_op op, type_id t, const std::vector<ir_operand>& args) {
    fn->instrs.push_back({ op, t, args, (int)fn->instrs.size() });
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
    if (auto arg = std::get_if<ir_stack>(&opr); arg) {
        return *arg;
    }
}

// Section: analysis

std::string generate_label_for_short_circuit(ast_node& node) {
    auto scope = ts->find_nearest_scope(scope_kind::func_body);
    auto& funcname = scope->self->type_def.mangled_name.str;
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
    case ast_type::for_stmt: {
        auto scope = ts->find_nearest_scope(scope_kind::func_body);
        auto& funcname = scope->self->type_def.mangled_name.str;

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
    case ast_type::while_stmt: {
        auto scope = ts->find_nearest_scope(scope_kind::func_body);
        auto& funcname = scope->self->type_def.mangled_name.str;

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
        auto& funcname = scope->self->type_def.mangled_name.str;

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

        analyse_children(node);

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
    ir_func& func = prog->funcs.emplace_back();
    func.index = prog->funcs.size() - 1;
    fn = &func;

    auto name = node.type_def.mangled_name.str;

    func.ret_type = node.func.ret_type_node->type_id;

    if (!node.scope.body_node) {
        func.name = name;
        func.is_extern = true;
        return;
    }

    if (node.local.id_node->id_parts.front() == "main") {
        func.name = node.local.id_node->id_parts.front();
    }
    else {
        func.name = name;
    }

    for (auto arg : node.func.arguments) {
        ir_arg_data iarg;
        iarg.type = arg->type_id;
        iarg.name = build_identifier_value(arg->local.id_node->id_parts);

        arg->local.ir_index = func.args.size();
        func.args.push_back(iarg);
    }
    for (auto& local : node.scope.local_defs) {
        if (local->is_argument) continue;

        ir_local_data ilocal;
        ilocal.type = local->self->type_id;
        ilocal.name = build_identifier_value(local->id_node->id_parts);

        local->ir_index = func.locals.size();
        func.locals.push_back(ilocal);
    }

    ts->enter_scope(node);
    for (auto& child : node.scope.body_node->children) {
        if (child) {
            generate_ir_node(*child);
        }
    }
    ts->leave_scope();
}

void generate_for_stmt(ast_node& node) {
    // assign elem to starting value
    generate_ir_node(*node.forinfo.declare_for_iter);
    generate_ir_node(*node.forinfo.assign_elem_to_range_start);

    // check if the elem is still inside the range
    emit(ir_make_label, ir_label{ node.ir.while_cond_label });
    generate_ir_node(*node.forinfo.compare_elem_to_range_end);

    // evaluate the body
    emit(ir_make_label, ir_label{ node.ir.if_body_label });
    generate_ir_node(*node.children[2]);

    // increase the elem
    generate_ir_node(*node.forinfo.increase_elem);

    // jump to elem < range.end
    emit(ir_jmp, ir_label{ node.ir.while_cond_label });

    // end
    emit(ir_make_label, ir_label{ node.ir.if_end_label });
}

void generate_while_stmt(ast_node& node) {
    emit(ir_make_label, ir_label{ node.ir.while_cond_label });
    generate_ir_node(*node.children[0]);

    emit(ir_make_label, ir_label{ node.ir.if_body_label });
    generate_ir_node(*node.children[1]);

    emit(ir_jmp, ir_label{ node.ir.while_cond_label });

    emit(ir_make_label, ir_label{ node.ir.if_end_label });
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

void generate_ir_return_stmt(ast_node& node) {
    auto& expr = node.children[0];
    if (expr) {
        generate_ir_node(*expr);
        emit(ir_return, pop());
    }
    else {
        emit(ir_return, 0);
    }
}

void generate_ir_asm_stmt(ast_node& node) {
    emit(ir_asm, std::string{node.string_value});
}

void generate_ir_field_expr(ast_node& node) {
    generate_ir_node(*node.children[0]);
    auto a = pop();
    
    if (node.field.needs_deref) {
        auto stype = node.field.struct_node->type_id.get().elem_type;
        temit(ir_deref, stype, a);
        push(ir_field{ ir_stack{ stype }, node.field.field_index });
    }
    else {
        push(ir_field{ toref(a), node.field.field_index });
    }
}

void generate_ir_index_expr(ast_node& node) {
    generate_ir_node(*node.children[1]);
    generate_ir_node(*node.children[0]);

    auto a = pop();
    auto b = pop();
    temit(ir_index, node.type_id, a, b);
    push(ir_stack{ node.type_id });
}

void generate_ir_call_expr(ast_node& node) {
    auto func_node = node.call.func_type_id.get().self;
    if (func_node->func.linkage == func_linkage::external_c) {
        fn->calls_extern_c = true;
    }

    std::vector<ir_operand> args;
    args.push_back(ir_label{ node.call.mangled_name.str });

    for (std::size_t i = 0; i < node.call.args.size(); i++) {
        auto arg = node.call.args[i];
        generate_ir_node(*arg);
        args.push_back(pop());
    }

    emitops(ir_call, node.type_id, args);
    push(ir_stack{ node.type_id });
}

void generate_ir_deref_expr(ast_node& node) {
    generate_ir_node(*node.children[0]);
    temit(ir_deref, node.type_id, pop());
    push(ir_stack{ node.type_id });
}

void generate_ir_addr_expr(ast_node& node) {
    generate_ir_node(*node.children[0]);
    temit(ir_load_addr, node.type_id, pop());
    push(ir_stack{ node.type_id });
}

void generate_ir_assignment(ast_node& node) {
    if (node.children[0] && node.children[1]) {
        if (is_aggregate_type(node.type_id) && node.children[1]->type == ast_type::init_expr) {
            generate_ir_node(*node.children[1]);
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
        temit(ir_add, node.type_id, a, b);
        push(ir_stack{ node.type_id });
        break;
    case '-':
        temit(ir_sub, node.type_id, a, b);
        push(ir_stack{ node.type_id });
        break;
    case '*':
        temit(ir_mul, node.type_id, a, b);
        push(ir_stack{ node.type_id });
        break;
    case '/':
        temit(ir_div, node.type_id, a, b);
        push(ir_stack{ node.type_id });
        break;
    case '<':
        emit((node.ir.bin_invert_jump) ? ir_jmp_gte : ir_jmp_lt, a, b, ir_label{node.ir.bin_target_label});
        break;
    case '>':
        emit((node.ir.bin_invert_jump) ? ir_jmp_lte : ir_jmp_gt, a, b, ir_label{node.ir.bin_target_label});
        break;
    }

    switch (node.op) {
    case token_type::eqeq:
        emit((node.ir.bin_invert_jump) ? ir_jmp_neq : ir_jmp_eq, a, b, ir_label{ node.ir.bin_target_label });
        break;
    case token_type::neq:
        emit((node.ir.bin_invert_jump) ? ir_jmp_eq : ir_jmp_neq, a, b, ir_label{ node.ir.bin_target_label });
        break;
    case token_type::lteq:
        emit((node.ir.bin_invert_jump) ? ir_jmp_gt : ir_jmp_lte, a, b, ir_label{ node.ir.bin_target_label });
        break;
    case token_type::gteq:
        emit((node.ir.bin_invert_jump) ? ir_jmp_lt : ir_jmp_gte, a, b, ir_label{ node.ir.bin_target_label });
        break;
    }
}

void generate_ir_unary_expr(ast_node& node) {
    if (token_to_char(node.op) == '*') {
        generate_ir_deref_expr(node);
    }
    else if (token_to_char(node.op) == '&') {
        generate_ir_addr_expr(node);
    }
    else if (token_to_char(node.op) == '!') {
        generate_ir_node(*node.children[0]);
    }
}

void generate_ir_var(ast_node& node) {
    if (node.local.value_node) {
        generate_ir_node(*node.local.value_node);
        
        if (!(is_aggregate_type(node.local.value_node->type_id) && node.local.value_node->type == ast_type::init_expr)) {
            emit(ir_load, ir_local{ node.local.ir_index }, pop());
        }
    }
}

void generate_ir_init_expr(ast_node& node) {
    for (auto& assign : node.initlist.assignments) {
        generate_ir_node(*assign);
    }
}

void generate_ir_identifier(ast_node& node) {
    auto local = node.lvalue.symbol->scope->local_defs[node.lvalue.symbol->local_index];
    if (local->is_argument) {
        push(ir_arg{ local->ir_index });
    }
    else {
        push(ir_local{ local->ir_index });
    }
}

void generate_ir_string_literal(ast_node& node) {
    int index = find_or_add_global_string_data(std::string{node.string_value});
    temit(ir_load_addr, ts->raw_string_type, ir_string{index});
    push(ir_stack{ ts->raw_string_type });
}

void generate_ir_int_literal(ast_node& node) {
    push(ir_int{ node.int_value, node.type_id });
}

void generate_ir_char_literal(ast_node& node) {
    push(char(node.int_value));
}

void generate_ir_node(ast_node& node) {
    for (auto& child : node.pre_children) {
        if (child) {
            generate_ir_node(*child);
        }
    }

    switch (node.type) {
    case ast_type::import_decl:
    case ast_type::type_expr:
        break;
    case ast_type::func_decl:
        generate_ir_func(node);
        break;
    case ast_type::var_decl:
        generate_ir_var(node);
        break;
    case ast_type::for_stmt:
        generate_for_stmt(node);
        break;
    case ast_type::while_stmt:
        generate_while_stmt(node);
        break;
    case ast_type::if_stmt:
        generate_if_stmt(node);
        break;
    case ast_type::return_stmt:
        generate_ir_return_stmt(node);
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
    case ast_type::int_literal:
    case ast_type::bool_literal:
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
                generate_ir_node(*child);
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

void print_ref(std::ofstream& f, ir_ref& opr) {
    if (auto arg = std::get_if<ir_arg>(&opr); arg) {
        f << "A" << arg->index;
    }
    if (auto arg = std::get_if<ir_local>(&opr); arg) {
        f << "L" << arg->index;
    }
    if (auto arg = std::get_if<ir_stack>(&opr); arg) {
        f << "ST";
    }
}

void print_opr(std::ofstream& f, ir_operand& opr) {
    if (auto str = std::get_if<std::string>(&opr); str) {
        f << *str;
    }
    if (auto lab = std::get_if<ir_label>(&opr); lab) {
        f << lab->name;
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
    if (auto arg = std::get_if<ir_stack>(&opr); arg) {
        f << "ST";
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
        f << "'" << *arg << "'";
    }
}

void print_instr(std::ofstream& f, ir_instr& instr) {
    f << opnames[instr.op];
    for (auto& opr : instr.operands) {
        f << " ";
        print_opr(f, opr);
    }
    f << ";\n";
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

    print_ir();

    prog = nullptr;
    ts = nullptr;
    return p;
}

}