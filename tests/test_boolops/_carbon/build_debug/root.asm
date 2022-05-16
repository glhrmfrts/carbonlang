.global cb__Nroot__Nside_effect
.global cb__Nroot__Nmain
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
    .comm root__a,4,4
.section .rodata
.text
cb__Nroot__Nside_effect:
# func side_effect(): bool
 sub $8,%rsp
# prolog end

 mov root__a(%rip),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add  1; (push)

 mov %eax,root__a(%rip)
# ir_load  POP();

 mov $1,%al
# ir_return 1;

.cb__Nroot__Nside_effect$end:
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
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool POP();

 mov $2,%r10d
 cmp $5,%r10d
 setl %al
# ir_cmp_lt 2 5; (push)

 mov %al,%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool POP();

 mov $2,%r10d
 cmp $5,%r10d
 jge .if5034$else
# ir_jmp_gte 2 5 .if5034$else;

 mov $10,%r10d
 cmp $10,%r10d
 jne .if5034$else
# ir_jmp_neq 10 10 .if5034$else;

.if5034$body:
# ir_make_label .if5034$body;

 mov $1,%r10b
 mov %r10b,-2(%rbp)
# ir_load L1 1;

 jmp .if5034$end
# ir_jmp .if5034$end;

.if5034$else:
# ir_make_label .if5034$else;

 xor %r10b,%r10b
 mov %r10b,-2(%rbp)
# ir_load L1 0;

.if5034$end:
# ir_make_label .if5034$end;

 mov -2(%rbp),%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool L1;

 mov $2,%r10d
 cmp $5,%r10d
 jge .if5055$else
# ir_jmp_gte 2 5 .if5055$else;

 mov $10,%r10d
 cmp $11,%r10d
 jne .if5055$else
# ir_jmp_neq 10 11 .if5055$else;

.if5055$body:
# ir_make_label .if5055$body;

 mov $1,%r10b
 mov %r10b,-3(%rbp)
# ir_load L2 1;

 jmp .if5055$end
# ir_jmp .if5055$end;

.if5055$else:
# ir_make_label .if5055$else;

 xor %r10b,%r10b
 mov %r10b,-3(%rbp)
# ir_load L2 0;

.if5055$end:
# ir_make_label .if5055$end;

 mov -3(%rbp),%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool L2;

 mov $2,%r10d
 cmp $5,%r10d
 jge .if5080$else
# ir_jmp_gte 2 5 .if5080$else;

 mov $10,%r10d
 cmp $11,%r10d
 jne .if5080$else
# ir_jmp_neq 10 11 .if5080$else;

 mov $90,%r10d
 cmp $10,%r10d
 jge .if5080$else
# ir_jmp_gte 90 10 .if5080$else;

.if5080$body:
# ir_make_label .if5080$body;

 mov $1,%r10b
 mov %r10b,-4(%rbp)
# ir_load L3 1;

 jmp .if5080$end
# ir_jmp .if5080$end;

.if5080$else:
# ir_make_label .if5080$else;

 xor %r10b,%r10b
 mov %r10b,-4(%rbp)
# ir_load L3 0;

.if5080$end:
# ir_make_label .if5080$end;

 mov -4(%rbp),%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool L3;

 mov $2,%r10d
 cmp $5,%r10d
 jl .if5101$body
# ir_jmp_lt 2 5 .if5101$body;

 mov $10,%r10d
 cmp $10,%r10d
 jne .if5101$else
# ir_jmp_neq 10 10 .if5101$else;

.if5101$body:
# ir_make_label .if5101$body;

 mov $1,%r10b
 mov %r10b,-5(%rbp)
# ir_load L4 1;

 jmp .if5101$end
# ir_jmp .if5101$end;

.if5101$else:
# ir_make_label .if5101$else;

 xor %r10b,%r10b
 mov %r10b,-5(%rbp)
# ir_load L4 0;

.if5101$end:
# ir_make_label .if5101$end;

 mov -5(%rbp),%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool L4;

 mov $2,%r10d
 cmp $5,%r10d
 jl .if5126$body
# ir_jmp_lt 2 5 .if5126$body;

 mov $10,%r10d
 cmp $11,%r10d
 jne .if5126$else
# ir_jmp_neq 10 11 .if5126$else;

 mov $90,%r10d
 cmp $10,%r10d
 jle .if5126$else
