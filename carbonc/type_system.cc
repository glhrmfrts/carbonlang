#include <cassert>
#include <optional>
#include <algorithm>
#include "type_system.hh"
#include "ast.hh"
#include "ast_manip.hh"
#include "fs.hh"
#include "prettyprint.hh"
#include "desugar.hh"
#include "scope.hh"
#include <fstream>
#include <numeric>
#include <fstream>

namespace carbon {

static const type_id invalid_type{};

type_id get_type_expr_node_type(type_system& ts, ast_node& node);

bool is_castable_to(type_system& ts, type_id a, type_id b);

std::string node_to_string(const ast_node& node);

std::string type_to_string(type_id t);

// Section: errors

template <typename... Args> void add_module_error(type_system& ts, const position& pos, const char* fmt, Args&&... args) {
    if (!ts.current_error.msg.empty()) {
        ts.errors.push_back(ts.current_error);
    }

    static char wholeb[1024];
    static char msgb[1024];
    snprintf(msgb, sizeof(msgb), fmt, std::forward<Args>(args)...);

    string_hash error_hash = string_hash{ std::string{ fmt } };

    const char* filename = pos.filename.c_str();
    snprintf(wholeb, sizeof(wholeb), "carbonc - ERROR - %s\n\n[%s:%d:%d]\t%s\n", filename, filename, pos.line_number, pos.col_offs, msgb);
    ts.current_error = { pos, error_hash, std::string{filename}, std::string{wholeb} };
}

template <typename... Args> void unk_type_error(type_system& ts, type_id tid, const position& pos, const char* fmt, Args&&... args) {
    if (ts.pass == type_system_pass::perform_checks && tid == invalid_type) {
        if (!ts.current_error.msg.empty()) {
            ts.errors.push_back(ts.current_error);
        }

        string_hash error_hash = string_hash{ std::string{ fmt } };

        static char wholeb[1024];
        static char msgb[1024];
        snprintf(msgb, sizeof(msgb), fmt, std::forward<Args>(args)...);

        const char* filename = pos.filename.c_str();
        snprintf(wholeb, sizeof(wholeb), "carbonc - ERROR %zX - %s\n\n[%s:%d:%d] %s\n", error_hash.hash & 0xFFFF, filename, filename, pos.line_number, pos.col_offs, msgb);
        ts.current_error = { pos, error_hash, std::string{filename}, std::string{wholeb} };
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

        const char* filename = pos.filename.c_str();
        snprintf(wholeb, sizeof(wholeb), "[%s:%d:%d] %s\n", filename, pos.line_number, pos.col_offs, msgb);
        ts.current_error.msg.append(wholeb);
    }
}

// Section: helpers

scope_def& curscope(type_system& ts) {
    return *ts.current_scope;
}

type_id register_type(type_system& ts, scope_def& scope, ast_node& node) {
    type_def* t = &node.type_def;
    t->self = &node;
    type_id id = { &scope, (int)(scope.type_defs.size()) };
    t->id = id;
    declare_type_symbol(ts, scope, t->name, node);
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

type_id register_alias_to_type_name(type_system& ts, const std::string& name, const std::string& toname) {
    auto it = curscope(ts).symbols.find(string_hash{ toname });
    if (it == curscope(ts).symbols.end()) {
        return invalid_type;
    }

    auto tid = type_id{ it->second->scope, it->second->type_index };

    auto node = make_in_arena<ast_node>(*ts.ast_arena);
    type_def* defcopy = &node->type_def;

    *defcopy = get_type(ts, tid);
    defcopy->name = name;
    defcopy->mangled_name = string_hash{ name };
    defcopy->alias_to = tid;
    return register_builtin_type(ts, std::move(node));
}

type_id register_pointer_type(type_system& ts, const std::string& name, const std::string& toname) {
    auto it = curscope(ts).symbols.find(string_hash{ toname });
    if (it == curscope(ts).symbols.end()) {
        return invalid_type;
    }

    auto tid = type_id{ it->second->scope, it->second->type_index };
    auto pointertid = get_ptr_type_to(ts, tid);

    return register_alias_to_type_name(ts, name, pointertid.get().name.str);
}

// Section: types

bool compare_types_exact(const type_def& a, const type_def& b) {
    return a.kind == b.kind
        && a.alias_to == b.alias_to
        && a.alignment == b.alignment
        && a.array.length == b.array.length
        && a.elem_type == b.elem_type
        && a.flags == b.flags
        && a.func.arg_types == b.func.arg_types
        && a.func.ret_type == b.func.ret_type
        && a.is_signed == b.is_signed
        && a.mangled_name == b.mangled_name
        && a.name == b.name
        && a.numeric.min == b.numeric.min
        && a.numeric.max == b.numeric.max
        && a.size == b.size
        && a.structure.fields == b.structure.fields;
}

type_id find_type_by_value(type_system& ts, scope_def& scope, const type_def& tdef) {
    for (const auto& t : scope.type_defs) {
        if (compare_types_exact(*t, tdef)) {
            return t->id;
        }
    }
    return invalid_type;
}

type_id execute_type_constructor(type_system& ts, scope_def& scope, type_constructor& tpl, const std::vector<comptime_value>& args) {
    auto result = tpl.func(args);

    auto tid = find_type_by_value(ts, scope, result->type_def);
    if (!tid.valid()) {
        result->type_def.constructor_type = tpl.self->type_def.id;
        tid = register_type(ts, scope, *result);
        scope.body_node->temps.push_back(std::move(result));
    }
    return tid;
}

type_id execute_builtin_type_constructor(type_system& ts, type_constructor& tpl, const std::vector<comptime_value>& args) {
    return execute_type_constructor(ts, ts.builtin_scope->scope, tpl, args);
}

string_hash build_array_name(int_type size, type_id t) {
    std::string result = "[";
    result.append(std::to_string(size));
    result.append("]");
    result.append(t.get().name.str);
    return { result };
}

string_hash build_tuple_name(const std::vector<comptime_value>& args) {
    std::string result = "{";
    int i = 0;
    for (const auto& arg : args) {
        if (auto tt = std::get_if<type_id>(&arg); tt) {
            result.append("");
            result.append(tt->get().name.str);
            if (i < args.size() - 1)
                result.append(", ");
        }
        i++;
    }
    result.append("}");
    return { result };
}

string_hash build_func_pointer_name(const std::vector<type_id>& arg_types, type_id ret_type) {
    std::string result = "{";
    int i = 0;
    for (const auto& arg : arg_types) {
        result.append("");
        result.append(arg.get().name.str);
        if (i < arg_types.size() - 1)
            result.append(", ");
        i++;
    }
    result.append("} -> ");
    result.append(type_to_string(ret_type));
    return { result };
}

string_hash build_type_constructor_name(const std::string& name, const std::vector<comptime_value>& args) {
    auto result = name;
    result.append("(");
    for (const auto& arg : args) {
        if (auto tt = std::get_if<type_id>(&arg); tt) {
            result.append(tt->get().name.str);
            result.append(",");
        }
    }
    result.replace(result.find_last_of(','), 1, ")");
    return { result };
}

string_hash build_type_constructor_mangled_name(const std::string& mangled_name, const std::vector<comptime_value>& args) {
    auto result = mangled_name;
    for (const auto& arg : args) {
        if (auto tt = std::get_if<type_id>(&arg); tt) {
            result.append("__T");
            result.append(tt->get().mangled_name.str);
        }
        else if (auto tt = std::get_if<int_type>(&arg); tt) {
            result.append("__I");
            result.append(std::to_string(*tt));
        }
    }
    return { result };
}

std::pair<comptime_value, bool> node_to_comptime_value(type_system& ts, ast_node& node) {
    comptime_value arg = {};
    switch (node.type) {
    case ast_type::type_expr: {
        resolve_node_type(ts, &node);
        if (node.type_id.valid()) {
            arg = node.type_id;
        }
        break;
    }
    case ast_type::int_literal: {
        arg = node.int_value;
        break;
    }
    case ast_type::string_literal: {
        arg = std::string{ node.string_value };
        break;
    }
    case ast_type::comptime_expr: {
        auto tid = get_type_expr_node_type(ts, *node.children[0]);
        if (tid.valid()) {
            node.type_id = ts.type_type;
            node.type_error = false;
            arg = tid;
        }
        else {
            add_type_error(ts, node.pos, "invalid compile-time expression");
        }
        break;
    }
    default: {
        add_type_error(ts, node.pos, "invalid compile-time expression: '%s'", node_to_string(node).c_str());
        break;
    }
    }
    return std::make_pair(arg, node.type_id.valid());
}

std::pair<comptime_value, bool> node_to_comptime_value_fold(type_system& ts, ast_node& node) {
    comptime_value arg = {};
    switch (node.type) {
    case ast_type::unary_expr: {
        auto [value, ok] = node_to_comptime_value_fold(ts, *node.children[0]);
        if (ok) {
            if (std::holds_alternative<int_type>(value)) {
                switch (node.op) {
                case token_from_char('-'):
                    arg = (int_type)(-std::get<int_type>(value));
                    break;
                case token_from_char('~'):
                    arg = (int_type)(~std::get<int_type>(value));
                    break;
                }
            }
        }
        break;
    }
    case ast_type::binary_expr: {
        auto [avalue, aok] = node_to_comptime_value_fold(ts, *node.children[0]);
        auto [bvalue, bok] = node_to_comptime_value_fold(ts, *node.children[1]);
        if (aok && bok && std::holds_alternative<int_type>(avalue) && std::holds_alternative<int_type>(bvalue)) {
            int_type a = std::get<int_type>(avalue);
            int_type b = std::get<int_type>(bvalue);
            switch (node.op) {
            case token_type::shr:
                arg = a >> b;
                break;
            case token_type::shl:
                arg = a << b;
                break;
            case token_from_char('&'):
                arg = a & b;
                break;
            case token_from_char('|'):
                arg = a | b;
                break;
            case token_from_char('^'):
                arg = a ^ b;
                break;
            case token_from_char('+'):
                arg = a + b;
                break;
            case token_from_char('-'):
                arg = a - b;
                break;
            case token_from_char('*'):
                arg = a * b;
                break;
            case token_from_char('/'):
                arg = a / b;
                break;
            case token_from_char('%'):
                arg = a % b;
                break;
            }
        }
        break;
    }
    default:
        return node_to_comptime_value(ts, node);
    }
    return std::make_pair(arg, true);
}

std::pair<std::vector<comptime_value>, bool> nodes_to_comptime_values(type_system& ts, std::vector<arena_ptr<ast_node>>& nodes) {
    std::vector<comptime_value> args;
    bool all_resolved = true;

    for (auto& node : nodes) {
        auto [arg, resolved] = node_to_comptime_value(ts, *node);
        if (!resolved) {
            all_resolved = false;
        }
        args.push_back(arg);
    }
    return std::make_pair(args, all_resolved);
}

type_id get_ptr_type_to(type_system& ts, type_id elem_type) {
    return execute_type_constructor(ts, ts.builtin_scope->scope, *ts.ptr_type_constructor, { elem_type });
}

type_id get_nullableptr_type_to(type_system& ts, type_id elem_type) {
    return execute_type_constructor(ts, ts.builtin_scope->scope, *ts.nullableptr_type_constructor, { elem_type });
}

type_id get_pure_type_to(type_system& ts, type_id elem_type) {
    return execute_type_constructor(ts, ts.builtin_scope->scope, *ts.pure_type_constructor, { elem_type });
}

type_id get_array_type(type_system& ts, int_type size, type_id elem_type) {
    return execute_type_constructor(ts, ts.builtin_scope->scope, *ts.arr_type_constructor, { size, elem_type });
}

type_id get_slice_type_to(type_system& ts, type_id elem_type) {
    return execute_type_constructor(ts, ts.builtin_scope->scope, *ts.slice_type_constructor, { elem_type });
}

type_id get_func_pointer_type_to(type_system& ts, type_id func_type) {
    std::vector<comptime_value> args;
    for (auto& arg_type : func_type.get().func.arg_types) {
        args.push_back(arg_type);
    }
    args.push_back(func_type.get().func.ret_type);
    return execute_type_constructor(ts, ts.builtin_scope->scope, *ts.func_pointer_type_constructor, args);
}

enum type_query_path_segment
{
    invalid,
    elem_type,
};

struct type_query
{
    type_id result;
    std::vector<type_query_path_segment> path;
    std::vector<type_id> history;
};

void tquery_for_type_kind(type_query& q, type_id root, type_kind k) {
    if (!root.valid()) { return; }

    if (root.get().kind == k) {
        q.result = root;
        return;
    }
    switch (root.get().kind) {
    case type_kind::ptr:
    case type_kind::array:
    case type_kind::slice:
        q.path.push_back(elem_type);
        q.history.push_back(root);
        tquery_for_type_kind(q, root.get().elem_type, k);
        break;
    }
}

void tquery_for_type_id(type_query& q, type_id root, type_id target) {
    if (!root.valid()) { return; }

    if (root == target) {
        q.result = root;
        return;
    }
    switch (root.get().kind) {
    case type_kind::ptr:
    case type_kind::array:
    case type_kind::slice:
        q.path.push_back(elem_type);
        q.history.push_back(root);
        tquery_for_type_id(q, root.get().elem_type, target);
        break;
    }
}

void tquery_for_type_with_constructor(type_query& q, type_id root, type_id ctor) {
    if (!root.valid()) { return; }

    if (root.get().constructor_type == ctor) {
        q.result = root;
        return;
    }
    switch (root.get().kind) {
    case type_kind::ptr:
    case type_kind::array:
    case type_kind::slice:
        q.path.push_back(elem_type);
        q.history.push_back(root);
        tquery_for_type_with_constructor(q, root.get().elem_type, ctor);
        break;
    }
}


bool tquery_path_equal(const type_query& a, const type_query& b) {
    if (a.path.size() != b.path.size()) return false;

    return a.path == b.path;
}

bool tquery_equal(const type_query& a, const type_query& b) {
    if (!(a.result == b.result)) return false;
    if (a.history.size() != b.history.size()) return false;
    if (a.path.size() != b.path.size()) return false;

    return a.history == b.history && a.path == b.path;
}

// is A assignable to B?
bool is_assignable_to(type_system& ts, type_id a, type_id b) {
    if (a == invalid_type || b == invalid_type) return false;

    if (a == b) {
        return true;
    }

    auto& ta = get_type(ts, a);
    auto& tb = get_type(ts, b);

    if (ta.alias_to == b || tb.alias_to == a) {
        return true;
    }

    if (ta.kind == type_kind::nullableptr && tb.kind == type_kind::nullableptr) {
        if (ta.id == ts.raw_ptr_type) {
            return true;
        }

        return is_assignable_to(ts, ta.elem_type, tb.elem_type);
    }

    if (ta.kind == type_kind::ptr && tb.kind == type_kind::ptr) {
        return is_assignable_to(ts, ta.elem_type, tb.elem_type);
    }

    if (ta.kind == type_kind::ptr && tb.kind == type_kind::nullableptr) {
        return is_assignable_to(ts, ta.elem_type, tb.elem_type);
    }

    if (ta.kind == type_kind::slice && tb.kind == type_kind::slice) {
        return is_assignable_to(ts, ta.elem_type, tb.elem_type);
    }

    if (ta.kind == type_kind::func_pointer && tb.kind == type_kind::func_pointer) {
        // TODO
        return true;
    }

    if (tb.kind == ta.kind && (tb.flags & type_flags::is_pure)) {
        return true;
    }

    return false;
}

// is A implicitly convertible to B? and does it need to cast?
std::pair<bool, bool> is_convertible_to(type_system& ts, type_id a, type_id b) {
    if (a == invalid_type || b == invalid_type) return std::make_pair(false, false);
    if (is_assignable_to(ts, a, b)) return std::make_pair(true, false);

    // any implicit conversions involving booleans are prohibited
    if (a == ts.bool_type || b == ts.bool_type) {
        return std::make_pair(false, false);
    }

    auto& ta = get_type(ts, a);
    auto& tb = get_type(ts, b);

    if (ta.kind == tb.kind && tb.kind == type_kind::integral) {
        return std::make_pair(tb.size >= ta.size, true);
    }

    return std::make_pair(false, false);
}

std::tuple<bool, bool, int> is_comparable(type_system& ts, type_id a, type_id b) {
    auto leftres = is_convertible_to(ts, a, b);
    if (!leftres.first) {
        auto rightres = is_convertible_to(ts, b, a);
        return std::make_tuple(rightres.first, rightres.second, 1);
    }
    return std::make_tuple(leftres.first, leftres.second, 0);
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
        else {
            if (from.type == ast_type::int_literal) {
                from.type_id = to;
            }
        }
    }
}

std::vector<struct_field>& get_type_fields(type_id id) {
    if (id.get().flags & (type_flags::is_auto | type_flags::is_pure)) {
        return get_type_fields(id.get().elem_type);
    }
    return id.get().structure.fields;
}

arena_ptr<ast_node> get_zero_value_node_for_type(type_system& ts, type_id id) {
    if (id.get().kind == type_kind::integral) {
        return make_int_literal_node(*ts.ast_arena, {}, 0);
    }
    else if (id.get().kind == type_kind::real) {
        return make_float_literal_node(*ts.ast_arena, {}, 0.0);
    }
    else if (id.get().kind == type_kind::nullableptr)  {
        return make_nullpointer_node(*ts.ast_arena, {});
    }
    return { nullptr, nullptr };
}

arena_ptr<ast_node> generate_init_list_zero_values(type_system& ts, type_id id) {
    std::vector<arena_ptr<ast_node>> list;
    for (const auto& field : get_type_fields(id)) {
        list.push_back(get_zero_value_node_for_type(ts, field.type));
    }
    auto result = make_init_expr_node(*ts.ast_arena, {}, {nullptr, nullptr}, make_arg_list_node(*ts.ast_arena, {}, std::move(list)));
    result->type_id = id;
    return result;
}

bool is_pointer(type_id id) {
    if (!id.valid()) return false;

    return id.get().kind == type_kind::ptr;
}

bool is_aggregate(type_id id) {
    if (!id.valid()) return false;

    return id.get().kind == type_kind::structure ||
           id.get().kind == type_kind::tuple ||
           id.get().kind == type_kind::array ||
           id.get().kind == type_kind::slice;
}

bool is_aggregate_root(type_id id) {
    if (!id.valid()) return false;
    if (id.get().flags) return false;

    return id.get().kind == type_kind::structure ||
        id.get().kind == type_kind::tuple ||
        id.get().kind == type_kind::array ||
        id.get().kind == type_kind::slice;
}

bool is_type_kind(type_id id, type_kind k) {
    return id.get().kind == k;
}

bool type_allows_no_init(type_system& ts, type_id id) {
    if (id.get().kind == type_kind::ptr) {
        return false;
    }
    if (id.get().kind == type_kind::func_pointer) {
        return false;
    }
    return true;
}

bool check_type_allows_no_init(type_system& ts, const position& pos, type_id id) {
    bool result = true;
    if (!is_aggregate(id)) {
        if (!type_allows_no_init(ts, id)) {
            result = false;
            add_type_error(ts, pos, "type '%s' does not allow declarations without initialization",
                type_to_string(id).c_str());
        }
    }
    else {
        int i = 0;
        for (const auto& field : get_type_fields(id)) {
            if (!type_allows_no_init(ts, field.type)) {
                result = false;
                add_type_error(ts, pos, "type '%s' does not allow declarations without initialization",
                    type_to_string(id).c_str());

                if (is_type_kind(id, type_kind::structure) || is_type_kind(id, type_kind::slice)) {
                    complement_error(ts, pos, "struct member '%s' of type '%s' does not allow declarations without initialization",
                        field.names[0].c_str(),
                        type_to_string(field.type).c_str());
                }
                else {
                    complement_error(ts, pos, "#%d tuple member of type '%s' does not allow declarations without initialization",
                        i+1, type_to_string(field.type).c_str());
                }
            }
            i++;
        }
    }
    return result;
}

// Section: structs / aggregates

void compute_struct_size_alignment_offsets(type_def& td) {
    std::size_t max_align = 1;
    std::size_t offs = 0;

    for (auto& f : td.structure.fields) {
        auto& ftype = f.type.get();
        f.offset = offs;
        offs += ftype.size;
        offs = align(offs, ftype.alignment);
        max_align = std::max(ftype.alignment, max_align);
    }

    td.size = align(offs, max_align);
    td.alignment = max_align;
}

int aggregate_find_field(type_id tid, const std::string& name) {
    if (!is_aggregate(tid)) return -1;

    auto& fields = get_type_fields(tid);
    for (std::size_t i = 0; i < fields.size(); i++) {
        for (const auto& fname : fields[i].names) {
            if (fname == name) {
                return (int)i;
            }
        }
    }
    return -1;
}

bool check_aggregate_types_match(type_system& ts, const position& pos, type_id src_type, type_id receiver_type) {
    auto& a = src_type;
    auto& b = receiver_type;
    if (a == b) { return true; }

    if (a.get().kind == type_kind::structure && b.get().kind == type_kind::structure) {
        add_type_error(ts, pos, "types '%s' and '%s' do not match", type_to_string(a).c_str(), type_to_string(b).c_str());
        return false;
    }

    auto& ffa = a.get().structure.fields;
    auto& ffb = b.get().structure.fields;
    if (ffa.size() != ffb.size()) {
        add_type_error(ts, pos, "types '%s' and '%s' do not match", type_to_string(a).c_str(), type_to_string(b).c_str());
        return false;
    }

    bool msg_already = false;
    for (std::size_t i = 0; i < ffa.size(); i++) {
        auto& fa = ffa[i];
        auto& fb = ffb[i];
        if (fa.type != fb.type) {
            if (!is_convertible_to(ts, fa.type, fb.type).first) {
                if (!msg_already) {
                    add_type_error(ts, pos, "types '%s' and '%s' do not match", type_to_string(a).c_str(), type_to_string(b).c_str());
                    msg_already = true;
                }

                if (is_type_kind(a, type_kind::structure) || is_type_kind(a, type_kind::slice)) {
                    complement_error(ts, pos, "struct member '%s: %s' is not convertible to the type of receiver struct member '%s: %s'",
                        fa.names[0].c_str(),
                        type_to_string(fa.type).c_str(),
                        fb.names[0].c_str(),
                        type_to_string(fb.type).c_str());
                }
                else {
                    complement_error(ts, pos, "tuple member #%d of type '%s' is not convertible to the type of receiver tuple member of type '%s'",
                        i + 1,
                        type_to_string(fa.type).c_str(),
                        type_to_string(fb.type).c_str());
                }
            }
        }
    }

    return !msg_already;
}

arena_ptr<ast_node> make_assignment_for_init_list_item(type_system& ts, ast_node& node, ast_node& receiver, arena_ptr<ast_node>&& value, const struct_field& field, int idx) {
    if (is_type_kind(node.type_id, type_kind::structure) || is_type_kind(node.type_id, type_kind::slice)) {
        auto fieldexpr = make_struct_field_access(*ts.ast_arena, copy_node(ts, &receiver), field.names[0]);
        return make_assignment(*ts.ast_arena, std::move(fieldexpr), std::move(value));
    }
    else if (is_type_kind(node.type_id, type_kind::tuple) || is_type_kind(node.type_id, type_kind::array)) {
        auto indexexpr = make_index_access(*ts.ast_arena, copy_node(ts, &receiver), idx);
        return make_assignment(*ts.ast_arena, std::move(indexexpr), std::move(value));
    }
}

void generate_assignments_for_init_list(type_system& ts, ast_node& node, ast_node& receiver) {
    auto& args = node.children[1]->children;
    auto& fields = get_type_fields(node.type_id);

    if (args.size() > fields.size()) {
        // TODO: handle different number of arguments vs fields
        node.type_error = true;
        add_type_error(ts, node.pos, "number of initialization arguments is greater than number of fields in type '%s'",
            type_to_string(node.type_id).c_str());
        return;
    }
    
    node.initlist.receiver = &receiver;

    int i = 0;
    for (auto& arg : args) {
        // TODO: handle designated initializers
        if (arg->type == ast_type::var_decl) continue;

        auto assignment = make_assignment_for_init_list_item(ts, node, receiver, std::move(arg), fields[i], i);
        resolve_node_type(ts, assignment.get());
        node.initlist.assignments.push_back(std::move(assignment));
        i++;
    }

    // generate zero-value initializers for remaining fields
    for (int j = i; j < fields.size(); j++) {
        auto& field = fields[j];
        auto zerovalue = get_zero_value_node_for_type(ts, field.type);
        if (!zerovalue) {
            add_type_error(ts, node.pos, "missing initializer value for field '%s' member of type '%s'",
                field.names.front().c_str(), type_to_string(node.type_id).c_str());
            complement_error(ts, node.pos, "field type '%s' requires explicit initialization",
                type_to_string(field.type).c_str());
            node.type_error = true;
            return;
        }

        auto assignment = make_assignment_for_init_list_item(ts, node, receiver, std::move(zerovalue), fields[j], j);
        resolve_node_type(ts, assignment.get());
        node.initlist.assignments.push_back(std::move(assignment));
    }

    node.children[1]->children.clear();
}

void check_init_list_assignment(type_system& ts, ast_node& node, ast_node& receiver) {
    if (node.type == ast_type::init_expr) {
        if (is_aggregate(node.type_id)) {
            generate_assignments_for_init_list(ts, node, receiver);
        }
    }
}

void deduce_init_list_type(type_system& ts, ast_node& node, type_id receiver_type) {
    if (node.type == ast_type::init_expr) {
        node.type_id = receiver_type;
    }
}

void transform_slice_expr_to_init_expr(type_system& ts, ast_node& node, bool mut) {
    node.type = ast_type::init_expr;
    
    type_id elem_type = node.children[0]->type_id.get().elem_type;
    auto arr = std::move(node.children[0]);
    auto idxpair = std::move(node.children[1]);
    auto offscopy = copy_node(ts, idxpair->children[1]->children[0].get());

    auto addrexpr = make_address_of_expr(ts,
        make_index_expr_node(*ts.ast_arena, arr->pos, std::move(arr), std::move(idxpair->children[1]->children[0]))
    );
    auto szexpr = make_binary_expr_node(*ts.ast_arena, idxpair->pos, token_from_char('-'),
        std::move(idxpair->children[1]->children[1]), std::move(offscopy)
    );
    resolve_node_type(ts, addrexpr.get());
    resolve_node_type(ts, szexpr.get());

    std::vector<arena_ptr<ast_node>> args;
    args.push_back(std::move(addrexpr));
    args.push_back(std::move(szexpr));
    auto arglist = make_arg_list_node(*ts.ast_arena, node.pos, std::move(args));
    node.children[1] = std::move(arglist);

    node.type_id = get_slice_type_to(ts, elem_type);
    node.children[0] = make_type_resolver_node(*ts.ast_arena, node.type_id);
    node.slice.self = &node;
}

// Section: cast checking

using cast_check_func = std::function<bool(type_system&, type_def&, type_def&)>;

bool can_pointer_be_cast_from(type_system& ts, type_def& self, type_def& from) {
    if (self.id == ts.raw_ptr_type) {
        if (from.kind == type_kind::ptr || from.kind == type_kind::nullableptr) {
            return true;
        }
        if (from.kind == type_kind::integral) {
            return from.id == ts.uintptr_type;
        }
    }

    if (from.kind == type_kind::ptr) {
        return is_castable_to(ts, from.elem_type, self.elem_type);
    }
    return false;
}

bool can_nullableptr_be_cast_from(type_system& ts, type_def& self, type_def& from) {
    if (self.id == ts.raw_ptr_type) {
        if (from.kind == type_kind::ptr || from.kind == type_kind::nullableptr) {
            return true;
        }
        if (from.kind == type_kind::integral) {
            return from.id == ts.uintptr_type;
        }
    }
    else if (from.id == ts.raw_ptr_type) {
        return true;
    }

    if (from.kind == type_kind::ptr) {
        return is_castable_to(ts, from.elem_type, self.elem_type);
    }
    return false;
}

bool can_integral_be_cast_from(type_system& ts, type_def& self, type_def& from) {
    if (self.id == ts.uintptr_type) {
        if (from.kind == type_kind::ptr) {
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
    {type_kind::ptr, can_pointer_be_cast_from},
    {type_kind::nullableptr, can_nullableptr_be_cast_from},
    {type_kind::integral, can_integral_be_cast_from},
};

// is A explicitly castable to B?
bool is_castable_to(type_system& ts, type_id a, type_id b) {
    if (a == invalid_type || b == invalid_type) return false;
    if (is_convertible_to(ts, a, b).first) return true;

    auto& ta = get_type(ts, a);
    auto& tb = get_type(ts, b);

    auto it = cast_check_funcs.find(tb.kind);
    if (it != cast_check_funcs.end()) {
        return it->second(ts, tb, ta);
    }
    return false;
}

// Section: string converters

std::string comptime_value_to_string(const comptime_value& v) {
    if (std::holds_alternative<type_id>(v)) {
        return type_to_string(std::get<type_id>(v));
    }
    assert(!"comptime_value_to_string not handled");
    return "";
}

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
        if (node.type_qual == type_qualifier::ptr) {
            result += "&";
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
        std::string result = node_to_string(*node.var_id());
        if (node.var_type()) {
            result += ": " + node_to_string(*node.var_type());
        }
        if (node.var_value()) {
            result += "= " + node_to_string(*node.var_value());
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
    result += func->self->func_id()->id_parts.front() + "(";
    result += type_list_to_string(func->self->type_def.func.arg_types);
    result += "): " + type_to_string(func->self->type_def.func.ret_type);
    return result;
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
        if (node.type_id.valid()) {
            return node.type_id;
        }

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
    case ast_type::nullptr_: {
        auto& sym = ts.builtin_scope->scope.symbols[string_hash{ "rawptr" }];
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
        else {
            node.type_error = false;
        }
        return to_type;
    }
    case ast_type::binary_expr: {
        if (node.children[0]->type_id == invalid_type || node.children[1]->type_id == invalid_type ||
            node.children[0]->type_error || node.children[1]->type_error) {
            return invalid_type;
        }

        if (is_cmp_binary_op(node.op)) {
            bool needcast = false;
            auto [comp, ncast, castidx] = is_comparable(ts, node.children[0]->type_id, node.children[1]->type_id);
            if (!comp) {
                try_coerce_to(ts, *node.children[1], node.children[0]->type_id);
                try_coerce_to(ts, *node.children[0], node.children[1]->type_id);

                auto [comp, ncast, castidx] = is_comparable(ts, node.children[0]->type_id, node.children[1]->type_id);
                if (!comp) {
                    node.type_error = true;
                    add_type_error(ts, node.pos, "cannot compare types '%s' and '%s'", 
                        type_to_string(node.children[0]->type_id).c_str(), type_to_string(node.children[1]->type_id).c_str()
                    );
                    return invalid_type;
                }
                else if (ncast) {
                    needcast = true;
                }
            }
            else if (ncast) {
                needcast = true;
            }

            if (needcast) {
                if (castidx == 0) {
                    node.children[0] = make_cast_to(ts, std::move(node.children[0]), node.children[1]->type_id);
                }
                else {
                    node.children[1] = make_cast_to(ts, std::move(node.children[1]), node.children[0]->type_id);
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
    case ast_type::identifier: {
        node.type_error = true;

        if (build_identifier_value(node.id_parts) == "T") {
            //printf("T\n");
        }

        auto sym = find_symbol(ts, separate_module_identifier(node.id_parts));
        if (sym) {
            if (sym->kind == symbol_kind::type) {
                node.type_id = type_id{ sym->scope, sym->type_index };
                node.type_error = false;
            }
            else if (sym->kind == symbol_kind::comptime) {
                auto& value = sym->ctvalue;
                if (std::holds_alternative<type_id>(value)) {
                    node.type_id = std::get<type_id>(value);
                    node.type_error = false;
                }
            }
        }
        break;
    }
    case ast_type::type_qualifier: {
        if (node.type_qual == type_qualifier::ptr) {
            auto elem_type = get_type_expr_node_type(ts, *node.children[0]);
            if (elem_type.valid()) {
                node.type_id = get_ptr_type_to(ts, elem_type);
            }
        }
        else if (node.type_qual == type_qualifier::nullableptr) {
            auto elem_type = get_type_expr_node_type(ts, *node.children[0]);
            if (elem_type.valid()) {
                node.type_id = get_nullableptr_type_to(ts, elem_type);
            }
        }
        else if (node.type_qual == type_qualifier::pure) {
            auto elem_type = get_type_expr_node_type(ts, *node.children[0]);
            if (elem_type.valid()) {
                node.type_id = get_pure_type_to(ts, elem_type);
            }
        }
        break;
    }
    case ast_type::array_type: {
        visit_children(ts, node);
        auto [args, all_resolved] = nodes_to_comptime_values(ts, node.children);
        if (all_resolved) {
            node.type_id = execute_type_constructor(ts, ts.builtin_scope->scope, *ts.arr_type_constructor, args);
            node.type_error = false;
        }
        else {
            node.type_error = true;
        }
        break;
    }
    case ast_type::slice_type: {
        visit_children(ts, node);
        auto [args, all_resolved] = nodes_to_comptime_values(ts, node.children);
        if (all_resolved) {
            auto typecons = ts.slice_type_constructor;
            node.type_id = execute_type_constructor(ts, ts.builtin_scope->scope, *typecons, args);
            node.type_error = false;
        }
        else {
            node.type_error = true;
        }
        break;
    }
    case ast_type::tuple_type: {
        visit_children(ts, node);

        if (node.children[0]) {
            auto [args, all_resolved] = nodes_to_comptime_values(ts, node.children[0]->children);
            if (all_resolved) {
                node.type_id = execute_type_constructor(ts, ts.builtin_scope->scope, *ts.tuple_type_constructor, args);
            }
            else {
                node.type_error = true;
            }
        }
        else {
            node.type_id = ts.void_type;
        }
        break;
    }
    case ast_type::struct_type: {
        if (node.children[0]) {
            bool all_resolved = true;
            std::vector<struct_field> sfields;

            for (auto& field : node.children[0]->children) {
                assert(field->type == ast_type::var_decl);
                auto name = build_identifier_value(field->var_id()->id_parts);

                if (field->var_type()) {
                    resolve_node_type(ts, field->var_type());
                    field->type_id = field->var_type()->type_id;
                    sfields.push_back({ { name }, field->type_id, 0 });
                }

                if (!field->type_id.valid()) {
                    all_resolved = false;
                }
            }

            if (all_resolved && !node.type_id.valid()) {
                auto& td = node.type_def;
                td.kind = type_kind::structure;
                td.structure.fields = sfields;
                compute_struct_size_alignment_offsets(td);

                // if name is not empty it means this is the result of a type constructor
                if (td.name.str.empty()) {
                    td.name = string_hash{ "anonymous struct" };
                    td.mangled_name = string_hash{ "anonymous$struct" };
                    auto fd = find_type_by_value(ts, ts.builtin_scope->scope, td);
                    if (fd.valid()) {
                        node.type_id = fd;
                    }
                    else {
                        node.type_id = register_type(ts, ts.builtin_scope->scope, node);
                    }
                }
                node.type_error = false;
            }
            else {
                node.type_error = true;
            }
        }
        else {
            node.type_id = ts.void_type;
        }
        break;
    }
    case ast_type::func_pointer_type: {
        visit_children(ts, node);

        auto [args, all_resolved] = nodes_to_comptime_values(ts, node.func_type_args());
        auto [retarg, resolved] = node_to_comptime_value(ts, *node.func_type_ret());
        if (all_resolved && resolved) {
            args.push_back(retarg);
            node.type_id = execute_type_constructor(ts, ts.builtin_scope->scope, *ts.func_pointer_type_constructor, args);
            node.type_error = false;
        }
        else {
            node.type_error = true;
        }
        break;
    }
    case ast_type::type_constructor_instance: {
        visit_children(ts, node);

        // type_expr/identifier
        auto id = node.children[0]->children[0].get();
        auto ctor = find_type_by_id_hash(ts, separate_module_identifier(id->id_parts));
        if (!ctor.valid()) {
            node.type_error = true;
            add_type_error(ts, node.pos, "type constructor '%s' not found", build_identifier_value(id->id_parts).c_str());
        }
        else if (ctor.get().kind != type_kind::constructor) {
            node.type_error = true;
            add_type_error(ts, node.pos, "type '%s' is not a constructor", build_identifier_value(id->id_parts).c_str());
        }
        else {
            auto [args, all_resolved] = nodes_to_comptime_values(ts, node.children[1]->children);
            if (all_resolved) {
                node.type_id = execute_type_constructor(ts, *ctor.scope, ctor.get().constructor, args);
            }
            else {
                node.type_error = true;
                complement_error(ts, node.pos, "while instantiating type constructor '%s'", build_identifier_value(id->id_parts).c_str());
            }
        }
        break;
    }
    case ast_type::type_resolver: {
        return node.type_id;
    }
    }

    return node.type_id;
}

type_id resolve_identifier(type_system& ts, ast_node& node) {
    auto sym = find_symbol(ts, separate_module_identifier(node.id_parts));
    if (sym && (sym->kind == symbol_kind::local || sym->kind == symbol_kind::global)) {
        auto local = get_symbol_local(*sym);
        bool was_unresolved = !node.type_id.valid();

        node.lvalue.self = &node;
        node.lvalue.symbol = sym;
        node.type_id = local->self->type_id;

        if (was_unresolved && node.type_id.valid()) { 
            for (auto ref : local->refs) {
                if (ref == &node) {
                    assert(!"about to insert duplicate ref");
                }
            }
            local->refs.push_back(&node);
        }

        if (!node.type_id.valid()) {
            unk_type_error(ts, node.type_id, node.pos, "cannot determine type of symbol '%s'", node_to_string(node).c_str());
        }
    }
    else if (sym && sym->kind == symbol_kind::overloaded_func_base) {
        node.lvalue.self = &node;
        node.lvalue.symbol = sym;
    }
    else if (sym && sym->kind == symbol_kind::comptime) {
        node.lvalue.self = &node;
        node.lvalue.symbol = sym;
        node.type_id = sym->cttype;
    }

    if (!sym) {
        unk_type_error(ts, node.type_id, node.pos, "unknown symbol '%s'", node_to_string(node).c_str());
    }

    return node.type_id;
}

void propagate_return_type(type_system& ts, const type_id& id) {
    //auto scope_id = find_nearest_scope(ts, scope_kind::func_body);
    //ts.scopes[scope_id].announced_return_types.push_back(id);
}

type_id resolve_local_variable_type(type_system& ts, ast_node& l) {
    auto decl_type = l.var_type() ? resolve_node_type(ts, l.var_type()) : type_id{};
    auto val_type = l.var_value() ? resolve_node_type(ts, l.var_value()) : type_id{};

    if (l.var_type() && decl_type.valid()) {
        l.type_id = decl_type;
        l.type_error = l.var_type()->type_error;

        if (l.var_value() && !(l.var_value()->type_id.valid()) && l.var_value()->type == ast_type::init_expr) {
            deduce_init_list_type(ts, *l.var_value(), decl_type);
        }
    }
    else if (!l.var_type()) {
        l.type_id = val_type;
        l.type_error = l.var_value()->type_error;
    }

    return l.type_id;
}

void update_local_variable_type(type_system& ts, ast_node& l, type_id tid) {
    l.type_id = tid;
    for (auto ref : l.local.refs) {
        ref->type_id = tid;
    }
}

void update_local_aggregate_argument(type_system& ts, ast_node& l) {
    update_local_variable_type(ts, l, get_ptr_type_to(ts, l.type_id));
    if (l.type == ast_type::var_decl) {
        l.children[ast_node::child_var_decl_type] = make_type_resolver_node(*ts.ast_arena, l.type_id);
    }
    for (auto ref : l.local.refs) {
        auto parent = ref->parent;
        auto idx = find_child_index(parent, ref);
        if (idx) {
            auto newchild = make_deref_expr(ts, std::move(parent->children[*idx]));
            resolve_node_type_post(ts, newchild.get());
            parent->children[*idx] = std::move(newchild);
        }
    }
}

enum cast_type
{
    invalid_cast,
    simple_cast,
    toptr_cast,
    unsafe_cast,
};

struct call_match_info
{
    std::vector<std::tuple<cast_type, type_id, int>> cast_needed_idxs;
};

bool in_desugar = false;

bool check_convertible_and_cast_call_args(type_system& ts, ast_node& node, type_id target, int idx, call_match_info& info) {
    if (in_desugar) { return true; }

    bool needcast = false;
    auto [convertible, ncast] = is_convertible_to(ts, node.type_id, target);
    if (!convertible) {
        try_coerce_to(ts, node, target);

        auto [convertible, ncast] = is_convertible_to(ts, node.type_id, target);
        if (!convertible) {
            if (target.get().kind == type_kind::ptr || target.get().kind == type_kind::nullableptr) {
                if (target.get().elem_type == node.type_id) {
                    info.cast_needed_idxs.push_back(std::make_tuple(toptr_cast, target, idx));
                    return true;
                }
                else if ((target.get().elem_type.get().flags & type_flags::is_pure) && (target.get().elem_type.get().elem_type == node.type_id)) {
                    info.cast_needed_idxs.push_back(std::make_tuple(toptr_cast, target, idx));
                    return true;
                }
            }
            return false;
        }
        else if (ncast) {
            info.cast_needed_idxs.push_back(std::make_tuple(simple_cast, target, idx));
        }
    }
    else if (ncast) {
        info.cast_needed_idxs.push_back(std::make_tuple(simple_cast, target, idx));
    }
    return true;
}

bool check_convertible_and_cast_call_args_constructor(type_system& ts, ast_node& node, type_id target, int idx, call_match_info& info) {
    bool needcast = false;
    auto [convertible, ncast] = is_convertible_to(ts, node.type_id, target);
    if (!convertible) {
        try_coerce_to(ts, node, target);

        auto [convertible, ncast] = is_convertible_to(ts, node.type_id, target);
        if (!convertible) {
            if (target.get().kind == type_kind::ptr && target.get().elem_type == node.type_id.get().constructor_type) {
                info.cast_needed_idxs.push_back(std::make_tuple(toptr_cast, get_ptr_type_to(ts, node.type_id), idx));
                return true;
            }

            return false;
        }
        else if (ncast) {
            info.cast_needed_idxs.push_back(std::make_tuple(simple_cast, target, idx));
        }
    }
    else if (ncast) {
        info.cast_needed_idxs.push_back(std::make_tuple(simple_cast, target, idx));
    }
    return true;
}

void perform_casts(type_system& ts, std::vector<arena_ptr<ast_node>>& call_args, const call_match_info& info) {
    for (const auto& c : info.cast_needed_idxs) {
        switch (std::get<0>(c)) {
        case simple_cast:
            call_args[std::get<2>(c)] = make_cast_to(ts, std::move(call_args[std::get<2>(c)]), std::get<1>(c));
            break;
        case toptr_cast:
            call_args[std::get<2>(c)] = make_address_of_expr(ts, std::move(call_args[std::get<2>(c)]));
            call_args[std::get<2>(c)]->type_id = get_ptr_type_to(ts, call_args[std::get<2>(c)]->children[0]->type_id);
            break;
        }
    }
}

bool match_arg_list(type_system& ts, std::vector<arena_ptr<ast_node>>& func_args, std::vector<arena_ptr<ast_node>>& call_args,
    const std::vector<comptime_value>& func_comptime_args, const std::vector<comptime_value>& call_comptime_args) {

    if (func_args.size() != call_args.size()) return false;
    if (func_comptime_args.size() != call_comptime_args.size()) return false;

    for (std::size_t i = 0; i < func_comptime_args.size(); i++) {
        auto& farg = func_comptime_args[i];
        auto& carg = call_comptime_args[i];
        if (!(farg == carg)) {
            return false;
        }
    }

    call_match_info info{};
    for (std::size_t i = 0; i < func_args.size(); i++) {
        auto& farg = func_args[i];
        auto& carg = call_args[i];

        if (!check_convertible_and_cast_call_args(ts, *carg, farg->type_id, i, info)) {
            return false;
        }
    }

    perform_casts(ts, call_args, info);

    return true;
}

string_hash mangle_global_name(type_system& ts, const std::vector<std::string>& mod_parts, const string_hash& name) {
    std::string result;
    for (const auto& part : mod_parts) {
        result.append(part);
        result.append("__");
    }
    result.append(name.str);
    return string_hash{ result };
}

string_hash mangle_func_name(type_system& ts, const std::vector<std::string>& id_parts, const std::vector<comptime_value>& comptime_args,
    const std::vector<arena_ptr<ast_node>>& args, func_linkage linkage) {
    //assert(f.type_id != invalid_type);

    if (linkage == func_linkage::local_carbon || linkage == func_linkage::external_carbon) {
        std::string name = "cb";
        for (const auto& part : id_parts) {
            name.append("__N");
            name.append(part);
        }
        for (auto& arg : comptime_args) {
            name.append("__C");
            name.append(comptime_value_to_string(arg));
        }
        for (auto& arg : args) {
            assert(arg->type_id != invalid_type);
            auto tdef = arg->type_id.get();
            name.append("__A");
            name.append(tdef.mangled_name.str);
        }
        return string_hash{ name };
    }
    else {
        return string_hash{ id_parts.back() };
    }
}

void resolve_func_args_type(type_system& ts, ast_node& node) {
    auto funcname = node_to_string(*node.func_id());

    node.func.args_unresolved = false;
    node.type_def.func.arg_types.clear();
    for (auto& arg : node.func_args()) {
        resolve_local_variable_type(ts, *arg);
        if (arg->type_id == invalid_type || arg->type_error) {
            node.func.args_unresolved = true;

            auto name = node_to_string(*arg->var_id());
            complement_error(ts, arg->pos, "in declaration of #%d argument '%s' of function '%s'", arg->local.arg_index + 1, name.c_str(), funcname.c_str());
        }
        node.type_def.func.arg_types.push_back(arg->type_id);
    }
}

// TODO: deduce type from return statements

type_id deduce_func_return_type(type_system& ts, ast_node& f) {
    if (f.func.return_statements.empty()) {
        return ts.void_type;
    }

    auto funcname = node_to_string(*f.func_id());

    type_id ret_type = invalid_type;
    for (auto& ret : f.func.return_statements) {
        if (ret->type_id.valid()) {
            if (ret_type.valid()) {
                if (is_assignable_to(ts, ret_type, ret->type_id)) {
                    ret_type = ret->type_id;
                }
                else {
                    // TODO: assume union type
                    add_type_error(ts, ret->pos, "incompatible return types for function '%s'", funcname.c_str());
                    complement_error(ts, ret->pos, "previous return statements had type '%s', but this one has type '%s'",
                        type_to_string(ret_type).c_str(), type_to_string(ret->type_id).c_str());
                    return invalid_type;
                }
            }
            else {
                ret_type = ret->type_id;
            }
        }
    }
    return ret_type;
}

type_id resolve_func_type(type_system& ts, ast_node& f) {
    assert(f.func.self || !"func not declared yet");

    auto funcname = node_to_string(*f.func_id());

    f.type_def.kind = type_kind::func;
    f.type_def.size = sizeof(void*);
    f.type_def.alignment = sizeof(void*);
    f.type_def.is_signed = false;

    type_id ret_type = invalid_type;
    if (f.func_ret_type()) {
        ret_type = resolve_node_type(ts, f.func_ret_type());
        if (!ret_type.valid()) {
            f.type_error = true;
            complement_error(ts, f.pos, "in return type of function '%s'", funcname.c_str());
        }

        if (ret_type.valid()) {
            if (f.func.return_statements.empty() && ret_type != ts.void_type && f.func.linkage == func_linkage::local_carbon) {
                add_type_error(ts, f.func_ret_type()->pos,
                    "function '%s' has return type '%s' but no return statements",
                    funcname.c_str(),
                    type_to_string(ret_type).c_str());
            }
            for (auto retst : f.func.return_statements) {
                // TODO: check for needed casts
                if (!is_convertible_to(ts, retst->type_id, ret_type).first) {
                    add_type_error(ts, retst->pos,
                        "cannot return type '%s' from function '%s' declared returning type '%s'",
                        type_to_string(retst->type_id).c_str(),
                        funcname.c_str(),
                        type_to_string(ret_type).c_str());
                    break;
                }

                // TODO: better coercion
                retst->type_id = ret_type;
            }
        }
    }
    else {
        ret_type = deduce_func_return_type(ts, f);
    }
    
    if (!f.type_id.valid() && !f.func.args_unresolved && ret_type.valid()) {
        f.type_def.func.ret_type = ret_type;
        f.type_def.name = string_hash{ func_declaration_to_string(&f.func) };
        f.type_id = register_user_type(ts, f);
    }

    assert(ts.current_scope->kind == scope_kind::code_unit);
    if (f.type_id != invalid_type && f.type_def.mangled_name.str.empty() && ts.current_scope->kind == scope_kind::code_unit) {
        // this means the function type was resolved, so mangle the name and declare it
        f.type_def.mangled_name = mangle_func_name(ts, f.func_id()->id_parts, f.func.comptime_args, f.func_args(), f.func.linkage);

        auto bsym = find_symbol_in_current_scope(ts, f.func.base_symbol);
        for (auto& of : bsym->overload_funcs) {
            if (of->self->type_def.mangled_name == f.type_def.mangled_name) {
                f.type_error = true;
                add_type_error(ts, f.pos, "cannot redeclare the same argument list for the same function");
                complement_error(ts, f.pos, "in declaration of function '%s'", funcname.c_str());
            }
        }

        bsym->overload_funcs.push_back(&f.func);
        declare_top_level_func_symbol(ts, f.type_def.mangled_name, f);
    }
    return f.type_id;
}

// Section: declarations

void clear_func_resolved_state(ast_node& func) {
    func.type_id = invalid_type;
    func.type_def.mangled_name = string_hash{ "" };
}

void fill_local_argument_info(ast_node& func, ast_node& arg, int idx) {
    arg.local.self = &arg;
    arg.local.flags |= local_flag::is_argument;
    arg.local.arg_index = idx;
    arg.local.arg_func_node = &func;
}

void declare_func_arguments(type_system& ts, ast_node& func) {
    auto& arg_list = func.func_args();
    auto body = func.func_body();

    int idx = 0;
    for (auto& arg : arg_list) {
        assert(arg->type == ast_type::var_decl);

        fill_local_argument_info(func, *arg, idx);
        if (body) {
            declare_local_symbol(ts, { arg->var_id()->id_parts.front() }, *arg);
        }
        idx++;
    }
}

bool is_func_generic(type_system& ts, ast_node& func) {
    auto& arg_list = func.func_args();
    for (auto& arg : arg_list) {
        if (arg->type == ast_type::comptime_expr) {
            return true;
        }

        assert(arg->type == ast_type::var_decl);

        if (!arg->var_type()) {
            return true;
        }
        
        auto tid = resolve_node_type(ts, arg->var_type());

        type_query cq{};
        tquery_for_type_kind(cq, tid, type_kind::constructor);

        if (cq.result.valid() && cq.result.get().kind == type_kind::constructor) {
            return true;
        }
    }
    return false;
}

void register_func_declaration_node(type_system& ts, ast_node& node) {
    auto& id = node.children[ast_node::child_func_decl_id];
    auto& arg_list = node.children[ast_node::child_func_decl_arg_list]->children;
    auto body = node.children[ast_node::child_func_decl_body].get();

    node.func.decl_scope = ts.current_scope;
    node.func.base_symbol = build_identifier_value(node.func_id()->id_parts);
    auto ovbase = find_symbol_in_current_scope(ts, node.func.base_symbol);
    if (!ovbase) {
        declare_overloaded_func_base_symbol(ts, node.func.base_symbol);
        ovbase = find_symbol_in_current_scope(ts, node.func.base_symbol);
    }

    if (node.func_ret_type()) {
        resolve_node_type(ts, node.func_ret_type());
    }

    if (body) {
        if (body->type != ast_type::compound_stmt) {
            auto new_return = make_return_stmt_node(*ts.ast_arena, body->pos, std::move(node.children[ast_node::child_func_decl_body]));

            auto stmts = std::vector<arena_ptr<ast_node>>{};
            stmts.push_back(std::move(new_return));
            auto new_slist = make_stmt_list_node(*ts.ast_arena, body->pos, std::move(stmts));

            auto new_lists = std::vector<arena_ptr<ast_node>>{};
            new_lists.push_back(std::move(new_slist));
            auto new_body = make_compound_stmt_node(*ts.ast_arena, body->pos, std::move(new_lists));

            node.children[ast_node::child_func_decl_body] = std::move(new_body);
            body = node.children[ast_node::child_func_decl_body].get();
            parent_tree(*body);
        }
    }

    node.func.is_generic = is_func_generic(ts, node);
    if (!node.func.is_generic) {
        node.scope.self = &node;
        node.func.self = &node;
        node.local.self = &node;

        if (body) {
            body->parent = &node;
            add_func_scope(ts, node, *body);
        }

        declare_func_arguments(ts, node);
        for (auto& arg : arg_list) {
            resolve_local_variable_type(ts, *arg);
        }

        if (body) {
            visit_tree(ts, *body);
            leave_scope_local(ts);
        }

        // try to resolve the func type already
        node.func.args_unresolved = true; // assume args are unresolved, possibly wasting a type check pass
        resolve_func_type(ts, node);
    }
    else {
        node.func.is_generic = true;
        if (!node.func.self) {
            ovbase->generic_funcs.push_back(&node.func);
        }

        node.scope.self = &node;
        node.func.self = &node;
        node.local.self = &node;
    }
}

bool visit_generated_func(type_system& ts, ast_node* node, ast_node& gnode, ast_node& call, call_match_info& info) {
    add_type_scope(ts, *node->children[ast_node::child_func_decl_arg_list], *node->children[ast_node::child_func_decl_arg_list]);
    scope_guard __{ [&]() { leave_scope_local(ts); } };

    auto& comptime_args = call.call.comptime_args;
    auto& call_args = call.call_args();

    // Pre-process compile-time arguments
    {
        auto& old_arg_list = node->children[ast_node::child_func_decl_arg_list]->children;
        std::vector<arena_ptr<ast_node>> new_arg_list;

        for (std::size_t i = 0; i < old_arg_list.size(); i++) {
            auto& argdecl = old_arg_list[i];
            if (argdecl->type == ast_type::comptime_expr) {
                type_id expected_comp_type = ts.type_type;
                ast_node* id_node = nullptr;
                if (argdecl->children[0]->type == ast_type::identifier) {
                    expected_comp_type = ts.type_type;
                    id_node = argdecl->children[0].get();
                }

                if (expected_comp_type == ts.type_type && std::holds_alternative<type_id>(comptime_args[i])) {
                    declare_comptime_symbol(ts, build_identifier_value(id_node->id_parts), comptime_args[i], expected_comp_type);
                    node->func.comptime_args.push_back(comptime_args[i]);
                }
            }
            else {
                new_arg_list.push_back(std::move(argdecl));
            }
        }

        node->children[ast_node::child_func_decl_arg_list]->children = std::move(new_arg_list);
    }

    auto& arg_list = node->children[ast_node::child_func_decl_arg_list]->children;

    for (std::size_t i = 0; i < arg_list.size(); i++) {
        auto& argdecl = arg_list[i];

        if (argdecl->var_type()) {
            resolve_node_type(ts, argdecl->var_type());

            auto& tid = argdecl->var_type()->type_id;

            type_query cq{};
            tquery_for_type_kind(cq, tid, type_kind::constructor);

            if (cq.result.valid() && cq.result.get().kind == type_kind::constructor) {
                type_query aq{};
                tquery_for_type_with_constructor(aq, call_args[i]->type_id, cq.result);

                if (!tquery_path_equal(aq, cq)) {
                    if (!check_convertible_and_cast_call_args_constructor(ts, *call_args[i], tid, i, info)) {
                        add_type_error(ts, call_args[i]->pos, "argument type '%s' does not have constructor type '%s'",
                            type_to_string(call_args[i]->type_id).c_str(),
                            type_to_string(cq.result).c_str());
                        complement_error(ts, gnode.pos, "requested constructor type '%s' in declaration of function '%s'",
                            type_to_string(cq.result).c_str(),
                            gnode.func.base_symbol.str.c_str());
                        return false;
                    }
                }
            }
            else if (tid.valid()) {
                // TODO: check for needed casts
                if (!check_convertible_and_cast_call_args(ts, *call_args[i], tid, i, info)) {
                    return false;
                }
            }
        }
    }

    perform_casts(ts, call_args, info);

    for (std::size_t i = 0; i < arg_list.size(); i++) {
        auto& argdecl = arg_list[i];

        // TODO: declare comptime symbol if declaration has comptime expression for the type
        argdecl->children[ast_node::child_var_decl_type] = make_type_resolver_node(*ts.ast_arena, call_args[i]->type_id);
    }

    auto body = node->children[ast_node::child_func_decl_body].get();
    if (body) {
        body->parent = node;
        add_func_scope(ts, *node, *body);
    }

    declare_func_arguments(ts, *node);
    for (auto& arg : arg_list) {
        resolve_local_variable_type(ts, *arg);
    }

    // TODO: check for compilation errors in the body and discard this generic overload

    if (body) {
        visit_tree(ts, *body);
        leave_scope_local(ts);
    }

    resolve_func_args_type(ts, *node);
    if (node->func_ret_type()) {
        resolve_node_type(ts, node->func_ret_type());
    }

    return true;
}

arena_ptr<ast_node> generate_func_for_call(type_system& ts, ast_node& gnode, ast_node& call, call_match_info& info) {
    auto node = copy_node(ts, &gnode);
    node->func.self = node.get();
    node->scope.self = node.get();
    node->local.self = node.get();
    node->func.decl_scope = gnode.func.decl_scope;
    node->func.base_symbol = gnode.func.base_symbol;

    auto prev_scope = ts.current_scope;
    ts.current_scope = gnode.func.decl_scope;
    scope_guard _{ [&]() { ts.current_scope = prev_scope; } };

    visit_generated_func(ts, node.get(), gnode, call, info);

    // try to resolve the func type already
    resolve_func_type(ts, *node);

    return std::move(node);
}

void generate_unpacking_operations(type_system& ts, ast_node& node) {
    auto valuecopy = copy_node(ts, node.var_value());
    auto tempname = generate_temp_name();
    auto tempdecl = make_var_decl_with_value(*ts.ast_arena, tempname, std::move(valuecopy));
    tempdecl->pos = node.pos;
    resolve_node_type(ts, tempdecl.get());
    node.parent->children_to_add.push_back(std::move(tempdecl));

    auto tempref = make_identifier_node(*ts.ast_arena, node.var_value()->pos, { tempname });

    if (node.type_id.get().kind == type_kind::structure || node.type_id.get().kind == type_kind::tuple) {
        const auto& fields = get_type_fields(node.type_id);
        int index = 0;
        for (auto& idnode : node.var_decl_ids()) {
            auto id = string_hash{ idnode->id_parts.back() };
            auto sym = find_symbol_in_current_scope(ts, id);

            auto dest = make_identifier_node(*ts.ast_arena, idnode->pos, idnode->id_parts);
            auto value = make_struct_field_access(*ts.ast_arena, copy_node(ts, tempref.get()), fields[index].names.front());

            if (sym) {
                // Symbol exists, generate assignment
                auto assign = make_assignment(*ts.ast_arena, std::move(dest), std::move(value));

                resolve_node_type(ts, assign.get());
                node.parent->children_to_add.push_back(std::move(assign));
            }
            else {
                // Symbol does not exist yet, generate declaration
                auto newdecl_type = make_type_expr_node(*ts.ast_arena, idnode->pos, make_type_resolver_node(*ts.ast_arena, fields[index].type));

                auto newdecl = make_var_decl_node_single(*ts.ast_arena, node.pos, token_type::let,
                    std::move(dest), std::move(newdecl_type), std::move(value), node.var_modifiers);

                resolve_node_type(ts, newdecl.get());
                node.parent->children_to_add.push_back(std::move(newdecl));
            }
            index++;
        }
    }
}

void resolve_and_declare_local_variables(type_system& ts, ast_node& node) {
    resolve_local_variable_type(ts, node);

    // Check if we're unpacking a tuple / struct / array
    if (node.type_id.valid() && is_aggregate(node.type_id) && node.var_decl_ids().size() > 1) {
        generate_unpacking_operations(ts, node);
        node.desugar_flags |= desugar_flag::var_decl_unpacked;
        node.disabled = true;
        return;
    }

    // Check if we're declaring a const (compile-time) value
    if (node.op == token_type::const_ && node.type_id.valid()) {
        if (!node.var_value()) {
            add_type_error(ts, node.pos, "const declaration requires a initializer expression");
            return;
        }

        auto [value, ok] = node_to_comptime_value_fold(ts, *node.var_value());
        if (ok) {
            auto id = string_hash{ node.var_id()->id_parts.back() };
            declare_comptime_symbol(ts, id, value, node.type_id);
        }
        else {
            add_type_error(ts, node.pos, "invalid constant expression");
        }
        return;
    }

    auto id = string_hash{ build_identifier_value(node.var_id()->id_parts) };

    if (node.type_id.valid()) {
        // Proceed with normal variable declaration (non-const, only 1 variable)
        if (ts.current_scope->kind == scope_kind::code_unit) {
            declare_global_symbol(ts, id, node);
        }
        else {
            declare_local_symbol(ts, id, node);
        }
        node.local.self = &node;
    }

    if (node.type_id.valid() && node.type_id.get().size == 0) {
        add_type_error(ts, node.pos, "cannot create value of an anonymous empty type");
        return;
    }

    if (node.var_value()) {
        if (node.var_value()->type == ast_type::init_expr) {
            if (node.type_id.valid() && !node.var_value()->initlist.receiver) {
                if (node.var_type() && node.var_value()->type_id.get().size == 0) {
                    node.var_value()->type_id = node.type_id;
                }

                // Create the ref for the assignments
                auto idref = make_identifier_node(*ts.ast_arena, {}, { id.str });
                resolve_identifier(ts, *idref.get());

                // Generate the assignments of the initializer list values
                if (check_aggregate_types_match(ts, node.pos, node.var_value()->type_id, node.type_id)) {
                    node.var_value()->type_id = node.type_id;
                    check_init_list_assignment(ts, *node.var_value(), *idref);
                    node.temps.push_back(std::move(idref));
                }
            }
        }
    } else if (node.type_id.valid() && check_type_allows_no_init(ts, node.pos, node.type_id)) {
        if (is_aggregate(node.type_id)) {
            auto idref = make_identifier_node(*ts.ast_arena, {}, { id.str });
            resolve_identifier(ts, *idref.get());
            auto initlist = generate_init_list_zero_values(ts, node.type_id);
            check_init_list_assignment(ts, *initlist, *idref);

            node.children[ast_node::child_var_decl_value] = std::move(initlist);
            node.temps.push_back(std::move(idref));
        } else {
            auto value = get_zero_value_node_for_type(ts, node.type_id);
            value->type_id = node.type_id;
            node.children[ast_node::child_var_decl_value] = std::move(value);
        }
    }
    else {
        node.type_error = true;
    }
}

void register_var_declaration_node(type_system& ts, ast_node& node) {
    // First check if at least one identifier is new
    for (auto& idnode : node.var_decl_ids()) {
        auto id = string_hash{ idnode->id_parts.back() };
        auto prev = find_symbol_in_current_scope(ts, id);
        if (prev) {
            add_type_error(ts, node.pos, "cannot redeclare name '%s'", idnode->id_parts.back().c_str());
            return;
        }
    }

    resolve_and_declare_local_variables(ts, node);
}

void resolve_assignment_type(type_system& ts, ast_node& node) {
    node.type_error = (node.children[0]->type_error || node.children[1]->type_error);

    // Check the left type is resolved
    if ((!node.children[0]->type_id.valid() || node.children[0]->type_error)) {
        complement_error(ts, node.pos, "in assignment of '%s'", node_to_string(*node.children[0]).c_str());
        return;
    }
    else if (!(node.children[0]->lvalue.self)) {
        add_type_error(ts, node.pos, "left-side of assignment must be an lvalue (identifier, index expression, struct/tuple field or pointer)");
        return;
    }

    // Check if we can re-assign the variable
    if (node.children[0]->type == ast_type::identifier) {
        auto local = get_symbol_local(*node.children[0]->lvalue.symbol);
        if (local && has_var_modifier(*local->self, token_type::const_)) {
            add_type_error(ts, node.children[0]->pos, "cannot re-assign a 'const' variable");
            node.type_error = true;
            return;
        }
    }
    /*
    else if (node.children[0]->type == ast_type::unary_expr && node.children[0]->op == token_from_char('*')) {
        if (node.children[0]->type_id.get().kind == type_kind::ptr) {
            add_type_error(ts, node.pos, "cannot dereference and assign to the pointer type '%s', did you mean to use a reference instead?",
                type_to_string(node.children[0]->type_id).c_str());
            node.type_error = true;
            return;
        }
    }
    else if (node.children[0]->type == ast_type::field_expr && node.children[0]->children[0]->type_id.get().kind == type_kind::ptr) {
        add_type_error(ts, node.pos, "cannot assign to field of pointer type '%s', did you mean to use a reference instead?",
            type_to_string(node.children[0]->children[0]->type_id).c_str());
        node.type_error = true;
        return;
    }
    else if (node.children[0]->type == ast_type::index_expr && node.children[0]->children[0]->type == ast_type::field_expr) {
        if (node.children[0]->children[0]->children[0]->type_id.get().kind == type_kind::slice &&
            node.children[0]->children[0]->children[0]->type_id.get().constructor_type == ts.slice_type_constructor->self->type_def.id) {
            
            add_type_error(ts, node.pos, "cannot assign to index of slice type '%s', did you mean to use a mutable slice instead?",
                type_to_string(node.children[0]->children[0]->children[0]->type_id).c_str());
            node.type_error = true;
            return;
        }
    }
    else if (node.children[0]->type == ast_type::index_expr && node.children[0]->children[0]->type_id.get().kind == type_kind::ptr) {
        add_type_error(ts, node.pos, "cannot assign to index of pointer type '%s', did you mean to use a reference instead?",
            type_to_string(node.children[0]->children[0]->type_id).c_str());
        node.type_error = true;
        return;
    }
    */

    if (node.children[1]->type == ast_type::init_expr) {
        if (!node.children[1]->initlist.receiver) {
            if (node.children[1]->type_id.get().size == 0) {
                node.children[1]->type_id = node.children[0]->type_id;
            }
            if (check_aggregate_types_match(ts, node.pos, node.children[1]->type_id, node.children[0]->type_id)) {
                node.children[1]->type_id = node.children[0]->type_id;
                check_init_list_assignment(ts, *node.children[1], *node.children[0]);
            }
        }
    }
    else {
        if (!node.children[1]->type_id.valid() || node.children[1]->type_error) {
            complement_error(ts, node.pos, "in assignment of '%s'", node_to_string(*node.children[0]).c_str());
            return;
        }
    }

    bool needs_cast = false;
    auto [convertible, ncast] = is_convertible_to(ts, node.children[1]->type_id, node.children[0]->type_id);
    if (!convertible) {
        try_coerce_to(ts, *node.children[1], node.children[0]->type_id);

        auto [convertible, ncast] = is_convertible_to(ts, node.children[1]->type_id, node.children[0]->type_id);
        if (!convertible) {
            add_type_error(ts, node.children[1]->pos, "cannot convert type '%s' to '%s'",
                type_to_string(node.children[1]->type_id).c_str(),
                type_to_string(node.children[0]->type_id).c_str());

            auto detail = get_conversion_error_detail(ts, node.children[1]->type_id, node.children[0]->type_id);
            if (detail) {
                complement_error(ts, node.pos, detail->c_str());
            }

            complement_error(ts, node.pos, "in assignment of '%s'", node_to_string(*node.children[0]).c_str());
            node.type_error = true;
            return;
        }
        else if (ncast) {
            needs_cast = true;
        }
    }
    else if (ncast) {
        needs_cast = true;
    }

    if (needs_cast) {
        node.children[1] = make_cast_to(ts, std::move(node.children[1]), node.children[0]->type_id);
    }

    node.type_error = false;
    node.type_id = node.children[0]->type_id;
}

token_type get_desugared_assignment_op(token_type op) {
    switch (op) {
    case token_type::plus_assign:
        return token_from_char('+');
    case token_type::minus_assign:
        return token_from_char('-');
    case token_type::mul_assign:
        return token_from_char('*');
    case token_type::div_assign:
        return token_from_char('/');
    case token_type::and_assign:
        return token_from_char('&');
    case token_type::or_assign:
        return token_from_char('|');
    case token_type::shr_assign:
        return token_type::shr;
    case token_type::shl_assign:
        return token_type::shl;
    default:
        assert(!"unhandled get_desugared_assignment_op");
    }
}

void desugar_assignment(type_system& ts, ast_node& node) {
    // e.g. a /= 4 ---> a = a / 4
    auto new_rhs = make_binary_expr_node(
        *ts.ast_arena, node.children[0]->pos, get_desugared_assignment_op(node.op),
        copy_node(ts, node.children[0].get()), std::move(node.children[1]));

    node.op = token_from_char('=');
    node.children[1] = std::move(new_rhs);
}

void register_for_declarations(type_system& ts, ast_node& node) {
    ast_node* elem_node = nullptr;
    if (node.children[0]->children.size() == 1) {
        elem_node = node.children[0]->children[0].get();
    }

    // TODO: handle array as well

    if (!node.forinfo.self && node.children[1]->type_id.valid() && elem_node) {
        if (node.children[1]->type_id.get().kind == type_kind::tuple) {
            int numfields = node.children[1]->type_id.get().structure.fields.size();
            if (numfields != 2) {
                add_type_error(ts, node.children[1]->pos, "a for statement requires a tuple of {start, end} or {start, end, step}");
                return;
            }

            type_id greater_type{};
            for (int i = 0; i < numfields; i++) {
            }

            auto iterdecl = make_var_decl_with_value(*ts.ast_arena, "$foriter", std::move(node.children[1]));
            resolve_node_type(ts, iterdecl.get());

            auto iterref1 = make_identifier_node(*ts.ast_arena, {}, { "$foriter" });
            resolve_node_type(ts, iterref1.get());

            auto iterref2 = make_identifier_node(*ts.ast_arena, {}, { "$foriter" });
            resolve_node_type(ts, iterref2.get());

            auto iterstart = make_struct_field_access(*ts.ast_arena, std::move(iterref1), "first");
            resolve_node_type(ts, iterstart.get());

            auto iterend   = make_struct_field_access(*ts.ast_arena, std::move(iterref2), "second");
            resolve_node_type(ts, iterend.get());

            // declare the variable to hold the element of the range
            auto elem_decl_node = make_var_decl_with_value(*ts.ast_arena, elem_node->id_parts.front(), std::move(iterstart));
            resolve_node_type(ts, elem_decl_node.get());

            auto elemref = make_identifier_node(*ts.ast_arena, {}, elem_node->id_parts);
            resolve_node_type(ts, elemref.get());

            node.forinfo.declare_for_iter = std::move(iterdecl);
            node.forinfo.declare_elem_to_range_start = std::move(elem_decl_node);
            node.forinfo.compare_elem_to_range_end = make_binary_expr_node(*ts.ast_arena, {},
                token_from_char('<'), copy_node(ts, elemref.get()), std::move(iterend)
            );

            // TODO: handle custom step
            auto step = make_int_literal_node(*ts.ast_arena, {}, 1);
            auto elem_plus = make_binary_expr_node(*ts.ast_arena, {},
                token_from_char('+'), copy_node(ts, elemref.get()), std::move(step)
            );
            node.forinfo.increase_elem = make_assignment(*ts.ast_arena, copy_node(ts, elemref.get()), std::move(elem_plus));

            resolve_node_type(ts, node.forinfo.declare_elem_to_range_start.get());
            resolve_node_type(ts, node.forinfo.compare_elem_to_range_end.get());
            resolve_node_type(ts, node.forinfo.increase_elem.get());
            node.forinfo.self = &node;

            node.forinfo.declare_for_iter->parent = &node;
            node.forinfo.declare_elem_to_range_start->parent = &node;
            node.forinfo.compare_elem_to_range_end->parent = &node;
            node.forinfo.increase_elem->parent = &node;
        }
        else {
            add_type_error(ts, node.children[1]->pos, "a for statement requires a tuple of {start, end} or {start, end, step}");
        }
    }
}

arena_ptr<ast_node> make_neq_false_node(type_system& ts, arena_ptr<ast_node>&& val) {
    auto node = make_binary_expr_node(
        *ts.ast_arena,
        val->pos,
        token_type::neq,
        std::move(val),
        make_bool_literal_node(*ts.ast_arena, val->pos, 0)
    );
    resolve_node_type(ts, val.get());
    return node;
}

void ensure_bool_op_is_comparison(type_system& ts, ast_node& node) {
    if (!is_bool_op(*node.children[0])) {
        node.children[0] = make_neq_false_node(ts, std::move(node.children[0]));
    }
    if (!is_bool_op(*node.children[1])) {
        node.children[1] = make_neq_false_node(ts, std::move(node.children[1]));
    }
}

void ensure_bool_op_is_comparison_unary(type_system& ts, ast_node& node) {
    if (!is_bool_op(*node.children[0])) {
        node.children[0] = make_neq_false_node(ts, std::move(node.children[0]));
    }
}

bool is_root_bool_op(type_system& ts, ast_node& node) {
    return is_bool_op(node) && !is_bool_op(*node.parent);
}

bool is_bool_op_inside_if_condition(type_system& ts, ast_node& node) {
    return node.parent->type == ast_type::if_stmt;
}

ast_node* find_valid_parent_to_add_pre_children(type_system& ts, ast_node& node) {
    auto parent = node.parent;
    while (parent) {
        if (parent->type != ast_type::arg_list) {
            return parent;
        }
        parent = parent->parent;
    }
    return nullptr;
}

void resolve_range_expr(type_system& ts, ast_node& node) {
    assert(!"range not supported anymore");
}

bool check_reserved_call(type_system& ts, ast_node& node) {
    if (node.children[0]->type == ast_type::identifier) {
        if (node.children[0]->id_parts.front() == "sizeof") {
            for (int i = 0; i < 2; i++) {
                node.type_error = true;
                if (i == 0) {
                    resolve_node_type(ts, node.children[1]->children[0].get());
                    if (node.children[1]->children[0]->type_id.valid()) {
                        node.type = ast_type::int_literal;
                        node.type_id = ts.usize_type;
                        node.int_value = node.children[1]->children[0]->type_id.get().size;
                        node.type_error = false;
                    }
                }
                else {
                    if (!node.sizeof_type_expr) {
                        node.sizeof_type_expr = make_type_expr_node(*ts.ast_arena, node.children[1]->children[0]->pos, copy_node(ts, node.children[1]->children[0].get()));
                    }
                    resolve_node_type(ts, node.sizeof_type_expr.get());
                    if (node.sizeof_type_expr->type_id.valid()) {
                        node.type = ast_type::int_literal;
                        node.type_id = ts.usize_type;
                        node.int_value = node.sizeof_type_expr->type_id.get().size;
                        node.type_error = false;
                    }
                }
            }
            return true;
        }
        else if (node.children[0]->id_parts.front() == "nullcast") {
            resolve_node_type(ts, node.children[1]->children[0].get());
            if (node.children[1]->children[0]->type_id.valid()) {
                node.type = ast_type::nullcast_expr;
                node.type_id = get_ptr_type_to(ts, node.children[1]->children[0]->type_id.get().elem_type);
                node.type_error = false;
            }
            return true;
        }
    }
    return false;
}

void separate_func_overload_selector_args(type_system& ts, ast_node& node) {
    if (!(node.call.flags & call_flag::separated_args)) {
        node.call.flags |= call_flag::separated_args;

        std::vector<arena_ptr<ast_node>> new_args;
        for (auto& arg : node.func_overload_args()) {
            if (arg->type == ast_type::comptime_expr) {
                auto [value, ok] = node_to_comptime_value(ts, *arg);
                if (!ok) {
                    assert(false);
                }

                node.call.comptime_args.push_back(value);
            }
            else {
                new_args.push_back(std::move(arg));
            }
        }

        node.children[1]->children[0]->children[0]->children = std::move(new_args);
    }
}

void separate_call_args(type_system& ts, ast_node& node) {
    if (!(node.call.flags & call_flag::separated_args)) {
        node.call.flags |= call_flag::separated_args;

        std::vector<arena_ptr<ast_node>> new_args;
        for (auto& arg : node.call_args()) {
            if (arg->type == ast_type::comptime_expr) {
                auto [value, ok] = node_to_comptime_value(ts, *arg);
                if (!ok) {
                    assert(false);
                }

                node.call.comptime_args.push_back(value);
            }
            else {
                new_args.push_back(std::move(arg));
            }
        }

        node.children[1]->children = std::move(new_args);
    }
}

void resolve_call_funcdef(type_system& ts, ast_node& node) {
    auto pair = separate_module_identifier(node.call_func()->id_parts);

    separate_call_args(ts, node);

    for (const auto& linkage : { func_linkage::local_carbon, func_linkage::external_c }) {
        node.call.mangled_name = mangle_func_name(ts, { pair.second.str }, node.call.comptime_args, node.call_args(), linkage);

        auto sym = find_symbol(ts, { pair.first, node.call.mangled_name });
        if (sym && sym->kind == symbol_kind::top_level_func) {
            auto local = sym->scope->local_defs[sym->local_index];
            node.type_id = local->self->type_def.func.ret_type;
            node.call.func_type_id = local->self->type_id;
            node.call.funcdef = &local->self->func;
            node.type_error = false;
            //if (local->flags & local_flag::is_aggregate_argument) {
              //  node.type_id = node.type_id.get().elem_type;
            //}
            break;
        }
    }

    if (!node.type_id.valid()) {
        node.type_error = true;

        auto funcname = node_to_string(*node.call_func());
        if (funcname == "allocn") {
            //printf("asdqwe\n");
        }
        auto bsym = find_symbol(ts, pair);
        if (bsym && bsym->kind == symbol_kind::overloaded_func_base) {
            // try to match the arguments performing implicit conversions using the function non-generic overloads
            bool resolved = false;
            for (std::size_t i = 0; i < bsym->overload_funcs.size(); i++) {
                auto func = bsym->overload_funcs[i];
                if (match_arg_list(ts, func->self->func_args(), node.call_args(), func->comptime_args, node.call.comptime_args)) {
                    resolved = true;
                    node.type_id = func->self->type_def.func.ret_type;
                    node.call.func_type_id = func->self->type_id;
                    node.call.funcdef = func;
                    node.type_error = false;
                    break;
                }
            }

            // try to match the arguments performing implicit conversions using the function GENERIC overloads
            if (!resolved) {
                for (std::size_t i = 0; i < bsym->generic_funcs.size(); i++) {
                    auto func = bsym->generic_funcs[i];
                    if (func->self->func_args().size() != (node.call.comptime_args.size() + node.call_args().size())) { continue; }

                    call_match_info info{};
                    auto genfunc = generate_func_for_call(ts, *func->self, node, info);
                    if (genfunc) {
                        resolved = true;
                        node.type_id = genfunc->type_def.func.ret_type;
                        node.call.func_type_id = genfunc->type_id;
                        node.call.funcdef = &genfunc->func;
                        node.type_error = false;
                        func->self->parent->children_to_add.push_back(std::move(genfunc));
                        break;
                    }
                }
            }

            if (!resolved) {
                unk_type_error(ts, node.type_id, node.pos, "cannot determine type of function call to '%s'", funcname.c_str());
                complement_error(ts, node.pos, "function exists but cannot find a matching argument list");
                for (std::size_t i = 0; i < bsym->overload_funcs.size(); i++) {
                    auto func = bsym->overload_funcs[i];
                    complement_error(ts, node.pos, "candidate #%d: '%s' declared in %s:%d",
                        (i + 1), func_declaration_to_string(func).c_str(), func->self->pos.filename.c_str(), func->self->pos.line_number);
                }
                for (std::size_t i = 0; i < bsym->generic_funcs.size(); i++) {
                    auto func = bsym->generic_funcs[i];
                    complement_error(ts, node.pos, "candidate #%d: '%s' declared in %s:%d",
                        (bsym->overload_funcs.size() + i + 1), func_declaration_to_string(func).c_str(), func->self->pos.filename.c_str(), func->self->pos.line_number);
                }
                complement_error(ts, node.pos, "call arguments: (%s)", type_list_to_string(node.call.arg_types).c_str());
            }
        }
        else if (bsym) {
            unk_type_error(ts, node.type_id, node.pos, "cannot determine type of function call to '%s'", funcname.c_str());
            complement_error(ts, node.pos, "symbol '%s' is not a function", funcname.c_str());
        }
        else {
            unk_type_error(ts, node.type_id, node.pos, "cannot determine type of function call to '%s'", funcname.c_str());
            complement_error(ts, node.pos, "undefined symbol '%s'", funcname.c_str());
        }
    }
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

void visit_pre_children(type_system& ts, ast_node& node) {
    for (auto& child : node.pre_children) {
        if (child) {
            child->parent = &node;
            visit_tree(ts, *child);
        }
    }
}

void visit_children(type_system& ts, ast_node& node) {
    for (auto& child : node.children) {
        if (child) {
            child->parent = &node;
            visit_tree(ts, *child);
        }
    }
    for (auto& child : node.children_to_add) {
        node.children.push_back(std::move(child));
    }
    node.children_to_add.clear();
}

template <typename F> void for_each_child_recur(ast_node& node, ast_type type, F f) {
    for (auto& child : node.children) {
        if (child) {
            if (child->type == type) {
                f(*child);
            }
            else { 
                for_each_child_recur(*child, type, f);
            }
        }
    }
}

void apply_linkage_specifier(const std::vector<arena_ptr<ast_node>>& children, func_linkage linkage, const std::vector<std::string>& alias) {
    for (auto& child : children) {
        if (!child) continue;

        if (child->type == ast_type::func_decl || child->type == ast_type::var_decl) {
            child->func.linkage = linkage;
            child->func.extern_alias = alias;
        }
        else if (child->type == ast_type::decl_list || child->type == ast_type::visibility_specifier) {
            apply_linkage_specifier(child->children, linkage, alias);
        }
    }
}

void apply_visibility_specifier(const std::vector<arena_ptr<ast_node>>& children, decl_visibility vis) {
    for (auto& child : children) {
        if (!child) continue;

        if (child->type == ast_type::func_decl || child->type == ast_type::var_decl) {
            child->visibility = vis;
        }
        else if (child->type == ast_type::decl_list || child->type == ast_type::linkage_specifier) {
            apply_visibility_specifier(child->children, vis);
        }
    }
}

void process_thread_first_expr(type_system& ts, ast_node& node) {
    if (node.children[1]->type != ast_type::call_expr) {
        add_type_error(ts, node.children[1]->pos, "'->' operator expects a call expression in the right-side");
        return;
    }

    auto receiver = std::move(node.children[0]);
    auto call_expr = std::move(node.children[1]);

    node.children.clear();

    auto new_args = std::vector<arena_ptr<ast_node>>{};
    new_args.push_back(std::move(receiver));
    for (auto& arg : call_expr->call_args()) {
        new_args.push_back(std::move(arg));
    }

    call_expr->children[ast_node::child_call_expr_arg_list]->children = std::move(new_args);

    node.children.push_back(std::move(call_expr->children[0]));
    node.children.push_back(std::move(call_expr->children[1]));

    node.type = ast_type::call_expr;
    node.call.flags |= call_flag::is_method_sugar_call;
}

void generate_temp_for_field_expr(type_system& ts, ast_node& node, type_id ltype) {
    auto tempname = generate_temp_name();
    auto temp = make_var_decl_node_single(*ts.ast_arena, node.pos, token_type::let,
        make_identifier_node(*ts.ast_arena, node.pos, { tempname }), // id
        make_type_expr_node(*ts.ast_arena, node.pos, make_type_resolver_node(*ts.ast_arena, ltype)), // type
        std::move(node.children[0]), {}); // value

    resolve_node_type(ts, temp.get());

    auto ref = make_identifier_node(*ts.ast_arena, temp->pos, { tempname });
    resolve_node_type(ts, ref.get());

    node.children[0] = std::move(ref);

    node.pre_children.push_back(std::move(temp));

    node.desugar_flags |= 1;
}

static bool g_inside_loop;

type_id resolve_node_type(type_system& ts, ast_node* nodeptr) {
    if (!nodeptr) return invalid_type;

    auto& node = *nodeptr;
    bool check_for_unresolved = true;

    switch (node.type) {
    case ast_type::import_decl: {
        check_for_unresolved = false;

        if (ts.pass == type_system_pass::resolve_literals_and_register_declarations && ts.subpass == 0) {
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
        }
        break;
    }
    case ast_type::type_decl: {
        check_for_unresolved = false;

        node.type_def.name = string_hash{ build_identifier_value(node.children[0]->id_parts) };
        node.type_def.mangled_name = string_hash{ build_identifier_value(node.children[0]->id_parts) };
        node.type_def.size = 0;
        node.type_def.is_opaque = true;

        type_id new_type_id{};
        if (!node.type_def.self) {
            auto sym = find_symbol_in_current_scope(ts, node.type_def.mangled_name);
            if (sym) {
                add_type_error(ts, node.pos, "cannot re-declare type '%s'", node.type_def.mangled_name.str.c_str());
                break;
            }
            new_type_id = register_user_type(ts, node);
        }

        node.type_def.self = &node;

        visit_tree(ts, *node.children[1]);
        if (node.children[1]) {
            auto type = node.children[1]->type_id;
            if (type.valid()) {
                node.type_def = type.get();
                node.type_def.id = new_type_id;
                node.type_def.self = &node;
                node.type_def.is_opaque = false;
                node.type_def.name = string_hash{ build_identifier_value(node.children[0]->id_parts) };
                node.type_def.mangled_name = string_hash{ build_identifier_value(node.children[0]->id_parts) };

                bool is_alias = node.int_value == 1;
                if (is_alias) {
                    node.type_def.alias_to = type;
                }
                //register_user_type(ts, node);
            }
            else {
                complement_error(ts, node.pos, "in type declaration '%s'", node_to_string(node).c_str());
            }
        }
        break;
    }
    case ast_type::type_constructor_decl: {
        check_for_unresolved = false;

        node.type_def.self = &node;
        node.type_def.name = string_hash{ build_identifier_value(node.children[0]->id_parts) };
        node.type_def.mangled_name = string_hash{ build_identifier_value(node.children[0]->id_parts) };
        node.type_def.kind = type_kind::constructor;

        type_constructor* type_ctor = &node.type_def.constructor;
        type_ctor->self = &node;

        type_ctor->func = [&ts, ctor = &node](const std::vector<comptime_value>& args) -> arena_ptr<ast_node> {
            // TODO: check number of args match and everything.
            // TODO: allow type constructor 'body' form, that returns a type at the end but has arbitrary code in it.

            auto& arg_list = copy_node(ts, ctor->children[1].get());
            auto& content = copy_node(ts, ctor->children[2].get());
            add_type_scope(ts, *content, *content);

            for (std::size_t i = 0; i < arg_list->children.size(); i++) {
                auto& ctor_arg_node = *arg_list->children[i];
                type_id arg_type = ts.type_type;//TODO: get_comptime_arg_type(ctor_arg_node);
                if (arg_type.get().kind == type_kind::type) {
                    auto instance_targ = std::get<type_id>(args[i]);
                    declare_comptime_symbol(ts, string_hash{ build_identifier_value(ctor_arg_node.var_id()->id_parts) }, instance_targ, arg_type);
                }
                else {
                    assert(!"user type constructor arg type not handled");
                }
            }

            resolve_node_type(ts, content.get()); 

            // Copy the type def from the type expr content
            content->type_def = content->children[0]->type_def;
            content->type_def.name = build_type_constructor_name(ctor->type_def.name.str, args);
            content->type_def.mangled_name = build_type_constructor_mangled_name(ctor->type_def.mangled_name.str, args);

            leave_scope_local(ts);
            return std::move(content);
        };

        register_user_type(ts, node);
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
    case ast_type::comptime_expr: {
        if (ts.pass != type_system_pass::perform_checks && node.type_id != invalid_type) return node.type_id;

        auto tid = get_type_expr_node_type(ts, *node.children[0]);
        if (tid.valid()) {
            node.type_id = ts.type_type;
            node.type_error = false;
        }
        else {
            add_type_error(ts, node.pos, "invalid compile-time expression");
        }
        break;
    }
    case ast_type::compound_stmt: {
        check_for_unresolved = false;
        if (node.parent->type != ast_type::func_decl) {
            if (node.scope.kind == scope_kind::invalid) {
                add_block_scope(ts, node, node);
            }
            else {
                enter_scope_local(ts, node);
            }
        }
        visit_children(ts, node);
        if (node.parent->type != ast_type::func_decl) {
            leave_scope_local(ts);
        }
        break;
    }
    case ast_type::return_stmt: {
        if (ts.inside_defer) {
            add_type_error(ts, node.pos, "illegal use of return statement while inside defer statement");
            node.type_error = true;
        }

        node.type_id = resolve_node_type(ts, node.children.front().get());
        if (!node.type_id.valid() || node.type_error) {
            auto funcname = node_to_string(
                *(find_nearest_scope_local(ts, scope_kind::func_body)->self->func_id())
            );
            complement_error(ts, node.pos, "in return statement of function '%s'", funcname.c_str());
        }

        // TODO: check if scope / sanity check
        auto scope = find_nearest_scope_local(ts, scope_kind::func_body);

        bool exists = false;
        for (auto ret : scope->self->func.return_statements) {
            if (ret == nodeptr) {
                exists = true;
                break;
            }
        }
        if (!exists) {
            scope->self->func.return_statements.push_back(nodeptr);
        }
        break;
    }
    case ast_type::continue_stmt:
    case ast_type::break_stmt: {
        check_for_unresolved = false;
        if (!g_inside_loop) {
            const char* stmt = (node.type == ast_type::continue_stmt) ? "continue" : "break";
            add_type_error(ts, node.pos, "'%s' statement can only be used inside a loop statement (e.g. while, for)", stmt);
        }
        break;
    }
    case ast_type::for_stmt: {
        check_for_unresolved = false;
        visit_tree(ts, *node.children[1]);

        if (ts.pass == type_system_pass::resolve_literals_and_register_declarations) {
            add_block_scope(ts, node, *node.children[2]);
        }
        else {
            enter_scope_local(ts, node);
        }

        register_for_declarations(ts, node);

        bool prevloop = g_inside_loop;
        g_inside_loop = true;

        visit_tree(ts, *node.children[2]);
        leave_scope_local(ts);

        g_inside_loop = prevloop;
        break;
    }
    case ast_type::if_stmt:
    case ast_type::while_stmt: {
        check_for_unresolved = false;

        bool prevloop = g_inside_loop;
        if (node.type == ast_type::while_stmt) {
            g_inside_loop = true;
        }

        if (node.scope.kind == scope_kind::invalid) {
            add_block_scope(ts, node, node);
        }
        else {
            enter_scope_local(ts, node);
        }
        visit_children(ts, node);

        g_inside_loop = prevloop;

        const char* stmt = (node.type == ast_type::if_stmt) ? "if" : "while";
        if (!node.children[0]->type_id.valid() || node.children[0]->type_error) {
            complement_error(ts, node.pos, "in %s statement condition", stmt);
            node.type_error = true;
        }
        else if (!is_assignable_to(ts, node.children[0]->type_id, ts.bool_type)) {
            add_type_error(ts, node.pos, "%s statement condition must have 'bool' type", stmt);
            node.type_error = true;
        }

        if (!node.type_error && !is_bool_op(*node.children[0])) {
            node.children[0] = make_neq_false_node(ts, std::move(node.children[0]));
        }

        leave_scope_local(ts);
        break;
    }
    case ast_type::defer_stmt: {
        if (ts.inside_defer) {
            add_type_error(ts, node.pos, "illegal use of defer statement inside another defer statement");
            node.type_error = true;
            break;
        }

        check_for_unresolved = false;
        ts.inside_defer = true;
        visit_children(ts, node);
        ts.inside_defer = false;
        break;
    }
    case ast_type::linkage_specifier: {
        check_for_unresolved = false;

        if (!node.func.self) {
            auto& alias = node.children[0];
            std::vector<std::string> alias_id = {};
            if (alias) {
                alias_id = alias->id_parts;
            }

            apply_linkage_specifier(node.children, node.func.linkage, alias_id);

            node.children.erase(node.children.begin());

            node.func.self = &node;
        }

        int i = 0;
        for (auto& child : node.children) {
            visit_tree(ts, *child);
            i++;
        }
        break;
    }
    case ast_type::visibility_specifier: {
        check_for_unresolved = false;
        apply_visibility_specifier(node.children, node.visibility);
        visit_children(ts, node);
        break;
    }
    case ast_type::func_decl: {
        if (ts.pass == type_system_pass::resolve_literals_and_register_declarations) {
            register_func_declaration_node(ts, node);
        }
        else if (!node.func.is_generic) {
            auto funcname = node_to_string(*node.func_id());
            resolve_func_args_type(ts, node);

            auto body = node.func_body();
            if (body) {
                body->parent = &node;
                enter_scope_local(ts, node);
                visit_children(ts, *body);
                leave_scope_local(ts);
            }
            else if (node.func.linkage == func_linkage::local_carbon) {
                // TODO: error
                assert(!"func linkage error");
            }

            resolve_func_type(ts, node);
        }
        else {
            check_for_unresolved = false;
        }
        break;
    }
    case ast_type::func_expr: {
        assert(!node.func_overload.self);

        auto encfunc = find_nearest_scope_local(ts, scope_kind::func_body)->self;
        auto encname = build_identifier_value(encfunc->func_id()->id_parts);
        auto lambda_name = encname + "__lambda__" + std::to_string(string_hash{ node.pos.filename }.hash) + "__" + std::to_string(node.pos.src_offs);
        auto lambda_id = make_identifier_node(*ts.ast_arena, {}, { lambda_name });
        auto new_func_decl = make_func_decl_node(
            *ts.ast_arena, node.pos, std::move(lambda_id),
            std::move(node.children[1]), std::move(node.children[2]), std::move(node.children[3]), func_linkage::local_carbon
        );
        auto new_func_decl_ptr = new_func_decl.get();
        encfunc->parent->children_to_add.push_back(std::move(new_func_decl));

        // Transform into a overload selector to get the function pointer as a result
        node.children.clear();
        node.type = ast_type::func_overload_selector_expr;
        node.func_overload.from_lambda = new_func_decl_ptr;
        node.func_overload.self = &node;
        break;
    }
    case ast_type::func_overload_selector_expr: {
        if (node.func_overload.from_lambda) {
            auto func = node.func_overload.from_lambda;
            node.call.funcdef = &func->func;

            if (func->type_def.id.valid()) {
                node.type_id = get_func_pointer_type_to(ts, func->type_def.id);
                node.type_error = false;
            }
            else {
                node.type_error = true;
            }
            break;
        }

        node.func_overload.self = &node;
        visit_tree(ts, *node.func_overload_fn());

        bool args_resolved = true;
        int argindex = 0;
        node.call.arg_types.clear();
        for (auto& arg : node.func_overload_args()) {
            resolve_node_type(ts, arg.get());
            if (arg->type_id == invalid_type || arg->type_error) {
                node.type_error = true;
                complement_error(ts, arg->pos, "in the #%d type argument for function overload selector '%s'",
                    argindex + 1, node_to_string(*node.func_overload_fn()).c_str());
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

        if (args_resolved) {
            auto pair = separate_module_identifier(node.func_overload_fn()->id_parts);

            separate_func_overload_selector_args(ts, node);

            for (const auto& linkage : { func_linkage::local_carbon, func_linkage::external_c }) {
                node.call.mangled_name = mangle_func_name(ts, { pair.second.str }, node.call.comptime_args, node.func_overload_args(), linkage);

                auto sym = find_symbol(ts, { pair.first, node.call.mangled_name });
                if (sym && sym->kind == symbol_kind::top_level_func) {
                    auto local = sym->scope->local_defs[sym->local_index];
                    node.type_id = get_func_pointer_type_to(ts, local->self->type_def.id);
                    node.call.funcdef = &local->self->func;
                    node.type_error = false;

                    if (local->flags & local_flag::is_aggregate_argument) {
                        node.type_id = node.type_id.get().elem_type;
                    }
                    break;
                }
            }
        }

        if (!node.type_id.valid()) {
            node.type_error = true;

            auto pair = separate_module_identifier(node.func_overload_fn()->id_parts);
            auto funcname = node_to_string(*node.func_overload_fn());
            auto bsym = find_symbol(ts, pair);
            if (bsym && bsym->kind == symbol_kind::overloaded_func_base) {
                // try to match the arguments performing implicit conversions
                bool resolved = false;
                for (std::size_t i = 0; i < bsym->overload_funcs.size(); i++) {
                    auto func = bsym->overload_funcs[i];
                    if (match_arg_list(ts, func->self->func_args(), node.func_overload_args(), func->comptime_args, node.call.comptime_args)) {
                        resolved = true;
                        node.type_id = func->self->type_def.func.ret_type;
                        node.call.func_type_id = func->self->type_id;
                        node.call.funcdef = func;
                        node.type_error = false;
                        break;
                    }
                }

                if (!resolved) {
                    unk_type_error(ts, node.type_id, node.pos, "cannot find function overload for '%s'", funcname.c_str());
                    complement_error(ts, node.pos, "function exists but cannot find a matching argument list");
                    for (std::size_t i = 0; i < bsym->overload_funcs.size(); i++) {
                        auto func = bsym->overload_funcs[i];
                        complement_error(ts, node.pos, "candidate #%d: '%s' declared in %s:%d",
                            (i + 1), func_declaration_to_string(func).c_str(), func->self->pos.filename.c_str(), func->self->pos.line_number);
                    }
                    complement_error(ts, node.pos, "requested arguments: (%s)", type_list_to_string(node.call.arg_types).c_str());
                }
            }
            else if (bsym) {
                unk_type_error(ts, node.type_id, node.pos, "cannot find function overload for '%s'", funcname.c_str());
                complement_error(ts, node.pos, "symbol '%s' is not a function", funcname.c_str());
            }
            else {
                unk_type_error(ts, node.type_id, node.pos, "cannot find function overload for '%s'", funcname.c_str());
                complement_error(ts, node.pos, "undefined symbol '%s'", funcname.c_str());
            }
        }
        break;
    }
    case ast_type::call_expr: {
        if (check_reserved_call(ts, node)) {
            break;
        }

        if (!node.call.self) {
            node.call.self = &node;
        }
        auto funcname = node_to_string(*node.call_func());

        bool args_resolved = true;
        int argindex = 0;
        node.call.arg_types.clear();
        for (auto& arg : node.call_args()) {
            resolve_node_type(ts, arg.get());
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

        visit_tree(ts, *node.call_func());
        if (node.call_func()->type == ast_type::identifier && !node.call_func()->type_id.valid()) {
            if (args_resolved) {
                // both args and func resolved
                resolve_call_funcdef(ts, node);
            }

            if (!node.call.funcdef) {
                //printf("asda");
            }
        }
        else if (node.call_func()->type_id.valid() && node.call_func()->type_id.get().kind == type_kind::func_pointer) {
            node.type_id = node.call_func()->type_id.get().func.ret_type;
            node.call.func_type_id = node.call_func()->type_id;
            node.type_error = false;
        }

        //report_type_error(node.type_id, node.pos, "cannot resolve type of function call %s", node_to_string(node));
        break;
    }
    case ast_type::field_expr: {
        resolve_node_type(ts, node.children[0].get());

        auto fieldid = build_identifier_value(node.children[1]->id_parts);
        if (fieldid == "strlen") {
            //printf("asdqwe\n");
        }

        if (node.children[0]->type_id.valid()) {
            auto ltype = node.children[0]->type_id;
            auto stype = ltype;

            // Generate a temp variable if it's not a lvalue
            if (!node.desugar_flags) {
                if (node.children[0]->type == ast_type::init_expr) {
                    generate_temp_for_field_expr(ts, node, ltype);
                    node.desugar_flags |= 1;
                }
                else if (node.children[0]->type == ast_type::call_expr && is_aggregate_root(ltype)) {
                    generate_temp_for_field_expr(ts, node, ltype);
                    node.desugar_flags |= 1;
                }
            }
            
            bool is_pointer = false;
            bool is_optional = false;
            bool is_struct = is_aggregate_root(stype);

            enum { LIMIT = 32 };
            int si = 0;
            while (stype.valid() && !is_aggregate_root(stype) && (si++) < LIMIT) {
                if (stype.get().kind == type_kind::nullableptr) {
                    node.type_error = true;
                    add_type_error(ts, node.pos, "cannot access field of nullable pointer '%s', perform a nullcast first", type_to_string(ltype).c_str());
                }
                else if ((stype.get().kind == type_kind::ptr) && is_aggregate(stype.get().elem_type)) {
                    is_struct = true;
                    is_pointer = true;
                    stype = stype.get().elem_type;
                }
                else if ((stype.get().flags & (type_flags::is_auto | type_flags::is_pure)) && is_aggregate(stype.get().elem_type)) {
                    stype = stype.get().elem_type;
                    is_struct = true;
                }
                else if (is_aggregate(stype)) {
                    is_struct = true;
                }
            }
            assert(stype.valid());

            int field_index = aggregate_find_field(stype, fieldid);
            if (is_struct && field_index != -1) {
                node.lvalue.self = &node;
                node.field.self = &node;
                node.field.is_optional = is_optional;
                node.field.field_index = field_index;
                node.type_id = stype.get().structure.fields[field_index].type;
            } 
            else if (!is_struct) {
                add_type_error(ts, node.children[1]->pos, "trying to access field '%s' of non-aggregate type '%s'",
                    fieldid.c_str(), type_to_string(ltype).c_str());
            }
            else {
                add_type_error(ts, node.children[1]->pos, "type '%s' has no field '%s'",
                    type_to_string(stype).c_str(), fieldid.c_str());
            }
        }
        break;
    }
    case ast_type::index_expr: {
        resolve_node_type(ts, node.children[0].get());
        resolve_node_type(ts, node.children[1].get());
        bool arr = false;
        bool sli = false;
        bool ptr = false;
        bool tup = false;

        if (node.children[0]->type_id.valid()) {
            arr = node.children[0]->type_id.get().kind == type_kind::array;
            sli = node.children[0]->type_id.get().kind == type_kind::slice;
            ptr = is_pointer(node.children[0]->type_id);
            tup = node.children[0]->type_id.get().kind == type_kind::tuple;
        }

        bool error = false;
        {
            const char* msg = "left-side of index expression has type '%s', it must be an array, pointer or tuple";
            if (!node.children[0]->type_id.valid()) {
                complement_error(ts, node.pos, msg, type_to_string(node.children[0]->type_id).c_str());
                error = true;
            }
            else if (!(arr || ptr || tup || sli)) {
                add_type_error(ts, node.pos, msg, type_to_string(node.children[0]->type_id).c_str());
                error = true;
            }
        }

        {
            const char* msg = "right-side of index expression has type '%s', it must be an integer or slice tuple";
            if (!node.children[1]->type_id.valid()) {
                complement_error(ts, node.pos, msg, type_to_string(node.children[1]->type_id).c_str());
                error = true;
            }
            else if ((arr || ptr || sli) && !(node.children[1]->type_id.get().kind == type_kind::integral || node.children[1]->type_id.get().kind == type_kind::tuple)) {
                add_type_error(ts, node.pos, msg, type_to_string(node.children[1]->type_id).c_str());
                error = true;
            }
            else if (tup && !(node.children[1]->type_id.get().kind == type_kind::integral)) {
                add_type_error(ts, node.pos, msg, type_to_string(node.children[1]->type_id).c_str());
                error = true;
            }
        }

        if (tup && node.children[1]->type != ast_type::int_literal) {
            add_type_error(ts, node.pos, "tuple index must be a constant expression");
            error = true;
        }

        node.type_error = error;
        if (!error) {
            if (arr || ptr) {
                if (node.children[1]->type_id.get().kind == type_kind::tuple) {
                    // slice operation
                    transform_slice_expr_to_init_expr(ts, node, false);
                }
                else {
                    node.lvalue.self = &node;
                    node.type_id = node.children[0]->type_id.get().elem_type;
                }
            }
            else if (sli) {
                node.lvalue.self = &node;
                node.type_id = node.children[0]->type_id.get().elem_type;

                auto field = make_struct_field_access(*ts.ast_arena, std::move(node.children[0]), "ptr");
                resolve_node_type(ts, field.get());
                node.children[0] = std::move(field);
            }
            else if (tup) {
                const auto& fields = get_type_fields(node.children[0]->type_id);
                if (node.children[1]->int_value >= fields.size()) {
                    node.type_error = true;
                    add_type_error(ts, node.pos, "tuple index out of bounds, type '%s' has only %d fields",
                        type_to_string(node.children[0]->type_id).c_str(), (int)fields.size());
                }
                else {
                    node.lvalue.self = &node;

                    int findex = node.children[1]->int_value;
                    const auto& field = fields[findex];

                    node.children[1] = make_identifier_node(*ts.ast_arena, node.children[1]->pos, { field.names.front() });
                    node.field.self = &node;
                    node.field.field_index = findex;
                    node.type = ast_type::field_expr;
                    node.type_id = field.type;
                }
            }
        }
        break;
    }
    case ast_type::var_decl: {
        if (!(node.desugar_flags & desugar_flag::var_decl_unpacked)) {
            if (ts.pass == type_system_pass::resolve_literals_and_register_declarations) {
                register_var_declaration_node(ts, node);
            }
            else {
                resolve_and_declare_local_variables(ts, node);
                if (!node.type_id.valid() || node.type_error) {
                    auto name = node_to_string(*node.var_id());
                    complement_error(ts, node.pos, "in declaration of variable '%s'", name.c_str());
                }
            }
        }
        break;
    }
    case ast_type::identifier: {
        //if (ts.pass != type_system_pass::perform_checks && node.type_id != invalid_type) return node.type_id;

        if (node.lvalue.symbol && node.lvalue.symbol->kind == symbol_kind::overloaded_func_base) {
            check_for_unresolved = false;
            break;
        }

        resolve_identifier(ts, node);
        break;
    }
    case ast_type::binary_expr: {
        if (node.op == token_type::arrow_right) {
            process_thread_first_expr(ts, node);
            break;
        }

        if (is_assignment_sugar_op(node.op)) {
            desugar_assignment(ts, node);
        }

        visit_children(ts, node);

        if (token_to_char(node.op) == '=') {
            resolve_assignment_type(ts, node);
        }
        else if (node.op == token_type::dotdot) {
            resolve_range_expr(ts, node);
        }
        else {
            if (is_logic_binary_op(node)) {
                ensure_bool_op_is_comparison(ts, node);
            }

            // TODO: check operators make sense for types
            node.type_error = (node.children[0]->type_error || node.children[1]->type_error);
            node.type_id = get_value_node_type(ts, node);
        }
        break;
    }
    case ast_type::unary_expr: {
        visit_children(ts, node);
        node.type_error = node.children[0]->type_error;

        if (token_to_char(node.op) == DEREF_OP) {
            // deref expression

            if (!(node.children[0]->type_id.valid() && is_pointer(node.children[0]->type_id))) {
                add_type_error(ts, node.children[0]->pos,
                    "right-side of unary '%c' (deref operation) has type '%s', it must be a pointer",
                    DEREF_OP, type_to_string(node.children[0]->type_id).c_str());
                node.type_error = true;
            }
            else {
                node.lvalue.self = &node;
                node.type_id = node.children[0]->type_id.get().elem_type;
                node.type_error = false;
            }
        }
        else if (token_to_char(node.op) == ADDR_OP) {
            // addressof expression

            if (!(node.children[0]->type_id.valid())) {
                node.type_error = true;
            }
            else if (!node.children[0]->lvalue.self) {
                add_type_error(ts, node.children[0]->pos,
                    "right-side of unary '%c' (addressof operation) must be an lvalue (identifier, index expression)",
                    ADDR_OP);
                node.type_error = true;
            }
            else {
                node.type_id = get_ptr_type_to(ts, node.children[0]->type_id);
                node.type_error = false;
            }
        }
        else if (token_to_char(node.op) == '!') {
            if (!node.children[0]->type_id.valid() || node.children[0]->type_error) {
                node.type_error = true;
            }
            else if (!is_convertible_to(ts, node.children[0]->type_id, ts.bool_type).first) {
                try_coerce_to(ts, *node.children[0], ts.bool_type);

                if (!is_convertible_to(ts, node.children[0]->type_id, ts.bool_type).first) {
                    add_type_error(ts, node.pos, "right side of unary '!' (negation) has type '%s', it must be a bool",
                        type_to_string(node.children[0]->type_id).c_str());
                    node.type_error = true;
                }

                node.type_id = ts.bool_type;
            }
            else {
                node.type_id = ts.bool_type;
            }

            ensure_bool_op_is_comparison_unary(ts, node);
        }
        else {
            node.type_id = node.children[0]->type_id;
            node.type_error = node.children[0]->type_error;
        }
        break;
    }
    case ast_type::init_expr: {
        for (auto& a : node.initlist.assignments) {
            visit_tree(ts, *a);
        }
        visit_children(ts, node);

        if (node.children[0] && !node.children[0]->type_id.valid()) {
            node.type_error = true;
        }
        else if (!node.children[0]) {
            // ok, but needs to deduce from receiver type
            node.initlist.deduce_to_tuple = true;
            if (node.initlist.deduce_to_tuple && !node.type_id.valid()) {
                std::vector<comptime_value> elem_types;
                bool all_resolved = true;
                for (auto& child : node.children[1]->children) {
                    resolve_node_type(ts, child.get());
                    if (!child->type_id.valid()) {
                        all_resolved = false;
                    }
                    else {
                        elem_types.push_back(child->type_id);
                    }
                }
                if (all_resolved) {
                    node.type_id = execute_builtin_type_constructor(ts, *ts.tuple_type_constructor, elem_types);
                }
            }
        }
        else {
            node.type_id = node.children[0]->type_id;
        }
        break;
    }
    case ast_type::ternary_expr: {
        visit_children(ts, node);
        if (!is_assignable_to(ts, node.if_cond()->type_id, ts.bool_type)) {
            add_type_error(ts, node.pos, "ternary expression condition must have 'bool' type");
            node.type_error = true;
            break;
        }

        if (!(node.if_body()->type_id.valid() && node.if_else()->type_id.valid())) {
            node.type_error = true;
            break;
        }

        try_coerce_to(ts, *node.if_else(), node.if_body()->type_id);
        try_coerce_to(ts, *node.if_body(), node.if_else()->type_id);
        auto [conv, ncast] = is_convertible_to(ts, node.if_else()->type_id, node.if_body()->type_id);
        if (!conv) {
            add_type_error(ts, node.pos, "non-compatible types in ternary expression branches: '%s' else '%s'",
                type_to_string(node.if_body()->type_id).c_str(), type_to_string(node.if_else()->type_id).c_str());
        }
        if (ncast) {
            node.children[2] = make_cast_to(ts, std::move(node.children[2]), node.if_body()->type_id);
        }

        node.type_id = node.if_body()->type_id;
        break;
    }
    case ast_type::cast_expr:
        visit_children(ts, node);
        node.type_id = get_value_node_type(ts, node);
        if (node.type_id.valid() && node.children[1]->type_id.valid()) {
            //node.children[1]->type_id = node.type_id;
        }
        break;
    case ast_type::nullcast_expr:
        visit_children(ts, *node.children[1]);
        break;
    case ast_type::string_literal:
        if (!node.type_id.valid()) {
            // Transform the string literal into a array of chars
            auto& sym = ts.builtin_scope->scope.symbols[string_hash{ "uint8" }];
            auto rstype = to_type_id(*sym);
            auto pure_rstype = get_pure_type_to(ts, rstype);
            auto pointer_type = get_ptr_type_to(ts, pure_rstype);

            auto slicetype = get_slice_type_to(ts, pure_rstype);
            auto slicetypenode = make_type_expr_node(*ts.ast_arena, node.pos, make_type_resolver_node(*ts.ast_arena, slicetype));

            std::vector<arena_ptr<ast_node>> nodes;
            nodes.push_back(make_string_literal_node(*ts.ast_arena, node.pos, std::string{ node.string_value }));
            nodes.push_back(make_int_literal_node(*ts.ast_arena, node.pos, node.string_value.size()));
            nodes[0]->type_id = pointer_type; // So the created string literal doesn't need to be transformed.

            auto arglist = make_arg_list_node(*ts.ast_arena, node.pos, std::move(nodes));
            auto initlist = make_init_expr_node(*ts.ast_arena, node.pos, std::move(slicetypenode), std::move(arglist));

            auto parent = node.parent;
            auto idx = find_child_index(parent, &node);
            if (idx) {
                parent->children[*idx] = std::move(initlist);
            }
        }
        break;
    case ast_type::bool_literal:
    case ast_type::int_literal:
    case ast_type::float_literal:
    case ast_type::char_literal:
    case ast_type::nullptr_:
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

// Section: final analysis

void remangle_names(type_system& ts, ast_node* nodeptr) {
    if (!nodeptr) return;

    auto& node = *nodeptr;
    switch (node.type) {
    case ast_type::for_stmt: {
        visit_tree(ts, *node.forinfo.declare_for_iter);
        visit_tree(ts, *node.forinfo.declare_elem_to_range_start);
        visit_tree(ts, *node.forinfo.compare_elem_to_range_end);
        visit_tree(ts, *node.forinfo.increase_elem);
        visit_tree(ts, *node.for_body());
        break;
    }
    case ast_type::func_decl: {
        if (node.func.is_generic) { break; }

        // remangle the function name with the fully qualified module name or alias
        if ((node.func.linkage == func_linkage::external_carbon || node.func.linkage == func_linkage::local_carbon)
            && !node.func.args_unresolved) {

            std::vector<std::string> parts;
            if (node.func.extern_alias.size() > 0) {
                parts = node.func.extern_alias;
            }
            else {
                parts = ts.current_scope->self_module_parts;
            }

            for (const auto& part : node.func_id()->id_parts) {
                parts.push_back(part);
            }

            node.type_def.mangled_name = mangle_func_name(ts, parts, node.func.comptime_args, node.func_args(), node.func.linkage);
        }

        if (node.scope.body_node) { enter_scope_local(ts, node); }
        visit_children(ts, node);
        if (node.scope.body_node) { leave_scope_local(ts); }
        break;
    }
    case ast_type::call_expr: {
        visit_pre_children(ts, node);
        visit_children(ts, node);

        // update the called function mangled name
        if (node.call.funcdef) {
            node.call.mangled_name = node.call.funcdef->self->type_def.mangled_name;
        }
        else if (node.call.func_type_id.get().kind != type_kind::func_pointer) {
            assert(!"call_expr no funcdef!");
        }
        break;
    }
    case ast_type::func_overload_selector_expr: {
        // update the called function mangled name
        if (node.call.funcdef) {
            node.call.mangled_name = node.call.funcdef->self->type_def.mangled_name;
        }
        else {
            assert(!"func_overload_selector_expr no funcdef!");
        }
        break;
    }
    case ast_type::init_expr: {
        for (auto& as : node.initlist.assignments) {
            visit_tree(ts, *as);
        }
        break;
    }
    case ast_type::code_unit: {
        for (auto& pair : node.scope.symbols) {
            if (pair.second->kind == symbol_kind::global) {
                auto local = get_symbol_local(*pair.second);
                local->mangled_name = mangle_global_name(ts, node.scope.self_module_parts, local->name);
            }
        }
        visit_pre_children(ts, node);
        visit_children(ts, node);
        break;
    }
    default: {
        visit_pre_children(ts, node);
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
        file << func_linkage_name(linkage) << " func " << build_identifier_value(node.children[0]->id_parts);
        file << "(";

        auto& arg_list = node.children[ast_node::child_func_decl_arg_list];
        int i = 0;
        for (const auto& child : arg_list->children) {
            if (child) {
                if (child->type == ast_type::var_decl) {
                    file << ":" << type_to_string(child->type_id);
                    if (i < arg_list->children.size() - 1) {
                        file << ", ";
                    }
                }
            }
            i++;
        }

        file << "):";

        type_id ret_type = node.type_def.func.ret_type;
        file << type_to_string(ret_type);

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

void create_header_file(type_system& ts, ast_node& unit) {
    auto path = "_carbon/headers/" + std::string{ unit.string_value };
    replace(path, ".cb", ".cbh");
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
    auto ptr = &node;
    if (!ptr) return;
    if (ptr->disabled) return;

    switch (ts.pass) {
    case type_system_pass::create_header_files:
        create_header_file(ts, node);
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
    case type_system_pass::desugar:
        desugar(ts, &node);
        break;
    case type_system_pass::remangle_names:
        remangle_names(ts, &node);
        break;
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
    usize_type = register_integral_type<std::size_t>(*this, "usize");
    isize_type = register_integral_type<std::int64_t>(*this, "isize");
    bool_type = register_integral_type<bool>(*this, "bool");

    int8_type = register_integral_type<std::int8_t>(*this, "int8");
    register_integral_type<std::int16_t>(*this, "int16");
    register_integral_type<std::int32_t>(*this, "int32");
    register_integral_type<std::int64_t>(*this, "int64");

    register_real_type<float>(*this, "float32");
    register_real_type<double>(*this, "float64");

    register_alias_to_type_name(*this, "char", "int8");
    register_alias_to_type_name(*this, "uint", "uint32");
    register_alias_to_type_name(*this, "int", "int32");
    register_alias_to_type_name(*this, "float", "float32");

    {
        auto node = make_in_arena<ast_node>(*ast_arena);
        node->type_def.name = string_hash{ "&" };
        node->type_def.mangled_name = string_hash{ "ptr" };
        node->type_def.kind = type_kind::constructor;

        type_constructor* ptr_template = &node->type_def.constructor;
        ptr_template->self = node.get();
        ptr_template->func = [this](const std::vector<comptime_value>& arg) {
            auto type_arg = std::get<type_id>(arg.front());
            auto node = make_in_arena<ast_node>(*ast_arena);
            type_def& tf = node->type_def;

            tf.kind = type_kind::ptr;
            tf.name = string_hash{ "&" + type_arg.get().name.str };
            tf.mangled_name = string_hash{ "ptr__T" + type_arg.get().mangled_name.str };
            tf.size = sizeof(void*);
            tf.alignment = alignof(void*);
            tf.elem_type = type_arg;
            return node;
        };

        ptr_type_constructor = ptr_template;
        register_type(*this, builtin_scope->scope, *node);
        builtin_type_nodes.push_back(std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);
        node->type_def.name = string_hash{ "*" };
        node->type_def.mangled_name = string_hash{ "nullableptr" };
        node->type_def.kind = type_kind::constructor;

        type_constructor* ptr_template = &node->type_def.constructor;
        ptr_template->self = node.get();
        ptr_template->func = [this](const std::vector<comptime_value>& arg) {
            auto type_arg = std::get<type_id>(arg.front());
            auto node = make_in_arena<ast_node>(*ast_arena);
            type_def& tf = node->type_def;

            tf.kind = type_kind::nullableptr;
            tf.name = string_hash{ "*" + type_arg.get().name.str };
            tf.mangled_name = string_hash{ "nullableptr__T" + type_arg.get().mangled_name.str };
            tf.size = sizeof(void*);
            tf.alignment = alignof(void*);
            tf.elem_type = type_arg;
            return node;
        };

        nullableptr_type_constructor = ptr_template;
        register_type(*this, builtin_scope->scope, *node);
        builtin_type_nodes.push_back(std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);
        node->type_def.name = string_hash{ "pure" };
        node->type_def.mangled_name = string_hash{ "pure" };
        node->type_def.kind = type_kind::constructor;

        type_constructor* ptr_template = &node->type_def.constructor;
        ptr_template->self = node.get();
        ptr_template->func = [this](const std::vector<comptime_value>& arg) {
            auto type_arg = std::get<type_id>(arg.front());
            auto node = make_in_arena<ast_node>(*ast_arena);
            type_def& tf = node->type_def;

            tf.kind = type_arg.get().kind;
            tf.name = string_hash{ "pure " + type_arg.get().name.str };
            tf.mangled_name = string_hash{ "pure__T" + type_arg.get().mangled_name.str };
            tf.size = type_arg.get().size;
            tf.alignment = type_arg.get().alignment;
            tf.elem_type = type_arg;
            tf.flags |= type_flags::is_pure;
            tf.structure = type_arg.get().structure;
            return node;
        };

        pure_type_constructor = ptr_template;
        register_type(*this, builtin_scope->scope, *node);
        builtin_type_nodes.push_back(std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);
        node->type_def.name = string_hash{ "tuple" };
        node->type_def.mangled_name = string_hash{ "tuple" };
        node->type_def.kind = type_kind::constructor;

        type_constructor* tuple_template = &node->type_def.constructor;
        tuple_template->self = node.get();

        tuple_template->func = [this, ctor = node.get()](const std::vector<comptime_value>& args) {
            auto node = make_in_arena<ast_node>(*ast_arena);
            type_def& tf = node->type_def;

            tf.kind = type_kind::tuple;
            tf.name = build_tuple_name(args);
            tf.mangled_name = build_type_constructor_mangled_name(ctor->type_def.mangled_name.str, args);

            std::vector<std::string> tuple_field_names = {
                "first", "second", "third", "fourth", "fifth",
                "sixth", "seventh", "eighth", "ninth", "tenth"
            };
            int i = 0;
            for (const auto& arg : args) {
                const auto& type_arg = std::get<type_id>(arg);
                std::string tfname = "";
                if (i < tuple_field_names.size()) {
                    tfname = tuple_field_names[i];
                }
                tf.structure.fields.push_back({ { tfname }, type_arg, 0 });
                i++;
            }
            if (i > 0) {
                tf.structure.fields[i - 1].names.push_back("last");
                compute_struct_size_alignment_offsets(tf);
            }
            else {
                tf.kind = type_kind::void_;
                tf.mangled_name = string_hash{ "void" };
            }
            
            return node;
        };

        tuple_type_constructor = tuple_template;
        register_type(*this, builtin_scope->scope, *node);
        builtin_type_nodes.push_back(std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);
        node->type_def.name = string_hash{ "array" };
        node->type_def.mangled_name = string_hash{ "array" };
        node->type_def.kind = type_kind::constructor;

        type_constructor* arr_template = &node->type_def.constructor;
        arr_template->self = node.get();

        arr_template->func = [this, ctor = node.get()](const std::vector<comptime_value>& args) {
            auto node = make_in_arena<ast_node>(*ast_arena);
            type_def& tf = node->type_def;

            tf.kind = type_kind::array;
            tf.name = build_array_name(std::get<int_type>(args[0]), std::get<type_id>(args[1]));
            tf.mangled_name = build_type_constructor_mangled_name(ctor->type_def.mangled_name.str, args);
            tf.array.length = std::get<int_type>(args[0]);
            tf.elem_type = std::get<type_id>(args[1]);
            tf.size = tf.array.length * tf.elem_type.get().size;
            tf.alignment = tf.elem_type.get().alignment;

            for (int_type i = 0; i < tf.array.length; i++) {
                tf.structure.fields.push_back({ {""}, tf.elem_type, 0 });
            }

            return node;
        };

        arr_type_constructor = arr_template;
        register_type(*this, builtin_scope->scope, *node);
        builtin_type_nodes.push_back(std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);
        node->type_def.name = string_hash{ "slice" };
        node->type_def.mangled_name = string_hash{ "slice" };
        node->type_def.kind = type_kind::constructor;

        type_constructor* slice_template = &node->type_def.constructor;
        slice_template->self = node.get();

        slice_template->func = [this, ctor = node.get()](const std::vector<comptime_value>& args) {
            auto node = make_in_arena<ast_node>(*ast_arena);
            type_def& tf = node->type_def;

            tf.kind = type_kind::slice;
            tf.name = string_hash{ "[]" + std::get<type_id>(args[0]).get().name.str };
            tf.mangled_name = build_type_constructor_mangled_name(ctor->type_def.mangled_name.str, args);
            tf.elem_type = std::get<type_id>(args[0]);

            auto ptype = get_ptr_type_to(*this, tf.elem_type);
            tf.structure.fields.push_back({ { "ptr" }, ptype, 0 });
            tf.structure.fields.push_back({ { "len" }, this->usize_type, 0 });

            compute_struct_size_alignment_offsets(tf);

            return node;
        };

        slice_type_constructor = slice_template;
        register_type(*this, builtin_scope->scope, *node);
        builtin_type_nodes.push_back(std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);
        node->type_def.name = string_hash{ "funcptr" };
        node->type_def.mangled_name = string_hash{ "funcptr" };
        node->type_def.kind = type_kind::constructor;

        type_constructor* func_pointer_template = &node->type_def.constructor;
        func_pointer_template->self = node.get();

        func_pointer_template->func = [this, ctor = node.get()](const std::vector<comptime_value>& args) {
            auto node = make_in_arena<ast_node>(*ast_arena);
            type_def& tf = node->type_def;

            std::vector<type_id> arg_types;
            std::transform(args.begin(), args.begin() + args.size() - 1, std::back_inserter(arg_types), [](auto&& arg) {
                return std::get<type_id>(arg);
            });

            auto ret_type = std::get<type_id>(args.back());

            tf.kind = type_kind::func_pointer;
            tf.size = sizeof(void*);
            tf.alignment = sizeof(void*);
            tf.name = build_func_pointer_name(arg_types, ret_type);
            tf.mangled_name = build_type_constructor_mangled_name(ctor->type_def.mangled_name.str, args);
            tf.func.arg_types = arg_types;
            tf.func.ret_type = ret_type;

            return node;
        };

        func_pointer_type_constructor = func_pointer_template;
        register_type(*this, builtin_scope->scope, *node);
        builtin_type_nodes.push_back(std::move(node));
    }

    // void and void*
    {
        void_type = execute_builtin_type_constructor(*this, *tuple_type_constructor, {});
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);

        type_def& tf = node->type_def;
        tf.kind = type_kind::nullableptr;
        tf.name = string_hash{ "rawptr" };
        tf.mangled_name = string_hash{ "rawptr" };
        tf.size = sizeof(void*);
        tf.alignment = alignof(void*);
        tf.elem_type = void_type;
        raw_ptr_type = register_builtin_type(*this, std::move(node));
    }

    raw_string_type = register_pointer_type(*this, "$rawstring", "uint8");
}

void type_system::process_code_unit(ast_node& node) {
    this->pass = type_system_pass::resolve_literals_and_register_declarations;
    this->code_units.push_back(&node);

    for (int i = 0; i < 2; i++) {
        this->subpass = i;
        parent_tree(node);

        if (i == 0) {
            add_scope(*this, node, scope_kind::code_unit);
        }
        else {
            enter_scope_local(*this, node);
        }

        node.scope.body_node = &node;
        visit_tree(*this, node);
        leave_scope();
    }
}

void type_system::resolve_and_check() {
    this->pass = type_system_pass::resolve_imports;
    this->subpass = 0;
    for (auto unit : this->code_units) {
        enter_scope(*unit);
        visit_tree(*this, *unit);
        leave_scope();
    }

    if (!current_error.msg.empty()) {
        errors.push_back(current_error);
        current_error = {};
    }
    if (!errors.empty()) {
        // TODO: continue even if with module errors for further type checking?
        return;
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

    if (!current_error.msg.empty()) {
        errors.push_back(current_error);
        current_error = {};
    }

    this->pass = type_system_pass::create_header_files;
    this->subpass = 0;
    for (auto unit : this->code_units) {
        enter_scope(*unit);
        visit_tree(*this, *unit);
        leave_scope();
    }

    if (errors.empty()) {
#if 1
        in_desugar = true;
        for (int i = 0; i < 3; i++) {
            this->pass = type_system_pass::desugar;
            this->subpass = i;
            for (auto unit : this->code_units) {
                parent_tree(*unit);
                enter_scope(*unit);
                visit_tree(*this, *unit);
                leave_scope();
            }
        }
        in_desugar = false;

        for (int i = 0; i < 2; i++) {
            this->pass = type_system_pass::remangle_names;
            this->subpass = i;
            for (auto unit : this->code_units) {
                enter_scope(*unit);
                visit_tree(*this, *unit);
                leave_scope();
            }
        }
#endif
    }

    if (!current_error.msg.empty()) {
        errors.push_back(current_error);
    }

    for (auto unit : this->code_units) {
        ensure_directory_exists("_carbon/build_debug/" + basename(std::string{ unit->string_value }) + ".ast");
        std::ofstream ast_file{ "_carbon/build_debug/" + basename(std::string{unit->string_value}) + ".ast" };
        prettyprint(*unit, ast_file);
        ast_file << "\n";
    }

    //exit(EXIT_FAILURE);
}

void type_system::enter_scope(ast_node& node) {
    enter_scope_local(*this, node);
}

void type_system::leave_scope() {
    leave_scope_local(*this);
}

void type_system::create_temp_variable_for_binary_expr(ast_node& node) {
    /*
    std::string tempname = "$cbT" + std::to_string(temp_count++);
    auto id_node = make_identifier_node(*ast_arena, {}, { tempname });

    node.local.self = &node;

    resolve_and_declare_local_variable(*this, { node.var_id()->id_parts.front() }, node);
    node.temps.push_back(std::move(id_node));
    */
}

void type_system::create_temp_variable_for_index_expr(ast_node& node) {
    auto [temp, ref] = make_temp_variable_for_index_expr_resolved(*this, std::move(node.children[0]));
    node.children[0] = std::move(ref);
    node.pre_children.push_back(std::move(temp));
}

void type_system::create_temp_variable_for_call_arg(ast_node& call, ast_node& arg, int idx) {
    auto [temp, ref] = make_temp_variable_for_call_resolved(*this, arg);
    call.children[ast_node::child_call_expr_arg_list]->children[idx] = std::move(ref);
    call.pre_children.push_back(std::move(temp));
}

scope_def* type_system::find_nearest_scope(scope_kind kind) {
    return find_nearest_scope_local(*this, kind);
}

type_def& type_id::get() const { return *scope->type_defs[type_index]; }

bool type_id::valid() const { return scope != nullptr && type_index != -1; }

bool is_pointer_type(type_id tid) {
    return is_pointer(tid);
}

bool is_aggregate_type(type_id tid) {
    return is_aggregate(tid);
}

}