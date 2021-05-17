#pragma once

namespace carbon {

enum gen_register {
    invalid,
    rax,
    rbx,
    rcx,
    rdx,
    rdi,
    r8,
    r9,
    eax,
    ebx,
    ecx,
    edx,
    edi,
    r8d,
    r9d,
};

struct gen_register_sizes {
    gen_register r64;
    gen_register r32;
    gen_register r16;
    gen_register r8high;
    gen_register r8low;
};

}