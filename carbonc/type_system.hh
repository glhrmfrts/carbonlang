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
    func,
};

using scope_id = int;

struct type_id {
    ast_node* scope = nullptr;
    int type_index = -1;

    bool operator ==(const type_id& other) { return scope == other.scope && type_index == other.type_index; }
    bool operator !=(const type_id& other) { return !(*this == other); }

    inline bool valid() { return scope != nullptr && type_index != -1; }
};

struct type_flags {
    using type = unsigned int;

    static constexpr type none = 0;
    static constexpr type is_alias = 1;
};

struct type_def {
    struct array_type {
        std::size_t size;
        bool is_static;
    };

    struct func_type {
        std::vector<type_id> arg_types{};
        type_id ret_type{};
    };

    std::string name;
    std::hash<std::string>::result_type name_hash;
    //std::vector<type_qualifier> qualifiers;

    type_kind kind{};

    std::size_t size = 0;
    std::size_t alignment = 0;
    bool is_signed = false;

    array_type array;
    func_type func;

    type_flags::type flags = 0;
    type_id alias_to{};
    type_id elem_type{};
};

struct local_def {
    ast_node* id_node;
    ast_node* type_node;
    ast_node* value_node;
    bool is_argument = false;
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
    invalid,
    builtin,
    global,
    func_body,
    block,
};

struct scope_def {
    scope_kind kind{};

    std::vector<type_def*> type_defs;
    std::vector<ast_node*> local_defs;

    std::unordered_map<std::size_t, type_id> type_map;
    std::unordered_map<std::size_t, symbol_info> symbols;

    std::vector<ast_node*> children;
    ast_node* parent = nullptr;
    ast_node* body_node;
};

struct func_def {
    ast_node* ret_type_node;
    std::vector<ast_node*> arguments;
    std::vector<ast_node*> return_statements;
};

enum class type_system_pass {
    resolve_literals_and_register_declarations,
    resolve_all,
    perform_checks,
};

struct type_system {
    ast_node* builtin_scope;
    std::vector<arena_ptr<ast_node>> builtin_type_nodes;

    //std::vector<ast_node*> scopes;
    ast_node* current_scope = nullptr;

    bool unresolved_types = false;
    type_system_pass pass{};

    memory_arena* ast_arena;
    std::vector<ast_node*> code_units;

    explicit type_system(memory_arena&);

    void process_ast_node(ast_node& node);

    void resolve_and_check();

    scope_id find_main_func_scope();
};

}