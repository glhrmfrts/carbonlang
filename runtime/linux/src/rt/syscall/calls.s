.text
.global syscall_1
.global syscall_2
.global syscall_3
.global syscall_4
.global syscall_5
.global syscall_6

# Procedures to shift the arguments into syscall-compatible protocol

syscall_1:
    mov %rdi, %rax
    mov %rsi, %rdi
    syscall
    ret

syscall_2:
    mov %rdi, %rax
    mov %rsi, %rdi
    mov %rdx, %rsi
    syscall
    ret

syscall_3:
    mov %rdi, %rax
    mov %rsi, %rdi
    mov %rdx, %rsi
    mov %rcx, %rdx
    syscall
    ret

syscall_4:
    mov %rdi, %rax
    mov %rsi, %rdi
    mov %rdx, %rsi
    mov %rcx, %rdx
    mov %r8, %r10
    syscall
    ret

syscall_5:
    mov %rdi, %rax
    mov %rsi, %rdi
    mov %rdx, %rsi
    mov %rcx, %rdx
    mov %r8, %r10
    mov %r9, %r8
    syscall
    ret

syscall_6:
    mov %rdi, %rax
    mov %rsi, %rdi
    mov %rdx, %rsi
    mov %rcx, %rdx
    mov %r8, %r10
    mov %r9, %r8
    mov 56(%rsp), %r9
    syscall
    ret
