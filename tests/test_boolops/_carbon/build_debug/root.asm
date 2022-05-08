.global cb__Nroot__Nside_effect
.global cb__Nroot__Nmain
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
    .comm root__a,4,4
.section .rodata
.text
cb__Nroot__Nside_effect:
# func side_effect(): bool
 sub $8,%rsp
# prolog end

 mov root__a,%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add  1; (push)

 mov %eax,root__a
# ir_load  POP();

 mov $1,%al
# ir_return 1;

cb__Nroot__Nside_effect$end:
 add $8,%rsp
 ret


cb__Nroot__Nmain:
# func main(): {}
 push %rbp
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 mov $2,%r10d
 cmp $5,%r10d
 setg %al
# ir_cmp_gt 2 5; (push)

 mov %al,%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool POP();

 mov $2,%r10d
 cmp $5,%r10d
 setl %al
# ir_cmp_lt 2 5; (push)

 mov %al,%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool POP();

 mov $2,%r10d
 cmp $5,%r10d
 jge cb__Nroot__Nmain$if4621$else
# ir_jmp_gte 2 5 cb__Nroot__Nmain$if4621$else;

 mov $10,%r10d
 cmp $10,%r10d
 jne cb__Nroot__Nmain$if4621$else
# ir_jmp_neq 10 10 cb__Nroot__Nmain$if4621$else;

cb__Nroot__Nmain$if4621$body:
# ir_make_label cb__Nroot__Nmain$if4621$body;

 mov $1,%r10b
 mov %r10b,-2(%rbp)
# ir_load L1 1;

 jmp cb__Nroot__Nmain$if4621$end
# ir_jmp cb__Nroot__Nmain$if4621$end;

cb__Nroot__Nmain$if4621$else:
# ir_make_label cb__Nroot__Nmain$if4621$else;

 xor %r10b,%r10b
 mov %r10b,-2(%rbp)
# ir_load L1 0;

cb__Nroot__Nmain$if4621$end:
# ir_make_label cb__Nroot__Nmain$if4621$end;

 mov -2(%rbp),%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool L1;

 mov $2,%r10d
 cmp $5,%r10d
 jge cb__Nroot__Nmain$if4642$else
# ir_jmp_gte 2 5 cb__Nroot__Nmain$if4642$else;

 mov $10,%r10d
 cmp $11,%r10d
 jne cb__Nroot__Nmain$if4642$else
# ir_jmp_neq 10 11 cb__Nroot__Nmain$if4642$else;

cb__Nroot__Nmain$if4642$body:
# ir_make_label cb__Nroot__Nmain$if4642$body;

 mov $1,%r10b
 mov %r10b,-3(%rbp)
# ir_load L2 1;

 jmp cb__Nroot__Nmain$if4642$end
# ir_jmp cb__Nroot__Nmain$if4642$end;

cb__Nroot__Nmain$if4642$else:
# ir_make_label cb__Nroot__Nmain$if4642$else;

 xor %r10b,%r10b
 mov %r10b,-3(%rbp)
# ir_load L2 0;

cb__Nroot__Nmain$if4642$end:
# ir_make_label cb__Nroot__Nmain$if4642$end;

 mov -3(%rbp),%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool L2;

 mov $2,%r10d
 cmp $5,%r10d
 jge cb__Nroot__Nmain$if4667$else
# ir_jmp_gte 2 5 cb__Nroot__Nmain$if4667$else;

 mov $10,%r10d
 cmp $11,%r10d
 jne cb__Nroot__Nmain$if4667$else
# ir_jmp_neq 10 11 cb__Nroot__Nmain$if4667$else;

 mov $90,%r10d
 cmp $10,%r10d
 jge cb__Nroot__Nmain$if4667$else
# ir_jmp_gte 90 10 cb__Nroot__Nmain$if4667$else;

cb__Nroot__Nmain$if4667$body:
# ir_make_label cb__Nroot__Nmain$if4667$body;

 mov $1,%r10b
 mov %r10b,-4(%rbp)
# ir_load L3 1;

 jmp cb__Nroot__Nmain$if4667$end
# ir_jmp cb__Nroot__Nmain$if4667$end;

cb__Nroot__Nmain$if4667$else:
# ir_make_label cb__Nroot__Nmain$if4667$else;

 xor %r10b,%r10b
 mov %r10b,-4(%rbp)
