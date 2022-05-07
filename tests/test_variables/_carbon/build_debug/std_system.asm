.extern cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize
.extern cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque
.extern cb__Nstd__Nsystem__Nfree__Aptr__Topaque__Ausize
.extern cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8
.extern cb__Nstd__Nsystem__Nread__Afile_handle__Aptr__Tslice__Tuint8
.extern cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tfile_handle__Terror__Aptr__Tslice__Tpure__Tuint8__Aopen_flags__Aint
.extern cb__Nstd__Nsystem__Nstdout
.extern cb__Nstd__Nsystem__Nstderr
.extern cb__Nstd__Nsystem__Nstdin
.extern cb__Nstd__Nsystem__Nfdflags__Afile_handle
.extern cb__Nstd__Nsystem__Nclose__Afile_handle
.extern cb__Nstd__Nsystem__Nseek__Afile_handle__Aint64__AWhence
.extern cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__TStat
.extern cb__Nstd__Nsystem__Nstat__Afile_handle__Aptr__TStat
.extern cb__Nstd__Nsystem__Nunlink__Aptr__Tslice__Tpure__Tuint8
.extern cb__Nstd__Nsystem__Nremove__Aptr__Tslice__Tpure__Tuint8
.extern cb__Nstd__Nsystem__Nrename__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8
.extern cb__Nstd__Nsystem__Ncopy__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8
.extern cb__Nstd__Nsystem__Nmkdir__Aptr__Tslice__Tpure__Tuint8
.extern cb__Nstd__Nsystem__Nchdir__Aptr__Tslice__Tpure__Tuint8
.extern cb__Nstd__Nsystem__Nexit__Aint
.extern cb__Nstd__Nsystem__Nprocess__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tslice__Tpure__Tuint8
.extern cb__Nstd__Nsystem__Nmake_thread__Aptr__Ttuple__Tthread_handle__Terror__Afuncptr__Tptr__Topaque__Tvoid__Aptr__Topaque
.extern cb__Nstd__Nsystem__Njoin__Athread_handle
.extern cb__Nstd__Nsystem__Nthread_id
.extern cb__Nstd__Nsystem__Ncpu_count
.extern cb__Nstd__Nsystem__Nmake_mutex__Aptr__Ttuple__Tmutex_handle__Terror
.extern cb__Nstd__Nsystem__Nlock__Amutex_handle
.extern cb__Nstd__Nsystem__Nunlock__Amutex_handle
.extern cb__Nstd__Nsystem__Ndestroy__Amutex_handle
.extern cb__Nstd__Nsystem__Nsleep_ms__Auint64
.global cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8
.global cb__Nstd__Nsystem__Nwrite_int__Afile_handle__Aint
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
    .string "zyxwvutsrqponmlkjihgfedcba9876543210123456789abcdefghijklmnopqrstuvwxyz"
.text
cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8:
# func intToString(int, int, []uint8): int
 mov %rdx,24(%rsp)
 mov %esi,16(%rsp)
 mov %edi,8(%rsp)
 push %rbp
 push %rbx
 push %r12
 mov %rsp,%rbp
 sub $80,%rsp
# prolog end

 mov 40(%rbp),%r10d
 cmp $2,%r10d
 jl cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3617$body
# ir_jmp_lt A1 2 cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3617$body;

 mov 40(%rbp),%r10d
 cmp $36,%r10d
 jle cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3617$else
# ir_jmp_lte A1 36 cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3617$else;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3617$body:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3617$body;

 xor %eax,%eax
 jmp cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$end
# ir_return 0;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3617$else:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3617$else;

 mov 48(%rbp),%rax
# ir_deref A2; (push)

 push %rdi
 push %rsi
 lea -16(%rbp),%rdi
 lea 0(%rax),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L0 POP() 16;

 lea .cbstr0,%rax
# ir_load_addr STR0; (push)

 mov %rax,-80(%rbp)
# ir_load [L7 . 0] POP();

 mov $71,%r10d
 mov %r10,-72(%rbp)
# ir_load [L7 . 1] 71;

 mov 32(%rbp),%r10d
 mov %r10d,-20(%rbp)
# ir_load L1 A0;

 xor %r10d,%r10d
 mov %r10d,-24(%rbp)
# ir_load L2 0;

 mov $1,%eax
 neg %eax
# ir_neg 1; (push)

 mov %eax,-28(%rbp)
# ir_load L3 POP();

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3693$cond:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3693$cond;

 mov -28(%rbp),%r10d
 cmp $0,%r10d
 je cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3693$end
# ir_jmp_eq L3 0 cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3693$end;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3693$body:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3693$body;

 mov -24(%rbp),%r10d
 mov %r10,%rax
# ir_cast L2; (push)

 cmp -8(%rbp),%rax
 jl cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3658$else
# ir_jmp_lt POP() [L0 . 1] cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3658$else;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3658$body:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3658$body;

 mov -24(%rbp),%r10d
 sub $1,%r10d
 mov %r10d,%eax
# ir_sub L2 1; (push)

 mov %eax,-24(%rbp)
# ir_load L2 POP();

 jmp cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3693$end
# ir_jmp cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3693$end;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3658$else:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3658$else;

 mov 32(%rbp),%r10d
 mov %r10d,-20(%rbp)
# ir_load L1 A0;

 mov 32(%rbp),%eax
 cdq
 idivl 40(%rbp)
# ir_div A0 A1; (push)

 mov %eax,32(%rbp)
# ir_load A0 POP();

 mov 32(%rbp),%r10d
 mov %r10d,-28(%rbp)
# ir_load L3 A0;

 mov -16(%rbp),%rax
# ir_deref [L0 . 0]; (push)

 mov -24(%rbp),%r10d
 mov %r10,%r10
 lea 0(%rax,%r10,1),%rbx
