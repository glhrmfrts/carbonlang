.global cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring
.global cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8
.global cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring
.data
.section .rodata
.text
cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring:
# func equals(string, string): bool
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 mov %rdi,%rbx
# ir_deref A0; (push)

 mov %rsi,%rax
# ir_deref A1; (push)

 mov 8(%rbx),%r10
 cmp 8(%rax),%r10
 je cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$if3687$else
# ir_jmp_eq [POP() . 1] [POP() . 1] cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$if3687$else;

cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$if3687$body:
# ir_make_label cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$if3687$body;

 xor %al,%al
 jmp cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$end
# ir_return 0;

cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$if3687$else:
# ir_make_label cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$if3687$else;

 xor %r10d,%r10d
 mov %r10d,-32(%rbp)
# ir_load [L1 . 0] 0;

 mov %rdi,%rax
# ir_deref A0; (push)

 mov 8(%rax),%r10
 mov %r10,-28(%rbp)
# ir_load [L1 . 1] [POP() . 1];

 mov -32(%rbp),%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 [L1 . 0];

cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$f3711$cond:
# ir_make_label cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$f3711$cond;

 movsxd -4(%rbp),%rax
# ir_cast L0; (push)

 cmp -28(%rbp),%rax
 jge cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$f3711$end
# ir_jmp_gte POP() [L1 . 1] cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$f3711$end;

cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$f3711$body:
# ir_make_label cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$f3711$body;

 mov %rdi,%rax
# ir_deref A0; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 movsxd -4(%rbp),%r10
 lea 0(%rax,%r10,1),%rbx
# ir_index POP() L0; (push)

 mov %rsi,%rax
# ir_deref A1; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 movsxd -4(%rbp),%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L0; (push)

 mov (%rbx),%r10b
 cmp (%rax),%r10b
 je cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$if3708$else
# ir_jmp_eq POP() POP() cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$if3708$else;

cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$if3708$body:
# ir_make_label cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$if3708$body;

 xor %al,%al
 jmp cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$end
# ir_return 0;

cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$if3708$else:
# ir_make_label cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$if3708$else;

 mov -4(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L0 1; (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

 jmp cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$f3711$cond
# ir_jmp cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$f3711$cond;

cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$f3711$end:
# ir_make_label cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$f3711$end;

 mov $1,%al
# ir_return 1;

cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$end:
 add $40,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8:
# func find(&{usize, bool}, &string, uint8): &{usize, bool}
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 xor %r10d,%r10d
 mov %r10d,-32(%rbp)
# ir_load [L1 . 0] 0;

 mov %rsi,%rax
# ir_deref A1; (push)

 mov 8(%rax),%r10
 mov %r10,-28(%rbp)
# ir_load [L1 . 1] [POP() . 1];

 mov -32(%rbp),%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 [L1 . 0];

cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$f3765$cond:
# ir_make_label cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$f3765$cond;

 movsxd -4(%rbp),%rax
# ir_cast L0; (push)

 cmp -28(%rbp),%rax
 jge cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$f3765$end
# ir_jmp_gte POP() [L1 . 1] cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$f3765$end;

cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$f3765$body:
# ir_make_label cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$f3765$body;

 mov %rsi,%rax
# ir_deref A1; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 movsxd -4(%rbp),%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L0; (push)

 mov (%rax),%r10b
 cmp %dl,%r10b
 jne cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$if3762$else
# ir_jmp_neq POP() A2 cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$if3762$else;

cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$if3762$body:
# ir_make_label cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$if3762$body;

 mov %rdi,%rbx
# ir_deref A0; (push)

 movsxd -4(%rbp),%rax
# ir_cast L0; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov %rdi,%rax
# ir_deref A0; (push)

 mov $1,%r10b
 mov %r10b,8(%rax)
# ir_load [POP() . 1] 1;

 mov %rdi,%rax
 jmp cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$end
# ir_return A0;

cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$if3762$else:
# ir_make_label cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$if3762$else;

 mov -4(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L0 1; (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

 jmp cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$f3765$cond
# ir_jmp cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$f3765$cond;

cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$f3765$end:
# ir_make_label cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$f3765$end;

 mov %rdi,%rax
# ir_deref A0; (push)

 xor %r10d,%r10d
 mov %r10,0(%rax)
# ir_load [POP() . 0] 0;

 mov %rdi,%rax
# ir_deref A0; (push)

 xor %r10b,%r10b
 mov %r10b,8(%rax)
# ir_load [POP() . 1] 0;

 mov %rdi,%rax
# ir_return A0;

cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$end:
 add $40,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring:
# func find(&{usize, bool}, &string, &string): &{usize, bool}
 mov %rdx,24(%rsp)
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $80,%rsp
# prolog end

 xor %r10d,%r10d
 mov %r10d,-32(%rbp)
# ir_load [L1 . 0] 0;

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 8(%rax),%r10
 mov %r10,-28(%rbp)
# ir_load [L1 . 1] [POP() . 1];

 mov -32(%rbp),%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 [L1 . 0];

cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$f3840$cond:
# ir_make_label cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$f3840$cond;

 movsxd -4(%rbp),%rax
# ir_cast L0; (push)

 cmp -28(%rbp),%rax
 jge cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$f3840$end
# ir_jmp_gte POP() [L1 . 1] cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$f3840$end;

cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$f3840$body:
# ir_make_label cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$f3840$body;

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 movsxd -4(%rbp),%r10
 lea 0(%rax,%r10,1),%rbx
# ir_index POP() L0; (push)

 mov 48(%rbp),%rax
# ir_deref A2; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 xor %r10,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() 0; (push)

 mov (%rbx),%r10b
 cmp (%rax),%r10b
 jne cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$if3837$else
# ir_jmp_neq POP() POP() cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$if3837$else;

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 movsxd -4(%rbp),%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L0; (push)

 lea (%rax),%rax
# ir_load_addr POP(); (push)

 mov %rax,-64(%rbp)
# ir_load [L3 . 0] POP();

 movsxd -4(%rbp),%rbx
# ir_cast L0; (push)

 mov 48(%rbp),%rax
# ir_deref A2; (push)

 add 8(%rax),%rbx
# ir_add POP() [POP() . 1]; (push)

 movsxd -4(%rbp),%rax
# ir_cast L0; (push)

 sub %rax,%rbx
 mov %rbx,%rax
# ir_sub POP() POP(); (push)

 mov %rax,-56(%rbp)
# ir_load [L3 . 1] POP();

 mov 48(%rbp),%rax
# ir_deref A2; (push)

 push %rdi
 push %rsi
 lea -48(%rbp),%rdi
 lea 0(%rax),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L2 POP() 16;

 lea -64(%rbp),%rbx
# ir_load_addr L3; (push)

 lea -48(%rbp),%rax
# ir_load_addr L2; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring
# ir_call cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring POP() POP(); (push)

 cmp $0,%al
 je cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$if3837$else
# ir_jmp_eq POP() 0 cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$if3837$else;

cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$if3837$body:
# ir_make_label cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$if3837$body;

 mov 32(%rbp),%rbx
# ir_deref A0; (push)

 movsxd -4(%rbp),%rax
# ir_cast L0; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 mov $1,%r10b
 mov %r10b,8(%rax)
# ir_load [POP() . 1] 1;

 mov 32(%rbp),%rax
 jmp cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$end
# ir_return A0;

cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$if3837$else:
# ir_make_label cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$if3837$else;

 mov -4(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L0 1; (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

 jmp cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$f3840$cond
# ir_jmp cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$f3840$cond;

cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$f3840$end:
# ir_make_label cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$f3840$end;

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 xor %r10d,%r10d
 mov %r10,0(%rax)
# ir_load [POP() . 0] 0;

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 xor %r10b,%r10b
 mov %r10b,8(%rax)
# ir_load [POP() . 1] 0;

 mov 32(%rbp),%rax
# ir_return A0;

cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$end:
 add $88,%rsp
 pop %rbx
 pop %rbp
 ret


