.global cb__Nstd__Nmem__Nalloc_in_block__Aptr__Tmemory_block__Ausize
.global cb__Nstd__Nmem__Nalign__Ausize__Ausize
.global cb__Nstd__Nmem__Nmemcopy__Aptr__Topaque__Aptr__Tpure__Topaque__Ausize
.global cb__Nstd__Nmem__Nmemset__Aptr__Topaque__Auint8__Ausize
.global cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize
.global cb__Nstd__Nmem__Nfree__Aptr__Topaque
.global cb__Nstd__Nmem__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize
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
    .local std__mem__last_block
    .comm std__mem__last_block,8,8
.section .rodata
.text
cb__Nstd__Nmem__Nalloc_in_block__Aptr__Tmemory_block__Ausize:
# func alloc_in_block(&memory_block, usize): &opaque
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov %rdi,%r10
 add $32,%r10
 mov %r10,%rax
# ir_add A0 32; (push)

 mov %rax,-8(%rbp)
# ir_load L0 POP();

 mov %rdi,%rax
# ir_deref A0; (push)

 mov -8(%rbp),%r10
 add 0(%rax),%r10
 mov %r10,%rax
# ir_add L0 [POP() . 0]; (push)

 mov %rax,-16(%rbp)
# ir_load L1 POP();

 mov %rdi,%rbx
# ir_deref A0; (push)

# ir_stack_dup; (push)

 mov 0(%rbx),%r10
 add %rsi,%r10
 mov %r10,%rax
# ir_add [POP() . 0] A1; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov %rdi,%rbx
# ir_deref A0; (push)

# ir_stack_dup; (push)

 mov 16(%rbx),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add [POP() . 2] 1; (push)

 mov %rax,16(%rbx)
# ir_load [POP() . 2] POP();

 mov -16(%rbp),%rax
# ir_return L1;

.cb__Nstd__Nmem__Nalloc_in_block__Aptr__Tmemory_block__Ausize$end:
 add $24,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nmem__Nalign__Ausize__Ausize:
# func align(usize, usize): usize
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
# prolog end

 mov %rdi,%rax
 neg %rax
 mov %rax,%rbx
# ir_neg A0; (push)

 mov %rsi,%r10
 sub $1,%r10
 mov %r10,%rax
# ir_sub A1 1; (push)

 and %rax,%rbx
 mov %rbx,%rax
# ir_and POP() POP(); (push)

 mov %rdi,%r10
 add %rax,%r10
 mov %r10,%rax
# ir_add A0 POP(); (push)

# ir_return POP();

.cb__Nstd__Nmem__Nalign__Ausize__Ausize$end:
 add $8,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nmem__Nmemcopy__Aptr__Topaque__Aptr__Tpure__Topaque__Ausize:
# func memcopy(&opaque, &pure opaque, usize): {}
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov %rdx,%rcx
    rep movsb

.cb__Nstd__Nmem__Nmemcopy__Aptr__Topaque__Aptr__Tpure__Topaque__Ausize$end:
 pop %rbp
 ret


cb__Nstd__Nmem__Nmemset__Aptr__Topaque__Auint8__Ausize:
# func memset(&opaque, uint8, usize): {}
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov %rsi,%rax
    mov %rdx,%rcx
    rep stosb

.cb__Nstd__Nmem__Nmemset__Aptr__Topaque__Auint8__Ausize$end:
 pop %rbp
 ret


cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize:
# func alloc(&{&opaque, error}, usize): &{&opaque, error}
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $128,%rsp
# prolog end

 mov $16,%rsi
 mov 40(%rbp),%rdi
 call cb__Nstd__Nmem__Nalign__Ausize__Ausize
# ir_call cb__Nstd__Nmem__Nalign__Ausize__Ausize A1 16; (push)

 mov %rax,-8(%rbp)
# ir_load L0 POP();

 mov std__mem__last_block(%rip),%r10
 mov %r10,-16(%rbp)
