#pragma once

#include <variant>
#include <array>
#include <string_view>
#include <iostream>
#include <fstream>
#include "carbonc.hh"

namespace carbon {

template <class... Ts> struct overload : Ts... { using Ts::operator()...; };
template <class... Ts> overload(Ts...)->overload<Ts...>;

enum gen_register {
    invalid,
    rax,
    rbx,
    rcx,
    rdx,
    rdi,
    rsi,
    rbp,
    rsp,
    r8,
    r9,
    r10,
    r11,
    r12,
    r13,
    r14,
    r15,
    eax,
    ebx,
    ecx,
    edx,
    edi,
    esi,
    ebp,
    esp,
    r8d,
    r9d,
    r10d,
    r11d,
    r12d,
    r13d,
    r14d,
    r15d,
    ax,
    bx,
    cx,
    dx,
    di,
    si,
    bp,
    sp,
    r8w,
    r9w,
    r10w,
    r11w,
    r12w,
    r13w,
    r14w,
    r15w,
    al,
    bl,
    cl,
    dl,
    dil,
    sil,
    bpl,
    spl,
    r8b,
    r9b,
    r10b,
    r11b,
    r12b,
    r13b,
    r14b,
    r15b,
};

struct gen_data_offset {
    std::string label;

    bool operator ==(const gen_data_offset& other) const {
        return label == other.label;
    }
};

using gen_offset_expr = std::variant<gen_register, gen_data_offset, int_type>;

struct gen_offset {
    std::size_t op_size;
    gen_register base;
    std::array<gen_offset_expr, 2> offsets;
    gen_offset_expr mult;

    bool operator ==(const gen_offset& other) const {
        return base == other.base && offsets[0] == other.offsets[0] && offsets[1] == other.offsets[1] && mult == other.mult && op_size == other.op_size;
    }
};

using gen_destination = std::variant<gen_register, gen_data_offset, gen_offset>;

using gen_operand = std::variant<gen_register, gen_offset, gen_data_offset, int_type, char>;

struct gen_register_sizes {
    gen_register r64;
    gen_register r32;
    gen_register r16;
    gen_register r8high;
    gen_register r8low;
};

struct codegen_x64_emitter {
    std::string current_func;
    std::ofstream out_file;

    explicit codegen_x64_emitter(std::string_view filename) {
        out_file = std::ofstream{ std::string{filename} };
    }

    virtual ~codegen_x64_emitter() {}

    virtual std::vector<gen_register> args_registers() = 0;

    virtual std::vector<gen_register> temp_registers() = 0;

    virtual void add_global_func_decl(const char* name) = 0;

    virtual void add_export_func_decl(const char* name) = 0;

    virtual void add_extern_func_decl(const char* name) = 0;

    virtual void end() = 0;

    virtual void begin_data_segment() = 0;

    virtual void add_string_data(std::string_view label, std::string_view data) = 0;

    virtual void add_global_int16(std::string_view label, int16_t v) = 0;

    virtual void add_global_int32(std::string_view label, int32_t v) = 0;

    virtual void add_global_int64(std::string_view label, int64_t v) = 0;

    virtual void begin_code_segment() = 0;

    virtual void begin_func(const char* func_name) = 0;

    virtual void end_func() = 0;

    virtual void ret() = 0;

    virtual void call(const char* func_name) = 0;

    virtual void calldest(gen_destination dest) = 0;

    virtual void push(gen_operand reg) = 0;

    virtual void pop(gen_operand reg) = 0;

    virtual void lea(gen_destination reg, gen_destination src) = 0;

    virtual void mov(gen_destination reg, gen_operand src) = 0;

    virtual void movsx(gen_destination reg, gen_operand src) = 0;

    virtual void movzx(gen_destination reg, gen_operand src) = 0;

    virtual void add(gen_destination a, gen_operand b) = 0;

    virtual void sub(gen_destination a, gen_operand b) = 0;

    virtual void imul(gen_destination a, gen_operand b) = 0;

    virtual void idiv(gen_destination b) = 0;

    virtual void and_(gen_destination a, gen_operand b) = 0;

    virtual void or_(gen_destination a, gen_operand b) = 0;

    virtual void neg(gen_destination a) = 0;

    virtual void sal(gen_destination a, gen_operand b) = 0;

    virtual void sar(gen_destination a, gen_operand b) = 0;

    virtual void cdq(type_id t) = 0;

    virtual void xor_(gen_destination a, gen_operand b) = 0;

    virtual void jmp(const char* label) = 0;

    virtual void cmp(gen_operand a, gen_operand b) = 0;

    virtual void label(const char* label) = 0;

    virtual void comment_prefix() = 0;

    virtual std::string special_label(const std::string& label) = 0;

    void emit(const char* fmt, ...) {
        static char buffer[1024];
        std::va_list args;
        va_start(args, fmt);
        std::vsnprintf(buffer, sizeof(buffer), fmt, args);
        va_end(args);
        out_file << buffer;
    }

    void emitln(const char* fmt, ...) {
        static char buffer[1024];
        std::va_list args;
        va_start(args, fmt);
        std::vsnprintf(buffer, sizeof(buffer), fmt, args);
        va_end(args);
        out_file << buffer << "\n";
    }

    void comment(const char* fmt, ...) {
        static char buffer[1024];
        std::va_list args;
        va_start(args, fmt);
        std::vsnprintf(buffer, sizeof(buffer), fmt, args);
        va_end(args);

        comment_prefix();

        out_file << buffer << "\n";
    }
};

std::size_t get_size(const gen_destination& v);
std::size_t get_size(const gen_operand& v);

extern const char* register_names[65];

}