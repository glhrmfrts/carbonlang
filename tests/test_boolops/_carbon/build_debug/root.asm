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
 jge .if4938$else
# ir_jmp_gte 2 5 .if4938$else;

 mov $10,%r10d
 cmp $10,%r10d
 jne .if4938$else
# ir_jmp_neq 10 10 .if4938$else;

.if4938$body:
# ir_make_label .if4938$body;

 mov $1,%r10b
 mov %r10b,-2(%rbp)
# ir_load L1 1;

 jmp .if4938$end
# ir_jmp .if4938$end;

.if4938$else:
# ir_make_label .if4938$else;

 xor %r10b,%r10b
 mov %r10b,-2(%rbp)
# ir_load L1 0;

.if4938$end:
# ir_make_label .if4938$end;

 mov -2(%rbp),%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool L1;

 mov $2,%r10d
 cmp $5,%r10d
 jge .if4959$else
# ir_jmp_gte 2 5 .if4959$else;

 mov $10,%r10d
 cmp $11,%r10d
 jne .if4959$else
# ir_jmp_neq 10 11 .if4959$else;

.if4959$body:
# ir_make_label .if4959$body;

 mov $1,%r10b
 mov %r10b,-3(%rbp)
# ir_load L2 1;

 jmp .if4959$end
# ir_jmp .if4959$end;

.if4959$else:
# ir_make_label .if4959$else;

 xor %r10b,%r10b
 mov %r10b,-3(%rbp)
# ir_load L2 0;

.if4959$end:
# ir_make_label .if4959$end;

 mov -3(%rbp),%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool L2;

 mov $2,%r10d
 cmp $5,%r10d
 jge .if4984$else
# ir_jmp_gte 2 5 .if4984$else;

 mov $10,%r10d
 cmp $11,%r10d
 jne .if4984$else
# ir_jmp_neq 10 11 .if4984$else;

 mov $90,%r10d
 cmp $10,%r10d
 jge .if4984$else
# ir_jmp_gte 90 10 .if4984$else;

.if4984$body:
# ir_make_label .if4984$body;

 mov $1,%r10b
 mov %r10b,-4(%rbp)
# ir_load L3 1;

 jmp .if4984$end
# ir_jmp .if4984$end;

.if4984$else:
# ir_make_label .if4984$else;

 xor %r10b,%r10b
 mov %r10b,-4(%rbp)
# ir_load L3 0;

.if4984$end:
# ir_make_label .if4984$end;

 mov -4(%rbp),%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool L3;

 mov $2,%r10d
 cmp $5,%r10d
 jl .if5005$body
# ir_jmp_lt 2 5 .if5005$body;

 mov $10,%r10d
 cmp $10,%r10d
 jne .if5005$else
# ir_jmp_neq 10 10 .if5005$else;

.if5005$body:
# ir_make_label .if5005$body;

 mov $1,%r10b
 mov %r10b,-5(%rbp)
# ir_load L4 1;

 jmp .if5005$end
# ir_jmp .if5005$end;

.if5005$else:
# ir_make_label .if5005$else;

 xor %r10b,%r10b
 mov %r10b,-5(%rbp)
# ir_load L4 0;

.if5005$end:
# ir_make_label .if5005$end;

 mov -5(%rbp),%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool L4;

 mov $2,%r10d
 cmp $5,%r10d
 jl .if5030$body
# ir_jmp_lt 2 5 .if5030$body;

 mov $10,%r10d
 cmp $11,%r10d
 jne .if5030$else
# ir_jmp_neq 10 11 .if5030$else;

 mov $90,%r10d
 cmp $10,%r10d
 jle .if5030$else
# ir_jmp_lte 90 10 .if5030$else;

.if5030$body:
# ir_make_label .if5030$body;

 mov $1,%r10b
 mov %r10b,-6(%rbp)
# ir_load L5 1;

 jmp .if5030$end
# ir_jmp .if5030$end;

.if5030$else:
# ir_make_label .if5030$else;

 xor %r10b,%r10b
 mov %r10b,-6(%rbp)
# ir_load L5 0;

.if5030$end:
# ir_make_label .if5030$end;

 mov -6(%rbp),%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool L5;

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
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool 1;

 jmp .if120$end
# ir_jmp .if120$end;

.if120$else:
# ir_make_label .if120$else;

 xor %dil,%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool 0;

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
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool 1;

 jmp .if145$end
# ir_jmp .if145$end;

.if145$else:
# ir_make_label .if145$else;

 xor %dil,%dil
 call cb__Nstd__Nio__Nprintln__Abool
# ir_call cb__Nstd__Nio__Nprintln__Abool 0;

.if145$end:
# ir_make_label .if145$end;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

 mov $2,%r10d
 cmp $5,%r10d
 jle .if5037$else
# ir_jmp_lte 2 5 .if5037$else;

 call cb__Nroot__Nside_effect
# ir_call cb__Nroot__Nside_effect; (push)

 cmp $0,%al
 je .if5037$else
# ir_jmp_eq POP() 0 .if5037$else;

.if5037$body:
# ir_make_label .if5037$body;

 mov $1,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 1;

 jmp .if5037$end
# ir_jmp .if5037$end;

.if5037$else:
# ir_make_label .if5037$else;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

.if5037$end:
# ir_make_label .if5037$end;

 mov root__a(%rip),%edi
 call cb__Nstd__Nio__Nprintln__Aint
# ir_call cb__Nstd__Nio__Nprintln__Aint ;

 mov $2,%r10d
 cmp $5,%r10d
 jg .if5044$body
# ir_jmp_gt 2 5 .if5044$body;

 call cb__Nroot__Nside_effect
# ir_call cb__Nroot__Nside_effect; (push)

 cmp $0,%al
 je .if5044$else
# ir_jmp_eq POP() 0 .if5044$else;

.if5044$body:
# ir_make_label .if5044$body;

 mov $1,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 1;

 jmp .if5044$end
# ir_jmp .if5044$end;

.if5044$else:
# ir_make_label .if5044$else;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

.if5044$end:
# ir_make_label .if5044$end;

 mov root__a(%rip),%edi
 call cb__Nstd__Nio__Nprintln__Aint
# ir_call cb__Nstd__Nio__Nprintln__Aint ;

 mov $2,%r10d
 cmp $5,%r10d
 jl .if5051$body
# ir_jmp_lt 2 5 .if5051$body;

 call cb__Nroot__Nside_effect
# ir_call cb__Nroot__Nside_effect; (push)

 cmp $0,%al
 je .if5051$else
# ir_jmp_eq POP() 0 .if5051$else;

.if5051$body:
# ir_make_label .if5051$body;

 mov $1,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 1;

 jmp .if5051$end
# ir_jmp .if5051$end;

.if5051$else:
# ir_make_label .if5051$else;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

.if5051$end:
# ir_make_label .if5051$end;

 mov root__a(%rip),%edi
 call cb__Nstd__Nio__Nprintln__Aint
# ir_call cb__Nstd__Nio__Nprintln__Aint ;

.cb__Nroot__Nmain$end:
 add $32,%rsp
 pop %rbp
 ret


