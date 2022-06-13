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
#include <numeric>
#include <fstream>
#include <iostream>

namespace carbon {

static const type_id invalid_type{};

type_id get_type_expr_node_type(type_system& ts, ast_node& node);

bool is_castable_to(type_system& ts, type_id a, type_id b);

std::string node_to_string(const ast_node& node);

std::string type_to_string(type_id t);

std::vector<struct_field>& get_type_fields(type_id id);

bool is_aggregate(type_id id);

void type_check_field_expr(type_system& ts, ast_node& node, bool change_to_identifier);

std::vector<arena_ptr<ast_node>>* get_compound_block_params(ast_node& compound);

// Section: errors

template <typename... Args> void add_module_error(type_system& ts, const position& pos, const char* fmt, Args&&... args) {
    if (!ts.current_error.msg.empty()) {
        ts.errors.push_back(ts.current_error);
    }

    static char wholeb[1024*2];
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

        static char wholeb[1024*2];
        static char msgb[1024];
        snprintf(msgb, sizeof(msgb), fmt, std::forward<Args>(args)...);

        const char* filename = pos.filename.c_str();
        snprintf(wholeb, sizeof(wholeb), "[%s:%d:%d] ERROR: %s\n", filename, pos.line_number, pos.col_offs, msgb);
        ts.current_error = { pos, error_hash, std::string{filename}, std::string{wholeb} };
    }
}

template <typename... Args> void add_type_error(type_system& ts, const position& pos, const char* fmt, Args&&... args) {
    unk_type_error(ts, invalid_type, pos, fmt, std::forward<Args>(args)...);
}

template <typename... Args> void complement_error(type_system& ts, const position& pos, const char* fmt, Args&&... args) {
    if (!ts.current_error.msg.empty() && ts.pass == type_system_pass::perform_checks) {
        static char wholeb[1024 * 2];
        static char msgb[1024];
        snprintf(msgb, sizeof(msgb), fmt, std::forward<Args>(args)...);

        const char* filename = pos.filename.c_str();
        snprintf(wholeb, sizeof(wholeb), "[%s:%d:%d] NOTE: %s\n", filename, pos.line_number, pos.col_offs, msgb);
        ts.current_error.msg.append(wholeb);
    }
}

// Section: helpers

scope_def& curscope(type_system& ts) {
    return *ts.current_scope;
}

