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
 jge cb__Nroot__Nmain$if4371$else
# ir_jmp_gte 2 5 cb__Nroot__Nmain$if4371$else;

 mov $10,%r10d
 cmp $10,%r10d
 jne cb__Nroot__Nmain$if4371$else
# ir_jmp_neq 10 10 cb__Nroot__Nmain$if4371$else;

cb__Nroot__Nmain$if4371$body:
# ir_make_label cb__Nroot__Nmain$if4371$body;

 mov $1,%r10b
 mov %r10b,-2(%rbp)
# ir_load L1 1;

 jmp cb__Nroot__Nmain$if4371$end
# ir_jmp cb__Nroot__Nmain$if4371$end;

cb__Nroot__Nmain$if4371$else:
# ir_make_label cb__Nroot__Nmain$if4371$else;

 xor %r10b,%r10b
 mov %r10b,-2(%rbp)
# ir_load L1 0;

cb__Nroot__Nmain$if4371$end:
# ir_make_label cb__Nroot__Nmain$if4371$end;

 mov -2(%rbp),%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool L1;

 mov $2,%r10d
 cmp $5,%r10d
 jge cb__Nroot__Nmain$if4392$else
# ir_jmp_gte 2 5 cb__Nroot__Nmain$if4392$else;

 mov $10,%r10d
 cmp $11,%r10d
 jne cb__Nroot__Nmain$if4392$else
# ir_jmp_neq 10 11 cb__Nroot__Nmain$if4392$else;

cb__Nroot__Nmain$if4392$body:
# ir_make_label cb__Nroot__Nmain$if4392$body;

 mov $1,%r10b
 mov %r10b,-3(%rbp)
# ir_load L2 1;

 jmp cb__Nroot__Nmain$if4392$end
# ir_jmp cb__Nroot__Nmain$if4392$end;

cb__Nroot__Nmain$if4392$else:
# ir_make_label cb__Nroot__Nmain$if4392$else;

 xor %r10b,%r10b
 mov %r10b,-3(%rbp)
# ir_load L2 0;

cb__Nroot__Nmain$if4392$end:
# ir_make_label cb__Nroot__Nmain$if4392$end;

 mov -3(%rbp),%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool L2;

 mov $2,%r10d
 cmp $5,%r10d
 jge cb__Nroot__Nmain$if4417$else
# ir_jmp_gte 2 5 cb__Nroot__Nmain$if4417$else;

 mov $10,%r10d
 cmp $11,%r10d
 jne cb__Nroot__Nmain$if4417$else
# ir_jmp_neq 10 11 cb__Nroot__Nmain$if4417$else;

 mov $90,%r10d
 cmp $10,%r10d
 jge cb__Nroot__Nmain$if4417$else
# ir_jmp_gte 90 10 cb__Nroot__Nmain$if4417$else;

cb__Nroot__Nmain$if4417$body:
# ir_make_label cb__Nroot__Nmain$if4417$body;

 mov $1,%r10b
 mov %r10b,-4(%rbp)
# ir_load L3 1;

 jmp cb__Nroot__Nmain$if4417$end
# ir_jmp cb__Nroot__Nmain$if4417$end;

cb__Nroot__Nmain$if4417$else:
# ir_make_label cb__Nroot__Nmain$if4417$else;

 xor %r10b,%r10b
 mov %r10b,-4(%rbp)
# ir_load L3 0;

cb__Nroot__Nmain$if4417$end:
# ir_make_label cb__Nroot__Nmain$if4417$end;

 mov -4(%rbp),%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool L3;

 mov $2,%r10d
 cmp $5,%r10d
 jl cb__Nroot__Nmain$if4438$body
# ir_jmp_lt 2 5 cb__Nroot__Nmain$if4438$body;

 mov $10,%r10d
 cmp $10,%r10d
 jne cb__Nroot__Nmain$if4438$else
# ir_jmp_neq 10 10 cb__Nroot__Nmain$if4438$else;

cb__Nroot__Nmain$if4438$body:
# ir_make_label cb__Nroot__Nmain$if4438$body;

 mov $1,%r10b
 mov %r10b,-5(%rbp)
# ir_load L4 1;

 jmp cb__Nroot__Nmain$if4438$end
# ir_jmp cb__Nroot__Nmain$if4438$end;

cb__Nroot__Nmain$if4438$else:
# ir_make_label cb__Nroot__Nmain$if4438$else;

 xor %r10b,%r10b
 mov %r10b,-5(%rbp)
# ir_load L4 0;

cb__Nroot__Nmain$if4438$end:
# ir_make_label cb__Nroot__Nmain$if4438$end;

 mov -5(%rbp),%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool L4;

 mov $2,%r10d
 cmp $5,%r10d
 jl cb__Nroot__Nmain$if4463$body
