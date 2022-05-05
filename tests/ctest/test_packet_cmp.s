
.data

.comm arr1,128,32
.comm arr2,128,32

.number:
    .long   1073741824

.msgequal:
    .string "YEqual!\n"

.msgnotequal:
    .string "NEqual!\n"

.text
.global _start
_start:
    movdqa arr1(%rip), %xmm0

    movss .number(%rip), %xmm2
    pxor %xmm2, %xmm2
    paddd %xmm2, %xmm0

    psadbw arr2(%rip), %xmm0

    movq %xmm0, %rax

    cmp $0,%ax
    jne .not_equal

    mov $1, %rax
    mov $1, %rdi
    lea .msgequal, %rsi
    mov $8, %rdx
    syscall

    mov $60, %rax
    mov $0, %rdi
    syscall

.not_equal:
    mov $1, %rax
    mov $1, %rdi
    lea .msgnotequal, %rsi
    mov $8, %rdx
    syscall

    mov $60, %rax
    mov $69, %rdi
    syscall

    hlt
