#pragma once

#include <string_view>
#include <fstream>
#include <stack>
#include "codegen_x64.hh"

namespace carbon {

struct emitter {
    //std::stack<std::int32_t> i32_stack;
    //std::stack<gen_register> reg_stack;
    std::string current_func;
    std::ofstream out_file;

    explicit emitter(std::string_view filename);

    void end();

    void begin_data_segment();

    void begin_code_segment();

    void begin_func(const char* func_name);

    void end_func();

    void ret();

    void mov(gen_register reg, gen_register src);

    void mov_offset(gen_register reg, gen_register src, std::size_t offs);

    void mov_literal(gen_register reg, std::int32_t val);

    void add(gen_register a, gen_register b);

    void sub(gen_register a, gen_register b);

    void imul(gen_register a, gen_register b);

    void emit(const char* fmt, ...);

    void emitln(const char* fmt, ...);
};

}