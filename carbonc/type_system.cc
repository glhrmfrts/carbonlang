#include <cassert>
#include <optional>
#include "type_system.hh"
#include "ast.hh"

namespace carbon {

namespace {

static const type_id invalid_type{};
static const scope_id invalid_scope = -1;

void visit_tree(type_system& ts, ast_node& node);

type_id resolve_node_type(type_system& ts, ast_node* nodeptr);

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
    return ts.current_scope->scope;
}

void register_builtin_type(type_system& ts, arena_ptr<ast_node>&& node) {
    type_def* t = &node->type_def;
    t->name_hash = hash(t->name);
    ts.builtin_scope->scope.type_defs.push_back(t);
    ts.builtin_scope->scope.type_map[t->name_hash] = { ts.current_scope, (int)(ts.builtin_scope->scope.type_defs.size() - 1) };
    ts.builtin_type_nodes.push_back(std::move(node));
}

type_id register_user_type(type_system& ts, ast_node& node) {
    type_def* t = &node.type_def;
    t->name_hash = hash(t->name);
    ts.current_scope->scope.type_defs.push_back(t);

    type_id id = { ts.current_scope, (int)(ts.current_scope->scope.type_defs.size() - 1) };
    ts.current_scope->scope.type_map[t->name_hash] = id;
    ts.current_scope->scope.children.push_back(&node);
    return id;
}

template <typename T> void register_integral_type(type_system& ts, const char* name) {
    auto node = make_in_arena<ast_node>(*ts.ast_arena);

    type_def& def = node->type_def;
    def.kind = type_kind::integral;
    def.name = name;
    def.name_hash = std::hash<std::string>{}(def.name);
    def.alignment = alignof(T);
    def.size = sizeof(T);
    def.is_signed = std::is_signed_v<T>;

    register_builtin_type(ts, std::move(node));
}

template <typename T> void register_real_type(type_system& ts, const char* name) {
    auto node = make_in_arena<ast_node>(*ts.ast_arena);

    type_def& def = node->type_def;
    def.kind = type_kind::real;
    def.name = name;
    def.name_hash = std::hash<std::string>{}(def.name);
    def.alignment = alignof(T);
    def.size = sizeof(T);
    def.is_signed = std::is_signed_v<T>;
    register_builtin_type(ts, std::move(node));
}

type_def& get_type(type_system& ts, type_id id) {
    return *id.scope->scope.type_defs[id.type_index];
}

bool register_alias_to_type_name(type_system& ts, const std::string& name, const std::string& toname) {
    auto it = curscope(ts).type_map.find(hash(toname));
    if (it == curscope(ts).type_map.end()) {
        return false;
    }

    auto node = make_in_arena<ast_node>(*ts.ast_arena);

    type_def* defcopy = &node->type_def;

    *defcopy = get_type(ts, it->second);
    defcopy->name = name;
    defcopy->alias_to = it->second;
    register_builtin_type(ts, std::move(node));
    return true;
}

// Section: types

// is A assignable to B?
bool is_assignable_to(type_system& ts, type_id a, type_id b) {
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
    if (is_assignable_to(ts, a, b)) return true;

    auto& ta = get_type(ts, a);
    auto& tb = get_type(ts, b);

    if (ta.kind == tb.kind && tb.kind == type_kind::integral) {
        return tb.size >= ta.size;
    }

    return false;
}

bool compare_types_exact(const type_def& a, const type_def& b) {
    return false;
}

// Section: scopes

void add_scope(type_system& ts, ast_node& node, scope_kind k) {
    node.scope.kind = k;
    //node.scope.body_node = body_node;
    node.scope.parent = ts.current_scope;
    
    // add to parent's children
    if (ts.current_scope) {
        ts.current_scope->scope.children.push_back(&node);
    }

    ts.current_scope = &node;
}

void add_func_scope(type_system& ts, ast_node& node) {
    add_scope(ts, node, scope_kind::func_body);
}

// enter existing scope
void enter_scope(type_system& ts, ast_node& node) {
    assert(node.scope.kind != scope_kind::invalid);
    node.scope.parent = ts.current_scope;
    ts.current_scope = &node;
}

void leave_scope(type_system& ts) {
    ts.current_scope = curscope(ts).parent;
}

ast_node* find_nearest_scope(type_system& ts, scope_kind kind) {
    auto scope = ts.current_scope;
    while (scope != nullptr) {
        if (scope->scope.kind == kind) {
            return scope;
        }

        scope = scope->scope.parent;
    }
    return nullptr;
}

void declare_local_symbol(type_system& ts, std::size_t hash, ast_node& ld) {
    symbol_info info;
    info.kind = symbol_kind::local;
    info.local_index = curscope(ts).local_defs.size();
    curscope(ts).local_defs.push_back(&ld);
    curscope(ts).symbols[hash] = info;
}

std::optional<symbol_info> find_symbol_in_current_scope(type_system& ts, std::size_t hash) {
    auto it = curscope(ts).symbols.find(hash);
    if (it == curscope(ts).symbols.end()) {
        return std::nullopt;
    }
    return it->second;
}

// Finds the type in scope or parents
type_id find_type_by_id_hash(type_system& ts, std::size_t hash) {
    auto scope = ts.current_scope;
    while (scope != nullptr) {

        auto it = scope->scope.type_map.find(hash);
        if (it != scope->scope.type_map.end()) {
            return it->second;
        }

        scope = scope->scope.parent;
    }
    return invalid_type;
}

// Section: resolvers

type_id get_value_node_type(type_system& ts, const ast_node& node) {
    switch (node.type) {
    case ast_type::bool_literal:
        return ts.builtin_scope->scope.type_map[hash("bool")];

    case ast_type::int_literal:
        return ts.builtin_scope->scope.type_map[hash("int")];

    case ast_type::float_literal:
        return ts.builtin_scope->scope.type_map[hash("float")];

    case ast_type::binary_expr:
        return node.children[0]->type_id;
    }

    return invalid_type;
}

type_id get_type_expr_node_type(type_system& ts, const ast_node& node) {
    auto& actual = node.children[0];
    switch (actual->type) {
    case ast_type::identifier:
        return find_type_by_id_hash(ts, actual->id_hash);
    }

    return invalid_type;
}

void propagate_return_type(type_system& ts, const type_id& id) {
    //auto scope_id = find_nearest_scope(ts, scope_kind::func_body);
    //ts.scopes[scope_id].announced_return_types.push_back(id);
}

type_id resolve_local_variable_type(type_system& ts, ast_node& l) {
    auto decl_type = l.local.type_node ? resolve_node_type(ts, l.local.type_node) : type_id{};
    auto val_type = l.local.value_node ? resolve_node_type(ts, l.local.value_node) : type_id{};

    if (decl_type.valid()) {
        l.type_id = decl_type;
    }
    else {
        l.type_id = val_type;
    }

    return l.type_id;
}

type_id resolve_func_type(type_system& ts, ast_node& f) {
    assert(f.func.ret_type_node || !"func not declared yet");

    f.type_def.kind = type_kind::func;
    f.type_def.size = sizeof(void*);
    f.type_def.alignment = sizeof(void*);
    f.type_def.is_signed = false;

    f.type_def.func.arg_types.clear();
    for (auto& arg : f.func.arguments) {
        f.type_def.func.arg_types.push_back(arg->type_id);
    }

    resolve_node_type(ts, f.func.ret_type_node);
    f.type_def.func.ret_type = f.func.ret_type_node->type_id;

    if (!f.type_id.valid()) {
        f.type_id = register_user_type(ts, f);
    }
    return f.type_id;
}

// Section: declarations

void register_func_declaration_node(type_system& ts, ast_node& node) {
    auto& id = node.children[ast_node::child_func_decl_id];
    auto& arg_list = node.children[ast_node::child_func_decl_arg_list]->children;
    auto& body = node.children[ast_node::child_func_decl_body];

    node.local.id_node = id.get();
    node.func.ret_type_node = node.children[ast_node::child_func_decl_ret_type].get();

    // TODO: overload

    auto prev = find_symbol_in_current_scope(ts, id->id_hash);
    if (prev) {
        //add_error(ts, "cannot redeclare '%s'", id->string_value.data());
        assert(!"cannot redeclare");
        return;
    }

    // try to resolve the return type already
    resolve_node_type(ts, node.func.ret_type_node);

    add_func_scope(ts, node);
    
    for (auto& arg : arg_list) {
        assert(arg->type == ast_type::var_decl);

        auto& argid = arg->children[ast_node::child_var_decl_id];
        auto& argtype = arg->children[ast_node::child_var_decl_type];
        auto& argvalue = arg->children[ast_node::child_var_decl_value];

        arg->local.id_node = argid.get();
        arg->local.type_node = argtype.get();
        arg->local.value_node = argvalue.get();
        arg->local.is_argument = true;

        resolve_local_variable_type(ts, *arg);

        declare_local_symbol(ts, arg->local.id_node->id_hash, *arg);
        node.func.arguments.push_back(arg.get());
    }

    visit_tree(ts, *body);

    leave_scope(ts);

    // try to resolve the func type already
    resolve_func_type(ts, node);

    declare_local_symbol(ts, node.local.id_node->id_hash, node);
}

void register_var_declaration_node(type_system& ts, ast_node& node) {
    node.local.id_node = node.children[ast_node::child_var_decl_id].get();
    node.local.type_node = node.children[ast_node::child_var_decl_type].get();
    node.local.value_node = node.children[ast_node::child_var_decl_value].get();

    auto prev = find_symbol_in_current_scope(ts, node.local.id_node->id_hash);
    if (prev) {
        //add_error(ts, "cannot redeclare '%s'", id->string_value.data());
        assert(!"cannot redeclare");
        return;
    }

    resolve_local_variable_type(ts, node);

    declare_local_symbol(ts, node.local.id_node->id_hash, node);
}

// Section: type checking

void type_check_node(type_system& ts, ast_node* nodeptr) {
    auto& node = *nodeptr;
    switch (node.type) {
    case ast_type::binary_expr: {
        auto left_type = node.children[0]->type_id;
        auto right_type = node.children[0]->type_id;
        if (!is_convertible_to(ts, right_type, left_type)) {
            assert(!"NOT CONVERTIBLE");
        }
        break;
    }
    default:
        break;
    }
}

// Section: main visitor

void visit_children(type_system& ts, ast_node& node) {
    for (auto& child : node.children) {
        if (child) {
            visit_tree(ts, *child);
        }
    }
}

type_id resolve_node_type(type_system& ts, ast_node* nodeptr) {
    if (!nodeptr) return invalid_type;

    auto& node = *nodeptr;
    bool check_for_unresolved = true;

    switch (node.type) {
    case ast_type::type_expr:
        if (node.type_id != invalid_type) return node.type_id;

        node.type_id = get_type_expr_node_type(ts, node);
        break;
    case ast_type::return_stmt: {
        if (node.type_id != invalid_type) return node.type_id;

        node.type_id = resolve_node_type(ts, node.children.front().get());

        // TODO: check if scope / sanity check
        if (ts.pass == type_system_pass::resolve_literals_and_register_declarations) {
            auto scope = find_nearest_scope(ts, scope_kind::func_body);
            scope->func.return_statements.push_back(nodeptr);
        }
        break;
    }
    case ast_type::func_decl: {
        if (ts.pass == type_system_pass::resolve_literals_and_register_declarations) {
            register_func_declaration_node(ts, node);
        }
        else {
            enter_scope(ts, node);
            visit_children(ts, node);
            leave_scope(ts);
            resolve_func_type(ts, node);
        }
        break;
    }
    case ast_type::var_decl: {
        if (ts.pass == type_system_pass::resolve_literals_and_register_declarations) {
            register_var_declaration_node(ts, node);
        }
        else {
            resolve_local_variable_type(ts, node);
        }
        break;
    }
    case ast_type::bool_literal:
    case ast_type::int_literal:
    case ast_type::float_literal:
    case ast_type::binary_expr: {
        if (node.type_id != invalid_type) return node.type_id;

        node.type_id = get_value_node_type(ts, node);
        visit_children(ts, node);
        break;
    }
    default: {
        visit_children(ts, node);
        check_for_unresolved = false;
        break;
    }
    }

    if (check_for_unresolved) {
        ts.unresolved_types = ts.unresolved_types || (node.type_id == invalid_type);
    }
    return node.type_id;
}

void visit_tree(type_system& ts, ast_node& node) {
    switch (ts.pass) {
    case type_system_pass::resolve_literals_and_register_declarations:
    case type_system_pass::resolve_all: {
        resolve_node_type(ts, &node);
        break;
    }
    case type_system_pass::perform_checks:
        type_check_node(ts, &node);
        break;
    }
}

}