# ir_index POP() L2; (push)

 mov -80(%rbp),%r12
# ir_deref [L7 . 0]; (push)

 mov 32(%rbp),%r10d
 imul 40(%rbp),%r10d
 mov %r10d,%eax
# ir_mul A0 A1; (push)

 mov -20(%rbp),%r10d
 sub %eax,%r10d
 mov %r10d,%eax
# ir_sub L1 POP(); (push)

 mov $35,%r10d
 add %eax,%r10d
 mov %r10d,%eax
# ir_add 35 POP(); (push)

 mov %eax,%r10d
 mov %r10,%r10
 lea 0(%r12,%r10,1),%rax
# ir_index POP() POP(); (push)

 mov (%rax),%r10b
 mov %r10b,(%rbx)
# ir_load POP() POP();

 mov -24(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L2 1; (push)

 mov %eax,-24(%rbp)
# ir_load L2 POP();

 jmp cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3693$cond
# ir_jmp cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3693$cond;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3693$end:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3693$end;

 mov -16(%rbp),%rax
# ir_deref [L0 . 0]; (push)

 mov -24(%rbp),%r10d
 mov %r10,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L2; (push)

 lea (%rax),%rax
# ir_load_addr POP(); (push)

 mov %rax,-40(%rbp)
# ir_load L4 POP();

 mov -16(%rbp),%rax
# ir_deref [L0 . 0]; (push)

 xor %r10,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() 0; (push)

 lea (%rax),%rax
# ir_load_addr POP(); (push)

 mov %rax,-48(%rbp)
# ir_load L5 POP();

 mov -20(%rbp),%r10d
 cmp $0,%r10d
 jge cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3733$else
# ir_jmp_gte L1 0 cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3733$else;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3733$body:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3733$body;

 mov -40(%rbp),%rax
# ir_deref L4; (push)

 mov $45,%r10b
 mov %r10b,0(%rax)
# ir_load POP() #45;

 mov -40(%rbp),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add L4 1; (push)

 mov %rax,-40(%rbp)
# ir_load L4 POP();

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3733$else:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3733$else;

 mov -40(%rbp),%rax
# ir_deref L4; (push)

 mov $0,%r10b
 mov %r10b,0(%rax)
# ir_load POP() #0;

 mov -40(%rbp),%r10
 sub $1,%r10
 mov %r10,%rax
# ir_sub L4 1; (push)

 mov %rax,-40(%rbp)
# ir_load L4 POP();

 xor %r10b,%r10b
 mov %r10b,-49(%rbp)
# ir_load L6 0;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3779$cond:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3779$cond;

 mov -48(%rbp),%r10
 cmp -40(%rbp),%r10
 jge cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3779$end
# ir_jmp_gte L5 L4 cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3779$end;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3779$body:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3779$body;

 mov -40(%rbp),%rax
# ir_deref L4; (push)

 mov 0(%rax),%r10b
 mov %r10b,-49(%rbp)
# ir_load L6 POP();

 mov -40(%rbp),%rbx
# ir_deref L4; (push)

 mov -48(%rbp),%rax
# ir_deref L5; (push)

 mov 0(%rax),%r10b
 mov %r10b,0(%rbx)
# ir_load POP() POP();

 mov -40(%rbp),%r10
 sub $1,%r10
 mov %r10,%rax
# ir_sub L4 1; (push)

 mov %rax,-40(%rbp)
# ir_load L4 POP();

 mov -48(%rbp),%rax
# ir_deref L5; (push)

 mov -49(%rbp),%r10b
 mov %r10b,0(%rax)
# ir_load POP() L6;

 mov -48(%rbp),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add L5 1; (push)

 mov %rax,-48(%rbp)
# ir_load L5 POP();

 jmp cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3779$cond
# ir_jmp cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3779$cond;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3779$end:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3779$end;

 mov -24(%rbp),%eax
# ir_return L2;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$end:
 add $80,%rsp
 pop %r12
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nsystem__Nwrite_int__Afile_handle__Aint:
# func write_int(file_handle, int): {}
 mov %esi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $112,%rsp
# prolog end

 xor %r10,%r10
 mov %r10,-32(%rbp)
 mov %r10,-24(%rbp)
 mov %r10,-16(%rbp)
 mov %r10,-8(%rbp)
# ir_store L0 0 0 32;

 xor %r10,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 0; (push)

 lea (%rax),%rax
# ir_load_addr POP(); (push)

 mov %rax,-48(%rbp)
# ir_load [L1 . 0] POP();

 mov $32,%r10
 mov %r10,-40(%rbp)
# ir_load [L1 . 1] 32;

 push %rdi
 push %rsi
 lea -64(%rbp),%rdi
 lea -48(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L2 L1 16;

 lea -64(%rbp),%rax
# ir_load_addr L2; (push)

 mov %rax,%rdx
 mov $10,%esi
 mov 24(%rbp),%edi
 call cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8
# ir_call cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8 A1 10 POP(); (push)

 mov %eax,%r10d
 mov %r10,%rax
# ir_cast POP(); (push)

 mov %rax,-40(%rbp)
# ir_load [L1 . 1] POP();

 push %rdi
 push %rsi
 lea -80(%rbp),%rdi
 lea -48(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L3 L1 16;

 lea -80(%rbp),%rax
# ir_load_addr L3; (push)

 mov %rax,%rsi
 mov 16(%rbp),%rdi
 call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__Afile_handle__Aptr__Tslice__Tpure__Tuint8 A0 POP(); (push)

# ir_noop POP();

cb__Nstd__Nsystem__Nwrite_int__Afile_handle__Aint$end:
 add $112,%rsp
 pop %rbp
 ret


