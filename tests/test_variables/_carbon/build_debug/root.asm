.global cb__Nroot__Nrun_compiler__Aptr__Tslice__Tpure__Tuint8
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
    .asciz "-p"
.cbstr1:
    .asciz "../../.."
.cbstr2:
    .asciz "-I"
.cbstr3:
    .asciz "stdlib"
.cbstr4:
    .asciz "-o"
.cbstr5:
    .asciz "test.out"
.cbstr6:
    .asciz "/usr/bin/carbonc"
.cbstr7:
    .asciz "subtest1"
.text
cb__Nroot__Nrun_compiler__Aptr__Tslice__Tpure__Tuint8:
# func run_compiler([]pure uint8): int
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 push %r12
 mov %rsp,%rbp
 sub $320,%rsp
# prolog end

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

 mov $6,%r10d
 mov %r10,-168(%rbp)
# ir_load [L1 . 1] 6;

 mov -176(%rbp),%rax
# ir_deref [L1 . 0]; (push)

 xor %r10,%r10
 imul $16,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() 0; (push)

 lea (%rax),%r10
 mov %r10,-248(%rbp)
# ir_load_ptr L6 POP();

 mov -248(%rbp),%rbx
# ir_deref L6; (push)

 lea .cbstr0(%rip),%rax
# ir_load_addr STR0; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov -248(%rbp),%rax
# ir_deref L6; (push)

 mov $2,%r10d
 mov %r10,8(%rax)
# ir_load [POP() . 1] 2;

 mov -176(%rbp),%rax
# ir_deref [L1 . 0]; (push)

 mov $1,%r10
 imul $16,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() 1; (push)

 lea (%rax),%r10
 mov %r10,-256(%rbp)
# ir_load_ptr L7 POP();

 mov -256(%rbp),%rbx
# ir_deref L7; (push)

 lea .cbstr1(%rip),%rax
# ir_load_addr STR1; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov -256(%rbp),%rax
# ir_deref L7; (push)

 mov $8,%r10d
 mov %r10,8(%rax)
# ir_load [POP() . 1] 8;

 mov -176(%rbp),%rax
# ir_deref [L1 . 0]; (push)

 mov $2,%r10
 imul $16,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() 2; (push)

 lea (%rax),%r10
 mov %r10,-264(%rbp)
# ir_load_ptr L8 POP();

 mov -264(%rbp),%rbx
# ir_deref L8; (push)

 lea .cbstr2(%rip),%rax
# ir_load_addr STR2; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov -264(%rbp),%rax
# ir_deref L8; (push)

 mov $2,%r10d
 mov %r10,8(%rax)
# ir_load [POP() . 1] 2;

 mov -176(%rbp),%rax
# ir_deref [L1 . 0]; (push)

 mov $3,%r10
 imul $16,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() 3; (push)

 lea (%rax),%r10
 mov %r10,-272(%rbp)
# ir_load_ptr L9 POP();

 mov -272(%rbp),%rbx
# ir_deref L9; (push)

 lea .cbstr3(%rip),%rax
# ir_load_addr STR3; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov -272(%rbp),%rax
# ir_deref L9; (push)

 mov $6,%r10d
 mov %r10,8(%rax)
# ir_load [POP() . 1] 6;

 mov -176(%rbp),%rax
# ir_deref [L1 . 0]; (push)

 mov $4,%r10
 imul $16,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() 4; (push)

 lea (%rax),%r10
 mov %r10,-280(%rbp)
# ir_load_ptr L10 POP();

 mov -280(%rbp),%rbx
# ir_deref L10; (push)

 lea .cbstr4(%rip),%rax
# ir_load_addr STR4; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov -280(%rbp),%rax
# ir_deref L10; (push)

 mov $2,%r10d
 mov %r10,8(%rax)
# ir_load [POP() . 1] 2;

 mov -176(%rbp),%rax
# ir_deref [L1 . 0]; (push)

 mov $5,%r10
 imul $16,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() 5; (push)

 lea (%rax),%r10
 mov %r10,-288(%rbp)
# ir_load_ptr L11 POP();

 mov -288(%rbp),%rbx
# ir_deref L11; (push)

 lea .cbstr5(%rip),%rax
# ir_load_addr STR5; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov -288(%rbp),%rax
# ir_deref L11; (push)

 mov $8,%r10d
 mov %r10,8(%rax)
# ir_load [POP() . 1] 8;

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 push %rdi
 push %rsi
 lea -208(%rbp),%rdi
 lea 0(%rax),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L3 POP() 16;

 lea -208(%rbp),%rax
# ir_load_addr L3; (push)

 mov %rax,%rdi
 call cb__Nstd__Nsystem__Nchdir__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nchdir__Aptr__Tslice__Tpure__Tuint8 POP(); (push)

# ir_noop POP();

 lea .cbstr6(%rip),%rax
# ir_load_addr STR6; (push)

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

 mov -184(%rbp),%eax
# ir_return [L2 . 0];

.cb__Nroot__Nrun_compiler__Aptr__Tslice__Tpure__Tuint8$end:
 add $320,%rsp
 pop %r12
 pop %rbx
 pop %rbp
 ret


cb__Nroot__Nmain:
# func main(): {}
 push %rbp
 mov %rsp,%rbp
 sub $144,%rsp
# prolog end

 lea -32(%rbp),%rax
# ir_load_addr L0; (push)

 mov $10,%esi
 mov %rax,%rdi
 call cb__Nstd__Nmem__Nalloc_slice__Cint__Aptr__Ttuple__Tslice__Tint__Terror__Ausize
# ir_call cb__Nstd__Nmem__Nalloc_slice__Cint__Aptr__Ttuple__Tslice__Tint__Terror__Ausize POP() 10;

 push %rdi
 push %rsi
 lea -48(%rbp),%rdi
 lea -32(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L1 [L0 . 0] 16;

 mov -16(%rbp),%r10d
 mov %r10d,-52(%rbp)
# ir_load L2 [L0 . 1];

 lea -96(%rbp),%rax
# ir_load_addr L3; (push)

 mov $20,%esi
 mov %rax,%rdi
 call cb__Nstd__Nmem__Nalloc_slice__Cint__Aptr__Ttuple__Tslice__Tint__Terror__Ausize
# ir_call cb__Nstd__Nmem__Nalloc_slice__Cint__Aptr__Ttuple__Tslice__Tint__Terror__Ausize POP() 20;

 push %rdi
 push %rsi
 lea -112(%rbp),%rdi
 lea -96(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L4 [L3 . 0] 16;

 mov -80(%rbp),%r10d
 mov %r10d,-52(%rbp)
# ir_load L2 [L3 . 1];

 lea .cbstr7(%rip),%rax
# ir_load_addr STR7; (push)

 mov %rax,-128(%rbp)
# ir_load [L5 . 0] POP();

 mov $8,%r10d
 mov %r10,-120(%rbp)
# ir_load [L5 . 1] 8;

 lea -128(%rbp),%rax
# ir_load_addr L5; (push)

 mov %rax,%rdi
 call cb__Nroot__Nrun_compiler__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nroot__Nrun_compiler__Aptr__Tslice__Tpure__Tuint8 POP(); (push)

 cmp $0,%eax
 sete %al
# ir_cmp_eq POP() 0; (push)

 mov %al,%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool POP();

.cb__Nroot__Nmain$end:
 add $144,%rsp
 pop %rbp
 ret


