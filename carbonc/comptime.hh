#pragma once

#include "carbonc.hh"
#include "type_id.hh"

namespace carbon {

struct ast_node;

using comptime_value = std::variant<type_id, int_type, ast_node*, std::string>;
using comptime_func = std::function<comptime_value(const std::vector<comptime_value>&)>;

}