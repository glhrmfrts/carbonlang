#pragma once

#include "ast.hh"
#include "type_system.hh"

namespace carbon {

void desugar(type_system& ts, ast_node* nodeptr);

}