#pragma once

#include <string>
#include <string_view>
#include <vector>
#include "carbonc.hh"
#include "memory.hh"
#include "token.hh"
#include "type_system.hh"
#include "ir.hh"

namespace carbon {

enum class ast_type {
    invalid,
    nullptr_,
    bool_literal,
    float_literal,
    int_literal,
    char_literal,
    string_literal,
    identifier,
    unary_expr,
    binary_expr,
    call_expr,
    index_expr,
    init_expr,
    cast_expr,
    nullcast_expr,
    field_expr,
    ternary_expr,
    func_expr,
    func_overload_selector_expr,
    comptime_expr,

    type_decl,
    type_constructor_decl,
    var_decl,
    func_decl,
    import_decl,

    arg_list,
    decl_list,
    stmt_list,

    compound_stmt,
    return_stmt,
    asm_stmt,
    if_stmt,
    while_stmt,
    for_stmt,
    defer_stmt,
    continue_stmt,
    break_stmt,

    type_expr,
    struct_type,
    tuple_type,
    array_type,
    slice_type,
    func_pointer_type,
    type_constructor_instance,
    type_qualifier,
    linkage_specifier,
    visibility_specifier,
    type_resolver,

    code_unit,
    target,
};

struct global_data {
    std::string label;
};

struct desugar_flag {
    using type = unsigned int;

    static constexpr type none = 0;
    static constexpr type bool_op_desugared = 1;
    static constexpr type ternary_desugared = 2;
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

    static constexpr std::size_t child_for_stmt_body = 2;

    static constexpr std::size_t child_struct_type_field_list = 0;
    static constexpr std::size_t child_tuple_type_field_list = 0;

    static constexpr std::size_t child_array_type_size_expr = 0;
    static constexpr std::size_t child_array_type_item_type = 1;

    static constexpr std::size_t child_if_cond = 0;
    static constexpr std::size_t child_if_body = 1;
    static constexpr std::size_t child_if_else = 2;

    ast_node(const ast_node&) = delete;

    ast_node& operator=(const ast_node&) = delete;
    
    std::size_t node_id = 0;
    ast_type type = ast_type::invalid;
    position pos{};
    token_type op{};
    type_qualifier type_qual{};
    type_id type_id{};
    std::string_view string_value{};
    //std::size_t id_hash{};
    float_type float_value{};
    int_type int_value{};
    std::vector<std::string> id_parts{};
    std::vector<arena_ptr<ast_node>> pre_children{};
    std::vector<arena_ptr<ast_node>> children{};
    std::vector<arena_ptr<ast_node>> children_to_add{};
    std::vector<arena_ptr<ast_node>> temps{};
    arena_ptr<ast_node> sizeof_type_expr{nullptr, nullptr};
    ast_node* parent = nullptr;
    desugar_flag::type desugar_flags = 0;
    std::vector<token_type> var_modifiers;

    // data filled by the type system
    scope_def scope;
    func_def func;
    local_def local;
    type_def type_def;
    lvalue lvalue;
    call_info call;
    func_overload_info func_overload;
    global_data global_data;
    for_info forinfo;
    slice_info slice;
    field_access field;
    init_list initlist;
    bool type_error = false;

    ir_node_data ir;

    ast_node* bin_left()  const { return children[0].get(); }
    ast_node* bin_right() const  { return children[1].get(); }

    ast_node* unary_right()  const { return children[0].get(); }

    ast_node*                         func_id() const  { return children[0].get(); }
    std::vector<arena_ptr<ast_node>>& func_args() const  { return children[1]->children; }
    ast_node*                         func_body() const  { return children[3].get(); }
    ast_node*                         func_ret_type() const  { return children[2].get(); }

    ast_node* var_id() const { return children[0].get(); }
    ast_node* var_type() const { return children[1].get(); }
    ast_node* var_value() const { return children[2].get(); }

    ast_node*                         call_func() const  { return children[0].get(); }
    std::vector<arena_ptr<ast_node>>& call_args() const  { return children[1]->children; }

    ast_node* field_struct() const  { return children[0].get(); }
    ast_node* field_field() const  { return children[1].get(); }

    ast_node* if_cond() const  { return children[0].get(); }
    ast_node* if_body() const  { return children[1].get(); }
    ast_node* if_else() const  { return children[2].get(); }

    ast_node* while_cond() const  { return children[0].get(); }
    ast_node* while_body() const  { return children[1].get(); }

    ast_node* for_elems() const  { return children[0].get(); }
    ast_node* for_iter()  const  { return children[1].get(); }
    ast_node* for_body()  const  { return children[2].get(); }

    ast_node*                         func_overload_fn() const { return children[0].get(); }
    std::vector<arena_ptr<ast_node>>& func_overload_args() const { return children[1]->children[0]->children[0]->children; }

    std::vector<arena_ptr<ast_node>>& func_type_args() const { return children[0]->children; }
    ast_node*                         func_type_ret() const { return children[1].get(); }
};

arena_ptr<ast_node> make_nullpointer_node(memory_arena& arena, const position& pos);

arena_ptr<ast_node> make_bool_literal_node(memory_arena& arena, const position& pos, bool value);

arena_ptr<ast_node> make_float_literal_node(memory_arena& arena, const position& pos, float_type value);

arena_ptr<ast_node> make_int_literal_node(memory_arena& arena, const position& pos, int_type value);

arena_ptr<ast_node> make_char_literal_node(memory_arena& arena, const position& pos, int_type value);

arena_ptr<ast_node> make_string_literal_node(memory_arena& arena, const position& pos, std::string&& value);

arena_ptr<ast_node> make_identifier_node(memory_arena& arena, const position& pos, const std::vector<std::string>& values);

arena_ptr<ast_node> make_unary_expr_node(memory_arena& arena, const position& pos, token_type op, arena_ptr<ast_node>&& right);

arena_ptr<ast_node> make_binary_expr_node(memory_arena& arena, const position& pos, token_type op, arena_ptr<ast_node>&& left, arena_ptr<ast_node>&& right);

arena_ptr<ast_node> make_init_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& init_type, arena_ptr<ast_node>&& init_list);

