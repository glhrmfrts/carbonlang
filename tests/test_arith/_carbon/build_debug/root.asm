.global cb__Nroot__Nmain
.global cb__Nroot__Ntest_div__Aint__Aint
.data
    .balign 16
    .size .cmp16selector, 16
.cmp16selector:
    .byte 0x0
    .byte 0x1
    .byte 0x8
    .byte 0x9
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
.section .rodata
.text
cb__Nroot__Nmain:
# func main(): {}
 push %rbp
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 mov $5,%esi
 mov $10,%edi
 call cb__Nroot__Ntest_div__Aint__Aint
# ir_call cb__Nroot__Ntest_div__Aint__Aint 10 5; (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

 mov -4(%rbp),%edi
 call cb__Nstd__Nio__Nprintln__Aint
# ir_call cb__Nstd__Nio__Nprintln__Aint L0;

cb__Nroot__Nmain$end:
 add $32,%rsp
 pop %rbp
 ret


cb__Nroot__Ntest_div__Aint__Aint:
# func test_div(int, int): int
 mov %esi,16(%rsp)
 mov %edi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
# prolog end

 mov 16(%rbp),%eax
 cdq
 idivl 24(%rbp)
# ir_div A0 A1; (push)

# ir_return POP();

cb__Nroot__Ntest_div__Aint__Aint$end:
 pop %rbp
 ret


