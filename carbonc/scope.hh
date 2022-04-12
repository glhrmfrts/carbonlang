#pragma once

#include "type_system.hh"

namespace carbon {

void add_scope(type_system& ts, ast_node& node, scope_kind k);

void add_func_scope(type_system& ts, ast_node& node, ast_node& body_node);

void add_block_scope(type_system& ts, ast_node& node, ast_node& body_node);

void add_type_scope(type_system& ts, ast_node& node, ast_node& body_node);

// enter existing scope
void enter_scope_local(type_system& ts, ast_node& node);

void leave_scope_local(type_system& ts);

scope_def* find_nearest_scope_local(type_system& ts, scope_kind kind);

bool declare_global_symbol(type_system& ts, const string_hash& hash, ast_node& ld);

bool declare_local_symbol(type_system& ts, const string_hash& hash, ast_node& ld);

bool declare_top_level_func_symbol(type_system& ts, const string_hash& hash, ast_node& ld);

bool declare_type_symbol(type_system& ts, const string_hash& hash, ast_node& node);

bool declare_type_symbol(type_system& ts, scope_def& scope, const string_hash& hash, ast_node& node);

bool declare_overloaded_func_base_symbol(type_system& ts, const string_hash& hash);

bool declare_comptime_symbol(type_system& ts, const string_hash& hash, const comptime_value& value, type_id type);

symbol_info* find_symbol_in_current_scope(type_system& ts, const string_hash& hash);

symbol_info* find_symbol(type_system& ts, const std::pair<string_hash, string_hash>& pair);

// Finds the type in scope or parents
type_id find_type_by_id_hash(type_system& ts, const std::pair<string_hash, string_hash>& pair);

local_def* get_symbol_local(const symbol_info& sym);

}