#include <cassert>
#include "ast_manip.hh"

namespace carbon {

void resolve_node_type_post(type_system& ts, ast_node* nodeptr) {
    auto prevpass = ts.pass;
    ts.pass = type_system_pass::perform_checks;

    int prevsubpass = ts.subpass;
    ts.subpass = DESUGAR_SUBPASS;

    resolve_node_type(ts, nodeptr);
    ts.pass = prevpass;
    ts.subpass = prevsubpass;
}

arena_ptr<ast_node> make_var_decl_with_value(memory_arena& ast_arena, std::string varname, arena_ptr<ast_node> value) {
    // TODO: modifiers
    auto res = make_var_decl_node_single(ast_arena, {}, token_type::let, make_identifier_node(ast_arena, {}, { varname }), { nullptr, nullptr }, std::move(value), {});
    res->local.self = res.get();
    return res;
}

arena_ptr<ast_node> make_assignment(memory_arena& ast_arena, arena_ptr<ast_node> dest, arena_ptr<ast_node> value) {
    auto pos = dest->pos;
    return make_assign_stmt_node(ast_arena, pos, std::move(dest), std::move(value));
}

arena_ptr<ast_node> make_struct_field_access(memory_arena& ast_arena, arena_ptr<ast_node> st, std::string field) {
    return make_field_expr_node(ast_arena, {}, std::move(st), make_identifier_node(ast_arena, {}, { field }));
}

arena_ptr<ast_node> make_index_access(memory_arena& ast_arena, arena_ptr<ast_node> st, int idx) {
    return make_index_expr_node(ast_arena, {}, std::move(st), make_int_literal_node(ast_arena, {}, idx));
}

arena_ptr<ast_node> make_address_of_expr(type_system& ts, arena_ptr<ast_node> expr) {
    return make_unary_expr_node(*ts.ast_arena, expr->pos, token_from_char(ADDR_OP), std::move(expr));
}

arena_ptr<ast_node> make_deref_expr(type_system& ts, arena_ptr<ast_node> expr) {
    return make_unary_expr_node(*ts.ast_arena, expr->pos, token_from_char(DEREF_OP), std::move(expr));
}

arena_ptr<ast_node> copy_node_helper(type_system& ts, ast_node& node) {
    if (node.type == ast_type::identifier) {
        auto ident = make_identifier_node(*ts.ast_arena, node.pos, node.id_parts);
        ident->lvalue = node.lvalue;
        return ident;
    }
    else if (node.type == ast_type::init_tag) {
        return make_init_tag_node(*ts.ast_arena, node.pos, node.op);
    }
    else if (node.type == ast_type::nil_literal) {
        return make_nil_node(*ts.ast_arena, node.pos);
    }
    else if (node.type == ast_type::bool_literal) {
        return make_bool_literal_node(*ts.ast_arena, node.pos, (bool)node.int_value);
    }
    else if (node.type == ast_type::char_literal) {
        return make_char_literal_node(*ts.ast_arena, node.pos, node.int_value);
    }
    else if (node.type == ast_type::int_literal) {
        return make_int_literal_node(*ts.ast_arena, node.pos, node.int_value);
    }
    else if (node.type == ast_type::float_literal) {
        return make_float_literal_node(*ts.ast_arena, node.pos, node.float_value);
    }
    else if (node.type == ast_type::string_literal) {
        auto str = std::string{ node.string_value };
        return make_string_literal_node(*ts.ast_arena, node.pos, std::move(str));
    }
    else if (node.type == ast_type::field_expr) {
        auto field = make_field_expr_node(*ts.ast_arena, node.pos, copy_node(ts, node.children[0].get()), copy_node(ts, node.children[1].get()));
        field->field = node.field;
        return field;
    }
    else if (node.type == ast_type::index_expr) {
        return make_index_expr_node(*ts.ast_arena, node.pos, copy_node(ts, node.children[0].get()), copy_node(ts, node.children[1].get()));
    }
    else if (node.type == ast_type::unary_expr) {
        return make_unary_expr_node(*ts.ast_arena, node.pos, node.op, copy_node(ts, node.children[0].get()));
    }
    else if (node.type == ast_type::binary_expr) {
        return make_binary_expr_node(*ts.ast_arena, node.pos, node.op, copy_node(ts, node.children[0].get()), copy_node(ts, node.children[1].get()));
    }
    else if (node.type == ast_type::ternary_expr) {
        return make_ternary_expr_node(*ts.ast_arena, node.pos, copy_node(ts, node.children[0].get()), copy_node(ts, node.children[1].get()), copy_node(ts, node.children[2].get()));
    }
    else if (node.type == ast_type::cast_expr) {
        return make_cast_expr_node(*ts.ast_arena, node.pos, copy_node(ts, node.children[0].get()), copy_node(ts, node.children[1].get()));
    }
    else if (node.type == ast_type::init_expr) {
        auto initexpr = make_init_expr_node(*ts.ast_arena, node.pos, copy_node(ts, node.children[0].get()), copy_node(ts, node.children[1].get()));
        initexpr->initlist = node.initlist;
        return initexpr;
    }
    else if (node.type == ast_type::type_resolver) {
        return make_type_resolver_node(*ts.ast_arena, node.tid);
    }
    else if (node.type == ast_type::type_expr) {
        return make_type_expr_node(*ts.ast_arena, node.pos, copy_node(ts, node.children[0].get()));
    }
    else if (node.type == ast_type::const_expr) {
        return make_const_expr_node(*ts.ast_arena, node.pos, copy_node(ts, node.children[0].get()));
    }
    else if (node.type == ast_type::type_qualifier) {
        return make_type_qualifier_node(*ts.ast_arena, node.pos, node.type_qual, copy_node(ts, node.children[0].get()));
    }
    else if (node.type == ast_type::struct_type) {
        return make_struct_type_node(*ts.ast_arena, node.pos, copy_node(ts, node.children[0].get()));
    }
    else if (node.type == ast_type::static_array_type) {
        return make_static_array_type_node(*ts.ast_arena, node.pos, copy_node(ts, node.children[0].get()), copy_node(ts, node.children[1].get()));
    }
    else if (node.type == ast_type::array_type) {
        return make_array_type_node(*ts.ast_arena, node.pos, copy_node(ts, node.children[0].get()));
    }
    else if (node.type == ast_type::array_view_type) {
        return make_array_view_type_node(*ts.ast_arena, node.pos, copy_node(ts, node.children[0].get()));
    }
    else if (node.type == ast_type::type_constructor_instance) {
        return make_type_constructor_instance_node(*ts.ast_arena, node.pos,
            copy_node(ts, node.children[0].get()),
            copy_node(ts, node.children[1].get()));
    }
    else if (node.type == ast_type::var_decl) {
        auto var_decl = make_var_decl_node(*ts.ast_arena, node.pos, node.op,
            copy_node(ts, node.children[0].get()),
            copy_node(ts, node.children[1].get()),
            copy_node(ts, node.children[2].get()),
            node.var_modifiers);
        var_decl->local = node.local;
        return var_decl;
    }
    else if (node.type == ast_type::func_decl) {
        return make_func_decl_node(*ts.ast_arena, node.pos,
            copy_node(ts, node.children[0].get()),
            copy_node(ts, node.children[1].get()),
            copy_node(ts, node.children[2].get()),
            copy_node(ts, node.children[3].get()),
            node.func.raises,
            node.func.linkage);
    }
    else if (node.type == ast_type::call_expr) {
        auto call = make_call_expr_node(*ts.ast_arena, node.pos,
            copy_node(ts, node.children[0].get()),
            copy_node(ts, node.children[1].get()));

        call->call = node.call;
        return call;
    }
    else if (node.type == ast_type::builtin_call_expr) {
        auto call = make_call_expr_node(*ts.ast_arena, node.pos,
            copy_node(ts, node.children[0].get()),
            copy_node(ts, node.children[1].get()));

        call->type = ast_type::builtin_call_expr;
        return call;
    }
    else if (node.type == ast_type::rest_expr) {
        auto rest = make_rest_expr_node(*ts.ast_arena, node.pos, copy_node(ts, node.children[0].get()));
        return rest;
    }
    else if (node.type == ast_type::func_overload_selector_expr) {
        auto ov = make_func_overload_selector_expr_node(*ts.ast_arena, node.pos,
            copy_node(ts, node.children[0].get()),
            copy_node(ts, node.children[1].get()));

        ov->func_overload = node.func_overload;
        ov->call = node.call;
        return ov;
    }
    else if (node.type == ast_type::arg_list) {
        std::vector<arena_ptr<ast_node>> args;
        for (auto& arg : node.children) {
            args.push_back(copy_node(ts, arg.get()));
        }
        return make_arg_list_node(*ts.ast_arena, node.pos, std::move(args));
    }
    else if (node.type == ast_type::decl_list) {
        std::vector<arena_ptr<ast_node>> args;
        for (auto& arg : node.children) {
            args.push_back(copy_node(ts, arg.get()));
        }
        return make_decl_list_node(*ts.ast_arena, node.pos, std::move(args));
    }
    else if (node.type == ast_type::stmt_list) {
        std::vector<arena_ptr<ast_node>> args;
        for (auto& arg : node.children) {
            args.push_back(copy_node(ts, arg.get()));
        }
        return make_stmt_list_node(*ts.ast_arena, node.pos, std::move(args));
    }
    else if (node.type == ast_type::compound_stmt) {
        std::vector<arena_ptr<ast_node>> args;
        for (auto& arg : node.children) {
            args.push_back(copy_node(ts, arg.get()));
        }
        return make_compound_stmt_node(*ts.ast_arena, node.pos, std::move(args), node.as_expr);
    }
    else if (node.type == ast_type::assign_stmt) {
        return make_assign_stmt_node(*ts.ast_arena, node.pos, copy_node(ts, node.children[0].get()), copy_node(ts, node.children[1].get()));
    }
    else if (node.type == ast_type::return_stmt) {
        return make_return_stmt_node(*ts.ast_arena, node.pos, copy_node(ts, node.children[0].get()));
    }
    else if (node.type == ast_type::compute_stmt) {
        return make_compute_stmt_node(*ts.ast_arena, node.pos, copy_node(ts, node.children[0].get()));
    }
    else if (node.type == ast_type::defer_stmt) {
        return make_defer_stmt_node(*ts.ast_arena, node.pos, copy_node(ts, node.children[0].get()));
    }
    else if (node.type == ast_type::if_stmt) {
        if (node.children.size() == 3) {
            return make_if_stmt_node(*ts.ast_arena, node.pos,
                copy_node(ts, node.children[0].get()),
                copy_node(ts, node.children[1].get()),
                copy_node(ts, node.children[2].get()), node.as_expr);
        }
        else {
            return make_if_stmt_node(*ts.ast_arena, node.pos,
                copy_node(ts, node.children[0].get()),
                copy_node(ts, node.children[1].get()),
                { nullptr, nullptr },
                node.as_expr);
        }
    }
    fprintf(stderr, "copy_node: node type not handled: %d\n", (int)node.type);
    assert(!"copy_node: node type not handled!");
    return { nullptr, nullptr };
}

arena_ptr<ast_node> copy_node(type_system& ts, ast_node* node) {
    if (!node) {
        return { nullptr, nullptr };
    }
    auto cpy = copy_node_helper(ts, *node);
    cpy->tid = node->tid;
    for (auto& child : node->pre_nodes) {
        assert(child.get());
        cpy->pre_nodes.push_back(copy_node(ts, child.get()));
    }
    return cpy;
}

arena_ptr<ast_node> make_cast_to(type_system& ts, arena_ptr<ast_node> expr, type_id t) {
    auto type_expr = make_type_resolver_node(*ts.ast_arena, t);
    auto res = make_cast_expr_node(*ts.ast_arena, expr->pos, std::move(type_expr), std::move(expr));
    res->tid = t;
    return res;
}

// TODO: obviously need better stuff here
static int temp_count = 0;

std::string generate_temp_name() {
    return "$ast_temp" + std::to_string(temp_count++);
}

arena_ptr<ast_node> transform_bool_op_into_if_statement(type_system& ts, arena_ptr<ast_node> bop, ast_node& destvar) {
    auto true_node = make_bool_literal_node(*ts.ast_arena, {}, true);
    auto false_node = make_bool_literal_node(*ts.ast_arena, {}, false);
    auto assign_true = make_assign_stmt_node(*ts.ast_arena, bop->pos, copy_node(ts, &destvar), std::move(true_node));
    auto assign_false = make_assign_stmt_node(*ts.ast_arena, bop->pos, copy_node(ts, &destvar), std::move(false_node));
    return make_if_stmt_node(*ts.ast_arena, bop->pos, std::move(bop), std::move(assign_true), std::move(assign_false), false);
}

arena_ptr<ast_node> transform_ternary_expr_into_if_statement(type_system& ts, ast_node& texpr, ast_node& destvar) {
    auto true_node = std::move(texpr.children[ast_node::child_if_body]);
    auto false_node = std::move(texpr.children[ast_node::child_if_else]);
    auto assign_true = make_binary_expr_node(*ts.ast_arena, {}, token_from_char('='), copy_node(ts, &destvar), std::move(true_node));
    auto assign_false = make_binary_expr_node(*ts.ast_arena, {}, token_from_char('='), copy_node(ts, &destvar), std::move(false_node));
    return make_if_stmt_node(
        *ts.ast_arena,
        texpr.pos,
        std::move(texpr.children[ast_node::child_if_cond]),
        std::move(assign_true),
        std::move(assign_false),
        false
    );
}

std::pair<arena_ptr<ast_node>, arena_ptr<ast_node>> make_temp_variable_for_call_resolved(type_system& ts, ast_node& call) {
    // generate the temp ID
    std::string tempname = generate_temp_name();
    auto id_node = make_identifier_node(*ts.ast_arena, {}, { tempname });

    auto val_node = make_call_expr_node(*ts.ast_arena, {}, std::move(call.children[ast_node::child_call_expr_callee]), std::move(call.children[ast_node::child_call_expr_arg_list]));
    // The call might have a pre-children of itself
    val_node->pre_nodes = std::move(call.pre_nodes);

    // Generate and register the declaration of the temp
    auto decl = make_var_decl_node_single(*ts.ast_arena, {}, token_type::let, std::move(id_node), { nullptr, nullptr }, std::move(val_node), { token_type::auto_ });
    resolve_node_type_post(ts, decl.get());

    // Make a reference to use as the new argument
    auto ref = make_identifier_node(*ts.ast_arena, {}, { tempname });
    resolve_node_type_post(ts, ref.get());

    return std::make_pair(std::move(decl), std::move(ref));
}

std::pair<arena_ptr<ast_node>, arena_ptr<ast_node>> make_temp_variable_for_index_expr_resolved(type_system& ts, arena_ptr<ast_node> lhs) {
    // generate the temp ID
    std::string tempname = generate_temp_name();
    auto id_node = make_identifier_node(*ts.ast_arena, {}, { tempname });

    // Generate and register the declaration of the temp
    auto decl = make_var_decl_node_single(*ts.ast_arena, {}, token_type::let, std::move(id_node), { nullptr, nullptr }, std::move(lhs), { token_type::auto_ });
    resolve_node_type_post(ts, decl.get());

    // Make a reference to use as the new argument6
    auto ref = make_identifier_node(*ts.ast_arena, {}, { tempname });
    resolve_node_type_post(ts, ref.get());

    return std::make_pair(std::move(decl), std::move(ref));
}

// generates something like:
// var temp: bool;
// if ($expr) temp = true; else temp = false;
// 
// returns the if statement and a reference to temp
std::pair<arena_ptr<ast_node>, arena_ptr<ast_node>> make_temp_variable_for_bool_op_resolved(type_system& ts, arena_ptr<ast_node> expr) {
    // generate the temp ID
    std::string tempname = generate_temp_name();
    auto id_node = make_identifier_node(*ts.ast_arena, {}, { tempname });
    auto type_node = make_type_expr_node(*ts.ast_arena, {}, make_identifier_node(*ts.ast_arena, {}, { "bool" }));

    // Generate and register the declaration of the temp
    auto decl = make_var_decl_node_single(*ts.ast_arena, {}, token_type::let, std::move(id_node), std::move(type_node), { nullptr, nullptr }, { token_type::auto_ });
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
arena_ptr<ast_node> make_temp_variable_for_bool_op_resolved(type_system& ts, arena_ptr<ast_node> expr, arena_ptr<ast_node> receiver) {
    // Make the if statement
    auto ifstmt = transform_bool_op_into_if_statement(ts, std::move(expr), *receiver);
    resolve_node_type_post(ts, ifstmt.get());

    return std::move(ifstmt);
}

std::pair<arena_ptr<ast_node>, arena_ptr<ast_node>> make_temp_variable_for_ternary_expr_resolved(type_system& ts, arena_ptr<ast_node> expr) {
    // generate the temp ID
    std::string tempname = generate_temp_name();
    auto id_node = make_identifier_node(*ts.ast_arena, {}, { tempname });
    auto type_node = make_type_resolver_node(*ts.ast_arena, expr->tid);

    // Generate and register the declaration of the temp
    auto decl = make_var_decl_node_single(*ts.ast_arena, {}, token_type::let, std::move(id_node), std::move(type_node), { nullptr, nullptr }, { token_type::auto_ });
    resolve_node_type_post(ts, decl.get());

    // Make a reference to use as the new argument
    auto ref = make_identifier_node(*ts.ast_arena, {}, { tempname });
    resolve_node_type_post(ts, ref.get());

    // Make the if statement
    auto ifstmt = transform_ternary_expr_into_if_statement(ts, *expr, *ref);
    resolve_node_type_post(ts, ifstmt.get());

    ifstmt->temps.push_back(std::move(decl));

    return std::make_pair(std::move(ifstmt), std::move(ref));
}

arena_ptr<ast_node> make_temp_variable_for_ternary_expr_resolved(type_system& ts, arena_ptr<ast_node> expr, arena_ptr<ast_node> receiver) {
    // Make the if statement
    auto ifstmt = transform_ternary_expr_into_if_statement(ts, *expr, *receiver);
    resolve_node_type_post(ts, ifstmt.get());

    return std::move(ifstmt);
}

arena_ptr<ast_node> make_var_decl_of_type(type_system& ts, token_type kind, const std::string& name, type_id tid) {
    auto id_node = make_identifier_node(*ts.ast_arena, {}, { name });
    auto type_node = make_type_resolver_node(*ts.ast_arena, tid);
    
    // TODO: modifiers

    auto res = make_var_decl_node_single(*ts.ast_arena, {}, kind, std::move(id_node), std::move(type_node), { nullptr, nullptr }, {});
    res->local.self = res.get();
    return res;
}

std::pair<arena_ptr<ast_node>, arena_ptr<ast_node>> make_temp_variable_for_aggregate_type_resolved(type_system& ts, arena_ptr<ast_node> expr) {
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
    for (auto& child : node.pre_nodes) {
        if (child) {
            child->parent = &node;
            parent_tree(*child);
        }
    }
    for (auto& child : node.children) {
        if (child) {
            child->parent = &node;
            parent_tree(*child);
        }
    }
}

}