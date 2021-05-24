#include <cassert>
#include <optional>
#include "type_system.hh"
#include "ast.hh"
#include "fs.hh"
#include <fstream>
#include <numeric>

namespace carbon {

namespace {

static const type_id invalid_type{};

void visit_tree(type_system& ts, ast_node& node);

type_id resolve_node_type(type_system& ts, ast_node* nodeptr);

void declare_type_symbol(type_system& ts, const string_hash& hash);

void declare_type_symbol(type_system& ts, scope_def& scope, const string_hash& hash);

type_id get_type_expr_node_type(type_system& ts, const ast_node& node);

bool is_castable_to(type_system& ts, type_id a, type_id b);

// Section: helpers

std::hash<std::string>::result_type hash(const std::string& v) {
    return std::hash<std::string>{}(v);
}

std::hash<std::string>::result_type hash(std::string_view v) {
    return std::hash<std::string>{}(std::string{v});
}

std::hash<std::string>::result_type hash(const char* v) {
    return std::hash<std::string>{}(std::string{v});
}

scope_def& curscope(type_system& ts) {
    return *ts.current_scope;
}

type_id register_type(type_system& ts, scope_def& scope, ast_node& node) {
    type_def* t = &node.type_def;
    t->self = &node;
    scope.type_defs.push_back(t);
    type_id id = { &scope, (int)(scope.type_defs.size() - 1) };
    t->id = id;
    declare_type_symbol(ts, scope, t->name);
    //scope.children.push_back(&node.scope);
    return id;
}

type_id register_builtin_type(type_system& ts, arena_ptr<ast_node>&& node) {
    auto id = register_type(ts, ts.builtin_scope->scope, *node);
    ts.builtin_type_nodes.push_back(std::move(node));
    return id;
}

type_id register_user_type(type_system& ts, ast_node& node) {
    auto id = register_type(ts, *ts.current_scope, node);
    ts.current_scope->children.push_back(&node.scope);
    return id;
}

template <typename T> type_id register_integral_type(type_system& ts, const char* name) {
    auto node = make_in_arena<ast_node>(*ts.ast_arena);

    type_def& def = node->type_def;
    def.kind = type_kind::integral;
    def.name = string_hash{ name };
    def.mangled_name = string_hash{ name };
    def.alignment = alignof(T);
    def.size = sizeof(T);
    def.is_signed = std::is_signed_v<T>;
    def.numeric.max = std::numeric_limits<T>::max();
    def.numeric.min = std::numeric_limits<T>::min();
    return register_builtin_type(ts, std::move(node));
}

template <typename T> type_id register_real_type(type_system& ts, const char* name) {
    auto node = make_in_arena<ast_node>(*ts.ast_arena);

    type_def& def = node->type_def;
    def.kind = type_kind::real;
    def.name = string_hash{ name };
    def.mangled_name = string_hash{ name };
    def.alignment = alignof(T);
    def.size = sizeof(T);
    def.is_signed = std::is_signed_v<T>;
    return register_builtin_type(ts, std::move(node));
}

type_def& get_type(type_system& ts, type_id id) {
    return *id.scope->type_defs[id.type_index];
}

bool register_alias_to_type_name(type_system& ts, const std::string& name, const std::string& toname) {
    auto it = curscope(ts).symbols.find(string_hash{ toname });
    if (it == curscope(ts).symbols.end()) {
        return false;
    }

    auto tid = type_id{ it->second->scope, it->second->type_index };

    auto node = make_in_arena<ast_node>(*ts.ast_arena);
    type_def* defcopy = &node->type_def;

    *defcopy = get_type(ts, tid);
    defcopy->name = name;
    defcopy->mangled_name = string_hash{ name };
    defcopy->alias_to = tid;
    register_builtin_type(ts, std::move(node));
    return true;
}

bool register_pointer_type(type_system& ts, const std::string& name, const std::string& toname) {
    auto it = curscope(ts).symbols.find(string_hash{ toname });
    if (it == curscope(ts).symbols.end()) {
        return false;
    }

    auto tid = type_id{ it->second->scope, it->second->type_index };

    auto node = make_in_arena<ast_node>(*ts.ast_arena);

    type_def& tf = node->type_def;
    tf.kind = type_kind::pointer;
    tf.name = string_hash{ name };
    tf.mangled_name = string_hash{ name };
    tf.size = sizeof(void*);
    tf.alignment = alignof(void*);
    tf.elem_type = tid;

    register_builtin_type(ts, std::move(node));
    return true;
}

// Section: types

bool compare_types_exact(const type_def& a, const type_def& b) {
    return a.alias_to == b.alias_to
        && a.alignment == b.alignment
        && a.array.is_static == b.array.is_static
        && a.array.size == b.array.size
        && a.elem_type == b.elem_type
        && a.flags == b.flags
        && a.func.arg_types == b.func.arg_types
        && a.func.ret_type == b.func.ret_type
        && a.is_signed == b.is_signed
        && a.kind == b.kind
        && a.mangled_name == b.mangled_name
        && a.name == b.name
        && a.numeric.min == b.numeric.min
        && a.numeric.max == b.numeric.max
        && a.size == b.size;
}

type_id find_type_by_value(type_system& ts, scope_def& scope, const type_def& tdef) {
    for (const auto& t : scope.type_defs) {
        if (compare_types_exact(*t, tdef)) {
            return t->id;
        }
    }
    return invalid_type;
}

type_id execute_type_template(type_system& ts, scope_def& scope, type_template& tpl, const std::vector<type_template_arg>& args) {
    auto result = tpl.func(args);

    auto tid = find_type_by_value(ts, scope, result->type_def);
    if (!tid.valid()) {
        tid = register_type(ts, scope, *result);
        scope.body_node->temps.push_back(std::move(result));
    }
    return tid;
}

type_id get_pointer_type_to(type_system& ts, type_id elem_type) {
    return execute_type_template(ts, ts.builtin_scope->scope, *ts.ptr_type_template, { elem_type });
}

// is A assignable to B?
bool is_assignable_to(type_system& ts, type_id a, type_id b) {
    if (a == invalid_type || b == invalid_type) return false;

    if (a == b) {
        return true;
    }

    if (get_type(ts, a).alias_to == b || get_type(ts, b).alias_to == a) {
        return true;
    }

    return false;
}

// is A implicitly convertible to B?
bool is_convertible_to(type_system& ts, type_id a, type_id b) {
    if (a == invalid_type || b == invalid_type) return false;
    if (is_assignable_to(ts, a, b)) return true;

    auto& ta = get_type(ts, a);
    auto& tb = get_type(ts, b);

    if (ta.kind == tb.kind && tb.kind == type_kind::integral) {
        return tb.size >= ta.size;
    }

    return false;
}

bool is_comparable(type_system& ts, type_id a, type_id b) {
    return is_convertible_to(ts, a, b) || is_convertible_to(ts, b, a);
}

std::optional<std::string> get_conversion_error_detail(type_system& ts, type_id a, type_id b) {
    if (!a.valid()) return {};
    if (!b.valid()) return {};

    auto& ta = get_type(ts, a);
    auto& tb = get_type(ts, b);

    if (ta.kind == tb.kind && tb.kind == type_kind::integral) {
        if (tb.size < ta.size) {
            return std::string{ "narrowing conversion might overflow, if you are sure about it, make an explicit cast" };
        }
    }

    return {};
}

void try_coerce_to(type_system& ts, ast_node& from, type_id to) {
    if (!from.type_id.valid()) return;
    if (!to.valid()) return;

    auto& ta = get_type(ts, from.type_id);
    auto& tb = get_type(ts, to);

    if (ta.kind == tb.kind && tb.kind == type_kind::integral) {
        if (tb.size < ta.size) {
            if (from.type == ast_type::int_literal && from.int_value < tb.numeric.max) {
                from.type_id = to;
            }
        }
    }
}

// Section: cast checking

using cast_check_func = std::function<bool(type_system&, type_def&, type_def&)>;

bool can_pointer_be_cast_from(type_system& ts, type_def& self, type_def& from) {
    if (self.id == ts.raw_ptr_type) {
        if (from.kind == type_kind::pointer) {
            return true;
        }
        if (from.kind == type_kind::integral) {
            return from.id == ts.uintptr_type;
        }
    }
    else if (from.id == ts.raw_ptr_type) {
        return true;
    }

    if (from.kind == type_kind::pointer) {
        return is_castable_to(ts, from.elem_type, self.elem_type);
    }
    return false;
}

bool can_integral_be_cast_from(type_system& ts, type_def& self, type_def& from) {
    if (self.id == ts.uintptr_type) {
        if (from.kind == type_kind::pointer) {
            return from.id == ts.raw_ptr_type;
        }
        return false;
    }

    if (from.kind == type_kind::integral || from.kind == type_kind::real) {
        return true;
    }

    return false;
}

static std::unordered_map<type_kind, cast_check_func> cast_check_funcs = {
    {type_kind::pointer, can_pointer_be_cast_from},
    {type_kind::integral, can_integral_be_cast_from},
};

// is A explicitly castable to B?
bool is_castable_to(type_system& ts, type_id a, type_id b) {
    if (a == invalid_type || b == invalid_type) return false;
    if (is_convertible_to(ts, a, b)) return true;

    auto& ta = get_type(ts, a);
    auto& tb = get_type(ts, b);

    auto it = cast_check_funcs.find(tb.kind);
    if (it != cast_check_funcs.end()) {
        return it->second(ts, tb, ta);
    }
    return false;
}

// Section: scopes

void add_scope(type_system& ts, ast_node& node, scope_kind k) {
    node.scope.self = &node;
    node.scope.kind = k;
    node.scope.parent = ts.current_scope;
    
    // add to parent's children
    if (ts.current_scope) {
        ts.current_scope->children.push_back(&node.scope);
    }

    ts.current_scope = &node.scope;

    if (k == scope_kind::code_unit) {
        auto fn = std::string{ node.string_value };

        std::string obase, ext;
        split_extension(fn, obase, ext);

        auto base = obase;
        while (replace(base, "/", "::"));
        while (replace(base, "\\", "::"));

        ts.modules[base] = ts.current_scope;

        auto partstr = obase;
        while (replace(partstr, "\\", "/"));
        auto parts = split(partstr, '/');

        ts.current_scope->self_module_key = base;
        ts.current_scope->self_module_parts = parts;
    }
}

void add_func_scope(type_system& ts, ast_node& node, ast_node& body_node) {
    add_scope(ts, node, scope_kind::func_body);
    node.scope.body_node = &body_node;
}

// enter existing scope
void enter_scope_local(type_system& ts, ast_node& node) {
    assert(node.scope.kind != scope_kind::invalid);
    node.scope.parent = ts.current_scope;
    ts.current_scope = &node.scope;
}

void leave_scope_local(type_system& ts) {
    ts.current_scope = curscope(ts).parent;
}

scope_def* find_nearest_scope_local(type_system& ts, scope_kind kind) {
    auto scope = ts.current_scope;
    while (scope != nullptr) {
        if (scope->kind == kind) {
            return scope;
        }

        scope = scope->parent;
    }
    return nullptr;
}

void declare_local_symbol(type_system& ts, const string_hash& hash, ast_node& ld) {
    symbol_info info;
    info.kind = symbol_kind::local;
    info.scope = ts.current_scope;
    info.local_index = curscope(ts).local_defs.size();
    curscope(ts).local_defs.push_back(&ld.local);
    curscope(ts).symbols[hash] = std::make_unique<symbol_info>(info);
}

void declare_top_level_func_symbol(type_system& ts, const string_hash& hash, ast_node& ld) {
    symbol_info info;
    info.kind = symbol_kind::top_level_func;
    info.scope = ts.current_scope;
    info.local_index = curscope(ts).local_defs.size();
    curscope(ts).local_defs.push_back(&ld.local);
    curscope(ts).symbols[hash] = std::make_unique<symbol_info>(info);
}

void declare_type_symbol(type_system& ts, const string_hash& hash) {
    declare_type_symbol(ts, *ts.current_scope, hash);
}

void declare_type_symbol(type_system& ts, scope_def& scope, const string_hash& hash) {
    symbol_info info;
    info.kind = symbol_kind::type;
    info.scope = &scope;
    info.type_index = scope.type_defs.size() - 1;
    scope.symbols[hash] = std::make_unique<symbol_info>(info);
}

void declare_type_template_symbol(type_system& ts, scope_def& scope, const string_hash& hash, ast_node& node) {
    symbol_info info;
    info.kind = symbol_kind::type_template;
    info.scope = &scope;
    info.type_template_index = scope.type_templates.size();
    scope.type_templates.push_back(&node.type_template);
    scope.symbols[hash] = std::make_unique<symbol_info>(info);
}

void declare_overloaded_func_base_symbol(type_system& ts, const string_hash& hash) {
    symbol_info info;
    info.kind = symbol_kind::overloaded_func_base;
    info.scope = ts.current_scope;
    curscope(ts).symbols[hash] = std::make_unique<symbol_info>(info);
}

symbol_info* find_symbol_in_current_scope(type_system& ts, const string_hash& hash) {
    auto it = curscope(ts).symbols.find(hash);
    if (it == curscope(ts).symbols.end()) {
        return nullptr;
    }
    return it->second.get();
}

symbol_info* find_symbol(type_system& ts, const std::pair<string_hash, string_hash>& pair) {
    auto scope = ts.current_scope;
    while (scope != nullptr) {

        auto it = scope->symbols.find(pair.second);
        if (it != scope->symbols.end()) {
            return it->second.get();
        }

        if (pair.first.str.empty()) {
            for (const auto& imp : scope->imports) {
                if (!imp.alias) {
                    auto impscope = ts.modules[imp.qual_name];
                    if (!impscope) break;

                    auto it = impscope->symbols.find(pair.second);
                    if (it != impscope->symbols.end()) {
                        return it->second.get();
                    }
                }
            }
        }
        else {
            auto mod = scope->imports_map.find(pair.first);
            if (mod != scope->imports_map.end()) {
                auto impscope = ts.modules[scope->imports[mod->second].qual_name];

                auto it = impscope->symbols.find(pair.second);
                if (it != impscope->symbols.end()) {
                    return it->second.get();
                }
            }
        }

        scope = scope->parent;
    }
    return {};
}

// Finds the type in scope or parents
type_id find_type_by_id_hash(type_system& ts, const std::pair<string_hash, string_hash>& pair) {
    auto sym = find_symbol(ts, pair);
    if (sym && sym->kind == symbol_kind::type) {
        return type_id{ sym->scope, sym->type_index };
    }
    return invalid_type;
}

local_def* get_symbol_local(const symbol_info& sym) {
    if (sym.scope && sym.local_index > -1) {
        return sym.scope->local_defs[sym.local_index];
    }
    return nullptr;
}

// Section: type errors

std::string node_to_string(const ast_node& node) {
    switch (node.type) {
    case ast_type::int_literal:
        return std::to_string(node.int_value);
    case ast_type::float_literal:
        return std::to_string(node.float_value);
    case ast_type::string_literal:
        return "\"" + (std::string{node.string_value}) + "\"";
    case ast_type::identifier:
        return build_identifier_value(node.id_parts);
    case ast_type::type_expr:
        return node_to_string(*node.children[0]);
    case ast_type::type_qualifier: {
        std::string result;
        if (node.type_qual == type_qualifier::pointer) {
            result += "* ";
        }
        result += node_to_string(*node.children[0]);
        return result;
    }
    case ast_type::index_expr: {
        auto leftstr = node_to_string(*node.children[0]);
        auto rightstr = node_to_string(*node.children[1]);
        return leftstr + "[" + rightstr + "]";
    }
    case ast_type::var_decl: {
        std::string result = node_to_string(*node.local.id_node);
        if (node.local.type_node) {
            result += ": " + node_to_string(*node.local.type_node);
        }
        if (node.local.value_node) {
            result += "= " + node_to_string(*node.local.value_node);
        }
        return result;
    }
    }
    return "";
}

std::string type_to_string(type_id tid) {
    if (tid == invalid_type) {
        return "unknown";
    }

    auto& tdef = tid.get();
    return tdef.name.str;
}

std::string arg_list_to_string(const std::vector<ast_node*>& args) {
    std::string result;
    for (std::size_t i = 0; i < args.size(); i++) {
        result += node_to_string(*args[i]);
        if (i < args.size() - 1) {
            result.append(", ");
        }
    }
    return result;
}

std::string type_list_to_string(const std::vector<type_id>& args) {
    std::string result;
    for (std::size_t i = 0; i < args.size(); i++) {
        result += type_to_string(args[i]);
        if (i < args.size() - 1) {
            result.append(", ");
        }
    }
    return result;
}

std::string func_declaration_to_string(func_def* func) {
    std::string result = "func ";
    result += func->self->local.id_node->id_parts.front() + "(";
    result += type_list_to_string(func->self->type_def.func.arg_types);
    result += "): " + node_to_string(*func->ret_type_node);
    return result;
}

template <typename... Args> void add_module_error(type_system& ts, const position& pos, const char* fmt, Args&&... args) {
    if (!ts.current_error.msg.empty()) {
        ts.errors.push_back(ts.current_error);
    }

    static char wholeb[1024];
    static char msgb[1024];
    snprintf(msgb, sizeof(msgb), fmt, std::forward<Args>(args)...);

    const char* filename = find_nearest_scope_local(ts, scope_kind::code_unit)->self->string_value.data();
    snprintf(wholeb, sizeof(wholeb), "carbonc - ERROR - %s\n\n[%s:%d:%d]\t%s\n", filename, filename, pos.line_number, pos.col_offs, msgb);
    ts.current_error = { pos, std::string{filename}, std::string{wholeb} };
}

template <typename... Args> void unk_type_error(type_system& ts, type_id tid, const position& pos, const char* fmt, Args&&... args) {
    if (ts.pass == type_system_pass::perform_checks && tid == invalid_type) {
        if (!ts.current_error.msg.empty()) {
            ts.errors.push_back(ts.current_error);
        }

        static char wholeb[1024];
        static char msgb[1024];
        snprintf(msgb, sizeof(msgb), fmt, std::forward<Args>(args)...);

        const char* filename = find_nearest_scope_local(ts, scope_kind::code_unit)->self->string_value.data();
        snprintf(wholeb, sizeof(wholeb), "carbonc - ERROR - %s\n\n[%s:%d:%d] %s\n", filename, filename, pos.line_number, pos.col_offs, msgb);
        ts.current_error = { pos, std::string{filename}, std::string{wholeb} };
    }
}

template <typename... Args> void add_type_error(type_system& ts, const position& pos, const char* fmt, Args&&... args) {
    unk_type_error(ts, invalid_type, pos, fmt, std::forward<Args>(args)...);
}

template <typename... Args> void complement_error(type_system& ts, const position& pos, const char* fmt, Args&&... args) {
    if (!ts.current_error.msg.empty() && ts.pass == type_system_pass::perform_checks) {
        static char wholeb[1024];
        static char msgb[1024];
        snprintf(msgb, sizeof(msgb), fmt, std::forward<Args>(args)...);

        const char* filename = find_nearest_scope_local(ts, scope_kind::code_unit)->self->string_value.data();
        snprintf(wholeb, sizeof(wholeb), "[%s:%d:%d] %s\n", filename, pos.line_number, pos.col_offs, msgb);
        ts.current_error.msg.append(wholeb);
    }
}

// Section: resolvers

type_id to_type_id(const symbol_info& info) {
    return { info.scope, info.type_index };
}

type_id get_value_node_type(type_system& ts, ast_node& node) {
    switch (node.type) {
    case ast_type::bool_literal: {
        auto& sym = ts.builtin_scope->scope.symbols[string_hash{ "bool" }];
        return to_type_id(*sym);
    }
    case ast_type::int_literal: {
        auto& sym = ts.builtin_scope->scope.symbols[string_hash{ "int" }];
        return to_type_id(*sym);
    }
    case ast_type::float_literal: {
        auto& sym = ts.builtin_scope->scope.symbols[string_hash{ "float" }];
        return to_type_id(*sym);
    }
    case ast_type::char_literal: {
        auto& sym = ts.builtin_scope->scope.symbols[string_hash{ "char" }];
        return to_type_id(*sym);
    }
    case ast_type::string_literal: {
        auto& sym = ts.builtin_scope->scope.symbols[string_hash{ "raw_string" }];
        return to_type_id(*sym);
    }
    case ast_type::cast_expr: {
        // TODO: check cast is possible and reasonable
        auto to_type = node.children[0]->type_id;
        auto from_type = node.children[1]->type_id;
        if (!is_castable_to(ts, from_type, to_type)) {
            node.type_error = true;
            add_type_error(ts, node.pos, "cannot cast expression of type '%s' to type '%s'", type_to_string(from_type).c_str(), type_to_string(to_type).c_str());
        }
        return to_type;
    }
    case ast_type::binary_expr: {
        if (node.children[0]->type_id == invalid_type || node.children[1]->type_id == invalid_type ||
            node.children[0]->type_error || node.children[1]->type_error) {
            return invalid_type;
        }

        if (is_bool_binary_op(node.op)) {
            if (!is_comparable(ts, node.children[0]->type_id, node.children[1]->type_id)) {
                try_coerce_to(ts, *node.children[1], node.children[0]->type_id);

                if (!is_comparable(ts, node.children[0]->type_id, node.children[1]->type_id)) {
                    node.type_error = true;
                    add_type_error(ts, node.pos, "cannot compare types '%s' and '%s", 
                        type_to_string(node.children[0]->type_id).c_str(), type_to_string(node.children[1]->type_id).c_str()
                    );
                    return invalid_type;
                }   
            }

            node.type_error = false;
            return ts.bool_type;
        }

        if (is_logic_binary_op(node.op)) {
            if (node.children[0]->type_id != ts.bool_type) {
                node.type_error = true;
                add_type_error(ts, node.children[0]->pos,
                    "operand of logic operators (&&, ||) has type '%s', it must be 'bool'",
                    type_to_string(node.children[0]->type_id).c_str());
                return invalid_type;
            }
            if (node.children[1]->type_id != ts.bool_type) {
                node.type_error = true;
                add_type_error(ts, node.children[1]->pos,
                    "operand of logic operators (&&, ||) has type '%s', it must be 'bool'",
                    type_to_string(node.children[1]->type_id).c_str());
                return invalid_type;
            }
            node.type_error = false;
            return ts.bool_type;
        }

        node.type_error = false;
        return node.children[0]->type_id;
    }
    }

    return invalid_type;
}

std::pair<string_hash, string_hash> separate_module_identifier(const std::vector<std::string>& parts) {
    if (parts.empty()) return {};

    std::string mod, id;
    for (std::size_t i = 0; i < parts.size(); i++) {
        if (i == parts.size() - 1) {
            id.append(parts[i]);
        }
        else {
            mod.append(parts[i]);
        }
    }

    return std::make_pair(string_hash{ mod }, string_hash{ id });
}

type_id get_type_expr_node_type(type_system& ts, ast_node& node) {
    switch (node.type) {
    case ast_type::identifier:
        node.type_id = find_type_by_id_hash(ts, separate_module_identifier(node.id_parts));
        break;
    case ast_type::type_qualifier: {
        if (node.type_qual == type_qualifier::pointer) {
            auto elem_type = get_type_expr_node_type(ts, *node.children[0]);
            node.type_id = get_pointer_type_to(ts, elem_type);
        }
        break;
    }
    }

    return node.type_id;
}

void propagate_return_type(type_system& ts, const type_id& id) {
    //auto scope_id = find_nearest_scope(ts, scope_kind::func_body);
    //ts.scopes[scope_id].announced_return_types.push_back(id);
}

type_id resolve_local_variable_type(type_system& ts, ast_node& l) {
    auto decl_type = l.local.type_node ? resolve_node_type(ts, l.local.type_node) : type_id{};
    auto val_type = l.local.value_node ? resolve_node_type(ts, l.local.value_node) : type_id{};

    if (l.local.type_node && decl_type.valid()) {
        l.type_id = decl_type;
        l.type_error = l.local.type_node->type_error;
    }
    else if (!l.local.type_node) {
        l.type_id = val_type;
        l.type_error = l.local.value_node->type_error;
    }

    return l.type_id;
}

bool match_arg_list(type_system& ts, const std::vector<ast_node*>& func_args, const std::vector<ast_node*>& call_args) {
    if (func_args.size() != call_args.size()) return false;

    for (std::size_t i = 0; i < func_args.size(); i++) {
        auto farg = func_args[i];
        auto carg = call_args[i];
        if (!is_convertible_to(ts, carg->type_id, farg->type_id)) {
            try_coerce_to(ts, *carg, farg->type_id);
            if (!is_convertible_to(ts, carg->type_id, farg->type_id)) {
                return false;
            }
        }
    }
    return true;
}

string_hash mangle_func_name(type_system& ts, const std::vector<std::string>& id_parts, const std::vector<ast_node*>& args, func_linkage linkage) {
    //assert(f.type_id != invalid_type);

    if (linkage == func_linkage::local_carbon || linkage == func_linkage::external_carbon) {
        std::string name = "cb";
        for (const auto& part : id_parts) {
            name.append("$N");
            name.append(part);
        }
        name.append("$AB");
        for (auto& arg : args) {
            assert(arg->type_id != invalid_type);
            auto tdef = arg->type_id.get();
            name.append("$A");
            name.append(tdef.mangled_name.str);
        }
        return string_hash{ name };
    }
    else {
        return string_hash{ id_parts.back() };
    }
}

void resolve_func_args_type(type_system& ts, ast_node& node) {
    auto funcname = node_to_string(*node.local.id_node);

    node.func.args_unresolved = false;
    node.type_def.func.arg_types.clear();
    for (auto& arg : node.func.arguments) {
        resolve_local_variable_type(ts, *arg);
        if (arg->type_id == invalid_type || arg->type_error) {
            node.func.args_unresolved = true;

            auto name = node_to_string(*arg->local.id_node);
            complement_error(ts, arg->pos, "in declaration of #%d argument '%s' of function '%s'", arg->local.arg_index + 1, name.c_str(), funcname.c_str());
        }
        node.type_def.func.arg_types.push_back(arg->type_id);
    }
}

// TODO: deduce type from return statements

type_id resolve_func_type(type_system& ts, ast_node& f) {
    assert(f.func.ret_type_node || !"func not declared yet");

    auto funcname = node_to_string(*f.local.id_node);

    f.type_def.kind = type_kind::func;
    f.type_def.size = sizeof(void*);
    f.type_def.alignment = sizeof(void*);
    f.type_def.is_signed = false;

    auto ret_type = resolve_node_type(ts, f.func.ret_type_node);
    if (!ret_type.valid()) {
        f.type_error = true;
        complement_error(ts, f.pos, "in return type of function '%s'", funcname.c_str());
    }

    if (ret_type.valid()) {
        if (f.func.return_statements.empty() && ret_type != ts.void_type && f.func.linkage == func_linkage::local_carbon) {
            add_type_error(ts, f.func.ret_type_node->pos,
                "function '%s' has return type '%s' but no return statements",
                funcname.c_str(),
                type_to_string(ret_type).c_str());
        }
        for (auto retst : f.func.return_statements) {
            if (!is_convertible_to(ts, retst->type_id, ret_type)) {
                add_type_error(ts, retst->pos,
                    "cannot return type '%s' from function '%s' declared returning type '%s'",
                    type_to_string(retst->type_id).c_str(),
                    funcname.c_str(),
                    type_to_string(ret_type).c_str());
                break;
            }
        }
    }
    
    if (!f.type_id.valid() && !f.func.args_unresolved && ret_type.valid()) {
        f.type_def.func.ret_type = ret_type;
        f.type_id = register_user_type(ts, f);
    }
    return f.type_id;
}

// Section: declarations

void register_func_declaration_node(type_system& ts, ast_node& node) {
    node.scope.self = &node;
    node.func.self = &node;
    node.local.self = &node;

    auto& id = node.children[ast_node::child_func_decl_id];
    auto& arg_list = node.children[ast_node::child_func_decl_arg_list]->children;
    auto& body = node.children[ast_node::child_func_decl_body];

    node.local.id_node = id.get();
    node.func.ret_type_node = node.children[ast_node::child_func_decl_ret_type].get();

    if (!node.func.ret_type_node) {
        auto id_void = make_identifier_node(*ts.ast_arena, {}, { "void" });
        auto ret_type = make_type_expr_node(*ts.ast_arena, {}, std::move(id_void));
        node.func.ret_type_node = ret_type.get();
        node.temps.push_back(std::move(ret_type));
    }

    node.func.base_symbol = build_identifier_value(node.local.id_node->id_parts);
    auto ovbase = find_symbol_in_current_scope(ts, node.func.base_symbol);
    if (!ovbase) {
        declare_overloaded_func_base_symbol(ts, node.func.base_symbol);
    }

    // try to resolve the return type already
    resolve_node_type(ts, node.func.ret_type_node);

    if (body) {
        add_func_scope(ts, node, *body);
    }
    
    int idx = 0;
    for (auto& arg : arg_list) {
        assert(arg->type == ast_type::var_decl);

        auto& argid = arg->children[ast_node::child_var_decl_id];
        auto& argtype = arg->children[ast_node::child_var_decl_type];
        auto& argvalue = arg->children[ast_node::child_var_decl_value];

        arg->local.self = arg.get();
        arg->local.id_node = argid.get();
        arg->local.type_node = argtype.get();
        arg->local.value_node = argvalue.get();
        arg->local.is_argument = true;
        arg->local.arg_index = idx;
        arg->local.arg_func_node = &node;

        resolve_local_variable_type(ts, *arg);
        if (body) {
            declare_local_symbol(ts, { arg->local.id_node->id_parts.front() }, *arg);
        }

        node.func.arguments.push_back(arg.get());
        idx++;
    }

    if (body) {
        visit_tree(ts, *body);
        leave_scope_local(ts);
    }

    // try to resolve the func type already
    node.func.args_unresolved = true; // assume args are unresolved, possibly wasting a type check pass
    resolve_func_type(ts, node);
}

void register_var_declaration_node(type_system& ts, ast_node& node) {
    node.local.self = &node;
    node.local.id_node = node.children[ast_node::child_var_decl_id].get();
    node.local.type_node = node.children[ast_node::child_var_decl_type].get();
    node.local.value_node = node.children[ast_node::child_var_decl_value].get();

    auto id = string_hash{ build_identifier_value(node.local.id_node->id_parts) };
    auto prev = find_symbol_in_current_scope(ts, id);
    if (prev) {
        //add_error(ts, "cannot redeclare '%s'", id->string_value.data());
        assert(!"cannot redeclare");
        return;
    }

    resolve_local_variable_type(ts, node);

    declare_local_symbol(ts, id, node);
}

// Section: main visitor

void clear_type_errors(type_system& ts, ast_node& node) {
    node.type_error = false;
    for (auto& child : node.children) {
        if (child) {
            clear_type_errors(ts, *child);
        }
    }
}

void visit_children(type_system& ts, ast_node& node) {
    for (auto& child : node.children) {
        if (child) {
            visit_tree(ts, *child);
        }
    }
}

template <typename F> void for_each_child_recur(ast_node& node, ast_type type, F f) {
    for (auto& child : node.children) {
        if (child) {
            if (child->type == type) { f(*child); }
            for_each_child_recur(*child, type, f);
        }
    }
}

type_id resolve_node_type(type_system& ts, ast_node* nodeptr) {
    if (!nodeptr) return invalid_type;

    auto& node = *nodeptr;
    bool check_for_unresolved = true;

    switch (node.type) {
    case ast_type::import_decl: {
        check_for_unresolved = false;
        auto scope = ts.current_scope;
        auto qual_name = string_hash{ build_identifier_value(node.children[0]->id_parts) };

        std::optional<string_hash> aliastr{};
        if (node.children[1]) {
            aliastr = string_hash{ build_identifier_value(node.children[1]->id_parts) };
            scope->imports_map[*aliastr] = scope->imports.size();
        }
        else {
            scope->imports_map[qual_name] = scope->imports.size();
        }

        scope->imports.push_back(scope_import{ qual_name, aliastr });
        break;
    }
    case ast_type::type_expr: {
        if (ts.pass != type_system_pass::perform_checks && node.type_id != invalid_type) return node.type_id;

        node.type_id = get_type_expr_node_type(ts, *node.children[0]);
        if (!node.type_id.valid()) {
            auto str = node_to_string(node);
            unk_type_error(ts, node.type_id, node.pos, "unknown type '%s'", str.c_str());
        }
        break;
    }
    case ast_type::return_stmt: {
        if (ts.pass != type_system_pass::perform_checks && node.type_id != invalid_type) return node.type_id;

        node.type_id = resolve_node_type(ts, node.children.front().get());
        if (!node.type_id.valid() || node.type_error) {
            auto funcname = node_to_string(
                *(find_nearest_scope_local(ts, scope_kind::func_body)->self->local.id_node)
            );
            complement_error(ts, node.pos, "in return statement of function '%s'", funcname.c_str());
        }

        // TODO: check if scope / sanity check
        if (ts.pass == type_system_pass::resolve_literals_and_register_declarations) {
            auto scope = find_nearest_scope_local(ts, scope_kind::func_body);
            scope->self->func.return_statements.push_back(nodeptr);
        }
        break;
    }
    case ast_type::if_stmt: {
        check_for_unresolved = false;
        visit_children(ts, node);

        if (!node.children[0]->type_id.valid() || node.children[0]->type_error) {
            complement_error(ts, node.pos, "in if statement condition");
            node.type_error = true;
        }
        else if (!is_convertible_to(ts, node.children[0]->type_id, ts.bool_type)) {
            try_coerce_to(ts, *node.children[0], ts.bool_type);
            if (!is_convertible_to(ts, node.children[0]->type_id, ts.bool_type)) {
                add_type_error(ts, node.pos, "if statement condition must have bool type or be convertible to bool");
                node.type_error = true;
            }
        }

        // TODO: recursively do this

        if (!node.type_error && !is_bool_binary_op(*node.children[0]) && !is_logic_binary_op(*node.children[0])) {
            node.children[0] = make_binary_expr_node(
                *ts.ast_arena,
                node.children[0]->pos,
                token_type::neq,
                std::move(node.children[0]),
                make_bool_literal_node(*ts.ast_arena, node.children[0]->pos, 0)
            );
            resolve_node_type(ts, node.children[0].get());
        }
        break;
    }
    case ast_type::linkage_specifier: {
        check_for_unresolved = false;
        for_each_child_recur(node, ast_type::func_decl, [&node](ast_node& child) {
            child.func.linkage = node.func.linkage;
        });
        visit_children(ts, node);
        break;
    }
    case ast_type::func_decl: {
        if (ts.pass == type_system_pass::resolve_literals_and_register_declarations) {
            register_func_declaration_node(ts, node);
        }
        else {
            auto funcname = node_to_string(*node.local.id_node);
            resolve_func_args_type(ts, node);

            auto& body = node.children[ast_node::child_func_decl_body];
            if (body) {
                enter_scope_local(ts, node);
                visit_tree(ts, *body);
                leave_scope_local(ts);
            }
            else if (node.func.linkage == func_linkage::local_carbon) {
                // TODO: error
                assert(!"func linkage error");
            }

            resolve_func_type(ts, node);
            if (!node.type_id.valid()) {
                //auto funcname = node_to_string(*node.local.id_node);
                //complement_error(ts, node.pos, "in declaration of function '%s'", funcname.c_str());
            }

            if (node.type_id != invalid_type && ts.current_scope->kind == scope_kind::code_unit && node.type_def.mangled_name.str.empty()) {
                // this means the function type was resolved, so mangle the name and declare it

                node.type_def.mangled_name = mangle_func_name(ts, node.local.id_node->id_parts, node.func.arguments, node.func.linkage);

                auto bsym = find_symbol_in_current_scope(ts, node.func.base_symbol);
                for (auto& f : bsym->overload_funcs) {
                    if (f->self->type_def.mangled_name == node.type_def.mangled_name) {
                        node.type_error = true;
                        add_type_error(ts, node.pos, "cannot redeclare the same argument list for the same function");
                        complement_error(ts, node.pos, "in declaration of function '%s'", funcname.c_str());
                    }
                }

                bsym->overload_funcs.push_back(&node.func);
                declare_top_level_func_symbol(ts, node.type_def.mangled_name, node);
            }
        }
        break;
    }
    case ast_type::call_expr: {
        if (ts.pass != type_system_pass::perform_checks && node.type_id != invalid_type) return node.type_id;

        if (!node.call.self) {
            node.call.self = &node;
            node.call.func_node = node.children[ast_node::child_call_expr_callee].get();
            for (auto& arg : node.children[ast_node::child_call_expr_arg_list]->children) {
                node.call.args.push_back(arg.get());
            }
        }
        auto funcname = node_to_string(*node.call.func_node);

        bool args_resolved = true;
        int argindex = 0;
        node.call.arg_types.clear();
        for (auto& arg : node.call.args) {
            resolve_node_type(ts, arg);
            //complement_error(arg->type_id, arg->pos, "in the #%d argument for function %s", node_to_string(node));
            if (arg->type_id == invalid_type || arg->type_error) {
                node.type_error = true;
                complement_error(ts, arg->pos, "in the #%d argument for function call to '%s'", argindex+1, funcname.c_str());
                if (arg->type_id == invalid_type) {
                    args_resolved = false;
                    break;
                }
            }
            else {
                node.call.arg_types.push_back(arg->type_id);
            }
            argindex++;
        }

        if (!args_resolved) {
            //auto funcname = node_to_string(*node.call.func_node);
            //complement_error(ts, node.pos, "because of that, function call to '%s' has type 'unknown'", funcname.c_str());
        }

        if (node.call.func_node->type == ast_type::identifier) {
            if (args_resolved) {
                // both args and func resolved
                auto pair = separate_module_identifier(node.call.func_node->id_parts);

                for (const auto& linkage : { func_linkage::local_carbon, func_linkage::external_c }) {    
                    node.call.mangled_name = mangle_func_name(ts, { pair.second.str }, node.call.args, linkage);

                    auto sym = find_symbol(ts, { pair.first, node.call.mangled_name });
                    if (sym && sym->kind == symbol_kind::top_level_func) {
                        auto local = sym->scope->local_defs[sym->local_index];
                        node.type_id = local->self->type_def.func.ret_type;
                        node.call.func_type_id = local->self->type_id;
                        node.call.funcdef = &local->self->func;
                        break;
                    }
                }

                if (!node.type_id.valid()) {
                    node.type_error = true;

                    auto funcname = node_to_string(*node.call.func_node);
                    unk_type_error(ts, node.type_id, node.pos, "cannot determine type of function call to '%s'", funcname.c_str());

                    auto bsym = find_symbol(ts, pair);
                    if (bsym && bsym->kind == symbol_kind::overloaded_func_base) {
                        // try to match the arguments performing implicit conversions
                        bool resolved = false;
                        for (std::size_t i = 0; i < bsym->overload_funcs.size(); i++) {
                            auto func = bsym->overload_funcs[i];
                            if (match_arg_list(ts, func->arguments, node.call.args)) {
                                resolved = true;
                                node.type_id = func->self->type_def.func.ret_type;
                                node.call.func_type_id = func->self->type_id;
                                node.call.funcdef = func;
                                break;
                            }
                        }

                        if (!resolved) {
                            complement_error(ts, node.pos, "function exists but cannot find a matching argument list");
                            for (std::size_t i = 0; i < bsym->overload_funcs.size(); i++) {
                                auto func = bsym->overload_funcs[i];
                                complement_error(ts, node.pos, "candidate #%d: '%s' declared in %s:%d",
                                    (i + 1), func_declaration_to_string(func).c_str(), func->self->pos.filename.c_str(), func->self->pos.line_number);
                            }
                            complement_error(ts, node.pos, "call arguments: (%s)", type_list_to_string(node.call.arg_types).c_str());
                        }
                    }
                    else if (bsym) {
                        complement_error(ts, node.pos, "symbol '%s' is not a function", funcname.c_str());
                    }
                    else {
                        complement_error(ts, node.pos, "undefined symbol '%s'", funcname.c_str());
                    }
                }
            }
        }

        //report_type_error(node.type_id, node.pos, "cannot resolve type of function call %s", node_to_string(node));
        break;
    }
    case ast_type::index_expr: {
        if (ts.pass == type_system_pass::resolve_literals_and_register_declarations) break;

        resolve_node_type(ts, node.children[0].get());
        resolve_node_type(ts, node.children[1].get());
        bool arr = false;
        bool ptr = false;

        if (node.children[0]->type_id.valid()) {
            arr = node.children[0]->type_id.get().kind == type_kind::array;
            ptr = node.children[0]->type_id.get().kind == type_kind::pointer;
        }
        bool arr_or_ptr = arr || ptr;

        bool error = false;
        {
            const char* msg = "left-side of index expression has type '%s', it must be an array or pointer";
            if (!node.children[0]->type_id.valid()) {
                complement_error(ts, node.pos, msg, type_to_string(node.children[0]->type_id).c_str());
                error = true;
            }
            else if (!arr_or_ptr) {
                add_type_error(ts, node.pos, msg, type_to_string(node.children[0]->type_id).c_str());
                error = true;
            }
        }

        {
            const char* msg = "right-side of index expression has type '%s', it must be an integer";
            if (!node.children[1]->type_id.valid()) {
                complement_error(ts, node.pos, msg, type_to_string(node.children[1]->type_id).c_str());
                error = true;
            }
            else if (arr_or_ptr && !(node.children[1]->type_id.get().kind == type_kind::integral)) {
                add_type_error(ts, node.pos, msg, type_to_string(node.children[1]->type_id).c_str());
                error = true;
            }
        }

        node.type_error = error;
        if (!error) {
            node.lvalue.self = &node;
            if (arr_or_ptr) {
                node.type_id = node.children[0]->type_id.get().elem_type;
            }
        }
        break;
    }
    case ast_type::var_decl: {
        if (ts.pass == type_system_pass::resolve_literals_and_register_declarations) {
            register_var_declaration_node(ts, node);
        }
        else {
            resolve_local_variable_type(ts, node);
            if (!node.type_id.valid() || node.type_error) {
                auto name = node_to_string(*node.local.id_node);
                complement_error(ts, node.pos, "in declaration of variable '%s'", name.c_str());
            }
        }
        break;
    }
    case ast_type::identifier: {
        if (ts.pass != type_system_pass::perform_checks && node.type_id != invalid_type) return node.type_id;

        auto sym = find_symbol(ts, separate_module_identifier(node.id_parts));
        if (sym && sym->kind == symbol_kind::local) {
            auto local = get_symbol_local(*sym);

            node.lvalue.self = &node;
            node.lvalue.symbol = *sym;
            node.type_id = local->self->type_id;

            if (!node.type_id.valid()) {
                unk_type_error(ts, node.type_id, node.pos, "cannot determine type of symbol '%s'", node_to_string(node).c_str());
            }
        }

        if (!sym) {
            unk_type_error(ts, node.type_id, node.pos, "unknown symbol '%s'", node_to_string(node).c_str());
        }
        break;
    }
    case ast_type::binary_expr: {
        visit_children(ts, node);

        node.type_error = (node.children[0]->type_error || node.children[1]->type_error);
        if (token_to_char(node.op) == '=') {
            
            if ((!node.children[0]->type_id.valid() || node.children[0]->type_error) || (!node.children[1]->type_id.valid() || node.children[1]->type_error)) {
                complement_error(ts, node.pos, "in assignment of '%s'", node_to_string(*node.children[0]).c_str());
            }
            else if (!(node.children[0]->lvalue.self)) {
                add_type_error(ts, node.pos, "left-side of assignment must be an lvalue (identifier, index expression)");
            }

            if (node.children[0]->type == ast_type::identifier) {
                auto local = get_symbol_local(node.children[0]->lvalue.symbol);
                if (local && local->self->op == token_type::let) {
                    add_type_error(ts, node.children[0]->pos, "cannot re-assign a 'let' value, use 'var' instead");
                    node.type_error = true;
                }
            }

            if (!is_convertible_to(ts, node.children[1]->type_id, node.children[0]->type_id)) {
                try_coerce_to(ts, *node.children[1], node.children[0]->type_id);

                if (!is_convertible_to(ts, node.children[1]->type_id, node.children[0]->type_id)) {
                    add_type_error(ts, node.children[1]->pos, "cannot convert type '%s' to '%s'",
                        type_to_string(node.children[1]->type_id).c_str(),
                        type_to_string(node.children[0]->type_id).c_str());

                    auto detail = get_conversion_error_detail(ts, node.children[1]->type_id, node.children[0]->type_id);
                    if (detail) {
                        complement_error(ts, node.pos, detail->c_str());
                    }

                    complement_error(ts, node.pos, "in assignment of '%s'", node_to_string(*node.children[0]).c_str());
                    node.type_error = true;
                }
                else {
                    node.type_id = node.children[0]->type_id;
                }
            }
            else {
                node.type_id = node.children[0]->type_id;
            }
        }
        else {
            // TODO: check operators make sense for types
            node.type_error = (node.children[0]->type_error || node.children[1]->type_error);
            node.type_id = get_value_node_type(ts, node);
        }
        break;
    }
    case ast_type::unary_expr: {
        visit_children(ts, node);
        node.type_error = node.children[0]->type_error;
        if (token_to_char(node.op) == '*') {
            // deref expression

            if (!(node.children[0]->type_id.valid() && node.children[0]->type_id.get().kind == type_kind::pointer)) {
                add_type_error(ts, node.children[0]->pos,
                    "right-side of unary '*' (deref operation) has type '%s', it must be a pointer",
                    type_to_string(node.children[0]->type_id).c_str());
                node.type_error = true;
            }
            else {
                node.lvalue.self = &node;
                node.type_id = node.children[0]->type_id.get().elem_type;
                node.type_error = false;
            }
        }
        else if (token_to_char(node.op) == '&') {
            // addressof expression

            if (!(node.children[0]->type_id.valid())) {
                node.type_error = true;
            }
            else if (!node.children[0]->lvalue.self) {
                add_type_error(ts, node.children[0]->pos,
                    "right-side of unary '&' (addressof operation) must be an lvalue (identifier, index expression)");
                node.type_error = true;
            }
            else {
                node.type_id = get_pointer_type_to(ts, node.children[0]->type_id);
                node.type_error = false;
            }
        }
        break;
    }
    case ast_type::cast_expr:
        visit_children(ts, node);
        node.type_id = get_value_node_type(ts, node);
        break;
    case ast_type::bool_literal:
    case ast_type::int_literal:
    case ast_type::float_literal:
    case ast_type::char_literal:
    case ast_type::string_literal:
        node.type_id = get_value_node_type(ts, node);
        break;
    default: {
        visit_children(ts, node);
        check_for_unresolved = false;
        break;
    }
    }

    if (check_for_unresolved) {
        if (node.type_id == invalid_type) {
            ts.unresolved_types = true;
        }
    }
    return node.type_id;
}

// TODO: obviously need better stuff here
static int temp_count = 0;

std::pair<arena_ptr<ast_node>, arena_ptr<ast_node>> make_temp_variable_for_call(type_system& ts, ast_node& call) {
    // generate the temp ID
    std::string tempname = "$cbT" + std::to_string(temp_count++);
    auto id_node = make_identifier_node(*ts.ast_arena, {}, { tempname });

    auto val_node = make_call_expr_node(*ts.ast_arena, {}, std::move(call.children[ast_node::child_call_expr_callee]), std::move(call.children[ast_node::child_call_expr_arg_list]));
    // The call might have a pre-children of itself
    val_node->pre_children = std::move(call.pre_children);

    // Generate and register the declaration of the temp
    auto decl = make_var_decl_node(*ts.ast_arena, {}, token_type::let, std::move(id_node), { nullptr, nullptr }, std::move(val_node));
    register_var_declaration_node(ts, *decl);

    // Make a reference to use as the new argument
    auto ref = make_identifier_node(*ts.ast_arena, {}, { tempname });
    resolve_node_type(ts, ref.get());

    return std::make_pair(std::move(decl), std::move(ref));
}

std::pair<arena_ptr<ast_node>, arena_ptr<ast_node>> make_temp_variable_for_index_expr(type_system& ts, arena_ptr<ast_node>&& lhs) {
    // generate the temp ID
    std::string tempname = "$cbT" + std::to_string(temp_count++);
    auto id_node = make_identifier_node(*ts.ast_arena, {}, { tempname });

    // Generate and register the declaration of the temp
    auto decl = make_var_decl_node(*ts.ast_arena, {}, token_type::let, std::move(id_node), { nullptr, nullptr }, std::move(lhs));
    register_var_declaration_node(ts, *decl);

    // Make a reference to use as the new argument
    auto ref = make_identifier_node(*ts.ast_arena, {}, { tempname });
    resolve_node_type(ts, ref.get());

    return std::make_pair(std::move(decl), std::move(ref));
}

void final_analysis(type_system& ts, ast_node* nodeptr) {
    if (!nodeptr) return;

    auto& node = *nodeptr;
    switch (node.type) {
    case ast_type::func_decl: {
        // remangle the function name with the fully qualified module name
        if ((node.func.linkage == func_linkage::external_carbon || node.func.linkage == func_linkage::local_carbon)
            && !node.func.args_unresolved) {

            auto parts = ts.current_scope->self_module_parts;
            for (const auto& part : node.local.id_node->id_parts) {
                parts.push_back(part);
            }
            
            node.type_def.mangled_name = mangle_func_name(ts, parts, node.func.arguments, node.func.linkage);
        }

        if (node.scope.body_node) { enter_scope_local(ts, node); }
        visit_children(ts, node);
        if (node.scope.body_node) { leave_scope_local(ts); }
        break;
    }
    case ast_type::call_expr: {
        // transform nested call expressions into temporary variables
        visit_children(ts, node);

        // update the called function mangled name
        if (node.call.funcdef) {
            node.call.mangled_name = node.call.funcdef->self->type_def.mangled_name;
        }
        break;
    }
    default: {
        visit_children(ts, node);
        break;
    }
    }
}

void spit_declaration(type_system& ts, ast_node& node, std::ofstream& file) {
    switch (node.type) {
    case ast_type::import_decl: {
        file << "import " << build_identifier_value(node.children[0]->id_parts);
        if (node.children[1]) {
            file << " as " << build_identifier_value(node.children[1]->id_parts);
        }
        file << ";\n";
        break;
    }
    case ast_type::linkage_specifier: {
        for (auto& child : node.children) {
            if (child) {
                child->func.linkage = node.func.linkage;
                spit_declaration(ts, *child, file);
            }
        }
        break;
    }
    case ast_type::func_decl: {
        auto linkage = node.func.linkage;
        if (linkage == func_linkage::local_carbon) {
            linkage = func_linkage::external_carbon;
        }
        file << func_linkage_name(linkage) << " " << build_identifier_value(node.children[0]->id_parts);
        file << "(";

        file << "):";
        spit_declaration(ts, *node.children[ast_node::child_func_decl_ret_type], file);
        file << ";\n";
        break;
    }
    case ast_type::visibility_specifier: {
        if (node.op == token_type::public_) {
            for (auto& child : node.children) {
                if (child) {
                    spit_declaration(ts, *child, file);
                }
            }
        }
        break;
    }
    default: {
        for (auto& child : node.children) {
            if (child) {
                spit_declaration(ts, *child, file);
            }
        }
        break;
    }
    }
}

void create_interface_file(type_system& ts, ast_node& unit) {
    auto path = "_carbon/interface/" + std::string{ unit.string_value };
    replace(path, ".cb", ".cbi");
    ensure_directory_exists(path);
    std::ofstream ifile{ path };
    for (auto& child : unit.children) {
        if (child) {
            spit_declaration(ts, *child, ifile);
        }
    }
}

void resolve_imports(type_system& ts, ast_node& node) {
    if (node.scope.kind != scope_kind::invalid) {
        for (auto& imp : node.scope.imports) {
            if (imp.qual_name.hash == node.scope.self_module_key.hash) {
                add_module_error(ts, node.pos, "a module cannot import itself '%s'", imp.qual_name.str.c_str());
                continue;
            }

            if (!ts.modules[imp.qual_name]) {
                // "TODO: look for interface file";
                add_module_error(ts, node.pos, "cannot find module '%s'", imp.qual_name.str.c_str());
                continue;
            }
        }
    }
    visit_children(ts, node);
}

void visit_tree(type_system& ts, ast_node& node) {
    switch (ts.pass) {
    case type_system_pass::create_interface_files:
        create_interface_file(ts, node);
        break;
    case type_system_pass::resolve_literals_and_register_declarations:
    case type_system_pass::perform_checks:
    case type_system_pass::resolve_all: {
        resolve_node_type(ts, &node);
        break;
    }
    case type_system_pass::resolve_imports:
        resolve_imports(ts, node);
        break;
    case type_system_pass::final_analysis:
        final_analysis(ts, &node);
        break;
    }
}

}

type_system::type_system(memory_arena& arena) {
    ast_arena = &arena;
    builtin_scope = new ast_node{};
    builtin_scope->scope.body_node = builtin_scope;
    add_scope(*this, *builtin_scope, scope_kind::builtin);

    // the type of all types :)
    {
        auto node = make_in_arena<ast_node>(*ast_arena);

        type_def& tf = node->type_def;
        tf.kind = type_kind::type;
        tf.name = string_hash{ "type" };
        tf.mangled_name = string_hash{ "type" };
        type_type = register_builtin_type(*this, std::move(node));
    }

    // void and void*
    {
        auto node = make_in_arena<ast_node>(*ast_arena);

        type_def& tf = node->type_def;
        tf.kind = type_kind::unit;
        tf.name = string_hash{ "void" };
        tf.mangled_name = string_hash{ "void" };
        void_type = register_builtin_type(*this, std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);

        type_def& tf = node->type_def;
        tf.kind = type_kind::pointer;
        tf.name = string_hash{ "raw_ptr" };
        tf.mangled_name = string_hash{ "raw_ptr" };
        tf.size = sizeof(void*);
        tf.alignment = alignof(void*);
        tf.elem_type = { builtin_scope->scope.symbols[string_hash{"void"}]->scope, 0 };
        raw_ptr_type = register_builtin_type(*this, std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);

        type_def& tf = node->type_def;
        tf.kind = type_kind::integral;
        tf.name = string_hash{ "uintptr" };
        tf.mangled_name = string_hash{ "uintptr" };
        tf.size = sizeof(std::uintptr_t);
        tf.alignment = alignof(std::uintptr_t);
        uintptr_type = register_builtin_type(*this, std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);

        type_def& tf = node->type_def;
        tf.kind = type_kind::integral;
        tf.name = string_hash{ "ptrdiff" };
        tf.mangled_name = string_hash{ "ptrdiff" };
        tf.size = sizeof(std::ptrdiff_t);
        tf.alignment = alignof(std::ptrdiff_t);
        ptrdiff_type = register_builtin_type(*this, std::move(node));
    }

    // register built-in types
    register_integral_type<std::uint8_t>(*this, "uint8");
    register_integral_type<std::uint16_t>(*this, "uint16");
    register_integral_type<std::uint32_t>(*this, "uint32");
    register_integral_type<std::uint64_t>(*this, "uint64");
    register_integral_type<std::size_t>(*this, "usize");
    bool_type = register_integral_type<bool>(*this, "bool");

    register_integral_type<std::int8_t>(*this, "int8");
    register_integral_type<std::int16_t>(*this, "int16");
    register_integral_type<std::int32_t>(*this, "int32");
    register_integral_type<std::int64_t>(*this, "int64");

    register_real_type<float>(*this, "float32");
    register_real_type<double>(*this, "float64");

    register_alias_to_type_name(*this, "char", "int8");
    register_alias_to_type_name(*this, "uint", "uint32");
    register_alias_to_type_name(*this, "int", "int32");
    register_alias_to_type_name(*this, "float", "float32");

    register_pointer_type(*this, "raw_string", "int8");

    {
        auto node = make_in_arena<ast_node>(*ast_arena);

        type_template* ptr_template = &node->type_template;
        ptr_template->name = string_hash{ "*" };
        ptr_template->self = node.get();
        ptr_template->func = [this](const std::vector<type_template_arg>& arg) {
            auto type_arg = std::get<type_id>(arg.front());
            auto node = make_in_arena<ast_node>(*ast_arena);
            type_def& tf = node->type_def;

            tf.kind = type_kind::pointer;
            tf.name = string_hash{ "* " + type_arg.get().name.str };
            tf.mangled_name = string_hash{ "ptr_" + type_arg.get().mangled_name.str };
            tf.size = sizeof(void*);
            tf.alignment = alignof(void*);
            tf.elem_type = type_arg;
            return node;
        };

        ptr_type_template = ptr_template;
        declare_type_template_symbol(*this, builtin_scope->scope, ptr_template->name, *node);
        builtin_type_nodes.push_back(std::move(node));
    }

/*
    register_alias_to_type_template(*this, "raw_str", {"*", "char"});

    register_builtin_type_template(*this, "*", {
        {type_template_param_kind::type, -1, {}},
        [this](std::vector<type_template_param> params) -> type_def {
            type_def result{};
            result.kind = type_kind::raw_pointer;
            result.raw_pointer.pointer_to = params[0].type_id_value;
            return result;
        }
    });

    register_builtin_type_template(*this, "(static array)", {
        {type_template_param_kind::value, type_map["usize"], {}},
        {type_template_param_kind::type, -1, {}},
        [this](std::vector<type_template_param> params) -> type_def {
            type_def result{};
            result.kind = type_kind::array;
            result.array.size = (std::size_t)params[0].int_value;
            result.array.item_type = params[1].type_id_value;
            result.array.is_static = true;
            return result;
        }
    });
*/
}

void type_system::process_code_unit(ast_node& node) {
    this->pass = type_system_pass::resolve_literals_and_register_declarations;
    this->code_units.push_back(&node);

    add_scope(*this, node, scope_kind::code_unit);
    visit_tree(*this, node);
    leave_scope();
}

void type_system::resolve_and_check() {
    this->pass = type_system_pass::resolve_imports;
    this->subpass = 0;
    for (auto unit : this->code_units) {
        enter_scope(*unit);
        visit_tree(*this, *unit);
        leave_scope();
    }

    this->pass = type_system_pass::resolve_all;
    for (int i = 0; i < 100; i++) {
        this->subpass = i;
        this->unresolved_types = false;
        for (auto unit : this->code_units) {
            clear_type_errors(*this, *unit);
            enter_scope(*unit);
            visit_tree(*this, *unit);
            leave_scope();
        }
        if (this->unresolved_types) {
            printf("unresolved types\n");
        }
        else {
            break;
        }
    }

    this->pass = type_system_pass::perform_checks;
    this->subpass = 0;
    for (auto unit : this->code_units) {
        clear_type_errors(*this, *unit);
        enter_scope(*unit);
        visit_tree(*this, *unit);
        leave_scope();
    }

    for (int i = 0; i < 2; i++) {
        this->pass = type_system_pass::final_analysis;
        this->subpass = i;
        for (auto unit : this->code_units) {
            enter_scope(*unit);
            visit_tree(*this, *unit);
            leave_scope();
        }
    }

    if (!current_error.msg.empty()) {
        errors.push_back(current_error);
    }
}

void type_system::enter_scope(ast_node& node) {
    enter_scope_local(*this, node);
}

void type_system::leave_scope() {
    leave_scope_local(*this);
}

void type_system::create_temp_variable_for_binary_expr(ast_node& node) {
    std::string tempname = "$cbT" + std::to_string(temp_count++);
    auto id_node = make_identifier_node(*ast_arena, {}, { tempname });

    node.local.self = &node;
    node.local.id_node = id_node.get();
    node.local.value_node = node.children[0].get();
    node.local.type_node = nullptr;

    resolve_local_variable_type(*this, node);
    declare_local_symbol(*this, { node.local.id_node->id_parts.front() }, node);
    node.temps.push_back(std::move(id_node));
}

void type_system::create_temp_variable_for_index_expr(ast_node& node) {
    auto [temp, ref] = make_temp_variable_for_index_expr(*this, std::move(node.children[0]));
    node.children[0] = std::move(ref);
    node.pre_children.push_back(std::move(temp));
}

void type_system::create_temp_variable_for_call_arg(ast_node& call, ast_node& arg, int idx) {
    auto [temp, ref] = make_temp_variable_for_call(*this, arg);

    call.call.args[idx] = ref.get();
    call.children[ast_node::child_call_expr_arg_list]->children[idx] = std::move(ref);

    call.pre_children.push_back(std::move(temp));
}

scope_def* type_system::find_nearest_scope(scope_kind kind) {
    return find_nearest_scope_local(*this, kind);
}

type_def& type_id::get() { return *scope->type_defs[type_index]; }

bool type_id::valid() const { return scope != nullptr && type_index != -1; }

}