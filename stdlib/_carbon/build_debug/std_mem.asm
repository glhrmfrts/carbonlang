.global cb__Nstd__Nmem__NallocInBlock__Aptr__TBlock__Ausize
.global cb__Nstd__Nmem__Nalign__Ausize__Ausize
.global cb__Nstd__Nmem__Nmemcopy__Aptr__Topaque__Aptr__Tpure__Topaque__Ausize
.global cb__Nstd__Nmem__Nmemset__Aptr__Topaque__Auint8__Ausize
.global cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize
.global cb__Nstd__Nmem__Nfree__Aptr__Topaque
.data
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
    .local std__mem__lastBlock
    .comm std__mem__lastBlock,8,8
.section .rodata
.cbstr0:
    .string "std::mem - Growing block fill to "
.cbstr1:
    .string " bytes\n"
.cbstr2:
    .string "std::mem - Allocating block of "
.cbstr3:
    .string "std::mem - Freeing block of "
.text
cb__Nstd__Nmem__NallocInBlock__Aptr__TBlock__Ausize:
# func allocInBlock(&Block, usize): &opaque
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $64,%rsp
# prolog end

 mov 32(%rbp),%r10
 add $32,%r10
 mov %r10,%rax
# ir_add A0 32; (push)

 mov %rax,-8(%rbp)
# ir_load L0 POP();

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 mov -8(%rbp),%r10
 add 0(%rax),%r10
 mov %r10,%rax
# ir_add L0 [POP() . 0]; (push)

 mov %rax,-16(%rbp)
# ir_load L1 POP();

 mov 32(%rbp),%rbx
# ir_deref A0; (push)

# ir_stack_dup; (push)

 mov 0(%rbx),%r10
 add 40(%rbp),%r10
 mov %r10,%rax
# ir_add [POP() . 0] A1; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov 32(%rbp),%rbx
# ir_deref A0; (push)

# ir_stack_dup; (push)

 mov 16(%rbx),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add [POP() . 2] 1; (push)

 mov %rax,16(%rbx)
# ir_load [POP() . 2] POP();

 lea .cbstr0,%rax
# ir_load_addr STR0; (push)

 mov %rax,-32(%rbp)
# ir_load [L2 . 0] POP();

 mov $33,%r10d
 mov %r10,-24(%rbp)
# ir_load [L2 . 1] 33;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -32(%rbp),%rax
# ir_load_addr L2; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 mov 0(%rax),%r10
 mov %r10d,%eax
# ir_cast [POP() . 0]; (push)

 mov %eax,%esi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint
# ir_call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint POP() POP();

 lea .cbstr1,%rax
# ir_load_addr STR1; (push)

 mov %rax,-48(%rbp)
# ir_load [L3 . 0] POP();

 mov $7,%r10d
 mov %r10,-40(%rbp)
# ir_load [L3 . 1] 7;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -48(%rbp),%rax
# ir_load_addr L3; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

 mov -16(%rbp),%rax
# ir_return L1;

cb__Nstd__Nmem__NallocInBlock__Aptr__TBlock__Ausize$end:
 add $72,%rsp
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

 sub $1,%rsi
 mov %rsi,%rax
# ir_sub A1 1; (push)

 and %rax,%rbx
 mov %rbx,%rax
# ir_and POP() POP(); (push)

 add %rax,%rdi
 mov %rdi,%rax
# ir_add A0 POP(); (push)

# ir_return POP();

cb__Nstd__Nmem__Nalign__Ausize__Ausize$end:
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

cb__Nstd__Nmem__Nmemcopy__Aptr__Topaque__Aptr__Tpure__Topaque__Ausize$end:
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

cb__Nstd__Nmem__Nmemset__Aptr__Topaque__Auint8__Ausize$end:
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

 mov %rax,-24(%rbp)
# ir_load L2 POP();

 mov std__mem__lastBlock,%r10
 mov %r10,-8(%rbp)
# ir_load L0 ;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w3354$cond:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w3354$cond;

 mov -8(%rbp),%r10
 cmp $0,%r10
 je cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w3354$end
# ir_jmp_eq L0 0 cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w3354$end;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w3354$body:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w3354$body;

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov 0(%rax),%r10
 add -24(%rbp),%r10
 mov %r10,%rbx
# ir_add [POP() . 0] L2; (push)

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 cmp 8(%rax),%rbx
 jge cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3345$else
# ir_jmp_gte POP() [POP() . 1] cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3345$else;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3345$body:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3345$body;

 jmp cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w3354$end
