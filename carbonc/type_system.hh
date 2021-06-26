#pragma once

#include <optional>
#include <vector>
#include <string>
#include <unordered_map>
#include <variant>
#include "memory.hh"
#include "common.hh"
#include "token.hh"
#include "type_id.hh"
#include "comptime.hh"
#include "carbonc.hh"

namespace carbon {

enum class func_linkage {
    local_carbon,
    external_carbon,
    external_c,
};

enum class type_qualifier {
    new_,
    optional,
    pointer,
};

enum class type_kind {
    void_,
    new_,
    pointer,
    optional,
    integral,
    real,
    array,
    slice,
    structure,
    tuple,
    func,
    func_pointer,
    type,
    constructor,
};

struct type_flags {
    using type = unsigned int;

    static constexpr type none = 0;
    static constexpr type is_alias = 1;
};

struct struct_field {
    std::vector<std::string> names;
    type_id type;
    std::size_t offset;

    bool operator ==(const struct_field& other) const { return names == other.names && type == other.type && offset == other.offset; }
};

using type_constructor_func = std::function<arena_ptr<ast_node>(const std::vector<comptime_value>&)>;

struct type_constructor {
    ast_node* self;
    std::vector<ast_node*> args;
    type_constructor_func func;
};

struct type_def {
    struct numeric_type {
        std::uint64_t max;
        std::int64_t min;
    };

    struct array_type {
        std::size_t length;
    };

    struct func_type {
        std::vector<type_id> arg_types{};
        type_id ret_type{};
    };

    struct struct_type {
        std::vector<struct_field> fields;
    };

    string_hash name;
    string_hash mangled_name;
    //std::vector<type_qualifier> qualifiers;

    type_kind kind{};

    std::size_t size = 0;
    std::size_t alignment = 0;
    bool is_signed = false;

    numeric_type numeric;
    array_type array;
    func_type func;
    struct_type structure;
    type_constructor constructor;

    type_flags::type flags = 0;
    type_id alias_to{};
    type_id elem_type{};
    type_id constructor_type{};

    ast_node* self = nullptr;
    type_id id{};
};

struct local_flag {
    using type = unsigned int;

    static constexpr type none = 0;
    static constexpr type is_argument = 1;
    static constexpr type is_temp = 2;
    static constexpr type is_aggregate_argument = 4;
};

struct local_def {
    std::vector<ast_node*> refs;
    ast_node* self = nullptr;
    //ast_node* id_node = nullptr;
    //ast_node* type_node = nullptr;
    //ast_node* value_node = nullptr;

    local_flag::type flags = local_flag::none;
    int arg_index = 0; // if is_argument
    ast_node* arg_func_node = nullptr; // if is_argument
    std::int32_t frame_offset = 0;
    int ir_index = 0;
};

enum class symbol_kind {
    local,
    top_level_func,
    overloaded_func_base,
    type,
    comptime,
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
    std::vector<func_def*> generic_funcs;

    // if kind == comptime
    comptime_value ctvalue;
};

struct lvalue {
    ast_node* self = nullptr;
    symbol_info* symbol;
};

struct call_flag {
    using type = unsigned int;

    static constexpr type none = 0;
    static constexpr type is_method_sugar_call = 1;
    static constexpr type is_aggregate_return = 4;
};

struct call_info {
    ast_node* self;
    call_flag::type flags;
    func_def* funcdef;
    std::vector<type_id> arg_types;
    string_hash mangled_name;
    type_id func_type_id{};
};

struct func_overload_info {
    ast_node* self;
    ast_node* from_lambda;
};

struct for_info {
    ast_node* self = nullptr;
    arena_ptr<ast_node> declare_for_iter{nullptr, nullptr};
    arena_ptr<ast_node> declare_elem_to_range_start{nullptr, nullptr};
    arena_ptr<ast_node> compare_elem_to_range_end{nullptr, nullptr};
    arena_ptr<ast_node> increase_elem{nullptr, nullptr};
};

struct slice_info {
    ast_node* self;
    //ast_node* start_node;
    //ast_node* end_node;
};

struct init_list {
    ast_node* receiver;
    std::vector<arena_ptr<ast_node>> assignments{};
    bool deduce_to_tuple = false;
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
    type,
};

struct scope_def {
    scope_kind kind{};

    std::vector<type_def*> type_defs;
    std::vector<local_def*> local_defs;
    std::vector<scope_import> imports;
    string_hash self_module_key;
    std::vector<std::string> self_module_parts;

