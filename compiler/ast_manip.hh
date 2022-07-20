#pragma once

#include "ast.hh"
#include "type_system.hh"

namespace carbon {

void resolve_node_type_post(type_system& ts, ast_node* nodeptr);

void resolve_node_type_desugar_calls(type_system& ts, ast_node* nodeptr);

arena_ptr<ast_node> make_var_decl_with_value(memory_arena& ast_arena, std::string varname, arena_ptr<ast_node> value);

arena_ptr<ast_node> make_assignment(memory_arena& ast_arena, arena_ptr<ast_node> dest, arena_ptr<ast_node> value);

arena_ptr<ast_node> make_struct_field_access(memory_arena& ast_arena, arena_ptr<ast_node> st, std::string field);

arena_ptr<ast_node> make_index_access(memory_arena& ast_arena, arena_ptr<ast_node> st, int idx);

arena_ptr<ast_node> make_address_of_expr(type_system& ts, arena_ptr<ast_node> expr);

arena_ptr<ast_node> make_deref_expr(type_system& ts, arena_ptr<ast_node> expr);

arena_ptr<ast_node> copy_node(type_system& ts, ast_node* node);

arena_ptr<ast_node> make_cast_to(type_system& ts, arena_ptr<ast_node> expr, type_id t);

std::string generate_temp_name(const std::string& from);

arena_ptr<ast_node> transform_bool_op_into_if_statement(type_system& ts, arena_ptr<ast_node> bop, ast_node& destvar);

arena_ptr<ast_node> transform_ternary_expr_into_if_statement(type_system& ts, ast_node& texpr, ast_node& destvar);

std::pair<arena_ptr<ast_node>, arena_ptr<ast_node>> make_temp_variable_for_call_resolved(type_system& ts, ast_node& call);

std::pair<arena_ptr<ast_node>, arena_ptr<ast_node>> make_temp_variable_for_index_expr_resolved(type_system& ts, arena_ptr<ast_node> lhs);

std::pair<arena_ptr<ast_node>, arena_ptr<ast_node>> make_temp_variable_for_bool_op_resolved(type_system& ts, arena_ptr<ast_node> expr);

arena_ptr<ast_node> make_temp_variable_for_bool_op_resolved(type_system& ts, arena_ptr<ast_node> expr, arena_ptr<ast_node> receiver);

std::pair<arena_ptr<ast_node>, arena_ptr<ast_node>> make_temp_variable_for_ternary_expr_resolved(type_system& ts, arena_ptr<ast_node> expr);

arena_ptr<ast_node> make_temp_variable_for_ternary_expr_resolved(type_system& ts, arena_ptr<ast_node> expr, arena_ptr<ast_node> receiver);

arena_ptr<ast_node> make_var_decl_of_type(type_system& ts, token_type kind, const std::string& name, type_id tid);

std::pair<arena_ptr<ast_node>, arena_ptr<ast_node>> make_temp_variable_for_aggregate_type_resolved(type_system& ts, arena_ptr<ast_node> expr);

std::optional<std::size_t> find_child_index(ast_node* parent, ast_node* child);

void parent_tree(ast_node& node);

}