# ir_load L3 0;

cb__Nroot__Nmain$if4667$end:
# ir_make_label cb__Nroot__Nmain$if4667$end;

 mov -4(%rbp),%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool L3;

 mov $2,%r10d
 cmp $5,%r10d
 jl cb__Nroot__Nmain$if4688$body
# ir_jmp_lt 2 5 cb__Nroot__Nmain$if4688$body;

 mov $10,%r10d
 cmp $10,%r10d
 jne cb__Nroot__Nmain$if4688$else
# ir_jmp_neq 10 10 cb__Nroot__Nmain$if4688$else;

cb__Nroot__Nmain$if4688$body:
# ir_make_label cb__Nroot__Nmain$if4688$body;

 mov $1,%r10b
 mov %r10b,-5(%rbp)
# ir_load L4 1;

 jmp cb__Nroot__Nmain$if4688$end
# ir_jmp cb__Nroot__Nmain$if4688$end;

cb__Nroot__Nmain$if4688$else:
# ir_make_label cb__Nroot__Nmain$if4688$else;

 xor %r10b,%r10b
 mov %r10b,-5(%rbp)
# ir_load L4 0;

cb__Nroot__Nmain$if4688$end:
# ir_make_label cb__Nroot__Nmain$if4688$end;

 mov -5(%rbp),%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool L4;

 mov $2,%r10d
 cmp $5,%r10d
 jl cb__Nroot__Nmain$if4713$body
# ir_jmp_lt 2 5 cb__Nroot__Nmain$if4713$body;

 mov $10,%r10d
 cmp $11,%r10d
 jne cb__Nroot__Nmain$if4713$else
# ir_jmp_neq 10 11 cb__Nroot__Nmain$if4713$else;

 mov $90,%r10d
 cmp $10,%r10d
 jle cb__Nroot__Nmain$if4713$else
# ir_jmp_lte 90 10 cb__Nroot__Nmain$if4713$else;

cb__Nroot__Nmain$if4713$body:
# ir_make_label cb__Nroot__Nmain$if4713$body;

 mov $1,%r10b
 mov %r10b,-6(%rbp)
# ir_load L5 1;

 jmp cb__Nroot__Nmain$if4713$end
# ir_jmp cb__Nroot__Nmain$if4713$end;

cb__Nroot__Nmain$if4713$else:
# ir_make_label cb__Nroot__Nmain$if4713$else;

 xor %r10b,%r10b
 mov %r10b,-6(%rbp)
# ir_load L5 0;

cb__Nroot__Nmain$if4713$end:
# ir_make_label cb__Nroot__Nmain$if4713$end;

 mov -6(%rbp),%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool L5;

 mov $2,%r10d
 cmp $5,%r10d
 jl cb__Nroot__Nmain$if120$body
# ir_jmp_lt 2 5 cb__Nroot__Nmain$if120$body;

 mov $10,%r10d
 cmp $11,%r10d
 jne cb__Nroot__Nmain$if120$else
# ir_jmp_neq 10 11 cb__Nroot__Nmain$if120$else;

 mov $90,%r10d
 cmp $10,%r10d
 jle cb__Nroot__Nmain$if120$else
# ir_jmp_lte 90 10 cb__Nroot__Nmain$if120$else;

cb__Nroot__Nmain$if120$body:
# ir_make_label cb__Nroot__Nmain$if120$body;

 mov $1,%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool 1;

 jmp cb__Nroot__Nmain$if120$end
# ir_jmp cb__Nroot__Nmain$if120$end;

cb__Nroot__Nmain$if120$else:
# ir_make_label cb__Nroot__Nmain$if120$else;

 xor %dil,%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool 0;

cb__Nroot__Nmain$if120$end:
# ir_make_label cb__Nroot__Nmain$if120$end;

 mov $2,%r10d
 cmp $5,%r10d
 jge cb__Nroot__Nmain$if145$else
# ir_jmp_gte 2 5 cb__Nroot__Nmain$if145$else;

 mov $10,%r10d
 cmp $11,%r10d
 jne cb__Nroot__Nmain$if145$else
