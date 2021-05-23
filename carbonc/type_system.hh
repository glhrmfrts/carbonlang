#pragma once

#include <optional>
#include <vector>
#include <string>
#include <unordered_map>
#include "memory.hh"
#include "common.hh"
#include "token.hh"

namespace carbon {

struct ast_node;
struct scope_def;
struct type_def;
struct local_def;
struct func_def;

enum class func_linkage {
    local_carbon,
    external_carbon,
    external_c,
};

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

struct type_id {
    scope_def* scope = nullptr;
    int type_index = -1;

    bool operator ==(const type_id& other) { return scope == other.scope && type_index == other.type_index; }
    bool operator !=(const type_id& other) { return !(*this == other); }

    type_def& get();

    bool valid() const;
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

    string_hash name;
    string_hash mangled_name;
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

    ast_node* self = nullptr;
    type_id id{};
};

struct local_def {
    ast_node* self = nullptr;
    ast_node* id_node = nullptr;
    ast_node* type_node = nullptr;
    ast_node* value_node = nullptr;
    bool is_argument = false;
    int arg_index = 0; // if is_argument
    ast_node* arg_func_node = nullptr; // if is_argument
    std::int32_t frame_offset = 0;
};

enum class symbol_kind {
    local,
    top_level_func,
    overloaded_func_base,
    type,
};

struct symbol_info {
    symbol_kind kind;
    scope_def* scope;

    // if kind == local
    int local_index = -1;

    // if kind == type
    int type_index = -1;
    
    // if kind == overloaded_func_base
    std::vector<func_def*> overload_funcs;
};

struct lvalue {
    ast_node* self = nullptr;
    symbol_info symbol{};
};

struct call_info {
    ast_node* self;
    ast_node* func_node;
    std::vector<ast_node*> args;
    string_hash mangled_name;
    type_id func_type_id{};
};

struct scope_import {
    string_hash qual_name;
    std::optional<string_hash> alias;
};

enum class scope_kind {
    invalid,
    builtin,
    code_unit,
    func_body,
    block,
};

struct scope_def {
    scope_kind kind{};

    std::vector<type_def*> type_defs;
    std::vector<local_def*> local_defs;
    std::vector<scope_import> imports;
    string_hash self_module_key;
    std::vector<std::string> self_module_parts;

    std::unordered_map<string_hash, symbol_info> symbols;
    std::unordered_map<string_hash, int> imports_map;

    std::vector<scope_def*> children;
    scope_def* parent = nullptr;
    ast_node* self = nullptr;
    ast_node* body_node = nullptr;
};

struct func_def {
    ast_node* self;
    ast_node* ret_type_node;
    std::vector<ast_node*> arguments;
    std::vector<ast_node*> return_statements;
    func_linkage linkage;
    bool args_unresolved = false;
    string_hash base_symbol;
};

enum class type_system_pass {
    resolve_literals_and_register_declarations,
    resolve_imports,
    resolve_all,
    perform_checks,
    final_analysis,
    create_interface_files,
};

struct type_error {
    position pos;
    std::string filename;
    std::string msg;
};

struct type_system {
    ast_node* builtin_scope;
    std::vector<arena_ptr<ast_node>> builtin_type_nodes;

    //std::vector<ast_node*> scopes;
    scope_def* current_scope = nullptr;

    bool unresolved_types = false;
    type_system_pass pass{};

    memory_arena* ast_arena;
    std::vector<ast_node*> code_units;

    std::unordered_map<string_hash, scope_def*> modules;
    std::vector<type_error> errors;
    type_error current_error{};

    type_id void_type{};
    type_id raw_ptr_type{};
    type_id uintptr_type{};
    type_id ptrdiff_type{};

    explicit type_system(memory_arena&);

    void process_code_unit(ast_node& node);

    void resolve_and_check();

    void enter_scope(ast_node& node);

    void leave_scope();

    scope_def* find_nearest_scope(scope_kind kind);

    void create_temp_variable_for_binary_expr(ast_node& node);
};

}