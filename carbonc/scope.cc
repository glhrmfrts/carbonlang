#include "ast.hh"
#include "common.hh"
#include "fs.hh"
#include "scope.hh"
#include <cassert>

namespace carbon {

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

void add_block_scope(type_system& ts, ast_node& node, ast_node& body_node) {
    add_scope(ts, node, scope_kind::block);
    node.scope.body_node = &body_node;
}

void add_type_scope(type_system& ts, ast_node& node, ast_node& body_node) {
    add_scope(ts, node, scope_kind::type);
    node.scope.body_node = &body_node;
}

// enter existing scope
void enter_scope_local(type_system& ts, ast_node& node) {
    assert(node.scope.kind != scope_kind::invalid);
    node.scope.parent = ts.current_scope;
    ts.current_scope = &node.scope;
}

void leave_scope_local(type_system& ts) {
    ts.current_scope = ts.current_scope->parent;
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

bool declare_global_symbol(type_system& ts, const string_hash& hash, ast_node& ld) {
    auto it = ts.current_scope->symbols.find(hash);
    if (it != ts.current_scope->symbols.end()) {
        return false;
    }

    symbol_info info;
    info.kind = symbol_kind::global;
    info.scope = ts.current_scope;
    info.local_index = ts.current_scope->local_defs.size();
    info.id = hash;

    ld.local.name = hash;
    ts.current_scope->local_defs.push_back(&ld.local);
    ts.current_scope->symbols[hash] = std::make_unique<symbol_info>(info);
    return true;
}

bool declare_local_symbol(type_system& ts, const string_hash& hash, ast_node& ld) {
    auto it = ts.current_scope->symbols.find(hash);
    if (it != ts.current_scope->symbols.end()) {
        return false;
    }

    symbol_info info;
    info.kind = symbol_kind::local;
    info.scope = ts.current_scope;
    info.local_index = ts.current_scope->local_defs.size();
    info.id = hash;

    ld.local.name = hash;
    ts.current_scope->local_defs.push_back(&ld.local);
    ts.current_scope->symbols[hash] = std::make_unique<symbol_info>(info);
    return true;
}

bool declare_top_level_func_symbol(type_system& ts, const string_hash& hash, ast_node& ld) {
    auto it = ts.current_scope->symbols.find(hash);
    if (it != ts.current_scope->symbols.end()) {
        return false;
    }

    symbol_info info;
    info.kind = symbol_kind::top_level_func;
    info.scope = ts.current_scope;
    info.local_index = ts.current_scope->local_defs.size();
    info.id = hash;
    ts.current_scope->local_defs.push_back(&ld.local);
    ts.current_scope->symbols[hash] = std::make_unique<symbol_info>(info);
    return true;
}

bool declare_type_symbol(type_system& ts, const string_hash& hash, ast_node& node) {
    return declare_type_symbol(ts, *ts.current_scope, hash, node);
}

bool declare_type_symbol(type_system& ts, scope_def& scope, const string_hash& hash, ast_node& node) {
    auto it = ts.current_scope->symbols.find(hash);
    if (it != ts.current_scope->symbols.end()) {
        return false;
    }

    symbol_info info;
    info.kind = symbol_kind::type;
    info.scope = &scope;
    info.type_index = scope.tdefs.size();
    info.id = hash;
    scope.symbols[hash] = std::make_unique<symbol_info>(info);
    scope.tdefs.push_back(&node.tdef);
    return true;
}

bool declare_comptime_symbol(type_system& ts, const string_hash& hash, const comptime_value& value, type_id tid) {
    auto it = ts.current_scope->symbols.find(hash);
    if (it != ts.current_scope->symbols.end()) {
        return false;
    }

    symbol_info info;
    info.kind = symbol_kind::comptime;
    info.scope = ts.current_scope;
    info.ctvalue = value;
    info.cttype = tid;
    info.id = hash;
    ts.current_scope->symbols[hash] = std::make_unique<symbol_info>(info);
    return true;
}

bool declare_overloaded_func_base_symbol(type_system& ts, const string_hash& hash) {
    auto it = ts.current_scope->symbols.find(hash);
    if (it != ts.current_scope->symbols.end()) {
        return false;
    }

    symbol_info info;
    info.kind = symbol_kind::overloaded_func_base;
    info.scope = ts.current_scope;
    info.id = hash;
    ts.current_scope->symbols[hash] = std::make_unique<symbol_info>(info);
    return true;
}

symbol_info* find_symbol_in_current_scope(type_system& ts, const string_hash& hash) {
    auto it = ts.current_scope->symbols.find(hash);
    if (it == ts.current_scope->symbols.end()) {
        return nullptr;
    }
    return it->second.get();
}

symbol_info* find_symbol(type_system& ts, const std::pair<string_hash, string_hash>& pair) {
    auto scope = ts.current_scope;
    while (scope != nullptr) {
        if (pair.first.str.empty()) {
            auto it = scope->symbols.find(pair.second);
            if (it != scope->symbols.end()) {
                return it->second.get();
            }

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
                if (impscope) {
                    auto it = impscope->symbols.find(pair.second);
                    if (it != impscope->symbols.end()) {
                        return it->second.get();
                    }
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
    return {};
}

local_def* get_symbol_local(const symbol_info& sym) {
    if (sym.scope && sym.local_index > -1) {
        return sym.scope->local_defs[sym.local_index];
    }
    return nullptr;
}

}