#include "ast.hh"

namespace carbon {
arena_ptr<ast_node> make_bool_literal_node(memory_arena& arena, const position& pos, bool value) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::bool_literal;
    ptr->pos = pos;
    ptr->int_value = value ? 1 : 0;
    return std::move(ptr);
}

arena_ptr<ast_node> make_float_literal_node(memory_arena& arena, const position& pos, float_type value) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::float_literal;
    ptr->pos = pos;
    ptr->float_value = value;
    return std::move(ptr);
}

arena_ptr<ast_node> make_int_literal_node(memory_arena& arena, const position& pos, int_type value) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::int_literal;
    ptr->pos = pos;
    ptr->int_value = value;
    return std::move(ptr);
}

arena_ptr<ast_node> make_string_literal_node(memory_arena& arena, const position& pos, std::string&& value) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::string_literal;
    ptr->pos = pos;

    char* data = alloc_many<char>(arena, value.size());
    std::memcpy(data, value.data(), value.size());

    ptr->string_value = std::string_view{ data, value.size() };
    return std::move(ptr);
}

arena_ptr<ast_node> make_identifier_node(memory_arena& arena, const position& pos, std::string&& value) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::identifier;
    ptr->pos = pos;

    char* data = alloc_many<char>(arena, value.size());
    std::memcpy(data, value.data(), value.size());

    ptr->string_value = std::string_view{ data, value.size() };
    return std::move(ptr);
}

arena_ptr<ast_node> make_unary_expr_node(memory_arena& arena, const position& pos, token_type op, arena_ptr<ast_node>&& right) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::unary_expr;
    ptr->pos = pos;
    ptr->op = op;
    ptr->children.push_back(std::move(right));
    return ptr;
}

arena_ptr<ast_node> make_binary_expr_node(memory_arena& arena, const position& pos, token_type op, arena_ptr<ast_node>&& left, arena_ptr<ast_node>&& right) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::binary_expr;
    ptr->pos = pos;
    ptr->op = op;
    ptr->children.push_back(std::move(left));
    ptr->children.push_back(std::move(right));
    return ptr;
}

arena_ptr<ast_node> make_init_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& init_type, arena_ptr<ast_node>&& init_list) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::init_expr;
    ptr->pos = pos;
    ptr->children.push_back(std::move(init_type));
    ptr->children.push_back(std::move(init_list));
    return ptr;
}

arena_ptr<ast_node> make_call_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& callee, arena_ptr<ast_node>&& arg_list) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::call_expr;
    ptr->pos = pos;
    ptr->children.push_back(std::move(callee));
    ptr->children.push_back(std::move(arg_list));
    return ptr;
}

arena_ptr<ast_node> make_type_decl_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& id, arena_ptr<ast_node>&& contents) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::type_decl;
    ptr->pos = pos;
    ptr->children.push_back(std::move(id));
    ptr->children.push_back(std::move(contents));
    return ptr;
}

arena_ptr<ast_node> make_var_decl_node(memory_arena& arena, const position& pos, token_type kind, arena_ptr<ast_node>&& id, arena_ptr<ast_node>&& decl_type, arena_ptr<ast_node>&& decl_val) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::var_decl;
    ptr->pos = pos;
    ptr->op = kind;
    ptr->children.push_back(std::move(id));
    ptr->children.push_back(std::move(decl_type));
    ptr->children.push_back(std::move(decl_val));
    return ptr;
}

arena_ptr<ast_node> make_func_decl_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& id, arena_ptr<ast_node>&& arg_list, arena_ptr<ast_node>&& ret_type, arena_ptr<ast_node>&& body) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::func_decl;
    ptr->pos = pos;
    ptr->children.push_back(std::move(id));
    ptr->children.push_back(std::move(arg_list));
    ptr->children.push_back(std::move(ret_type));
    ptr->children.push_back(std::move(body));
    return ptr;
}

arena_ptr<ast_node> make_arg_list_node(memory_arena& arena, const position& pos, std::vector<arena_ptr<ast_node>>&& list) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::arg_list;
    ptr->pos = pos;
    ptr->children = std::move(list);
    return ptr;
}

arena_ptr<ast_node> make_decl_list_node(memory_arena& arena, const position& pos, std::vector<arena_ptr<ast_node>>&& list) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::decl_list;
    ptr->pos = pos;
    ptr->children = std::move(list);
    return ptr;
}

arena_ptr<ast_node> make_stmt_list_node(memory_arena& arena, const position& pos, std::vector<arena_ptr<ast_node>>&& list) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::stmt_list;
    ptr->pos = pos;
    ptr->children = std::move(list);
    return ptr;
}

arena_ptr<ast_node> make_compound_stmt_node(memory_arena& arena, const position& pos, std::vector<arena_ptr<ast_node>>&& list) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::compound_stmt;
    ptr->pos = pos;
    ptr->children = std::move(list);
    return ptr;
}

arena_ptr<ast_node> make_return_stmt_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& expr) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::return_stmt;
    ptr->pos = pos;
    ptr->children.push_back(std::move(expr));
    return ptr;
}

arena_ptr<ast_node> make_struct_type_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& field_list) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::struct_type;
    ptr->pos = pos;
    ptr->children.push_back(std::move(field_list));
    return ptr;
}

arena_ptr<ast_node> make_tuple_type_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& field_list) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::tuple_type;
    ptr->pos = pos;
    ptr->children.push_back(std::move(field_list));
    return ptr;
}

arena_ptr<ast_node> make_array_type_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& size_expr, arena_ptr<ast_node>&& item_type) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::array_type;
    ptr->pos = pos;
    ptr->children.push_back(std::move(size_expr));
    ptr->children.push_back(std::move(item_type));
    return ptr;
}

arena_ptr<ast_node> make_type_qualifier_node(memory_arena& arena, const position& pos, type_qualifier q, arena_ptr<ast_node>&& to_type) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->type = ast_type::type_qualifier;
    ptr->pos = pos;
    ptr->type_qual = q;
    ptr->children.push_back(std::move(to_type));
    return ptr;
}
}