arena_ptr<ast_node> make_call_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& callee, arena_ptr<ast_node>&& arg_list);

arena_ptr<ast_node> make_index_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& left, arena_ptr<ast_node>&& index);

arena_ptr<ast_node> make_field_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& left, arena_ptr<ast_node>&& field);

arena_ptr<ast_node> make_cast_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& type_expr, arena_ptr<ast_node>&& value);

arena_ptr<ast_node> make_ternary_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& cond, arena_ptr<ast_node>&& then_expr, arena_ptr<ast_node>&& else_expr);

arena_ptr<ast_node> make_func_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& id, arena_ptr<ast_node>&& arg_list, arena_ptr<ast_node>&& ret_type, arena_ptr<ast_node>&& body, func_linkage linkage);

arena_ptr<ast_node> make_func_overload_selector_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& fn, arena_ptr<ast_node>&& arg_types);

arena_ptr<ast_node> make_comptime_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& expr);

arena_ptr<ast_node> make_import_decl_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& mod, arena_ptr<ast_node>&& alias);

arena_ptr<ast_node> make_type_decl_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& id, arena_ptr<ast_node>&& contents, bool is_alias);

arena_ptr<ast_node> make_type_constructor_decl_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& tpl, arena_ptr<ast_node>&& arg_list, arena_ptr<ast_node>&& contents);

arena_ptr<ast_node> make_var_decl_node(memory_arena& arena, const position& pos, token_type kind, arena_ptr<ast_node>&& id, arena_ptr<ast_node>&& decl_type, arena_ptr<ast_node>&& decl_val, const std::vector<token_type>& mods);

arena_ptr<ast_node> make_func_decl_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& id, arena_ptr<ast_node>&& arg_list, arena_ptr<ast_node>&& ret_type, arena_ptr<ast_node>&& body, func_linkage linkage);

arena_ptr<ast_node> make_arg_list_node(memory_arena& arena, const position& pos, std::vector<arena_ptr<ast_node>>&& children);

arena_ptr<ast_node> make_decl_list_node(memory_arena& arena, const position& pos, std::vector<arena_ptr<ast_node>>&& children);

arena_ptr<ast_node> make_stmt_list_node(memory_arena& arena, const position& pos, std::vector<arena_ptr<ast_node>>&& children);

arena_ptr<ast_node> make_compound_stmt_node(memory_arena& arena, const position& pos, std::vector<arena_ptr<ast_node>>&& children);

arena_ptr<ast_node> make_return_stmt_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& expr);

arena_ptr<ast_node> make_asm_stmt_node(memory_arena& arena, const position& pos, std::string&& value);

arena_ptr<ast_node> make_while_stmt_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& cond, arena_ptr<ast_node>&& body);

arena_ptr<ast_node> make_for_stmt_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& ids, arena_ptr<ast_node>&& iter, arena_ptr<ast_node>&& body);

arena_ptr<ast_node> make_if_stmt_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& cond, arena_ptr<ast_node>&& body, arena_ptr<ast_node>&& elsebody);

arena_ptr<ast_node> make_defer_stmt_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& body);

arena_ptr<ast_node> make_continue_stmt_node(memory_arena& arena, const position& pos);

arena_ptr<ast_node> make_break_stmt_node(memory_arena& arena, const position& pos);

arena_ptr<ast_node> make_type_expr_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& expr);

arena_ptr<ast_node> make_struct_type_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& field_list);

arena_ptr<ast_node> make_tuple_type_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& field_list);

arena_ptr<ast_node> make_array_type_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& size_expr, arena_ptr<ast_node>&& item_type);

arena_ptr<ast_node> make_slice_type_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& item_type);

arena_ptr<ast_node> make_func_pointer_type_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& arg_types, arena_ptr<ast_node>&& ret_type);

arena_ptr<ast_node> make_type_constructor_instance_node(memory_arena& arena, const position& pos, arena_ptr<ast_node>&& tpl, arena_ptr<ast_node>&& arg_list);

arena_ptr<ast_node> make_type_qualifier_node(memory_arena& arena, const position& pos, type_qualifier q, arena_ptr<ast_node>&& to_type);

arena_ptr<ast_node> make_linkage_specifier_node(memory_arena& arena, const position& pos, func_linkage l, arena_ptr<ast_node>&& content);

arena_ptr<ast_node> make_visibility_specifier_node(memory_arena& arena, const position& pos, token_type spec, arena_ptr<ast_node>&& content);

arena_ptr<ast_node> make_code_unit_node(memory_arena& arena, const position& pos, const std::string& filename, arena_ptr<ast_node>&& decls);

arena_ptr<ast_node> make_type_resolver_node(memory_arena& arena, type_id tid);

bool is_primary_expr(ast_node& node);

bool is_logic_binary_op(ast_node& node);

bool is_cmp_binary_op(ast_node& node);

bool is_bool_op(ast_node& node);

std::string build_identifier_value(const std::vector<std::string>& parts);

std::string visibility_name(token_type op);

std::string func_linkage_name(func_linkage l);

inline static bool has_var_modifier(ast_node& node, token_type mod) {
    for (const auto nm : node.var_modifiers) {
        if (nm == mod) {
            return true;
        }
    }
    return false;
}

}