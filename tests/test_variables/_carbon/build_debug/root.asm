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
    .string "hi"
.cbstr1:
    .string "/usr/bin/carbonc"
.text
cb__Nroot__Nmain:
# func main(): {}
 push %rbp
 push %rbx
 push %r12
 mov %rsp,%rbp
 sub $272,%rsp
# prolog end

 lea .cbstr0,%rax
# ir_load_addr STR0; (push)

 mov %rax,-208(%rbp)
# ir_load [L3 . 0] POP();

 mov $2,%r10d
 mov %r10,-200(%rbp)
# ir_load [L3 . 1] 2;

 lea -208(%rbp),%rax
# ir_load_addr L3; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 push %rdi
 xor %rax,%rax
 mov $20,%rcx
 lea -160(%rbp),%rdi
 rep stosq
 pop %rdi
# ir_store L0 0 0 160;

 xor %r10,%r10
 imul $16,%r10
 lea -160(%rbp,%r10,1),%rax
# ir_index L0 0; (push)

 lea (%rax),%rax
# ir_load_addr POP(); (push)

 mov %rax,-176(%rbp)
# ir_load [L1 . 0] POP();

 xor %r10d,%r10d
 mov %r10,-168(%rbp)
# ir_load [L1 . 1] 0;

 lea .cbstr1,%rax
# ir_load_addr STR1; (push)

 mov %rax,-224(%rbp)
# ir_load [L4 . 0] POP();

 mov $16,%r10d
 mov %r10,-216(%rbp)
# ir_load [L4 . 1] 16;

 push %rdi
 push %rsi
 lea -240(%rbp),%rdi
 lea -176(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L5 L1 16;

 lea -184(%rbp),%rbx
# ir_load_addr L2; (push)

 lea -224(%rbp),%r12
# ir_load_addr L4; (push)

 lea -240(%rbp),%rax
# ir_load_addr L5; (push)

 mov %rax,%rdx
 mov %r12,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8 POP() POP() POP();

# ir_noop L2;

cb__Nroot__Nmain$end:
 add $272,%rsp
 pop %r12
 pop %rbx
 pop %rbp
 ret


