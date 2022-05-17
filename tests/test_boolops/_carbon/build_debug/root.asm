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

 movl root__a(%rip),%r10d
 add $1,%r10d
 movl %r10d,%eax
# ir_add  1; (push)

 movq %eax,root__a(%rip)
# ir_load  POP();

 movb $1,%al
# ir_return 1;

.cb__Nroot__Nside_effect$end:
 add $8,%rsp
 ret


cb__Nroot__Nmain:
# func main(): {}
 push %rbp
 movq %rsp,%rbp
 sub $32,%rsp
# prolog end

 movl $2,%r10d
 cmp $5,%r10d
 setg %al
# ir_cmp_gt 2 5; (push)

 movb %al,%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool POP();

 movl $2,%r10d
 cmp $5,%r10d
 setl %al
# ir_cmp_lt 2 5; (push)

 movb %al,%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool POP();

 movl $2,%r10d
 cmp $5,%r10d
 jge .if5110$else
# ir_jmp_gte 2 5 .if5110$else;

 movl $10,%r10d
 cmp $10,%r10d
 jne .if5110$else
# ir_jmp_neq 10 10 .if5110$else;

.if5110$body:
# ir_make_label .if5110$body;

 movb $1,%r10b
 movb %r10b,-2(%rbp)
# ir_load L1 1;

 jmp .if5110$end
# ir_jmp .if5110$end;

.if5110$else:
# ir_make_label .if5110$else;

 xor %r10b,%r10b
 movb %r10b,-2(%rbp)
# ir_load L1 0;

.if5110$end:
# ir_make_label .if5110$end;

 movb -2(%rbp),%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool L1;

 movl $2,%r10d
 cmp $5,%r10d
 jge .if5131$else
# ir_jmp_gte 2 5 .if5131$else;

 movl $10,%r10d
 cmp $11,%r10d
 jne .if5131$else
# ir_jmp_neq 10 11 .if5131$else;

.if5131$body:
# ir_make_label .if5131$body;

 movb $1,%r10b
 movb %r10b,-3(%rbp)
# ir_load L2 1;

 jmp .if5131$end
# ir_jmp .if5131$end;

.if5131$else:
# ir_make_label .if5131$else;

 xor %r10b,%r10b
 movb %r10b,-3(%rbp)
# ir_load L2 0;

.if5131$end:
# ir_make_label .if5131$end;

 movb -3(%rbp),%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool L2;

 movl $2,%r10d
 cmp $5,%r10d
 jge .if5156$else
# ir_jmp_gte 2 5 .if5156$else;

 movl $10,%r10d
 cmp $11,%r10d
 jne .if5156$else
# ir_jmp_neq 10 11 .if5156$else;

 movl $90,%r10d
 cmp $10,%r10d
 jge .if5156$else
# ir_jmp_gte 90 10 .if5156$else;

.if5156$body:
# ir_make_label .if5156$body;

 movb $1,%r10b
 movb %r10b,-4(%rbp)
# ir_load L3 1;

 jmp .if5156$end
# ir_jmp .if5156$end;

.if5156$else:
# ir_make_label .if5156$else;

 xor %r10b,%r10b
 movb %r10b,-4(%rbp)
# ir_load L3 0;

.if5156$end:
# ir_make_label .if5156$end;

 movb -4(%rbp),%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool L3;

 movl $2,%r10d
 cmp $5,%r10d
 jl .if5177$body
# ir_jmp_lt 2 5 .if5177$body;

 movl $10,%r10d
 cmp $10,%r10d
 jne .if5177$else
# ir_jmp_neq 10 10 .if5177$else;

.if5177$body:
# ir_make_label .if5177$body;

 movb $1,%r10b
 movb %r10b,-5(%rbp)
# ir_load L4 1;

 jmp .if5177$end
# ir_jmp .if5177$end;

.if5177$else:
# ir_make_label .if5177$else;

 xor %r10b,%r10b
 movb %r10b,-5(%rbp)
# ir_load L4 0;

.if5177$end:
# ir_make_label .if5177$end;

 movb -5(%rbp),%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool L4;

 movl $2,%r10d
 cmp $5,%r10d
 jl .if5202$body
# ir_jmp_lt 2 5 .if5202$body;

 movl $10,%r10d
 cmp $11,%r10d
 jne .if5202$else
# ir_jmp_neq 10 11 .if5202$else;

 movl $90,%r10d
 cmp $10,%r10d
 jle .if5202$else
# ir_jmp_lte 90 10 .if5202$else;

