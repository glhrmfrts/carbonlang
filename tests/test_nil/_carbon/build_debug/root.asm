.global cb__Nroot__Nmain
.data
    .align 16
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
    .string ","
.cbstr1:
    .string ""
.text
cb__Nroot__Nmain:
# func main(): {}
 push %rbp
 mov %rsp,%rbp
 sub $64,%rsp
# prolog end

 xor %rdi,%rdi
 call cb__Nstd__Nio__Nprintln__Anil
# ir_call cb__Nstd__Nio__Nprintln__Anil 0;

 xor %r10,%r10
 mov %r10,-8(%rbp)
# ir_store L0 0 0 8;

 mov -8(%rbp),%edi
 call cb__Nstd__Nio__Nprint__Aint
# ir_call cb__Nstd__Nio__Nprint__Aint [L0 . 0];

 lea .cbstr0,%rax
# ir_load_addr STR0; (push)

 mov %rax,-32(%rbp)
# ir_load [L1 . 0] POP();

 mov $1,%r10d
 mov %r10,-24(%rbp)
# ir_load [L1 . 1] 1;

 lea -32(%rbp),%rax
# ir_load_addr L1; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8 POP();

 mov -4(%rbp),%edi
 call cb__Nstd__Nio__Nprint__Aint
# ir_call cb__Nstd__Nio__Nprint__Aint [L0 . 1];

 lea .cbstr1,%rax
# ir_load_addr STR1; (push)

 mov %rax,-48(%rbp)
# ir_load [L2 . 0] POP();

 xor %r10d,%r10d
 mov %r10,-40(%rbp)
# ir_load [L2 . 1] 0;

 lea -48(%rbp),%rax
# ir_load_addr L2; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 mov $1304468645,%edi
 call cb__Nstd__Nio__Nprintln__Aint
# ir_call cb__Nstd__Nio__Nprintln__Aint 1304468645;

cb__Nroot__Nmain$end:
 add $64,%rsp
 pop %rbp
 ret