# ir_jmp_neq 10 11 cb__Nroot__Nmain$if145$else;

 mov $90,%r10d
 cmp $10,%r10d
 jge cb__Nroot__Nmain$if145$else
# ir_jmp_gte 90 10 cb__Nroot__Nmain$if145$else;

cb__Nroot__Nmain$if145$body:
# ir_make_label cb__Nroot__Nmain$if145$body;

 mov $1,%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool 1;

 jmp cb__Nroot__Nmain$if145$end
# ir_jmp cb__Nroot__Nmain$if145$end;

cb__Nroot__Nmain$if145$else:
# ir_make_label cb__Nroot__Nmain$if145$else;

 xor %dil,%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool 0;

cb__Nroot__Nmain$if145$end:
# ir_make_label cb__Nroot__Nmain$if145$end;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

 mov $2,%r10d
 cmp $5,%r10d
 jle cb__Nroot__Nmain$if4720$else
# ir_jmp_lte 2 5 cb__Nroot__Nmain$if4720$else;

 call cb__Nroot__Nside_effect
# ir_call cb__Nroot__Nside_effect; (push)

 cmp $0,%al
 je cb__Nroot__Nmain$if4720$else
# ir_jmp_eq POP() 0 cb__Nroot__Nmain$if4720$else;

cb__Nroot__Nmain$if4720$body:
# ir_make_label cb__Nroot__Nmain$if4720$body;

 mov $1,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 1;

 jmp cb__Nroot__Nmain$if4720$end
# ir_jmp cb__Nroot__Nmain$if4720$end;

cb__Nroot__Nmain$if4720$else:
# ir_make_label cb__Nroot__Nmain$if4720$else;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

cb__Nroot__Nmain$if4720$end:
# ir_make_label cb__Nroot__Nmain$if4720$end;

 mov root__a,%edi
 call cb__Nstd__Nio__Nprintln__Aint
# ir_call cb__Nstd__Nio__Nprintln__Aint ;

 mov $2,%r10d
 cmp $5,%r10d
 jg cb__Nroot__Nmain$if4727$body
# ir_jmp_gt 2 5 cb__Nroot__Nmain$if4727$body;

 call cb__Nroot__Nside_effect
# ir_call cb__Nroot__Nside_effect; (push)

 cmp $0,%al
 je cb__Nroot__Nmain$if4727$else
# ir_jmp_eq POP() 0 cb__Nroot__Nmain$if4727$else;

cb__Nroot__Nmain$if4727$body:
# ir_make_label cb__Nroot__Nmain$if4727$body;

 mov $1,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 1;

 jmp cb__Nroot__Nmain$if4727$end
# ir_jmp cb__Nroot__Nmain$if4727$end;

cb__Nroot__Nmain$if4727$else:
# ir_make_label cb__Nroot__Nmain$if4727$else;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

cb__Nroot__Nmain$if4727$end:
# ir_make_label cb__Nroot__Nmain$if4727$end;

 mov root__a,%edi
 call cb__Nstd__Nio__Nprintln__Aint
# ir_call cb__Nstd__Nio__Nprintln__Aint ;

 mov $2,%r10d
 cmp $5,%r10d
 jl cb__Nroot__Nmain$if4734$body
# ir_jmp_lt 2 5 cb__Nroot__Nmain$if4734$body;

 call cb__Nroot__Nside_effect
# ir_call cb__Nroot__Nside_effect; (push)

 cmp $0,%al
 je cb__Nroot__Nmain$if4734$else
# ir_jmp_eq POP() 0 cb__Nroot__Nmain$if4734$else;

cb__Nroot__Nmain$if4734$body:
# ir_make_label cb__Nroot__Nmain$if4734$body;

 mov $1,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 1;

 jmp cb__Nroot__Nmain$if4734$end
# ir_jmp cb__Nroot__Nmain$if4734$end;

cb__Nroot__Nmain$if4734$else:
# ir_make_label cb__Nroot__Nmain$if4734$else;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

cb__Nroot__Nmain$if4734$end:
# ir_make_label cb__Nroot__Nmain$if4734$end;

 mov root__a,%edi
 call cb__Nstd__Nio__Nprintln__Aint
# ir_call cb__Nstd__Nio__Nprintln__Aint ;

cb__Nroot__Nmain$end:
 add $32,%rsp
 pop %rbp
 ret


