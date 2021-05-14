#include <cassert>
#include <optional>
#include "type_system.hh"
#include "ast.hh"

namespace carbon {

namespace {

void visit_tree(type_system& ts, ast_node& node);

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

template <typename T> void register_integral_type(scope& ts, const char* name) {
    auto& def = ts.type_defs.emplace_back();
    def.kind = type_kind::integral;
    def.name = name;
    def.name_hash = std::hash<std::string>{}(def.name);
    def.alignment = alignof(T);
    def.size = sizeof(T);
    def.is_signed = std::is_signed_v<T>;
    ts.type_map[hash(name)] = ts.type_defs.size() - 1;
}

template <typename T> void register_real_type(scope& ts, const char* name) {
    auto& def = ts.type_defs.emplace_back();
    def.kind = type_kind::real;
    def.name = name;
    def.name_hash = std::hash<std::string>{}(def.name);
    def.alignment = alignof(T);
    def.size = sizeof(T);
    def.is_signed = std::is_signed_v<T>;
    ts.type_map[hash(name)] = ts.type_defs.size() - 1;
}

void register_type(scope& ts, type_def t) {
    t.name_hash = hash(t.name);
    ts.type_defs.push_back(t);
    ts.type_map[t.name_hash] = ts.type_defs.size() - 1;
}

bool register_alias_to_type_name(scope& ts, const std::string& name, const std::string& toname) {
    auto it = ts.type_map.find(hash(toname));
    if (it == ts.type_map.end()) {
        return false;
    }

    type_def defcopy = ts.type_defs[it->second];
    defcopy.name = name;
    defcopy.name_hash = std::hash<std::string>{}(defcopy.name);
    defcopy.alias_to = it->second;
    ts.type_defs.push_back(defcopy);

    ts.type_map[hash(name)] = ts.type_defs.size() - 1;
    return true;
}

// Section: scopes

scope& curscope(type_system& ts) {
    return ts.scopes[ts.current_scope];
}

int enter_scope(type_system& ts, scope_kind k, ast_node* node) {
    scope sc{};
    sc.kind = k;
    sc.node = node;
    sc.parent = ts.current_scope;
    ts.scopes.push_back(sc);

    int new_scope = ts.scopes.size() - 1;
    
    // add to parent's children
    if (ts.current_scope != -1) {
        ts.scopes[ts.current_scope].children.push_back(new_scope);
    }

    ts.current_scope = new_scope;
    return new_scope;
}

int enter_func_scope(type_system& ts, ast_node* node, type_id ret_type) {
    enter_scope(ts, scope_kind::func_body, node);
    curscope(ts).ret_type = ret_type;
    return ts.current_scope;
}

void leave_scope(type_system& ts) {
    ts.current_scope = curscope(ts).parent;
}

void declare_local_symbol(type_system& ts, std::size_t hash, const local_def& ld) {
    symbol_info info;
    info.kind = symbol_kind::local;
    info.local_index = curscope(ts).local_defs.size();
    curscope(ts).local_defs.push_back(ld);
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
    int scope = ts.current_scope;
    while (scope != -1) {
        const auto& sc = ts.scopes[scope];

        auto it = sc.type_map.find(hash);
        if (it != sc.type_map.end()) {
            return it->second;
        }

        scope = sc.parent;
    }
    return -1;
}

// Section: resolvers

type_id get_literal_node_type(type_system& ts, const ast_node& node) {
    switch (node.type) {
    case ast_type::bool_literal:
        return ts.scopes[0].type_map[hash("bool")];
        
    case ast_type::int_literal:
        return ts.scopes[0].type_map[hash("int")];
        
    case ast_type::float_literal:
        return ts.scopes[0].type_map[hash("float")];
    }

    return -1;
}

type_id get_value_node_type(type_system& ts, const ast_node& node) {
    if (ts.pass == type_system_pass::resolve_literals_and_register_declarations) {
        return get_literal_node_type(ts, node);
    }

    return -1;
}

type_id get_type_expr_node_type(type_system& ts, const ast_node& node) {
    auto& actual = node.children[0];
    switch (actual->type) {
    case ast_type::identifier:
        return find_type_by_id_hash(ts, actual->id_hash);
    }

    return -1;
}

type_id resolve_node_type(type_system& ts, ast_node* nodeptr) {
    if (!nodeptr) return -1;

    auto& node = *nodeptr;
    if (node.type_id != -1) return node.type_id;

    if (node.type == ast_type::type_expr) {
        node.type_id = get_type_expr_node_type(ts, node);
    }
    else {
        node.type_id = get_value_node_type(ts, node);
    }

    ts.unresolved_types = node.type_id == -1;
    return node.type_id;
}

type_id resolve_local_variable_type(type_system& ts, local_def& l) {
    auto decl_type = l.type_node ? resolve_node_type(ts, l.type_node) : -1;
    auto val_type = l.value_node ? resolve_node_type(ts, l.value_node) : -1;

    if (decl_type != -1) {
        l.type_id = decl_type;
        if (decl_type != val_type) {
            // TODO: check conversions / cast
        }
    }
    else {
        l.type_id = val_type;
    }

    return l.type_id;
}

// Section: declarations

void register_func_declaration_node(type_system& ts, ast_node& node) {
    auto& id = node.children[ast_node::child_func_decl_id];
    auto& ret_type = node.children[ast_node::child_func_decl_ret_type];
    auto& arg_list = node.children[ast_node::child_func_decl_arg_list]->children;
    auto& body = node.children[ast_node::child_func_decl_body];

    // TODO: overload

    auto prev = find_symbol_in_current_scope(ts, id->id_hash);
    if (prev) {
        //add_error(ts, "cannot redeclare '%s'", id->string_value.data());
        assert(!"cannot redeclare");
        return;
    }

    // try to resolve the return type already
    enter_func_scope(ts, &node, resolve_node_type(ts, ret_type.get()));
    
    for (auto& arg : arg_list) {
        assert(arg->type == ast_type::var_decl);

        auto& argid = arg->children[ast_node::child_var_decl_id];
        auto& argtype = arg->children[ast_node::child_var_decl_type];
        auto& argvalue = arg->children[ast_node::child_var_decl_value];

        local_def a;
        a.id_node = argid.get();
        a.type_node = argtype.get();
        a.value_node = argvalue.get();
        a.is_argument = true;
        resolve_local_variable_type(ts, a);

        declare_local_symbol(ts, a.id_node->id_hash, a);
    }

    visit_tree(ts, *body);

    leave_scope(ts);
}

void register_var_declaration_node(type_system& ts, ast_node& node) {
    auto& id = node.children[ast_node::child_var_decl_id];
    auto& ty = node.children[ast_node::child_var_decl_type];
    auto& val = node.children[ast_node::child_var_decl_value];

    auto prev = find_symbol_in_current_scope(ts, id->id_hash);
    if (prev) {
        //add_error(ts, "cannot redeclare '%s'", id->string_value.data());
        assert(!"cannot redeclare");
        return;
    }

    local_def l{};
    l.id_node = id.get();
    l.type_node = ty.get();
    l.value_node = val.get();

    resolve_local_variable_type(ts, l);

    declare_local_symbol(ts, l.id_node->id_hash, l);
}

bool register_declaration_node(type_system& ts, ast_node& node) {
    switch (node.type) {
    case ast_type::func_decl:
        register_func_declaration_node(ts, node);
        return true;
    case ast_type::var_decl:
        register_var_declaration_node(ts, node);
        return true;
    }
    return false;
}

// Section: main visitor

void visit_tree(type_system& ts, ast_node& node) {
    switch (ts.pass) {
    case type_system_pass::resolve_literals_and_register_declarations:
        resolve_node_type(ts, &node);
        if (!register_declaration_node(ts, node)) {
            for (auto& child : node.children) {
                if (child) {
                    visit_tree(ts, *child);
                }
            }
        }
        break;
    }
}

}

type_system::type_system(memory_arena& arena) {
    ast_arena = &arena;
    enter_scope(*this, scope_kind::global, nullptr);

    // register built-in types
    register_integral_type<std::uint8_t>(scopes[0], "uint8");
    register_integral_type<std::uint16_t>(scopes[0], "uint16");
    register_integral_type<std::uint32_t>(scopes[0], "uint32");
    register_integral_type<std::uint64_t>(scopes[0], "uint64");
    register_integral_type<std::size_t>(scopes[0], "usize");

    register_integral_type<std::int8_t>(scopes[0], "int8");
    register_integral_type<std::int16_t>(scopes[0], "int16");
    register_integral_type<std::int32_t>(scopes[0], "int32");
    register_integral_type<std::int64_t>(scopes[0], "int64");

    register_real_type<float>(scopes[0], "float32");
    register_real_type<double>(scopes[0], "float64");

    register_alias_to_type_name(scopes[0], "char", "int8");
    register_alias_to_type_name(scopes[0], "uint", "uint32");
    register_alias_to_type_name(scopes[0], "int", "int32");
    register_alias_to_type_name(scopes[0], "bool", "int32");
    register_alias_to_type_name(scopes[0], "float", "float32");
    
    // void and void*
    {
        type_def tf{};
        tf.kind = type_kind::unit;
        tf.name = "()";
        register_type(scopes[0], tf);
    }

    {
        type_def tf;
        tf.kind = type_kind::pointer;
        tf.name = "raw_ptr";
        tf.size = sizeof(void*);
        tf.alignment = alignof(void*);
        tf.pointer_to = scopes[0].type_map[hash("()")];
        register_type(scopes[0], tf);
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

void type_system::process_ast_node(ast_node& node) {
    this->pass = type_system_pass::resolve_literals_and_register_declarations;
    visit_tree(*this, node);
}

scope_id type_system::find_main_func_scope() {
    return -1;
}

}