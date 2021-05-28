#pragma once

#include <variant>
#include "carbonc.hh"
#include "type_system.hh"

namespace carbon {

enum ir_op {
    ir_load,
    ir_add,
    ir_sub,
    ir_mul,
    ir_div,
    ir_call,
    ir_return,
    ir_index,
    ir_deref,
    ir_load_addr,
    ir_make_label,
    ir_asm,
    ir_jmp,
    ir_jmp_eq,
    ir_jmp_neq,
    ir_jmp_gt,
    ir_jmp_gte,
    ir_jmp_lt,
    ir_jmp_lte,
};

struct ir_local_data {
    std::string name;
    type_id type;
};

struct ir_arg_data {
    std::string name;
    type_id type;
};

struct ir_stack {
    type_id type;
};

struct ir_local {
    int index;
};

struct ir_arg {
    int index;
};

struct ir_string {
    int index;
};

struct ir_int {
    int_type val;
    type_id type;
};

struct ir_float {
    float_type val;
    type_id type;
};

struct ir_label {
    std::string name;
};

using ir_ref = std::variant<ir_local, ir_arg, ir_stack>;

struct ir_field {
    ir_ref ref;
    int field_index;
};

using ir_operand = std::variant<std::string, ir_field, ir_label, ir_local, ir_arg, ir_stack, ir_string, ir_int, ir_float, char>;

struct ir_instr {
    ir_op op;
    std::vector<ir_operand> operands;
};

struct ir_func {
    std::string name;
    std::vector<ir_arg_data> args;
    std::vector<ir_local_data> locals;
    std::vector<ir_instr> instrs;
    type_id ret_type;
    bool is_extern;
    bool calls_extern_c;
    int index = 0;
};

struct ir_node_data {
    std::string bin_self_label;
    std::string bin_target_label;
    bool bin_invert_jump;

    std::string if_body_label;
    std::string if_else_label;
    std::string if_end_label;

    std::string while_cond_label;
};

struct ir_program {
    std::vector<std::string> strings;
    std::vector<ir_func> funcs;
};

ir_program generate_ir(type_system& ts, ast_node& program_node);

}