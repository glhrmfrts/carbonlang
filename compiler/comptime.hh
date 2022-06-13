#pragma once

#include "compiler.hh"
#include "type_id.hh"

namespace carbon {

struct ast_node;

struct ellipsis_value {
    int dummy;

    bool operator ==(const ellipsis_value& other) const {
        return true;
    }
};

using const_value = std::variant<type_id, comp_int_type, ast_node*, std::string, ellipsis_value>;
using const_func = std::function<const_value(const std::vector<const_value>&)>;

}