type_id register_type(type_system& ts, scope_def& scope, ast_node& node) {
    type_def* t = &node.tdef;
    t->self = &node;
    type_id id = { &scope, (int)(scope.tdefs.size()) };
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

    type_def& def = node->tdef;
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

template <typename T> type_id register_integral_like_type(type_system& ts, const char* name, type_kind kind) {
    auto node = make_in_arena<ast_node>(*ts.ast_arena);

    type_def& def = node->tdef;
    def.kind = kind;
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

    type_def& def = node->tdef;
    def.kind = type_kind::real;
    def.name = string_hash{ name };
    def.mangled_name = string_hash{ name };
    def.alignment = alignof(T);
    def.size = sizeof(T);
    def.is_signed = std::is_signed_v<T>;
    return register_builtin_type(ts, std::move(node));
}

type_def& get_type(type_system& ts, type_id id) {
    return *id.scope->tdefs[id.type_index];
}

type_id register_alias_to_type_name(type_system& ts, const std::string& name, const std::string& toname) {
    auto it = curscope(ts).symbols.find(string_hash{ toname });
    if (it == curscope(ts).symbols.end()) {
        return invalid_type;
    }

    auto tid = type_id{ it->second->scope, it->second->type_index };

    auto node = make_in_arena<ast_node>(*ts.ast_arena);
    type_def* defcopy = &node->tdef;

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

type_id get_unsigned_type(type_system& ts, type_id tid) {
    if (tid == ts.int8_type) {
        return ts.uint8_type;
    }
    else if (tid == ts.int16_type) {
        return ts.uint16_type;
    }
    else if (tid == ts.int32_type) {
        return ts.uint32_type;
    }
    else if (tid == ts.int64_type) {
        return ts.uint64_type;
    }
    return {};
}

type_id get_pure_root(type_system& ts, type_id tid) {
    if (!tid.valid()) {
        return tid;
    }
    if (tid.get().flags & type_flags::is_pure) {
        return get_pure_root(ts, tid.get().elem_type);
    }
    return tid;
}

type_id get_alias_root(type_system& ts, type_id tid) {
    if (!tid.valid()) {
        return tid;
    }
    if (tid.get().alias_to.valid()) {
        return get_alias_root(ts, tid.get().alias_to);
    }
    return tid;
}

type_id get_pure_alias_root(type_system& ts, type_id tid) {
    if (!tid.valid()) {
        return tid;
    }
    if (tid.get().alias_to.valid()) {
        return get_pure_alias_root(ts, tid.get().alias_to);
    }
    if (tid.get().flags & type_flags::is_pure) {
        return get_pure_alias_root(ts, tid.get().elem_type);
    }
    return tid;
}

bool is_arith_type(type_id tid) {
    return tid.get().kind == type_kind::integral || tid.get().kind == type_kind::real || tid.get().kind == type_kind::enumflags;
}

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
    for (const auto& t : scope.tdefs) {
        if (compare_types_exact(*t, tdef)) {
            return t->id;
        }
    }
    return invalid_type;
}

type_id execute_type_constructor(type_system& ts, scope_def& scope, type_constructor& tpl, const std::vector<const_value>& args) {
    auto result = tpl.func(args);

    auto tid = find_type_by_value(ts, scope, result->tdef);
    if (!tid.valid()) {
        result->tdef.constructor_type = tpl.self->tdef.id;
        tid = register_type(ts, scope, *result);
        scope.body_node->temps.push_back(std::move(result));
    }
    return tid;
}

type_id execute_builtin_type_constructor(type_system& ts, type_constructor& tpl, const std::vector<const_value>& args) {
    return execute_type_constructor(ts, ts.builtin_scope->scope, tpl, args);
}

string_hash build_static_array_name(comp_int_type size, type_id t) {
    std::string result = "array[";
    result.append(std::to_string(size));
    result.append("] of ");
    result.append(t.get().name.str);
    return { result };
}

string_hash build_func_pointer_name(const std::vector<type_id>& arg_types, type_id ret_type) {
    std::string result = "fun (";
    int i = 0;
    for (const auto& arg : arg_types) {
        result.append("");
        result.append(arg.get().name.str);
        if (i < arg_types.size() - 1)
            result.append(", ");
        i++;
    }
    result.append(") => ");
    result.append(type_to_string(ret_type));
    return { result };
}

string_hash build_type_constructor_name(const std::string& name, const std::vector<const_value>& args) {
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

string_hash build_type_constructor_mangled_name(const std::string& mangled_name, const std::vector<const_value>& args) {
    auto result = mangled_name;
    for (const auto& arg : args) {
        if (auto tt = std::get_if<type_id>(&arg); tt) {
            result.append("__T");
            result.append(tt->get().mangled_name.str);
        }
        else if (auto tt = std::get_if<comp_int_type>(&arg); tt) {
            result.append("__I");
            result.append(std::to_string(*tt));
        }
    }
    return { result };
}

std::pair<const_value, bool> node_to_const_value(type_system& ts, ast_node& node, bool emit_error = true) {
    const_value arg = {};
    switch (node.type) {
    case ast_type::type_expr: {
        resolve_node_type(ts, &node);
        if (node.tid.valid()) {
            arg = node.tid;
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
    case ast_type::const_expr: {
        type_id tid{};
        if (node.children[0]->type == ast_type::type_expr) {
            tid = get_type_expr_node_type(ts, *node.children[0]->children[0]);
        }

        if (tid.valid()) {
            node.tid = ts.type_type;
            node.type_error = false;
            arg = tid;
        }
        else if (emit_error) {
            add_type_error(ts, node.pos, "invalid const expression");
        }
        break;
    }
    case ast_type::identifier: {
        auto pair = separate_module_identifier(node.id_parts);
        auto sym = find_symbol(ts, pair);
        if (sym) {
            if (sym->kind == symbol_kind::const_value) {
                node.tid = sym->cttype;
                arg = sym->ctvalue;
            }
            else if (sym->kind == symbol_kind::type) {
                node.tid = ts.type_type;
                arg = sym->scope->tdefs[sym->type_index]->id;
            }
        }
        break;
    }
    case ast_type::rest_expr: {
        arg = ellipsis_value{};
        node.tid = ts.opaque_type;
        break;
    }
    default: {
        if (emit_error) add_type_error(ts, node.pos, "invalid const expression: '%s'", node_to_string(node).c_str());
        break;
    }
    }
    return std::make_pair(arg, node.tid.valid());
}

std::pair<const_value, bool> node_to_const_value_fold(type_system& ts, ast_node& node, bool emit_error = true) {
    const_value arg = {};
    switch (node.type) {
    case ast_type::cast_expr: {
        auto [avalue, aok] = node_to_const_value_fold(ts, *node.children[1], emit_error);
        if (aok && std::holds_alternative<comp_int_type>(avalue)) {
            arg = avalue;
        }
        break;
    }
    case ast_type::unary_expr: {
        auto [value, ok] = node_to_const_value_fold(ts, *node.children[0], emit_error);
        if (ok) {
            if (std::holds_alternative<comp_int_type>(value)) {
                switch (node.op) {
                case token_from_char('-'):
                    arg = (comp_int_type)(-std::get<comp_int_type>(value));
                    break;
                case token_from_char('~'):
                    arg = (comp_int_type)(~std::get<comp_int_type>(value));
                    break;
                }
            }
        }
        break;
    }
    case ast_type::binary_expr: {
        auto [avalue, aok] = node_to_const_value_fold(ts, *node.children[0], emit_error);
        auto [bvalue, bok] = node_to_const_value_fold(ts, *node.children[1], emit_error);
        if (aok && bok && std::holds_alternative<comp_int_type>(avalue) && std::holds_alternative<comp_int_type>(bvalue)) {
            comp_int_type a = std::get<comp_int_type>(avalue);
            comp_int_type b = std::get<comp_int_type>(bvalue);
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
            case token_from_char('>'):
                arg = a > b;
                break;
            case token_from_char('<'):
                arg = a < b;
                break;
            case token_type::gteq:
                arg = a >= b;
                break;
            case token_type::lteq:
                arg = a <= b;
                break;
            case token_from_char('='):
                arg = a == b;
                break;
            }
        }
        break;
    }
    default:
        return node_to_const_value(ts, node, emit_error);
    }
    return std::make_pair(arg, true);
}

std::pair<std::vector<const_value>, bool> nodes_to_const_values(type_system& ts, std::vector<arena_ptr<ast_node>>& nodes) {
    std::vector<const_value> args;
    bool all_resolved = true;

    for (auto& node : nodes) {
        auto [arg, resolved] = node_to_const_value(ts, *node);
        if (!resolved) {
            all_resolved = false;
        }
        args.push_back(arg);
    }
    return std::make_pair(args, all_resolved);
}

type_id get_inout_type_to(type_system& ts, type_id elem_type) {
    return execute_type_constructor(ts, ts.builtin_scope->scope, *ts.inout_type_constructor, { elem_type });
}

type_id get_in_type_to(type_system& ts, type_id elem_type) {
    return execute_type_constructor(ts, ts.builtin_scope->scope, *ts.in_type_constructor, { elem_type });
}

type_id get_out_type_to(type_system& ts, type_id elem_type) {
    return execute_type_constructor(ts, ts.builtin_scope->scope, *ts.out_type_constructor, { elem_type });
}

type_id get_pure_type_to(type_system& ts, type_id elem_type) {
    if (elem_type.valid() && (elem_type.get().flags & type_flags::is_pure)) {
        return elem_type;
    }
    return execute_type_constructor(ts, ts.builtin_scope->scope, *ts.pure_type_constructor, { elem_type });
}

type_id get_ptr_type_to(type_system& ts, type_id elem_type) {
    return execute_type_constructor(ts, ts.builtin_scope->scope, *ts.ptr_type_constructor, { elem_type });
}

#if 0
type_id get_arrayview_type_to(type_system& ts, type_id elem_type) {
    return execute_type_constructor(ts, ts.builtin_scope->scope, *ts.array_view_type_constructor, { elem_type });
}
#endif

type_id get_static_array_type(type_system& ts, comp_int_type size, type_id elem_type) {
    return execute_type_constructor(ts, ts.builtin_scope->scope, *ts.static_array_type_constructor, { size, elem_type });
}

type_id get_array_type_to(type_system& ts, type_id elem_type) {
    return execute_type_constructor(ts, ts.builtin_scope->scope, *ts.array_type_constructor, { elem_type });
}

type_id get_func_pointer_type_to(type_system& ts, type_id func_type) {
    std::vector<const_value> args;
    for (auto& arg_type : func_type.get().func.arg_types) {
        args.push_back(arg_type);
    }
    args.push_back(func_type.get().func.ret_type);
    return execute_type_constructor(ts, ts.builtin_scope->scope, *ts.func_pointer_type_constructor, args);
}

// is A assignable to B?
bool is_assignable_to(type_system& ts, type_id a, type_id b) {
    if (a == invalid_type || b == invalid_type) return false;

    if (a == b) {
        return true;
    }

    // ta = from
    // tb = target

    auto& tsrc = get_type(ts, a);
    auto& ttarget = get_type(ts, b);

    if (tsrc.alias_to == b || ttarget.alias_to == a) {
        return true;
    }

    if ((ttarget.flags & type_flags::is_pure) && ttarget.elem_type == tsrc.id) {
        return true;
    }

    if ((tsrc.flags & type_flags::is_pure) && is_assignable_to(ts, tsrc.elem_type, ttarget.id)) {
        if (!is_aggregate_type(ttarget.elem_type)) {
            return true;
        }
    }

    if (tsrc.kind == type_kind::nil && ttarget.kind == type_kind::error) {
        return true;
    }

    if (tsrc.kind == type_kind::nil && ttarget.kind == type_kind::enumflags) {
        return true;
    }

    if (tsrc.kind == type_kind::nil && is_aggregate(ttarget.id)) {
        return true;
    }

    if (tsrc.kind == type_kind::ptr && ttarget.kind == type_kind::ptr) {
        if (get_alias_root(ts, ttarget.id) == ts.opaque_ptr_type) {
            return true;
        }

        return is_assignable_to(ts, tsrc.elem_type, ttarget.elem_type);
    }

    // NIL = PTR
    if (tsrc.kind == type_kind::ptr && ttarget.kind == type_kind::nil) {
        return true;
    }

    // PTR = NIL
    if (tsrc.kind == type_kind::nil && ttarget.kind == type_kind::ptr) {
        return true;
    }

    if (tsrc.kind == type_kind::array && ttarget.kind == type_kind::array) {
        return is_assignable_to(ts, tsrc.elem_type, ttarget.elem_type);
    }

    if (tsrc.kind == type_kind::array_view && ttarget.kind == type_kind::array_view) {
        return is_assignable_to(ts, tsrc.elem_type, ttarget.elem_type);
    }

    if (tsrc.kind == type_kind::func_pointer && ttarget.kind == type_kind::func_pointer) {
        // TODO
        return true;
    }

    if ((ttarget.flags & (type_flags::is_in | type_flags::is_out)) && (tsrc.flags & (type_flags::is_in | type_flags::is_out))) {
        if (tsrc.flags & type_flags::is_out) {
            // Src is output

            return is_assignable_to(ts, tsrc.elem_type, ttarget.elem_type);
        }
        else if (tsrc.flags & type_flags::is_in) {
            // Src is only input, assign to Target only if Target is only input

            if (ttarget.kind == type_kind::input) {
                return is_assignable_to(ts, tsrc.elem_type, ttarget.elem_type);
            }
        }
    }

    return false;
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
    if (!from.tid.valid()) return;
    if (!to.valid()) return;

    auto& ta = get_type(ts, from.tid);
    auto& tb = get_type(ts, to);

    bool can_coerce = false;

    if (ta.kind == tb.kind && tb.kind == type_kind::integral) {
        if (tb.size < ta.size) {
            if (from.type == ast_type::int_literal && from.int_value < tb.numeric.max) {
                can_coerce = true;
            }
        }
        else {
            if (from.type == ast_type::int_literal) {
                can_coerce = true;
            }
        }
    }
    else if (ta.kind == type_kind::integral && tb.kind == type_kind::ptr) {
        if (from.type == ast_type::int_literal) {
            can_coerce = true;
        }
    }
    else if (ta.kind == type_kind::error && tb.kind == type_kind::nil) {
        can_coerce = true;
    }
    else if (ta.kind == type_kind::enumflags && tb.kind == type_kind::nil) {
        can_coerce = true;
    }

    if (can_coerce) {
        from.tid = to;
    }
}

std::vector<struct_field>& get_type_fields(type_id id) {
    if (id.get().flags & (type_flags::is_in | type_flags::is_out)) {
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
    else if (id.get().kind == type_kind::ptr)  {
        return make_nil_node(*ts.ast_arena, {});
    }
    else if (id.get().kind == type_kind::enum_) {
        symbol_info* sym = id.get().enumtype.symbols.front();
        return make_identifier_node(*ts.ast_arena, {}, { id.get().name.str, sym->id.str });
    }
    else if (id.get().kind == type_kind::error) {
        return make_nil_node(*ts.ast_arena, {});
    }
    else if (is_aggregate(id)) {
        return make_nil_node(*ts.ast_arena, {});
    }
    return { nullptr, nullptr };
}

bool is_pointer(type_id id) {
    if (!id.valid()) return false;

    return (id.get().kind == type_kind::ptr) || (id.get().kind == type_kind::input) || (id.get().kind == type_kind::output) || (id.get().kind == type_kind::inout);
}

bool is_aggregate(type_id id) {
    if (!id.valid()) return false;

    return id.get().kind == type_kind::structure ||
           id.get().kind == type_kind::c_structure ||
           id.get().kind == type_kind::static_array ||
           id.get().kind == type_kind::array ||
           id.get().kind == type_kind::array_view;
}

bool is_aggregate_root(type_id id) {
    if (!id.valid()) return false;
    // if (id.get().flags) return false;

    return id.get().kind == type_kind::structure ||
        id.get().kind == type_kind::c_structure ||
        id.get().kind == type_kind::static_array ||
        id.get().kind == type_kind::array ||
        id.get().kind == type_kind::array_view;
}

bool is_type_kind(type_id id, type_kind k) {
    return id.get().kind == k;
}

bool type_allows_no_init(type_system& ts, type_id id) {
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

                if (is_type_kind(id, type_kind::structure) || is_type_kind(id, type_kind::c_structure)) {
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
        f.offset = offs > 0 ? align(offs, ftype.alignment) : 0;
        offs += ftype.size;
        offs = align(offs, ftype.alignment);
        max_align = std::max(ftype.alignment, max_align);
    }

    td.size = align(offs, max_align);

    if (td.kind != type_kind::c_structure && td.size > 8) {
        td.size = align(offs, (size_t)16);
        td.alignment = 16;
    }
    else {
        td.alignment = max_align;
    }
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

arena_ptr<ast_node> make_assignment_for_init_list_item(type_system& ts, ast_node& node, ast_node& receiver, arena_ptr<ast_node>&& value, const struct_field& field, int idx) {
    if (is_type_kind(node.tid, type_kind::structure) || is_type_kind(node.tid, type_kind::c_structure) || is_type_kind(node.tid, type_kind::array_view)) {
        auto fieldexpr = make_struct_field_access(*ts.ast_arena, copy_node(ts, &receiver), field.names[0]);
        return make_assignment(*ts.ast_arena, std::move(fieldexpr), std::move(value));
    }
    else if (is_type_kind(node.tid, type_kind::tuple) || is_type_kind(node.tid, type_kind::static_array)) {
        auto indexexpr = make_index_access(*ts.ast_arena, copy_node(ts, &receiver), idx);
        return make_assignment(*ts.ast_arena, std::move(indexexpr), std::move(value));
    }
    return {nullptr, nullptr};
}

void generate_assignments_for_init_list(type_system& ts, ast_node& node, ast_node& receiver) {
    auto& args = node.children[1]->children;
    auto& fields = get_type_fields(node.tid);
    if (args.size() > fields.size()) {
        // TODO: handle different number of arguments vs fields
        node.type_error = true;
        add_type_error(ts, node.pos, "number of initialization arguments is greater than number of fields in type '%s'",
            type_to_string(node.tid).c_str());
        return;
    }
    node.initlist.receiver = &receiver;
}

void deduce_init_list_type(type_system& ts, ast_node& node, type_id receiver_type) {
    if (node.type == ast_type::init_expr) {
        node.tid = receiver_type;
    }
}

void transform_slice_expr_to_init_expr(type_system& ts, ast_node& node, bool mut) {
    node.type = ast_type::init_expr;
    
    type_id elem_type = node.children[0]->tid.get().elem_type;
    auto arr = std::move(node.children[0]);
    auto idxpair = std::move(node.children[1]);
    auto offscopy = copy_node(ts, idxpair->children[0]->children[0].get());

    auto addrexpr = make_address_of_expr(ts,
        make_index_expr_node(*ts.ast_arena, arr->pos, std::move(arr), std::move(idxpair->children[0]->children[0]))
    );
    auto szexpr = make_binary_expr_node(*ts.ast_arena, idxpair->pos, token_from_char('-'),
        std::move(idxpair->children[0]->children[1]), std::move(offscopy)
    );
    resolve_node_type(ts, addrexpr.get());
    resolve_node_type(ts, szexpr.get());

    std::vector<arena_ptr<ast_node>> args;
    args.push_back(std::move(addrexpr));
    args.push_back(std::move(szexpr));
    auto arglist = make_arg_list_node(*ts.ast_arena, node.pos, std::move(args));
    node.children[1] = std::move(arglist);

    node.tid = get_array_type_to(ts, elem_type);
    node.children[0] = make_type_resolver_node(*ts.ast_arena, node.tid);
    node.slice.self = &node;
}

// Section: cast checking

using cast_check_func = std::function<bool(type_system&, type_def&, type_def&)>;

bool can_pointer_be_cast_from(type_system& ts, type_def& self, type_def& from) {
    if (get_pure_alias_root(ts, self.id) == ts.opaque_ptr_type) {
        if (from.kind == type_kind::ptr) {
            return true;
        }
        if (from.kind == type_kind::integral && (get_pure_alias_root(ts, from.id) == ts.uintptr_type)) {
            return true;
        }
    }

    if (get_pure_alias_root(ts, from.id) == ts.opaque_ptr_type) {
        return true;
    }

    if (from.kind == type_kind::ptr) {
        return is_castable_to(ts, from.elem_type, self.elem_type);
    }
    return false;
}

bool can_integral_be_cast_from(type_system& ts, type_def& self, type_def& from) {
    if (get_pure_alias_root(ts, self.id) == ts.uintptr_type) {
        if (from.kind == type_kind::ptr) {
            return true;
        }
        if (from.kind == type_kind::integral) {
            return true;
        }
        return false;
    }

    if (from.kind == type_kind::integral || from.kind == type_kind::real) {
        return true;
    }

    if (from.kind == type_kind::enum_ || from.kind == type_kind::enumflags || from.kind == type_kind::error) {
        return true;
    }

    return false;
}

bool can_enum_be_cast_from(type_system& ts, type_def& self, type_def& from) {
#if 0
    if (from.kind == type_kind::integral || from.kind == type_kind::enum_ || from.kind == type_kind::enumflags) {
        return true;
    }
#endif

    return false;
}

static std::unordered_map<type_kind, cast_check_func> cast_check_funcs = {
    {type_kind::ptr, can_pointer_be_cast_from},
    {type_kind::integral, can_integral_be_cast_from},
    {type_kind::enum_, can_enum_be_cast_from},
    {type_kind::enumflags, can_enum_be_cast_from},
};

// is A explicitly castable to B?
bool is_castable_to(type_system& ts, type_id a, type_id b) {
    if (a == invalid_type || b == invalid_type) return false;
    if (is_assignable_to(ts, a, b)) return true;

    auto& ta = get_type(ts, a);
    auto& tb = get_type(ts, b);

    auto it = cast_check_funcs.find(tb.kind);
    if (it != cast_check_funcs.end()) {
        return it->second(ts, tb, ta);
    }
    return false;
}

// Section: string converters

std::string const_value_to_string(const const_value& v) {
    if (std::holds_alternative<type_id>(v)) {
        return std::get<type_id>(v).get().mangled_name.str;
    }
    assert(!"const_value_to_string not handled");
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
    std::string result = "fun ";
    result += func->self->func_id()->id_parts.front() + "(";
    result += type_list_to_string(func->self->tdef.func.arg_types);
    result += ") => " + type_to_string(func->self->tdef.func.ret_type);
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
        if (node.tid.valid()) {
            return node.tid;
        }

        auto& sym = ts.builtin_scope->scope.symbols[string_hash{ "int" }];
        return to_type_id(*sym);
    }
    case ast_type::float_literal: {
        auto& sym = ts.builtin_scope->scope.symbols[string_hash{ "float" }];
        return to_type_id(*sym);
    }
    case ast_type::char_literal: {
        auto& sym = ts.builtin_scope->scope.symbols[string_hash{ "byte" }];
        return to_type_id(*sym);
    }
    case ast_type::nil_literal: {
        return ts.nil_type;
    }
    case ast_type::cast_expr: {
        // TODO: check cast is possible and reasonable
        auto to_type = node.children[0]->tid;
        auto from_type = node.children[1]->tid;
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
        if (node.children[0]->tid == invalid_type || node.children[1]->tid == invalid_type ||
            node.children[0]->type_error || node.children[1]->type_error) {
            return invalid_type;
        }

        if (is_cmp_binary_op(node.op) || is_arith_binary_op(node.op)) {
            if (node.children[0]->tid.get().kind == type_kind::c_structure) {
                add_type_error(ts, node.pos, "cannot perform value-comparison on C structure type '%s'",
                    type_to_string(node.children[0]->tid).c_str()
                );
                return invalid_type;
            }
            else if (node.children[1]->tid.get().kind == type_kind::c_structure) {
                add_type_error(ts, node.pos, "cannot perform value-comparison on C structure type '%s'",
                    type_to_string(node.children[1]->tid).c_str()
                );
                return invalid_type;
            }

            if (is_arith_binary_op(node.op)) {
                if (!is_arith_type(node.children[0]->tid) || !is_arith_type(node.children[1]->tid)) {
                    add_type_error(ts, node.pos, "cannot perform operation on types '%s' and '%s'",
                        type_to_string(node.children[0]->tid).c_str(), type_to_string(node.children[1]->tid).c_str()
                    );
                    return invalid_type;
                }
            }

            bool needcast = false;
            if (!is_assignable_to(ts, node.children[0]->tid, node.children[1]->tid)) {
                try_coerce_to(ts, *node.children[1], node.children[0]->tid);
                try_coerce_to(ts, *node.children[0], node.children[1]->tid);
                
                if (!is_assignable_to(ts, node.children[0]->tid, node.children[1]->tid)) {
                    node.type_error = true;
                    if (is_arith_binary_op(node.op)) {
                        add_type_error(ts, node.pos, "cannot perform operation on types '%s' and '%s'",
                            type_to_string(node.children[0]->tid).c_str(), type_to_string(node.children[1]->tid).c_str()
                        );
                    }
                    else {
                        add_type_error(ts, node.pos, "cannot compare types '%s' and '%s'",
                            type_to_string(node.children[0]->tid).c_str(), type_to_string(node.children[1]->tid).c_str()
                        );
                    }
                    return invalid_type;
                }
            }

            node.type_error = false;

            if (is_cmp_binary_op(node.op)) {
                return ts.bool_type;
            }
            else {
                return node.children[0]->tid;
            }
        }

        if (is_logic_binary_op(node.op)) {
            if (node.children[0]->tid != ts.bool_type) {
                node.type_error = true;
                add_type_error(ts, node.children[0]->pos,
                    "operand of logic operators (&&, ||) has type '%s', it must be 'bool'",
                    type_to_string(node.children[0]->tid).c_str());
                return invalid_type;
            }
            if (node.children[1]->tid != ts.bool_type) {
                node.type_error = true;
                add_type_error(ts, node.children[1]->pos,
                    "operand of logic operators (&&, ||) has type '%s', it must be 'bool'",
                    type_to_string(node.children[1]->tid).c_str());
                return invalid_type;
            }
            node.type_error = false;
            return ts.bool_type;
        }

        node.type_error = false;
        return node.children[0]->tid;
    }
    }

    return invalid_type;
}

type_id get_type_expr_node_type(type_system& ts, ast_node& node) {
    switch (node.type) {
    case ast_type::identifier: {
        node.type_error = true;

        if (node.id_parts.front() == "$error") {
            node.tid = ts.error_type;
            node.type_error = false;
            break;
        }

        if (node.id_parts.front() == "$nil") {
            node.tid = ts.nil_type;
            node.type_error = false;
            break;
        }

        auto sym = find_symbol(ts, separate_module_identifier(node.id_parts));
        if (sym) {
            if (sym->kind == symbol_kind::type) {
                node.tid = type_id{ sym->scope, sym->type_index };
                node.type_error = false;
            }
            else if (sym->kind == symbol_kind::const_value) {
                auto& value = sym->ctvalue;
                if (std::holds_alternative<type_id>(value)) {
                    node.tid = std::get<type_id>(value);
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
                node.tid = get_ptr_type_to(ts, elem_type);
            }
        }
        else if (node.type_qual == type_qualifier::in) {
            auto elem_type = get_type_expr_node_type(ts, *node.children[0]);
            if (elem_type.valid()) {
                if (elem_type.get().kind == type_kind::output) {
                    node.tid = get_inout_type_to(ts, elem_type.get().elem_type);
                }
                else {
                    node.tid = get_in_type_to(ts, elem_type);
                }
            }
        }
        else if (node.type_qual == type_qualifier::out) {
            auto elem_type = get_type_expr_node_type(ts, *node.children[0]);
            if (elem_type.valid()) {
                if (elem_type.get().kind == type_kind::input) {
                    node.tid = get_inout_type_to(ts, elem_type.get().elem_type);
                }
                else {
                    node.tid = get_out_type_to(ts, elem_type);
                }
            }
        }
        else if (node.type_qual == type_qualifier::pure) {
            auto elem_type = get_type_expr_node_type(ts, *node.children[0]);
            if (elem_type.valid()) {
                node.tid = get_pure_type_to(ts, elem_type);
            }
        }
        break;
    }
    case ast_type::static_array_type: {
        visit_children(ts, node);
        auto [args, all_resolved] = nodes_to_const_values(ts, node.children);
        if (all_resolved) {
            node.tid = execute_type_constructor(ts, ts.builtin_scope->scope, *ts.static_array_type_constructor, args);
            node.type_error = false;
        }
        else {
            node.type_error = true;
        }
        break;
    }
    case ast_type::array_type: {
        visit_children(ts, node);
        auto [args, all_resolved] = nodes_to_const_values(ts, node.children);
        if (all_resolved) {
            node.tid = execute_type_constructor(ts, ts.builtin_scope->scope, *ts.array_type_constructor, args);
            node.type_error = false;
        }
        else {
            node.type_error = true;
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
                    field->tid = field->var_type()->tid;
                    sfields.push_back({ { name }, field->tid, 0 });
                }

                if (!field->tid.valid()) {
                    all_resolved = false;
                }
            }

            if (all_resolved && !node.tid.valid()) {
                auto& td = node.tdef;
                td.kind = type_kind::structure;
                td.structure.fields = sfields;
                compute_struct_size_alignment_offsets(td);

                // if name is not empty it means this is the result of a type constructor
                if (td.name.str.empty()) {
                    td.name = string_hash{ "anonymous struct " + std::to_string(node.node_id) };
                    td.mangled_name = string_hash{ "anonymous$struct$" + std::to_string(node.node_id) };
                    auto fd = find_type_by_value(ts, ts.builtin_scope->scope, td);
                    if (fd.valid()) {
                        node.tid = fd;
                    }
                    else {
                        node.tid = register_type(ts, ts.builtin_scope->scope, node);
                    }
                }
                node.type_error = false;
            }
            else {
                node.type_error = true;
            }
        }
        else {
            node.tid = ts.opaque_type;
        }
        break;
    }
    case ast_type::func_pointer_type: {
        visit_children(ts, node);

        auto [args, all_resolved] = nodes_to_const_values(ts, node.func_type_args());
        auto [retarg, resolved] = node_to_const_value(ts, *node.func_type_ret());
        if (all_resolved && resolved) {
            args.push_back(retarg);
            node.tid = execute_type_constructor(ts, ts.builtin_scope->scope, *ts.func_pointer_type_constructor, args);
            node.type_error = false;
        }
        else {
            node.type_error = true;
        }
        break;
    }
    case ast_type::enum_type: {
        if (node.tdef.self) {
            break;
        }

        auto& base_type_node = node.children[0];
        auto& id_list = node.children[1];
        bool is_flags = node.int_value == 1;

        type_id base_type = ts.int_type;
        if (base_type_node) {
            visit_tree(ts, *base_type_node);
            if (base_type_node->tid.valid()) {
                base_type = base_type_node->tid;
            }
        }

        if (base_type.get().kind != type_kind::integral) {
            add_type_error(ts, node.pos, "enum base type '%s' is not an integral type", type_to_string(base_type));
            break;
        }

        node.tdef = base_type.get();
        node.tdef.self = &node;
        node.tdef.kind = is_flags ? type_kind::enumflags : type_kind::enum_;
        node.tdef.name = string_hash{ "anonymous enum" + std::to_string(node.node_id) };
        node.tdef.mangled_name = string_hash{ "anonymous$enum" + std::to_string(node.node_id) };
        node.tid = register_user_type(ts, node);

        comp_int_type numeric_value = 0;
        for (auto& idnode : id_list->children) {
            auto id = string_hash{ build_identifier_value(idnode->id_parts) };

            const_value value;
            if (is_flags) {
                value = 1 << numeric_value;
            }
            else {
                value = numeric_value;
            }

            declare_const_symbol(ts, id, value, node.tid);
            node.tdef.enumtype.symbols.push_back(find_symbol_in_current_scope(ts, id));
            numeric_value++;
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
            auto [args, all_resolved] = nodes_to_const_values(ts, node.children[1]->children);
            if (all_resolved) {
                node.tid = execute_type_constructor(ts, *ctor.scope, ctor.get().constructor, args);
            }
            else {
                node.type_error = true;
                complement_error(ts, node.pos, "while instantiating type constructor '%s'", build_identifier_value(id->id_parts).c_str());
            }
        }
        break;
    }
    case ast_type::field_expr: {
        type_check_field_expr(ts, node, false);
        if (node.tid == ts.type_type) {
            node.tid = type_id{ node.lvalue.symbol->scope, node.lvalue.symbol->type_index };
        }
        else {
            add_type_error(ts, node.pos, "unknown type '%s'", node_to_string(node).c_str());
        }
        break;
    }
    case ast_type::builtin_call_expr: {
        resolve_node_type(ts, &node);
        if (node.type != ast_type::builtin_call_expr) {
            return get_type_expr_node_type(ts, node);
        }
        break;
    }
    case ast_type::type_resolver: {
        return node.tid;
    }
    }

    return node.tid;
}

type_id resolve_identifier_with_symbol(type_system& ts, ast_node& node, symbol_info* sym) {
    if (sym && (sym->kind == symbol_kind::local || sym->kind == symbol_kind::global)) {
        auto local = get_symbol_local(*sym);
        bool was_unresolved = !node.tid.valid();

        node.lvalue.self = &node;
        node.lvalue.symbol = sym;
        node.tid = local->self->tid;

        if (node.tid.valid()) {
            bool isnew = true;
            for (auto ref : local->refs) {
                if (ref == &node) {
                    //assert(!"about to insert duplicate ref");
                    isnew = false;
                }
            }
            if (isnew) {
                local->refs.push_back(&node);
            }
        }

        if (!node.tid.valid()) {
            //printf("cannot determine type of symbol '%s' - %p\n", node_to_string(node).c_str(), local->self);
            unk_type_error(ts, node.tid, node.pos, "cannot determine type of symbol '%s'", node_to_string(node).c_str());
        }
    }
    else if (sym && (sym->kind == symbol_kind::overloaded_func_base || sym->kind == symbol_kind::top_level_func)) {
        node.lvalue.self = &node;
        node.lvalue.symbol = sym;
    }
    else if (sym && sym->kind == symbol_kind::const_value) {
        node.lvalue.self = &node;
        node.lvalue.symbol = sym;
        node.tid = sym->cttype;
    }
    else if (sym && sym->kind == symbol_kind::type) {
        node.lvalue.self = &node;
        node.lvalue.symbol = sym;
        node.tid = ts.type_type;
    }
    else if (sym && sym->kind == symbol_kind::module_) {
        node.lvalue.self = &node;
        node.lvalue.symbol = sym;
        node.tid = ts.module_type;
    }

    if (!sym) {
        unk_type_error(ts, node.tid, node.pos, "undefined '%s'", node_to_string(node).c_str());
    }

    return node.tid;
}

type_id resolve_identifier(type_system& ts, ast_node& node) {
    auto sym = find_symbol(ts, separate_module_identifier(node.id_parts));
    return resolve_identifier_with_symbol(ts, node, sym);
}

void propagate_return_type(type_system& ts, const type_id& id) {
    //auto scope_id = find_nearest_scope(ts, scope_kind::func_body);
    //ts.scopes[scope_id].announced_return_types.push_back(id);
}

void propagate_type_coercion(type_system& ts, ast_node& node, const type_id& id) {
    switch (node.type) {
    case ast_type::return_stmt:
        node.tid = id;
        for (const auto& child : node.children) {
            if (child) {
                propagate_type_coercion(ts, *child, id);
            }
        }
        break;
    case ast_type::init_expr:
        node.tid = id;
        break;
    }
}

static void push_receiver_type(type_system& ts, type_id t) {
    ts.receiver_type_stack.push(t);
}

static void pop_receiver_type(type_system& ts) {
    ts.receiver_type_stack.pop();
}

static type_id top_receiver_type(type_system& ts) {
    if (ts.receiver_type_stack.empty()) {
        return {};
    }
    return ts.receiver_type_stack.top();
}

type_id generate_deref_for_input(type_system& ts, ast_node& l, type_id val_type, int val_index) {
    if (val_type.valid() && (val_type.get().flags & type_flags::is_in)) {
        auto deref_expr = make_deref_expr(ts, std::move(l.children[val_index]));
        deref_expr->parent = &l;
        l.children[val_index] = std::move(deref_expr);
        resolve_node_type(ts, l.children[val_index].get());
        val_type = l.children[val_index]->tid;
    }
    return val_type;
}

bool resolve_local_variable_type(type_system& ts, ast_node& l, bool is_arg = false) {
    auto decl_type = l.var_type() ? resolve_node_type(ts, l.var_type()) : type_id{};

    ts.assignee_stack.push(l.var_decl_ids().front().get());

    if (l.var_type()) push_receiver_type(ts, decl_type);
    auto val_type = l.var_value() ? resolve_node_type(ts, l.var_value()) : type_id{};
    if (l.var_type()) pop_receiver_type(ts);

    ts.assignee_stack.pop();

    decl_type = l.var_type() ? l.var_type()->tid : type_id{};
    val_type = l.var_value() ? l.var_value()->tid : type_id{};

    val_type = generate_deref_for_input(ts, l, val_type, 2);

    if (l.var_type() && decl_type.valid()) {
        if (decl_type.get().array.deduce_size
            && val_type.valid()
            && is_assignable_to(ts, val_type.get().elem_type, decl_type.get().elem_type)
        ) {
            decl_type = val_type;
            l.var_type()->tid = decl_type;
        }

        l.tid = decl_type;
        l.type_error = l.var_type()->type_error;

        if (l.var_value() && !(l.var_value()->tid.valid()) && l.var_value()->type == ast_type::init_expr) {
            deduce_init_list_type(ts, *l.var_value(), decl_type);
        }

        if (l.var_value() && !is_assignable_to(ts, l.var_value()->tid, l.var_type()->tid)) {
            add_type_error(ts, l.var_value()->pos, "cannot assign value of type '%s' to '%s'",
                type_to_string(l.var_value()->tid).c_str(), type_to_string(l.var_type()->tid).c_str());
            return false;
        }
    }
    else if (!l.var_type()) {
        l.tid = val_type;
        l.type_error = l.var_value()->type_error;
    }

    if (!is_arg && l.tid.valid() && l.tid.get().kind == type_kind::output) {
        add_type_error(ts, l.pos, "cannot have a local variable of type '%s'", type_to_string(l.tid).c_str());
        return false;
    }

    return true;
}

void update_local_variable_type(type_system& ts, ast_node& l, type_id tid) {
    l.tid = tid;
    for (auto ref : l.local.refs) {
        ref->tid = tid;
    }
}

void update_local_aggregate_argument(type_system& ts, ast_node& l) {
    update_local_variable_type(ts, l, get_ptr_type_to(ts, l.tid));
    if (l.type == ast_type::var_decl) {
        l.children[ast_node::child_var_decl_type] = make_type_resolver_node(*ts.ast_arena, l.tid);
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
    array_cast,
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
    bool convertible = is_assignable_to(ts, node.tid, target);
    if (!convertible) {
        try_coerce_to(ts, node, target);

        convertible = is_assignable_to(ts, node.tid, target);
        if (!convertible) {
            if (target.get().flags & (type_flags::is_in | type_flags::is_out)) {
                if ((target.get().flags & type_flags::is_out) && (node.tid.get().flags & type_flags::is_pure)) {
                    return false;
                }

                if (is_assignable_to(ts, node.tid, target.get().elem_type)) {
                    info.cast_needed_idxs.push_back(std::make_tuple(toptr_cast, target, idx));
                    return true;
                }
                else if ((target.get().elem_type.get().flags & type_flags::is_pure) &&
                        (get_alias_root(ts, target.get().elem_type.get().elem_type) == get_alias_root(ts, node.tid))) {
                    info.cast_needed_idxs.push_back(std::make_tuple(toptr_cast, target, idx));
                    return true;
                }
                else if ((node.tid.get().flags & type_flags::is_pure) &&
                    (get_alias_root(ts, target.get().elem_type) == get_alias_root(ts, node.tid.get().elem_type))) {
                    info.cast_needed_idxs.push_back(std::make_tuple(toptr_cast, target, idx));
                    return true;
                }
                else if (node.tid.get().kind == type_kind::static_array && target.get().elem_type.get().kind == type_kind::array) {
                    if (is_assignable_to(ts, node.tid.get().elem_type, get_pure_alias_root(ts, target.get().elem_type.get().elem_type))) {
                        info.cast_needed_idxs.push_back(std::make_tuple(array_cast, target.get().elem_type, idx));
                        return true;
                    }
                }
            }
            return false;
        }
    }
    return true;
}

bool check_convertible_and_cast_call_args_constructor(type_system& ts, ast_node& node, type_id target, int idx, call_match_info& info) {
    if (!is_assignable_to(ts, node.tid, target)) {
        try_coerce_to(ts, node, target);

        if (!is_assignable_to(ts, node.tid, target)) {
            if (target.get().kind == type_kind::ptr && target.get().elem_type == node.tid.get().constructor_type) {
                info.cast_needed_idxs.push_back(std::make_tuple(toptr_cast, get_ptr_type_to(ts, node.tid), idx));
                return true;
            }

            return false;
        }
    }

    return true;
}

void perform_casts(type_system& ts, std::vector<arena_ptr<ast_node>>& call_args, const call_match_info& info) {
    for (const auto& c : info.cast_needed_idxs) {
        switch (std::get<0>(c)) {
        case simple_cast:
            call_args[std::get<2>(c)] = make_cast_to(ts, std::move(call_args[std::get<2>(c)]), std::get<1>(c));
            break;
        case toptr_cast: {
            auto target_type = std::get<1>(c);
            auto& arg_node = call_args[std::get<2>(c)];

            if ((target_type.get().flags & type_flags::is_out)) {
                if (!arg_node->lvalue.self) {
                    add_type_error(ts, arg_node->pos, "expected an lvalue for out parameter");
                    break;
                }
            }

            call_args[std::get<2>(c)] = make_address_of_expr(ts, std::move(call_args[std::get<2>(c)]));
            call_args[std::get<2>(c)]->tid = get_ptr_type_to(ts, call_args[std::get<2>(c)]->children[0]->tid);
            break;
        }
        case array_cast: {
            auto target_type = std::get<1>(c);
            auto& arg_node = call_args[std::get<2>(c)];

            auto index_expr = make_index_expr_node(*ts.ast_arena, arg_node->pos, copy_node(ts, arg_node.get()), make_int_literal_node(*ts.ast_arena, arg_node->pos, 0));
            auto address_of_first_expr = make_unary_expr_node(*ts.ast_arena, arg_node->pos, token_from_char('&'), std::move(index_expr));
            auto asize = arg_node->tid.get().array.length;

            std::vector<arena_ptr<ast_node>> init_args;
            init_args.push_back(std::move(address_of_first_expr));
            init_args.push_back(make_int_literal_node(*ts.ast_arena, arg_node->pos, asize));
            init_args.push_back(make_int_literal_node(*ts.ast_arena, arg_node->pos, asize));
            auto init_arg_list = make_arg_list_node(*ts.ast_arena, arg_node->pos, std::move(init_args));

            auto init_type = make_type_expr_node(*ts.ast_arena, arg_node->pos, make_type_resolver_node(*ts.ast_arena, target_type));

            auto init_expr = make_init_expr_node(*ts.ast_arena, arg_node->pos, std::move(init_type), std::move(init_arg_list));

            auto new_arg = make_address_of_expr(ts, std::move(init_expr));
            resolve_node_type(ts, new_arg.get());

            call_args[std::get<2>(c)] = std::move(new_arg);
            break;
        }
        }
    }
}

bool match_arg_list(type_system& ts, std::vector<arena_ptr<ast_node>>& func_args, std::vector<arena_ptr<ast_node>>& call_args,
    const std::vector<const_value>& func_const_args, const std::vector<const_value>& call_const_args) {

    if (func_args.size() != call_args.size()) return false;
    if (func_const_args.size() != call_const_args.size()) return false;

    for (std::size_t i = 0; i < func_const_args.size(); i++) {
        auto& farg = func_const_args[i];
        auto& carg = call_const_args[i];
        if (!(farg == carg)) {
            return false;
        }
    }

    call_match_info info{};
    for (std::size_t i = 0; i < func_args.size(); i++) {
        auto& farg = func_args[i];
        auto& carg = call_args[i];

        if (!check_convertible_and_cast_call_args(ts, *carg, farg->tid, i, info)) {
            return false;
        }
    }

    perform_casts(ts, call_args, info);

    return true;
}

string_hash mangle_global_name(type_system& ts, const std::vector<std::string>& mod_parts, const string_hash& name, func_linkage linkage) {
    std::string result;
    if (linkage != func_linkage::external_c) {
        for (const auto& part : mod_parts) {
            result.append(part);
            result.append("__");
        }
    }
    result.append(name.str);
    return string_hash{ result };
}

string_hash mangle_macro_name(type_system& ts, const std::vector<std::string>& id_parts, int num_args) {
    std::string name;
    for (const auto& part : id_parts) {
        name.append(part);
        name.append("_");
    }
    name.append("a");
    name.append(std::to_string(num_args));
    return name;
}

string_hash mangle_func_name(type_system& ts, const std::vector<std::string>& id_parts, const std::vector<const_value>& const_args,
    const std::vector<arena_ptr<ast_node>>& args, func_linkage linkage) {
    //assert(f.tid != invalid_type);

    if (linkage == func_linkage::local_carbon || linkage == func_linkage::external_carbon) {
        std::string name = "paruser";
        for (const auto& part : id_parts) {
            name.append(".");
            name.append(part);
        }
        for (auto& arg : const_args) {
            name.append("._C");
            name.append(const_value_to_string(arg));
        }
        for (auto& arg : args) {
            assert(arg->tid != invalid_type);
            auto tdef = arg->tid.get();
            name.append("._A");
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
    node.tdef.func.arg_types.clear();
    for (auto& arg : node.func_args()) {
        resolve_local_variable_type(ts, *arg, true);
        if (arg->tid == invalid_type || arg->type_error) {
            node.func.args_unresolved = true;

            auto name = node_to_string(*arg->var_id());
            //complement_error(ts, arg->pos, "in declaration of #%d argument '%s' of function '%s'", arg->local.arg_index + 1, name.c_str(), funcname.c_str());
        }
        else if (is_aggregate_type(arg->tid)) {
            arg->tid = get_in_type_to(ts, arg->tid);
        }
        node.tdef.func.arg_types.push_back(arg->tid);
    }
}

// TODO: deduce type from return statements

type_id deduce_func_return_type(type_system& ts, ast_node& f) {
    if (f.func.return_statements.empty()) {
        return ts.opaque_type;
    }

    auto funcname = node_to_string(*f.func_id());

    type_id ret_type = invalid_type;
    for (auto& ret : f.func.return_statements) {
        if (ret->tid.valid()) {
            if (ret_type.valid()) {
                if (is_assignable_to(ts, ret_type, ret->tid)) {
                    ret_type = ret->tid;
                }
                else {
                    // TODO: assume union type
                    add_type_error(ts, ret->pos, "incompatible return types for function '%s'", funcname.c_str());
                    complement_error(ts, ret->pos, "previous return statements had type '%s', but this one has type '%s'",
                        type_to_string(ret_type).c_str(), type_to_string(ret->tid).c_str());
                    return invalid_type;
                }
            }
            else {
                ret_type = ret->tid;
            }
        }
        else if (ret->children.empty() || !ret->children[0]) {
            ret_type = ts.opaque_type;
        }
    }
    return ret_type;
}

static void count_asm_statements(type_system& ts, ast_node& node, int* asmcount, int* nonasmcount) {
    switch (node.type) {
    case ast_type::decl_list:
    case ast_type::stmt_list:
    case ast_type::compound_stmt: {
        for (auto& child : node.children) {
            if (child) {
                count_asm_statements(ts, *child, asmcount, nonasmcount);
            }
        }
        break;
    }
    case ast_type::asm_stmt: {
        *asmcount += 1;
        break;
    }
    default:
        *nonasmcount += 1;
        break;
    }
}

static void generate_init_for_out_arguments(type_system& ts, ast_node& f) {
    if (!f.func_body()) return;

    enter_scope_local(ts, f);

    assert(f.func_body()->type == ast_type::compound_stmt);

    for (int idx = f.func_args().size() - 1; idx >= 0; idx--) {
        auto& arg = f.func_args()[idx];
        assert(arg->type == ast_type::var_decl);

        if (arg->tid.get().kind == type_kind::output) {
            auto ref = make_identifier_node(*ts.ast_arena, f.func_body()->pos, arg->var_id()->id_parts);

            auto zerovalue = get_zero_value_node_for_type(ts, arg->tid.get().elem_type);
            assert(zerovalue.get());

            auto assign = make_assign_stmt_node(*ts.ast_arena, f.func_body()->pos, std::move(ref), std::move(zerovalue));
            resolve_node_type(ts, assign.get());

            f.func_body()->children.insert(f.func_body()->children.begin(), std::move(assign));
        }
    }

    leave_scope_local(ts);
}

type_id resolve_func_type(type_system& ts, ast_node& f) {
    assert(f.func.self || !"func not declared yet");

    auto funcname = node_to_string(*f.func_id());

    f.tdef.kind = type_kind::func;
    f.tdef.size = sizeof(void*);
    f.tdef.alignment = sizeof(void*);
    f.tdef.is_signed = false;

    type_id ret_type = invalid_type;
    if (f.func_ret_type()) {
        ret_type = resolve_node_type(ts, f.func_ret_type());
        if (!ret_type.valid()) {
            f.type_error = true;
            //complement_error(ts, f.pos, "in return type of function '%s'", funcname.c_str());
        }

        if (ret_type.valid()) {
            if (f.func.return_statements.empty() && ret_type != ts.opaque_type && f.func.linkage == func_linkage::local_carbon && f.func_body()) {
                int asmcount = 0;
                int nonasmcount = 0;
                count_asm_statements(ts, *f.func_body(), &asmcount, &nonasmcount);
                if (nonasmcount > 0 || asmcount == 0) {
                    add_type_error(ts, f.func_ret_type()->pos,
                        "function '%s' has return type '%s' but no return statements",
                        funcname.c_str(),
                        type_to_string(ret_type).c_str());
                }
            }
            for (auto retst : f.func.return_statements) {
                // TODO: check for needed casts
                if (!is_assignable_to(ts, retst->tid, ret_type)) {
                    add_type_error(ts, retst->pos,
                        "cannot return type '%s' from function '%s' declared returning type '%s'",
                        type_to_string(retst->tid).c_str(),
                        funcname.c_str(),
                        type_to_string(ret_type).c_str());
                    break;
                }

                // TODO: better coercion
                propagate_type_coercion(ts, *retst, ret_type);
            }
        }
    }
    else {
        ret_type = deduce_func_return_type(ts, f);
    }
    
    if (!f.tid.valid() && !f.func.args_unresolved && ret_type.valid()) {
        generate_init_for_out_arguments(ts, f);
        f.tdef.func.ret_type = ret_type;
        f.tdef.name = string_hash{ func_declaration_to_string(&f.func) };
        f.tid = register_user_type(ts, f);
    }

    assert(ts.current_scope->kind == scope_kind::module_);
    if (f.tid != invalid_type && f.tdef.mangled_name.str.empty() && ts.current_scope->kind == scope_kind::module_) {
        // this means the function type was resolved, so mangle the name and declare it
        f.tdef.mangled_name = mangle_func_name(ts, f.func_id()->id_parts, f.func.const_args, f.func_args(), f.func.linkage);

        auto bsym = find_symbol_in_current_scope(ts, f.func.base_symbol);
        for (auto& of : bsym->overload_funcs) {
            if (of->self->tdef.mangled_name == f.tdef.mangled_name) {
                f.type_error = true;
                add_type_error(ts, f.pos, "cannot redeclare the same argument list for the same function");
                //complement_error(ts, f.pos, "in declaration of function '%s'", funcname.c_str());
            }
        }

        bsym->overload_funcs.push_back(&f.func);
        declare_top_level_func_symbol(ts, f.tdef.mangled_name, f);
    }
    return f.tid;
}

// Section: declarations

void clear_func_resolved_state(ast_node& func) {
    func.tid = invalid_type;
    func.tdef.mangled_name = string_hash{ "" };
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

void register_macro_declaration_node(type_system& ts, ast_node& node) {
    if (node.local.self) return;

    auto& id = node.children[0];
    auto& arg_list = node.children[1]->children;
    auto& body = node.children[2];

    node.func.decl_scope = ts.current_scope;
    node.func.base_symbol = build_identifier_value(node.func_id()->id_parts);
    auto ovbase = find_symbol_in_current_scope(ts, node.func.base_symbol);
    if (!ovbase) {
        declare_overloaded_func_base_symbol(ts, node.func.base_symbol);
        ovbase = find_symbol_in_current_scope(ts, node.func.base_symbol);
    }

    node.scope.self = &node;
    node.func.self = &node;
    node.local.self = &node;

    auto& f = node;
    f.func.num_args = arg_list.size();

    if (f.tdef.mangled_name.str.empty() && ts.current_scope->kind == scope_kind::module_) {
        f.tdef.mangled_name = mangle_macro_name(ts, id->id_parts, arg_list.size());

        for (auto& of : ovbase->overload_macros) {
            if (of->self->tdef.mangled_name == f.tdef.mangled_name) {
                f.type_error = true;
                add_type_error(ts, f.pos, "cannot redeclare the same argument list for the same macro");
                return;
            }
        }

        ovbase->overload_macros.push_back(&f.func);
        declare_macro_symbol(ts, f.tdef.mangled_name, f);
    }
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
            auto new_body = make_compound_stmt_node(*ts.ast_arena, body->pos, std::move(new_lists), false);

            node.children[ast_node::child_func_decl_body] = std::move(new_body);
            body = node.children[ast_node::child_func_decl_body].get();
            parent_tree(*body);
        }
    }

    node.scope.self = &node;
    node.func.self = &node;
    node.local.self = &node;

    if (body) {
        body->parent = &node;
        add_func_scope(ts, node, *body);
    }

    declare_func_arguments(ts, node);
    for (auto& arg : arg_list) {
        resolve_local_variable_type(ts, *arg, true);
    }

    if (body) {
        visit_tree(ts, *body);
        leave_scope_local(ts);
    }

    // try to resolve the func type already
    node.func.args_unresolved = true; // assume args are unresolved, possibly wasting a type check pass
    resolve_func_type(ts, node);
}

void resolve_and_declare_local_variables(type_system& ts, ast_node& node) {
    size_t num_new = 0;
    bool diderror = false;
    for (auto& idnode : node.var_decl_ids()) {
        string_hash id;

        bool is_rest = false;

        if (idnode->type == ast_type::identifier) {
            id = string_hash{ idnode->id_parts.back() };
        }
        else if (idnode->type == ast_type::rest_expr) {
            id = string_hash{ idnode->children[0]->id_parts.back() };
            is_rest = true;
        }

        auto prev = find_symbol_in_current_scope_thispass(ts, id);
        if (prev && num_new == 0 && !(node.local.flags & local_flag::dont_check_for_duplicates)) {
            //node.tid = invalid_type;
            add_type_error(ts, idnode->pos, "cannot re-declare name '%s'", id.str.c_str());
            diderror = true;
        }
        else if (prev && is_rest) {
            //node.tid = invalid_type;
            add_type_error(ts, idnode->pos, "cannot re-declare identifier of '...' expression '%s'", id.str.c_str());
            diderror = true;
        }
        else {
            num_new++;
        }
    }
    if (num_new == 0) {
        add_type_error(ts, node.pos, "at least one new variable must be declared in a 'let' declaration");
        return;
    }
    if (diderror) {
        return;
    }

    if (!resolve_local_variable_type(ts, node)) {
        return;
    }

    // Check if we're unpacking a tuple / struct / array
    if (node.var_decl_ids().size() > 1) {
        return;
    }

    // Check if we're declaring a const (compile-time) value
    if (node.op == token_type::const_ && node.tid.valid()) {
        if (!node.var_value()) {
            add_type_error(ts, node.pos, "const declaration requires a initializer expression");
            return;
        }

        auto [value, ok] = node_to_const_value_fold(ts, *node.var_value());
        if (ok) {
            auto id = string_hash{ node.var_id()->id_parts.back() };
            declare_const_symbol(ts, id, value, node.tid);
        }
        else {
            add_type_error(ts, node.pos, "invalid constant expression");
        }
        return;
    }

    auto id = string_hash{ build_identifier_value(node.var_id()->id_parts) };

    // Proceed with normal variable declaration (non-const, only 1 variable)
    if (ts.current_scope->kind == scope_kind::module_) {
        declare_global_symbol(ts, id, node);
    }
    else {
        //printf("declaring local %s of type %s - %p\n", id.str.c_str(), type_to_string(node.tid).c_str(), &node);
        declare_local_symbol(ts, id, node);
    }
    node.local.self = &node;

    if (node.tid.valid() && node.tid.get().size == 0) {
        add_type_error(ts, node.pos, "cannot create value of an anonymous empty type");
        return;
    }

    if (node.var_value()) {

    } else if (node.tid.valid() && check_type_allows_no_init(ts, node.pos, node.tid)) {
        auto value = get_zero_value_node_for_type(ts, node.tid);
        if (value) {
            value->tid = node.tid;
            node.children[ast_node::child_var_decl_value] = std::move(value);
        }
    }
    else {
        node.type_error = true;
    }
}

void register_var_declaration_node(type_system& ts, ast_node& node) {
    // First check if at least one identifier is new
    resolve_and_declare_local_variables(ts, node);
}

bool is_assignment(const ast_node& node) {
    return (node.type == ast_type::assign_stmt);
}

bool is_aggregate_return_value(const ast_node& node) {
    if (node.type == ast_type::unary_expr && node.op == token_from_char(DEREF_OP)) {
        if (node.children[0]->type == ast_type::identifier) {
            auto sym = node.children[0]->lvalue.symbol;
            auto local = sym->scope->local_defs[sym->local_index];
            return (local->flags & local_flag::is_aggregate_return);
        }
    }
    return false;
}

void resolve_assignment_type(type_system& ts, ast_node& node) {
    node.type_error = (node.children[0]->type_error || node.children[1]->type_error);

    // Check the left type is resolved
    if ((!node.children[0]->tid.valid() || node.children[0]->type_error)) {
        //complement_error(ts, node.pos, "in assignment of '%s'", node_to_string(*node.children[0]).c_str());
        return;
    }
    else if (!(node.children[0]->lvalue.self)) {
        add_type_error(ts, node.pos, "left-side of assignment must be an lvalue (identifier, index expression, struct/tuple field or pointer)");
        return;
    }

    auto left_type = node.children[0]->tid;
    if (left_type.get().flags & type_flags::is_in) {
        add_type_error(ts, node.pos, "left-side of assignment has input type '%s'", type_to_string(left_type).c_str());
        return;
    }
    if ((left_type.get().flags & type_flags::is_pure) && !is_aggregate_return_value(*node.children[0])) {
        add_type_error(ts, node.pos, "left-side of assignment has pure type '%s'", type_to_string(left_type).c_str());

        if (node.children[0]->type == ast_type::field_expr && node.children[0]->children[0]->tid.get().kind == type_kind::input) {
            complement_error(ts, node.pos, "trying to assign to field of input argument '%s'",
                type_to_string(node.children[0]->children[0]->tid).c_str());
        }

        return;
    }

    // Check if the destination is an 'out' parameter and automatically derefs it
    if (left_type.get().flags & type_flags::is_out) {
        auto deref_expr = make_deref_expr(ts, std::move(node.children[0]));
        deref_expr->parent = &node;
        node.children[0] = std::move(deref_expr);
        resolve_node_type(ts, node.children[0].get());
        left_type = node.children[0]->tid;
    }

    // Check if the source is an 'in/in out' parameter and automatically derefs it
    auto val_type = node.children[1]->tid;
    val_type = generate_deref_for_input(ts, node, val_type, 1);

    // Check if the types are assignable from one to another
    if (!is_assignable_to(ts, val_type, left_type)) {
        try_coerce_to(ts, *node.children[1], left_type);

        val_type = node.children[1]->tid;
        if (!is_assignable_to(ts, val_type, left_type)) {
            add_type_error(ts, node.children[1]->pos, "cannot assign value of type '%s' to '%s'",
                type_to_string(node.children[1]->tid).c_str(),
                type_to_string(node.children[0]->tid).c_str());

            node.type_error = true;
            node.tid = invalid_type;
            return;
        }
    }

    node.type_error = false;
    node.tid = node.children[0]->tid;
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
    // TODO: handle array as well

    if (!node.forinfo.self) {
        if (node.children[1]->type == ast_type::range_expr) {
            int numfields = 3;

            auto iterstart = copy_node(ts, node.children[1]->range.start);
            iterstart->parent = &node;
            resolve_node_type(ts, iterstart.get());

            auto iterend   = copy_node(ts, node.children[1]->range.end);
            iterend->parent = &node;
            resolve_node_type(ts, iterend.get());

            auto iterstep = copy_node(ts, node.children[1]->range.step);
            iterstep->parent = &node;
            resolve_node_type(ts, node.forinfo.iterstep.get());


            auto decl_iterstart = make_var_decl_with_value(*ts.ast_arena, "$for_iter_start", copy_node(ts, iterstart.get()));
            decl_iterstart->local.flags |= local_flag::dont_check_for_duplicates;
            resolve_node_type(ts, decl_iterstart.get());

            auto decl_iterend = make_var_decl_with_value(*ts.ast_arena, "$for_iter_end", copy_node(ts, iterend.get()));
            decl_iterend->local.flags |= local_flag::dont_check_for_duplicates;
            resolve_node_type(ts, decl_iterend.get());

            auto decl_iterstep = make_var_decl_with_value(*ts.ast_arena, "$for_iter_step", copy_node(ts, iterstep.get()));
            decl_iterstep->local.flags |= local_flag::dont_check_for_duplicates;
            resolve_node_type(ts, decl_iterstep.get());


            auto ref_iterstart = make_identifier_node(*ts.ast_arena, {}, { "$for_iter_start" });
            resolve_node_type(ts, ref_iterstart.get());

            auto ref_iterend = make_identifier_node(*ts.ast_arena, {}, { "$for_iter_end" });
            resolve_node_type(ts, ref_iterend.get());

            auto ref_iterstep = make_identifier_node(*ts.ast_arena, {}, { "$for_iter_step" });
            resolve_node_type(ts, ref_iterstep.get());


            // declare the variable to hold the element of the range
            std::string elem_id = "";

            auto params = get_compound_block_params(*node.children[2]);
            if (params) {
                elem_id = params->at(0)->id_parts.front();
            }
            else {
                elem_id = generate_temp_name();
            }

            if (!elem_id.empty()) {
                auto elem_decl_node = make_var_decl_with_value(*ts.ast_arena, elem_id, copy_node(ts, ref_iterstart.get()));
                resolve_node_type(ts, elem_decl_node.get());

                auto elemref = make_identifier_node(*ts.ast_arena, {}, { elem_id });
                resolve_node_type(ts, elemref.get());

                node.forinfo.declare_elem_to_range_start = std::move(elem_decl_node);
                node.forinfo.elemref = copy_node(ts, elemref.get());

                node.forinfo.declare_elem_to_range_start->parent = &node;
                node.forinfo.elemref->parent = &node;
            }
            
            node.pre_nodes.push_back(std::move(decl_iterstart));
            node.pre_nodes.push_back(std::move(decl_iterend));
            node.pre_nodes.push_back(std::move(decl_iterstep));
            
            node.forinfo.iterstart = copy_node(ts, ref_iterstart.get());
            node.forinfo.iterend = copy_node(ts, ref_iterend.get());
            node.forinfo.iterstep = copy_node(ts, ref_iterstep.get());

            node.forinfo.iterstart->parent = &node;
            node.forinfo.iterend->parent = &node;
            node.forinfo.iterstep->parent = &node;
            node.forinfo.self = &node;
        }
        else {
            add_type_error(ts, node.children[1]->pos, "a for statement requires a tuple of {start, end} or {start, end, step}");
        }
    }

    if (node.forinfo.declare_elem_to_range_start) {
        resolve_node_type(ts, node.forinfo.declare_elem_to_range_start.get());
    }
}

arena_ptr<ast_node> make_neq_false_node(type_system& ts, arena_ptr<ast_node>&& val) {
    auto pos = val->pos;
    if (val->tid == ts.bool_type) {
        auto node = make_binary_expr_node(
            *ts.ast_arena,
            val->pos,
            token_type::neq,
            std::move(val),
            make_bool_literal_node(*ts.ast_arena, pos, 0)
        );
        resolve_node_type(ts, val.get());
        return node;
    }
    else if (val->tid.valid() && val->tid.get().kind == type_kind::enumflags) {
        auto node = make_binary_expr_node(
            *ts.ast_arena,
            val->pos,
            token_type::neq,
            std::move(val),
            make_nil_node(*ts.ast_arena, pos)
        );
        resolve_node_type(ts, val.get());
        return node;
    }
    else if (val->tid.valid() && val->tid.get().kind == type_kind::error) {
        auto node = make_binary_expr_node(
            *ts.ast_arena,
            val->pos,
            token_type::neq,
            std::move(val),
            make_nil_node(*ts.ast_arena, pos)
        );
        resolve_node_type(ts, val.get());
        return node;
    }
    else if (val->tid.valid()) {
        assert(false);
        return { nullptr, nullptr };
    }
    else {
        return std::move(val);
    }
}

bool is_boolish_type(type_system&ts, type_id tid) {
    if (!tid.valid()) {
        return false;
    }
    return is_assignable_to(ts, tid, ts.bool_type) || is_assignable_to(ts, tid, ts.error_type) || (tid.get().kind == type_kind::enumflags);
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

bool check_builtin_call(type_system& ts, ast_node& node) {
    if (node.children[0]->type == ast_type::identifier) {
        if (node.children[0]->id_parts.front() == "sizeof") {
            for (int i = 0; i < 2; i++) {
                node.type_error = true;
                if (i == 0) {
                    resolve_node_type(ts, node.children[1]->children[0].get());
                    if (node.children[1]->children[0]->tid.valid()) {
                        node.type = ast_type::int_literal;
                        node.tid = ts.int_type;
                        node.int_value = node.children[1]->children[0]->tid.get().size;
                        node.type_error = false;
                    }
                }
                else {
                    if (!node.sizeof_type_expr) {
                        node.sizeof_type_expr = make_type_expr_node(*ts.ast_arena, node.children[1]->children[0]->pos, copy_node(ts, node.children[1]->children[0].get()));
                    }
                    resolve_node_type(ts, node.sizeof_type_expr.get());
                    if (node.sizeof_type_expr->tid.valid()) {
                        node.type = ast_type::int_literal;
                        node.tid = ts.int_type;
                        node.int_value = node.sizeof_type_expr->tid.get().size;
                        node.type_error = false;
                    }
                }
            }
            return true;
        }
        else if (node.children[0]->id_parts.front() == "typeof") {
            resolve_node_type(ts, node.children[1]->children[0].get());
            if (node.children[1]->children[0]->tid.valid()) {
                node.type = ast_type::identifier;
                node.tid = node.children[1]->children[0]->tid;

                auto tempid = string_hash{ generate_temp_name() };
                const_value value = node.tid;
                declare_const_symbol(ts, tempid, value, ts.type_type);

                node.id_parts = { tempid.str };
                resolve_node_type(ts, &node);
                return true;
            }
        }
    }
    return false;
}

void separate_func_overload_selector_args(type_system& ts, ast_node& node) {
    if (!(node.call.flags & call_flag::separated_args)) {
        node.call.flags |= call_flag::separated_args;

        std::vector<arena_ptr<ast_node>> new_args;
        for (auto& arg : node.func_overload_args()) {
            if (arg->type == ast_type::const_expr) {
                auto [value, ok] = node_to_const_value(ts, *arg);
                if (!ok) {
                    assert(false);
                }

                node.call.const_args.push_back(value);
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
            if (arg->type == ast_type::const_expr) {
                auto [value, ok] = node_to_const_value(ts, *arg);
                if (!ok) {
                    assert(false);
                }

                node.call.const_args.push_back(value);
            }
            else {
                new_args.push_back(std::move(arg));
            }
        }

        node.children[1]->children = std::move(new_args);
    }
}

void macro_pre_pass(type_system& ts, ast_node* node, const std::vector<std::string>& original_arg_names, const std::string& macro_prefix) {
    if (node->type == ast_type::identifier) {
        for (const auto& aname : original_arg_names) {
            std::string idname = node->id_parts.front();
            if (aname == node->id_parts.front()) {
                node->id_parts = { macro_prefix + "$" + idname };
                break;
            }
        }
    }
    else {
        for (auto& child : node->pre_nodes) {
            if (child) macro_pre_pass(ts, child.get(), original_arg_names, macro_prefix);
        }
        for (auto& child : node->children) {
            if (child) macro_pre_pass(ts, child.get(), original_arg_names, macro_prefix);
        }
    }
}

bool check_macro_is_compound_expr(ast_node& body) {
    if ((body.type == ast_type::compound_stmt || body.type == ast_type::if_stmt) && body.as_expr) return false;

    for (auto& child : body.children) {
        if (child && child->type == ast_type::compute_stmt) {
            return true;
        }
        else if (child && check_macro_is_compound_expr(*child)) {
            return true;
        }
    }

    return false;
}

void macro_instantiate(type_system& ts, ast_node& node, func_def* func) {
    auto macro_instance = make_in_arena<ast_node>(*ts.ast_arena);
    macro_instance->type = ast_type::macro_instance;
    macro_instance->pos = node.pos;
    macro_instance->parent = node.parent;

    auto macro_body = copy_node(ts, func->self->children[2].get());
    macro_body->parent = macro_instance.get();
    if (check_macro_is_compound_expr(*macro_body)) {
        macro_body->as_expr = true;
    }

    macro_instance->children.push_back(std::move(macro_body));

    add_block_scope(ts, *macro_instance, *macro_instance);

    auto macro_prefix = func->self->tdef.mangled_name.str + std::to_string(node.node_id);

    std::vector<std::string> original_arg_names;

    int arg_index = 0;
    for (auto& arg : node.call_args()) {
        auto& name = func->self->func_args().at(arg_index);
        original_arg_names.push_back(name->var_decl_ids().front()->id_parts.front());
        arg_index++;
    }

    macro_pre_pass(ts, macro_instance->children[0].get(), original_arg_names, macro_prefix);

    arg_index = 0;
    for (auto& arg : node.call_args()) {
        auto& name = func->self->func_args().at(arg_index);
        auto id = string_hash{ macro_prefix + "$" + name->var_decl_ids().front()->id_parts.front() };
        auto value = const_value(arg.get());
        declare_const_symbol(ts, id, value, ts.quote_type);
        arg_index++;
    }

    resolve_node_type(ts, macro_instance->children[0].get());
    macro_instance->tid = macro_instance->children[0]->tid;

    leave_scope_local(ts);

    auto idx = find_child_index(node.parent, &node);

    auto self = std::move(node.parent->children[*idx]);
    macro_instance->temps.push_back(std::move(self));

    node.parent->children[*idx] = std::move(macro_instance);
}

void resolve_call_funcdef(type_system& ts, ast_node& node) {
    //auto pair = separate_module_identifier(node.call_func()->id_parts);
    separate_call_args(ts, node);
#if 0

#endif
    if (node.call_func()->lvalue.symbol && node.call_func()->type == ast_type::identifier) {
        std::string mod = "";
        std::string id = "";
        if (node.call_func()->id_parts.size() == 2) {
            mod = node.call_func()->id_parts.front();
            id = node.call_func()->id_parts.back();
        }
        else {
            id = node.call_func()->id_parts.front();
        }
        for (const auto& linkage : { func_linkage::local_carbon, func_linkage::external_c }) {
            node.call.mangled_name = mangle_func_name(ts, { id }, node.call.const_args, node.call_args(), linkage);

            auto sym = find_symbol(ts, { mod, node.call.mangled_name });
            if (sym && sym->kind == symbol_kind::top_level_func) {
                auto local = sym->scope->local_defs[sym->local_index];
                node.tid = local->self->tdef.func.ret_type;
                node.call.func_type_id = local->self->tid;
                node.call.funcdef = &local->self->func;
                node.type_error = false;
                //if (local->flags & local_flag::is_aggregate_argument) {
                  //  node.tid = node.tid.get().elem_type;
                //}
                break;
            }
        }
    }

    if (!node.tid.valid() && node.call_func()->lvalue.symbol) {
        node.type_error = true;

        auto funcname = node_to_string(*node.call_func());

        auto bsym = node.call_func()->lvalue.symbol;
        if (bsym && bsym->kind == symbol_kind::overloaded_func_base) {
            // try to match the arguments performing implicit conversions using the function non-generic overloads
            bool resolved = false;
            for (std::size_t i = 0; i < bsym->overload_funcs.size(); i++) {
                auto func = bsym->overload_funcs[i];
                if (match_arg_list(ts, func->self->func_args(), node.call_args(), func->const_args, node.call.const_args)) {
                    resolved = true;
                    node.tid = func->self->tdef.func.ret_type;
                    node.call.func_type_id = func->self->tid;
                    node.call.funcdef = func;
                    node.type_error = false;
                    break;
                }
            }

            for (std::size_t i = 0; i < bsym->overload_macros.size(); i++) {
                auto func = bsym->overload_macros[i];
                if (func->num_args == node.call_args().size()) {
                    resolved = true;

                    macro_instantiate(ts, node, func);
                    break;
                }
            }

            if (!resolved) {
                unk_type_error(ts, node.tid, node.pos, "cannot determine type of function call to '%s'", funcname.c_str());
                complement_error(ts, node.pos, "function exists but cannot find a matching argument list");
                for (std::size_t i = 0; i < bsym->overload_funcs.size(); i++) {
                    auto func = bsym->overload_funcs[i];
                    complement_error(ts, node.pos, "candidate #%d: '%s' declared in %s:%d",
                        (i + 1), func_declaration_to_string(func).c_str(), func->self->pos.filename.c_str(), func->self->pos.line_number);
                }
                for (std::size_t i = 0; i < bsym->overload_macros.size(); i++) {
                    auto func = bsym->overload_macros[i];
                    complement_error(ts, node.pos, "candidate #%d: '%s' declared in %s:%d",
                        (bsym->overload_funcs.size() + i + 1), func_declaration_to_string(func).c_str(), func->self->pos.filename.c_str(), func->self->pos.line_number);
                }
                complement_error(ts, node.pos, "call arguments: (%s)", type_list_to_string(node.call.arg_types).c_str());
            }
        }
        else if (bsym) {
            unk_type_error(ts, node.tid, node.pos, "cannot determine type of function call to '%s'", funcname.c_str());
            complement_error(ts, node.pos, "symbol '%s' is not a function", funcname.c_str());
        }
        else {
            // unk_type_error(ts, node.tid, node.pos, "cannot determine type of function call to '%s'", funcname.c_str());
            // complement_error(ts, node.pos, "undefined symbol '%s'", funcname.c_str());
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

void visit_pre_nodes(type_system& ts, ast_node& node) {
    for (auto& child : node.pre_nodes) {
        if (child) {
            child->parent = &node;
            visit_tree(ts, *child);
        }
    }
}

void visit_children(type_system& ts, ast_node& node) {
    for (size_t i = 0; i < node.children.size(); i++) {
        auto& child = node.children[i];
        if (child) {
            child->parent = &node;
            visit_tree(ts, *child);

            for (auto& [idx, newchild] : node.children_to_add) {
                newchild->parent = &node;
                if (idx == -1) {
                    node.children.push_back(std::move(newchild));
                }
                else {
                    node.children.insert(node.children.begin() + idx, std::move(newchild));
                }
            }
            node.children_to_add.clear();
        }
    }
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

std::vector<arena_ptr<ast_node>>* get_compound_block_params(ast_node& compound) {
    if (compound.children.empty()) { return nullptr; }
    if (compound.children[0]->type == ast_type::block_parameter_list) {
        return &compound.children[0]->children;
    }
    return nullptr;
}

arena_ptr<ast_node> make_condition_decl_for_block_param(type_system& ts, ast_node& idnode, arena_ptr<ast_node> cond_node) {
    auto tempname = idnode.id_parts.front();
    auto temp_type = cond_node->tid;
    auto temp = make_var_decl_node_single(*ts.ast_arena, idnode.pos, token_type::let,
        make_identifier_node(*ts.ast_arena, idnode.pos, { tempname }), // id
        make_type_expr_node(*ts.ast_arena, idnode.pos, make_type_resolver_node(*ts.ast_arena, temp_type)), // type
        std::move(cond_node), {}); // value
    temp->local.flags |= local_flag::dont_check_for_duplicates;

    resolve_node_type(ts, temp.get());

    auto ref = make_identifier_node(*ts.ast_arena, temp->pos, { tempname });
    resolve_node_type(ts, ref.get());

    ref->pre_nodes.push_back(std::move(temp));

    return ref;
}

void generate_temp_for_compound_expr(type_system& ts, ast_node& node) {
    auto parent = node.parent;
    auto idx = find_child_index(parent, &node);
    auto self = std::move(parent->children[*idx]);

    auto tempname = generate_temp_name();
    auto temp = make_var_decl_node_single(*ts.ast_arena, node.pos, token_type::let,
        make_identifier_node(*ts.ast_arena, node.pos, { tempname }), // id
        {nullptr, nullptr}, // type
        std::move(self), {}); // value
    temp->local.flags |= local_flag::dont_check_for_duplicates;

    resolve_node_type(ts, temp.get());

    auto ref = make_identifier_node(*ts.ast_arena, temp->pos, { tempname });
    resolve_node_type(ts, ref.get());

    ref->pre_nodes.push_back(std::move(temp));

    parent->children[*idx] = std::move(ref);
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

    node.pre_nodes.push_back(std::move(temp));

    node.desugar_flags |= 1;
}

void generate_temp_for_addr_expr(type_system& ts, ast_node& node, type_id ltype) {
    auto tempname = generate_temp_name();
    auto temp = make_var_decl_node_single(*ts.ast_arena, node.pos, token_type::let,
        make_identifier_node(*ts.ast_arena, node.pos, { tempname }), // id
        make_type_expr_node(*ts.ast_arena, node.pos, make_type_resolver_node(*ts.ast_arena, ltype)), // type
        std::move(node.children[0]), {}); // value
    temp->local.flags |= local_flag::dont_check_for_duplicates;

    resolve_node_type(ts, temp.get());

    auto ref = make_identifier_node(*ts.ast_arena, temp->pos, { tempname });
    resolve_node_type(ts, ref.get());

    node.children[0] = std::move(ref);

    node.pre_nodes.push_back(std::move(temp));

    node.desugar_flags |= 1;
}

void transform_aggregate_call_into_pointer_argument_helper_ts(type_system& ts, ast_node& receiver, ast_node* call) {
    assert(call->tid.valid());

    auto ref = copy_node(ts, &receiver);
    ref->tid = call->tid;

    auto addr = make_address_of_expr(ts, std::move(ref));
    addr->tid = get_ptr_type_to(ts, call->tid);

    call->call_args().insert(call->call_args().begin(), std::move(addr));

    //call->tid = get_ptr_type_to(ts, call->tid);
    call->tid = ts.opaque_type;

    call->call.flags |= call_flag::is_aggregate_return;
}

// Generates a temp variable for a call with aggregate return type, returns a ref to the temp variable
arena_ptr<ast_node> generate_temp_for_call_expr(type_system& ts, ast_node& node, type_id ltype) {
    auto tempname = generate_temp_name();
    auto temp_type = get_pure_type_to(ts, node.tid);
    auto temp = make_var_decl_node_single(*ts.ast_arena, node.pos, token_type::let,
        make_identifier_node(*ts.ast_arena, node.pos, { tempname }), // id
        make_type_expr_node(*ts.ast_arena, node.pos, make_type_resolver_node(*ts.ast_arena, temp_type)), // type
        copy_node(ts, &node), {}); // value

    resolve_node_type(ts, temp.get());

    auto ref = make_identifier_node(*ts.ast_arena, temp->pos, { tempname });
    resolve_node_type(ts, ref.get());

    ref->pre_nodes.push_back(std::move(temp));

    return ref;
}

arena_ptr<ast_node> generate_temp_for_ternary_expr(type_system& ts, ast_node& node) {
    auto tempname = generate_temp_name();
    auto temp = make_var_decl_node_single(*ts.ast_arena, node.pos, token_type::let,
        make_identifier_node(*ts.ast_arena, node.pos, { tempname }), // id
        make_type_expr_node(*ts.ast_arena, node.pos, make_type_resolver_node(*ts.ast_arena, node.tid)), // type
        make_init_tag_node(*ts.ast_arena, {}, token_type::noinit), {}); // value
    resolve_node_type(ts, temp.get());

    auto ref = make_identifier_node(*ts.ast_arena, temp->pos, { tempname });
    resolve_node_type(ts, ref.get());

    auto ifstmt = transform_ternary_expr_into_if_statement(ts, node, *ref);
    resolve_node_type(ts, ifstmt.get());

    ifstmt->temps.push_back(std::move(temp));
    ref->pre_nodes.push_back(std::move(ifstmt));
    return ref;
}

static bool g_inside_loop;

bool type_check_identifier(type_system& ts, ast_node& node) {
    if (ts.subpass != DESUGAR_SUBPASS) {
        visit_pre_nodes(ts, node);
    }

    if (node.lvalue.symbol && node.lvalue.symbol->kind == symbol_kind::overloaded_func_base) {
        return false;
    }

    resolve_identifier(ts, node);

    if (node.tid == ts.quote_type) {
        ast_node* arg = std::get<ast_node*>(node.lvalue.symbol->ctvalue);
        auto copy = copy_node(ts, arg);
        copy->parent = node.parent;
        auto idx = find_child_index(node.parent, &node);
        node.parent->children[*idx] = std::move(copy);
        resolve_node_type(ts, node.parent->children[*idx].get());
    }

    return true;
}

void type_check_qualified_identifier(type_system& ts, ast_node& node, bool change_to_identifier) {
    auto& modid = node.children[0];
    auto& compid = node.children[1];
    auto modalias = modid->id_parts.front();
    auto modpath = modid->lvalue.symbol->module_path;
    scope_def* modscope = ts.module_scopes[modpath];
    if (modscope == nullptr) { return; } // module not traversed yet

    auto it = modscope->symbols.find(string_hash{ compid->id_parts.front() });
    if (it == modscope->symbols.end() || it->second->vis != decl_visibility::public_) {
        add_type_error(ts, node.pos, "undefined '%s' from '%s' (module '%s')", compid->id_parts.front().c_str(), modalias.c_str(), modpath.str.c_str());
        return;
    }
    resolve_identifier_with_symbol(ts, node, it->second.get());
    if (node.lvalue.self && change_to_identifier) {
        node.type = ast_type::identifier;
        node.id_parts.push_back(node.children[0]->id_parts.front());
        node.id_parts.push_back(node.children[1]->id_parts.front());
    }
}

void type_check_type_identifier(type_system& ts, ast_node& node, bool change_to_identifier) {
    auto& tynode = node.children[0];
    auto& compid = node.children[1];
    auto tid = type_id{ tynode->lvalue.symbol->scope, tynode->lvalue.symbol->type_index };

    scope_def* modscope = &tid.get().self->scope;
    if (modscope == nullptr) { return; } // module not traversed yet

    auto it = modscope->symbols.find(string_hash{ compid->id_parts.front() });
    if (it == modscope->symbols.end() || it->second->vis != decl_visibility::public_) {
        add_type_error(ts, node.pos, "undefined '%s' from type '%s'", compid->id_parts.front().c_str(), type_to_string(tid).c_str());
        return;
    }
    resolve_identifier_with_symbol(ts, node, it->second.get());
    if (node.lvalue.self && change_to_identifier) {
        node.type = ast_type::identifier;
        node.id_parts.push_back(node.children[0]->id_parts.front());
        node.id_parts.push_back(node.children[1]->id_parts.front());
    }
}

void type_check_binary_expr(type_system& ts, ast_node& node) {
    if (node.op == token_type::arrow_right) {
        process_thread_first_expr(ts, node);
        return;
    }

    if (is_assignment_sugar_op(node.op)) {
        desugar_assignment(ts, node);
    }

    visit_children(ts, node);

    if (is_logic_binary_op(node)) {
        ensure_bool_op_is_comparison(ts, node);
    }

    // TODO: check operators make sense for types
    node.type_error = (node.children[0]->type_error || node.children[1]->type_error);
    node.tid = get_value_node_type(ts, node);
}

bool is_deref_op(const ast_node& node) { return node.type == ast_type::unary_expr && token_to_char(node.op) == DEREF_OP; }

void type_check_unary_expr(type_system& ts, ast_node& node) {
    visit_pre_nodes(ts, node);
    visit_children(ts, node);
    node.type_error = node.children[0]->type_error;

    if (token_to_char(node.op) == DEREF_OP) {
        // deref expression

        if (!(node.children[0]->tid.valid() && is_pointer(node.children[0]->tid))) {
            add_type_error(ts, node.children[0]->pos,
                "right-side of unary '%c' (deref operation) has type '%s', it must be a pointer",
                DEREF_OP, type_to_string(node.children[0]->tid).c_str());
            node.type_error = true;
        }
        else {
            node.lvalue.self = &node;
            node.tid = node.children[0]->tid.get().elem_type;
            node.type_error = false;
        }
    }
    else if (token_to_char(node.op) == ADDR_OP) {
        // addressof expression

        if (!(node.children[0]->tid.valid())) {
            node.type_error = true;
            return;
        }

        if (node.children[0]->type != ast_type::identifier
            && node.children[0]->type != ast_type::field_expr
            && node.children[0]->type != ast_type::index_expr
            && node.children[0]->type != ast_type::int_literal
            && node.children[0]->type != ast_type::nil_literal
            && node.children[0]->type != ast_type::char_literal
            && node.children[0]->type != ast_type::bool_literal
            && !is_deref_op(*node.children[0])
        ) {
            generate_temp_for_addr_expr(ts, node, node.children[0]->tid);
        }

        if (!node.children[0]->lvalue.self) {
            add_type_error(ts, node.children[0]->pos,
                "right-side of unary '%c' (addressof operation) must be an lvalue (identifier, index expression)",
                ADDR_OP);
            node.type_error = true;
        }
        else {
            auto elem_type = node.children[0]->tid;
            if (elem_type.get().flags & (type_flags::is_in | type_flags::is_out)) {
                elem_type = node.children[0]->tid.get().elem_type;
                node.children[0] = make_deref_expr(ts, std::move(node.children[0]));
                node.children[0]->parent = &node;
                resolve_node_type(ts, node.children[0].get());
            }

            node.tid = get_ptr_type_to(ts, elem_type);
            node.type_error = false;
        }
    }
    else if (node.op == token_type::not_) {
        if (!node.children[0]->tid.valid() || node.children[0]->type_error) {
            node.type_error = true;
        }
        else if (!is_boolish_type(ts, node.children[0]->tid)) {
            add_type_error(ts, node.pos, "right side of unary 'not' has type '%s', it must be a bool, enumflags or error",
                type_to_string(node.children[0]->tid).c_str());
            node.type_error = true;
        }
        else {
            node.tid = ts.bool_type;
        }

        ensure_bool_op_is_comparison_unary(ts, node);
    }
    else if (node.op == token_from_char('-') || node.op == token_from_char('~')) {
        if (!node.children[0]->tid.valid() || !(node.children[0]->tid.get().kind == type_kind::integral)) {
            add_type_error(ts, node.pos, "right side of unary '%c' has type '%s', it must be an integer",
                token_to_char(node.op), type_to_string(node.children[0]->tid).c_str());
            return;
        }

        node.tid = node.children[0]->tid;
        node.type_error = node.children[0]->type_error;
    }
    else {
        node.tid = node.children[0]->tid;
        node.type_error = node.children[0]->type_error;
    }
}

void type_check_call_expr(type_system& ts, ast_node& node) {
    if (!node.call.self) {
        node.call.self = &node;
    }
    auto funcname = node_to_string(*node.call_func());

    bool args_resolved = true;
    int argindex = 0;
    node.call.arg_types.clear();
    for (auto& arg : node.call_args()) {
        resolve_node_type(ts, arg.get());
        if (arg->tid == invalid_type || arg->type_error) {
            node.type_error = true;
            //complement_error(ts, arg->pos, "in the #%d argument for function call to '%s'", argindex+1, funcname.c_str());
            if (arg->tid == invalid_type) {
                args_resolved = false;
                break;
            }
        }
        else {
            node.call.arg_types.push_back(arg->tid);
        }
        argindex++;
    }

    visit_tree(ts, *node.call_func());
    if (node.call_func()->type == ast_type::identifier && !node.call_func()->tid.valid()) {
        if (args_resolved) {
            // both args and func resolved
            resolve_call_funcdef(ts, node);
        }

        if (!node.call.funcdef) {
            //printf("asda");
        }
    }
    else if (node.call_func()->tid.valid() && node.call_func()->tid.get().kind == type_kind::func_pointer) {
        node.tid = node.call_func()->tid.get().func.ret_type;
        node.call.func_type_id = node.call_func()->tid;
        node.type_error = false;
    }

    bool is_parent_var_decl = node.parent->type == ast_type::var_decl;
    if (!is_parent_var_decl && !is_assignment(*node.parent) && is_aggregate(get_alias_root(ts, node.tid))) {
        auto ref = generate_temp_for_call_expr(ts, node, node.tid);
        auto idx = find_child_index(node.parent, &node);
        if (idx) {
            auto parent = node.parent;
            parent->children[*idx] = std::move(ref);
        }
    }
}

void type_check_return_stmt(type_system& ts, ast_node& node) {
    if (ts.inside_defer) {
        add_type_error(ts, node.pos, "illegal use of return statement inside defer statement");
        node.type_error = true;
    }

    if (!node.children.front()) {
        node.tid = ts.opaque_type;
    }
    else {
        node.tid = resolve_node_type(ts, node.children.front().get());
        if (!node.tid.valid() || node.type_error) {
            auto funcname = node_to_string(
                *(find_nearest_scope_local(ts, scope_kind::func_body)->self->func_id())
            );
            //complement_error(ts, node.pos, "in return statement of function '%s'", funcname.c_str());
        }
    }

    // TODO: check if scope / sanity check
    auto scope = find_nearest_scope_local(ts, scope_kind::func_body);

    bool exists = false;
    for (auto ret : scope->self->func.return_statements) {
        if (ret == &node) {
            exists = true;
            break;
        }
    }
    if (!exists) {
        scope->self->func.return_statements.push_back(&node);
    }

    if (ts.current_scope->kind == scope_kind::func_body) {
        ts.current_scope->self->func.has_root_return_statements = true;
    }
}

void type_check_compute_stmt(type_system& ts, ast_node& node) {
    auto cmpd = find_first_compound_expr(node);
    if (!cmpd) {
        add_type_error(ts, node.pos, "compute statement outside of compound expression");
        return;
    }

    node.children[0]->parent = &node;
    resolve_node_type(ts, node.children.front().get());
    node.tid = node.children.front()->tid;
    if (!node.tid.valid() || node.type_error) {
        return;
    }

    if (cmpd->tid.valid() && !is_assignable_to(ts, node.tid, cmpd->tid)) {
        add_type_error(ts, node.pos, "compute statement of incompatible type '%s'", type_to_string(node.tid).c_str());
        complement_error(ts, node.pos, "previous compute statements had type '%s'", type_to_string(cmpd->tid).c_str());
        return;
    }
    cmpd->tid = node.tid;

    auto assignee = ts.assignee_stack.top();
    if (!assignee) {
        add_type_error(ts, node.pos, "compute statement without destination");
        return;
    }

    // Transform this into an assignment statement
    node.type = ast_type::assign_stmt;
    node.as_expr = true;
    node.children.push_back({ nullptr, nullptr });
    node.children[1] = std::move(node.children[0]);
    node.children[0] = copy_node(ts, assignee);
}

void type_check_if_or_cond_stmt(type_system& ts, ast_node& node) {
    if (node.as_expr) {
        if (node.parent->type != ast_type::assign_stmt && node.parent->type != ast_type::var_decl) {
            generate_temp_for_compound_expr(ts, node);
            return;
        }
    }

    bool prevloop = g_inside_loop;
    if (node.type == ast_type::for_cond_stmt) {
        g_inside_loop = true;
    }

    if (node.scope.kind == scope_kind::invalid) {
        add_block_scope(ts, node, node);
    }
    else {
        enter_scope_local(ts, node);
    }

    if (node.children[0]) node.children[0]->parent = &node;
    if (node.children[1]) node.children[1]->parent = &node;
    if (node.children.size() == 3) if (node.children[2]) node.children[2]->parent = &node;

    visit_tree(ts, *node.children[0]);

    auto [cond_value, ok] = node_to_const_value_fold(ts, *node.children[0], /*emit_error=*/false);
    if (ok && node.type == ast_type::if_stmt && std::holds_alternative<comp_int_type>(cond_value)) {
        auto idx = find_child_index(node.parent, &node);
        if (std::get<comp_int_type>(cond_value)) {
            printf("If statement evaluated to true - %s\n", node_to_string(*node.children[0]).c_str());
            visit_tree(ts, *node.children[1]);
            node.parent->children_to_add.push_back({ *idx, std::move(node.children[1]) });
        }
        else {
            printf("If statement evaluated to false - %s\n", node_to_string(*node.children[0]).c_str());
            if (node.children.size() == 3) {
                visit_tree(ts, *node.children[2]);
                node.parent->children_to_add.push_back({ *idx, std::move(node.children[2]) });
            }
        }
        node.disabled = true;
    }
    else {
        visit_children(ts, node);

        g_inside_loop = prevloop;

        const char* stmt = (node.type == ast_type::if_stmt) ? "if" : "for";
        if (!node.children[0]->tid.valid() || node.children[0]->type_error) {
            //complement_error(ts, node.pos, "in %s statement condition", stmt);
            node.type_error = true;
        }
        else if (!is_boolish_type(ts, node.children[0]->tid)) {
            add_type_error(
                ts,
                node.pos,
                "%s statement condition has type '%s'. It must have bool, enumflags or error type",
                stmt,
                type_to_string(node.children[0]->tid).c_str()
            );
            node.type_error = true;
        }

        // At this point, the type of the condition is resolved if (node.type_error == false)

        constexpr int CONDITION_PARAM_FLAG = 0x20;
        if (node.children[0]->tid.valid() && !(node.desugar_flags & CONDITION_PARAM_FLAG)) {
            auto params = get_compound_block_params(*node.children[1]);
            if (params && params->size() != 1) {
                add_type_error(ts, node.pos, "%s statement supports only 1 block parameter", stmt);
                node.type_error = true;
            }
            else if (params) {
                node.children[0] = make_condition_decl_for_block_param(ts, *params->front(), std::move(node.children[0]));
            }
            node.desugar_flags |= CONDITION_PARAM_FLAG;
        }

        if (!node.type_error && !is_bool_op(*node.children[0])) {
            node.children[0] = make_neq_false_node(ts, std::move(node.children[0]));
        }
    }

    leave_scope_local(ts);
}

void type_check_field_expr(type_system& ts, ast_node& node, bool change_to_identifier) {
    auto fieldid = build_identifier_value(node.children[1]->id_parts);

    node.children[0]->parent = &node;
    resolve_node_type(ts, node.children[0].get());

    if (!node.children[0]->tid.valid()) {
        //printf("invalid field_expr: %s\n", fieldid.c_str());
        //exit(1);
    }

    if (node.children[0]->tid.valid() && node.children[0]->tid.get().kind == type_kind::module_) {
        type_check_qualified_identifier(ts, node, change_to_identifier);
        return;
    }

    if (node.children[0]->tid.valid() && node.children[0]->tid.get().kind == type_kind::type) {
        type_check_type_identifier(ts, node, change_to_identifier);
        return;
    }

    if (node.children[0]->tid.valid()) {
        auto ltype = node.children[0]->tid;
        auto stype = ltype;

        // Generate a temp variable if it's not a lvalue
        if (!node.desugar_flags) {
            if (node.children[0]->type == ast_type::call_expr && is_aggregate_root(ltype)) {
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
            if (is_pointer_type(stype) && is_aggregate(stype.get().elem_type)) {
                is_struct = true;
                is_pointer = true;
                stype = stype.get().elem_type;
            }
            else if ((stype.get().flags & type_flags::is_pure) && is_aggregate(stype.get().elem_type)) {
                stype = stype.get().elem_type;
                is_struct = true;
            }
            else if (is_aggregate(stype)) {
                is_struct = true;
            }
        }
        assert(stype.valid());

        if (stype.get().kind == type_kind::tuple && (fieldid == "len")) {
            node.type = ast_type::int_literal;
            node.int_value = stype.get().structure.fields.size();
            node.tid = ts.int_type;
            node.children.clear();
            return;
        }
        else if (stype.get().kind == type_kind::static_array && (fieldid == "len")) {
            node.type = ast_type::int_literal;
            node.int_value = stype.get().array.length;
            node.tid = ts.int_type;
            node.children.clear();
            return;
        }

        int field_index = aggregate_find_field(stype, fieldid);
        if (is_struct && field_index != -1) {
            node.lvalue.self = &node;
            node.field.self = &node;
            node.field.is_optional = is_optional;
            node.field.field_index = field_index;
            node.tid = stype.get().structure.fields[field_index].type;

            if (ltype.get().kind == type_kind::input || (stype.get().flags & type_flags::is_pure)) {
                node.tid = get_pure_type_to(ts, node.tid);
            }
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
}

void type_check_index_expr(type_system& ts, ast_node& node) {
    visit_children(ts, node);

    bool arr = false;
    bool sli = false;
    bool ptr = false;
    bool inout = false;
    bool tup = false;

    if (node.children[0]->tid.valid()) {
        arr = node.children[0]->tid.get().kind == type_kind::static_array;
        sli = node.children[0]->tid.get().kind == type_kind::array;
        ptr = node.children[0]->tid.get().kind == type_kind::ptr;
        tup = node.children[0]->tid.get().kind == type_kind::tuple;
        inout = (node.children[0]->tid.get().flags & (type_flags::is_in | type_flags::is_out));
    }

    bool error = false;
    {
        const char* msg = "left-side of index expression has type '%s', it must be an array, arrayview or pointer";
        if (!node.children[0]->tid.valid()) {
            complement_error(ts, node.pos, msg, type_to_string(node.children[0]->tid).c_str());
            error = true;
        }
        else if (!(arr || ptr || tup || sli || inout)) {
            add_type_error(ts, node.pos, msg, type_to_string(node.children[0]->tid).c_str());
            error = true;
        }
    }

    {
        const char* msg = "right-side of index expression has type '%s', it must be an integer or range expression";
        if (node.children[1]->range.self) {
            error = false;
        }
        else if (!node.children[1]->tid.valid()) {
            complement_error(ts, node.pos, msg, type_to_string(node.children[1]->tid).c_str());
            error = true;
        }
        else if ((arr || ptr || sli) && !(node.children[1]->tid.get().kind == type_kind::integral || node.children[1]->tid.get().kind == type_kind::tuple)) {
            add_type_error(ts, node.pos, msg, type_to_string(node.children[1]->tid).c_str());
            error = true;
        }
        else if (tup && !(node.children[1]->tid.get().kind == type_kind::integral)) {
            add_type_error(ts, node.pos, msg, type_to_string(node.children[1]->tid).c_str());
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
            if (node.children[1]->range.self) {
                // slice operation
                transform_slice_expr_to_init_expr(ts, node, false);
            }
            else {
                node.lvalue.self = &node;
                node.tid = node.children[0]->tid.get().elem_type;
                if (node.children[0]->tid.get().flags & type_flags::is_pure) {
                    node.tid = get_pure_type_to(ts, node.children[0]->tid.get().elem_type.get().elem_type);
                }
            }
        }
        else if (sli) {
            node.lvalue.self = &node;
            node.tid = node.children[0]->tid.get().elem_type;
            if (node.children[0]->tid.get().flags & type_flags::is_pure) {
                node.tid = get_pure_type_to(ts, node.children[0]->tid.get().elem_type.get().elem_type);
            }

            auto field = make_struct_field_access(*ts.ast_arena, std::move(node.children[0]), "ptr");
            resolve_node_type(ts, field.get());
            node.children[0] = std::move(field);
        }
        else if (inout) {
            auto deref = make_deref_expr(ts, std::move(node.children[0]));
            resolve_node_type(ts, deref.get());
            node.children[0] = std::move(deref);

            resolve_node_type(ts, &node);
        }
        else if (tup) {
            const auto& fields = get_type_fields(node.children[0]->tid);
            if (node.children[1]->int_value >= fields.size()) {
                node.type_error = true;
                add_type_error(ts, node.pos, "tuple index out of bounds, type '%s' has only %d fields",
                    type_to_string(node.children[0]->tid).c_str(), (int)fields.size());
            }
            else {
                node.lvalue.self = &node;

                int findex = node.children[1]->int_value;
                const auto& field = fields[findex];

                node.children[1] = make_identifier_node(*ts.ast_arena, node.children[1]->pos, { field.names.front() });
                node.field.self = &node;
                node.field.field_index = findex;
                node.type = ast_type::field_expr;
                node.tid = field.type;
            }
        }
    }
}

void type_check_init_expr(type_system& ts, ast_node& node) {
    type_id receiver_type{};

    if (node.children[0]) {
        node.children[0]->parent = &node;
        visit_tree(ts, *node.children[0]);
        receiver_type = node.children[0]->tid;
    }
    else {
        receiver_type = top_receiver_type(ts);
    }

    node.initlist.deduce_to_tuple = !receiver_type.valid();
    if (node.initlist.deduce_to_tuple && !node.tid.valid()) {
        std::vector<const_value> elem_types;
        bool all_resolved = true;
        type_id first_type{};
        for (auto& child : node.children[1]->children) {
            resolve_node_type(ts, child.get());
        }
        for (auto& child : node.children[1]->children) {
            resolve_node_type(ts, child.get());
            if (!child->tid.valid()) {
                all_resolved = false;
            }
            else {
                if (first_type.valid() && !is_assignable_to(ts, child->tid, first_type)) {
                    add_type_error(ts, child->pos, "array initializer element has incompatible type '%s'", type_to_string(child->tid).c_str());
                    complement_error(ts, node.pos, "previous elements had type '%s'", type_to_string(first_type).c_str());
                    all_resolved = false;
                }
                else {
                    elem_types.push_back(child->tid);
                    first_type = child->tid;
                }
            }
        }
        if (all_resolved) {
            // TODO: resolve to array of single type or array of variants
            node.tid = get_static_array_type(ts, elem_types.size(), first_type);
        }
    }
    else if (receiver_type.valid() && is_aggregate_type(receiver_type)) {
        if (receiver_type.get().kind == type_kind::static_array && receiver_type.get().array.deduce_size) {
            std::vector<const_value> args;
            args.push_back(comp_int_type(node.children[1]->children.size()));
            args.push_back(receiver_type.get().elem_type);
            receiver_type = execute_builtin_type_constructor(ts, *ts.static_array_type_constructor, args);
        }

        const auto& fields = receiver_type.get().structure.fields;
        int narg = 0;
        bool did_error = false;
        for (auto& child : node.children[1]->children) {
            if (narg >= fields.size()) break;

            push_receiver_type(ts, fields[narg].type);
            resolve_node_type(ts, child.get());
            pop_receiver_type(ts);

            if (!is_assignable_to(ts, child->tid, fields[narg].type)) {
                add_type_error(ts, child->pos, "cannot assign value of type '%s' to '%s'",
                    type_to_string(child->tid).c_str(), type_to_string(fields[narg].type).c_str());
                did_error = true;
            }

            narg++;
        }
        if (did_error) return;

        if (ts.current_scope->kind == scope_kind::module_) {
            for (int fi = narg; fi < fields.size(); fi++) {
                const auto& field = fields[fi];

                auto zerovalue = get_zero_value_node_for_type(ts, field.type);
                assert(zerovalue.get());

                node.children[1]->children.push_back(std::move(zerovalue));
            }
        }

        node.tid = receiver_type;
    }
}

type_id resolve_node_type(type_system& ts, ast_node* nodeptr) {
    if (!nodeptr) return invalid_type;

    auto& node = *nodeptr;
    bool check_for_unresolved = true;

    switch (node.type) {
    case ast_type::imports_decl: {
        check_for_unresolved = false;

        if (ts.pass == type_system_pass::resolve_literals_and_register_declarations && ts.subpass == 0) {
            auto scope = ts.current_scope;
            auto qual_name = string_hash{ std::string{node.children[0]->string_value} };

            std::optional<string_hash> aliastr{};
            if (node.children[1]) {
                aliastr = string_hash{ build_identifier_value(node.children[1]->id_parts) };
                scope->imports_map[*aliastr] = scope->imports.size();
                declare_module_symbol(ts, *aliastr, *node.children[1], qual_name);
            }
            else {
                scope->imports_map[qual_name] = scope->imports.size();
            }

            scope->imports.push_back(scope_import{ scope_import_type::module_, node.pos, qual_name, aliastr });
        }
        break;
    }
    case ast_type::error_decl: {
        check_for_unresolved = false;

        if (node.tid.valid()) { break; }

        node.tid = ts.error_type;

        for (auto& idnode : node.children) {
            auto id = string_hash{ build_identifier_value(idnode->id_parts) };
            uint32_t mmhash = hash(id.str.c_str(), id.str.size());
            const_value value = mmhash;
            declare_const_symbol(ts, id, value, node.tid);
            idnode->lvalue.symbol = find_symbol_in_current_scope(ts, id);
        }
        break;
    }
    case ast_type::c_struct_decl: {
        check_for_unresolved = false;

        node.tdef.name = string_hash{ build_identifier_value(node.children[0]->id_parts) };
        node.tdef.mangled_name = string_hash{ build_identifier_value(node.children[0]->id_parts) };
        node.tdef.size = 0;
        node.tdef.is_opaque = true;

        type_id new_type_id{};
        if (!node.tdef.self) {
            auto sym = find_symbol_in_current_scope(ts, node.tdef.mangled_name);
            if (sym) {
                add_type_error(ts, node.pos, "cannot re-declare type '%s'", node.tdef.mangled_name.str.c_str());
                break;
            }
            new_type_id = register_user_type(ts, node);
        }
        else {
            new_type_id = node.tdef.id;
        }

        node.tdef.self = &node;

        bool all_resolved = true;
        std::vector<struct_field> sfields;

        for (auto& field : node.children[1]->children) {
            assert(field->type == ast_type::c_struct_field);
            resolve_node_type(ts, field.get());
            if (field->tid.valid()) {
                sfields.push_back(struct_field{ { std::string{field->id_parts.back()} }, field->tid, 0 });
            }
            else {
                all_resolved = false;
            }
        }

        if (all_resolved && !node.tid.valid()) {
            auto& td = node.tdef;
            td.kind = type_kind::c_structure;
            td.structure.fields = sfields;
            td.id = new_type_id;
            td.self = &node;
            td.is_opaque = false;

            compute_struct_size_alignment_offsets(td);

            node.type_error = false;
        }
        else {
            node.type_error = true;
        }
        break;
    }
    case ast_type::c_struct_field: {
        check_for_unresolved = false;

        if (node.tid.valid()) {
            break;
        }

        bool is_unsigned = false;
        type_id our_type = ts.int32_type;
        int pointer_level = 0;

        for (int i = 0; i < node.id_parts.size() - 1; i++) {
            const auto& part = node.id_parts[i];
            if (part == "unsigned") {
                is_unsigned = true;
            }
            else if (part == "*") {
                pointer_level++;
            }
            else if (part == "long" || part == "int64_t") {
                our_type = ts.int64_type;
            }
            else if (part == "int" || part == "int32_t") {
                our_type = ts.int32_type;
            }
            else if (part == "short" || part == "int16_t") {
                our_type = ts.int16_type;
            }
            else if (part == "char" || part == "int8_t") {
                our_type = ts.int8_type;
            }
            else if (part == "uint64_t") {
                is_unsigned = true;
                our_type = ts.int64_type;
            }
            else if (part == "uint32_t") {
                is_unsigned = true;
                our_type = ts.int32_type;
            }
            else if (part == "uint16_t") {
                is_unsigned = true;
                our_type = ts.int16_type;
            }
            else if (part == "uint8_t") {
                is_unsigned = true;
                our_type = ts.int8_type;
            }
            else if (part == "size_t") {
                our_type = ts.usize_type;
            }
            else {
                auto sym = find_symbol(ts, { {""}, string_hash{part} });
                if (sym && sym->kind == symbol_kind::type) {
                    our_type = to_type_id(*sym);
                }
            }
        }

        type_id current_type = is_unsigned ? get_unsigned_type(ts, our_type) : our_type;
        for (int i = 0; i < pointer_level; i++) {
            current_type = get_ptr_type_to(ts, current_type);
        }

        node.tid = current_type;
        break;
    }
    case ast_type::type_decl: {
        check_for_unresolved = false;

        node.tdef.name = string_hash{ build_identifier_value(node.children[0]->id_parts) };
        node.tdef.mangled_name = string_hash{ build_identifier_value(node.children[0]->id_parts) };
        node.tdef.size = 0;
        node.tdef.is_opaque = true;

        bool is_new = false;

        type_id new_type_id{};
        if (!node.tdef.self) {
            auto sym = find_symbol_in_current_scope(ts, node.tdef.mangled_name);
            if (sym) {
                add_type_error(ts, node.pos, "cannot re-declare type '%s'", node.tdef.mangled_name.str.c_str());
                break;
            }
            new_type_id = register_user_type(ts, node);
            is_new = true;
        }
        else {
            new_type_id = node.tdef.id;
        }

        if (is_new) {
            add_type_scope(ts, node, node);
        }
        else {
            enter_scope_local(ts, node);
        }

        node.tdef.self = &node;

        if (node.children[1]) {
            bool is_enum_decl = (node.children[1]->children[0]->type == ast_type::enum_type);

            visit_tree(ts, *node.children[1]);

            auto type = node.children[1]->tid;
            if (type.valid()) {
                node.tdef = type.get();
                node.tdef.id = new_type_id;
                node.tdef.self = &node;
                node.tdef.is_opaque = false;
                node.tdef.name = string_hash{ build_identifier_value(node.children[0]->id_parts) };
                node.tdef.mangled_name = string_hash{ build_identifier_value(node.children[0]->id_parts) };

                // If it's an enum we need to treat this as an alias, because the enum symbols have the 'anonymous enum' type
                if (is_enum_decl) {
                    // Propagate back the enum name
                    type.get().name = node.tdef.name;
                    type.get().mangled_name = node.tdef.mangled_name;
                }

                bool is_alias = node.int_value == 1;
                if (is_alias || is_enum_decl) {
                    node.tdef.alias_to = type;
                }
                //register_user_type(ts, node);
            }
            else {
                //complement_error(ts, node.pos, "in type declaration '%s'", node_to_string(node).c_str());
            }
        }

        leave_scope_local(ts);

        break;
    }
    case ast_type::type_constructor_decl: {
        check_for_unresolved = false;

        node.tdef.self = &node;
        node.tdef.name = string_hash{ build_identifier_value(node.children[0]->id_parts) };
        node.tdef.mangled_name = string_hash{ build_identifier_value(node.children[0]->id_parts) };
        node.tdef.kind = type_kind::constructor;

        type_constructor* type_ctor = &node.tdef.constructor;
        type_ctor->self = &node;

        type_ctor->func = [&ts, ctor = &node](const std::vector<const_value>& args) -> arena_ptr<ast_node> {
            // TODO: check number of args match and everything.
            // TODO: allow type constructor 'body' form, that returns a type at the end but has arbitrary code in it.

            auto arg_list = copy_node(ts, ctor->children[1].get());
            auto content = copy_node(ts, ctor->children[2].get());
            add_type_scope(ts, *content, *content);

            for (std::size_t i = 0; i < arg_list->children.size(); i++) {
                auto& ctor_arg_node = *arg_list->children[i];
                type_id arg_type = ts.type_type;//TODO: get_comptime_arg_type(ctor_arg_node);
                if (arg_type.get().kind == type_kind::type) {
                    auto instance_targ = std::get<type_id>(args[i]);
                    declare_const_symbol(ts, string_hash{ build_identifier_value(ctor_arg_node.var_id()->id_parts) }, instance_targ, arg_type);
                }
                else {
                    assert(!"user type constructor arg type not handled");
                }
            }

            resolve_node_type(ts, content.get()); 

            // Copy the type def from the type expr content
            content->tdef = content->children[0]->tdef;
            content->tdef.name = build_type_constructor_name(ctor->tdef.name.str, args);
            content->tdef.mangled_name = build_type_constructor_mangled_name(ctor->tdef.mangled_name.str, args);

            leave_scope_local(ts);
            return std::move(content);
        };

        register_user_type(ts, node);
        break;
    }
    case ast_type::type_expr: {
        if (ts.pass != type_system_pass::perform_checks && node.tid != invalid_type) return node.tid;

        node.tid = get_type_expr_node_type(ts, *node.children[0]);
        if (!node.tid.valid()) {
            auto str = node_to_string(node);
            unk_type_error(ts, node.tid, node.pos, "unknown type '%s'", str.c_str());
        }
        break;
    }
    case ast_type::const_expr: {
        if (ts.pass != type_system_pass::perform_checks && node.tid != invalid_type) return node.tid;

        type_id tid{};
        if (node.children[0]->type == ast_type::type_expr) {
            tid = get_type_expr_node_type(ts, *node.children[0]->children[0]);
        }

        if (tid.valid()) {
            node.tid = ts.type_type;
            node.type_error = false;
        }
        else {
            add_type_error(ts, node.pos, "invalid const expression");
        }
        break;
    }
    case ast_type::macro_instance: {
        check_for_unresolved = false;
        if (node.scope.kind == scope_kind::invalid) {
            add_block_scope(ts, node, node);
        }
        else {
            enter_scope_local(ts, node);
        }
        visit_children(ts, node);
        leave_scope_local(ts);
        break;
    }
    case ast_type::compound_stmt: {
        if (node.as_expr) {
            if (node.parent->type != ast_type::assign_stmt && node.parent->type != ast_type::var_decl) {
                generate_temp_for_compound_expr(ts, node);
                break;
            }
        }
        else {
            check_for_unresolved = false;
        }

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
    case ast_type::block_parameter_list: {
        check_for_unresolved = false;
        break;
    }
    case ast_type::return_stmt: {
        type_check_return_stmt(ts, node);
        break;
    }
    case ast_type::compute_stmt: {
        type_check_compute_stmt(ts, node);
        break;
    }
    case ast_type::continue_stmt:
    case ast_type::break_stmt: {
        check_for_unresolved = false;
        if (!g_inside_loop) {
            const char* stmt = (node.type == ast_type::continue_stmt) ? "continue" : "break";
            add_type_error(ts, node.pos, "'%s' statement can only be used inside a for statement", stmt);
        }
        break;
    }
    case ast_type::for_numeric_stmt: {
        node.children[0]->parent = &node;
        node.children[1]->parent = &node;
        node.children[2]->parent = &node;

        check_for_unresolved = false;
        visit_tree(ts, *node.children[1]);

        if (ts.pass == type_system_pass::resolve_literals_and_register_declarations) {
            add_block_scope(ts, node, *node.children[2]);
        }
        else {
            enter_scope_local(ts, node);
        }

        for (auto& pn : node.pre_nodes) {
            visit_tree(ts, *pn);
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
    case ast_type::for_cond_stmt: {
        check_for_unresolved = node.as_expr;
        type_check_if_or_cond_stmt(ts, node);
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
    case ast_type::macro_decl: {
        register_macro_declaration_node(ts, node);
        node.disabled = true;
        check_for_unresolved = false;
        break;
    }
    case ast_type::func_decl: {
        if (ts.pass == type_system_pass::resolve_literals_and_register_declarations) {
            register_func_declaration_node(ts, node);
        }
        else {
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
        break;
    }
    case ast_type::func_expr: {
        assert(!"unreachable");
        break;
    }
    case ast_type::func_overload_selector_expr: {
        if (node.func_overload.from_lambda) {
            auto func = node.func_overload.from_lambda;
            node.call.funcdef = &func->func;

            if (func->tdef.id.valid()) {
                node.tid = get_func_pointer_type_to(ts, func->tdef.id);
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
            if (arg->tid == invalid_type || arg->type_error) {
                node.type_error = true;
                //complement_error(ts, arg->pos, "in the #%d type argument for function overload selector '%s'",
                    //argindex + 1, node_to_string(*node.func_overload_fn()).c_str());
                if (arg->tid == invalid_type) {
                    args_resolved = false;
                    break;
                }
            }
            else {
                node.call.arg_types.push_back(arg->tid);
            }
            argindex++;
        }

        if (args_resolved) {
            auto pair = separate_module_identifier(node.func_overload_fn()->id_parts);

            separate_func_overload_selector_args(ts, node);

            for (const auto& linkage : { func_linkage::local_carbon, func_linkage::external_c }) {
                node.call.mangled_name = mangle_func_name(ts, { pair.second.str }, node.call.const_args, node.func_overload_args(), linkage);

                auto sym = find_symbol(ts, { pair.first, node.call.mangled_name });
                if (sym && sym->kind == symbol_kind::top_level_func) {
                    auto local = sym->scope->local_defs[sym->local_index];
                    node.tid = get_func_pointer_type_to(ts, local->self->tdef.id);
                    node.call.funcdef = &local->self->func;
                    node.type_error = false;

                    if (local->flags & local_flag::is_aggregate_argument) {
                        node.tid = node.tid.get().elem_type;
                    }
                    break;
                }
            }
        }

        if (!node.tid.valid()) {
            node.type_error = true;

            auto pair = separate_module_identifier(node.func_overload_fn()->id_parts);
            auto funcname = node_to_string(*node.func_overload_fn());
            auto bsym = find_symbol(ts, pair);
            if (bsym && bsym->kind == symbol_kind::overloaded_func_base) {
                // try to match the arguments performing implicit conversions
                bool resolved = false;
                for (std::size_t i = 0; i < bsym->overload_funcs.size(); i++) {
                    auto func = bsym->overload_funcs[i];
                    if (match_arg_list(ts, func->self->func_args(), node.func_overload_args(), func->const_args, node.call.const_args)) {
                        resolved = true;
                        node.tid = func->self->tdef.func.ret_type;
                        node.call.func_type_id = func->self->tid;
                        node.call.funcdef = func;
                        node.type_error = false;
                        break;
                    }
                }

                if (!resolved) {
                    unk_type_error(ts, node.tid, node.pos, "cannot find function overload for '%s'", funcname.c_str());
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
                unk_type_error(ts, node.tid, node.pos, "cannot find function overload for '%s'", funcname.c_str());
                complement_error(ts, node.pos, "symbol '%s' is not a function", funcname.c_str());
            }
            else {
                unk_type_error(ts, node.tid, node.pos, "cannot find function overload for '%s'", funcname.c_str());
                complement_error(ts, node.pos, "undefined symbol '%s'", funcname.c_str());
            }
        }
        break;
    }
    case ast_type::builtin_call_expr: {
        if (!check_builtin_call(ts, node)) {
            add_type_error(ts, node.pos, "unknown built-in function '%s'", node_to_string(*node.children[0]).c_str());
        }
        break;
    }
    case ast_type::call_expr: {
        type_check_call_expr(ts, node);
        //report_type_error(node.tid, node.pos, "cannot resolve type of function call %s", node_to_string(node));
        break;
    }
    case ast_type::field_expr: {
        type_check_field_expr(ts, node, true);
        break;
    }
    case ast_type::index_expr: {
        type_check_index_expr(ts, node);
        break;
    }
    case ast_type::var_decl: {
        resolve_and_declare_local_variables(ts, node);
        if (!node.tid.valid() || node.type_error) {
            auto name = node_to_string(*node.var_id());
            //complement_error(ts, node.pos, "in declaration of variable '%s'", name.c_str());
        }
        break;
    }
    case ast_type::assign_stmt: {
        node.children[0]->parent = &node;
        node.children[1]->parent = &node;

        visit_tree(ts, *node.children[0]);

        ts.assignee_stack.push(node.children[0].get());
        visit_tree(ts, *node.children[1]);
        ts.assignee_stack.pop();

        resolve_assignment_type(ts, node);
        break;
    }
    case ast_type::identifier: {
        //if (ts.pass != type_system_pass::perform_checks && node.tid != invalid_type) return node.tid;
        check_for_unresolved = type_check_identifier(ts, node);
        break;
    }
    case ast_type::binary_expr: {
        type_check_binary_expr(ts, node);
        break;
    }
    case ast_type::unary_expr: {
        type_check_unary_expr(ts, node);
        break;
    }
    case ast_type::range_expr: {
        check_for_unresolved = false;

        if (node.children[0]->children.size() == 2) {
            node.children[0]->children.push_back(make_int_literal_node(*ts.ast_arena, node.children[0]->pos, 1));
        }
        visit_children(ts, node);

        if (!node.range.self) {
            type_id curtype{};
            for (auto& arg : node.children[0]->children) {
                if (!curtype.valid()) {
                    curtype = arg->tid;
                }
                else {
                    if (!is_assignable_to(ts, arg->tid, curtype)) {
                        add_type_error(ts, node.pos, "cannot have range of different types");
                        complement_error(ts, node.pos, "range has elements of type '%s'", type_to_string(curtype).c_str());
                        complement_error(ts, arg->pos, "argument has type '%s'", type_to_string(arg->tid).c_str());
                        break;
                    }
                }
            }
            node.range.self = &node;
            node.range.start = node.children[0]->children[0].get();
            node.range.end = node.children[0]->children[1].get();
            node.range.step = node.children[0]->children[2].get();

            // TODO: validate that we only use the range expr in expected places
        }
        break;
    }
    case ast_type::init_expr: {
        type_check_init_expr(ts, node);
        break;
    }
    case ast_type::ternary_expr: {
        visit_children(ts, node);
        if (!is_assignable_to(ts, node.if_cond()->tid, ts.bool_type)) {
            add_type_error(ts, node.pos, "ternary expression condition must have 'bool' type");
            node.type_error = true;
            break;
        }

        if (!(node.if_body()->tid.valid() && node.if_else()->tid.valid())) {
            node.type_error = true;
            break;
        }

        try_coerce_to(ts, *node.if_else(), node.if_body()->tid);
        try_coerce_to(ts, *node.if_body(), node.if_else()->tid);

        if (!is_assignable_to(ts, node.if_else()->tid, node.if_body()->tid)) {
            add_type_error(ts, node.pos, "non-compatible types in ternary expression branches: '%s' else '%s'",
                type_to_string(node.if_body()->tid).c_str(), type_to_string(node.if_else()->tid).c_str());
        }

        node.tid = node.if_body()->tid;

        bool is_parent_var_decl = node.parent->type == ast_type::var_decl;
        if (!is_parent_var_decl) {
            auto ref = generate_temp_for_ternary_expr(ts, node);
            auto idx = find_child_index(node.parent, &node);
            if (idx) {
                auto parent = node.parent;
                //ref->pre_children.push_back(std::move(parent->children[*idx]));
                parent->children[*idx] = std::move(ref);
            }
        }
        break;
    }
    case ast_type::cast_expr:
        visit_children(ts, node);
        node.tid = get_value_node_type(ts, node);
        if (node.tid.valid() && node.children[1]->tid.valid()) {
            //node.children[1]->tid = node.tid;
        }
        break;
    case ast_type::string_literal:
        if (!node.tid.valid()) {
            // Transform the string literal into a array of chars
            auto& sym = ts.builtin_scope->scope.symbols[string_hash{ "byte" }];
            auto rstype = to_type_id(*sym);
            auto pure_rstype = get_pure_type_to(ts, rstype);
            auto pointer_type = get_ptr_type_to(ts, pure_rstype);

            auto slicetype = get_array_type_to(ts, pure_rstype);
            //auto pureslicetype = get_pure_type_to(ts, slicetype);
            auto slicetypenode = make_type_expr_node(*ts.ast_arena, node.pos, make_type_resolver_node(*ts.ast_arena, slicetype));

            std::vector<arena_ptr<ast_node>> nodes;
            nodes.push_back(make_string_literal_node(*ts.ast_arena, node.pos, std::string{ node.string_value }));
            nodes.push_back(make_int_literal_node(*ts.ast_arena, node.pos, node.string_value.size()));
            nodes.push_back(make_int_literal_node(*ts.ast_arena, node.pos, node.string_value.size() + 1));
            nodes[0]->tid = pointer_type; // So the created string literal doesn't need to be transformed.

            auto arglist = make_arg_list_node(*ts.ast_arena, node.pos, std::move(nodes));
            auto initlist = make_init_expr_node(*ts.ast_arena, node.pos, std::move(slicetypenode), std::move(arglist));
            initlist->tid = slicetype;

            auto parent = node.parent;
            auto idx = find_child_index(parent, &node);
            if (idx) {
                initlist->parent = parent;
                parent->children[*idx] = std::move(initlist);
            }
        }
        break;
    case ast_type::init_tag: {
        if (node.op == token_type::noinit) {
            node.tid = ts.opaque_type;
        }
        else if (node.op == token_type::placeholder) {
            ast_node* assignee = ts.assignee_stack.top();
            auto idx = find_child_index(node.parent, &node);
            node.parent->children[*idx] = copy_node(ts, assignee);
        }
        break;
    }
    case ast_type::bool_literal:
    case ast_type::int_literal:
    case ast_type::float_literal:
    case ast_type::char_literal:
    case ast_type::nil_literal:
        node.tid = get_value_node_type(ts, node);
        break;
    default: {
        check_for_unresolved = false;
        visit_children(ts, node);
        break;
    }
    }

    if (check_for_unresolved) {
        if (node.tid == invalid_type) {
            //printf("node unresolved: %d\n", (int)node.type);
            ts.unresolved_types = true;
        }
    }
    return node.tid;
}

// Section: final analysis

void remangle_names(type_system& ts, ast_node* nodeptr) {
    if (!nodeptr) return;

    auto& node = *nodeptr;
    switch (node.type) {
    case ast_type::for_numeric_stmt: {
        for (auto& pn : node.pre_nodes) {
            visit_tree(ts, *pn);
        }
        if (node.forinfo.declare_elem_to_range_start) {
            visit_tree(ts, *node.forinfo.declare_elem_to_range_start);
        }
        visit_tree(ts, *node.forinfo.iterstart);
        visit_tree(ts, *node.forinfo.iterstep);
        visit_tree(ts, *node.forinfo.iterend);
        if (node.forinfo.elemref) {
            visit_tree(ts, *node.forinfo.elemref);
        }
        visit_tree(ts, *node.for_body());
        break;
    }
    case ast_type::func_decl: {
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

            node.tdef.mangled_name = mangle_func_name(ts, parts, node.func.const_args, node.func_args(), node.func.linkage);
        }

        if (node.scope.body_node) { enter_scope_local(ts, node); }
        visit_children(ts, node);
        if (node.scope.body_node) { leave_scope_local(ts); }
        break;
    }
    case ast_type::call_expr: {
        visit_pre_nodes(ts, node);
        visit_children(ts, node);

        // update the called function mangled name
        if (node.call.funcdef) {
            node.call.mangled_name = node.call.funcdef->self->tdef.mangled_name;
        }
        else if (node.call.func_type_id.get().kind != type_kind::func_pointer) {
            assert(!"call_expr no funcdef!");
        }
        break;
    }
    case ast_type::func_overload_selector_expr: {
        // update the called function mangled name
        if (node.call.funcdef) {
            node.call.mangled_name = node.call.funcdef->self->tdef.mangled_name;
        }
        else {
            assert(!"func_overload_selector_expr no funcdef!");
        }
        break;
    }
    case ast_type::module_: {
        for (auto& pair : node.scope.symbols) {
            if (pair.second->kind == symbol_kind::global) {
                auto local = get_symbol_local(*pair.second);
                local->mangled_name = mangle_global_name(ts, node.scope.self_module_parts, local->name, local->self->func.linkage);
            }
        }
        visit_pre_nodes(ts, node);
        visit_children(ts, node);
        break;
    }
    case ast_type::block_parameter_list: {
        break;
    }
    default: {
        visit_pre_nodes(ts, node);
        visit_children(ts, node);
        break;
    }
    }
}

void spit_declaration(type_system& ts, ast_node& node, std::ofstream& file) {
    switch (node.type) {
    case ast_type::imports_decl: {
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
                    file << ":" << type_to_string(child->tid);
                    if (i < arg_list->children.size() - 1) {
                        file << ", ";
                    }
                }
            }
            i++;
        }

        file << "):";

        type_id ret_type = node.tdef.func.ret_type;
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
                add_module_error(ts, imp.pos, "a module cannot import itself '%s'", imp.qual_name.str.c_str());
                continue;
            }

            if (imp.type == scope_import_type::module_ && !ts.module_scopes[imp.qual_name]) {
                // "TODO: look for interface file";
                add_module_error(ts, imp.pos, "cannot find module '%s'", imp.qual_name.str.c_str());
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

        type_def& tf = node->tdef;
        tf.kind = type_kind::type;
        tf.name = string_hash{ "type" };
        tf.mangled_name = string_hash{ "type" };
        type_type = register_builtin_type(*this, std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);

        type_def& tf = node->tdef;
        tf.kind = type_kind::quote;
        tf.name = string_hash{ "quote" };
        tf.mangled_name = string_hash{ "quote" };
        quote_type = register_builtin_type(*this, std::move(node));
    }

    // register built-in types
    int_type = register_integral_type<std::intptr_t>(*this, "int");
    byte_type = register_integral_type<std::int8_t>(*this, "byte");
    bool_type = register_integral_like_type<std::int8_t>(*this, "bool", type_kind::boolean);

    uint8_type = register_integral_type<std::uint8_t>(*this, "uint8");
    uint16_type = register_integral_type<std::uint16_t>(*this, "uint16");
    uint32_type = register_integral_type<std::uint32_t>(*this, "uint32");
    uint64_type = register_integral_type<std::uint64_t>(*this, "uint64");
    usize_type = register_integral_type<std::size_t>(*this, "usize");
    isize_type = register_integral_type<std::int64_t>(*this, "isize");
    uintptr_type = register_integral_type<std::uintptr_t>(*this, "uintptr");

    int8_type = register_integral_type<std::int8_t>(*this, "int8");
    int16_type = register_integral_type<std::int16_t>(*this, "int16");
    int32_type = register_integral_type<std::int32_t>(*this, "int32");
    int64_type = register_integral_type<std::int64_t>(*this, "int64");

    register_real_type<float>(*this, "float");
    register_real_type<double>(*this, "double");

    error_type = register_integral_like_type<std::intptr_t>(*this, "error", type_kind::error);

    {
        auto node = make_in_arena<ast_node>(*ast_arena);
        node->tdef.name = string_hash{ "&" };
        node->tdef.mangled_name = string_hash{ "ptr" };
        node->tdef.kind = type_kind::constructor;

        type_constructor* ptr_template = &node->tdef.constructor;
        ptr_template->self = node.get();
        ptr_template->func = [this](const std::vector<const_value>& arg) {
            auto type_arg = std::get<type_id>(arg.front());
            auto node = make_in_arena<ast_node>(*ast_arena);
            type_def& tf = node->tdef;

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
        node->tdef.name = string_hash{ "pure" };
        node->tdef.mangled_name = string_hash{ "pure" };
        node->tdef.kind = type_kind::constructor;

        type_constructor* ptr_template = &node->tdef.constructor;
        ptr_template->self = node.get();
        ptr_template->func = [this](const std::vector<const_value>& arg) {
            auto type_arg = std::get<type_id>(arg.front());
            auto node = make_in_arena<ast_node>(*ast_arena);
            type_def& tf = node->tdef;

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
        node->tdef.name = string_hash{ "in" };
        node->tdef.mangled_name = string_hash{ "in" };
        node->tdef.kind = type_kind::constructor;

        type_constructor* ptr_template = &node->tdef.constructor;
        ptr_template->self = node.get();
        ptr_template->func = [this](const std::vector<const_value>& arg) {
            auto type_arg = std::get<type_id>(arg.front());
            auto node = make_in_arena<ast_node>(*ast_arena);
            type_def& tf = node->tdef;

            tf.kind = type_kind::input;
            tf.name = string_hash{ "in " + type_arg.get().name.str };
            tf.mangled_name = string_hash{ "in__T" + type_arg.get().mangled_name.str };
            tf.size = sizeof(void*);
            tf.alignment = alignof(void*);
            tf.elem_type = type_arg;
            tf.flags |= type_flags::is_in;
            return node;
        };

        in_type_constructor = ptr_template;
        register_type(*this, builtin_scope->scope, *node);
        builtin_type_nodes.push_back(std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);
        node->tdef.name = string_hash{ "out" };
        node->tdef.mangled_name = string_hash{ "out" };
        node->tdef.kind = type_kind::constructor;

        type_constructor* ptr_template = &node->tdef.constructor;
        ptr_template->self = node.get();
        ptr_template->func = [this](const std::vector<const_value>& arg) {
            auto type_arg = std::get<type_id>(arg.front());
            auto node = make_in_arena<ast_node>(*ast_arena);
            type_def& tf = node->tdef;

            tf.kind = type_kind::output;
            tf.name = string_hash{ "out " + type_arg.get().name.str };
            tf.mangled_name = string_hash{ "out__T" + type_arg.get().mangled_name.str };
            tf.size = sizeof(void*);
            tf.alignment = sizeof(void*);
            tf.elem_type = type_arg;
            tf.flags |= type_flags::is_out;
            return node;
        };

        out_type_constructor = ptr_template;
        register_type(*this, builtin_scope->scope, *node);
        builtin_type_nodes.push_back(std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);
        node->tdef.name = string_hash{ "in out" };
        node->tdef.mangled_name = string_hash{ "inout" };
        node->tdef.kind = type_kind::constructor;

        type_constructor* ptr_template = &node->tdef.constructor;
        ptr_template->self = node.get();
        ptr_template->func = [this](const std::vector<const_value>& arg) {
            auto type_arg = std::get<type_id>(arg.front());
            auto node = make_in_arena<ast_node>(*ast_arena);
            type_def& tf = node->tdef;

            tf.kind = type_kind::inout;
            tf.name = string_hash{ "in out " + type_arg.get().name.str };
            tf.mangled_name = string_hash{ "inout__T" + type_arg.get().mangled_name.str };
            tf.size = sizeof(void*);
            tf.alignment = sizeof(void*);
            tf.elem_type = type_arg;
            tf.flags |= type_flags::is_in | type_flags::is_out;
            return node;
        };

        inout_type_constructor = ptr_template;
        register_type(*this, builtin_scope->scope, *node);
        builtin_type_nodes.push_back(std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);
        node->tdef.name = string_hash{ "array" };
        node->tdef.mangled_name = string_hash{ "array" };
        node->tdef.kind = type_kind::constructor;

        type_constructor* arr_template = &node->tdef.constructor;
        arr_template->self = node.get();

        arr_template->func = [this, ctor = node.get()](const std::vector<const_value>& args) {
            auto node = make_in_arena<ast_node>(*ast_arena);
            type_def& tf = node->tdef;

            tf.kind = type_kind::static_array;
            
            if (std::holds_alternative<comp_int_type>(args[0])) {
                tf.name = build_static_array_name(std::get<comp_int_type>(args[0]), std::get<type_id>(args[1]));
                tf.mangled_name = build_type_constructor_mangled_name(ctor->tdef.mangled_name.str, args);
                tf.array.length = std::get<comp_int_type>(args[0]);
                tf.array.deduce_size = false;
            }
            else if (std::holds_alternative<ellipsis_value>(args[0])) {
                tf.name = string_hash{ "array[...]" };
                tf.mangled_name = string_hash{ "array_unsized" };
                tf.array.length = 0;
                tf.array.deduce_size = true;
            }

            tf.elem_type = std::get<type_id>(args[1]);

#if 0
            tf.size = tf.array.length * tf.elem_type.get().size;
            tf.alignment = tf.elem_type.get().alignment;
            if (tf.size > 8) {
                tf.alignment = 16;
            }
#endif

            for (comp_int_type i = 0; i < tf.array.length; i++) {
                tf.structure.fields.push_back({ {""}, tf.elem_type, 0 });
            }

            compute_struct_size_alignment_offsets(tf);

            return node;
        };

        static_array_type_constructor = arr_template;
        register_type(*this, builtin_scope->scope, *node);
        builtin_type_nodes.push_back(std::move(node));
    }

#if 0
    {
        auto node = make_in_arena<ast_node>(*ast_arena);
        node->tdef.name = string_hash{ "arrayview" };
        node->tdef.mangled_name = string_hash{ "arrayview" };
        node->tdef.kind = type_kind::constructor;

        type_constructor* slice_template = &node->tdef.constructor;
        slice_template->self = node.get();

        slice_template->func = [this, ctor = node.get()](const std::vector<const_value>& args) {
            auto node = make_in_arena<ast_node>(*ast_arena);
            type_def& tf = node->tdef;

            tf.kind = type_kind::array_view;
            tf.name = string_hash{ "arrayview of " + std::get<type_id>(args[0]).get().name.str };
            tf.mangled_name = build_type_constructor_mangled_name(ctor->tdef.mangled_name.str, args);
            tf.elem_type = std::get<type_id>(args[0]);

            auto ptype = get_ptr_type_to(*this, tf.elem_type);
            tf.structure.fields.push_back({ { ARRAY_VIEW_PTR_MEMBER }, ptype, 0 });
            tf.structure.fields.push_back({ { ARRAY_VIEW_LEN_MEMBER }, this->int_type, 0 });

            compute_struct_size_alignment_offsets(tf);

            return node;
        };

        array_view_type_constructor = slice_template;
        register_type(*this, builtin_scope->scope, *node);
        builtin_type_nodes.push_back(std::move(node));
    }
#endif

    {
        auto node = make_in_arena<ast_node>(*ast_arena);
        node->tdef.name = string_hash{ "array" };
        node->tdef.mangled_name = string_hash{ "array" };
        node->tdef.kind = type_kind::constructor;

        type_constructor* slice_template = &node->tdef.constructor;
        slice_template->self = node.get();

        slice_template->func = [this, ctor = node.get()](const std::vector<const_value>& args) {
            auto node = make_in_arena<ast_node>(*ast_arena);
            type_def& tf = node->tdef;

            tf.kind = type_kind::array;
            tf.name = string_hash{ "array of " + std::get<type_id>(args[0]).get().name.str };
            tf.mangled_name = build_type_constructor_mangled_name(ctor->tdef.mangled_name.str, args);
            tf.elem_type = std::get<type_id>(args[0]);

            auto ptype = get_ptr_type_to(*this, tf.elem_type);
            tf.structure.fields.push_back({ { ARRAY_VIEW_PTR_MEMBER }, ptype, 0 });
            tf.structure.fields.push_back({ { ARRAY_VIEW_LEN_MEMBER }, this->int_type, 0 });
            tf.structure.fields.push_back({ { ARRAY_CAPACITY_MEMBER }, this->int_type, 0 });

            compute_struct_size_alignment_offsets(tf);

            return node;
        };

        array_type_constructor = slice_template;
        register_type(*this, builtin_scope->scope, *node);
        builtin_type_nodes.push_back(std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);
        node->tdef.name = string_hash{ "funcptr" };
        node->tdef.mangled_name = string_hash{ "funcptr" };
        node->tdef.kind = type_kind::constructor;

        type_constructor* func_pointer_template = &node->tdef.constructor;
        func_pointer_template->self = node.get();

        func_pointer_template->func = [this, ctor = node.get()](const std::vector<const_value>& args) {
            auto node = make_in_arena<ast_node>(*ast_arena);
            type_def& tf = node->tdef;

            std::vector<type_id> arg_types;
            std::transform(args.begin(), args.begin() + args.size() - 1, std::back_inserter(arg_types), [](auto&& arg) {
                return std::get<type_id>(arg);
            });

            auto ret_type = std::get<type_id>(args.back());

            tf.kind = type_kind::func_pointer;
            tf.size = sizeof(void*);
            tf.alignment = sizeof(void*);
            tf.name = build_func_pointer_name(arg_types, ret_type);
            tf.mangled_name = build_type_constructor_mangled_name(ctor->tdef.mangled_name.str, args);
            tf.func.arg_types = arg_types;
            tf.func.ret_type = ret_type;

            return node;
        };

        func_pointer_type_constructor = func_pointer_template;
        register_type(*this, builtin_scope->scope, *node);
        builtin_type_nodes.push_back(std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);

        type_def& tf = node->tdef;
        tf.kind = type_kind::nil;
        tf.name = string_hash{ "nil" };
        tf.mangled_name = string_hash{ "nil" };
        tf.size = sizeof(void*);
        tf.alignment = alignof(void*);
        tf.elem_type = opaque_type;
        nil_type = register_builtin_type(*this, std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);

        type_def& tf = node->tdef;
        tf.kind = type_kind::void_;
        tf.name = string_hash{ "opaque" };
        tf.mangled_name = string_hash{ "opaque" };
        tf.size = 0;
        tf.alignment = 0;
        opaque_type = register_builtin_type(*this, std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);

        type_def& tf = node->tdef;
        tf.kind = type_kind::module_;
        tf.name = string_hash{ "module" };
        tf.mangled_name = string_hash{ "module" };
        tf.size = 0;
        tf.alignment = 0;
        module_type = register_builtin_type(*this, std::move(node));
    }

    // void*
    opaque_ptr_type = get_ptr_type_to(*this, opaque_type);
    raw_string_type = register_pointer_type(*this, "$rawstring", "byte");

    declare_const_symbol(*this, string_hash{ "OS_WINDOWS" }, const_value{ 1 }, int_type);
    declare_const_symbol(*this, string_hash{ "OS_LINUX" }, const_value{ 2 }, int_type);

#ifdef _WIN32
    declare_const_symbol(*this, string_hash{ "TARGET_OS" }, const_value{ 1 }, int_type);
#else
    declare_const_symbol(*this, string_hash{ "TARGET_OS" }, const_value{ 2 }, int_type);
#endif

    root = make_in_arena<ast_node>(*ast_arena);
    root->type = ast_type::root;
}

void type_system::add_module(const std::string& name) {
    auto modnode = make_in_arena<ast_node>(*ast_arena);
    modnode->modname = name;
    modnode->type = ast_type::module_;

    std::cout << "carbonc - compiling module: " << name << std::endl;

    add_scope(*this, *modnode, scope_kind::module_);
    
    modnode->parent = root.get();
    root->children.push_back(std::move(modnode));
}

void type_system::end_module() {
    leave_scope();
}

void type_system::process_code_unit(arena_ptr<ast_node> node) {
    this->pass = type_system_pass::resolve_literals_and_register_declarations;

    current_scope->self->children.push_back(std::move(node));
    auto& unit = current_scope->self->children.back();

    // std::cout << "    process_code_unit: " << unit->filename << std::endl;

    for (int i = 0; i < 2; i++) {
        this->subpass = i;
        update_symbols_pass_tokens(*this);
        parent_tree(*unit);
        visit_tree(*this, *unit);
    }
}

void type_system::resolve_and_check() {
    this->pass = type_system_pass::resolve_imports;
    this->subpass = 0;
    update_symbols_pass_tokens(*this);

    for (auto& mod : this->root->children) {
        enter_scope(*mod);
        visit_tree(*this, *mod);
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
    for (int i = 0; i < 30; i++) {
        this->subpass = i;
        //update_symbols_pass_tokens(*this);
        this->unresolved_types = false;
        for (auto& mod : this->root->children) {
            clear_type_errors(*this, *mod);
            enter_scope(*mod);
            visit_tree(*this, *mod);
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
    //update_symbols_pass_tokens(*this);
    for (auto& mod : this->root->children) {
        clear_type_errors(*this, *mod);
        enter_scope(*mod);
        visit_tree(*this, *mod);
        leave_scope();
    }
    if (!current_error.msg.empty()) {
        errors.push_back(current_error);
        current_error = {};
    }

    this->pass = type_system_pass::create_header_files;
    this->subpass = 0;
    for (auto& mod : this->root->children) {
        enter_scope(*mod);
        visit_tree(*this, *mod);
        leave_scope();
    }
    update_symbols_pass_tokens(*this);

    if (errors.empty()) {
#if 1
        in_desugar = true;
        for (int i = 0; i < 3; i++) {
            this->pass = type_system_pass::desugar;
            this->subpass = i;
            for (auto& mod : this->root->children) {
                parent_tree(*mod);
                enter_scope(*mod);
                visit_tree(*this, *mod);
                leave_scope();
            }
            update_symbols_pass_tokens(*this);
        }
        in_desugar = false;

        for (int i = 0; i < 2; i++) {
            this->pass = type_system_pass::remangle_names;
            this->subpass = i;
            for (auto& mod : this->root->children) {
                enter_scope(*mod);
                visit_tree(*this, *mod);
                leave_scope();
            }
            update_symbols_pass_tokens(*this);
        }
#endif
    }

    if (!current_error.msg.empty()) {
        errors.push_back(current_error);
    }

    for (auto& mod : this->root->children) {
        std::string astname = mod->modname;
        while (replace(astname, "/", "_"));

        ensure_directory_exists("_carbon/build_debug/" + basename(astname + ".ast"));
        std::ofstream ast_file{ "_carbon/build_debug/" + basename(astname + ".ast") };
        prettyprint(*mod, ast_file);
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
    node.pre_nodes.push_back(std::move(temp));
}

void type_system::create_temp_variable_for_call_arg(ast_node& call, ast_node& arg, int idx) {
    auto [temp, ref] = make_temp_variable_for_call_resolved(*this, arg);
    call.children[ast_node::child_call_expr_arg_list]->children[idx] = std::move(ref);
    call.pre_nodes.push_back(std::move(temp));
}

scope_def* type_system::find_nearest_scope(scope_kind kind) {
    return find_nearest_scope_local(*this, kind);
}

type_def& type_id::get() const { return *scope->tdefs[type_index]; }

bool type_id::valid() const { return scope != nullptr && type_index != -1; }

bool is_pointer_type(type_id tid) {
    return is_pointer(tid);
}

bool is_aggregate_type(type_id tid) {
    return is_aggregate(tid);
}

}