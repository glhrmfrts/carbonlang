#pragma once

#include <variant>

namespace carbon {

enum gen_register {
    invalid,
    rax,
    rbx,
    rcx,
    rdx,
    rdi,
    rbp,
    rsp,
    r8,
    r9,
    eax,
    ebx,
    ecx,
    edx,
    edi,
    ebp,
    esp,
    r8d,
    r9d,
};

struct gen_offset {
    gen_register reg;
    std::int32_t offset;
    std::size_t op_size;

    bool operator ==(const gen_offset& other) const {
        return reg == other.reg && offset == other.offset && op_size == other.op_size;
    }
};

using gen_destination = std::variant<gen_register, gen_offset>;

using gen_operand = std::variant<gen_register, gen_offset, std::int32_t>;

struct gen_register_sizes {
    gen_register r64;
    gen_register r32;
    gen_register r16;
    gen_register r8high;
    gen_register r8low;
};

}