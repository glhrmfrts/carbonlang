#include "ast_manip.hh"
#include "scope.hh"
#include "desugar.hh"

namespace carbon {

static const type_id invalid_type{};

// Section: temp for bool ops

void check_assignment_bool_op(type_system& ts, ast_node& node) {
    if (node.children[1] && is_bool_op(*node.children[1])) {
        node.children[1]->desugar_flags |= desugar_flag::bool_op_desugared;

        auto temp = make_temp_variable_for_bool_op_resolved(ts, std::move(node.children[1]), std::move(node.children[0]));
        node.pre_children.push_back(std::move(temp));
    }
}

void check_assignment_ternary_expr(type_system& ts, ast_node& node) {
    if (node.children[1] && node.children[1]->type == ast_type::ternary_expr) {
        node.children[1]->desugar_flags |= desugar_flag::ternary_desugared;

        auto temp = make_temp_variable_for_ternary_expr_resolved(ts, std::move(node.children[1]), std::move(node.children[0]));
        node.pre_children.push_back(std::move(temp));
    }
}

void check_var_decl_bool_op(type_system& ts, ast_node& node) {
    if (node.var_value() && is_bool_op(*node.var_value())) {
        node.local.flags |= local_flag::is_temp;
        node.var_value()->desugar_flags |= desugar_flag::bool_op_desugared;

        auto idref = make_identifier_node(*ts.ast_arena, {}, node.var_id()->id_parts);
        auto temp = make_temp_variable_for_bool_op_resolved(ts, std::move(node.children[ast_node::child_var_decl_value]), std::move(idref));

        node.pre_children.push_back(std::move(temp));
    }
}

void check_var_decl_ternary_expr(type_system& ts, ast_node& node) {
    if (node.var_value() && node.var_value()->type == ast_type::ternary_expr) {
        node.local.flags |= local_flag::is_temp;
        node.var_value()->desugar_flags |= desugar_flag::ternary_desugared;

        auto idref = make_identifier_node(*ts.ast_arena, {}, node.var_id()->id_parts);
        auto temp = make_temp_variable_for_ternary_expr_resolved(ts, std::move(node.children[ast_node::child_var_decl_value]), std::move(idref));
        
        node.pre_children.push_back(std::move(temp));
    }
}

void check_temp_bool_op(type_system& ts, ast_node& node) {
    if (is_bool_op(node) && !(node.desugar_flags & desugar_flag::bool_op_desugared)) {
        auto cpy = copy_node_typed(ts, node);
        auto [temp, ref] = make_temp_variable_for_bool_op_resolved(ts, std::move(cpy));
        node.desugar_flags |= desugar_flag::bool_op_desugared;

        node.type = ref->type;
        node.type_id = ref->type_id;
        node.lvalue = ref->lvalue;
        node.id_parts = ref->id_parts;
        node.pre_children.push_back(std::move(temp));
    }
}

void check_temp_ternary_expr(type_system& ts, ast_node& node) {
    if (node.type == ast_type::ternary_expr && !(node.desugar_flags & desugar_flag::ternary_desugared)) {
        auto cpy = copy_node_typed(ts, node);
        auto [temp, ref] = make_temp_variable_for_ternary_expr_resolved(ts, std::move(cpy));

        node.type = ref->type;
        node.type_id = ref->type_id;
        node.lvalue = ref->lvalue;
        node.id_parts = ref->id_parts;
        node.pre_children.push_back(std::move(temp));
    }
}

// Section: aggregate arguments/return value

void check_func_arg_aggregate_type(type_system& ts, ast_node& func, int idx) {
    if (is_aggregate_type(func.func_args()[idx]->type_id) && !(func.func_args()[idx]->local.flags & local_flag::is_aggregate_argument)) {
        func.func_args()[idx]->local.flags |= local_flag::is_aggregate_argument;
        update_local_aggregate_argument(ts, *func.func_args()[idx]);
    }
}

void check_call_arg_aggregate_type(type_system &ts, ast_node& call, int idx) {
    if (is_aggregate_type(call.call_args()[idx]->type_id)) {
        auto [temp, ref] = make_temp_variable_for_aggregate_type_resolved(ts, std::move(call.children[ast_node::child_call_expr_arg_list]->children[idx]));
        call.children[ast_node::child_call_expr_arg_list]->children[idx] = std::move(ref);
        call.pre_children.push_back(std::move(temp));
    }
}

void check_func_return_aggregate_type(type_system& ts, ast_node& func) {
    if (is_aggregate_type(func.type_def.func.ret_type)) {
        auto& args = func.func_args();

        auto new_ret_type = get_pointer_type_to(ts, func.type_def.func.ret_type);
        func.children[ast_node::child_func_decl_ret_type] = make_type_resolver_node(*ts.ast_arena, new_ret_type);

        auto arg_decl = make_var_decl_of_type(ts, token_type::var, "$cb_agg_ret", new_ret_type);

        args.insert(args.begin(), std::move(arg_decl));
        declare_func_arguments(ts, func);
        resolve_func_args_type(ts, func);

        for (auto ret : func.func.return_statements) {
            auto agg_ret_id = make_identifier_node(*ts.ast_arena, ret->pos, { "$cb_agg_ret" });
            auto agg_ret_deref = make_deref_expr(ts, std::move(agg_ret_id));
            auto agg_assign = make_assignment(*ts.ast_arena, std::move(agg_ret_deref), std::move(ret->children[0]));
            resolve_node_type_post(ts, agg_assign.get());

            ret->children[0] = make_identifier_node(*ts.ast_arena, ret->pos, { "$cb_agg_ret" });
            resolve_node_type_post(ts, ret);

            ret->pre_children.push_back(std::move(agg_assign));
        }

        clear_func_resolved_state(func);
        func.local.flags |= local_flag::is_aggregate_argument;
    }
}

void transform_aggregate_call_into_pointer_argument_helper(type_system& ts, ast_node& receiver, ast_node* call) {
    auto ref = copy_node(ts, receiver);
    ref->type_id = call->type_id;

    auto addr = make_address_of_expr(ts, std::move(ref));
    addr->type_id = get_pointer_type_to(ts, call->type_id);

    call->call_args().insert(call->call_args().begin(), std::move(addr));

    call->type_id = invalid_type;
    resolve_node_type_post(ts, call);

    call->call.flags |= call_flag::is_aggregate_return;
}

arena_ptr<ast_node> transform_aggregate_call_into_pointer_argument(type_system& ts, ast_node& receiver, arena_ptr<ast_node>&& call) {
    transform_aggregate_call_into_pointer_argument_helper(ts, receiver, call.get());
    return std::move(call);
}

void check_assignment_aggregate_call(type_system& ts, ast_node& node) {
    if (is_aggregate_type(node.type_id) && node.bin_right() && node.bin_right()->type == ast_type::call_expr) {
        auto call = transform_aggregate_call_into_pointer_argument(ts, *node.bin_left(), std::move(node.children[1]));
        node.pre_children.push_back(std::move(call));
    }
}

void check_var_decl_aggregate_call(type_system& ts, ast_node& node) {
    if (is_aggregate_type(node.type_id) && node.var_value() && node.var_value()->type == ast_type::call_expr) {
        auto call = transform_aggregate_call_into_pointer_argument(ts, *node.var_id(), std::move(node.children[ast_node::child_var_decl_value]));
        node.pre_children.push_back(std::move(call));
    }
}

void check_temp_aggregate_call(type_system& ts, ast_node& node) {
    if (is_aggregate_type(node.type_id) && !(node.call.flags & call_flag::is_aggregate_return)) {
        auto tempname = generate_temp_name();
        auto temp = make_var_decl_of_type(ts, token_type::var, tempname, node.type_id);
        resolve_node_type_post(ts, temp.get());

        auto ref = make_identifier_node(*ts.ast_arena, node.pos, { tempname });
        ref->type_id = node.type_id;

        transform_aggregate_call_into_pointer_argument_helper(ts, *ref, &node);

        node.temps.push_back(std::move(temp));
    }
}

void desugar(type_system& ts, ast_node* nodeptr) {
    if (!nodeptr) return;

    auto& node = *nodeptr;
    switch (node.type) {
    case ast_type::for_stmt: {
        enter_scope_local(ts, node);
        visit_tree(ts, *node.forinfo.declare_for_iter);
        visit_tree(ts, *node.forinfo.declare_elem_to_range_start);
        visit_tree(ts, *node.forinfo.compare_elem_to_range_end);
        visit_tree(ts, *node.forinfo.increase_elem);
        visit_tree(ts, *node.children[ast_node::child_for_stmt_body]);
        leave_scope_local(ts);
        break;
    }
    case ast_type::if_stmt:
    case ast_type::while_stmt:
    case ast_type::compound_stmt: {        
        if (node.scope.self) {
            enter_scope_local(ts, node);
            visit_pre_children(ts, node);
            visit_children(ts, node);
            leave_scope_local(ts);
        }
        else {
            visit_pre_children(ts, node);
            visit_children(ts, node);
        }
        break;
    }
    case ast_type::func_decl: {
        if (node.scope.body_node) { enter_scope_local(ts, node); }

        for (int i = 0; i < node.func_args().size(); i++) {
            check_func_arg_aggregate_type(ts, node, i);
        }
        check_func_return_aggregate_type(ts, node);

        visit_children(ts, node);
        if (node.scope.body_node) { leave_scope_local(ts); }

        resolve_func_type(ts, node);
        break;
    }
    case ast_type::call_expr: {
        for (int i = 0; i < node.call_args().size(); i++) {
            check_call_arg_aggregate_type(ts, node, i);
            check_temp_bool_op(ts, *(node.call_args()[i]));
            check_temp_ternary_expr(ts, *(node.call_args()[i]));
        }

        visit_pre_children(ts, node);
        visit_children(ts, node);

        if (ts.subpass == 1) {
            check_temp_aggregate_call(ts, node);
        }
        break;
    }
    case ast_type::init_expr: {
        for (auto& as : node.initlist.assignments) {
            visit_tree(ts, *as);
        }
        visit_pre_children(ts, node);
        break;
    }
    case ast_type::binary_expr: {
        if (token_to_char(node.op) == '=') {
            check_assignment_bool_op(ts, node);
            check_assignment_ternary_expr(ts, node);
        }
        else {
            for (int i = 0; i < 2; i++) {
                check_temp_ternary_expr(ts, *node.children[i]);
                if (!is_bool_op(node)) {
                    check_temp_bool_op(ts, *node.children[i]);
                }
            }
        }

        visit_pre_children(ts, node);
        visit_children(ts, node);

        if (token_to_char(node.op) == '=') {
            check_assignment_aggregate_call(ts, node);
        }
        else {
            for (int i = 0; i < 2; i++) {
                check_temp_aggregate_call(ts, *node.children[i]);
            }
        }
        break;
    }
    case ast_type::ternary_expr: {
        check_temp_ternary_expr(ts, *node.children[1]);
        check_temp_bool_op(ts, *node.children[1]);
        check_temp_ternary_expr(ts, *node.children[2]);
        check_temp_bool_op(ts, *node.children[2]);
        visit_pre_children(ts, node);
        visit_children(ts, node);
        break;
    }
    case ast_type::var_decl: {
        check_var_decl_bool_op(ts, node);
        check_var_decl_ternary_expr(ts, node);
        visit_pre_children(ts, node);
        visit_children(ts, node);
        check_var_decl_aggregate_call(ts, node);
        break;
    }
    case ast_type::return_stmt: {
        if (node.children[0]) { 
            check_temp_bool_op(ts, *node.children[0]);
            check_temp_ternary_expr(ts, *node.children[0]);
        }
        visit_pre_children(ts, node);
        visit_children(ts, node);
        break;
    }
    default: {
        visit_pre_children(ts, node);
        visit_children(ts, node);
        break;
    }
    }
}

}