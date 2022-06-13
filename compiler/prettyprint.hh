#pragma once

#include <ostream>
#include "ast.hh"

namespace carbon {

void prettyprint(const ast_node& node, std::ostream& stream, int indent = 0, bool doindent=true);

}