# ir_load L1 ;

.w2661$cond:
# ir_make_label .w2661$cond;

 mov -16(%rbp),%r10
 cmp $0,%r10
 je .w2661$end
# ir_jmp_eq L1 0 .w2661$end;

.w2661$body:
# ir_make_label .w2661$body;

 mov -16(%rbp),%rax
# ir_deref L1; (push)

 mov 0(%rax),%r10
 add -8(%rbp),%r10
 mov %r10,%rbx
# ir_add [POP() . 0] L0; (push)

 mov -16(%rbp),%rax
# ir_deref L1; (push)

 cmp 8(%rax),%rbx
 jge .if2652$else
# ir_jmp_gte POP() [POP() . 1] .if2652$else;

.if2652$body:
# ir_make_label .if2652$body;

 jmp .w2661$end
# ir_jmp .w2661$end;

.if2652$else:
# ir_make_label .if2652$else;

 mov -16(%rbp),%rax
# ir_deref L1; (push)

 mov 24(%rax),%r10
 mov %r10,-16(%rbp)
# ir_load L1 [POP() . 3];

 jmp .w2661$cond
# ir_jmp .w2661$cond;

.w2661$end:
# ir_make_label .w2661$end;

 mov -16(%rbp),%r10
 cmp $0,%r10
 je .if2677$else
# ir_jmp_eq L1 0 .if2677$else;

.if2677$body:
# ir_make_label .if2677$body;

 mov 32(%rbp),%r10
 mov %r10,-72(%rbp)
# ir_load L7 A0;

 mov -72(%rbp),%rbx
# ir_deref L7; (push)

 mov -8(%rbp),%rsi
 mov -16(%rbp),%rdi
 call cb__Nstd__Nmem__Nalloc_in_block__Aptr__Tmemory_block__Ausize
# ir_call cb__Nstd__Nmem__Nalloc_in_block__Aptr__Tmemory_block__Ausize L1 L0; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov -72(%rbp),%rax
# ir_deref L7; (push)

 xor %r10d,%r10d
 mov %r10d,8(%rax)
# ir_load [POP() . 1] 0;

 mov 32(%rbp),%rax
 jmp .cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$end
# ir_return A0;

.if2677$else:
# ir_make_label .if2677$else;

 mov $32,%r10
 add -8(%rbp),%r10
 mov %r10,%rax
# ir_add 32 L0; (push)

 mov $4096,%rsi
 mov %rax,%rdi
 call cb__Nstd__Nmem__Nalign__Ausize__Ausize
# ir_call cb__Nstd__Nmem__Nalign__Ausize__Ausize POP() 4096; (push)

 mov %rax,-24(%rbp)
# ir_load L2 POP();

 lea -48(%rbp),%rax
# ir_load_addr L4; (push)

 mov -24(%rbp),%rsi
 mov %rax,%rdi
 call cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize
# ir_call cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize POP() L2;

 mov -48(%rbp),%r10
 mov %r10,-56(%rbp)
# ir_load L5 [L4 . 0];

 mov -40(%rbp),%r10d
 mov %r10d,-60(%rbp)
# ir_load L6 [L4 . 1];

 mov -60(%rbp),%r10d
 cmp $0,%r10d
 je .if2711$else
# ir_jmp_eq L6 0 .if2711$else;

.if2711$body:
# ir_make_label .if2711$body;

 mov 32(%rbp),%r10
 mov %r10,-80(%rbp)
# ir_load L8 A0;

 mov -80(%rbp),%rax
# ir_deref L8; (push)

 xor %r10,%r10
 mov %r10,0(%rax)
# ir_load [POP() . 0] 0;

 mov -80(%rbp),%rax
# ir_deref L8; (push)

 mov -60(%rbp),%r10d
 mov %r10d,8(%rax)
# ir_load [POP() . 1] L6;

 mov 32(%rbp),%rax
 jmp .cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$end
