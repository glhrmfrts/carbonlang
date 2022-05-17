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
 movq %rsp,%rbp
 sub $32,%rsp
# prolog end

 movl $5,%esi
 movl $10,%edi
 call cb__Nroot__Ntest_div__Aint__Aint
# ir_call cb__Nroot__Ntest_div__Aint__Aint 10 5; (push)

 movl %eax,-4(%rbp)
# ir_load L0 POP();

 movl -4(%rbp),%edi
 call cb__Nio__Nprintln__Aint
# ir_call cb__Nio__Nprintln__Aint L0;

 movl $42,%eax
 neg %eax
# ir_neg 42; (push)

 movl %eax,%edi
 call cb__Nio__Nprintln__Aint
# ir_call cb__Nio__Nprintln__Aint POP();

 movl $255,%r10d
 sar $4,%r10d
 movl %r10d,%eax
# ir_shr 255 4; (push)

 movl %eax,%edi
 call cb__Nio__Nprintln__Aint
# ir_call cb__Nio__Nprintln__Aint POP();

 movl $15,%r10d
 sal $4,%r10d
 movl %r10d,%eax
# ir_shl 15 4; (push)

 movl %eax,%edi
 call cb__Nio__Nprintln__Aint
# ir_call cb__Nio__Nprintln__Aint POP();

.cb__Nroot__Nmain$end:
 add $32,%rsp
 pop %rbp
 ret


cb__Nroot__Ntest_div__Aint__Aint:
# func test_div(int, int): int
 movl %esi,16(%rsp)
 movl %edi,8(%rsp)
 push %rbp
 movq %rsp,%rbp
# prolog end

 movl 16(%rbp),%eax
 cdq
 idivl 24(%rbp)
# ir_div A0 A1; (push)

# ir_return POP();

.cb__Nroot__Ntest_div__Aint__Aint$end:
 pop %rbp
 ret