type_system::type_system(memory_arena& arena) {
    ast_arena = &arena;
    builtin_scope = new ast_node{};
    add_scope(*this, *builtin_scope, scope_kind::builtin);

    // void and void*
    {
        auto node = make_in_arena<ast_node>(*ast_arena);

        type_def& tf = node->type_def;
        tf.kind = type_kind::unit;
        tf.name = "()";
        register_builtin_type(*this, std::move(node));
    }

    {
        auto node = make_in_arena<ast_node>(*ast_arena);

        type_def& tf = node->type_def;
        tf.kind = type_kind::pointer;
        tf.name = "raw_ptr";
        tf.size = sizeof(void*);
        tf.alignment = alignof(void*);
        tf.elem_type = builtin_scope->scope.type_map[hash("()")];
        register_builtin_type(*this, std::move(node));
    }

    // register built-in types
    register_integral_type<std::uint8_t>(*this, "uint8");
    register_integral_type<std::uint16_t>(*this, "uint16");
    register_integral_type<std::uint32_t>(*this, "uint32");
    register_integral_type<std::uint64_t>(*this, "uint64");
    register_integral_type<std::size_t>(*this, "usize");

    register_integral_type<std::int8_t>(*this, "int8");
    register_integral_type<std::int16_t>(*this, "int16");
    register_integral_type<std::int32_t>(*this, "int32");
    register_integral_type<std::int64_t>(*this, "int64");

    register_real_type<float>(*this, "float32");
    register_real_type<double>(*this, "float64");

    register_alias_to_type_name(*this, "char", "int8");
    register_alias_to_type_name(*this, "uint", "uint32");
    register_alias_to_type_name(*this, "int", "int32");
    register_alias_to_type_name(*this, "bool", "int32");
    register_alias_to_type_name(*this, "float", "float32");

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

void type_system::process_ast_node(ast_node& node) {
    this->pass = type_system_pass::resolve_literals_and_register_declarations;
    this->code_units.push_back(&node);

    add_scope(*this, node, scope_kind::global);
    visit_tree(*this, node);
    leave_scope(*this);
}

void type_system::resolve_and_check() {
    this->pass = type_system_pass::resolve_all;

    for (int i = 0; i < 1000; i++) {
        this->unresolved_types = false;
        for (auto unit : this->code_units) {
            enter_scope(*this, *unit);
            visit_tree(*this, *unit);
            leave_scope(*this);
        }
        if (!this->unresolved_types) break;
    }

    this->pass = type_system_pass::perform_checks;
    for (auto unit : this->code_units) {
        visit_tree(*this, *unit);
    }
}

scope_id type_system::find_main_func_scope() {
    return -1;
}

}