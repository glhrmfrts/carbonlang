#pragma once

#include <string_view>
#include <fstream>
#include <vector>
#include "codegen_x64.hh"

namespace carbon {

struct emitter {
    //std::stack<std::int32_t> i32_stack;
    //std::stack<gen_register> reg_stack;
    std::string current_func;
    std::ofstream out_file;

    explicit emitter(std::string_view filename);

    std::vector<gen_register> get_argument_registers();

    void end();

    void begin_data_segment();

    void begin_code_segment();

    void begin_func(const char* func_name);

    void end_func();

    void ret();

    void call(const char* func_name);

    void push(gen_operand reg);

    void pop(gen_operand reg);

    void lea(gen_destination dst, gen_destination op);

    void mov(gen_destination reg, gen_operand src);

    void add(gen_destination a, gen_operand b);

    void sub(gen_destination a, gen_operand b);

    void imul(gen_destination a, gen_operand b);

    void xor(gen_destination a, gen_operand b);

    void emit(const char* fmt, ...);

    void emitln(const char* fmt, ...);
};

}