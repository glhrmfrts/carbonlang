#include "type_system.hh"
#include "ast.hh"

namespace carbon {

namespace {

template <typename T> void register_integral_type(type_system& ts, const char* name) {
    auto& def = ts.type_defs.emplace_back();
    def.kind = type_kind::integral;
    def.name = name;
    def.name_hash = std::hash<std::string>{}(def.name);
    def.number.alignment = alignof(T);
    def.number.size = sizeof(T);
    def.number.is_signed = std::is_signed_v<T>;
    ts.type_map[name] = ts.type_defs.size() - 1;
}

template <typename T> void register_real_type(type_system& ts, const char* name) {
    auto& def = ts.type_defs.emplace_back();
    def.kind = type_kind::real;
    def.name = name;
    def.name_hash = std::hash<std::string>{}(def.name);
    def.number.alignment = alignof(T);
    def.number.size = sizeof(T);
    def.number.is_signed = std::is_signed_v<T>;
    ts.type_map[name] = ts.type_defs.size() - 1;
}

bool register_alias_to_type_name(type_system& ts, const std::string& name, const std::string& toname) {
    auto it = ts.type_map.find(toname);
    if (it == ts.type_map.end()) {
        return false;
    }

    type_def defcopy = ts.type_defs[it->second];
    defcopy.name = name;
    defcopy.name_hash = std::hash<std::string>{}(defcopy.name);
    defcopy.alias_to = it->second;
    ts.type_defs.push_back(defcopy);

    ts.type_map[name] = ts.type_defs.size() - 1;
    return true;
}

void resolve_literals(type_system& ts, ast_node& node) {
    switch (node.type) {
    case ast_type::bool_literal:
        node.type_id = ts.type_map["bool"];
        break;
    case ast_type::int_literal:
        node.type_id = ts.type_map["int"];
        break;
    case ast_type::float_literal:
        node.type_id = ts.type_map["float"];
        break;
    default:
        for (auto& child : node.children) {
            if (child) {
                resolve_literals(ts, *child);
            }
        }
        break;
    }
}

}

type_system::type_system() {
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
}

void type_system::resolve_and_check_program(ast_node& node) {
    resolve_literals(*this, node);
}


}