# ir_jmp cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w3354$end;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3345$else:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3345$else;

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov 24(%rax),%r10
 mov %r10,-8(%rbp)
# ir_load L0 [POP() . 3];

 jmp cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w3354$cond
# ir_jmp cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w3354$cond;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w3354$end:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w3354$end;

 mov -8(%rbp),%r10
 cmp $0,%r10
 je cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3370$else
# ir_jmp_eq L0 0 cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3370$else;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3370$body:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3370$body;

 mov 32(%rbp),%rbx
# ir_deref A0; (push)

 mov -24(%rbp),%rsi
 mov -8(%rbp),%rdi
 call cb__Nstd__Nmem__NallocInBlock__Aptr__TBlock__Ausize
# ir_call cb__Nstd__Nmem__NallocInBlock__Aptr__TBlock__Ausize L0 L2; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 xor %r10d,%r10d
 mov %r10d,8(%rax)
# ir_load [POP() . 1] 0;

 mov 32(%rbp),%rax
 jmp cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$end
# ir_return A0;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3370$else:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3370$else;

 mov $32,%r10
 add -24(%rbp),%r10
 mov %r10,%rax
# ir_add 32 L2; (push)

 mov $4096,%rsi
 mov %rax,%rdi
 call cb__Nstd__Nmem__Nalign__Ausize__Ausize
# ir_call cb__Nstd__Nmem__Nalign__Ausize__Ausize POP() 4096; (push)

 mov %rax,-32(%rbp)
# ir_load L3 POP();

 lea -48(%rbp),%rax
# ir_load_addr L4; (push)

 mov -32(%rbp),%rsi
 mov %rax,%rdi
 call cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize
# ir_call cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize POP() L3;

 mov -48(%rbp),%r10
 mov %r10,-56(%rbp)
# ir_load L5 [L4 . 0];

 mov -40(%rbp),%r10d
 mov %r10d,-60(%rbp)
# ir_load L6 [L4 . 1];

 mov -60(%rbp),%r10d
 cmp $0,%r10d
 je cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3404$else
# ir_jmp_eq L6 0 cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3404$else;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3404$body:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3404$body;

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 xor %r10,%r10
 mov %r10,0(%rax)
# ir_load [POP() . 0] 0;

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 mov -60(%rbp),%r10d
 mov %r10d,8(%rax)
# ir_load [POP() . 1] L6;

 mov 32(%rbp),%rax
 jmp cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$end
# ir_return A0;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3404$else:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if3404$else;

 mov $32,%rdx
 xor %sil,%sil
 mov -56(%rbp),%rdi
 call cb__Nstd__Nmem__Nmemset__Aptr__Topaque__Auint8__Ausize
# ir_call cb__Nstd__Nmem__Nmemset__Aptr__Topaque__Auint8__Ausize L5 0 32;

 mov -56(%rbp),%r10
 mov %r10,-16(%rbp)
# ir_load L1 L5;

 mov -16(%rbp),%rax
# ir_deref L1; (push)

 mov -32(%rbp),%r10
 mov %r10,8(%rax)
# ir_load [POP() . 1] L3;

 mov -16(%rbp),%rax
# ir_deref L1; (push)

 mov std__mem__lastBlock,%r10
 mov %r10,24(%rax)
# ir_load [POP() . 3] ;

 lea .cbstr2,%rax
# ir_load_addr STR2; (push)

 mov %rax,-80(%rbp)
# ir_load [L7 . 0] POP();

 mov $31,%r10d
 mov %r10,-72(%rbp)
# ir_load [L7 . 1] 31;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -80(%rbp),%rax
# ir_load_addr L7; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 mov -16(%rbp),%rax
# ir_deref L1; (push)

 mov 8(%rax),%r10
 mov %r10d,%eax
# ir_cast [POP() . 1]; (push)

 mov %eax,%esi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint
# ir_call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint POP() POP();

 lea .cbstr1,%rax
# ir_load_addr STR1; (push)

 mov %rax,-96(%rbp)
# ir_load [L8 . 0] POP();

 mov $7,%r10d
 mov %r10,-88(%rbp)
# ir_load [L8 . 1] 7;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -96(%rbp),%rax
# ir_load_addr L8; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

 mov -16(%rbp),%r10
 mov %r10,std__mem__lastBlock
# ir_load  L1;

 mov 32(%rbp),%rbx
# ir_deref A0; (push)

 mov -24(%rbp),%rsi
 mov -16(%rbp),%rdi
 call cb__Nstd__Nmem__NallocInBlock__Aptr__TBlock__Ausize
