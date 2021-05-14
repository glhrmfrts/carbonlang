#pragma once

#include <vector>
#include <string>
#include <unordered_map>

namespace carbon {

struct ast_node;

enum class type_qualifier {
    optional,
    reference,
};

enum class type_kind {
    unit,
    integral,
    real,
    array,
    map,
    structure,
    tuple,
};

using type_id = int;

struct type_flags {
    using type = unsigned int;

    static constexpr type none = 0;
    static constexpr type is_alias = 1;
};

struct number_type {
    std::size_t size;
    std::size_t alignment;
    bool is_signed;
};

struct array_type {
    std::size_t size;
    bool is_static;
};

struct type_def {
    std::string name;
    std::hash<std::string>::result_type name_hash;
    //std::vector<type_qualifier> qualifiers;
    type_kind kind;
    number_type number;
    array_type array;
    type_flags::type flags;
    int alias_to = -1;
    int reference_to = -1;
    int optional_of = -1;
};

struct type_system {
    std::vector<type_def> type_defs;
    std::unordered_map<std::string, int> type_map;

    type_system();

    void resolve_and_check_program(ast_node& node);
};

}