.global cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8
.global cb__Nstd__Nio__Nprint__Aint
.global cb__Nstd__Nio__Nprint__Ausize
.global cb__Nstd__Nio__Nprint__Abool
.global cb__Nstd__Nio__Nprint__Anil
.global cb__Nstd__Nio__Nprint__Aerror
.global cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8
.global cb__Nstd__Nio__Nprintln__Aint
.global cb__Nstd__Nio__Nprintln__Ausize
.global cb__Nstd__Nio__Nprintln__Aptr__Topaque
.global cb__Nstd__Nio__Nprintln__Abool
.global cb__Nstd__Nio__Nprintln__Anil
.global cb__Nstd__Nio__Nprintln__Aerror
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
    .asciz "true"
.cbstr1:
    .asciz "false"
.cbstr2:
    .asciz "nil"
.cbstr3:
    .asciz "\n"
.cbstr4:
    .asciz ""
.text
cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8:
# func print([]pure uint8): {}
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 push %rdi
 push %rsi
 lea -16(%rbp),%rdi
 lea 0(%rax),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L0 POP() 16;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -16(%rbp),%rax
# ir_load_addr L0; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

.cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8$end:
 add $40,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nio__Nprint__Aint:
# func print(int): {}
 mov %edi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 call cb__Nstd__Nsystem__Nstdout
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 mov 16(%rbp),%esi
 mov %rax,%rdi
 call cb__Nstd__Nsystem__Nwrite_int__Afile_handle__Aint
# ir_call cb__Nstd__Nsystem__Nwrite_int__Afile_handle__Aint POP() A0;

.cb__Nstd__Nio__Nprint__Aint$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nstd__Nio__Nprint__Ausize:
# func print(usize): {}
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov 16(%rbp),%r10
 mov %r10d,%eax
# ir_cast A0; (push)

 mov %eax,%edi
 call cb__Nstd__Nio__Nprint__Aint
# ir_call cb__Nstd__Nio__Nprint__Aint POP();

.cb__Nstd__Nio__Nprint__Ausize$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nstd__Nio__Nprint__Abool:
# func print(bool): {}
 mov %dil,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $48,%rsp
# prolog end

 mov 16(%rbp),%r10b
 cmp $0,%r10b
 je .if277$else
# ir_jmp_eq A0 0 .if277$else;

.if277$body:
# ir_make_label .if277$body;

 lea .cbstr0(%rip),%rax
# ir_load_addr STR0; (push)

 mov %rax,-16(%rbp)
# ir_load [L0 . 0] POP();

 mov $4,%r10d
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] 4;

 lea -16(%rbp),%rax
# ir_load_addr L0; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8 POP();

 jmp .if277$end
# ir_jmp .if277$end;

.if277$else:
# ir_make_label .if277$else;

 lea .cbstr1(%rip),%rax
# ir_load_addr STR1; (push)

 mov %rax,-32(%rbp)
# ir_load [L1 . 0] POP();

 mov $5,%r10d
 mov %r10,-24(%rbp)
# ir_load [L1 . 1] 5;

 lea -32(%rbp),%rax
# ir_load_addr L1; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8 POP();

.if277$end:
# ir_make_label .if277$end;

.cb__Nstd__Nio__Nprint__Abool$end:
 add $48,%rsp
 pop %rbp
 ret


cb__Nstd__Nio__Nprint__Anil:
# func print(nil): {}
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 lea .cbstr2(%rip),%rax
# ir_load_addr STR2; (push)

 mov %rax,-16(%rbp)
# ir_load [L0 . 0] POP();

 mov $3,%r10d
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] 3;

 lea -16(%rbp),%rax
# ir_load_addr L0; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8 POP();

.cb__Nstd__Nio__Nprint__Anil$end:
 add $32,%rsp
 pop %rbp
 ret


cb__Nstd__Nio__Nprint__Aerror:
# func print(error): {}
 mov %edi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $48,%rsp
# prolog end

 lea -16(%rbp),%rax
# ir_load_addr L0; (push)

 mov 16(%rbp),%esi
 mov %rax,%rdi
 call cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror
