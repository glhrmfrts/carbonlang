#pragma once

#include "ast.hh"

namespace carbon {

void codegen(ast_node& node, type_system* ts, std::string_view filename);

}