#pragma once

#include "ast.hh"

namespace carbon {

void codegen(ast_node& node, std::string_view filename);

}