# ir_call cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror POP() A0;

 push %rdi
 push %rsi
 lea -32(%rbp),%rdi
 lea -16(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L1 L0 16;

 lea -32(%rbp),%rax
# ir_load_addr L1; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8 POP();

.cb__Nstd__Nio__Nprint__Aerror$end:
 add $48,%rsp
 pop %rbp
 ret


cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8:
# func println([]pure uint8): {}
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $48,%rsp
# prolog end

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 push %rdi
 push %rsi
 lea -16(%rbp),%rdi
 lea 0(%rax),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L0 POP() 16;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -16(%rbp),%rax
# ir_load_addr L0; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

 lea .cbstr3(%rip),%rax
# ir_load_addr STR3; (push)

 mov %rax,-32(%rbp)
# ir_load [L1 . 0] POP();

 mov $1,%r10d
 mov %r10,-24(%rbp)
# ir_load [L1 . 1] 1;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -32(%rbp),%rax
# ir_load_addr L1; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

.cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8$end:
 add $56,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nio__Nprintln__Aint:
# func println(int): {}
 mov %edi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 call cb__Nstd__Nsystem__Nstdout
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 mov 32(%rbp),%esi
 mov %rax,%rdi
 call cb__Nstd__Nsystem__Nwrite_int__Afile_handle__Aint
# ir_call cb__Nstd__Nsystem__Nwrite_int__Afile_handle__Aint POP() A0;

 lea .cbstr3(%rip),%rax
# ir_load_addr STR3; (push)

 mov %rax,-16(%rbp)
# ir_load [L0 . 0] POP();

 mov $1,%r10d
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] 1;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -16(%rbp),%rax
# ir_load_addr L0; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

.cb__Nstd__Nio__Nprintln__Aint$end:
 add $40,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nio__Nprintln__Ausize:
# func println(usize): {}
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov 16(%rbp),%r10
 mov %r10d,%eax
# ir_cast A0; (push)

 mov %eax,%edi
 call cb__Nstd__Nio__Nprintln__Aint
# ir_call cb__Nstd__Nio__Nprintln__Aint POP();

.cb__Nstd__Nio__Nprintln__Ausize$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nstd__Nio__Nprintln__Aptr__Topaque:
# func println(&opaque): {}
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov 16(%rbp),%r10
 mov %r10d,%eax
# ir_cast A0; (push)

 mov %eax,%edi
 call cb__Nstd__Nio__Nprintln__Aint
# ir_call cb__Nstd__Nio__Nprintln__Aint POP();

.cb__Nstd__Nio__Nprintln__Aptr__Topaque$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nstd__Nio__Nprintln__Abool:
# func println(bool): {}
 mov %dil,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 mov 16(%rbp),%dil
 call cb__Nstd__Nio__Nprint__Abool
# ir_call cb__Nstd__Nio__Nprint__Abool A0;

 lea .cbstr4(%rip),%rax
# ir_load_addr STR4; (push)

 mov %rax,-16(%rbp)
# ir_load [L0 . 0] POP();

 xor %r10d,%r10d
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] 0;

 lea -16(%rbp),%rax
# ir_load_addr L0; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

.cb__Nstd__Nio__Nprintln__Abool$end:
 add $32,%rsp
 pop %rbp
 ret


cb__Nstd__Nio__Nprintln__Anil:
# func println(nil): {}
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 mov 16(%rbp),%rdi
 call cb__Nstd__Nio__Nprint__Anil
# ir_call cb__Nstd__Nio__Nprint__Anil A0;

 lea .cbstr4(%rip),%rax
# ir_load_addr STR4; (push)

 mov %rax,-16(%rbp)
# ir_load [L0 . 0] POP();

 xor %r10d,%r10d
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] 0;

 lea -16(%rbp),%rax
# ir_load_addr L0; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

.cb__Nstd__Nio__Nprintln__Anil$end:
 add $32,%rsp
 pop %rbp
 ret


cb__Nstd__Nio__Nprintln__Aerror:
# func println(error): {}
 mov %edi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 mov 16(%rbp),%edi
 call cb__Nstd__Nio__Nprint__Aerror
# ir_call cb__Nstd__Nio__Nprint__Aerror A0;

 lea .cbstr4(%rip),%rax
# ir_load_addr STR4; (push)

 mov %rax,-16(%rbp)
# ir_load [L0 . 0] POP();

 xor %r10d,%r10d
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] 0;

 lea -16(%rbp),%rax
# ir_load_addr L0; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

.cb__Nstd__Nio__Nprintln__Aerror$end:
 add $32,%rsp
 pop %rbp
 ret