# ir_return A0;

.if2711$else:
# ir_make_label .if2711$else;

 mov $32,%rdx
 xor %sil,%sil
 mov -56(%rbp),%rdi
 call cb__Nstd__Nmem__Nmemset__Aptr__Topaque__Auint8__Ausize
# ir_call cb__Nstd__Nmem__Nmemset__Aptr__Topaque__Auint8__Ausize L5 0 32;

 mov -56(%rbp),%r10
 mov %r10,-32(%rbp)
# ir_load L3 L5;

 mov -32(%rbp),%rax
# ir_deref L3; (push)

 mov -24(%rbp),%r10
 mov %r10,8(%rax)
# ir_load [POP() . 1] L2;

 mov -32(%rbp),%rax
# ir_deref L3; (push)

 mov std__mem__last_block(%rip),%r10
 mov %r10,24(%rax)
# ir_load [POP() . 3] ;

 mov -32(%rbp),%r10
 mov %r10,std__mem__last_block(%rip)
# ir_load  L3;

 mov 32(%rbp),%r10
 mov %r10,-88(%rbp)
# ir_load L9 A0;

 mov -88(%rbp),%rbx
# ir_deref L9; (push)

 mov -8(%rbp),%rsi
 mov -32(%rbp),%rdi
 call cb__Nstd__Nmem__Nalloc_in_block__Aptr__Tmemory_block__Ausize
# ir_call cb__Nstd__Nmem__Nalloc_in_block__Aptr__Tmemory_block__Ausize L3 L0; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov -88(%rbp),%rax
# ir_deref L9; (push)

 xor %r10d,%r10d
 mov %r10d,8(%rax)
# ir_load [POP() . 1] 0;

 mov 32(%rbp),%rax
# ir_return A0;

.cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$end:
 add $136,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nmem__Nfree__Aptr__Topaque:
# func free(&opaque): {}
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $48,%rsp
# prolog end

 mov std__mem__last_block(%rip),%r10
 mov %r10,-8(%rbp)
# ir_load L0 ;

 xor %r10,%r10
 mov %r10,-16(%rbp)
# ir_store L1 0 0 8;

.w2828$cond:
# ir_make_label .w2828$cond;

 mov -8(%rbp),%r10
 cmp $0,%r10
 je .w2828$end
# ir_jmp_eq L0 0 .w2828$end;

.w2828$body:
# ir_make_label .w2828$body;

 mov -8(%rbp),%r10
 add $32,%r10
 mov %r10,%rax
# ir_add L0 32; (push)

 mov %rax,-24(%rbp)
# ir_load L2 POP();

 mov 32(%rbp),%r10
 cmp -24(%rbp),%r10
 jl .if2815$else
# ir_jmp_lt A0 L2 .if2815$else;

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov -24(%rbp),%r10
 add 8(%rax),%r10
 mov %r10,%rax
# ir_add L2 [POP() . 1]; (push)

 mov 32(%rbp),%r10
 cmp %rax,%r10
 jge .if2815$else
# ir_jmp_gte A0 POP() .if2815$else;

.if2815$body:
# ir_make_label .if2815$body;

 jmp .w2828$end
# ir_jmp .w2828$end;

.if2815$else:
# ir_make_label .if2815$else;

 mov -8(%rbp),%r10
 mov %r10,-16(%rbp)
# ir_load L1 L0;

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov 24(%rax),%r10
 mov %r10,-8(%rbp)
# ir_load L0 [POP() . 3];

 jmp .w2828$cond
# ir_jmp .w2828$cond;

.w2828$end:
# ir_make_label .w2828$end;

 mov -8(%rbp),%r10
 cmp $0,%r10
 jne .if2836$else
# ir_jmp_neq L0 0 .if2836$else;

.if2836$body:
# ir_make_label .if2836$body;

 jmp .cb__Nstd__Nmem__Nfree__Aptr__Topaque$end
