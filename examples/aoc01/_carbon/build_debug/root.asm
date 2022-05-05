.global cb__Nroot__Nalloc_string__Aptr__Tslice__Tuint8__Ausize
.global cb__Nroot__Nalloc_int_slice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize
.global cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8
.global cb__Nroot__Nis_numeric__Auint8
.global cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8
.global cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint
.global cb__Nroot__Nmain
.global cb__Nroot__Nfree__Aptr__Tslice__Tuint8
.global cb__Nroot__Nfree__Aptr__Tslice__Tint
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
    .string "aoc01.txt"
.cbstr1:
    .string "STAT ERROR"
.cbstr2:
    .string "OPEN ERROR"
.cbstr3:
    .string ""
.cbstr4:
    .string "increase count: "
.cbstr5:
    .string "sum increase count: "
.cbstr6:
    .string "hello world"
.cbstr7:
    .string "Equal"
.cbstr8:
    .string "Not Equal"
.text
cb__Nroot__Nalloc_string__Aptr__Tslice__Tuint8__Ausize:
# func alloc_string(&[]uint8, usize): &[]uint8
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $80,%rsp
# prolog end

 lea -16(%rbp),%rbx
# ir_load_addr L0; (push)

 mov 40(%rbp),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add A1 1; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize
# ir_call cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize POP() POP();

 mov -16(%rbp),%r10
 mov %r10,-24(%rbp)
# ir_load L1 [L0 . 0];

 mov -8(%rbp),%r10d
 mov %r10d,-28(%rbp)
# ir_load L2 [L0 . 1];

 mov 40(%rbp),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add A1 1; (push)

 mov %rax,%rdx
 xor %sil,%sil
 mov -24(%rbp),%rdi
 call cb__Nstd__Nmem__Nmemset__Aptr__Topaque__Auint8__Ausize
# ir_call cb__Nstd__Nmem__Nmemset__Aptr__Topaque__Auint8__Ausize L1 0 POP();

 mov 32(%rbp),%r10
 mov %r10,-40(%rbp)
# ir_load L3 A0;

 mov -40(%rbp),%rax
# ir_deref L3; (push)

 mov -24(%rbp),%r10
 mov %r10,0(%rax)
# ir_load [POP() . 0] L1;

 mov -40(%rbp),%rax
# ir_deref L3; (push)

 mov 40(%rbp),%r10
 mov %r10,8(%rax)
# ir_load [POP() . 1] A1;

 mov 32(%rbp),%rax
# ir_return A0;

cb__Nroot__Nalloc_string__Aptr__Tslice__Tuint8__Ausize$end:
 add $88,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nroot__Nalloc_int_slice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize:
# func alloc_int_slice(&{[]int, error}, usize): &{[]int, error}
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $96,%rsp
# prolog end

 lea -32(%rbp),%rbx
# ir_load_addr L1; (push)

 mov 40(%rbp),%r10
 imul $4,%r10
 mov %r10,%rax
# ir_mul A1 4; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize
# ir_call cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize POP() POP();

 mov -32(%rbp),%r10
 mov %r10,-40(%rbp)
# ir_load L2 [L1 . 0];

 mov -24(%rbp),%r10d
 mov %r10d,-44(%rbp)
# ir_load L3 [L1 . 1];

 mov -44(%rbp),%r10d
 cmp $0,%r10d
 je cb__Nroot__Nalloc_int_slice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if100$else
# ir_jmp_eq L3 0 cb__Nroot__Nalloc_int_slice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if100$else;

cb__Nroot__Nalloc_int_slice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if100$body:
# ir_make_label cb__Nroot__Nalloc_int_slice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if100$body;

 mov 32(%rbp),%r10
 mov %r10,-56(%rbp)
# ir_load L4 A0;

 mov -56(%rbp),%rax
# ir_deref L4; (push)

 lea 0(%rax),%r10
 mov %r10,-64(%rbp)
# ir_load_ptr L5 [POP() . 0];

 mov -56(%rbp),%rax
# ir_deref L4; (push)

 mov -44(%rbp),%r10d
 mov %r10d,16(%rax)
# ir_load [POP() . 1] L3;

 mov 32(%rbp),%rax
 jmp cb__Nroot__Nalloc_int_slice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$end
# ir_return A0;

cb__Nroot__Nalloc_int_slice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if100$else:
# ir_make_label cb__Nroot__Nalloc_int_slice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if100$else;

 mov -40(%rbp),%r10
 mov %r10,-16(%rbp)
# ir_load [L0 . 0] L2;

 mov 40(%rbp),%r10
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] A1;

 mov 32(%rbp),%r10
 mov %r10,-72(%rbp)
# ir_load L6 A0;

 mov -72(%rbp),%rax
# ir_deref L6; (push)

 mov -16(%rbp),%r10
 mov %r10,0(%rax)
# ir_load [POP() . 0] L0;

 mov -72(%rbp),%rax
# ir_deref L6; (push)

 xor %r10d,%r10d
 mov %r10d,16(%rax)
# ir_load [POP() . 1] 0;

 mov 32(%rbp),%rax
# ir_return A0;

cb__Nroot__Nalloc_int_slice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$end:
 add $104,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8:
