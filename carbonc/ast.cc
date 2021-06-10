#include "ast.hh"

namespace carbon {

static std::size_t node_id_gen = 0;

arena_ptr<ast_node> make_nil_literal_node(memory_arena& arena, const position& pos) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::nil_literal;
    ptr->pos = pos;
    return std::move(ptr);
}

arena_ptr<ast_node> make_bool_literal_node(memory_arena& arena, const position& pos, bool value) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::bool_literal;
    ptr->pos = pos;
    ptr->int_value = value ? 1 : 0;
    return std::move(ptr);
}

arena_ptr<ast_node> make_float_literal_node(memory_arena& arena, const position& pos, float_type value) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::float_literal;
    ptr->pos = pos;
    ptr->float_value = value;
    return std::move(ptr);
}

arena_ptr<ast_node> make_int_literal_node(memory_arena& arena, const position& pos, int_type value) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::int_literal;
    ptr->pos = pos;
    ptr->int_value = value;
    return std::move(ptr);
}

arena_ptr<ast_node> make_char_literal_node(memory_arena& arena, const position& pos, int_type value) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::char_literal;
    ptr->pos = pos;
    ptr->int_value = value;
    return std::move(ptr);
}

arena_ptr<ast_node> make_string_literal_node(memory_arena& arena, const position& pos, std::string&& value) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::string_literal;
    ptr->pos = pos;

    char* data = alloc_many<char>(arena, value.size() + 1);
    std::memcpy(data, value.data(), value.size());
    data[value.size()] = '\0';

    ptr->string_value = std::string_view{ data, value.size() };
    return std::move(ptr);
}

arena_ptr<ast_node> make_identifier_node(memory_arena& arena, const position& pos, const std::vector<std::string>& values) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::identifier;
    ptr->pos = pos;
    ptr->id_parts = values;
    return std::move(ptr);
}

arena_ptr<ast_node> make_unary_expr_node(memory_arena& arena, const position& pos, token_type op, arena_ptr<ast_node>&& right) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::unary_expr;
    ptr->pos = pos;
    ptr->op = op;
    ptr->children.push_back(std::move(right));
    return ptr;
}

arena_ptr<ast_node> make_binary_expr_node(memory_arena& arena, const position& pos, token_type op, arena_ptr<ast_node>&& left, arena_ptr<ast_node>&& right) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::binary_expr;
    ptr->pos = pos;
    ptr->op = op;
    ptr->children.push_back(std::move(left));
    ptr->children.push_back(std::move(right));
    return ptr;
}

arena_ptr<ast_node> make_init_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& init_type, arena_ptr<ast_node>&& init_list) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::init_expr;
    ptr->pos = pos;
    ptr->children.push_back(std::move(init_type));
    ptr->children.push_back(std::move(init_list));
    return ptr;
}

arena_ptr<ast_node> make_call_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& callee, arena_ptr<ast_node>&& arg_list) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::call_expr;
    ptr->pos = pos;
    ptr->children.push_back(std::move(callee));
    ptr->children.push_back(std::move(arg_list));
    return ptr;
}

arena_ptr<ast_node> make_index_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& left, arena_ptr<ast_node>&& index) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::index_expr;
    ptr->pos = pos;
    ptr->children.push_back(std::move(left));
    ptr->children.push_back(std::move(index));
    return ptr;
}

arena_ptr<ast_node> make_field_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& left, arena_ptr<ast_node>&& field) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::field_expr;
    ptr->pos = pos;
    ptr->children.push_back(std::move(left));
    ptr->children.push_back(std::move(field));
    return ptr;
}

arena_ptr<ast_node> make_cast_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& type_expr, arena_ptr<ast_node>&& value) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::cast_expr;
    ptr->pos = pos;
    ptr->children.push_back(std::move(type_expr));
    ptr->children.push_back(std::move(value));
    return ptr;
}

arena_ptr<ast_node> make_import_decl_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& mod, arena_ptr<ast_node>&& alias) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::import_decl;
    ptr->pos = pos;
    ptr->children.push_back(std::move(mod));
    ptr->children.push_back(std::move(alias));
    return ptr;
}

arena_ptr<ast_node> make_type_decl_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& id, arena_ptr<ast_node>&& contents) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::type_decl;
    ptr->pos = pos;
    ptr->children.push_back(std::move(id));
    ptr->children.push_back(std::move(contents));
    return ptr;
}

