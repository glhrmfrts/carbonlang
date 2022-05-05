.global cb__Naoc__Nprint__Aptr__Tslice__Tpure__Tuint8
.global cb__Naoc__Nprint__Aint
.global cb__Naoc__Nprint__Ausize
.global cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8
.global cb__Naoc__Nprintln__Aint
.global cb__Naoc__Nprintln__Ausize
.global cb__Naoc__NallocString__Aptr__Tslice__Tuint8__Ausize
.global cb__Naoc__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize
.global cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8
.global cb__Naoc__NisNumeric__Auint8
.global cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8
.global cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint
.global cb__Naoc__Naoc01
.global cb__Naoc__Nfree__Aptr__Tslice__Tuint8
.global cb__Naoc__Nfree__Aptr__Tslice__Tint
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
    .string "\n"
.cbstr1:
    .string "aoc01_part1.txt"
.cbstr2:
    .string "STAT ERROR"
.cbstr3:
    .string "OPEN ERROR"
.cbstr4:
    .string ""
.cbstr5:
    .string "increase count: "
.cbstr6:
    .string "sum increase count: "
.cbstr7:
    .string "hello world"
.cbstr8:
    .string "Equal"
.cbstr9:
    .string "Not Equal"
.text
cb__Naoc__Nprint__Aptr__Tslice__Tpure__Tuint8:
# func print([]pure uint8): {}
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 push %rdi
 push %rsi
 lea -16(%rbp),%rdi
 lea 0(%rax),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L0 POP() 16;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -16(%rbp),%rax
# ir_load_addr L0; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

cb__Naoc__Nprint__Aptr__Tslice__Tpure__Tuint8$end:
 add $40,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Naoc__Nprint__Aint:
# func print(int): {}
 mov %edi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 call cb__Nstd__Nsystem__Nstdout
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 mov 16(%rbp),%esi
 mov %rax,%rdi
 call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint
# ir_call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint POP() A0;

cb__Naoc__Nprint__Aint$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Naoc__Nprint__Ausize:
# func print(usize): {}
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov 16(%rbp),%r10
 mov %r10d,%eax
# ir_cast A0; (push)

 mov %eax,%edi
 call cb__Naoc__Nprint__Aint
# ir_call cb__Naoc__Nprint__Aint POP();

cb__Naoc__Nprint__Ausize$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8:
# func println([]pure uint8): {}
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $48,%rsp
# prolog end

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 push %rdi
 push %rsi
 lea -16(%rbp),%rdi
 lea 0(%rax),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L0 POP() 16;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -16(%rbp),%rax
# ir_load_addr L0; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

 lea .cbstr0,%rax
# ir_load_addr STR0; (push)

 mov %rax,-32(%rbp)
# ir_load [L1 . 0] POP();

 mov $1,%r10d
 mov %r10,-24(%rbp)
# ir_load [L1 . 1] 1;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -32(%rbp),%rax
# ir_load_addr L1; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8$end:
 add $56,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Naoc__Nprintln__Aint:
# func println(int): {}
 mov %edi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 call cb__Nstd__Nsystem__Nstdout
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 mov 32(%rbp),%esi
 mov %rax,%rdi
 call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint
# ir_call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint POP() A0;

 lea .cbstr0,%rax
# ir_load_addr STR0; (push)

 mov %rax,-16(%rbp)
# ir_load [L0 . 0] POP();

 mov $1,%r10d
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] 1;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -16(%rbp),%rax
# ir_load_addr L0; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

cb__Naoc__Nprintln__Aint$end:
 add $40,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Naoc__Nprintln__Ausize:
# func println(usize): {}
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov 16(%rbp),%r10
 mov %r10d,%eax
# ir_cast A0; (push)

 mov %eax,%edi
 call cb__Naoc__Nprintln__Aint
# ir_call cb__Naoc__Nprintln__Aint POP();

cb__Naoc__Nprintln__Ausize$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Naoc__NallocString__Aptr__Tslice__Tuint8__Ausize:
# func allocString(&[]uint8, usize): &[]uint8
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $64,%rsp
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

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 mov -24(%rbp),%r10
 mov %r10,0(%rax)
# ir_load [POP() . 0] L1;

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 mov 40(%rbp),%r10
 mov %r10,8(%rax)
# ir_load [POP() . 1] A1;

 mov 32(%rbp),%rax
# ir_return A0;

cb__Naoc__NallocString__Aptr__Tslice__Tuint8__Ausize$end:
 add $72,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Naoc__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize:
# func allocIntSlice(&{[]int, error}, usize): &{[]int, error}
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $64,%rsp
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
 je cb__Naoc__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if222$else
# ir_jmp_eq L3 0 cb__Naoc__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if222$else;

cb__Naoc__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if222$body:
# ir_make_label cb__Naoc__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if222$body;

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 lea 0(%rax),%rax
# ir_load_addr [POP() . 0]; (push)

 xor %r10,%r10
 mov %r10,0(%rax)
# ir_load [POP() . 0] 0;

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 lea 0(%rax),%rax
# ir_load_addr [POP() . 0]; (push)

 xor %r10d,%r10d
 mov %r10,8(%rax)