# func count_lines([]pure uint8): usize
 push %rbp
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 xor %r10,%r10
 mov %r10,-8(%rbp)
# ir_load L0 0;

 xor %r10d,%r10d
 mov %r10d,-32(%rbp)
# ir_load [L2 . 0] 0;

 mov %rdi,%rax
# ir_deref A0; (push)

 mov 8(%rax),%r10
 mov %r10,-24(%rbp)
# ir_load [L2 . 1] [POP() . 1];

 mov -32(%rbp),%r10d
 mov %r10d,-12(%rbp)
# ir_load L1 [L2 . 0];

cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8$f179$cond:
# ir_make_label cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8$f179$cond;

 movsxd -12(%rbp),%rax
# ir_cast L1; (push)

 cmp -24(%rbp),%rax
 jge cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8$f179$end
# ir_jmp_gte POP() [L2 . 1] cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8$f179$end;

cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8$f179$body:
# ir_make_label cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8$f179$body;

 mov %rdi,%rax
# ir_deref A0; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 movsxd -12(%rbp),%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L1; (push)

 mov (%rax),%r10b
 cmp $10,%r10b
 jne cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8$if176$else
# ir_jmp_neq POP() #10 cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8$if176$else;

cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8$if176$body:
# ir_make_label cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8$if176$body;

 mov -8(%rbp),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add L0 1; (push)

 mov %rax,-8(%rbp)
# ir_load L0 POP();

cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8$if176$else:
# ir_make_label cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8$if176$else;

 mov -12(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L1 1; (push)

 mov %eax,-12(%rbp)
# ir_load L1 POP();

 jmp cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8$f179$cond
# ir_jmp cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8$f179$cond;

cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8$f179$end:
# ir_make_label cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8$f179$end;

 mov -8(%rbp),%rax
# ir_return L0;

cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8$end:
 add $32,%rsp
 pop %rbp
 ret


cb__Nroot__Nis_numeric__Auint8:
# func is_numeric(uint8): bool
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 cmp $48,%dil
 jl cb__Nroot__Nis_numeric__Auint8$if5050$else
# ir_jmp_lt A0 #48 cb__Nroot__Nis_numeric__Auint8$if5050$else;

 cmp $57,%dil
 jg cb__Nroot__Nis_numeric__Auint8$if5050$else
# ir_jmp_gt A0 #57 cb__Nroot__Nis_numeric__Auint8$if5050$else;

cb__Nroot__Nis_numeric__Auint8$if5050$body:
# ir_make_label cb__Nroot__Nis_numeric__Auint8$if5050$body;

 mov $1,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 1;

 jmp cb__Nroot__Nis_numeric__Auint8$if5050$end
# ir_jmp cb__Nroot__Nis_numeric__Auint8$if5050$end;

cb__Nroot__Nis_numeric__Auint8$if5050$else:
# ir_make_label cb__Nroot__Nis_numeric__Auint8$if5050$else;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

cb__Nroot__Nis_numeric__Auint8$if5050$end:
# ir_make_label cb__Nroot__Nis_numeric__Auint8$if5050$end;

 mov -1(%rbp),%al
# ir_return L0;

cb__Nroot__Nis_numeric__Auint8$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8:
# func trim_left_non_numeric(&[]pure uint8, &[]pure uint8): &[]pure uint8
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $64,%rsp
# prolog end

 xor %r10,%r10
 mov %r10,-8(%rbp)
# ir_load L0 0;

 xor %r10d,%r10d
 mov %r10d,-32(%rbp)
# ir_load [L2 . 0] 0;

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 8(%rax),%r10
 mov %r10,-24(%rbp)
# ir_load [L2 . 1] [POP() . 1];

 mov -32(%rbp),%r10d
 mov %r10d,-12(%rbp)
# ir_load L1 [L2 . 0];

cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f253$cond:
# ir_make_label cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f253$cond;

 movsxd -12(%rbp),%rax
# ir_cast L1; (push)

 cmp -24(%rbp),%rax
 jge cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f253$end
# ir_jmp_gte POP() [L2 . 1] cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f253$end;

cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f253$body:
# ir_make_label cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f253$body;

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 movsxd -12(%rbp),%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L1; (push)

 mov (%rax),%dil
 call cb__Nroot__Nis_numeric__Auint8
# ir_call cb__Nroot__Nis_numeric__Auint8 POP(); (push)

 cmp $0,%al
 jne cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if250$else
# ir_jmp_neq POP() 0 cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if250$else;

cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if250$body:
# ir_make_label cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if250$body;

 mov -8(%rbp),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add L0 1; (push)

 mov %rax,-8(%rbp)
# ir_load L0 POP();

 jmp cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if250$end
# ir_jmp cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if250$end;

cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if250$else:
# ir_make_label cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if250$else;

 jmp cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f253$end
# ir_jmp cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f253$end;

cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if250$end:
# ir_make_label cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if250$end;

 mov -12(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L1 1; (push)

 mov %eax,-12(%rbp)
# ir_load L1 POP();

 jmp cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f253$cond
# ir_jmp cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f253$cond;

cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f253$end:
# ir_make_label cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f253$end;

 mov 32(%rbp),%r10
 mov %r10,-40(%rbp)
# ir_load L3 A0;

 mov -40(%rbp),%rbx
# ir_deref L3; (push)

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%r10
 add -8(%rbp),%r10
 mov %r10,%rax
# ir_add [POP() . 0] L0; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov -40(%rbp),%rbx
# ir_deref L3; (push)

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 8(%rax),%r10
 sub -8(%rbp),%r10
 mov %r10,%rax
# ir_sub [POP() . 1] L0; (push)

 mov %rax,8(%rbx)
# ir_load [POP() . 1] POP();

 mov 32(%rbp),%rax
# ir_return A0;

cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$end:
 add $72,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint:
# func parse_int(&{int, []pure uint8, bool}, &[]pure uint8, int): &{int, []pure uint8, bool}
 mov %edx,24(%rsp)
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $80,%rsp
# prolog end

 xor %r10d,%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 0;

 xor %r10,%r10
 mov %r10,-16(%rbp)
# ir_load L1 0;

 xor %r10d,%r10d
 mov %r10d,-48(%rbp)
# ir_load [L3 . 0] 0;

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 8(%rax),%r10
 mov %r10,-40(%rbp)
# ir_load [L3 . 1] [POP() . 1];

 mov -48(%rbp),%r10d
 mov %r10d,-20(%rbp)
# ir_load L2 [L3 . 0];

cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f351$cond:
# ir_make_label cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f351$cond;

 movsxd -20(%rbp),%rax
# ir_cast L2; (push)

 cmp -40(%rbp),%rax
 jge cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f351$end
# ir_jmp_gte POP() [L3 . 1] cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f351$end;

cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f351$body:
# ir_make_label cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f351$body;

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 movsxd -20(%rbp),%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L2; (push)

 mov (%rax),%dil
 call cb__Nroot__Nis_numeric__Auint8
# ir_call cb__Nroot__Nis_numeric__Auint8 POP(); (push)

 cmp $0,%al
 je cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if348$else
# ir_jmp_eq POP() 0 cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if348$else;

cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if348$body:
# ir_make_label cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if348$body;

 mov -4(%rbp),%r10d
 imul 48(%rbp),%r10d
 mov %r10d,%ebx
# ir_mul L0 A2; (push)

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 movsxd -20(%rbp),%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L2; (push)

 mov (%rax),%r10b
 sub $48,%r10b
 mov %r10b,%al
# ir_sub POP() #48; (push)

 movsx %al,%eax
# ir_cast POP(); (push)

 add %eax,%ebx
 mov %ebx,%eax
# ir_add POP() POP(); (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

 mov -16(%rbp),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add L1 1; (push)

 mov %rax,-16(%rbp)
# ir_load L1 POP();

 jmp cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if348$end
# ir_jmp cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if348$end;

cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if348$else:
# ir_make_label cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if348$else;

 jmp cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f351$end
# ir_jmp cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f351$end;

cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if348$end:
# ir_make_label cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if348$end;

 mov -20(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L2 1; (push)

 mov %eax,-20(%rbp)
# ir_load L2 POP();

 jmp cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f351$cond
# ir_jmp cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f351$cond;

cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f351$end:
# ir_make_label cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f351$end;

 mov 32(%rbp),%r10
 mov %r10,-56(%rbp)
# ir_load L4 A0;

 mov -56(%rbp),%rax
# ir_deref L4; (push)

 mov -4(%rbp),%r10d
 mov %r10d,0(%rax)
# ir_load [POP() . 0] L0;

 mov -56(%rbp),%rax
# ir_deref L4; (push)

 lea 16(%rax),%r10
 mov %r10,-64(%rbp)
# ir_load_ptr L5 [POP() . 1];

 mov -64(%rbp),%rbx
# ir_deref L5; (push)

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%r10
 add -16(%rbp),%r10
 mov %r10,%rax
# ir_add [POP() . 0] L1; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov -64(%rbp),%rbx
# ir_deref L5; (push)

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 8(%rax),%r10
 sub -16(%rbp),%r10
 mov %r10,%rax
# ir_sub [POP() . 1] L1; (push)

 mov %rax,8(%rbx)
# ir_load [POP() . 1] POP();

 mov -56(%rbp),%rbx
# ir_deref L4; (push)

 mov -16(%rbp),%r10
 cmp $0,%r10
 setg %al
# ir_cmp_gt L1 0; (push)

 mov %al,32(%rbx)
# ir_load [POP() . 2] POP();

 mov 32(%rbp),%rax
# ir_return A0;

cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$end:
 add $88,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nroot__Nmain:
# func main(): {}
 push %rbp
 push %rbx
 push %r12
 push %r13
 sub $8,%rsp
 mov %rsp,%rbp
 sub $848,%rsp
# prolog end

 xor %r10,%r10
 mov %r10,-176(%rbp)
 mov %r10,-168(%rbp)
 mov %r10,-160(%rbp)
 mov %r10,-152(%rbp)
 mov %r10,-144(%rbp)
 mov %r10,-136(%rbp)
# ir_store L9 0 0 48;

 lea .cbstr0,%rax
# ir_load_addr STR0; (push)

 mov %rax,-352(%rbp)
# ir_load [L18 . 0] POP();

 mov $9,%r10d
 mov %r10,-344(%rbp)
# ir_load [L18 . 1] 9;

 lea -352(%rbp),%rbx
# ir_load_addr L18; (push)

 lea -176(%rbp),%rax
# ir_load_addr L9; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__TStat
# ir_call cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__TStat POP() POP(); (push)

 mov %eax,-16(%rbp)
# ir_load L0 POP();

 mov -244(%rbp),%r10d
 cmp $0,%r10d
 je cb__Nroot__Nmain$if411$else
# ir_jmp_eq L13 0 cb__Nroot__Nmain$if411$else;

cb__Nroot__Nmain$if411$body:
# ir_make_label cb__Nroot__Nmain$if411$body;

 lea .cbstr1,%rax
# ir_load_addr STR1; (push)

 mov %rax,-560(%rbp)
# ir_load [L31 . 0] POP();

 mov $10,%r10d
 mov %r10,-552(%rbp)
# ir_load [L31 . 1] 10;

 lea -560(%rbp),%rax
# ir_load_addr L31; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 mov $1,%edi
 call cb__Nstd__Nsystem__Nexit__Aint
# ir_call cb__Nstd__Nsystem__Nexit__Aint 1;

cb__Nroot__Nmain$if411$else:
# ir_make_label cb__Nroot__Nmain$if411$else;

 lea .cbstr0,%rax
# ir_load_addr STR0; (push)

 mov %rax,-368(%rbp)
# ir_load [L19 . 0] POP();

 mov $9,%r10d
 mov %r10,-360(%rbp)
# ir_load [L19 . 1] 9;

 lea -320(%rbp),%rbx
# ir_load_addr L16; (push)

 lea -368(%rbp),%rax
# ir_load_addr L19; (push)

 xor %ecx,%ecx
 mov $4,%edx
 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tfile_handle__Terror__Aptr__Tslice__Tpure__Tuint8__Aopen_flags__Aint
# ir_call cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tfile_handle__Terror__Aptr__Tslice__Tpure__Tuint8__Aopen_flags__Aint POP() POP() 4 0;

 mov -320(%rbp),%r10
 mov %r10,-328(%rbp)
# ir_load L17 [L16 . 0];

 mov -312(%rbp),%r10d
 mov %r10d,-244(%rbp)
# ir_load L13 [L16 . 1];

 mov -244(%rbp),%r10d
 cmp $0,%r10d
 je cb__Nroot__Nmain$if438$else
# ir_jmp_eq L13 0 cb__Nroot__Nmain$if438$else;

cb__Nroot__Nmain$if438$body:
# ir_make_label cb__Nroot__Nmain$if438$body;

 lea .cbstr2,%rax
# ir_load_addr STR2; (push)

 mov %rax,-576(%rbp)
# ir_load [L32 . 0] POP();

 mov $10,%r10d
 mov %r10,-568(%rbp)
# ir_load [L32 . 1] 10;

 lea -576(%rbp),%rax
# ir_load_addr L32; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 mov $1,%edi
 call cb__Nstd__Nsystem__Nexit__Aint
# ir_call cb__Nstd__Nsystem__Nexit__Aint 1;

cb__Nroot__Nmain$if438$else:
# ir_make_label cb__Nroot__Nmain$if438$else;

 lea -192(%rbp),%rax
# ir_load_addr L10; (push)

 mov -176(%rbp),%rsi
 mov %rax,%rdi
 call cb__Nroot__Nalloc_string__Aptr__Tslice__Tuint8__Ausize
# ir_call cb__Nroot__Nalloc_string__Aptr__Tslice__Tuint8__Ausize POP() [L9 . 0];

 push %rdi
 push %rsi
 lea -400(%rbp),%rdi
 lea -192(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L21 L10 16;

 lea -400(%rbp),%rax
# ir_load_addr L21; (push)

 mov %rax,%rsi
 mov -328(%rbp),%rdi
 call cb__Nstd__Nsystem__Nread__Afile_handle__Aptr__Tslice__Tuint8
# ir_call cb__Nstd__Nsystem__Nread__Afile_handle__Aptr__Tslice__Tuint8 L17 POP(); (push)

 mov %rax,-184(%rbp)
# ir_load [L10 . 1] POP();

 mov -192(%rbp),%r10
 mov %r10,-16(%rbp)
# ir_load [L0 . 0] [L10 . 0];

 mov -184(%rbp),%r10
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] [L10 . 1];

 lea -224(%rbp),%rbx
# ir_load_addr L11; (push)

 push %rdi
 push %rsi
 lea -416(%rbp),%rdi
 lea -16(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L22 L0 16;

 lea -416(%rbp),%rax
# ir_load_addr L22; (push)

 mov %rax,%rdi
 call cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8 POP(); (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nroot__Nalloc_int_slice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize
# ir_call cb__Nroot__Nalloc_int_slice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize POP() POP();

 push %rdi
 push %rsi
 lea -240(%rbp),%rdi
 lea -224(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L12 [L11 . 0] 16;

 mov -208(%rbp),%r10d
 mov %r10d,-244(%rbp)
# ir_load L13 [L11 . 1];

 mov -244(%rbp),%r10d
 cmp $0,%r10d
 je cb__Nroot__Nmain$if509$else
# ir_jmp_eq L13 0 cb__Nroot__Nmain$if509$else;

cb__Nroot__Nmain$if509$body:
# ir_make_label cb__Nroot__Nmain$if509$body;

 mov $1,%edi
 call cb__Nstd__Nsystem__Nexit__Aint
# ir_call cb__Nstd__Nsystem__Nexit__Aint 1;

cb__Nroot__Nmain$if509$else:
# ir_make_label cb__Nroot__Nmain$if509$else;

 lea -288(%rbp),%rbx
# ir_load_addr L14; (push)

 push %rdi
 push %rsi
 lea -448(%rbp),%rdi
 lea -16(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L24 L0 16;

 lea -448(%rbp),%rax
# ir_load_addr L24; (push)

 mov %rax,%rdi
 call cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nroot__Ncount_lines__Aptr__Tslice__Tpure__Tuint8 POP(); (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nroot__Nalloc_int_slice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize
# ir_call cb__Nroot__Nalloc_int_slice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize POP() POP();

 push %rdi
 push %rsi
 lea -304(%rbp),%rdi
 lea -288(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L15 [L14 . 0] 16;

 mov -272(%rbp),%r10d
 mov %r10d,-244(%rbp)
# ir_load L13 [L14 . 1];

 mov -244(%rbp),%r10d
 cmp $0,%r10d
 je cb__Nroot__Nmain$if538$else
# ir_jmp_eq L13 0 cb__Nroot__Nmain$if538$else;

cb__Nroot__Nmain$if538$body:
# ir_make_label cb__Nroot__Nmain$if538$body;

 mov $1,%edi
 call cb__Nstd__Nsystem__Nexit__Aint
# ir_call cb__Nstd__Nsystem__Nexit__Aint 1;

cb__Nroot__Nmain$if538$else:
# ir_make_label cb__Nroot__Nmain$if538$else;

 xor %r10d,%r10d
 mov %r10d,-20(%rbp)
# ir_load L1 0;

cb__Nroot__Nmain$w597$cond:
# ir_make_label cb__Nroot__Nmain$w597$cond;

 mov -8(%rbp),%r10
 cmp $0,%r10
 jle cb__Nroot__Nmain$w597$end
# ir_jmp_lte [L0 . 1] 0 cb__Nroot__Nmain$w597$end;

cb__Nroot__Nmain$w597$body:
# ir_make_label cb__Nroot__Nmain$w597$body;

 push %rdi
 push %rsi
 lea -608(%rbp),%rdi
 lea -16(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L34 L0 16;

 lea -16(%rbp),%rbx
# ir_load_addr L0; (push)

 lea -608(%rbp),%rax
# ir_load_addr L34; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nroot__Ntrim_left_non_numeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8 POP() POP();

 push %rdi
 push %rsi
 lea -592(%rbp),%rdi
 lea -16(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L33 L0 16;

 lea -704(%rbp),%rbx
# ir_load_addr L38; (push)

 lea -592(%rbp),%rax
# ir_load_addr L33; (push)

 mov $10,%edx
 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint
# ir_call cb__Nroot__Nparse_int__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint POP() POP() 10;

 mov -704(%rbp),%r10d
 mov %r10d,-644(%rbp)
# ir_load L37 [L38 . 0];

 push %rdi
 push %rsi
 lea -640(%rbp),%rdi
 lea -688(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L36 [L38 . 1] 16;

 mov -672(%rbp),%r10b
 mov %r10b,-609(%rbp)
# ir_load L35 [L38 . 2];

 push %rdi
 push %rsi
 lea -16(%rbp),%rdi
 lea -640(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L0 L36 16;

 mov -609(%rbp),%r10b
 cmp $0,%r10b
 je cb__Nroot__Nmain$if594$else
# ir_jmp_eq L35 0 cb__Nroot__Nmain$if594$else;

cb__Nroot__Nmain$if594$body:
# ir_make_label cb__Nroot__Nmain$if594$body;

 mov -240(%rbp),%rax
# ir_deref [L12 . 0]; (push)

 movsxd -20(%rbp),%r10
 lea 0(%rax,%r10,4),%rax
# ir_index POP() L1; (push)

 mov -644(%rbp),%r10d
 mov %r10d,(%rax)
# ir_load POP() L37;

 mov -20(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L1 1; (push)

 mov %eax,-20(%rbp)
# ir_load L1 POP();

 jmp cb__Nroot__Nmain$if594$end
# ir_jmp cb__Nroot__Nmain$if594$end;

cb__Nroot__Nmain$if594$else:
# ir_make_label cb__Nroot__Nmain$if594$else;

 jmp cb__Nroot__Nmain$w597$end
# ir_jmp cb__Nroot__Nmain$w597$end;

cb__Nroot__Nmain$if594$end:
# ir_make_label cb__Nroot__Nmain$if594$end;

 jmp cb__Nroot__Nmain$w597$cond
# ir_jmp cb__Nroot__Nmain$w597$cond;

cb__Nroot__Nmain$w597$end:
# ir_make_label cb__Nroot__Nmain$w597$end;

 xor %r10d,%r10d
 mov %r10d,-24(%rbp)
# ir_load L2 0;

 xor %r10d,%r10d
 mov %r10d,-28(%rbp)
# ir_load L3 0;

 mov $1,%r10d
 mov %r10d,-716(%rbp)
# ir_load [L40 . 0] 1;

 mov -20(%rbp),%r10d
 mov %r10d,-712(%rbp)
# ir_load [L40 . 1] L1;

 mov -716(%rbp),%r10d
 mov %r10d,-708(%rbp)
# ir_load L39 [L40 . 0];

cb__Nroot__Nmain$f631$cond:
# ir_make_label cb__Nroot__Nmain$f631$cond;

 mov -708(%rbp),%r10d
 cmp -712(%rbp),%r10d
 jge cb__Nroot__Nmain$f631$end
# ir_jmp_gte L39 [L40 . 1] cb__Nroot__Nmain$f631$end;

cb__Nroot__Nmain$f631$body:
# ir_make_label cb__Nroot__Nmain$f631$body;

 mov -240(%rbp),%rax
# ir_deref [L12 . 0]; (push)

 movsxd -708(%rbp),%r10
 lea 0(%rax,%r10,4),%rbx
# ir_index POP() L39; (push)

 mov -240(%rbp),%r12
# ir_deref [L12 . 0]; (push)

 mov -708(%rbp),%r10d
 sub $1,%r10d
 mov %r10d,%eax
# ir_sub L39 1; (push)

 movsxd %eax,%r10
 lea 0(%r12,%r10,4),%rax
# ir_index POP() POP(); (push)

 mov (%rbx),%r10d
 cmp (%rax),%r10d
 jle cb__Nroot__Nmain$if628$else
# ir_jmp_lte POP() POP() cb__Nroot__Nmain$if628$else;

cb__Nroot__Nmain$if628$body:
# ir_make_label cb__Nroot__Nmain$if628$body;

 mov -24(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L2 1; (push)

 mov %eax,-24(%rbp)
# ir_load L2 POP();

cb__Nroot__Nmain$if628$else:
# ir_make_label cb__Nroot__Nmain$if628$else;

 mov -708(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L39 1; (push)

 mov %eax,-708(%rbp)
# ir_load L39 POP();

 jmp cb__Nroot__Nmain$f631$cond
# ir_jmp cb__Nroot__Nmain$f631$cond;

cb__Nroot__Nmain$f631$end:
# ir_make_label cb__Nroot__Nmain$f631$end;

 lea .cbstr3,%rax
# ir_load_addr STR3; (push)

 mov %rax,-480(%rbp)
# ir_load [L26 . 0] POP();

 xor %r10d,%r10d
 mov %r10,-472(%rbp)
# ir_load [L26 . 1] 0;

 lea -480(%rbp),%rax
# ir_load_addr L26; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 xor %r10d,%r10d
 mov %r10d,-728(%rbp)
# ir_load [L42 . 0] 0;

 mov -20(%rbp),%r10d
 mov %r10d,-724(%rbp)
# ir_load [L42 . 1] L1;

 mov -728(%rbp),%r10d
 mov %r10d,-720(%rbp)
# ir_load L41 [L42 . 0];

cb__Nroot__Nmain$f673$cond:
# ir_make_label cb__Nroot__Nmain$f673$cond;

 mov -720(%rbp),%r10d
 cmp -724(%rbp),%r10d
 jge cb__Nroot__Nmain$f673$end
# ir_jmp_gte L41 [L42 . 1] cb__Nroot__Nmain$f673$end;

cb__Nroot__Nmain$f673$body:
# ir_make_label cb__Nroot__Nmain$f673$body;

 mov -20(%rbp),%r10d
 sub $2,%r10d
 mov %r10d,%eax
# ir_sub L1 2; (push)

 mov -720(%rbp),%r10d
 cmp %eax,%r10d
 jge cb__Nroot__Nmain$if670$else
# ir_jmp_gte L41 POP() cb__Nroot__Nmain$if670$else;

cb__Nroot__Nmain$if670$body:
# ir_make_label cb__Nroot__Nmain$if670$body;

 mov -304(%rbp),%rax
# ir_deref [L15 . 0]; (push)

 movsxd -720(%rbp),%r10
 lea 0(%rax,%r10,4),%rbx
# ir_index POP() L41; (push)

 mov -240(%rbp),%rax
# ir_deref [L12 . 0]; (push)

 movsxd -720(%rbp),%r10
 lea 0(%rax,%r10,4),%r12
# ir_index POP() L41; (push)

 mov -240(%rbp),%r13
# ir_deref [L12 . 0]; (push)

 mov -720(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L41 1; (push)

 movsxd %eax,%r10
 lea 0(%r13,%r10,4),%rax
# ir_index POP() POP(); (push)

 mov (%r12),%r10d
 add (%rax),%r10d
 mov %r10d,%r12d
# ir_add POP() POP(); (push)

 mov -240(%rbp),%r13
# ir_deref [L12 . 0]; (push)

 mov -720(%rbp),%r10d
 add $2,%r10d
 mov %r10d,%eax
# ir_add L41 2; (push)

 movsxd %eax,%r10
 lea 0(%r13,%r10,4),%rax
# ir_index POP() POP(); (push)

 add (%rax),%r12d
 mov %r12d,%eax
# ir_add POP() POP(); (push)

 mov %eax,(%rbx)
# ir_load POP() POP();

cb__Nroot__Nmain$if670$else:
# ir_make_label cb__Nroot__Nmain$if670$else;

 mov -720(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L41 1; (push)

 mov %eax,-720(%rbp)
# ir_load L41 POP();

 jmp cb__Nroot__Nmain$f673$cond
# ir_jmp cb__Nroot__Nmain$f673$cond;

cb__Nroot__Nmain$f673$end:
# ir_make_label cb__Nroot__Nmain$f673$end;

 mov $1,%r10d
 mov %r10d,-740(%rbp)
# ir_load [L44 . 0] 1;

 mov -20(%rbp),%r10d
 mov %r10d,-736(%rbp)
# ir_load [L44 . 1] L1;

 mov -740(%rbp),%r10d
 mov %r10d,-732(%rbp)
# ir_load L43 [L44 . 0];

cb__Nroot__Nmain$f698$cond:
# ir_make_label cb__Nroot__Nmain$f698$cond;

 mov -732(%rbp),%r10d
 cmp -736(%rbp),%r10d
 jge cb__Nroot__Nmain$f698$end
# ir_jmp_gte L43 [L44 . 1] cb__Nroot__Nmain$f698$end;

cb__Nroot__Nmain$f698$body:
# ir_make_label cb__Nroot__Nmain$f698$body;

 mov -304(%rbp),%rax
# ir_deref [L15 . 0]; (push)

 movsxd -732(%rbp),%r10
 lea 0(%rax,%r10,4),%rbx
# ir_index POP() L43; (push)

 mov -304(%rbp),%r12
# ir_deref [L15 . 0]; (push)

 mov -732(%rbp),%r10d
 sub $1,%r10d
 mov %r10d,%eax
# ir_sub L43 1; (push)

 movsxd %eax,%r10
 lea 0(%r12,%r10,4),%rax
# ir_index POP() POP(); (push)

 mov (%rbx),%r10d
 cmp (%rax),%r10d
 jle cb__Nroot__Nmain$if695$else
# ir_jmp_lte POP() POP() cb__Nroot__Nmain$if695$else;

cb__Nroot__Nmain$if695$body:
# ir_make_label cb__Nroot__Nmain$if695$body;

 mov -28(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L3 1; (push)

 mov %eax,-28(%rbp)
# ir_load L3 POP();

cb__Nroot__Nmain$if695$else:
# ir_make_label cb__Nroot__Nmain$if695$else;

 mov -732(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L43 1; (push)

 mov %eax,-732(%rbp)
# ir_load L43 POP();

 jmp cb__Nroot__Nmain$f698$cond
# ir_jmp cb__Nroot__Nmain$f698$cond;

cb__Nroot__Nmain$f698$end:
# ir_make_label cb__Nroot__Nmain$f698$end;

 lea .cbstr4,%rax
# ir_load_addr STR4; (push)

 mov %rax,-496(%rbp)
# ir_load [L27 . 0] POP();

 mov $16,%r10d
 mov %r10,-488(%rbp)
# ir_load [L27 . 1] 16;

 lea -496(%rbp),%rax
# ir_load_addr L27; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8 POP();

 mov -24(%rbp),%edi
 call cb__Nstd__Nio__Nprint__Aint
# ir_call cb__Nstd__Nio__Nprint__Aint L2;

 lea .cbstr3,%rax
# ir_load_addr STR3; (push)

 mov %rax,-512(%rbp)
# ir_load [L28 . 0] POP();

 xor %r10d,%r10d
 mov %r10,-504(%rbp)
# ir_load [L28 . 1] 0;

 lea -512(%rbp),%rax
# ir_load_addr L28; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 lea .cbstr5,%rax
# ir_load_addr STR5; (push)

 mov %rax,-528(%rbp)
# ir_load [L29 . 0] POP();

 mov $20,%r10d
 mov %r10,-520(%rbp)
# ir_load [L29 . 1] 20;

 lea -528(%rbp),%rax
# ir_load_addr L29; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8 POP();

 mov -28(%rbp),%edi
 call cb__Nstd__Nio__Nprint__Aint
# ir_call cb__Nstd__Nio__Nprint__Aint L3;

 lea .cbstr3,%rax
# ir_load_addr STR3; (push)

 mov %rax,-544(%rbp)
# ir_load [L30 . 0] POP();

 xor %r10d,%r10d
 mov %r10,-536(%rbp)
# ir_load [L30 . 1] 0;

 lea -544(%rbp),%rax
# ir_load_addr L30; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 lea .cbstr6,%rax
# ir_load_addr STR6; (push)

 mov %rax,-128(%rbp)
# ir_load [L8 . 0] POP();

 mov $11,%r10d
 mov %r10,-120(%rbp)
# ir_load [L8 . 1] 11;

 xor %r10,%r10
 mov %r10,-64(%rbp)
 mov %r10,-56(%rbp)
 mov %r10,-48(%rbp)
 mov %r10,-40(%rbp)
# ir_store L4 0 0 32;

 xor %r10d,%r10d
 mov %r10,-816(%rbp)
# ir_load [L47 . 0] 0;

 xor %r10d,%r10d
 mov %r10,-808(%rbp)
# ir_load [L47 . 1] 0;

 xor %r10d,%r10d
 mov %r10,-800(%rbp)
# ir_load [L47 . 2] 0;

 xor %r10d,%r10d
 mov %r10,-792(%rbp)
# ir_load [L47 . 3] 0;

 movdqa .cmp16selector,%xmm0
 movdqa -64(%rbp),%xmm7
 psadbw -816(%rbp),%xmm7
 pshufb %xmm0,%xmm7
 movq %xmm7,%r10
 cmp $0,%r10d
 jne cb__Nroot__Nmain$if781$else
 movdqa -48(%rbp),%xmm7
 psadbw -800(%rbp),%xmm7
 pshufb %xmm0,%xmm7
 movq %xmm7,%r10
 cmp $0,%r10d
 jne cb__Nroot__Nmain$if781$else
# ir_jmp_neq L4 L47 cb__Nroot__Nmain$if781$else;

cb__Nroot__Nmain$if781$body:
# ir_make_label cb__Nroot__Nmain$if781$body;

 lea .cbstr7,%rax
# ir_load_addr STR7; (push)

 mov %rax,-768(%rbp)
# ir_load [L45 . 0] POP();

 mov $5,%r10d
 mov %r10,-760(%rbp)
# ir_load [L45 . 1] 5;

 lea -768(%rbp),%rax
# ir_load_addr L45; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 jmp cb__Nroot__Nmain$if781$end
# ir_jmp cb__Nroot__Nmain$if781$end;

cb__Nroot__Nmain$if781$else:
# ir_make_label cb__Nroot__Nmain$if781$else;

 lea .cbstr8,%rax
# ir_load_addr STR8; (push)

 mov %rax,-784(%rbp)
# ir_load [L46 . 0] POP();

 mov $9,%r10d
 mov %r10,-776(%rbp)
# ir_load [L46 . 1] 9;

 lea -784(%rbp),%rax
# ir_load_addr L46; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

cb__Nroot__Nmain$if781$end:
# ir_make_label cb__Nroot__Nmain$if781$end;

 xor %r10,%r10
 mov %r10,-96(%rbp)
 mov %r10,-88(%rbp)
 mov %r10,-80(%rbp)
 mov %r10,-72(%rbp)
# ir_store L5 0 0 32;

 lea -80(%rbp),%rax
# ir_load_addr [L5 . 2]; (push)

 mov %rax,-104(%rbp)
# ir_load L6 POP();

 lea -79(%rbp),%rax
# ir_load_addr [L5 . 3]; (push)

 mov %rax,-112(%rbp)
# ir_load L7 POP();

 mov $32,%rdi
 call cb__Nstd__Nio__Nprintln__Aint
# ir_call cb__Nstd__Nio__Nprintln__Aint 32;

 mov -112(%rbp),%r10
 sub -104(%rbp),%r10
 mov %r10,%rax
# ir_sub L7 L6; (push)

 mov %rax,%rdi
 call cb__Nstd__Nio__Nprintln__Ausize
# ir_call cb__Nstd__Nio__Nprintln__Ausize POP();

 push %rdi
 push %rsi
 lea -464(%rbp),%rdi
 lea -304(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L25 L15 16;

 lea -464(%rbp),%rax
# ir_load_addr L25; (push)

 mov %rax,%rdi
 call cb__Nroot__Nfree__Aptr__Tslice__Tint
# ir_call cb__Nroot__Nfree__Aptr__Tslice__Tint POP();

 push %rdi
 push %rsi
 lea -432(%rbp),%rdi
 lea -240(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L23 L12 16;

 lea -432(%rbp),%rax
# ir_load_addr L23; (push)

 mov %rax,%rdi
 call cb__Nroot__Nfree__Aptr__Tslice__Tint
# ir_call cb__Nroot__Nfree__Aptr__Tslice__Tint POP();

 push %rdi
 push %rsi
 lea -384(%rbp),%rdi
 lea -192(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L20 L10 16;

 lea -384(%rbp),%rax
# ir_load_addr L20; (push)

 mov %rax,%rdi
 call cb__Nroot__Nfree__Aptr__Tslice__Tuint8
# ir_call cb__Nroot__Nfree__Aptr__Tslice__Tuint8 POP();

 mov -328(%rbp),%rdi
 call cb__Nstd__Nsystem__Nclose__Afile_handle
# ir_call cb__Nstd__Nsystem__Nclose__Afile_handle L17; (push)

# ir_noop POP();

cb__Nroot__Nmain$end:
 add $856,%rsp
 pop %r13
 pop %r12
 pop %rbx
 pop %rbp
 ret


cb__Nroot__Nfree__Aptr__Tslice__Tuint8:
# func free([]uint8): {}
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov 16(%rbp),%rax
# ir_deref A0; (push)

 mov 0(%rax),%rdi
 call cb__Nstd__Nmem__Nfree__Aptr__Topaque
# ir_call cb__Nstd__Nmem__Nfree__Aptr__Topaque [POP() . 0];

cb__Nroot__Nfree__Aptr__Tslice__Tuint8$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nroot__Nfree__Aptr__Tslice__Tint:
# func free([]int): {}
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov 16(%rbp),%rax
# ir_deref A0; (push)

 mov 0(%rax),%rdi
 call cb__Nstd__Nmem__Nfree__Aptr__Topaque
# ir_call cb__Nstd__Nmem__Nfree__Aptr__Topaque [POP() . 0];

cb__Nroot__Nfree__Aptr__Tslice__Tint$end:
 add $16,%rsp
 pop %rbp
 ret