arena_ptr<ast_node> make_var_decl_node(memory_arena& arena, const position& pos, token_type kind, arena_ptr<ast_node>&& id, arena_ptr<ast_node>&& decl_type, arena_ptr<ast_node>&& decl_val) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::var_decl;
    ptr->pos = pos;
    ptr->op = kind;
    ptr->children.push_back(std::move(id));
    ptr->children.push_back(std::move(decl_type));
    ptr->children.push_back(std::move(decl_val));
    return ptr;
}

arena_ptr<ast_node> make_func_decl_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& id, arena_ptr<ast_node>&& arg_list,
    arena_ptr<ast_node>&& ret_type, arena_ptr<ast_node>&& body, func_linkage linkage) {

    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::func_decl;
    ptr->pos = pos;
    ptr->func.linkage = linkage;
    ptr->children.push_back(std::move(id));
    ptr->children.push_back(std::move(arg_list));
    ptr->children.push_back(std::move(ret_type));
    ptr->children.push_back(std::move(body));
    return ptr;
}

arena_ptr<ast_node> make_arg_list_node(memory_arena& arena, const position& pos, std::vector<arena_ptr<ast_node>>&& list) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::arg_list;
    ptr->pos = pos;
    ptr->children = std::move(list);
    return ptr;
}

arena_ptr<ast_node> make_decl_list_node(memory_arena& arena, const position& pos, std::vector<arena_ptr<ast_node>>&& list) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::decl_list;
    ptr->pos = pos;
    ptr->children = std::move(list);
    return ptr;
}

arena_ptr<ast_node> make_stmt_list_node(memory_arena& arena, const position& pos, std::vector<arena_ptr<ast_node>>&& list) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::stmt_list;
    ptr->pos = pos;
    ptr->children = std::move(list);
    return ptr;
}

arena_ptr<ast_node> make_compound_stmt_node(memory_arena& arena, const position& pos, std::vector<arena_ptr<ast_node>>&& list) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::compound_stmt;
    ptr->pos = pos;
    ptr->children = std::move(list);
    return ptr;
}

arena_ptr<ast_node> make_return_stmt_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& expr) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::return_stmt;
    ptr->pos = pos;
    ptr->children.push_back(std::move(expr));
    return ptr;
}

arena_ptr<ast_node> make_asm_stmt_node(memory_arena& arena, const position& pos, std::string&& value) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::asm_stmt;
    ptr->pos = pos;

    char* data = alloc_many<char>(arena, value.size() + 1);
    std::memcpy(data, value.data(), value.size());
    data[value.size()] = '\0';

    ptr->string_value = std::string_view{ data, value.size() };
    return ptr;
}

arena_ptr<ast_node> make_if_stmt_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& cond, arena_ptr<ast_node>&& body, arena_ptr<ast_node>&& elsebody) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::if_stmt;
    ptr->pos = pos;
    ptr->children.push_back(std::move(cond));
    ptr->children.push_back(std::move(body));
    if (elsebody) {
        ptr->children.push_back(std::move(elsebody));
    }
    return ptr;
}

arena_ptr<ast_node> make_while_stmt_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& cond, arena_ptr<ast_node>&& body) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::while_stmt;
    ptr->pos = pos;
    ptr->children.push_back(std::move(cond));
    ptr->children.push_back(std::move(body));
    return ptr;
}

arena_ptr<ast_node> make_for_stmt_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& ids, arena_ptr<ast_node>&& iter, arena_ptr<ast_node>&& body) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::for_stmt;
    ptr->pos = pos;
    ptr->children.push_back(std::move(ids));
    ptr->children.push_back(std::move(iter));
    ptr->children.push_back(std::move(body));
    return ptr;
}

arena_ptr<ast_node> make_type_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& expr) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::type_expr;
    ptr->pos = pos;
    ptr->children.push_back(std::move(expr));
    return ptr;
}

arena_ptr<ast_node> make_struct_type_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& field_list) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::struct_type;
    ptr->pos = pos;
    ptr->children.push_back(std::move(field_list));
    return ptr;
}

arena_ptr<ast_node> make_tuple_type_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& field_list) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::tuple_type;
    ptr->pos = pos;
    ptr->children.push_back(std::move(field_list));
    return ptr;
}

