#pragma once

#include "carbonc.hh"
#include "type_id.hh"

namespace carbon {

struct ast_node;

using const_value = std::variant<type_id, comp_int_type, ast_node*, std::string>;
using const_func = std::function<const_value(const std::vector<const_value>&)>;

}