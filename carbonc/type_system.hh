#pragma once

#include <vector>
#include <string>
#include <unordered_map>
#include "memory.hh"

namespace carbon {

struct ast_node;

enum class type_qualifier {
    optional,
    reference,
};

enum class type_kind {
    unit,
    pointer,
    reference,
    integral,
    real,
    array,
    map,
    structure,
    tuple,
};

using type_id = int;

struct type_flags {
    using type = unsigned int;

    static constexpr type none = 0;
    static constexpr type is_alias = 1;
};

struct array_type {
    std::size_t size;
    bool is_static;
};

struct type_def {
    std::string name;
    std::hash<std::string>::result_type name_hash;
    //std::vector<type_qualifier> qualifiers;

    type_kind kind{};

    std::size_t size = 0;
    std::size_t alignment = 0;
    bool is_signed = false;

    array_type array;

    type_flags::type flags = 0;
    type_id alias_to = -1;
    type_id pointer_to = -1;
    type_id reference_to = -1;
    type_id optional_of = -1;
};

struct local_def {
    ast_node* id_node;
    ast_node* type_node;
    ast_node* value_node;
    type_id type_id = -1;
    bool is_argument = false;
};

struct func_def {
    ast_node* func_node;
    std::vector<local_def> args;
    type_id ret_type = -1;
    int scope = -1;
};

enum class symbol_kind {
    local,
};

struct symbol_info {
    symbol_kind kind;

    // if kind == local
    int local_index = -1;
};

enum class scope_kind {
    func_body,
    block,
    global,
};

using scope_id = int;

struct scope {
    scope_kind kind;
    std::vector<type_def> type_defs;
    std::vector<func_def> func_defs;
    std::vector<local_def> local_defs;
    std::unordered_map<std::size_t, int> type_map;
    std::unordered_map<std::size_t, symbol_info> symbols;
    std::vector<scope_id> children;
    scope_id parent = -1;
    ast_node* node;
    
    // if kind == func_body
    type_id ret_type = -1;
};

enum class type_system_pass {
    resolve_literals_and_register_declarations,
};

struct type_system {
    std::vector<scope> scopes;
    scope_id current_scope = -1;
    bool unresolved_types = false;
    type_system_pass pass{};
    memory_arena* ast_arena;

    explicit type_system(memory_arena&);

    void process_ast_node(ast_node& node);

    scope_id find_main_func_scope();
};

}