# ir_return #0;

.if2836$else:
# ir_make_label .if2836$else;

 mov -8(%rbp),%rbx
# ir_deref L0; (push)

# ir_stack_dup; (push)

 mov 16(%rbx),%r10
 sub $1,%r10
 mov %r10,%rax
# ir_sub [POP() . 2] 1; (push)

 mov %rax,16(%rbx)
# ir_load [POP() . 2] POP();

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov 16(%rax),%r10
 cmp $0,%r10
 jne .if2879$else
# ir_jmp_neq [POP() . 2] 0 .if2879$else;

.if2879$body:
# ir_make_label .if2879$body;

 mov std__mem__last_block(%rip),%r10
 cmp -8(%rbp),%r10
 jne .if2868$else
# ir_jmp_neq  L0 .if2868$else;

.if2868$body:
# ir_make_label .if2868$body;

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov 24(%rax),%r10
 mov %r10,std__mem__last_block(%rip)
# ir_load  [POP() . 3];

 jmp .if2868$end
# ir_jmp .if2868$end;

.if2868$else:
# ir_make_label .if2868$else;

 mov -16(%rbp),%rbx
# ir_deref L1; (push)

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov 24(%rax),%r10
 mov %r10,24(%rbx)
# ir_load [POP() . 3] [POP() . 3];

.if2868$end:
# ir_make_label .if2868$end;

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov 8(%rax),%rsi
 mov -8(%rbp),%rdi
 call cb__Nstd__Nsystem__Nfree__Aptr__Topaque__Ausize
# ir_call cb__Nstd__Nsystem__Nfree__Aptr__Topaque__Ausize L0 [POP() . 1];

.if2879$else:
# ir_make_label .if2879$else;

.cb__Nstd__Nmem__Nfree__Aptr__Topaque$end:
 add $56,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nmem__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize:
# func alloc_slice(&{[]&pure uint8, error}, usize): &{[]&pure uint8, error}
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $80,%rsp
# prolog end

 lea -32(%rbp),%rbx
# ir_load_addr L1; (push)

 mov 40(%rbp),%r10
 imul $8,%r10
 mov %r10,%rax
# ir_mul A1 8; (push)

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
 je .if4144$else
# ir_jmp_eq L3 0 .if4144$else;

.if4144$body:
# ir_make_label .if4144$body;

 mov 32(%rbp),%r10
 mov %r10,-56(%rbp)
# ir_load L4 A0;

 mov -56(%rbp),%rax
# ir_deref L4; (push)

 xor %r10,%r10
 mov %r10,0(%rax)
 mov %r10,8(%rax)
# ir_store [POP() . 0] 0 0 16;

 mov -56(%rbp),%rax
# ir_deref L4; (push)

 mov -44(%rbp),%r10d
 mov %r10d,16(%rax)
# ir_load [POP() . 1] L3;

 mov 32(%rbp),%rax
 jmp .cb__Nstd__Nmem__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize$end
# ir_return A0;

.if4144$else:
# ir_make_label .if4144$else;

 mov -40(%rbp),%r10
 mov %r10,-16(%rbp)
# ir_load [L0 . 0] L2;

 mov 40(%rbp),%r10
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] A1;

 mov 32(%rbp),%r10
 mov %r10,-64(%rbp)
# ir_load L5 A0;

 mov -64(%rbp),%rax
# ir_deref L5; (push)

 mov -16(%rbp),%r10
 mov %r10,0(%rax)
# ir_load [POP() . 0] L0;

 mov -64(%rbp),%rax
# ir_deref L5; (push)

 xor %r10d,%r10d
 mov %r10d,16(%rax)
# ir_load [POP() . 1] 0;

 mov 32(%rbp),%rax
# ir_return A0;

.cb__Nstd__Nmem__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize$end:
 add $88,%rsp
 pop %rbx
 pop %rbp
 ret


