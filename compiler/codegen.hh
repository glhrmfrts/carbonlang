#pragma once

#include "ir.hh"

namespace carbon {

void codegen(ir_program& prog, type_system* ts, std::string_view filename);

}