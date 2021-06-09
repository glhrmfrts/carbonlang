#include <cassert>
#include "ast_manip.hh"

namespace carbon {

void resolve_node_type_post(type_system& ts, ast_node* nodeptr) {
    auto prevpass = ts.pass;
    ts.pass = type_system_pass::perform_checks;
    resolve_node_type(ts, nodeptr);
    ts.pass = prevpass;
}

arena_ptr<ast_node> make_var_decl_with_value(memory_arena& ast_arena, std::string varname, arena_ptr<ast_node>&& value) {
    auto res = make_var_decl_node(ast_arena, {}, token_type::var, make_identifier_node(ast_arena, {}, { varname }), { nullptr, nullptr }, std::move(value));
    res->local.self = res.get();
    return res;
}

arena_ptr<ast_node> make_assignment(memory_arena& ast_arena, arena_ptr<ast_node>&& dest, arena_ptr<ast_node>&& value) {
    return make_binary_expr_node(ast_arena, {}, token_from_char('='), std::move(dest), std::move(value));
}

arena_ptr<ast_node> make_struct_field_access(memory_arena& ast_arena, arena_ptr<ast_node>&& st, std::string field) {
    return make_field_expr_node(ast_arena, {}, std::move(st), make_identifier_node(ast_arena, {}, { field }));
}

arena_ptr<ast_node> make_index_access(memory_arena& ast_arena, arena_ptr<ast_node>&& st, int idx) {
    return make_index_expr_node(ast_arena, {}, std::move(st), make_int_literal_node(ast_arena, {}, idx));
}

arena_ptr<ast_node> make_address_of_expr(type_system& ts, arena_ptr<ast_node>&& expr) {
    return make_unary_expr_node(*ts.ast_arena, expr->pos, token_from_char('&'), std::move(expr));
}

arena_ptr<ast_node> make_deref_expr(type_system& ts, arena_ptr<ast_node>&& expr) {
    return make_unary_expr_node(*ts.ast_arena, expr->pos, token_from_char('*'), std::move(expr));
}

arena_ptr<ast_node> copy_var_ref(type_system& ts, ast_node& node) {
    if (node.type == ast_type::identifier) {
        return make_identifier_node(*ts.ast_arena, node.pos, node.id_parts);
    }
    else if (node.type == ast_type::field_expr) {
        return make_field_expr_node(*ts.ast_arena, node.pos, copy_var_ref(ts, *node.children[0]), copy_var_ref(ts, *node.children[1]));
    }
    else if (node.type == ast_type::unary_expr && token_to_char(node.op) == '*') {
        return make_deref_expr(ts, copy_var_ref(ts, *node.children[0]));
    }
    assert(!"copy_var_ref: node type not handled!");
    return { nullptr, nullptr };
}

// TODO: obviously need better stuff here
static int temp_count = 0;

std::string generate_temp_name() {
    return "$cbT" + std::to_string(temp_count++);
}

arena_ptr<ast_node> transform_bool_op_into_if_statement(type_system& ts, arena_ptr<ast_node>&& bop, ast_node& destvar) {
    auto true_node = make_bool_literal_node(*ts.ast_arena, {}, true);
    auto false_node = make_bool_literal_node(*ts.ast_arena, {}, false);
    auto assign_true = make_binary_expr_node(*ts.ast_arena, {}, token_from_char('='), copy_var_ref(ts, destvar), std::move(true_node));
    auto assign_false = make_binary_expr_node(*ts.ast_arena, {}, token_from_char('='), copy_var_ref(ts, destvar), std::move(false_node));
    return make_if_stmt_node(*ts.ast_arena, bop->pos, std::move(bop), std::move(assign_true), std::move(assign_false));
}

std::pair<arena_ptr<ast_node>, arena_ptr<ast_node>> make_temp_variable_for_call_resolved(type_system& ts, ast_node& call) {
    // generate the temp ID
    std::string tempname = generate_temp_name();
    auto id_node = make_identifier_node(*ts.ast_arena, {}, { tempname });

    auto val_node = make_call_expr_node(*ts.ast_arena, {}, std::move(call.children[ast_node::child_call_expr_callee]), std::move(call.children[ast_node::child_call_expr_arg_list]));
    // The call might have a pre-children of itself
    val_node->pre_children = std::move(call.pre_children);

    // Generate and register the declaration of the temp
    auto decl = make_var_decl_node(*ts.ast_arena, {}, token_type::let, std::move(id_node), { nullptr, nullptr }, std::move(val_node));
    resolve_node_type_post(ts, decl.get());

    // Make a reference to use as the new argument
    auto ref = make_identifier_node(*ts.ast_arena, {}, { tempname });
    resolve_node_type_post(ts, ref.get());

    return std::make_pair(std::move(decl), std::move(ref));
}

std::pair<arena_ptr<ast_node>, arena_ptr<ast_node>> make_temp_variable_for_index_expr_resolved(type_system& ts, arena_ptr<ast_node>&& lhs) {
    // generate the temp ID
    std::string tempname = generate_temp_name();
    auto id_node = make_identifier_node(*ts.ast_arena, {}, { tempname });

    // Generate and register the declaration of the temp
    auto decl = make_var_decl_node(*ts.ast_arena, {}, token_type::let, std::move(id_node), { nullptr, nullptr }, std::move(lhs));
    resolve_node_type_post(ts, decl.get());

    // Make a reference to use as the new argument
    auto ref = make_identifier_node(*ts.ast_arena, {}, { tempname });
    resolve_node_type_post(ts, ref.get());

    return std::make_pair(std::move(decl), std::move(ref));
}

// generates something like:
// var temp: bool;
// if ($expr) temp = true; else temp = false;
// 
// returns the if statement and a reference to temp
std::pair<arena_ptr<ast_node>, arena_ptr<ast_node>> make_temp_variable_for_bool_op_resolved(type_system& ts, arena_ptr<ast_node>&& expr) {
    // generate the temp ID
    std::string tempname = generate_temp_name();
    auto id_node = make_identifier_node(*ts.ast_arena, {}, { tempname });
    auto type_node = make_type_expr_node(*ts.ast_arena, {}, make_identifier_node(*ts.ast_arena, {}, { "bool" }));

    // Generate and register the declaration of the temp
    auto decl = make_var_decl_node(*ts.ast_arena, {}, token_type::var, std::move(id_node), std::move(type_node), { nullptr, nullptr });
    resolve_node_type_post(ts, decl.get());

    // Make a reference to use as the new argument
    auto ref = make_identifier_node(*ts.ast_arena, {}, { tempname });
    resolve_node_type_post(ts, ref.get());

    // Make the if statement
    auto ifstmt = transform_bool_op_into_if_statement(ts, std::move(expr), *ref);
    resolve_node_type_post(ts, ifstmt.get());

    ifstmt->temps.push_back(std::move(decl));

    return std::make_pair(std::move(ifstmt), std::move(ref));
}

// generates something like:
// if ($expr) $receiver = true; else $receiver = false;
// 
// returns the if statement
arena_ptr<ast_node> make_temp_variable_for_bool_op_resolved(type_system& ts, arena_ptr<ast_node>&& expr, arena_ptr<ast_node>&& receiver) {
    // Make the if statement
    auto ifstmt = transform_bool_op_into_if_statement(ts, std::move(expr), *receiver);
    resolve_node_type_post(ts, ifstmt.get());

    return std::move(ifstmt);
}

arena_ptr<ast_node> make_var_decl_of_type(type_system& ts, token_type kind, const std::string& name, type_id tid) {
    auto id_node = make_identifier_node(*ts.ast_arena, {}, { name });
    auto type_node = make_type_resolver_node(*ts.ast_arena, tid);

    auto res = make_var_decl_node(*ts.ast_arena, {}, kind, std::move(id_node), std::move(type_node), { nullptr, nullptr });
    res->local.self = res.get();
    return res;
}

std::pair<arena_ptr<ast_node>, arena_ptr<ast_node>> make_temp_variable_for_aggregate_type_resolved(type_system& ts, arena_ptr<ast_node>&& expr) {
    auto pos = expr->pos;
    auto tempname = generate_temp_name();
    auto decl = make_var_decl_with_value(*ts.ast_arena, tempname, std::move(expr));
    resolve_node_type_post(ts, decl.get());

    auto ref = make_address_of_expr(ts, make_identifier_node(*ts.ast_arena, pos, { tempname }));
    resolve_node_type_post(ts, ref.get());

    return std::make_pair(std::move(decl), std::move(ref));
}

std::optional<std::size_t> find_child_index(ast_node* parent, ast_node* child) {
    std::size_t i = 0;
    for (auto& ch : parent->children) {
        if (ch.get() == child) {
            return i;
        }
        i++;
    }
    return {};
}

void parent_tree(ast_node& node) {
    for (auto& child : node.children) {
        if (child) {
            child->parent = &node;
            parent_tree(*child);
        }
    }
}

}