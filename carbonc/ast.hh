#pragma once

#include <string>
#include <string_view>
#include <vector>
#include "carbonc.hh"
#include "memory.hh"
#include "token.hh"
#include "type_system.hh"

namespace carbon {

enum class ast_type {
    invalid,
    bool_literal,
    float_literal,
    int_literal,
    string_literal,
    identifier,
    unary_expr,
    binary_expr,
    call_expr,
    init_expr,

    type_decl,
    var_decl,
    func_decl,
    import_decl,

    arg_list,
    decl_list,
    stmt_list,

    compound_stmt,
    return_stmt,
    asm_stmt,

    type_expr,
    struct_type,
    tuple_type,
    array_type,
    type_qualifier,
    linkage_specifier,
    visibility_specifier,

    code_unit,
};

struct global_data {
    std::string label;
};

struct ast_node {
    static constexpr std::size_t child_binary_expr_left = 0;
    static constexpr std::size_t child_binary_expr_right = 1;

    static constexpr std::size_t child_call_expr_callee = 0;
    static constexpr std::size_t child_call_expr_arg_list = 1;

    static constexpr std::size_t child_type_decl_id = 0;
    static constexpr std::size_t child_type_decl_contents = 1;

    static constexpr std::size_t child_var_decl_id = 0;
    static constexpr std::size_t child_var_decl_type = 1;
    static constexpr std::size_t child_var_decl_value = 2;

    static constexpr std::size_t child_func_decl_id = 0;
    static constexpr std::size_t child_func_decl_arg_list = 1;
    static constexpr std::size_t child_func_decl_ret_type = 2;
    static constexpr std::size_t child_func_decl_body = 3;

    static constexpr std::size_t child_struct_type_field_list = 0;
    static constexpr std::size_t child_tuple_type_field_list = 0;

    static constexpr std::size_t child_array_type_size_expr = 0;
    static constexpr std::size_t child_array_type_item_type = 1;

    ast_node(const ast_node&) = delete;

    ast_node& operator=(const ast_node&) = delete;
    
    std::size_t node_id = 0;
    ast_type type = ast_type::invalid;
    position pos{};
    token_type op{};
    type_qualifier type_qual{};
    type_id type_id{};
    std::string_view string_value{};
    std::size_t id_hash{};
    float_type float_value{};
    int_type int_value{};
    std::vector<std::string> id_parts{};
    std::vector<arena_ptr<ast_node>> pre_children{};
    std::vector<arena_ptr<ast_node>> children{};
    std::vector<arena_ptr<ast_node>> temps{};

    // data filled by the type system
    scope_def scope;
    func_def func;
    local_def local;
    type_def type_def;
    lvalue lvalue;
    call_info call;
    global_data global_data;
};

arena_ptr<ast_node> make_bool_literal_node(memory_arena& arena, const position& pos, bool value);

arena_ptr<ast_node> make_float_literal_node(memory_arena& arena, const position& pos, float_type value);

arena_ptr<ast_node> make_int_literal_node(memory_arena& arena, const position& pos, int_type value);

arena_ptr<ast_node> make_string_literal_node(memory_arena& arena, const position& pos, std::string&& value);

arena_ptr<ast_node> make_identifier_node(memory_arena& arena, const position& pos, const std::vector<std::string>& values);

arena_ptr<ast_node> make_unary_expr_node(memory_arena& arena, const position& pos, token_type op, arena_ptr<ast_node>&& right);

arena_ptr<ast_node> make_binary_expr_node(memory_arena& arena, const position& pos, token_type op, arena_ptr<ast_node>&& left, arena_ptr<ast_node>&& right);

arena_ptr<ast_node> make_init_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& init_type, arena_ptr<ast_node>&& init_list);

arena_ptr<ast_node> make_call_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& callee, arena_ptr<ast_node>&& arg_list);

arena_ptr<ast_node> make_import_decl_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& mod, arena_ptr<ast_node>&& alias);

arena_ptr<ast_node> make_type_decl_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& id, arena_ptr<ast_node>&& contents);

arena_ptr<ast_node> make_var_decl_node(memory_arena& arena, const position& pos, token_type kind, arena_ptr<ast_node>&& id, arena_ptr<ast_node>&& decl_type, arena_ptr<ast_node>&& decl_val);

arena_ptr<ast_node> make_func_decl_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& id, arena_ptr<ast_node>&& arg_list, arena_ptr<ast_node>&& ret_type, arena_ptr<ast_node>&& body, func_linkage linkage);

arena_ptr<ast_node> make_arg_list_node(memory_arena& arena, const position& pos, std::vector<arena_ptr<ast_node>>&& children);

arena_ptr<ast_node> make_decl_list_node(memory_arena& arena, const position& pos, std::vector<arena_ptr<ast_node>>&& children);

arena_ptr<ast_node> make_stmt_list_node(memory_arena& arena, const position& pos, std::vector<arena_ptr<ast_node>>&& children);

arena_ptr<ast_node> make_compound_stmt_node(memory_arena& arena, const position& pos, std::vector<arena_ptr<ast_node>>&& children);

arena_ptr<ast_node> make_return_stmt_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& expr);

arena_ptr<ast_node> make_asm_stmt_node(memory_arena& arena, const position& pos, std::string&& value);

arena_ptr<ast_node> make_type_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& expr);

arena_ptr<ast_node> make_struct_type_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& field_list);

arena_ptr<ast_node> make_tuple_type_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& field_list);

arena_ptr<ast_node> make_array_type_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& size_expr, arena_ptr<ast_node>&& item_type);

arena_ptr<ast_node> make_type_qualifier_node(memory_arena& arena, const position& pos, type_qualifier q, arena_ptr<ast_node>&& to_type);

arena_ptr<ast_node> make_linkage_specifier_node(memory_arena& arena, const position& pos, func_linkage l, arena_ptr<ast_node>&& content);

arena_ptr<ast_node> make_visibility_specifier_node(memory_arena& arena, const position& pos, token_type spec, arena_ptr<ast_node>&& content);

arena_ptr<ast_node> make_code_unit_node(memory_arena& arena, const position& pos, const std::string& filename, arena_ptr<ast_node>&& decls);

bool is_primary_expr(ast_node& node);

}