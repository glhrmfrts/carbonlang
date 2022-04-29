#pragma once

#include <variant>
#include <memory>
#include "carbonc.hh"
#include "type_system.hh"

namespace carbon {

enum ir_op {
    ir_load,
    ir_copy,
    ir_cast,
    ir_add,
    ir_sub,
    ir_mul,
    ir_div,
    ir_neg,
    ir_and,
    ir_or,
    ir_shr,
    ir_shl,
    ir_call,
    ir_return,
    ir_index,
    ir_deref,
    ir_load_addr,
    ir_make_label,
    ir_asm,
    ir_cmp_lt,
    ir_cmp_gt,
    ir_cmp_lteq,
    ir_cmp_gteq,
    ir_cmp_eq,
    ir_cmp_neq,
    ir_jmp,
    ir_jmp_eq,
    ir_jmp_neq,
    ir_jmp_gt,
    ir_jmp_gte,
    ir_jmp_lt,
    ir_jmp_lte,
    ir_stack_dup,
    ir_noop,
};

struct ir_local_data {
    std::string name;
    type_id type;

    inline bool operator ==(const ir_local_data& other) const { return name == other.name && type == other.type; }
};

struct ir_arg_data {
    std::string name;
    type_id type;

    inline bool operator ==(const ir_arg_data& other) const { return name == other.name && type == other.type; }
};

struct ir_stackpop {
    type_id type;

    inline bool operator ==(const ir_stackpop& other) const { return type == other.type; }
};

struct ir_global {
    std::string name;
    type_id type;

    inline bool operator ==(const ir_global& other) const { return name == other.name && type == other.type; }
};

struct ir_local {
    int index;
    type_id type;

    inline bool operator ==(const ir_local& other) const { return index == other.index && type == other.type; }
};

struct ir_arg {
    int index;
    type_id type;

    inline bool operator ==(const ir_arg& other) const { return index == other.index && type == other.type; }
};

struct ir_string {
    int index;

    inline bool operator ==(const ir_string& other) const { return index == other.index; }
};

struct ir_int {
    int_type val;
    type_id type;

    inline bool operator ==(const ir_int& other) const { return val == other.val && type == other.type; }
};

struct ir_float {
    float_type val;
    type_id type;

    inline bool operator ==(const ir_float& other) const { return val == other.val && type == other.type; }
};

struct ir_funclabel {
    std::string name;
    type_id type;

    inline bool operator ==(const ir_funclabel& other) const { return name == other.name && type == other.type; }
};

struct ir_label {
    std::string name;

    inline bool operator ==(const ir_label& other) const { return name == other.name; }
};

struct ir_field;

using ir_ref = std::variant<ir_global, ir_local, ir_arg, ir_stackpop, std::shared_ptr<ir_field>>;

struct ir_field {
    ir_ref ref;
    int field_index;

    inline bool operator ==(const ir_field& other) const {
        return ref == other.ref && field_index == other.field_index;
    }
};

using ir_operand = std::variant<std::string, ir_field, ir_label, ir_funclabel, ir_global, ir_local, ir_arg, ir_stackpop, ir_string, ir_int, ir_float, char>;

struct ir_instr {
    ir_op op;
    type_id result_type;
    std::vector<ir_operand> operands;
    int index;

    inline bool contents_equal(const ir_instr& other) const {
        bool operands_equal = true;
        if (operands.size() != other.operands.size()) {
            return false;
        }
        for (size_t i = 0; i < operands.size(); i++) {
            const auto& myop = operands[i];
            const auto& otherop = other.operands[i];
            if (!(myop == otherop)) {
                return false;
            }
        }
        return (op == other.op && result_type == other.result_type && operands_equal);
    }
};

struct ir_global_data {
    std::string name;
    type_id type;
    std::optional<ir_operand> value;
    func_linkage linkage;
    decl_visibility visibility;
};

struct ir_func {
    std::string name;
    std::string demangled_name;
    std::vector<ir_arg_data> args;
    std::vector<ir_local_data> locals;
    std::vector<ir_instr> instrs;
    type_id ret_type;
    decl_visibility visibility;
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

    std::vector<ast_node*> scope_defer_statements;
};

struct ir_program {
    std::vector<std::string> strings;
    std::vector<ir_global_data> globals;
    std::vector<ir_func> funcs;
};

int ref_opstack_consumption(const ir_ref& ref);

int operand_opstack_consumption(const ir_operand& opr);

int instr_opstack_consumption(const ir_instr& instr);

bool instr_pushes_to_stack(const ir_instr& instr);

std::string sprint_ir_instr(const ir_instr& instr);

ir_program generate_ir(type_system& ts, ast_node& program_node);

}