# ir_jmp_lte 90 10 .if5126$else;

.if5126$body:
# ir_make_label .if5126$body;

 mov $1,%r10b
 mov %r10b,-6(%rbp)
# ir_load L5 1;

 jmp .if5126$end
# ir_jmp .if5126$end;

.if5126$else:
# ir_make_label .if5126$else;

 xor %r10b,%r10b
 mov %r10b,-6(%rbp)
# ir_load L5 0;

.if5126$end:
# ir_make_label .if5126$end;

 mov -6(%rbp),%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool L5;

 mov $2,%r10d
 cmp $5,%r10d
 jl .if120$body
# ir_jmp_lt 2 5 .if120$body;

 mov $10,%r10d
 cmp $11,%r10d
 jne .if120$else
# ir_jmp_neq 10 11 .if120$else;

 mov $90,%r10d
 cmp $10,%r10d
 jle .if120$else
# ir_jmp_lte 90 10 .if120$else;

.if120$body:
# ir_make_label .if120$body;

 mov $1,%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool 1;

 jmp .if120$end
# ir_jmp .if120$end;

.if120$else:
# ir_make_label .if120$else;

 xor %dil,%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool 0;

.if120$end:
# ir_make_label .if120$end;

 mov $2,%r10d
 cmp $5,%r10d
 jge .if145$else
# ir_jmp_gte 2 5 .if145$else;

 mov $10,%r10d
 cmp $11,%r10d
 jne .if145$else
# ir_jmp_neq 10 11 .if145$else;

 mov $90,%r10d
 cmp $10,%r10d
 jge .if145$else
# ir_jmp_gte 90 10 .if145$else;

.if145$body:
# ir_make_label .if145$body;

 mov $1,%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool 1;

 jmp .if145$end
# ir_jmp .if145$end;

.if145$else:
# ir_make_label .if145$else;

 xor %dil,%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool 0;

.if145$end:
# ir_make_label .if145$end;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

 mov $2,%r10d
 cmp $5,%r10d
 jle .if5133$else
# ir_jmp_lte 2 5 .if5133$else;

 call cb__Nroot__Nside_effect
# ir_call cb__Nroot__Nside_effect; (push)

 cmp $0,%al
 je .if5133$else
# ir_jmp_eq POP() 0 .if5133$else;

.if5133$body:
# ir_make_label .if5133$body;

 mov $1,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 1;

 jmp .if5133$end
# ir_jmp .if5133$end;

.if5133$else:
# ir_make_label .if5133$else;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

.if5133$end:
# ir_make_label .if5133$end;

 mov root__a(%rip),%edi
 call cb__Nio__Nprintln__Aint
# ir_call cb__Nio__Nprintln__Aint ;

 mov $2,%r10d
 cmp $5,%r10d
 jg .if5140$body
# ir_jmp_gt 2 5 .if5140$body;

 call cb__Nroot__Nside_effect
# ir_call cb__Nroot__Nside_effect; (push)

 cmp $0,%al
 je .if5140$else
# ir_jmp_eq POP() 0 .if5140$else;

.if5140$body:
# ir_make_label .if5140$body;

 mov $1,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 1;

 jmp .if5140$end
# ir_jmp .if5140$end;

.if5140$else:
# ir_make_label .if5140$else;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

.if5140$end:
# ir_make_label .if5140$end;

 mov root__a(%rip),%edi
 call cb__Nio__Nprintln__Aint
# ir_call cb__Nio__Nprintln__Aint ;

 mov $2,%r10d
 cmp $5,%r10d
 jl .if5147$body
# ir_jmp_lt 2 5 .if5147$body;

 call cb__Nroot__Nside_effect
# ir_call cb__Nroot__Nside_effect; (push)

 cmp $0,%al
 je .if5147$else
# ir_jmp_eq POP() 0 .if5147$else;

.if5147$body:
# ir_make_label .if5147$body;

 mov $1,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 1;

 jmp .if5147$end
# ir_jmp .if5147$end;

.if5147$else:
# ir_make_label .if5147$else;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

.if5147$end:
# ir_make_label .if5147$end;

 mov root__a(%rip),%edi
 call cb__Nio__Nprintln__Aint
# ir_call cb__Nio__Nprintln__Aint ;

.cb__Nroot__Nmain$end:
 add $32,%rsp
 pop %rbp
 ret


