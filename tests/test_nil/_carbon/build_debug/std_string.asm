.global cb__Nstd__Nstring__Nfrom_cstring__Aptr__Tslice__Tpure__Tuint8__Aptr__Tpure__Tuint8
.global cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring
.global cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8
.global cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring
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
    .asciz ""
.text
cb__Nstd__Nstring__Nfrom_cstring__Aptr__Tslice__Tpure__Tuint8__Aptr__Tpure__Tuint8:
# func from_cstring(&[]pure uint8, &pure uint8): &[]pure uint8
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov 24(%rbp),%r10
 mov %r10,-16(%rbp)
# ir_load [L0 . 0] A1;

 xor %r10d,%r10d
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] 0;

.w3075$cond:
# ir_make_label .w3075$cond;

 mov 24(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%r10b
 mov %r10d,%eax
# ir_cast POP(); (push)

 cmp $0,%eax
 je .w3075$end
# ir_jmp_eq POP() 0 .w3075$end;

.w3075$body:
# ir_make_label .w3075$body;

 mov 24(%rbp),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add A1 1; (push)

 mov %rax,24(%rbp)
# ir_load A1 POP();

 mov -8(%rbp),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add [L0 . 1] 1; (push)

 mov %rax,-8(%rbp)
# ir_load [L0 . 1] POP();

 jmp .w3075$cond
# ir_jmp .w3075$cond;

.w3075$end:
# ir_make_label .w3075$end;

 mov 16(%rbp),%rax
# ir_deref A0; (push)

 push %rdi
 push %rsi
 lea 0(%rax),%rdi
 lea -16(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy POP() L0 16;

 mov 16(%rbp),%rax
# ir_return A0;

.cb__Nstd__Nstring__Nfrom_cstring__Aptr__Tslice__Tpure__Tuint8__Aptr__Tpure__Tuint8$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring:
# func equals(string, string): bool
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $48,%rsp
# prolog end

 mov %rdi,%rbx
# ir_deref A0; (push)

 mov %rsi,%rax
# ir_deref A1; (push)

 mov 8(%rbx),%r10
 cmp 8(%rax),%r10
 je .if3119$else
# ir_jmp_eq [POP() . 1] [POP() . 1] .if3119$else;

.if3119$body:
# ir_make_label .if3119$body;

 xor %al,%al
 jmp .cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$end
# ir_return 0;

.if3119$else:
# ir_make_label .if3119$else;

 xor %r10d,%r10d
 mov %r10d,-32(%rbp)
# ir_load [L1 . 0] 0;

 mov %rdi,%rax
# ir_deref A0; (push)

 mov 8(%rax),%r10
 mov %r10,-24(%rbp)
# ir_load [L1 . 1] [POP() . 1];

 mov -32(%rbp),%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 [L1 . 0];

.f3143$cond:
# ir_make_label .f3143$cond;

 mov -32(%rbp),%r10d
 cmp -24(%rbp),%r10d
 jge .f3143$neg
# ir_jmp_gte [L1 . 0] [L1 . 1] .f3143$neg;

 mov $1,%r10d
 mov %r10d,-36(%rbp)
# ir_load L2 1;

 mov -4(%rbp),%r10d
 cmp -24(%rbp),%r10d
 jge .f3143$end
# ir_jmp_gte L0 [L1 . 1] .f3143$end;

 jmp .f3143$body
# ir_jmp .f3143$body;

.f3143$neg:
# ir_make_label .f3143$neg;

 mov $-1,%r10d
 mov %r10d,-36(%rbp)
# ir_load L2 -1;

 mov -4(%rbp),%r10d
 cmp -24(%rbp),%r10d
 jle .f3143$end
# ir_jmp_lte L0 [L1 . 1] .f3143$end;

.f3143$body:
# ir_make_label .f3143$body;

 mov %rdi,%rax
# ir_deref A0; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 mov -4(%rbp),%r10d
 mov %r10,%r10
 lea 0(%rax,%r10,1),%rbx
# ir_index POP() L0; (push)

 mov %rsi,%rax
# ir_deref A1; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 mov -4(%rbp),%r10d
 mov %r10,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L0; (push)

 mov (%rbx),%r10b
 cmp (%rax),%r10b
 je .if3140$else
# ir_jmp_eq POP() POP() .if3140$else;

.if3140$body:
# ir_make_label .if3140$body;

 xor %al,%al
 jmp .cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$end
# ir_return 0;

.if3140$else:
# ir_make_label .if3140$else;

 mov -4(%rbp),%r10d
 add -36(%rbp),%r10d
 mov %r10d,%eax
# ir_add L0 L2; (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

 jmp .f3143$cond
# ir_jmp .f3143$cond;

.f3143$end:
# ir_make_label .f3143$end;

 mov $1,%al
# ir_return 1;

.cb__Nstd__Nstring__Nequals__Aptr__Tstring__Aptr__Tstring$end:
 add $56,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8:
# func find(&{usize, bool}, &string, uint8): &{usize, bool}
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $64,%rsp
# prolog end

 xor %r10d,%r10d
 mov %r10d,-32(%rbp)
# ir_load [L1 . 0] 0;

 mov %rsi,%rax
# ir_deref A1; (push)

 mov 8(%rax),%r10
 mov %r10,-24(%rbp)
# ir_load [L1 . 1] [POP() . 1];

 mov -32(%rbp),%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 [L1 . 0];

.f3197$cond:
# ir_make_label .f3197$cond;

 mov -32(%rbp),%r10d
 cmp -24(%rbp),%r10d
 jge .f3197$neg
# ir_jmp_gte [L1 . 0] [L1 . 1] .f3197$neg;

 mov $1,%r10d
 mov %r10d,-36(%rbp)
# ir_load L2 1;

 mov -4(%rbp),%r10d
 cmp -24(%rbp),%r10d
 jge .f3197$end
# ir_jmp_gte L0 [L1 . 1] .f3197$end;

 jmp .f3197$body
# ir_jmp .f3197$body;

.f3197$neg:
# ir_make_label .f3197$neg;

 mov $-1,%r10d
 mov %r10d,-36(%rbp)
# ir_load L2 -1;

 mov -4(%rbp),%r10d
 cmp -24(%rbp),%r10d
 jle .f3197$end
# ir_jmp_lte L0 [L1 . 1] .f3197$end;

.f3197$body:
# ir_make_label .f3197$body;

 mov %rsi,%rax
# ir_deref A1; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 mov -4(%rbp),%r10d
 mov %r10,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L0; (push)

 mov (%rax),%r10b
 cmp %dl,%r10b
 jne .if3194$else
# ir_jmp_neq POP() A2 .if3194$else;

.if3194$body:
# ir_make_label .if3194$body;

 mov %rdi,-48(%rbp)
# ir_load L3 A0;

 mov -48(%rbp),%rbx
# ir_deref L3; (push)

 mov -4(%rbp),%r10d
 mov %r10,%rax
# ir_cast L0; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov -48(%rbp),%rax
# ir_deref L3; (push)

 mov $1,%r10b
 mov %r10b,8(%rax)
# ir_load [POP() . 1] 1;

 mov %rdi,%rax
 jmp .cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$end
# ir_return A0;

.if3194$else:
# ir_make_label .if3194$else;

 mov -4(%rbp),%r10d
 add -36(%rbp),%r10d
 mov %r10d,%eax
# ir_add L0 L2; (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

 jmp .f3197$cond
# ir_jmp .f3197$cond;

.f3197$end:
# ir_make_label .f3197$end;

 mov %rdi,-56(%rbp)
# ir_load L4 A0;

 mov -56(%rbp),%rax
# ir_deref L4; (push)

 xor %r10d,%r10d
 mov %r10,0(%rax)
# ir_load [POP() . 0] 0;

 mov -56(%rbp),%rax
# ir_deref L4; (push)

 xor %r10b,%r10b
 mov %r10b,8(%rax)
# ir_load [POP() . 1] 0;

 mov %rdi,%rax
# ir_return A0;

.cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Auint8$end:
 add $72,%rsp
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
 sub $112,%rsp
# prolog end

 xor %r10d,%r10d
 mov %r10d,-32(%rbp)
# ir_load [L1 . 0] 0;

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 8(%rax),%r10
 mov %r10,-24(%rbp)
# ir_load [L1 . 1] [POP() . 1];

 mov -32(%rbp),%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 [L1 . 0];

.f3273$cond:
# ir_make_label .f3273$cond;

 mov -32(%rbp),%r10d
 cmp -24(%rbp),%r10d
 jge .f3273$neg
# ir_jmp_gte [L1 . 0] [L1 . 1] .f3273$neg;

 mov $1,%r10d
 mov %r10d,-68(%rbp)
# ir_load L4 1;

 mov -4(%rbp),%r10d
 cmp -24(%rbp),%r10d
 jge .f3273$end
# ir_jmp_gte L0 [L1 . 1] .f3273$end;

 jmp .f3273$body
# ir_jmp .f3273$body;

.f3273$neg:
# ir_make_label .f3273$neg;

 mov $-1,%r10d
 mov %r10d,-68(%rbp)
# ir_load L4 -1;

 mov -4(%rbp),%r10d
 cmp -24(%rbp),%r10d
 jle .f3273$end
# ir_jmp_lte L0 [L1 . 1] .f3273$end;

.f3273$body:
# ir_make_label .f3273$body;

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 mov -4(%rbp),%r10d
 mov %r10,%r10
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
 jne .if3270$else
# ir_jmp_neq POP() POP() .if3270$else;

 mov -4(%rbp),%r10d
 mov %r10,%rbx
# ir_cast L0; (push)

 mov 48(%rbp),%rax
# ir_deref A2; (push)

 add 8(%rax),%rbx
# ir_add POP() [POP() . 1]; (push)

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 cmp 8(%rax),%rbx
 jge .if3270$else
# ir_jmp_gte POP() [POP() . 1] .if3270$else;

 lea .cbstr0(%rip),%rax
# ir_load_addr STR0; (push)

 mov %rax,-64(%rbp)
# ir_load [L3 . 0] POP();

 xor %r10d,%r10d
 mov %r10,-56(%rbp)
# ir_load [L3 . 1] 0;

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
 je .if3270$else
# ir_jmp_eq POP() 0 .if3270$else;

.if3270$body:
# ir_make_label .if3270$body;

 mov 32(%rbp),%r10
 mov %r10,-80(%rbp)
# ir_load L5 A0;

 mov -80(%rbp),%rbx
# ir_deref L5; (push)

 mov -4(%rbp),%r10d
 mov %r10,%rax
# ir_cast L0; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov -80(%rbp),%rax
# ir_deref L5; (push)

 mov $1,%r10b
 mov %r10b,8(%rax)
# ir_load [POP() . 1] 1;

 mov 32(%rbp),%rax
 jmp .cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$end
# ir_return A0;

.if3270$else:
# ir_make_label .if3270$else;

 mov -4(%rbp),%r10d
 add -68(%rbp),%r10d
 mov %r10d,%eax
# ir_add L0 L4; (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

 jmp .f3273$cond
# ir_jmp .f3273$cond;

.f3273$end:
# ir_make_label .f3273$end;

 mov 32(%rbp),%r10
 mov %r10,-88(%rbp)
# ir_load L6 A0;

 mov -88(%rbp),%rax
# ir_deref L6; (push)

 xor %r10d,%r10d
 mov %r10,0(%rax)
# ir_load [POP() . 0] 0;

 mov -88(%rbp),%rax
# ir_deref L6; (push)

 xor %r10b,%r10b
 mov %r10b,8(%rax)
# ir_load [POP() . 1] 0;

 mov 32(%rbp),%rax
# ir_return A0;

.cb__Nstd__Nstring__Nfind__Aptr__Ttuple__Tusize__Tbool__Aptr__Tstring__Aptr__Tstring$end:
 add $120,%rsp
 pop %rbx
 pop %rbp
 ret


