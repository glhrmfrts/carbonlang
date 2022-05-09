.global cb__Nstd__Nlinux__Nprintbytes__Aptr__Tpure__Tuint8__Ausize
.global cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror
.global cb__Nstd__Nsystem__Nstdin
.global cb__Nstd__Nsystem__Nstdout
.global cb__Nstd__Nsystem__Nstderr
.global cb__Nstd__Nsystem__Nread__Afile_handle__Aptr__Tslice__Tuint8
.global cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8
.global cb__Nstd__Nsystem__Nclose__Afile_handle
.global cb__Nstd__Nsystem__Nchdir__Aptr__Tslice__Tpure__Tuint8
.global cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque
.global cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize
.global cb__Nstd__Nsystem__Nfree__Aptr__Topaque__Ausize
.global cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags
.global cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tfile_handle__Terror__Aptr__Tslice__Tpure__Tuint8__Aopen_flags__Aint
.global cb__Nstd__Nsystem__Nexit__Aint
.global cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8
.global cb__Nstd__Nsystem__Nerrno_to_error__Aint
.global cb__Nstd__Nsystem__Nwifexited__Aint
.global cb__Nstd__Nsystem__Nwifsignaled__Aint
.global cb__Nstd__Nsystem__Nwexitstatus__Aint
.global cb__Nstd__Nsystem__Nwtermsig__Aint
.global cb__Nstd__Nlinux__NtestAlloc
.global cb__Nstd__Nlinux__NtestMain__Aint
.global cb__Nstd__Nlinux__NtestBoolOp
.global __carbon_main
.global cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__TStat
.global cb__Nstd__Nsystem__Nstat__Afile_handle__Aptr__TStat
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
    .asciz ","
.cbstr1:
    .asciz ""
.cbstr2:
    .asciz "noerr"
.cbstr3:
    .asciz "Unknown error"
.cbstr4:
    .asciz "ALLOC_FAILED\n"
.cbstr5:
    .asciz "testAlloc: OK\n"
.cbstr6:
    .asciz "\n"
.cbstr7:
    .asciz "I'm going to segfault, ok?\n"
.text
cb__Nstd__Nlinux__Nprintbytes__Aptr__Tpure__Tuint8__Ausize:
# func printbytes(&pure uint8, usize): {}
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $96,%rsp
# prolog end

 xor %r10d,%r10d
 mov %r10d,-48(%rbp)
# ir_load [L2 . 0] 0;

 mov 24(%rbp),%r10
 mov %r10,-40(%rbp)
# ir_load [L2 . 1] A1;

 mov -48(%rbp),%r10d
 mov %r10d,-20(%rbp)
# ir_load L1 [L2 . 0];

cb__Nstd__Nlinux__Nprintbytes__Aptr__Tpure__Tuint8__Ausize$f441$cond:
# ir_make_label cb__Nstd__Nlinux__Nprintbytes__Aptr__Tpure__Tuint8__Ausize$f441$cond;

 mov -20(%rbp),%r10d
 mov %r10,%rax
# ir_cast L1; (push)

 cmp -40(%rbp),%rax
 jge cb__Nstd__Nlinux__Nprintbytes__Aptr__Tpure__Tuint8__Ausize$f441$end
# ir_jmp_gte POP() [L2 . 1] cb__Nstd__Nlinux__Nprintbytes__Aptr__Tpure__Tuint8__Ausize$f441$end;

cb__Nstd__Nlinux__Nprintbytes__Aptr__Tpure__Tuint8__Ausize$f441$body:
# ir_make_label cb__Nstd__Nlinux__Nprintbytes__Aptr__Tpure__Tuint8__Ausize$f441$body;

 mov 16(%rbp),%rax
# ir_deref A0; (push)

 mov -20(%rbp),%r10d
 mov %r10,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L1; (push)

 mov (%rax),%r10b
 mov %r10b,-65(%rbp)
# ir_load L4 POP();

 mov -65(%rbp),%r10b
 mov %r10d,%eax
# ir_cast L4; (push)

 mov %eax,%edi
 call cb__Nstd__Nio__Nprint__Aint
# ir_call cb__Nstd__Nio__Nprint__Aint POP();

 lea .cbstr0(%rip),%rax
# ir_load_addr STR0; (push)

 mov %rax,-64(%rbp)
# ir_load [L3 . 0] POP();

 mov $1,%r10d
 mov %r10,-56(%rbp)
# ir_load [L3 . 1] 1;

 lea -64(%rbp),%rax
