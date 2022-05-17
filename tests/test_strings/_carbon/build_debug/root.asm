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
    .asciz "a string"
.cbstr1:
    .asciz ","
.text
cb__Nroot__Nmain:
# func main(): {}
 push %rbp
 movq %rsp,%rbp
 sub $240,%rsp
# prolog end

 lea .cbstr0(%rip),%rax
# ir_load_addr STR0; (push)

 movq %rax,-96(%rbp)
# ir_load [L5 . 0] POP();

 movl $8,%r10d
 movq %r10,-88(%rbp)
# ir_load [L5 . 1] 8;

 lea -96(%rbp),%rax
# ir_load_addr L5; (push)

 movq %rax,%rdi
 call cb__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 lea .cbstr0(%rip),%rax
# ir_load_addr STR0; (push)

 movq %rax,-16(%rbp)
# ir_load [L0 . 0] POP();

 movl $8,%r10d
 movq %r10,-8(%rbp)
# ir_load [L0 . 1] 8;

 lea .cbstr0(%rip),%rax
# ir_load_addr STR0; (push)

 movq %rax,-208(%rbp)
# ir_load [L12 . 0] POP();

 movl $8,%r10d
 movq %r10,-200(%rbp)
# ir_load [L12 . 1] 8;

 movq -16(%rbp),%r10
 cmp -208(%rbp),%r10
 sete %al
# ir_cmp_eq [L0 . 0] [L12 . 0]; (push)

 movb %al,%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool POP();

 lea .cbstr0(%rip),%rax
# ir_load_addr STR0; (push)

 movq %rax,-224(%rbp)
# ir_load [L13 . 0] POP();

 movl $8,%r10d
 movq %r10,-216(%rbp)
# ir_load [L13 . 1] 8;

 movq -216(%rbp),%rdi
 call cb__Nio__Nprintln__Ausize
# ir_call cb__Nio__Nprintln__Ausize [L13 . 1];

 movq -16(%rbp),%rax
# ir_deref [L0 . 0]; (push)

 xor %r10,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() 0; (push)

 movb (%rax),%r10b
 cmp $97,%r10b
 sete %al
# ir_cmp_eq POP() #97; (push)

 movb %al,%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool POP();

 movq -16(%rbp),%r10
 movq %r10,-24(%rbp)
# ir_load L1 [L0 . 0];

 movq -24(%rbp),%rax
# ir_deref L1; (push)

 movq -8(%rbp),%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() [L0 . 1]; (push)

 movb (%rax),%r10b
 movl %r10d,%eax
# ir_cast POP(); (push)

 cmp $0,%eax
 sete %al
# ir_cmp_eq POP() 0; (push)

 movb %al,%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool POP();

 movq -16(%rbp),%rax
# ir_deref [L0 . 0]; (push)

 movq $2,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() 2; (push)

 lea (%rax),%rax
# ir_load_addr POP(); (push)

 movq %rax,-48(%rbp)
# ir_load [L2 . 0] POP();

 movl $5,%r10d
 sub $2,%r10d
 movl %r10d,%eax
# ir_sub 5 2; (push)

 mov %eax,%r10d
 movq %r10,-40(%rbp)
# ir_load [L2 . 1] POP();

 push %rdi
 push %rsi
 lea -112(%rbp),%rdi
 lea -48(%rbp),%rsi
 movq $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L6 L2 16;

 lea -112(%rbp),%rax
# ir_load_addr L6; (push)

 movq %rax,%rdi
 call cb__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8 POP();

 lea .cbstr1(%rip),%rax
# ir_load_addr STR1; (push)

 movq %rax,-128(%rbp)
# ir_load [L7 . 0] POP();

 movl $1,%r10d
 movq %r10,-120(%rbp)
# ir_load [L7 . 1] 1;

 lea -128(%rbp),%rax
# ir_load_addr L7; (push)

 movq %rax,%rdi
 call cb__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8 POP();

 movq -40(%rbp),%rdi
 call cb__Nio__Nprintln__Ausize
# ir_call cb__Nio__Nprintln__Ausize [L2 . 1];

 movq -16(%rbp),%rax
# ir_deref [L0 . 0]; (push)

 xor %r10,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() 0; (push)

 lea (%rax),%rax
# ir_load_addr POP(); (push)

 movq %rax,-64(%rbp)
# ir_load [L3 . 0] POP();

 movl $5,%r10d
 sub $0,%r10d
 movl %r10d,%eax
# ir_sub 5 0; (push)

 mov %eax,%r10d
 movq %r10,-56(%rbp)
# ir_load [L3 . 1] POP();

 push %rdi
 push %rsi
 lea -144(%rbp),%rdi
 lea -64(%rbp),%rsi
 movq $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L8 L3 16;

 lea -144(%rbp),%rax
# ir_load_addr L8; (push)

 movq %rax,%rdi
 call cb__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8 POP();

 lea .cbstr1(%rip),%rax
# ir_load_addr STR1; (push)

 movq %rax,-160(%rbp)
# ir_load [L9 . 0] POP();

 movl $1,%r10d
 movq %r10,-152(%rbp)
# ir_load [L9 . 1] 1;

 lea -160(%rbp),%rax
# ir_load_addr L9; (push)

 movq %rax,%rdi
 call cb__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8 POP();

 movq -56(%rbp),%rdi
 call cb__Nio__Nprintln__Ausize
# ir_call cb__Nio__Nprintln__Ausize [L3 . 1];

 movq -16(%rbp),%rax
# ir_deref [L0 . 0]; (push)

 movq $2,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() 2; (push)

 lea (%rax),%rax
# ir_load_addr POP(); (push)

 movq %rax,-80(%rbp)
# ir_load [L4 . 0] POP();

 movq -8(%rbp),%r10
 sub $2,%r10
 movq %r10,%rax
# ir_sub [L0 . 1] 2; (push)

 movq %rax,-72(%rbp)
# ir_load [L4 . 1] POP();

 push %rdi
 push %rsi
 lea -176(%rbp),%rdi
 lea -80(%rbp),%rsi
 movq $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L10 L4 16;

 lea -176(%rbp),%rax
# ir_load_addr L10; (push)

 movq %rax,%rdi
 call cb__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8 POP();

 lea .cbstr1(%rip),%rax
# ir_load_addr STR1; (push)

 movq %rax,-192(%rbp)
# ir_load [L11 . 0] POP();

 movl $1,%r10d
 movq %r10,-184(%rbp)
# ir_load [L11 . 1] 1;

 lea -192(%rbp),%rax
# ir_load_addr L11; (push)

 movq %rax,%rdi
 call cb__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8 POP();

 movq -72(%rbp),%rdi
 call cb__Nio__Nprintln__Ausize
# ir_call cb__Nio__Nprintln__Ausize [L4 . 1];

.cb__Nroot__Nmain$end:
 add $240,%rsp
 pop %rbp
 ret