    std::unordered_map<string_hash, std::unique_ptr<symbol_info>> symbols;
    std::unordered_map<string_hash, int> imports_map;

    std::vector<scope_def*> children;
    scope_def* parent = nullptr;
    ast_node* self = nullptr;
    ast_node* body_node = nullptr;
};

struct func_def {
    ast_node* self;
    //ast_node* ret_type_node;
    //std::vector<ast_node*> arguments;
    std::vector<ast_node*> return_statements;
    func_linkage linkage;
    bool args_unresolved = false;
    bool is_generic = false;
    scope_def* decl_scope;
    string_hash base_symbol;
};

struct field_access {
    ast_node* self;
    //ast_node* struct_node;
    //ast_node* field_node;
    int field_index;
    bool is_optional;
};

enum class type_system_pass {
    // literally what it says
    resolve_literals_and_register_declarations,

    // literally what it says
    resolve_imports,

    // does a lot of sub-passes until it resolves every possible type
    resolve_all,

    // repeat the last pass but emit errors if it fails
    perform_checks,

    // if no errors found, adjust func arguments for aggregate types, create temp variables for bool ops...
    desugar,

    // if no errors found, provide fully-qualified mangled names
    remangle_names,

    // if no errors found, generate interface files
    create_interface_files,
};

struct type_error {
    position pos;
    string_hash hash;
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
    int subpass = 0;

    memory_arena* ast_arena;
    std::vector<ast_node*> code_units;

    std::unordered_map<string_hash, scope_def*> modules;
    std::vector<type_error> errors;
    type_error current_error{};

    bool inside_defer = false;

    type_id type_type{};
    type_id void_type{};
    type_id raw_ptr_type{};
    type_id uintptr_type{};
    type_id ptrdiff_type{};
    type_id bool_type{};
    type_id usize_type{};
    type_id raw_string_type{};

    type_constructor* ptr_type_constructor;
    type_constructor* optional_type_constructor;
    type_constructor* new_type_constructor;
    type_constructor* tuple_type_constructor;
    type_constructor* arr_type_constructor;
    type_constructor* slice_type_constructor;
    type_constructor* func_pointer_type_constructor;

    explicit type_system(memory_arena&);

    void process_code_unit(ast_node& node);

    void resolve_and_check();

    void enter_scope(ast_node& node);

    void leave_scope();

    scope_def* find_nearest_scope(scope_kind kind);

    void create_temp_variable_for_binary_expr(ast_node& node);

    void create_temp_variable_for_index_expr(ast_node& node);

    void create_temp_variable_for_call_arg(ast_node& node, ast_node& arg, int idx);
};

bool is_pointer_type(type_id tid);

bool is_aggregate_type(type_id tid);

bool compare_types_exact(const type_def& a, const type_def& b);

type_id find_type_by_value(type_system& ts, scope_def& scope, const type_def& tdef);

type_id execute_type_constructor(type_system& ts, scope_def& scope, type_constructor& tpl, const std::vector<comptime_value>& args);

type_id execute_builtin_type_constructor(type_system& ts, type_constructor& tpl, const std::vector<comptime_value>& args);

string_hash build_tuple_name(const std::vector<comptime_value>& args);

string_hash build_type_constructor_name(const std::string& name, const std::vector<comptime_value>& args);

string_hash build_type_constructor_mangled_name(const std::string& mangled_name, const std::vector<comptime_value>& args);

type_id get_pointer_type_to(type_system& ts, type_id elem_type);

type_id get_optional_type_to(type_system& ts, type_id elem_type);

type_id get_new_type_to(type_system& ts, type_id elem_type);


void resolve_func_args_type(type_system& ts, ast_node& node);

type_id resolve_func_type(type_system& ts, ast_node& f);

void clear_func_resolved_state(ast_node& func);

void fill_local_argument_info(ast_node& func, ast_node& arg, int idx);

void declare_func_arguments(type_system& ts, ast_node& func);


void update_local_variable_type(type_system& ts, ast_node& l, type_id tid);

void update_local_aggregate_argument(type_system& ts, ast_node& l);


void visit_tree(type_system& ts, ast_node& node);

void visit_pre_children(type_system& ts, ast_node& node);

void visit_children(type_system& ts, ast_node& node);

type_id resolve_node_type(type_system& ts, ast_node* nodeptr);

}