# ir_load_addr L3; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8 POP();

 mov -20(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L1 1; (push)

 mov %eax,-20(%rbp)
# ir_load L1 POP();

 jmp cb__Nstd__Nlinux__Nprintbytes__Aptr__Tpure__Tuint8__Ausize$f441$cond
# ir_jmp cb__Nstd__Nlinux__Nprintbytes__Aptr__Tpure__Tuint8__Ausize$f441$cond;

cb__Nstd__Nlinux__Nprintbytes__Aptr__Tpure__Tuint8__Ausize$f441$end:
# ir_make_label cb__Nstd__Nlinux__Nprintbytes__Aptr__Tpure__Tuint8__Ausize$f441$end;

 lea .cbstr1(%rip),%rax
# ir_load_addr STR1; (push)

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

cb__Nstd__Nlinux__Nprintbytes__Aptr__Tpure__Tuint8__Ausize$end:
 add $96,%rsp
 pop %rbp
 ret


cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror:
# func error_string(&[]pure uint8, error): &[]pure uint8
 mov %esi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $96,%rsp
# prolog end

 mov 40(%rbp),%r10d
 cmp $0,%r10d
 jne cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$if471$else
# ir_jmp_neq A1 0 cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$if471$else;

cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$if471$body:
# ir_make_label cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$if471$body;

 mov 32(%rbp),%r10
 mov %r10,-64(%rbp)
# ir_load L6 A0;

 mov -64(%rbp),%rbx
# ir_deref L6; (push)

 lea .cbstr2(%rip),%rax
# ir_load_addr STR2; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov -64(%rbp),%rax
# ir_deref L6; (push)

 mov $5,%r10d
 mov %r10,8(%rax)
# ir_load [POP() . 1] 5;

 mov 32(%rbp),%rax
 jmp cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$end
# ir_return A0;

cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$if471$else:
# ir_make_label cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$if471$else;

 lea __error_array_start(%rip),%rax
# ir_load_addr ; (push)

 mov %rax,-8(%rbp)
# ir_load L0 POP();

 lea __error_array_end(%rip),%rax
# ir_load_addr ; (push)

 mov %rax,-16(%rbp)
# ir_load L1 POP();

 mov -8(%rbp),%r10
 mov %r10,-24(%rbp)
# ir_load L2 L0;

 mov 40(%rbp),%r10d
 mov %r10d,-28(%rbp)
# ir_load L3 A1;

cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$w574$cond:
# ir_make_label cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$w574$cond;

 mov -24(%rbp),%r10
 cmp -16(%rbp),%r10
 jge cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$w574$end
# ir_jmp_gte L2 L1 cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$w574$end;

cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$w574$body:
# ir_make_label cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$w574$body;

 mov -24(%rbp),%r10
 mov %r10,-56(%rbp)
# ir_load L5 L2;

 mov -24(%rbp),%r10
 add $4,%r10
 mov %r10,%rax
# ir_add L2 4; (push)

 mov %rax,-24(%rbp)
# ir_load L2 POP();

 lea -48(%rbp),%rax
# ir_load_addr L4; (push)

 mov -24(%rbp),%rsi
 mov %rax,%rdi
 call cb__Nstd__Nstring__Nfrom_cstring__Aptr__Tslice__Tpure__Tuint8__Aptr__Tpure__Tuint8
# ir_call cb__Nstd__Nstring__Nfrom_cstring__Aptr__Tslice__Tpure__Tuint8__Aptr__Tpure__Tuint8 POP() L2;

 mov -56(%rbp),%rax
# ir_deref L5; (push)

 mov -28(%rbp),%r10d
 cmp 0(%rax),%r10d
 jne cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$if557$else
# ir_jmp_neq L3 POP() cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$if557$else;

cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$if557$body:
# ir_make_label cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$if557$body;

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 push %rdi
 push %rsi
 lea 0(%rax),%rdi
 lea -48(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy POP() L4 16;

 mov 32(%rbp),%rax
 jmp cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$end
# ir_return A0;

cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$if557$else:
# ir_make_label cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$if557$else;

 mov -24(%rbp),%r10
 add -40(%rbp),%r10
 mov %r10,%rax
# ir_add L2 [L4 . 1]; (push)

 mov %rax,-24(%rbp)
# ir_load L2 POP();

 mov $16,%rsi
 mov -24(%rbp),%rdi
 call cb__Nstd__Nmem__Nalign__Ausize__Ausize
# ir_call cb__Nstd__Nmem__Nalign__Ausize__Ausize L2 16; (push)

 mov %rax,-24(%rbp)
# ir_load L2 POP();

 jmp cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$w574$cond
# ir_jmp cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$w574$cond;

cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$w574$end:
# ir_make_label cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$w574$end;

 mov 32(%rbp),%r10
 mov %r10,-72(%rbp)
# ir_load L7 A0;

 mov -72(%rbp),%rbx
# ir_deref L7; (push)

 lea .cbstr3(%rip),%rax
# ir_load_addr STR3; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov -72(%rbp),%rax
# ir_deref L7; (push)

 mov $13,%r10d
 mov %r10,8(%rax)
# ir_load [POP() . 1] 13;

 mov 32(%rbp),%rax
# ir_return A0;

cb__Nstd__Nsystem__Nerror_string__Aptr__Tslice__Tpure__Tuint8__Aerror$end:
 add $104,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nsystem__Nstdin:
# func stdin(): file_handle
 sub $8,%rsp
# prolog end

 xor %rax,%rax
# ir_return 0;

cb__Nstd__Nsystem__Nstdin$end:
 add $8,%rsp
 ret


cb__Nstd__Nsystem__Nstdout:
# func stdout(): file_handle
 sub $8,%rsp
# prolog end

 mov $1,%rax
# ir_return 1;

cb__Nstd__Nsystem__Nstdout$end:
 add $8,%rsp
 ret


cb__Nstd__Nsystem__Nstderr:
# func stderr(): file_handle
 sub $8,%rsp
# prolog end

 mov $2,%rax
# ir_return 2;

cb__Nstd__Nsystem__Nstderr$end:
 add $8,%rsp
 ret


cb__Nstd__Nsystem__Nread__Afile_handle__Aptr__Tslice__Tuint8:
# func read(file_handle, []uint8): {}
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 push %r12
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 mov 32(%rbp),%r10
 mov %r10d,%ebx
# ir_cast A0; (push)

 mov 40(%rbp),%r12
# ir_deref A1; (push)

# ir_stack_dup; (push)

 mov 8(%r12),%rdx
 mov 0(%r12),%rsi
 mov %ebx,%edi
 call cb__Nstd__Nlinux__Nsyscall__Nread__Auint__Aptr__Tuint8__Ausize
# ir_call cb__Nstd__Nlinux__Nsyscall__Nread__Auint__Aptr__Tuint8__Ausize POP() [POP() . 0] [POP() . 1];

cb__Nstd__Nsystem__Nread__Afile_handle__Aptr__Tslice__Tuint8$end:
 add $32,%rsp
 pop %r12
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8:
# func write(file_handle, []pure uint8): {}
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 push %r12
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 mov 32(%rbp),%r10
 mov %r10d,%ebx
# ir_cast A0; (push)

 mov 40(%rbp),%r12
# ir_deref A1; (push)

# ir_stack_dup; (push)

 mov 8(%r12),%rdx
 mov 0(%r12),%rsi
 mov %ebx,%edi
 call cb__Nstd__Nlinux__Nsyscall__Nwrite__Auint__Aptr__Tpure__Tuint8__Ausize
# ir_call cb__Nstd__Nlinux__Nsyscall__Nwrite__Auint__Aptr__Tpure__Tuint8__Ausize POP() [POP() . 0] [POP() . 1];

cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8$end:
 add $32,%rsp
 pop %r12
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nsystem__Nclose__Afile_handle:
# func close(file_handle): error
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov 16(%rbp),%r10
 mov %r10d,%eax
# ir_cast A0; (push)

 mov %eax,%edi
 call cb__Nstd__Nlinux__Nsyscall__Nclose__Auint
# ir_call cb__Nstd__Nlinux__Nsyscall__Nclose__Auint POP();

 xor %eax,%eax
# ir_return 0;

cb__Nstd__Nsystem__Nclose__Afile_handle$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nstd__Nsystem__Nchdir__Aptr__Tslice__Tpure__Tuint8:
# func chdir([]pure uint8): error
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov 16(%rbp),%rax
# ir_deref A0; (push)

 mov 0(%rax),%rdi
 call cb__Nstd__Nlinux__Nsyscall__Nchdir__Aptr__Tpure__Tuint8
# ir_call cb__Nstd__Nlinux__Nsyscall__Nchdir__Aptr__Tpure__Tuint8 [POP() . 0];

 xor %eax,%eax
# ir_return 0;

cb__Nstd__Nsystem__Nchdir__Aptr__Tslice__Tpure__Tuint8$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque:
# func alloc(&{&opaque, error}, usize, &opaque): &{&opaque, error}
 mov %rdx,24(%rsp)
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $80,%rsp
# prolog end

 mov 48(%rbp),%r10
 mov %r10,-8(%rbp)
# ir_load L0 A2;

 mov -8(%rbp),%rbx
# ir_deref L0; (push)

# ir_stack_dup; (push)

 xor %r9d,%r9d
 xor %r8d,%r8d
 mov 4(%rbx),%ecx
 mov 0(%rbx),%edx
 mov 40(%rbp),%rsi
 xor %rdi,%rdi
 call cb__Nstd__Nlinux__Nsyscall__Nmmap__Aptr__Topaque__Ausize__Aint__Aint__Aint__Ausize
# ir_call cb__Nstd__Nlinux__Nsyscall__Nmmap__Aptr__Topaque__Ausize__Aint__Aint__Aint__Ausize 0 A1 [POP() . 0] [POP() . 1] 0 0; (push)

 mov %rax,-16(%rbp)
# ir_load L1 POP();

 mov $1,%eax
 neg %eax
# ir_neg 1; (push)

 mov %eax,%r10d
 mov %r10,%rax
# ir_cast POP(); (push)

 mov -16(%rbp),%r10
 cmp %rax,%r10
 jne cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque$if899$else
# ir_jmp_neq L1 POP() cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque$if899$else;

cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque$if899$body:
# ir_make_label cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque$if899$body;

 mov 32(%rbp),%r10
 mov %r10,-24(%rbp)
# ir_load L2 A0;

 mov -24(%rbp),%rax
# ir_deref L2; (push)

 xor %r10,%r10
 mov %r10,0(%rax)
# ir_load [POP() . 0] 0;

 mov -24(%rbp),%rax
# ir_deref L2; (push)

 mov $1304468645,%r10d
 mov %r10d,8(%rax)
# ir_load [POP() . 1] 1304468645;

 mov 32(%rbp),%rax
 jmp cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque$end
# ir_return A0;

cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque$if899$else:
# ir_make_label cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque$if899$else;

 mov 32(%rbp),%r10
 mov %r10,-32(%rbp)
# ir_load L3 A0;

 mov -32(%rbp),%rax
# ir_deref L3; (push)

 mov -16(%rbp),%r10
 mov %r10,0(%rax)
# ir_load [POP() . 0] L1;

 mov -32(%rbp),%rax
# ir_deref L3; (push)

 xor %r10d,%r10d
 mov %r10d,8(%rax)
# ir_load [POP() . 1] 0;

 mov 32(%rbp),%rax
# ir_return A0;

cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque$end:
 add $88,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize:
# func alloc(&{&opaque, error}, usize): &{&opaque, error}
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 push %r12
 mov %rsp,%rbp
 sub $64,%rsp
# prolog end

 xor %r10,%r10
 mov %r10,-8(%rbp)
# ir_store L0 0 0 8;

 mov $1,%r10d
 or $2,%r10d
 mov %r10d,%eax
# ir_or 1 2; (push)

 mov %eax,-8(%rbp)
# ir_load [L0 . 0] POP();

 mov $2,%r10d
 or $32,%r10d
 mov %r10d,%eax
# ir_or 2 32; (push)

 mov %eax,-4(%rbp)
# ir_load [L0 . 1] POP();

 mov 32(%rbp),%rbx
# ir_deref A0; (push)

 lea -32(%rbp),%r12
# ir_load_addr L1; (push)

 lea -8(%rbp),%rax
# ir_load_addr L0; (push)

 mov %rax,%rdx
 mov 40(%rbp),%rsi
 mov %r12,%rdi
 call cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque
# ir_call cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque POP() A1 POP();

 push %rdi
 push %rsi
 lea 0(%rbx),%rdi
 lea -32(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy POP() L1 16;

 mov 32(%rbp),%rax
# ir_return A0;

cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$end:
 add $64,%rsp
 pop %r12
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nsystem__Nfree__Aptr__Topaque__Ausize:
# func free(&opaque, usize): {}
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov 24(%rbp),%rsi
 mov 16(%rbp),%rdi
 call cb__Nstd__Nlinux__Nsyscall__Nmunmap__Aptr__Topaque__Ausize
# ir_call cb__Nstd__Nlinux__Nsyscall__Nmunmap__Aptr__Topaque__Ausize A0 A1;

cb__Nstd__Nsystem__Nfree__Aptr__Topaque__Ausize$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags:
# func to_kernel_flags(open_flags): int
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 xor %r10d,%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 0;

 mov $1,%r10d
 or $2,%r10d
 mov %r10d,%eax
# ir_or 1 2; (push)

 and %eax,%edi
 mov %edi,%eax
# ir_and A0 POP(); (push)

 cmp $0,%eax
 je cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1103$else
# ir_jmp_eq POP() 0 cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1103$else;

cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1103$body:
# ir_make_label cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1103$body;

 mov $2,%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 2;

 jmp cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1103$end
# ir_jmp cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1103$end;

cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1103$else:
# ir_make_label cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1103$else;

 and $1,%edi
 mov %edi,%eax
# ir_and A0 1; (push)

 cmp $0,%eax
 je cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1102$else
# ir_jmp_eq POP() 0 cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1102$else;

cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1102$body:
# ir_make_label cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1102$body;

 mov $1,%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 1;

 jmp cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1102$end
# ir_jmp cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1102$end;

cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1102$else:
# ir_make_label cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1102$else;

 and $2,%edi
 mov %edi,%eax
# ir_and A0 2; (push)

 cmp $0,%eax
 je cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1101$else
# ir_jmp_eq POP() 0 cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1101$else;

cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1101$body:
# ir_make_label cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1101$body;

 xor %r10d,%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 0;

cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1101$else:
# ir_make_label cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1101$else;

cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1102$end:
# ir_make_label cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1102$end;

cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1103$end:
# ir_make_label cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1103$end;

 and $4,%edi
 mov %edi,%eax
# ir_and A0 4; (push)

 cmp $0,%eax
 je cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1113$else
# ir_jmp_eq POP() 0 cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1113$else;

cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1113$body:
# ir_make_label cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1113$body;

 mov -4(%rbp),%r10d
 or $64,%r10d
 mov %r10d,%eax
# ir_or L0 64; (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1113$else:
# ir_make_label cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1113$else;

 and $8,%edi
 mov %edi,%eax
# ir_and A0 8; (push)

 cmp $0,%eax
 je cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1123$else
# ir_jmp_eq POP() 0 cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1123$else;

cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1123$body:
# ir_make_label cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1123$body;

 mov -4(%rbp),%r10d
 or $1024,%r10d
 mov %r10d,%eax
# ir_or L0 1024; (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1123$else:
# ir_make_label cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1123$else;

 and $16,%edi
 mov %edi,%eax
# ir_and A0 16; (push)

 cmp $0,%eax
 je cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1133$else
# ir_jmp_eq POP() 0 cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1133$else;

cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1133$body:
# ir_make_label cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1133$body;

 mov -4(%rbp),%r10d
 or $512,%r10d
 mov %r10d,%eax
# ir_or L0 512; (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1133$else:
# ir_make_label cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$if1133$else;

 mov -4(%rbp),%eax
# ir_return L0;

cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tfile_handle__Terror__Aptr__Tslice__Tpure__Tuint8__Aopen_flags__Aint:
# func open(&{file_handle, error}, &[]pure uint8, open_flags, int): &{file_handle, error}
 mov %ecx,32(%rsp)
 mov %edx,24(%rsp)
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $48,%rsp
# prolog end

 mov 48(%rbp),%edi
 call cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags
# ir_call cb__Nstd__Nlinux__Nto_kernel_flags__Aopen_flags A2; (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

 mov 40(%rbp),%rbx
# ir_deref A1; (push)

 mov 56(%rbp),%r10d
 mov %r10w,%ax
# ir_cast A3; (push)

 mov %ax,%dx
 mov -4(%rbp),%esi
 mov 0(%rbx),%rdi
 call cb__Nstd__Nlinux__Nsyscall__Nopen__Aptr__Tpure__Tuint8__Aint__Aint16
# ir_call cb__Nstd__Nlinux__Nsyscall__Nopen__Aptr__Tpure__Tuint8__Aint__Aint16 [POP() . 0] L0 POP(); (push)

 mov %eax,-8(%rbp)
# ir_load L1 POP();

 mov 32(%rbp),%r10
 mov %r10,-16(%rbp)
# ir_load L2 A0;

 mov -16(%rbp),%rbx
# ir_deref L2; (push)

 mov -8(%rbp),%r10d
 mov %r10,%rax
# ir_cast L1; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov -16(%rbp),%rax
# ir_deref L2; (push)

 xor %r10d,%r10d
 mov %r10d,8(%rax)
# ir_load [POP() . 1] 0;

 mov 32(%rbp),%rax
# ir_return A0;

cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tfile_handle__Terror__Aptr__Tslice__Tpure__Tuint8__Aopen_flags__Aint$end:
 add $56,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nsystem__Nexit__Aint:
# func exit(int): {}
 mov %edi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov 16(%rbp),%edi
 call cb__Nstd__Nlinux__Nsyscall__Nexit__Aint
# ir_call cb__Nstd__Nlinux__Nsyscall__Nexit__Aint A0;

cb__Nstd__Nsystem__Nexit__Aint$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8:
# func process(&{int, error}, &[]pure uint8, &[][]pure uint8): &{int, error}
 mov %rdx,24(%rsp)
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $160,%rsp
# prolog end

 call cb__Nstd__Nlinux__Nsyscall__Nfork
# ir_call cb__Nstd__Nlinux__Nsyscall__Nfork; (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

 mov -4(%rbp),%r10d
 cmp $0,%r10d
 jne cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1411$else
# ir_jmp_neq L0 0 cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1411$else;

cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1411$body:
# ir_make_label cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1411$body;

 lea -64(%rbp),%rbx
# ir_load_addr L3; (push)

 mov 48(%rbp),%rax
# ir_deref A2; (push)

 mov 8(%rax),%r10
 add $2,%r10
 mov %r10,%rax
# ir_add [POP() . 1] 2; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nmem__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize
# ir_call cb__Nstd__Nmem__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize POP() POP();

 push %rdi
 push %rsi
 lea -32(%rbp),%rdi
 lea -64(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L2 [L3 . 0] 16;

 mov -48(%rbp),%r10d
 mov %r10d,-8(%rbp)
# ir_load L1 [L3 . 1];

 mov -32(%rbp),%rax
# ir_deref [L2 . 0]; (push)

 xor %r10,%r10
 lea 0(%rax,%r10,8),%rbx
# ir_index POP() 0; (push)

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%r10
 mov %r10,(%rbx)
# ir_load POP() [POP() . 0];

 xor %r10d,%r10d
 mov %r10d,-96(%rbp)
# ir_load [L5 . 0] 0;

 mov 48(%rbp),%rax
# ir_deref A2; (push)

 mov 8(%rax),%r10
 mov %r10,-88(%rbp)
# ir_load [L5 . 1] [POP() . 1];

 mov -96(%rbp),%r10d
 mov %r10d,-68(%rbp)
# ir_load L4 [L5 . 0];

cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$f1315$cond:
# ir_make_label cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$f1315$cond;

 mov -68(%rbp),%r10d
 mov %r10,%rax
# ir_cast L4; (push)

 cmp -88(%rbp),%rax
 jge cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$f1315$end
# ir_jmp_gte POP() [L5 . 1] cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$f1315$end;

cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$f1315$body:
# ir_make_label cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$f1315$body;

 mov -32(%rbp),%rbx
# ir_deref [L2 . 0]; (push)

 mov -68(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L4 1; (push)

 mov %eax,%r10d
 mov %r10,%r10
 lea 0(%rbx,%r10,8),%rbx
# ir_index POP() POP(); (push)

 mov 48(%rbp),%rax
# ir_deref A2; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 mov -68(%rbp),%r10d
 mov %r10,%r10
 imul $16,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L4; (push)

 mov 0(%rax),%r10
 mov %r10,(%rbx)
# ir_load POP() [POP() . 0];

 mov -68(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L4 1; (push)

 mov %eax,-68(%rbp)
# ir_load L4 POP();

 jmp cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$f1315$cond
# ir_jmp cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$f1315$cond;

cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$f1315$end:
# ir_make_label cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$f1315$end;

 mov -32(%rbp),%rbx
# ir_deref [L2 . 0]; (push)

 mov 48(%rbp),%rax
# ir_deref A2; (push)

 mov 8(%rax),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add [POP() . 1] 1; (push)

 mov %rax,%r10
 lea 0(%rbx,%r10,8),%rax
# ir_index POP() POP(); (push)

 xor %r10,%r10
 mov %r10,(%rax)
# ir_load POP() 0;

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 xor %rdx,%rdx
 mov -32(%rbp),%rsi
 mov 0(%rax),%rdi
 call cb__Nstd__Nlinux__Nsyscall__Nexecve__Aptr__Tpure__Tuint8__Aptr__Tptr__Tpure__Tuint8__Aptr__Tptr__Tpure__Tuint8
# ir_call cb__Nstd__Nlinux__Nsyscall__Nexecve__Aptr__Tpure__Tuint8__Aptr__Tptr__Tpure__Tuint8__Aptr__Tptr__Tpure__Tuint8 [POP() . 0] [L2 . 0] 0;

 xor %edi,%edi
 call cb__Nstd__Nlinux__Nsyscall__Nexit__Aint
# ir_call cb__Nstd__Nlinux__Nsyscall__Nexit__Aint 0;

 jmp cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1411$end
# ir_jmp cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1411$end;

cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1411$else:
# ir_make_label cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1411$else;

 mov $1,%eax
 neg %eax
# ir_neg 1; (push)

 mov -4(%rbp),%r10d
 cmp %eax,%r10d
 je cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1410$else
# ir_jmp_eq L0 POP() cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1410$else;

cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1410$body:
# ir_make_label cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1410$body;

 xor %r10d,%r10d
 mov %r10d,-100(%rbp)
# ir_load L6 0;

 lea -100(%rbp),%rax
# ir_load_addr L6; (push)

 xor %rcx,%rcx
 xor %edx,%edx
 mov %rax,%rsi
 mov -4(%rbp),%edi
 call cb__Nstd__Nlinux__Nsyscall__Nwait4__Aint__Aptr__Tint__Aint__Aptr__Topaque
# ir_call cb__Nstd__Nlinux__Nsyscall__Nwait4__Aint__Aptr__Tint__Aint__Aptr__Topaque L0 POP() 0 0;

 mov -100(%rbp),%edi
 call cb__Nstd__Nsystem__Nwifexited__Aint
# ir_call cb__Nstd__Nsystem__Nwifexited__Aint L6; (push)

 cmp $0,%al
 je cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1392$else
# ir_jmp_eq POP() 0 cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1392$else;

cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1392$body:
# ir_make_label cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1392$body;

 mov 32(%rbp),%r10
 mov %r10,-112(%rbp)
# ir_load L7 A0;

 mov -112(%rbp),%rbx
# ir_deref L7; (push)

 mov -100(%rbp),%edi
 call cb__Nstd__Nsystem__Nwexitstatus__Aint
# ir_call cb__Nstd__Nsystem__Nwexitstatus__Aint L6; (push)

 mov %eax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov -112(%rbp),%rax
# ir_deref L7; (push)

 xor %r10d,%r10d
 mov %r10d,4(%rax)
# ir_load [POP() . 1] 0;

 mov 32(%rbp),%rax
 jmp cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$end
# ir_return A0;

 jmp cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1392$end
# ir_jmp cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1392$end;

cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1392$else:
# ir_make_label cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1392$else;

 mov -100(%rbp),%edi
 call cb__Nstd__Nsystem__Nwifsignaled__Aint
# ir_call cb__Nstd__Nsystem__Nwifsignaled__Aint L6; (push)

 cmp $0,%al
 je cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1391$else
# ir_jmp_eq POP() 0 cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1391$else;

cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1391$body:
# ir_make_label cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1391$body;

 mov 32(%rbp),%r10
 mov %r10,-120(%rbp)
# ir_load L8 A0;

 mov -120(%rbp),%rbx
# ir_deref L8; (push)

 mov -100(%rbp),%edi
 call cb__Nstd__Nsystem__Nwtermsig__Aint
# ir_call cb__Nstd__Nsystem__Nwtermsig__Aint L6; (push)

 mov %eax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov -120(%rbp),%rax
# ir_deref L8; (push)

 xor %r10d,%r10d
 mov %r10d,4(%rax)
# ir_load [POP() . 1] 0;

 mov 32(%rbp),%rax
 jmp cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$end
# ir_return A0;

cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1391$else:
# ir_make_label cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1391$else;

cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1392$end:
# ir_make_label cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1392$end;

 mov $1,%edi
 call cb__Nstd__Nlinux__Nsyscall__Nexit__Aint
# ir_call cb__Nstd__Nlinux__Nsyscall__Nexit__Aint 1;

 jmp cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1410$end
# ir_jmp cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1410$end;

cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1410$else:
# ir_make_label cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1410$else;

 mov 32(%rbp),%r10
 mov %r10,-128(%rbp)
# ir_load L9 A0;

 mov -128(%rbp),%rax
# ir_deref L9; (push)

 xor %r10d,%r10d
 mov %r10d,0(%rax)
# ir_load [POP() . 0] 0;

 mov -128(%rbp),%rbx
# ir_deref L9; (push)

 mov -4(%rbp),%edi
 call cb__Nstd__Nsystem__Nerrno_to_error__Aint
# ir_call cb__Nstd__Nsystem__Nerrno_to_error__Aint L0; (push)

 mov %eax,4(%rbx)
# ir_load [POP() . 1] POP();

 mov 32(%rbp),%rax
 jmp cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$end
# ir_return A0;

cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1410$end:
# ir_make_label cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1410$end;

cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1411$end:
# ir_make_label cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$if1411$end;

cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8$end:
 add $168,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nsystem__Nerrno_to_error__Aint:
# func errno_to_error(int): error
 push %rbp
 mov %rsp,%rbp
# prolog end

 xor %eax,%eax
# ir_return 0;

cb__Nstd__Nsystem__Nerrno_to_error__Aint$end:
 pop %rbp
 ret


cb__Nstd__Nsystem__Nwifexited__Aint:
# func wifexited(int): bool
 push %rbp
 mov %rsp,%rbp
# prolog end

 mov $1,%al
# ir_return 1;

cb__Nstd__Nsystem__Nwifexited__Aint$end:
 pop %rbp
 ret


cb__Nstd__Nsystem__Nwifsignaled__Aint:
# func wifsignaled(int): bool
 push %rbp
 mov %rsp,%rbp
# prolog end

 xor %al,%al
# ir_return 0;

cb__Nstd__Nsystem__Nwifsignaled__Aint$end:
 pop %rbp
 ret


cb__Nstd__Nsystem__Nwexitstatus__Aint:
# func wexitstatus(int): int
 push %rbp
 mov %rsp,%rbp
# prolog end

 xor %eax,%eax
# ir_return 0;

cb__Nstd__Nsystem__Nwexitstatus__Aint$end:
 pop %rbp
 ret


cb__Nstd__Nsystem__Nwtermsig__Aint:
# func wtermsig(int): int
 push %rbp
 mov %rsp,%rbp
# prolog end

 xor %eax,%eax
# ir_return 0;

cb__Nstd__Nsystem__Nwtermsig__Aint$end:
 pop %rbp
 ret


cb__Nstd__Nlinux__NtestAlloc:
# func testAlloc(): {}
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $80,%rsp
# prolog end

 lea -16(%rbp),%rax
# ir_load_addr L0; (push)

 mov $16,%esi
 mov %rax,%rdi
 call cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize
# ir_call cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize POP() 16;

 mov -16(%rbp),%r10
 mov %r10,-24(%rbp)
# ir_load L1 [L0 . 0];

 mov -8(%rbp),%r10d
 mov %r10d,-28(%rbp)
# ir_load L2 [L0 . 1];

 mov -28(%rbp),%r10d
 cmp $0,%r10d
 je cb__Nstd__Nlinux__NtestAlloc$if1548$else
# ir_jmp_eq L2 0 cb__Nstd__Nlinux__NtestAlloc$if1548$else;

cb__Nstd__Nlinux__NtestAlloc$if1548$body:
# ir_make_label cb__Nstd__Nlinux__NtestAlloc$if1548$body;

 lea .cbstr4(%rip),%rax
# ir_load_addr STR4; (push)

 mov %rax,-64(%rbp)
# ir_load [L4 . 0] POP();

 mov $13,%r10d
 mov %r10,-56(%rbp)
# ir_load [L4 . 1] 13;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -64(%rbp),%rax
# ir_load_addr L4; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8 POP() POP();

 jmp cb__Nstd__Nlinux__NtestAlloc$end
# ir_return #0;

cb__Nstd__Nlinux__NtestAlloc$if1548$else:
# ir_make_label cb__Nstd__Nlinux__NtestAlloc$if1548$else;

 lea .cbstr5(%rip),%rax
# ir_load_addr STR5; (push)

 mov %rax,-48(%rbp)
# ir_load [L3 . 0] POP();

 mov $14,%r10d
 mov %r10,-40(%rbp)
# ir_load [L3 . 1] 14;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -48(%rbp),%rax
# ir_load_addr L3; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8 POP() POP();

 mov -24(%rbp),%rdi
 call cb__Nstd__Nmem__Nfree__Aptr__Topaque
# ir_call cb__Nstd__Nmem__Nfree__Aptr__Topaque L1;

cb__Nstd__Nlinux__NtestAlloc$end:
 add $88,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nlinux__NtestMain__Aint:
# func testMain(int): {}
 mov %edi,8(%rsp)
 push %rbp
 push %rbx
 push %r12
 push %r13
 sub $8,%rsp
 mov %rsp,%rbp
 sub $208,%rsp
# prolog end

 mov $1,%eax
 neg %eax
# ir_neg 1; (push)

 mov %eax,%r10d
 mov %r10,%rax
# ir_cast POP(); (push)

 mov %rax,-8(%rbp)
# ir_load L0 POP();

 lea -64(%rbp),%rbx
# ir_load_addr L3; (push)

 mov $10,%rax
# ir_cast 10; (push)

 imul $4,%rax
# ir_mul POP() 4; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize
# ir_call cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize POP() POP();

 mov -64(%rbp),%r10
 mov %r10,-72(%rbp)
# ir_load L4 [L3 . 0];

 mov -56(%rbp),%r10d
 mov %r10d,-76(%rbp)
# ir_load L5 [L3 . 1];

 mov -76(%rbp),%r10d
 cmp $0,%r10d
 je cb__Nstd__Nlinux__NtestMain__Aint$if1611$else
# ir_jmp_eq L5 0 cb__Nstd__Nlinux__NtestMain__Aint$if1611$else;

cb__Nstd__Nlinux__NtestMain__Aint$if1611$body:
# ir_make_label cb__Nstd__Nlinux__NtestMain__Aint$if1611$body;

 mov $1,%edi
 call cb__Nstd__Nsystem__Nexit__Aint
# ir_call cb__Nstd__Nsystem__Nexit__Aint 1;

cb__Nstd__Nlinux__NtestMain__Aint$if1611$else:
# ir_make_label cb__Nstd__Nlinux__NtestMain__Aint$if1611$else;

 call cb__Nstd__Nsystem__Nstdout
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 mov $1412312,%esi
 mov %rax,%rdi
 call cb__Nstd__Nsystem__Nwrite_int__Afile_handle__Aint
# ir_call cb__Nstd__Nsystem__Nwrite_int__Afile_handle__Aint POP() 1412312;

 lea .cbstr6(%rip),%rax
# ir_load_addr STR6; (push)

 mov %rax,-96(%rbp)
# ir_load [L6 . 0] POP();

 mov $1,%r10d
 mov %r10,-88(%rbp)
# ir_load [L6 . 1] 1;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -96(%rbp),%rax
# ir_load_addr L6; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8 POP() POP();

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 mov -72(%rbp),%r10
 mov %r10d,%eax
# ir_cast L4; (push)

 mov %eax,%esi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite_int__Afile_handle__Aint
# ir_call cb__Nstd__Nsystem__Nwrite_int__Afile_handle__Aint POP() POP();

 lea .cbstr6(%rip),%rax
# ir_load_addr STR6; (push)

 mov %rax,-112(%rbp)
# ir_load [L7 . 0] POP();

 mov $1,%r10d
 mov %r10,-104(%rbp)
# ir_load [L7 . 1] 1;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -112(%rbp),%rax
# ir_load_addr L7; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8 POP() POP();

 mov -72(%rbp),%r10
 mov %r10,-32(%rbp)
# ir_load [L1 . 0] L4;

 mov $10,%r10d
 mov %r10,-24(%rbp)
# ir_load [L1 . 1] 10;

 mov -32(%rbp),%rax
# ir_deref [L1 . 0]; (push)

 xor %r10,%r10
 lea 0(%rax,%r10,4),%rax
# ir_index POP() 0; (push)

 xor %r10d,%r10d
 mov %r10d,(%rax)
# ir_load POP() 0;

 mov -32(%rbp),%rax
# ir_deref [L1 . 0]; (push)

 mov $1,%r10
 lea 0(%rax,%r10,4),%rax
# ir_index POP() 1; (push)

 mov $1,%r10d
 mov %r10d,(%rax)
# ir_load POP() 1;

 mov $2,%r10d
 mov %r10d,-156(%rbp)
# ir_load [L11 . 0] 2;

 mov $10,%r10d
 mov %r10d,-152(%rbp)
# ir_load [L11 . 1] 10;

 mov -156(%rbp),%r10d
 mov %r10d,-148(%rbp)
# ir_load L10 [L11 . 0];

cb__Nstd__Nlinux__NtestMain__Aint$f1702$cond:
# ir_make_label cb__Nstd__Nlinux__NtestMain__Aint$f1702$cond;

 mov -148(%rbp),%r10d
 cmp -152(%rbp),%r10d
 jge cb__Nstd__Nlinux__NtestMain__Aint$f1702$end
# ir_jmp_gte L10 [L11 . 1] cb__Nstd__Nlinux__NtestMain__Aint$f1702$end;

cb__Nstd__Nlinux__NtestMain__Aint$f1702$body:
# ir_make_label cb__Nstd__Nlinux__NtestMain__Aint$f1702$body;

 mov -32(%rbp),%rax
# ir_deref [L1 . 0]; (push)

 mov -148(%rbp),%r10d
 mov %r10,%r10
 lea 0(%rax,%r10,4),%rbx
# ir_index POP() L10; (push)

 mov -32(%rbp),%r12
# ir_deref [L1 . 0]; (push)

 mov -148(%rbp),%r10d
 sub $1,%r10d
 mov %r10d,%eax
# ir_sub L10 1; (push)

 mov %eax,%r10d
 mov %r10,%r10
 lea 0(%r12,%r10,4),%r12
# ir_index POP() POP(); (push)

 mov -32(%rbp),%r13
# ir_deref [L1 . 0]; (push)

 mov -148(%rbp),%r10d
 sub $2,%r10d
 mov %r10d,%eax
# ir_sub L10 2; (push)

 mov %eax,%r10d
 mov %r10,%r10
 lea 0(%r13,%r10,4),%rax
# ir_index POP() POP(); (push)

 mov (%r12),%r10d
 add (%rax),%r10d
 mov %r10d,%eax
# ir_add POP() POP(); (push)

 mov %eax,(%rbx)
# ir_load POP() POP();

 mov -148(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L10 1; (push)

 mov %eax,-148(%rbp)
# ir_load L10 POP();

 jmp cb__Nstd__Nlinux__NtestMain__Aint$f1702$cond
# ir_jmp cb__Nstd__Nlinux__NtestMain__Aint$f1702$cond;

cb__Nstd__Nlinux__NtestMain__Aint$f1702$end:
# ir_make_label cb__Nstd__Nlinux__NtestMain__Aint$f1702$end;

 xor %r10d,%r10d
 mov %r10d,-168(%rbp)
# ir_load [L13 . 0] 0;

 mov $10,%r10d
 mov %r10d,-164(%rbp)
# ir_load [L13 . 1] 10;

 mov -168(%rbp),%r10d
 mov %r10d,-160(%rbp)
# ir_load L12 [L13 . 0];

cb__Nstd__Nlinux__NtestMain__Aint$f1729$cond:
# ir_make_label cb__Nstd__Nlinux__NtestMain__Aint$f1729$cond;

 mov -160(%rbp),%r10d
 cmp -164(%rbp),%r10d
 jge cb__Nstd__Nlinux__NtestMain__Aint$f1729$end
# ir_jmp_gte L12 [L13 . 1] cb__Nstd__Nlinux__NtestMain__Aint$f1729$end;

cb__Nstd__Nlinux__NtestMain__Aint$f1729$body:
# ir_make_label cb__Nstd__Nlinux__NtestMain__Aint$f1729$body;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 mov -32(%rbp),%rax
# ir_deref [L1 . 0]; (push)

 mov -160(%rbp),%r10d
 mov %r10,%r10
 lea 0(%rax,%r10,4),%rax
# ir_index POP() L12; (push)

 mov (%rax),%esi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite_int__Afile_handle__Aint
# ir_call cb__Nstd__Nsystem__Nwrite_int__Afile_handle__Aint POP() POP();

 lea .cbstr0(%rip),%rax
# ir_load_addr STR0; (push)

 mov %rax,-192(%rbp)
# ir_load [L14 . 0] POP();

 mov $1,%r10d
 mov %r10,-184(%rbp)
# ir_load [L14 . 1] 1;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -192(%rbp),%rax
# ir_load_addr L14; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8 POP() POP();

 mov -160(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L12 1; (push)

 mov %eax,-160(%rbp)
# ir_load L12 POP();

 jmp cb__Nstd__Nlinux__NtestMain__Aint$f1729$cond
# ir_jmp cb__Nstd__Nlinux__NtestMain__Aint$f1729$cond;

cb__Nstd__Nlinux__NtestMain__Aint$f1729$end:
# ir_make_label cb__Nstd__Nlinux__NtestMain__Aint$f1729$end;

 lea .cbstr6(%rip),%rax
# ir_load_addr STR6; (push)

 mov %rax,-128(%rbp)
# ir_load [L8 . 0] POP();

 mov $1,%r10d
 mov %r10,-120(%rbp)
# ir_load [L8 . 1] 1;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -128(%rbp),%rax
# ir_load_addr L8; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8 POP() POP();

 call cb__Nstd__Nlinux__NtestAlloc
# ir_call cb__Nstd__Nlinux__NtestAlloc;

 mov -72(%rbp),%rdi
 call cb__Nstd__Nmem__Nfree__Aptr__Topaque
# ir_call cb__Nstd__Nmem__Nfree__Aptr__Topaque L4;

 lea .cbstr7(%rip),%rax
# ir_load_addr STR7; (push)

 mov %rax,-144(%rbp)
# ir_load [L9 . 0] POP();

 mov $27,%r10d
 mov %r10,-136(%rbp)
# ir_load [L9 . 1] 27;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -144(%rbp),%rax
# ir_load_addr L9; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8 POP() POP();

 mov -32(%rbp),%rax
# ir_deref [L1 . 0]; (push)

 xor %r10,%r10
 lea 0(%rax,%r10,4),%rax
# ir_index POP() 0; (push)

 mov (%rax),%r10d
 mov %r10d,-36(%rbp)
# ir_load L2 POP();

 mov 48(%rbp),%edi
 call cb__Nstd__Nsystem__Nexit__Aint
# ir_call cb__Nstd__Nsystem__Nexit__Aint A0;

cb__Nstd__Nlinux__NtestMain__Aint$end:
 add $216,%rsp
 pop %r13
 pop %r12
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nlinux__NtestBoolOp:
# func testBoolOp(): bool
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 xor %r10d,%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 0;

 mov -4(%rbp),%r10d
 cmp $0,%r10d
 setg %al
# ir_cmp_gt L0 0; (push)

 mov %al,-5(%rbp)
# ir_load L1 POP();

 xor %al,%al
# ir_return 0;

cb__Nstd__Nlinux__NtestBoolOp$end:
 add $16,%rsp
 pop %rbp
 ret


__carbon_main:
# func __carbon_main(int, &&pure uint8): {}
 mov %rsi,16(%rsp)
 mov %edi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 call cb__Nroot__Nmain
# ir_call cb__Nroot__Nmain;

 xor %edi,%edi
 call cb__Nstd__Nsystem__Nexit__Aint
# ir_call cb__Nstd__Nsystem__Nexit__Aint 0;

__carbon_main$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__TStat:
# func stat([]pure uint8, &Stat): error
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $160,%rsp
# prolog end

 push %rdi
 xor %rax,%rax
 mov $17,%rcx
 lea -144(%rbp),%rdi
 rep stosq
 pop %rdi
# ir_store L0 0 0 136;

 mov 32(%rbp),%rbx
# ir_deref A0; (push)

 lea -144(%rbp),%rax
# ir_load_addr L0; (push)

 mov %rax,%rsi
 mov 0(%rbx),%rdi
 call cb__Nstd__Nlinux__Nsyscall__Nstat__Aptr__Tpure__Tuint8__Aptr__Topaque
# ir_call cb__Nstd__Nlinux__Nsyscall__Nstat__Aptr__Tpure__Tuint8__Aptr__Topaque [POP() . 0] POP(); (push)

 cmp $0,%eax
 jge cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__TStat$if1946$else
# ir_jmp_gte POP() 0 cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__TStat$if1946$else;

cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__TStat$if1946$body:
# ir_make_label cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__TStat$if1946$body;

 mov $2669138376,%eax
 jmp cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__TStat$end
# ir_return 2669138376;

cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__TStat$if1946$else:
# ir_make_label cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__TStat$if1946$else;

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov -96(%rbp),%r10
 mov %r10,0(%rax)
# ir_load [POP() . 0] [L0 . 8];

 xor %eax,%eax
# ir_return 0;

cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__TStat$end:
 add $168,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nsystem__Nstat__Afile_handle__Aptr__TStat:
# func stat(file_handle, &Stat): error
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $160,%rsp
# prolog end

 push %rdi
 xor %rax,%rax
 mov $17,%rcx
 lea -144(%rbp),%rdi
 rep stosq
 pop %rdi
# ir_store L0 0 0 136;

 mov 32(%rbp),%r10
 mov %r10d,%ebx
# ir_cast A0; (push)

 lea -144(%rbp),%rax
# ir_load_addr L0; (push)

 mov %rax,%rsi
 mov %ebx,%edi
 call cb__Nstd__Nlinux__Nsyscall__Nfstat__Aint__Aptr__Topaque
# ir_call cb__Nstd__Nlinux__Nsyscall__Nfstat__Aint__Aptr__Topaque POP() POP(); (push)

 cmp $0,%eax
 jge cb__Nstd__Nsystem__Nstat__Afile_handle__Aptr__TStat$if2000$else
# ir_jmp_gte POP() 0 cb__Nstd__Nsystem__Nstat__Afile_handle__Aptr__TStat$if2000$else;

cb__Nstd__Nsystem__Nstat__Afile_handle__Aptr__TStat$if2000$body:
# ir_make_label cb__Nstd__Nsystem__Nstat__Afile_handle__Aptr__TStat$if2000$body;

 mov $2669138376,%eax
 jmp cb__Nstd__Nsystem__Nstat__Afile_handle__Aptr__TStat$end
# ir_return 2669138376;

cb__Nstd__Nsystem__Nstat__Afile_handle__Aptr__TStat$if2000$else:
# ir_make_label cb__Nstd__Nsystem__Nstat__Afile_handle__Aptr__TStat$if2000$else;

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov -96(%rbp),%r10
 mov %r10,0(%rax)
# ir_load [POP() . 0] [L0 . 8];

 xor %eax,%eax
# ir_return 0;

cb__Nstd__Nsystem__Nstat__Afile_handle__Aptr__TStat$end:
 add $168,%rsp
 pop %rbx
 pop %rbp
 ret