# ir_load [POP() . 1] 0;

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 mov -44(%rbp),%r10d
 mov %r10d,16(%rax)
# ir_load [POP() . 1] L3;

 mov 32(%rbp),%rax
 jmp cb__Naoc__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$end
# ir_return A0;

cb__Naoc__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if222$else:
# ir_make_label cb__Naoc__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if222$else;

 mov -40(%rbp),%r10
 mov %r10,-16(%rbp)
# ir_load [L0 . 0] L2;

 mov 40(%rbp),%r10
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] A1;

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 push %rdi
 push %rsi
 lea 0(%rax),%rdi
 lea -16(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy [POP() . 0] L0 16;

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 xor %r10d,%r10d
 mov %r10d,16(%rax)
# ir_load [POP() . 1] 0;

 mov 32(%rbp),%rax
# ir_return A0;

cb__Naoc__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$end:
 add $72,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8:
# func countLines([]pure uint8): usize
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

cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$cond:
# ir_make_label cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$cond;

 movsxd -12(%rbp),%rax
# ir_cast L1; (push)

 cmp -24(%rbp),%rax
 jge cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$end
# ir_jmp_gte POP() [L2 . 1] cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$end;

cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$body:
# ir_make_label cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$body;

 mov %rdi,%rax
# ir_deref A0; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 movsxd -12(%rbp),%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L1; (push)

 mov (%rax),%r10b
 cmp $10,%r10b
 jne cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8$if298$else
# ir_jmp_neq POP() #10 cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8$if298$else;

cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8$if298$body:
# ir_make_label cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8$if298$body;

 mov -8(%rbp),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add L0 1; (push)

 mov %rax,-8(%rbp)
# ir_load L0 POP();

cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8$if298$else:
# ir_make_label cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8$if298$else;

 mov -12(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L1 1; (push)

 mov %eax,-12(%rbp)
# ir_load L1 POP();

 jmp cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$cond
# ir_jmp cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$cond;

cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$end:
# ir_make_label cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$end;

 mov -8(%rbp),%rax
# ir_return L0;

cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8$end:
 add $32,%rsp
 pop %rbp
 ret


cb__Naoc__NisNumeric__Auint8:
# func isNumeric(uint8): bool
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 cmp $48,%dil
 jl cb__Naoc__NisNumeric__Auint8$if6045$else
# ir_jmp_lt A0 #48 cb__Naoc__NisNumeric__Auint8$if6045$else;

 cmp $57,%dil
 jg cb__Naoc__NisNumeric__Auint8$if6045$else
# ir_jmp_gt A0 #57 cb__Naoc__NisNumeric__Auint8$if6045$else;

cb__Naoc__NisNumeric__Auint8$if6045$body:
# ir_make_label cb__Naoc__NisNumeric__Auint8$if6045$body;

 mov $1,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 1;

 jmp cb__Naoc__NisNumeric__Auint8$if6045$end
# ir_jmp cb__Naoc__NisNumeric__Auint8$if6045$end;

cb__Naoc__NisNumeric__Auint8$if6045$else:
# ir_make_label cb__Naoc__NisNumeric__Auint8$if6045$else;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

cb__Naoc__NisNumeric__Auint8$if6045$end:
# ir_make_label cb__Naoc__NisNumeric__Auint8$if6045$end;

 mov -1(%rbp),%al
# ir_return L0;

cb__Naoc__NisNumeric__Auint8$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8:
# func trimNonNumeric(&[]pure uint8, &[]pure uint8): &[]pure uint8
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $48,%rsp
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

cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$cond:
# ir_make_label cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$cond;

 movsxd -12(%rbp),%rax
# ir_cast L1; (push)

 cmp -24(%rbp),%rax
 jge cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$end
# ir_jmp_gte POP() [L2 . 1] cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$end;

cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$body:
# ir_make_label cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$body;

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 movsxd -12(%rbp),%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L1; (push)

 mov (%rax),%dil
 call cb__Naoc__NisNumeric__Auint8
# ir_call cb__Naoc__NisNumeric__Auint8 POP(); (push)

 cmp $0,%al
 jne cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$else
# ir_jmp_neq POP() 0 cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$else;

cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$body:
# ir_make_label cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$body;

 mov -8(%rbp),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add L0 1; (push)

 mov %rax,-8(%rbp)
# ir_load L0 POP();

 jmp cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$end
# ir_jmp cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$end;

cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$else:
# ir_make_label cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$else;

 jmp cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$end
# ir_jmp cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$end;

cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$end:
# ir_make_label cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$end;

 mov -12(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L1 1; (push)

 mov %eax,-12(%rbp)
# ir_load L1 POP();

 jmp cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$cond
# ir_jmp cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$cond;

cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$end:
# ir_make_label cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$end;

 mov 32(%rbp),%rbx
# ir_deref A0; (push)

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%r10
 add -8(%rbp),%r10
 mov %r10,%rax
# ir_add [POP() . 0] L0; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov 32(%rbp),%rbx
# ir_deref A0; (push)

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

cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$end:
 add $56,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint:
# func parseIntRem(&{int, []pure uint8, bool}, &[]pure uint8, int): &{int, []pure uint8, bool}
 mov %edx,24(%rsp)
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 sub $8,%rsp
 mov %rsp,%rbp
 sub $64,%rsp
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

cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$cond:
# ir_make_label cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$cond;

 movsxd -20(%rbp),%rax
# ir_cast L2; (push)

 cmp -40(%rbp),%rax
 jge cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$end
# ir_jmp_gte POP() [L3 . 1] cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$end;

cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$body:
# ir_make_label cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$body;

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 movsxd -20(%rbp),%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L2; (push)

 mov (%rax),%dil
 call cb__Naoc__NisNumeric__Auint8
# ir_call cb__Naoc__NisNumeric__Auint8 POP(); (push)

 cmp $0,%al
 je cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$else
# ir_jmp_eq POP() 0 cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$else;

cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$body:
# ir_make_label cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$body;

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

 jmp cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$end
# ir_jmp cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$end;

cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$else:
# ir_make_label cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$else;

 jmp cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$end
# ir_jmp cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$end;

cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$end:
# ir_make_label cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$end;

 mov -20(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L2 1; (push)

 mov %eax,-20(%rbp)
# ir_load L2 POP();

 jmp cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$cond
# ir_jmp cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$cond;

cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$end:
# ir_make_label cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$end;

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 mov -4(%rbp),%r10d
 mov %r10d,0(%rax)
# ir_load [POP() . 0] L0;

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 lea 16(%rax),%rbx
# ir_load_addr [POP() . 1]; (push)

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%r10
 add -16(%rbp),%r10
 mov %r10,%rax
# ir_add [POP() . 0] L1; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov 32(%rbp),%rax
# ir_deref A0; (push)

 lea 16(%rax),%rbx
# ir_load_addr [POP() . 1]; (push)

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 8(%rax),%r10
 sub -16(%rbp),%r10
 mov %r10,%rax
# ir_sub [POP() . 1] L1; (push)

 mov %rax,8(%rbx)
# ir_load [POP() . 1] POP();

 mov 32(%rbp),%rbx
# ir_deref A0; (push)

 mov -16(%rbp),%r10
 cmp $0,%r10
 setg %al
# ir_cmp_gt L1 0; (push)

 mov %al,32(%rbx)
# ir_load [POP() . 2] POP();

 mov 32(%rbp),%rax
# ir_return A0;

cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$end:
 add $72,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Naoc__Naoc01:
# func aoc01(): int
 push %rbp
 push %rbx
 push %r12
 push %r13
 sub $8,%rsp
 mov %rsp,%rbp
 sub $848,%rsp
# prolog end

 xor %r10d,%r10d
 mov %r10,-192(%rbp)
# ir_load [L10 . 0] 0;

 xor %r10d,%r10d
 mov %r10,-184(%rbp)
# ir_load [L10 . 1] 0;

 xor %r10d,%r10d
 mov %r10,-176(%rbp)
# ir_load [L10 . 2] 0;

 xor %r10d,%r10d
 mov %r10,-168(%rbp)
# ir_load [L10 . 3] 0;

 xor %r10d,%r10d
 mov %r10d,-160(%rbp)
# ir_load [L10 . 4] 0;

 lea .cbstr1,%rax
# ir_load_addr STR1; (push)

 mov %rax,-368(%rbp)
# ir_load [L19 . 0] POP();

 mov $15,%r10d
 mov %r10,-360(%rbp)
# ir_load [L19 . 1] 15;

 lea -368(%rbp),%rbx
# ir_load_addr L19; (push)

 lea -192(%rbp),%rax
# ir_load_addr L10; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__TStat
# ir_call cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__TStat POP() POP(); (push)

 mov %eax,-16(%rbp)
# ir_load L0 POP();

 mov -260(%rbp),%r10d
 cmp $0,%r10d
 je cb__Naoc__Naoc01$if535$else
# ir_jmp_eq L14 0 cb__Naoc__Naoc01$if535$else;

cb__Naoc__Naoc01$if535$body:
# ir_make_label cb__Naoc__Naoc01$if535$body;

 lea .cbstr2,%rax
# ir_load_addr STR2; (push)

 mov %rax,-592(%rbp)
# ir_load [L33 . 0] POP();

 mov $10,%r10d
 mov %r10,-584(%rbp)
# ir_load [L33 . 1] 10;

 lea -592(%rbp),%rax
# ir_load_addr L33; (push)

 mov %rax,%rdi
 call cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 mov $1,%edi
 call cb__Nstd__Nsystem__Nexit__Aint
# ir_call cb__Nstd__Nsystem__Nexit__Aint 1;

cb__Naoc__Naoc01$if535$else:
# ir_make_label cb__Naoc__Naoc01$if535$else;

 lea .cbstr1,%rax
# ir_load_addr STR1; (push)

 mov %rax,-384(%rbp)
# ir_load [L20 . 0] POP();

 mov $15,%r10d
 mov %r10,-376(%rbp)
# ir_load [L20 . 1] 15;

 lea -336(%rbp),%rbx
# ir_load_addr L17; (push)

 lea -384(%rbp),%rax
# ir_load_addr L20; (push)

 xor %ecx,%ecx
 mov $4,%edx
 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__TFileHandle__Terror__Aptr__Tslice__Tpure__Tuint8__AOpenFlags__Aint
# ir_call cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__TFileHandle__Terror__Aptr__Tslice__Tpure__Tuint8__AOpenFlags__Aint POP() POP() 4 0;

 mov -336(%rbp),%r10
 mov %r10,-344(%rbp)
# ir_load L18 [L17 . 0];

 mov -328(%rbp),%r10d
 mov %r10d,-260(%rbp)
# ir_load L14 [L17 . 1];

 mov -260(%rbp),%r10d
 cmp $0,%r10d
 je cb__Naoc__Naoc01$if562$else
# ir_jmp_eq L14 0 cb__Naoc__Naoc01$if562$else;

cb__Naoc__Naoc01$if562$body:
# ir_make_label cb__Naoc__Naoc01$if562$body;

 lea .cbstr3,%rax
# ir_load_addr STR3; (push)

 mov %rax,-608(%rbp)
# ir_load [L34 . 0] POP();

 mov $10,%r10d
 mov %r10,-600(%rbp)
# ir_load [L34 . 1] 10;

 lea -608(%rbp),%rax
# ir_load_addr L34; (push)

 mov %rax,%rdi
 call cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 mov $1,%edi
 call cb__Nstd__Nsystem__Nexit__Aint
# ir_call cb__Nstd__Nsystem__Nexit__Aint 1;

cb__Naoc__Naoc01$if562$else:
# ir_make_label cb__Naoc__Naoc01$if562$else;

 lea -208(%rbp),%rax
# ir_load_addr L11; (push)

 mov -192(%rbp),%rsi
 mov %rax,%rdi
 call cb__Naoc__NallocString__Aptr__Tslice__Tuint8__Ausize
# ir_call cb__Naoc__NallocString__Aptr__Tslice__Tuint8__Ausize POP() [L10 . 0];

 push %rdi
 push %rsi
 lea -416(%rbp),%rdi
 lea -208(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L22 L11 16;

 lea -416(%rbp),%rax
# ir_load_addr L22; (push)

 mov %rax,%rsi
 mov -344(%rbp),%rdi
 call cb__Nstd__Nsystem__Nread__AFileHandle__Aptr__Tslice__Tuint8
# ir_call cb__Nstd__Nsystem__Nread__AFileHandle__Aptr__Tslice__Tuint8 L18 POP(); (push)

 mov %rax,-200(%rbp)
# ir_load [L11 . 1] POP();

 mov -208(%rbp),%r10
 mov %r10,-16(%rbp)
# ir_load [L0 . 0] [L11 . 0];

 mov -200(%rbp),%r10
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] [L11 . 1];

 lea -240(%rbp),%rbx
# ir_load_addr L12; (push)

 push %rdi
 push %rsi
 lea -432(%rbp),%rdi
 lea -16(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L23 L0 16;

 lea -432(%rbp),%rax
# ir_load_addr L23; (push)

 mov %rax,%rdi
 call cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8 POP(); (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Naoc__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize
# ir_call cb__Naoc__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize POP() POP();

 push %rdi
 push %rsi
 lea -256(%rbp),%rdi
 lea -240(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L13 [L12 . 0] 16;

 mov -224(%rbp),%r10d
 mov %r10d,-260(%rbp)
# ir_load L14 [L12 . 1];

 mov -260(%rbp),%r10d
 cmp $0,%r10d
 je cb__Naoc__Naoc01$if633$else
# ir_jmp_eq L14 0 cb__Naoc__Naoc01$if633$else;

cb__Naoc__Naoc01$if633$body:
# ir_make_label cb__Naoc__Naoc01$if633$body;

 mov $1,%edi
 call cb__Nstd__Nsystem__Nexit__Aint
# ir_call cb__Nstd__Nsystem__Nexit__Aint 1;

cb__Naoc__Naoc01$if633$else:
# ir_make_label cb__Naoc__Naoc01$if633$else;

 lea -304(%rbp),%rbx
# ir_load_addr L15; (push)

 push %rdi
 push %rsi
 lea -464(%rbp),%rdi
 lea -16(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L25 L0 16;

 lea -464(%rbp),%rax
# ir_load_addr L25; (push)

 mov %rax,%rdi
 call cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__NcountLines__Aptr__Tslice__Tpure__Tuint8 POP(); (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Naoc__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize
# ir_call cb__Naoc__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize POP() POP();

 push %rdi
 push %rsi
 lea -320(%rbp),%rdi
 lea -304(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L16 [L15 . 0] 16;

 mov -288(%rbp),%r10d
 mov %r10d,-260(%rbp)
# ir_load L14 [L15 . 1];

 mov -260(%rbp),%r10d
 cmp $0,%r10d
 je cb__Naoc__Naoc01$if662$else
# ir_jmp_eq L14 0 cb__Naoc__Naoc01$if662$else;

cb__Naoc__Naoc01$if662$body:
# ir_make_label cb__Naoc__Naoc01$if662$body;

 mov $1,%edi
 call cb__Nstd__Nsystem__Nexit__Aint
# ir_call cb__Nstd__Nsystem__Nexit__Aint 1;

cb__Naoc__Naoc01$if662$else:
# ir_make_label cb__Naoc__Naoc01$if662$else;

 xor %r10d,%r10d
 mov %r10d,-20(%rbp)
# ir_load L1 0;

cb__Naoc__Naoc01$w721$cond:
# ir_make_label cb__Naoc__Naoc01$w721$cond;

 mov -8(%rbp),%r10
 cmp $0,%r10
 jle cb__Naoc__Naoc01$w721$end
# ir_jmp_lte [L0 . 1] 0 cb__Naoc__Naoc01$w721$end;

cb__Naoc__Naoc01$w721$body:
# ir_make_label cb__Naoc__Naoc01$w721$body;

 push %rdi
 push %rsi
 lea -688(%rbp),%rdi
 lea -16(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L39 L0 16;

 lea -16(%rbp),%rbx
# ir_load_addr L0; (push)

 lea -688(%rbp),%rax
# ir_load_addr L39; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8 POP() POP();

 push %rdi
 push %rsi
 lea -624(%rbp),%rdi
 lea -16(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L35 L0 16;

 lea -736(%rbp),%rbx
# ir_load_addr L40; (push)

 lea -624(%rbp),%rax
# ir_load_addr L35; (push)

 mov $10,%edx
 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint
# ir_call cb__Naoc__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint POP() POP() 10;

 mov -736(%rbp),%r10d
 mov %r10d,-660(%rbp)
# ir_load L38 [L40 . 0];

 push %rdi
 push %rsi
 lea -656(%rbp),%rdi
 lea -720(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L37 [L40 . 1] 16;

 mov -704(%rbp),%r10b
 mov %r10b,-625(%rbp)
# ir_load L36 [L40 . 2];

 push %rdi
 push %rsi
 lea -16(%rbp),%rdi
 lea -656(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L0 L37 16;

 mov -625(%rbp),%r10b
 cmp $0,%r10b
 je cb__Naoc__Naoc01$if718$else
# ir_jmp_eq L36 0 cb__Naoc__Naoc01$if718$else;

cb__Naoc__Naoc01$if718$body:
# ir_make_label cb__Naoc__Naoc01$if718$body;

 mov -256(%rbp),%rax
# ir_deref [L13 . 0]; (push)

 movsxd -20(%rbp),%r10
 lea 0(%rax,%r10,4),%rax
# ir_index POP() L1; (push)

 mov -660(%rbp),%r10d
 mov %r10d,(%rax)
# ir_load POP() L38;

 mov -20(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L1 1; (push)

 mov %eax,-20(%rbp)
# ir_load L1 POP();

 jmp cb__Naoc__Naoc01$if718$end
# ir_jmp cb__Naoc__Naoc01$if718$end;

cb__Naoc__Naoc01$if718$else:
# ir_make_label cb__Naoc__Naoc01$if718$else;

 jmp cb__Naoc__Naoc01$w721$end
# ir_jmp cb__Naoc__Naoc01$w721$end;

cb__Naoc__Naoc01$if718$end:
# ir_make_label cb__Naoc__Naoc01$if718$end;

 jmp cb__Naoc__Naoc01$w721$cond
# ir_jmp cb__Naoc__Naoc01$w721$cond;

cb__Naoc__Naoc01$w721$end:
# ir_make_label cb__Naoc__Naoc01$w721$end;

 xor %r10d,%r10d
 mov %r10d,-24(%rbp)
# ir_load L2 0;

 xor %r10d,%r10d
 mov %r10d,-28(%rbp)
# ir_load L3 0;

 mov $1,%r10d
 mov %r10d,-748(%rbp)
# ir_load [L42 . 0] 1;

 mov -20(%rbp),%r10d
 mov %r10d,-744(%rbp)
# ir_load [L42 . 1] L1;

 mov -748(%rbp),%r10d
 mov %r10d,-740(%rbp)
# ir_load L41 [L42 . 0];

cb__Naoc__Naoc01$f755$cond:
# ir_make_label cb__Naoc__Naoc01$f755$cond;

 mov -740(%rbp),%r10d
 cmp -744(%rbp),%r10d
 jge cb__Naoc__Naoc01$f755$end
# ir_jmp_gte L41 [L42 . 1] cb__Naoc__Naoc01$f755$end;

cb__Naoc__Naoc01$f755$body:
# ir_make_label cb__Naoc__Naoc01$f755$body;

 mov -256(%rbp),%rax
# ir_deref [L13 . 0]; (push)

 movsxd -740(%rbp),%r10
 lea 0(%rax,%r10,4),%rbx
# ir_index POP() L41; (push)

 mov -256(%rbp),%r12
# ir_deref [L13 . 0]; (push)

 mov -740(%rbp),%r10d
 sub $1,%r10d
 mov %r10d,%eax
# ir_sub L41 1; (push)

 movsxd %eax,%r10
 lea 0(%r12,%r10,4),%rax
# ir_index POP() POP(); (push)

 mov (%rbx),%r10d
 cmp (%rax),%r10d
 jle cb__Naoc__Naoc01$if752$else
# ir_jmp_lte POP() POP() cb__Naoc__Naoc01$if752$else;

cb__Naoc__Naoc01$if752$body:
# ir_make_label cb__Naoc__Naoc01$if752$body;

 mov -24(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L2 1; (push)

 mov %eax,-24(%rbp)
# ir_load L2 POP();

cb__Naoc__Naoc01$if752$else:
# ir_make_label cb__Naoc__Naoc01$if752$else;

 mov -740(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L41 1; (push)

 mov %eax,-740(%rbp)
# ir_load L41 POP();

 jmp cb__Naoc__Naoc01$f755$cond
# ir_jmp cb__Naoc__Naoc01$f755$cond;

cb__Naoc__Naoc01$f755$end:
# ir_make_label cb__Naoc__Naoc01$f755$end;

 lea .cbstr4,%rax
# ir_load_addr STR4; (push)

 mov %rax,-496(%rbp)
# ir_load [L27 . 0] POP();

 xor %r10d,%r10d
 mov %r10,-488(%rbp)
# ir_load [L27 . 1] 0;

 lea -496(%rbp),%rax
# ir_load_addr L27; (push)

 mov %rax,%rdi
 call cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 xor %r10d,%r10d
 mov %r10d,-760(%rbp)
# ir_load [L44 . 0] 0;

 mov -20(%rbp),%r10d
 mov %r10d,-756(%rbp)
# ir_load [L44 . 1] L1;

 mov -760(%rbp),%r10d
 mov %r10d,-752(%rbp)
# ir_load L43 [L44 . 0];

cb__Naoc__Naoc01$f797$cond:
# ir_make_label cb__Naoc__Naoc01$f797$cond;

 mov -752(%rbp),%r10d
 cmp -756(%rbp),%r10d
 jge cb__Naoc__Naoc01$f797$end
# ir_jmp_gte L43 [L44 . 1] cb__Naoc__Naoc01$f797$end;

cb__Naoc__Naoc01$f797$body:
# ir_make_label cb__Naoc__Naoc01$f797$body;

 mov -20(%rbp),%r10d
 sub $2,%r10d
 mov %r10d,%eax
# ir_sub L1 2; (push)

 mov -752(%rbp),%r10d
 cmp %eax,%r10d
 jge cb__Naoc__Naoc01$if794$else
# ir_jmp_gte L43 POP() cb__Naoc__Naoc01$if794$else;

cb__Naoc__Naoc01$if794$body:
# ir_make_label cb__Naoc__Naoc01$if794$body;

 mov -320(%rbp),%rax
# ir_deref [L16 . 0]; (push)

 movsxd -752(%rbp),%r10
 lea 0(%rax,%r10,4),%rbx
# ir_index POP() L43; (push)

 mov -256(%rbp),%rax
# ir_deref [L13 . 0]; (push)

 movsxd -752(%rbp),%r10
 lea 0(%rax,%r10,4),%r12
# ir_index POP() L43; (push)

 mov -256(%rbp),%r13
# ir_deref [L13 . 0]; (push)

 mov -752(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L43 1; (push)

 movsxd %eax,%r10
 lea 0(%r13,%r10,4),%rax
# ir_index POP() POP(); (push)

 mov (%r12),%r10d
 add (%rax),%r10d
 mov %r10d,%r12d
# ir_add POP() POP(); (push)

 mov -256(%rbp),%r13
# ir_deref [L13 . 0]; (push)

 mov -752(%rbp),%r10d
 add $2,%r10d
 mov %r10d,%eax
# ir_add L43 2; (push)

 movsxd %eax,%r10
 lea 0(%r13,%r10,4),%rax
# ir_index POP() POP(); (push)

 add (%rax),%r12d
 mov %r12d,%eax
# ir_add POP() POP(); (push)

 mov %eax,(%rbx)
# ir_load POP() POP();

cb__Naoc__Naoc01$if794$else:
# ir_make_label cb__Naoc__Naoc01$if794$else;

 mov -752(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L43 1; (push)

 mov %eax,-752(%rbp)
# ir_load L43 POP();

 jmp cb__Naoc__Naoc01$f797$cond
# ir_jmp cb__Naoc__Naoc01$f797$cond;

cb__Naoc__Naoc01$f797$end:
# ir_make_label cb__Naoc__Naoc01$f797$end;

 mov $1,%r10d
 mov %r10d,-772(%rbp)
# ir_load [L46 . 0] 1;

 mov -20(%rbp),%r10d
 mov %r10d,-768(%rbp)
# ir_load [L46 . 1] L1;

 mov -772(%rbp),%r10d
 mov %r10d,-764(%rbp)
# ir_load L45 [L46 . 0];

cb__Naoc__Naoc01$f822$cond:
# ir_make_label cb__Naoc__Naoc01$f822$cond;

 mov -764(%rbp),%r10d
 cmp -768(%rbp),%r10d
 jge cb__Naoc__Naoc01$f822$end
# ir_jmp_gte L45 [L46 . 1] cb__Naoc__Naoc01$f822$end;

cb__Naoc__Naoc01$f822$body:
# ir_make_label cb__Naoc__Naoc01$f822$body;

 mov -320(%rbp),%rax
# ir_deref [L16 . 0]; (push)

 movsxd -764(%rbp),%r10
 lea 0(%rax,%r10,4),%rbx
# ir_index POP() L45; (push)

 mov -320(%rbp),%r12
# ir_deref [L16 . 0]; (push)

 mov -764(%rbp),%r10d
 sub $1,%r10d
 mov %r10d,%eax
# ir_sub L45 1; (push)

 movsxd %eax,%r10
 lea 0(%r12,%r10,4),%rax
# ir_index POP() POP(); (push)

 mov (%rbx),%r10d
 cmp (%rax),%r10d
 jle cb__Naoc__Naoc01$if819$else
# ir_jmp_lte POP() POP() cb__Naoc__Naoc01$if819$else;

cb__Naoc__Naoc01$if819$body:
# ir_make_label cb__Naoc__Naoc01$if819$body;

 mov -28(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L3 1; (push)

 mov %eax,-28(%rbp)
# ir_load L3 POP();

cb__Naoc__Naoc01$if819$else:
# ir_make_label cb__Naoc__Naoc01$if819$else;

 mov -764(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L45 1; (push)

 mov %eax,-764(%rbp)
# ir_load L45 POP();

 jmp cb__Naoc__Naoc01$f822$cond
# ir_jmp cb__Naoc__Naoc01$f822$cond;

cb__Naoc__Naoc01$f822$end:
# ir_make_label cb__Naoc__Naoc01$f822$end;

 lea .cbstr5,%rax
# ir_load_addr STR5; (push)

 mov %rax,-512(%rbp)
# ir_load [L28 . 0] POP();

 mov $16,%r10d
 mov %r10,-504(%rbp)
# ir_load [L28 . 1] 16;

 lea -512(%rbp),%rax
# ir_load_addr L28; (push)

 mov %rax,%rdi
 call cb__Naoc__Nprint__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__Nprint__Aptr__Tslice__Tpure__Tuint8 POP();

 mov -24(%rbp),%edi
 call cb__Naoc__Nprint__Aint
# ir_call cb__Naoc__Nprint__Aint L2;

 lea .cbstr4,%rax
# ir_load_addr STR4; (push)

 mov %rax,-528(%rbp)
# ir_load [L29 . 0] POP();

 xor %r10d,%r10d
 mov %r10,-520(%rbp)
# ir_load [L29 . 1] 0;

 lea -528(%rbp),%rax
# ir_load_addr L29; (push)

 mov %rax,%rdi
 call cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 lea .cbstr6,%rax
# ir_load_addr STR6; (push)

 mov %rax,-544(%rbp)
# ir_load [L30 . 0] POP();

 mov $20,%r10d
 mov %r10,-536(%rbp)
# ir_load [L30 . 1] 20;

 lea -544(%rbp),%rax
# ir_load_addr L30; (push)

 mov %rax,%rdi
 call cb__Naoc__Nprint__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__Nprint__Aptr__Tslice__Tpure__Tuint8 POP();

 mov -28(%rbp),%edi
 call cb__Naoc__Nprint__Aint
# ir_call cb__Naoc__Nprint__Aint L3;

 lea .cbstr4,%rax
# ir_load_addr STR4; (push)

 mov %rax,-560(%rbp)
# ir_load [L31 . 0] POP();

 xor %r10d,%r10d
 mov %r10,-552(%rbp)
# ir_load [L31 . 1] 0;

 lea -560(%rbp),%rax
# ir_load_addr L31; (push)

 mov %rax,%rdi
 call cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 lea .cbstr7,%rax
# ir_load_addr STR7; (push)

 mov %rax,-144(%rbp)
# ir_load [L9 . 0] POP();

 mov $11,%r10d
 mov %r10,-136(%rbp)
# ir_load [L9 . 1] 11;

 mov -144(%rbp),%rax
# ir_deref [L9 . 0]; (push)

 mov $1,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() 1; (push)

 lea (%rax),%rax
# ir_load_addr POP(); (push)

 mov %rax,-576(%rbp)
# ir_load [L32 . 0] POP();

 mov $10,%r10d
 sub $1,%r10d
 mov %r10d,%eax
# ir_sub 10 1; (push)

 movsxd %eax,%rax
# ir_cast POP(); (push)

 mov %rax,-568(%rbp)
# ir_load [L32 . 1] POP();

 lea -576(%rbp),%rax
# ir_load_addr L32; (push)

 mov %rax,%rdi
 call cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 xor %r10d,%r10d
 mov %r10,-48(%rbp)
# ir_load [L4 . 0] 0;

 xor %r10b,%r10b
 mov %r10b,-40(%rbp)
# ir_load [L4 . 1] 0;

 xor %r10d,%r10d
 mov %r10,-64(%rbp)
# ir_load [L5 . 0] 0;

 mov $1,%r10b
 mov %r10b,-56(%rbp)
# ir_load [L5 . 1] 1;

 movdqa -48(%rbp),%xmm0
 psadbw -64(%rbp),%xmm0
 pshufb .cmp16selector,%xmm0
 movq %xmm0,%r10
 cmp $0,%r10d
 jne cb__Naoc__Naoc01$if913$else
# ir_jmp_neq L4 L5 cb__Naoc__Naoc01$if913$else;

cb__Naoc__Naoc01$if913$body:
# ir_make_label cb__Naoc__Naoc01$if913$body;

 lea .cbstr8,%rax
# ir_load_addr STR8; (push)

 mov %rax,-800(%rbp)
# ir_load [L47 . 0] POP();

 mov $5,%r10d
 mov %r10,-792(%rbp)
# ir_load [L47 . 1] 5;

 lea -800(%rbp),%rax
# ir_load_addr L47; (push)

 mov %rax,%rdi
 call cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 jmp cb__Naoc__Naoc01$if913$end
# ir_jmp cb__Naoc__Naoc01$if913$end;

cb__Naoc__Naoc01$if913$else:
# ir_make_label cb__Naoc__Naoc01$if913$else;

 lea .cbstr9,%rax
# ir_load_addr STR9; (push)

 mov %rax,-816(%rbp)
# ir_load [L48 . 0] POP();

 mov $9,%r10d
 mov %r10,-808(%rbp)
# ir_load [L48 . 1] 9;

 lea -816(%rbp),%rax
# ir_load_addr L48; (push)

 mov %rax,%rdi
 call cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

cb__Naoc__Naoc01$if913$end:
# ir_make_label cb__Naoc__Naoc01$if913$end;

 xor %r10d,%r10d
 mov %r10,-112(%rbp)
# ir_load [L6 . 0] 0;

 xor %r10d,%r10d
 mov %r10,-104(%rbp)
# ir_load [L6 . 1] 0;

 xor %r10d,%r10d
 mov %r10,-96(%rbp)
# ir_load [L6 . 2] 0;

 xor %r10d,%r10d
 mov %r10,-88(%rbp)
# ir_load [L6 . 3] 0;

 xor %r10d,%r10d
 mov %r10,-80(%rbp)
# ir_load [L6 . 4] 0;

 lea -96(%rbp),%rax
# ir_load_addr [L6 . 2]; (push)

 mov %rax,-120(%rbp)
# ir_load L7 POP();

 lea -88(%rbp),%rax
# ir_load_addr [L6 . 3]; (push)

 mov %rax,-128(%rbp)
# ir_load L8 POP();

 mov $48,%rdi
 call cb__Naoc__Nprintln__Aint
# ir_call cb__Naoc__Nprintln__Aint 48;

 mov -128(%rbp),%r10
 sub -120(%rbp),%r10
 mov %r10,%rax
# ir_sub L8 L7; (push)

 mov %rax,%rdi
 call cb__Naoc__Nprintln__Ausize
# ir_call cb__Naoc__Nprintln__Ausize POP();

 push %rdi
 push %rsi
 lea -480(%rbp),%rdi
 lea -320(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L26 L16 16;

 lea -480(%rbp),%rax
# ir_load_addr L26; (push)

 mov %rax,%rdi
 call cb__Naoc__Nfree__Aptr__Tslice__Tint
# ir_call cb__Naoc__Nfree__Aptr__Tslice__Tint POP();

 push %rdi
 push %rsi
 lea -448(%rbp),%rdi
 lea -256(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L24 L13 16;

 lea -448(%rbp),%rax
# ir_load_addr L24; (push)

 mov %rax,%rdi
 call cb__Naoc__Nfree__Aptr__Tslice__Tint
# ir_call cb__Naoc__Nfree__Aptr__Tslice__Tint POP();

 push %rdi
 push %rsi
 lea -400(%rbp),%rdi
 lea -208(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L21 L11 16;

 lea -400(%rbp),%rax
# ir_load_addr L21; (push)

 mov %rax,%rdi
 call cb__Naoc__Nfree__Aptr__Tslice__Tuint8
# ir_call cb__Naoc__Nfree__Aptr__Tslice__Tuint8 POP();

 mov -344(%rbp),%rdi
 call cb__Nstd__Nsystem__Nclose__AFileHandle
# ir_call cb__Nstd__Nsystem__Nclose__AFileHandle L18; (push)

# ir_noop POP();

 mov -24(%rbp),%eax
# ir_return L2;

cb__Naoc__Naoc01$end:
 add $856,%rsp
 pop %r13
 pop %r12
 pop %rbx
 pop %rbp
 ret


cb__Naoc__Nfree__Aptr__Tslice__Tuint8:
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

cb__Naoc__Nfree__Aptr__Tslice__Tuint8$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Naoc__Nfree__Aptr__Tslice__Tint:
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

cb__Naoc__Nfree__Aptr__Tslice__Tint$end:
 add $16,%rsp
 pop %rbp
 ret


