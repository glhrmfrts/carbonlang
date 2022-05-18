.global cb__Nroot__Nmain
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
.cbstr0:
    .asciz "Hello World asd qwewq e\n"
.text
cb__Nroot__Nmain:
# fun main() => opaque
 push %rbp
 movq %rsp,%rbp
 sub $48,%rsp
# prolog end

 lea .cbstr0(%rip),%rax
# ir_load_addr STR0; (push)

 movq %rax,-16(%rbp)
# ir_load [L0 . 0] POP();

 movq $24,%r10
 movq %r10,-8(%rbp)
# ir_load [L0 . 1] 24;

 movq -8(%rbp),%rdx
 movq -16(%rbp),%rsi
 movq $1,%rdi
 call cb__Nrt__Nx86_64__Nwrite__Aint__Aptr__Tpure__Tbyte__Aint
# ir_call cb__Nrt__Nx86_64__Nwrite__Aint__Aptr__Tpure__Tbyte__Aint 1 [L0 . 0] [L0 . 1];

.cb__Nroot__Nmain$end:
 add $48,%rsp
 pop %rbp
 ret


