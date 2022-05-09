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
    .asciz "Hello world"
.text
cb__Nroot__Nmain:
# func main(): {}
 push %rbp
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 lea .cbstr0(%rip),%rax
# ir_load_addr STR0; (push)

 mov %rax,-16(%rbp)
# ir_load [L0 . 0] POP();

 mov $11,%r10d
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] 11;

 lea -16(%rbp),%rax
# ir_load_addr L0; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

cb__Nroot__Nmain$end:
 add $32,%rsp
 pop %rbp
 ret


