.text
.global _start
.extern __gamma_start
_start:
    mov 0(%rsp), %rdi # argc
    lea 8(%rsp), %rsi # argv

    and $~15, %rsp # align the stack to 16 bytes to follow the ABI

    sub $16, %rsp # reserve stack space for __carbon_main arguments

    call __gamma_start

    hlt
    