# ir_jmp_lt 2 5 cb__Nroot__Nmain$if4463$body;

 mov $10,%r10d
 cmp $11,%r10d
 jne cb__Nroot__Nmain$if4463$else
# ir_jmp_neq 10 11 cb__Nroot__Nmain$if4463$else;

 mov $90,%r10d
 cmp $10,%r10d
 jle cb__Nroot__Nmain$if4463$else
# ir_jmp_lte 90 10 cb__Nroot__Nmain$if4463$else;

cb__Nroot__Nmain$if4463$body:
# ir_make_label cb__Nroot__Nmain$if4463$body;

 mov $1,%r10b
 mov %r10b,-6(%rbp)
# ir_load L5 1;

 jmp cb__Nroot__Nmain$if4463$end
# ir_jmp cb__Nroot__Nmain$if4463$end;

cb__Nroot__Nmain$if4463$else:
# ir_make_label cb__Nroot__Nmain$if4463$else;

 xor %r10b,%r10b
 mov %r10b,-6(%rbp)
# ir_load L5 0;

cb__Nroot__Nmain$if4463$end:
# ir_make_label cb__Nroot__Nmain$if4463$end;

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
 jle cb__Nroot__Nmain$if4470$else
# ir_jmp_lte 2 5 cb__Nroot__Nmain$if4470$else;

 call cb__Nroot__Nside_effect
# ir_call cb__Nroot__Nside_effect; (push)

 cmp $0,%al
 je cb__Nroot__Nmain$if4470$else
# ir_jmp_eq POP() 0 cb__Nroot__Nmain$if4470$else;

cb__Nroot__Nmain$if4470$body:
# ir_make_label cb__Nroot__Nmain$if4470$body;

 mov $1,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 1;

 jmp cb__Nroot__Nmain$if4470$end
# ir_jmp cb__Nroot__Nmain$if4470$end;

cb__Nroot__Nmain$if4470$else:
# ir_make_label cb__Nroot__Nmain$if4470$else;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

cb__Nroot__Nmain$if4470$end:
# ir_make_label cb__Nroot__Nmain$if4470$end;

 mov root__a,%edi
 call cb__Nstd__Nio__Nprintln__Aint
# ir_call cb__Nstd__Nio__Nprintln__Aint ;

 mov $2,%r10d
 cmp $5,%r10d
 jg cb__Nroot__Nmain$if4477$body
# ir_jmp_gt 2 5 cb__Nroot__Nmain$if4477$body;

 call cb__Nroot__Nside_effect
# ir_call cb__Nroot__Nside_effect; (push)

 cmp $0,%al
 je cb__Nroot__Nmain$if4477$else
# ir_jmp_eq POP() 0 cb__Nroot__Nmain$if4477$else;

cb__Nroot__Nmain$if4477$body:
# ir_make_label cb__Nroot__Nmain$if4477$body;

 mov $1,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 1;

 jmp cb__Nroot__Nmain$if4477$end
# ir_jmp cb__Nroot__Nmain$if4477$end;

cb__Nroot__Nmain$if4477$else:
# ir_make_label cb__Nroot__Nmain$if4477$else;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

cb__Nroot__Nmain$if4477$end:
# ir_make_label cb__Nroot__Nmain$if4477$end;

 mov root__a,%edi
 call cb__Nstd__Nio__Nprintln__Aint
# ir_call cb__Nstd__Nio__Nprintln__Aint ;

 mov $2,%r10d
 cmp $5,%r10d
 jl cb__Nroot__Nmain$if4484$body
# ir_jmp_lt 2 5 cb__Nroot__Nmain$if4484$body;

 call cb__Nroot__Nside_effect
# ir_call cb__Nroot__Nside_effect; (push)

 cmp $0,%al
 je cb__Nroot__Nmain$if4484$else
# ir_jmp_eq POP() 0 cb__Nroot__Nmain$if4484$else;

cb__Nroot__Nmain$if4484$body:
# ir_make_label cb__Nroot__Nmain$if4484$body;

 mov $1,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 1;

 jmp cb__Nroot__Nmain$if4484$end
# ir_jmp cb__Nroot__Nmain$if4484$end;

cb__Nroot__Nmain$if4484$else:
# ir_make_label cb__Nroot__Nmain$if4484$else;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

cb__Nroot__Nmain$if4484$end:
# ir_make_label cb__Nroot__Nmain$if4484$end;

 mov root__a,%edi
 call cb__Nstd__Nio__Nprintln__Aint
# ir_call cb__Nstd__Nio__Nprintln__Aint ;

cb__Nroot__Nmain$end:
 add $32,%rsp
 pop %rbp
 ret