# ir_call cb__Nstd__Nmem__NallocInBlock__Aptr__TBlock__Ausize L1 L2; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 xor %r10d,%r10d
 mov %r10d,8(%rax)
# ir_load [POP() . 1] 0;

 mov 32(%rbp),%rax
# ir_return A0;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$end:
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
 sub $80,%rsp
# prolog end

 mov std__mem__lastBlock,%r10
 mov %r10,-8(%rbp)
# ir_load L0 ;

 xor %r10,%r10
 mov %r10,-16(%rbp)
# ir_load L1 0;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$w3550$cond:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$w3550$cond;

 mov -8(%rbp),%r10
 cmp $0,%r10
 je cb__Nstd__Nmem__Nfree__Aptr__Topaque$w3550$end
# ir_jmp_eq L0 0 cb__Nstd__Nmem__Nfree__Aptr__Topaque$w3550$end;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$w3550$body:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$w3550$body;

 mov -8(%rbp),%r10
 add $32,%r10
 mov %r10,%rax
# ir_add L0 32; (push)

 mov %rax,-24(%rbp)
# ir_load L2 POP();

 mov 32(%rbp),%r10
 cmp -24(%rbp),%r10
 jl cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3537$else
# ir_jmp_lt A0 L2 cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3537$else;

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov -24(%rbp),%r10
 add 8(%rax),%r10
 mov %r10,%rax
# ir_add L2 [POP() . 1]; (push)

 mov 32(%rbp),%r10
 cmp %rax,%r10
 jge cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3537$else
# ir_jmp_gte A0 POP() cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3537$else;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3537$body:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3537$body;

 jmp cb__Nstd__Nmem__Nfree__Aptr__Topaque$w3550$end
# ir_jmp cb__Nstd__Nmem__Nfree__Aptr__Topaque$w3550$end;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3537$else:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3537$else;

 mov -8(%rbp),%r10
 mov %r10,-16(%rbp)
# ir_load L1 L0;

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov 24(%rax),%r10
 mov %r10,-8(%rbp)
# ir_load L0 [POP() . 3];

 jmp cb__Nstd__Nmem__Nfree__Aptr__Topaque$w3550$cond
# ir_jmp cb__Nstd__Nmem__Nfree__Aptr__Topaque$w3550$cond;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$w3550$end:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$w3550$end;

 mov -8(%rbp),%r10
 cmp $0,%r10
 jne cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3558$else
# ir_jmp_neq L0 0 cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3558$else;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3558$body:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3558$body;

 jmp cb__Nstd__Nmem__Nfree__Aptr__Topaque$end
# ir_return #0;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3558$else:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3558$else;

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
 jne cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3630$else
# ir_jmp_neq [POP() . 2] 0 cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3630$else;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3630$body:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3630$body;

 mov std__mem__lastBlock,%r10
 cmp -8(%rbp),%r10
 jne cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3590$else
# ir_jmp_neq  L0 cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3590$else;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3590$body:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3590$body;

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov 24(%rax),%r10
 mov %r10,std__mem__lastBlock
# ir_load  [POP() . 3];

 jmp cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3590$end
# ir_jmp cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3590$end;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3590$else:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3590$else;

 mov -16(%rbp),%rbx
# ir_deref L1; (push)

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov 24(%rax),%r10
 mov %r10,24(%rbx)
# ir_load [POP() . 3] [POP() . 3];

cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3590$end:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3590$end;

 lea .cbstr3,%rax
# ir_load_addr STR3; (push)

 mov %rax,-64(%rbp)
# ir_load [L4 . 0] POP();

 mov $28,%r10d
 mov %r10,-56(%rbp)
# ir_load [L4 . 1] 28;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -64(%rbp),%rax
# ir_load_addr L4; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov 8(%rax),%r10
 mov %r10d,%eax
# ir_cast [POP() . 1]; (push)

 mov %eax,%esi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint
# ir_call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint POP() POP();

 lea .cbstr1,%rax
# ir_load_addr STR1; (push)

 mov %rax,-48(%rbp)
# ir_load [L3 . 0] POP();

 mov $7,%r10d
 mov %r10,-40(%rbp)
# ir_load [L3 . 1] 7;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -48(%rbp),%rax
# ir_load_addr L3; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov 8(%rax),%rsi
 mov -8(%rbp),%rdi
 call cb__Nstd__Nsystem__Nfree__Aptr__Topaque__Ausize
# ir_call cb__Nstd__Nsystem__Nfree__Aptr__Topaque__Ausize L0 [POP() . 1];

cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3630$else:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$if3630$else;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$end:
 add $88,%rsp
 pop %rbx
 pop %rbp
 ret