.if5202$body:
# ir_make_label .if5202$body;

 movb $1,%r10b
 movb %r10b,-6(%rbp)
# ir_load L5 1;

 jmp .if5202$end
# ir_jmp .if5202$end;

.if5202$else:
# ir_make_label .if5202$else;

 xor %r10b,%r10b
 movb %r10b,-6(%rbp)
# ir_load L5 0;

.if5202$end:
# ir_make_label .if5202$end;

 movb -6(%rbp),%dil
 call cb__Nio__Nprintln__Abool
# ir_call cb__Nio__Nprintln__Abool L5;

 movl $2,%r10d
 cmp $5,%r10d
 jl .if120$body
# ir_jmp_lt 2 5 .if120$body;

 movl $10,%r10d
 cmp $11,%r10d
 jne .if120$else
# ir_jmp_neq 10 11 .if120$else;

 movl $90,%r10d
 cmp $10,%r10d
 jle .if120$else
# ir_jmp_lte 90 10 .if120$else;

.if120$body:
# ir_make_label .if120$body;

 movb $1,%dil
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

 movl $2,%r10d
 cmp $5,%r10d
 jge .if145$else
# ir_jmp_gte 2 5 .if145$else;

 movl $10,%r10d
 cmp $11,%r10d
 jne .if145$else
# ir_jmp_neq 10 11 .if145$else;

 movl $90,%r10d
 cmp $10,%r10d
 jge .if145$else
# ir_jmp_gte 90 10 .if145$else;

.if145$body:
# ir_make_label .if145$body;

 movb $1,%dil
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
 movb %r10b,-1(%rbp)
# ir_load L0 0;

 movl $2,%r10d
 cmp $5,%r10d
 jle .if5209$else
# ir_jmp_lte 2 5 .if5209$else;

 call cb__Nroot__Nside_effect
# ir_call cb__Nroot__Nside_effect; (push)

 cmp $0,%al
 je .if5209$else
# ir_jmp_eq POP() 0 .if5209$else;

.if5209$body:
# ir_make_label .if5209$body;

 movb $1,%r10b
 movb %r10b,-1(%rbp)
# ir_load L0 1;

 jmp .if5209$end
# ir_jmp .if5209$end;

.if5209$else:
# ir_make_label .if5209$else;

 xor %r10b,%r10b
 movb %r10b,-1(%rbp)
# ir_load L0 0;

.if5209$end:
# ir_make_label .if5209$end;

 movl root__a(%rip),%edi
 call cb__Nio__Nprintln__Aint
# ir_call cb__Nio__Nprintln__Aint ;

 movl $2,%r10d
 cmp $5,%r10d
 jg .if5216$body
# ir_jmp_gt 2 5 .if5216$body;

 call cb__Nroot__Nside_effect
# ir_call cb__Nroot__Nside_effect; (push)

 cmp $0,%al
 je .if5216$else
# ir_jmp_eq POP() 0 .if5216$else;

.if5216$body:
# ir_make_label .if5216$body;

 movb $1,%r10b
 movb %r10b,-1(%rbp)
# ir_load L0 1;

 jmp .if5216$end
# ir_jmp .if5216$end;

.if5216$else:
# ir_make_label .if5216$else;

 xor %r10b,%r10b
 movb %r10b,-1(%rbp)
# ir_load L0 0;

.if5216$end:
# ir_make_label .if5216$end;

 movl root__a(%rip),%edi
 call cb__Nio__Nprintln__Aint
# ir_call cb__Nio__Nprintln__Aint ;

 movl $2,%r10d
 cmp $5,%r10d
 jl .if5223$body
# ir_jmp_lt 2 5 .if5223$body;

 call cb__Nroot__Nside_effect
# ir_call cb__Nroot__Nside_effect; (push)

 cmp $0,%al
 je .if5223$else
# ir_jmp_eq POP() 0 .if5223$else;

.if5223$body:
# ir_make_label .if5223$body;

 movb $1,%r10b
 movb %r10b,-1(%rbp)
# ir_load L0 1;

 jmp .if5223$end
# ir_jmp .if5223$end;

.if5223$else:
# ir_make_label .if5223$else;

 xor %r10b,%r10b
 movb %r10b,-1(%rbp)
# ir_load L0 0;

.if5223$end:
# ir_make_label .if5223$end;

 movl root__a(%rip),%edi
 call cb__Nio__Nprintln__Aint
# ir_call cb__Nio__Nprintln__Aint ;

.cb__Nroot__Nmain$end:
 add $32,%rsp
 pop %rbp
 ret