arena_ptr<ast_node> make_array_type_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& size_expr, arena_ptr<ast_node>&& item_type) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::array_type;
    ptr->pos = pos;
    ptr->children.push_back(std::move(size_expr));
    ptr->children.push_back(std::move(item_type));
    return ptr;
}

arena_ptr<ast_node> make_slice_type_node(memory_arena& arena, const position& pos, token_type op, arena_ptr<ast_node>&& item_type) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::slice_type;
    ptr->pos = pos;
    ptr->op = op;
    ptr->children.push_back(std::move(item_type));
    return ptr;
}

arena_ptr<ast_node> make_type_qualifier_node(memory_arena& arena, const position& pos, type_qualifier q, arena_ptr<ast_node>&& to_type) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::type_qualifier;
    ptr->pos = pos;
    ptr->type_qual = q;
    ptr->children.push_back(std::move(to_type));
    return ptr;
}

arena_ptr<ast_node> make_linkage_specifier_node(memory_arena& arena, const position& pos, func_linkage l, arena_ptr<ast_node>&& content) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::linkage_specifier;
    ptr->pos = pos;
    ptr->func.linkage = l;
    ptr->children.push_back(std::move(content));
    return ptr;
}

arena_ptr<ast_node> make_visibility_specifier_node(memory_arena& arena, const position& pos, token_type spec, arena_ptr<ast_node>&& content) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::visibility_specifier;
    ptr->pos = pos;
    ptr->op = spec;
    ptr->children.push_back(std::move(content));
    return ptr;
}

arena_ptr<ast_node> make_code_unit_node(memory_arena& arena, const position& pos, const std::string& filename, arena_ptr<ast_node>&& decls) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::code_unit;
    ptr->pos = pos;
    char* data = alloc_many<char>(arena, filename.size() + 1);
    std::memcpy(data, filename.data(), filename.size());
    data[filename.size()] = '\0';

    ptr->string_value = std::string_view{ data, filename.size() };
    ptr->children.push_back(std::move(decls));
    return ptr;
}

arena_ptr<ast_node> make_type_constructor_instance_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& tpl, arena_ptr<ast_node>&& arg_list) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::type_constructor_instance;
    ptr->pos = pos;
    ptr->children.push_back(std::move(tpl));
    ptr->children.push_back(std::move(arg_list));
    return ptr;
}

arena_ptr<ast_node> make_type_resolver_node(memory_arena& arena, type_id tid) {
    auto ptr = make_in_arena<ast_node>(arena);
    ptr->node_id = node_id_gen++;
    ptr->type = ast_type::type_resolver;
    ptr->type_id = tid;
    return ptr;
}

bool is_primary_expr(ast_node& node) {
    switch (node.type) {
    case ast_type::bool_literal:
    case ast_type::int_literal:
    case ast_type::float_literal:
    case ast_type::char_literal:
    case ast_type::string_literal:
    case ast_type::identifier:
        return true;
    default:
        return false;
    }
}

bool is_logic_binary_op(ast_node& node) {
    if (node.type == ast_type::binary_expr) {
        return is_logic_binary_op(node.op);
    }
    return false;
}

bool is_cmp_binary_op(ast_node& node) {
    if (node.type == ast_type::binary_expr) {
        return is_cmp_binary_op(node.op);
    }
    return false;
}

bool is_bool_op(ast_node& node) {
    if (node.type == ast_type::binary_expr) {
        return is_logic_binary_op(node.op) || is_cmp_binary_op(node.op);
    }
    else if (node.type == ast_type::unary_expr) {
        return token_to_char(node.op) == '!';
    }
    return false;
}

std::string build_identifier_value(const std::vector<std::string>& parts) {
    std::string result;
    for (std::size_t i = 0; i < parts.size(); i++) {
        result.append(parts[i]);
        if (i < parts.size() - 1) {
            result.append("::");
        }
    }
    return result;
}

std::string visibility_name(token_type op) {
    switch (op) {
    case token_type::public_:
        return "public";
    case token_type::private_:
        return "private";
    case token_type::internal_:
        return "internal";
    }
}

std::string func_linkage_name(func_linkage l) {
    switch (l) {
    case func_linkage::external_c:
        return "extern(C)";
    case func_linkage::external_carbon:
        return "extern";
    case func_linkage::local_carbon:
        return "local";
    }
}
}