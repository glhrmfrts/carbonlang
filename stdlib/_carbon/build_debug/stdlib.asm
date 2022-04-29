.global cb__Naoc__Naoc01__Nprint__Aptr__Tslice__Tpure__Tuint8
.global cb__Naoc__Naoc01__Nprint__Aint
.global cb__Naoc__Naoc01__Nprint__Ausize
.global cb__Naoc__Naoc01__Nprintln__Aptr__Tslice__Tpure__Tuint8
.global cb__Naoc__Naoc01__Nprintln__Aint
.global cb__Naoc__Naoc01__Nprintln__Ausize
.global cb__Naoc__Naoc01__NallocString__Aptr__Tslice__Tuint8__Ausize
.global cb__Naoc__Naoc01__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize
.global cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8
.global cb__Naoc__Naoc01__NisNumeric__Auint8
.global cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8
.global cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint
.global cb__Naoc__Naoc01__Naoc01
.global cb__Naoc__Naoc01__Nfree__Aptr__Tslice__Tuint8
.global cb__Naoc__Naoc01__Nfree__Aptr__Tslice__Tint
.global cb__Nstd__Nsystem__Nstdin
.global cb__Nstd__Nsystem__Nstdout
.global cb__Nstd__Nsystem__Nstderr
.global cb__Nstd__Nsystem__Nread__AFileHandle__Aptr__Tslice__Tuint8
.global cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
.global cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque
.global cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize
.global cb__Nstd__Nsystem__Nfree__Aptr__Topaque__Ausize
.global cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags
.global cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__TFileHandle__Terror__Aptr__Tslice__Tpure__Tuint8__AOpenFlags__Aint
.global cb__Nstd__Nsystem__Nexit__Aint
.global cb__Nstd__Nlinux__Nstart__NtestAlloc
.global cb__Nstd__Nlinux__Nstart__NtestMain__Aint
.global cb__Nstd__Nlinux__Nstart__NtestBoolOp
.global __carbon_main
.global cb__Nstd__Nlinux__Nsyscall__Nread__Auint__Aptr__Tuint8__Ausize
.global cb__Nstd__Nlinux__Nsyscall__Nwrite__Auint__Aptr__Tpure__Tuint8__Ausize
.global cb__Nstd__Nlinux__Nsyscall__Nopen__Aptr__Tpure__Tuint8__Aint__Aint16
.global cb__Nstd__Nlinux__Nsyscall__Nclose__Auint
.global cb__Nstd__Nlinux__Nsyscall__Nmmap__Aptr__Topaque__Ausize__Aint__Aint__Aint__Ausize
.global cb__Nstd__Nlinux__Nsyscall__Nmunmap__Aptr__Topaque__Ausize
.global cb__Nstd__Nlinux__Nsyscall__Nexit__Aint
.global cb__Nstd__Nmem__NallocInBlock__Aptr__TBlock__Ausize
.global cb__Nstd__Nmem__Nalign__Ausize__Ausize
.global cb__Nstd__Nmem__Nmemcopy__Aptr__Topaque__Aptr__Tpure__Topaque__Ausize
.global cb__Nstd__Nmem__Nmemset__Aptr__Topaque__Auint8__Ausize
.global cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize
.global cb__Nstd__Nmem__Nfree__Aptr__Topaque
.extern cb__Nstd__Nsystem__Nfdflags__AFileHandle
.extern cb__Nstd__Nsystem__Nclose__AFileHandle
.extern cb__Nstd__Nsystem__Nseek__AFileHandle__Aint64__AWhence
.extern cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__TStat
.extern cb__Nstd__Nsystem__Nstat__AFileHandle__Aptr__TStat
.extern cb__Nstd__Nsystem__Nunlink__Aptr__Tslice__Tpure__Tuint8
.extern cb__Nstd__Nsystem__Nremove__Aptr__Tslice__Tpure__Tuint8
.extern cb__Nstd__Nsystem__Nrename__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8
.extern cb__Nstd__Nsystem__Ncopy__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8
.extern cb__Nstd__Nsystem__Nmkdir__Aptr__Tslice__Tpure__Tuint8
.extern cb__Nstd__Nsystem__Nprocess__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8
.extern cb__Nstd__Nsystem__NmakeThread__Aptr__Ttuple__TThreadHandle__Terror__Afuncptr__Tptr__Topaque__Tvoid__Aptr__Topaque
.extern cb__Nstd__Nsystem__Njoin__AThreadHandle
.extern cb__Nstd__Nsystem__NthreadId
.extern cb__Nstd__Nsystem__NcpuCount
.extern cb__Nstd__Nsystem__NmakeMutex__Aptr__Ttuple__TMutexHandle__Terror
.extern cb__Nstd__Nsystem__Nlock__AMutexHandle
.extern cb__Nstd__Nsystem__Nunlock__AMutexHandle
.extern cb__Nstd__Nsystem__Ndestroy__AMutexHandle
.extern cb__Nstd__Nsystem__NsleepMs__Auint64
.global cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8
.global cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint
.data
    .local std__mem__lastBlock
    .comm std__mem__lastBlock,8,8
.section .rodata
.cbstr0:
    .string "\n"
.cbstr1:
    .string "aoc01_part1.txt"
.cbstr2:
    .string "OPEN ERROR"
.cbstr3:
    .string ""
.cbstr4:
    .string "increase count: "
.cbstr5:
    .string "ALLOC_FAILED\n"
.cbstr6:
    .string "testAlloc: OK\n"
.cbstr7:
    .string ","
.cbstr8:
    .string "I'm going to segfault, ok?\n"
.cbstr9:
    .string "Running aoc01:\n"
.cbstr10:
    .string "AOC01: OK"
.cbstr11:
    .string "std::mem - Growing block fill to "
.cbstr12:
    .string " bytes\n"
.cbstr13:
    .string "std::mem - Allocating block of "
.cbstr14:
    .string "std::mem - Freeing block of "
.cbstr15:
    .string "zyxwvutsrqponmlkjihgfedcba9876543210123456789abcdefghijklmnopqrstuvwxyz"
.text
cb__Naoc__Naoc01__Nprint__Aptr__Tslice__Tpure__Tuint8:
# func print([]pure uint8): {}
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 mov %rsp,%rbp
 sub $40,%rsp
# prolog end

 mov 24(%rbp),%rax
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

cb__Naoc__Naoc01__Nprint__Aptr__Tslice__Tpure__Tuint8$end:
 add $40,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Naoc__Naoc01__Nprint__Aint:
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

cb__Naoc__Naoc01__Nprint__Aint$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Naoc__Naoc01__Nprint__Ausize:
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
 call cb__Naoc__Naoc01__Nprint__Aint
# ir_call cb__Naoc__Naoc01__Nprint__Aint POP();

cb__Naoc__Naoc01__Nprint__Ausize$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Naoc__Naoc01__Nprintln__Aptr__Tslice__Tpure__Tuint8:
# func println([]pure uint8): {}
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 mov %rsp,%rbp
 sub $56,%rsp
# prolog end

 mov 24(%rbp),%rax
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

cb__Naoc__Naoc01__Nprintln__Aptr__Tslice__Tpure__Tuint8$end:
 add $56,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Naoc__Naoc01__Nprintln__Aint:
# func println(int): {}
 mov %edi,8(%rsp)
 push %rbp
 push %rbx
 mov %rsp,%rbp
 sub $40,%rsp
# prolog end

 call cb__Nstd__Nsystem__Nstdout
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 mov 24(%rbp),%esi
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

cb__Naoc__Naoc01__Nprintln__Aint$end:
 add $40,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Naoc__Naoc01__Nprintln__Ausize:
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
 call cb__Naoc__Naoc01__Nprintln__Aint
# ir_call cb__Naoc__Naoc01__Nprintln__Aint POP();

cb__Naoc__Naoc01__Nprintln__Ausize$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Naoc__Naoc01__NallocString__Aptr__Tslice__Tuint8__Ausize:
# func allocString(&[]uint8, usize): &[]uint8
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 mov %rsp,%rbp
 sub $72,%rsp
# prolog end

 lea -16(%rbp),%rbx
# ir_load_addr L0; (push)

 mov 32(%rbp),%r10
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

 mov 32(%rbp),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add A1 1; (push)

 mov %rax,%rdx
 xor %sil,%sil
 mov -24(%rbp),%rdi
 call cb__Nstd__Nmem__Nmemset__Aptr__Topaque__Auint8__Ausize
# ir_call cb__Nstd__Nmem__Nmemset__Aptr__Topaque__Auint8__Ausize L1 0 POP();

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 mov -24(%rbp),%r10
 mov %r10,0(%rax)
# ir_load [POP() . 0] L1;

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 mov 32(%rbp),%r10
 mov %r10,8(%rax)
# ir_load [POP() . 1] A1;

 mov 24(%rbp),%rax
# ir_return A0;

cb__Naoc__Naoc01__NallocString__Aptr__Tslice__Tuint8__Ausize$end:
 add $72,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Naoc__Naoc01__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize:
# func allocIntSlice(&{[]int, error}, usize): &{[]int, error}
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 mov %rsp,%rbp
 sub $72,%rsp
# prolog end

 lea -32(%rbp),%rbx
# ir_load_addr L1; (push)

 mov 32(%rbp),%r10
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
 je cb__Naoc__Naoc01__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if222$else
# ir_jmp_eq L3 0 cb__Naoc__Naoc01__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if222$else;

cb__Naoc__Naoc01__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if222$body:
# ir_make_label cb__Naoc__Naoc01__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if222$body;

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 lea 0(%rax),%rax
# ir_load_addr [POP() . 0]; (push)

 xor %r10,%r10
 mov %r10,0(%rax)
# ir_load [POP() . 0] 0;

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 lea 0(%rax),%rax
# ir_load_addr [POP() . 0]; (push)

 xor %r10d,%r10d
 mov %r10,8(%rax)
# ir_load [POP() . 1] 0;

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 mov -44(%rbp),%r10d
 mov %r10d,16(%rax)
# ir_load [POP() . 1] L3;

 mov 24(%rbp),%rax
 jmp cb__Naoc__Naoc01__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$end
# ir_return A0;

cb__Naoc__Naoc01__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if222$else:
# ir_make_label cb__Naoc__Naoc01__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$if222$else;

 mov -40(%rbp),%r10
 mov %r10,-16(%rbp)
# ir_load [L0 . 0] L2;

 mov 32(%rbp),%r10
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] A1;

 mov 24(%rbp),%rax
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

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 xor %r10d,%r10d
 mov %r10d,16(%rax)
# ir_load [POP() . 1] 0;

 mov 24(%rbp),%rax
# ir_return A0;

cb__Naoc__Naoc01__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize$end:
 add $72,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8:
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
 mov %r10,-28(%rbp)
# ir_load [L2 . 1] [POP() . 1];

 mov -32(%rbp),%r10d
 mov %r10d,-12(%rbp)
# ir_load L1 [L2 . 0];

cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$cond:
# ir_make_label cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$cond;

 movsxd -12(%rbp),%rax
# ir_cast L1; (push)

 cmp -28(%rbp),%rax
 jge cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$end
# ir_jmp_gte POP() [L2 . 1] cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$end;

cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$body:
# ir_make_label cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$body;

 mov %rdi,%rax
# ir_deref A0; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 movsxd -12(%rbp),%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L1; (push)

 mov (%rax),%r10b
 cmp $10,%r10b
 jne cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8$if298$else
# ir_jmp_neq POP() #10 cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8$if298$else;

cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8$if298$body:
# ir_make_label cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8$if298$body;

 mov -8(%rbp),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add L0 1; (push)

 mov %rax,-8(%rbp)
# ir_load L0 POP();

cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8$if298$else:
# ir_make_label cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8$if298$else;

 mov -12(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L1 1; (push)

 mov %eax,-12(%rbp)
# ir_load L1 POP();

 jmp cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$cond
# ir_jmp cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$cond;

cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$end:
# ir_make_label cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8$f301$end;

 mov -8(%rbp),%rax
# ir_return L0;

cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8$end:
 add $32,%rsp
 pop %rbp
 ret


cb__Naoc__Naoc01__NisNumeric__Auint8:
# func isNumeric(uint8): bool
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 cmp $48,%dil
 jl cb__Naoc__Naoc01__NisNumeric__Auint8$if4494$else
# ir_jmp_lt A0 #48 cb__Naoc__Naoc01__NisNumeric__Auint8$if4494$else;

 cmp $57,%dil
 jg cb__Naoc__Naoc01__NisNumeric__Auint8$if4494$else
# ir_jmp_gt A0 #57 cb__Naoc__Naoc01__NisNumeric__Auint8$if4494$else;

cb__Naoc__Naoc01__NisNumeric__Auint8$if4494$body:
# ir_make_label cb__Naoc__Naoc01__NisNumeric__Auint8$if4494$body;

 mov $1,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 1;

 jmp cb__Naoc__Naoc01__NisNumeric__Auint8$if4494$end
# ir_jmp cb__Naoc__Naoc01__NisNumeric__Auint8$if4494$end;

cb__Naoc__Naoc01__NisNumeric__Auint8$if4494$else:
# ir_make_label cb__Naoc__Naoc01__NisNumeric__Auint8$if4494$else;

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

cb__Naoc__Naoc01__NisNumeric__Auint8$if4494$end:
# ir_make_label cb__Naoc__Naoc01__NisNumeric__Auint8$if4494$end;

 mov -1(%rbp),%al
# ir_return L0;

cb__Naoc__Naoc01__NisNumeric__Auint8$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8:
# func trimNonNumeric(&[]pure uint8, &[]pure uint8): &[]pure uint8
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 mov %rsp,%rbp
 sub $56,%rsp
# prolog end

 xor %r10,%r10
 mov %r10,-8(%rbp)
# ir_load L0 0;

 xor %r10d,%r10d
 mov %r10d,-32(%rbp)
# ir_load [L2 . 0] 0;

 mov 32(%rbp),%rax
# ir_deref A1; (push)

 mov 8(%rax),%r10
 mov %r10,-28(%rbp)
# ir_load [L2 . 1] [POP() . 1];

 mov -32(%rbp),%r10d
 mov %r10d,-12(%rbp)
# ir_load L1 [L2 . 0];

cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$cond:
# ir_make_label cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$cond;

 movsxd -12(%rbp),%rax
# ir_cast L1; (push)

 cmp -28(%rbp),%rax
 jge cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$end
# ir_jmp_gte POP() [L2 . 1] cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$end;

cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$body:
# ir_make_label cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$body;

 mov 32(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 movsxd -12(%rbp),%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L1; (push)

 mov (%rax),%dil
 call cb__Naoc__Naoc01__NisNumeric__Auint8
# ir_call cb__Naoc__Naoc01__NisNumeric__Auint8 POP(); (push)

 cmp $0,%al
 jne cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$else
# ir_jmp_neq POP() 0 cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$else;

cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$body:
# ir_make_label cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$body;

 mov -8(%rbp),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add L0 1; (push)

 mov %rax,-8(%rbp)
# ir_load L0 POP();

 jmp cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$end
# ir_jmp cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$end;

cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$else:
# ir_make_label cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$else;

 jmp cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$end
# ir_jmp cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$end;

cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$end:
# ir_make_label cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if372$end;

 mov -12(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L1 1; (push)

 mov %eax,-12(%rbp)
# ir_load L1 POP();

 jmp cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$cond
# ir_jmp cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$cond;

cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$end:
# ir_make_label cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$f375$end;

 mov 24(%rbp),%rbx
# ir_deref A0; (push)

 mov 32(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%r10
 add -8(%rbp),%r10
 mov %r10,%rax
# ir_add [POP() . 0] L0; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov 24(%rbp),%rbx
# ir_deref A0; (push)

 mov 32(%rbp),%rax
# ir_deref A1; (push)

 mov 8(%rax),%r10
 sub -8(%rbp),%r10
 mov %r10,%rax
# ir_sub [POP() . 1] L0; (push)

 mov %rax,8(%rbx)
# ir_load [POP() . 1] POP();

 mov 24(%rbp),%rax
# ir_return A0;

cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$end:
 add $56,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint:
# func parseIntRem(&{int, []pure uint8, bool}, &[]pure uint8, int): &{int, []pure uint8, bool}
 mov %edx,24(%rsp)
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 mov %rsp,%rbp
 sub $72,%rsp
# prolog end

 xor %r10d,%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 0;

 xor %r10,%r10
 mov %r10,-16(%rbp)
# ir_load L1 0;

 xor %r10d,%r10d
 mov %r10d,-40(%rbp)
# ir_load [L3 . 0] 0;

 mov 32(%rbp),%rax
# ir_deref A1; (push)

 mov 8(%rax),%r10
 mov %r10,-36(%rbp)
# ir_load [L3 . 1] [POP() . 1];

 mov -40(%rbp),%r10d
 mov %r10d,-20(%rbp)
# ir_load L2 [L3 . 0];

cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$cond:
# ir_make_label cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$cond;

 movsxd -20(%rbp),%rax
# ir_cast L2; (push)

 cmp -36(%rbp),%rax
 jge cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$end
# ir_jmp_gte POP() [L3 . 1] cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$end;

cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$body:
# ir_make_label cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$body;

 mov 32(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%rax
# ir_deref [POP() . 0]; (push)

 movsxd -20(%rbp),%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L2; (push)

 mov (%rax),%dil
 call cb__Naoc__Naoc01__NisNumeric__Auint8
# ir_call cb__Naoc__Naoc01__NisNumeric__Auint8 POP(); (push)

 cmp $0,%al
 je cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$else
# ir_jmp_eq POP() 0 cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$else;

cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$body:
# ir_make_label cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$body;

 mov -4(%rbp),%r10d
 imul 40(%rbp),%r10d
 mov %r10d,%ebx
# ir_mul L0 A2; (push)

 mov 32(%rbp),%rax
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

 jmp cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$end
# ir_jmp cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$end;

cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$else:
# ir_make_label cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$else;

 jmp cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$end
# ir_jmp cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$end;

cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$end:
# ir_make_label cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if470$end;

 mov -20(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L2 1; (push)

 mov %eax,-20(%rbp)
# ir_load L2 POP();

 jmp cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$cond
# ir_jmp cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$cond;

cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$end:
# ir_make_label cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f473$end;

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 mov -4(%rbp),%r10d
 mov %r10d,0(%rax)
# ir_load [POP() . 0] L0;

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 lea 4(%rax),%rbx
# ir_load_addr [POP() . 1]; (push)

 mov 32(%rbp),%rax
# ir_deref A1; (push)

 mov 0(%rax),%r10
 add -16(%rbp),%r10
 mov %r10,%rax
# ir_add [POP() . 0] L1; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 lea 4(%rax),%rbx
# ir_load_addr [POP() . 1]; (push)

 mov 32(%rbp),%rax
# ir_deref A1; (push)

 mov 8(%rax),%r10
 sub -16(%rbp),%r10
 mov %r10,%rax
# ir_sub [POP() . 1] L1; (push)

 mov %rax,8(%rbx)
# ir_load [POP() . 1] POP();

 mov 24(%rbp),%rbx
# ir_deref A0; (push)

 mov -16(%rbp),%r10
 cmp $0,%r10
 setg %al
# ir_cmp_gt L1 0; (push)

 mov %al,24(%rbx)
# ir_load [POP() . 2] POP();

 mov 24(%rbp),%rax
# ir_return A0;

cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$end:
 add $72,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Naoc__Naoc01__Naoc01:
# func aoc01(): int
 push %rbp
 push %rbx
 push %r12
 mov %rsp,%rbp
 sub $400,%rsp
# prolog end

 lea .cbstr1,%rax
# ir_load_addr STR1; (push)

 mov %rax,-128(%rbp)
# ir_load [L9 . 0] POP();

 mov $15,%r10d
 mov %r10,-120(%rbp)
# ir_load [L9 . 1] 15;

 lea -104(%rbp),%rbx
# ir_load_addr L7; (push)

 lea -128(%rbp),%rax
# ir_load_addr L9; (push)

 xor %ecx,%ecx
 mov $4,%edx
 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__TFileHandle__Terror__Aptr__Tslice__Tpure__Tuint8__AOpenFlags__Aint
# ir_call cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__TFileHandle__Terror__Aptr__Tslice__Tpure__Tuint8__AOpenFlags__Aint POP() POP() 4 0;

 mov -104(%rbp),%r10
 mov %r10,-112(%rbp)
# ir_load L8 [L7 . 0];

 mov -96(%rbp),%r10d
 mov %r10d,-84(%rbp)
# ir_load L6 [L7 . 1];

 mov -84(%rbp),%r10d
 cmp $0,%r10d
 je cb__Naoc__Naoc01__Naoc01$if531$else
# ir_jmp_eq L6 0 cb__Naoc__Naoc01__Naoc01$if531$else;

cb__Naoc__Naoc01__Naoc01$if531$body:
# ir_make_label cb__Naoc__Naoc01__Naoc01$if531$body;

 lea .cbstr2,%rax
# ir_load_addr STR2; (push)

 mov %rax,-256(%rbp)
# ir_load [L17 . 0] POP();

 mov $10,%r10d
 mov %r10,-248(%rbp)
# ir_load [L17 . 1] 10;

 lea -256(%rbp),%rax
# ir_load_addr L17; (push)

 mov %rax,%rdi
 call cb__Naoc__Naoc01__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__Naoc01__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 mov $1,%edi
 call cb__Nstd__Nsystem__Nexit__Aint
# ir_call cb__Nstd__Nsystem__Nexit__Aint 1;

cb__Naoc__Naoc01__Naoc01$if531$else:
# ir_make_label cb__Naoc__Naoc01__Naoc01$if531$else;

 lea -40(%rbp),%rbx
# ir_load_addr L3; (push)

 mov $16,%r10d
 imul $1024,%r10d
 mov %r10d,%eax
# ir_mul 16 1024; (push)

 movsxd %eax,%rax
# ir_cast POP(); (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Naoc__Naoc01__NallocString__Aptr__Tslice__Tuint8__Ausize
# ir_call cb__Naoc__Naoc01__NallocString__Aptr__Tslice__Tuint8__Ausize POP() POP();

 push %rdi
 push %rsi
 lea -160(%rbp),%rdi
 lea -40(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L11 L3 16;

 lea -160(%rbp),%rax
# ir_load_addr L11; (push)

 mov %rax,%rsi
 mov -112(%rbp),%rdi
 call cb__Nstd__Nsystem__Nread__AFileHandle__Aptr__Tslice__Tuint8
# ir_call cb__Nstd__Nsystem__Nread__AFileHandle__Aptr__Tslice__Tuint8 L8 POP(); (push)

 mov %rax,-32(%rbp)
# ir_load [L3 . 1] POP();

 mov -40(%rbp),%r10
 mov %r10,-16(%rbp)
# ir_load [L0 . 0] [L3 . 0];

 mov -32(%rbp),%r10
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] [L3 . 1];

 lea -64(%rbp),%rbx
# ir_load_addr L4; (push)

 push %rdi
 push %rsi
 lea -176(%rbp),%rdi
 lea -16(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L12 L0 16;

 lea -176(%rbp),%rax
# ir_load_addr L12; (push)

 mov %rax,%rdi
 call cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__Naoc01__NcountLines__Aptr__Tslice__Tpure__Tuint8 POP(); (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Naoc__Naoc01__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize
# ir_call cb__Naoc__Naoc01__NallocIntSlice__Aptr__Ttuple__Tslice__Tint__Terror__Ausize POP() POP();

 push %rdi
 push %rsi
 lea -80(%rbp),%rdi
 lea -64(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L5 [L4 . 0] 16;

 mov -48(%rbp),%r10d
 mov %r10d,-84(%rbp)
# ir_load L6 [L4 . 1];

 mov -84(%rbp),%r10d
 cmp $0,%r10d
 je cb__Naoc__Naoc01__Naoc01$if596$else
# ir_jmp_eq L6 0 cb__Naoc__Naoc01__Naoc01$if596$else;

cb__Naoc__Naoc01__Naoc01$if596$body:
# ir_make_label cb__Naoc__Naoc01__Naoc01$if596$body;

 mov $1,%edi
 call cb__Nstd__Nsystem__Nexit__Aint
# ir_call cb__Nstd__Nsystem__Nexit__Aint 1;

cb__Naoc__Naoc01__Naoc01$if596$else:
# ir_make_label cb__Naoc__Naoc01__Naoc01$if596$else;

 xor %r10d,%r10d
 mov %r10d,-20(%rbp)
# ir_load L1 0;

cb__Naoc__Naoc01__Naoc01$w655$cond:
# ir_make_label cb__Naoc__Naoc01__Naoc01$w655$cond;

 mov -8(%rbp),%r10
 cmp $0,%r10
 jle cb__Naoc__Naoc01__Naoc01$w655$end
# ir_jmp_lte [L0 . 1] 0 cb__Naoc__Naoc01__Naoc01$w655$end;

cb__Naoc__Naoc01__Naoc01$w655$body:
# ir_make_label cb__Naoc__Naoc01__Naoc01$w655$body;

 push %rdi
 push %rsi
 lea -288(%rbp),%rdi
 lea -16(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L19 L0 16;

 lea -16(%rbp),%rbx
# ir_load_addr L0; (push)

 lea -288(%rbp),%rax
# ir_load_addr L19; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__Naoc01__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8 POP() POP();

 push %rdi
 push %rsi
 lea -272(%rbp),%rdi
 lea -16(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L18 L0 16;

 lea -352(%rbp),%rbx
# ir_load_addr L23; (push)

 lea -272(%rbp),%rax
# ir_load_addr L18; (push)

 mov $10,%edx
 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint
# ir_call cb__Naoc__Naoc01__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint POP() POP() 10;

 mov -352(%rbp),%r10d
 mov %r10d,-316(%rbp)
# ir_load L22 [L23 . 0];

 push %rdi
 push %rsi
 lea -312(%rbp),%rdi
 lea -348(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L21 [L23 . 1] 16;

 mov -328(%rbp),%r10b
 mov %r10b,-289(%rbp)
# ir_load L20 [L23 . 2];

 push %rdi
 push %rsi
 lea -16(%rbp),%rdi
 lea -312(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L0 L21 16;

 mov -289(%rbp),%r10b
 cmp $0,%r10b
 je cb__Naoc__Naoc01__Naoc01$if652$else
# ir_jmp_eq L20 0 cb__Naoc__Naoc01__Naoc01$if652$else;

cb__Naoc__Naoc01__Naoc01$if652$body:
# ir_make_label cb__Naoc__Naoc01__Naoc01$if652$body;

 mov -80(%rbp),%rax
# ir_deref [L5 . 0]; (push)

 movsxd -20(%rbp),%r10
 lea 0(%rax,%r10,4),%rax
# ir_index POP() L1; (push)

 mov -316(%rbp),%r10d
 mov %r10d,(%rax)
# ir_load POP() L22;

 mov -20(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L1 1; (push)

 mov %eax,-20(%rbp)
# ir_load L1 POP();

 jmp cb__Naoc__Naoc01__Naoc01$if652$end
# ir_jmp cb__Naoc__Naoc01__Naoc01$if652$end;

cb__Naoc__Naoc01__Naoc01$if652$else:
# ir_make_label cb__Naoc__Naoc01__Naoc01$if652$else;

 jmp cb__Naoc__Naoc01__Naoc01$w655$end
# ir_jmp cb__Naoc__Naoc01__Naoc01$w655$end;

cb__Naoc__Naoc01__Naoc01$if652$end:
# ir_make_label cb__Naoc__Naoc01__Naoc01$if652$end;

 jmp cb__Naoc__Naoc01__Naoc01$w655$cond
# ir_jmp cb__Naoc__Naoc01__Naoc01$w655$cond;

cb__Naoc__Naoc01__Naoc01$w655$end:
# ir_make_label cb__Naoc__Naoc01__Naoc01$w655$end;

 xor %r10d,%r10d
 mov %r10d,-24(%rbp)
# ir_load L2 0;

 mov $1,%r10d
 mov %r10d,-364(%rbp)
# ir_load [L25 . 0] 1;

 mov -20(%rbp),%r10d
 mov %r10d,-360(%rbp)
# ir_load [L25 . 1] L1;

 mov -364(%rbp),%r10d
 mov %r10d,-356(%rbp)
# ir_load L24 [L25 . 0];

cb__Naoc__Naoc01__Naoc01$f685$cond:
# ir_make_label cb__Naoc__Naoc01__Naoc01$f685$cond;

 mov -356(%rbp),%r10d
 cmp -360(%rbp),%r10d
 jge cb__Naoc__Naoc01__Naoc01$f685$end
# ir_jmp_gte L24 [L25 . 1] cb__Naoc__Naoc01__Naoc01$f685$end;

cb__Naoc__Naoc01__Naoc01$f685$body:
# ir_make_label cb__Naoc__Naoc01__Naoc01$f685$body;

 mov -80(%rbp),%rax
# ir_deref [L5 . 0]; (push)

 movsxd -356(%rbp),%r10
 lea 0(%rax,%r10,4),%rbx
# ir_index POP() L24; (push)

 mov -80(%rbp),%r12
# ir_deref [L5 . 0]; (push)

 mov -356(%rbp),%r10d
 sub $1,%r10d
 mov %r10d,%eax
# ir_sub L24 1; (push)

 movsxd %eax,%r10
 lea 0(%r12,%r10,4),%rax
# ir_index POP() POP(); (push)

 mov (%rbx),%r10d
 cmp (%rax),%r10d
 jle cb__Naoc__Naoc01__Naoc01$if682$else
# ir_jmp_lte POP() POP() cb__Naoc__Naoc01__Naoc01$if682$else;

cb__Naoc__Naoc01__Naoc01$if682$body:
# ir_make_label cb__Naoc__Naoc01__Naoc01$if682$body;

 mov -24(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L2 1; (push)

 mov %eax,-24(%rbp)
# ir_load L2 POP();

cb__Naoc__Naoc01__Naoc01$if682$else:
# ir_make_label cb__Naoc__Naoc01__Naoc01$if682$else;

 mov -356(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L24 1; (push)

 mov %eax,-356(%rbp)
# ir_load L24 POP();

 jmp cb__Naoc__Naoc01__Naoc01$f685$cond
# ir_jmp cb__Naoc__Naoc01__Naoc01$f685$cond;

cb__Naoc__Naoc01__Naoc01$f685$end:
# ir_make_label cb__Naoc__Naoc01__Naoc01$f685$end;

 lea .cbstr3,%rax
# ir_load_addr STR3; (push)

 mov %rax,-208(%rbp)
# ir_load [L14 . 0] POP();

 xor %r10d,%r10d
 mov %r10,-200(%rbp)
# ir_load [L14 . 1] 0;

 lea -208(%rbp),%rax
# ir_load_addr L14; (push)

 mov %rax,%rdi
 call cb__Naoc__Naoc01__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__Naoc01__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 lea .cbstr4,%rax
# ir_load_addr STR4; (push)

 mov %rax,-224(%rbp)
# ir_load [L15 . 0] POP();

 mov $16,%r10d
 mov %r10,-216(%rbp)
# ir_load [L15 . 1] 16;

 lea -224(%rbp),%rax
# ir_load_addr L15; (push)

 mov %rax,%rdi
 call cb__Naoc__Naoc01__Nprint__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__Naoc01__Nprint__Aptr__Tslice__Tpure__Tuint8 POP();

 mov -24(%rbp),%edi
 call cb__Naoc__Naoc01__Nprint__Aint
# ir_call cb__Naoc__Naoc01__Nprint__Aint L2;

 lea .cbstr3,%rax
# ir_load_addr STR3; (push)

 mov %rax,-240(%rbp)
# ir_load [L16 . 0] POP();

 xor %r10d,%r10d
 mov %r10,-232(%rbp)
# ir_load [L16 . 1] 0;

 lea -240(%rbp),%rax
# ir_load_addr L16; (push)

 mov %rax,%rdi
 call cb__Naoc__Naoc01__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__Naoc01__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

 push %rdi
 push %rsi
 lea -192(%rbp),%rdi
 lea -80(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L13 L5 16;

 lea -192(%rbp),%rax
# ir_load_addr L13; (push)

 mov %rax,%rdi
 call cb__Naoc__Naoc01__Nfree__Aptr__Tslice__Tint
# ir_call cb__Naoc__Naoc01__Nfree__Aptr__Tslice__Tint POP();

 push %rdi
 push %rsi
 lea -144(%rbp),%rdi
 lea -40(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L10 L3 16;

 lea -144(%rbp),%rax
# ir_load_addr L10; (push)

 mov %rax,%rdi
 call cb__Naoc__Naoc01__Nfree__Aptr__Tslice__Tuint8
# ir_call cb__Naoc__Naoc01__Nfree__Aptr__Tslice__Tuint8 POP();

 mov -24(%rbp),%eax
# ir_return L2;

cb__Naoc__Naoc01__Naoc01$end:
 add $400,%rsp
 pop %r12
 pop %rbx
 pop %rbp
 ret


cb__Naoc__Naoc01__Nfree__Aptr__Tslice__Tuint8:
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

cb__Naoc__Naoc01__Nfree__Aptr__Tslice__Tuint8$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Naoc__Naoc01__Nfree__Aptr__Tslice__Tint:
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

cb__Naoc__Naoc01__Nfree__Aptr__Tslice__Tint$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nstd__Nsystem__Nstdin:
# func stdin(): FileHandle
 sub $8,%rsp
# prolog end

 xor %rax,%rax
# ir_return 0;

cb__Nstd__Nsystem__Nstdin$end:
 add $8,%rsp
 ret


cb__Nstd__Nsystem__Nstdout:
# func stdout(): FileHandle
 sub $8,%rsp
# prolog end

 mov $1,%rax
# ir_return 1;

cb__Nstd__Nsystem__Nstdout$end:
 add $8,%rsp
 ret


cb__Nstd__Nsystem__Nstderr:
# func stderr(): FileHandle
 sub $8,%rsp
# prolog end

 mov $2,%rax
# ir_return 2;

cb__Nstd__Nsystem__Nstderr$end:
 add $8,%rsp
 ret


cb__Nstd__Nsystem__Nread__AFileHandle__Aptr__Tslice__Tuint8:
# func read(FileHandle, []uint8): isize
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 push %r12
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 mov 32(%rbp),%r10
 mov %r10d,%ebx
# ir_cast A0; (push)

 mov 40(%rbp),%r12
# ir_deref A1; (push)

# ir_stack_dup; (push)

 mov 8(%r12),%rdx
 mov 0(%r12),%rsi
 mov %ebx,%edi
 call cb__Nstd__Nlinux__Nsyscall__Nread__Auint__Aptr__Tuint8__Ausize
# ir_call cb__Nstd__Nlinux__Nsyscall__Nread__Auint__Aptr__Tuint8__Ausize POP() [POP() . 0] [POP() . 1];

cb__Nstd__Nsystem__Nread__AFileHandle__Aptr__Tslice__Tuint8$end:
 add $32,%rsp
 pop %r12
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8:
# func write(FileHandle, []pure uint8): isize
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 push %r12
 mov %rsp,%rbp
 sub $32,%rsp
# prolog end

 mov 32(%rbp),%r10
 mov %r10d,%ebx
# ir_cast A0; (push)

 mov 40(%rbp),%r12
# ir_deref A1; (push)

# ir_stack_dup; (push)

 mov 8(%r12),%rdx
 mov 0(%r12),%rsi
 mov %ebx,%edi
 call cb__Nstd__Nlinux__Nsyscall__Nwrite__Auint__Aptr__Tpure__Tuint8__Ausize
# ir_call cb__Nstd__Nlinux__Nsyscall__Nwrite__Auint__Aptr__Tpure__Tuint8__Ausize POP() [POP() . 0] [POP() . 1];

cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8$end:
 add $32,%rsp
 pop %r12
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque:
# func alloc(&{&opaque, error}, usize, &opaque): &{&opaque, error}
 mov %rdx,24(%rsp)
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 mov %rsp,%rbp
 sub $72,%rsp
# prolog end

 mov 40(%rbp),%r10
 mov %r10,-8(%rbp)
# ir_load L0 A2;

 mov -8(%rbp),%rbx
# ir_deref L0; (push)

# ir_stack_dup; (push)

 xor %r9d,%r9d
 xor %r8d,%r8d
 mov 4(%rbx),%ecx
 mov 0(%rbx),%edx
 mov 32(%rbp),%rsi
 xor %rdi,%rdi
 call cb__Nstd__Nlinux__Nsyscall__Nmmap__Aptr__Topaque__Ausize__Aint__Aint__Aint__Ausize
# ir_call cb__Nstd__Nlinux__Nsyscall__Nmmap__Aptr__Topaque__Ausize__Aint__Aint__Aint__Ausize 0 A1 [POP() . 0] [POP() . 1] 0 0; (push)

 mov %rax,-16(%rbp)
# ir_load L1 POP();

 mov $1,%eax
 neg %eax
# ir_neg 1; (push)

 movsxd %eax,%rax
# ir_cast POP(); (push)

 mov -16(%rbp),%r10
 cmp %rax,%r10
 jne cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque$if1144$else
# ir_jmp_neq L1 POP() cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque$if1144$else;

cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque$if1144$body:
# ir_make_label cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque$if1144$body;

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 xor %r10,%r10
 mov %r10,0(%rax)
# ir_load [POP() . 0] 0;

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 mov $1304468645,%r10d
 mov %r10d,8(%rax)
# ir_load [POP() . 1] 1304468645;

 mov 24(%rbp),%rax
 jmp cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque$end
# ir_return A0;

cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque$if1144$else:
# ir_make_label cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque$if1144$else;

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 mov -16(%rbp),%r10
 mov %r10,0(%rax)
# ir_load [POP() . 0] L1;

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 xor %r10d,%r10d
 mov %r10d,8(%rax)
# ir_load [POP() . 1] 0;

 mov 24(%rbp),%rax
# ir_return A0;

cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque$end:
 add $72,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize:
# func alloc(&{&opaque, error}, usize): &{&opaque, error}
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 push %r12
 mov %rsp,%rbp
 sub $64,%rsp
# prolog end

 xor %r10d,%r10d
 mov %r10d,-8(%rbp)
# ir_load [L0 . 0] 0;

 xor %r10d,%r10d
 mov %r10d,-4(%rbp)
# ir_load [L0 . 1] 0;

 mov $1,%r10d
 or $2,%r10d
 mov %r10d,%eax
# ir_or 1 2; (push)

 mov %eax,-8(%rbp)
# ir_load [L0 . 0] POP();

 mov $2,%r10d
 or $32,%r10d
 mov %r10d,%eax
# ir_or 2 32; (push)

 mov %eax,-4(%rbp)
# ir_load [L0 . 1] POP();

 mov 32(%rbp),%rbx
# ir_deref A0; (push)

 lea -24(%rbp),%r12
# ir_load_addr L1; (push)

 lea -8(%rbp),%rax
# ir_load_addr L0; (push)

 mov %rax,%rdx
 mov 40(%rbp),%rsi
 mov %r12,%rdi
 call cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque
# ir_call cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque POP() A1 POP();

 push %rdi
 push %rsi
 lea 0(%rbx),%rdi
 lea -24(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy POP() L1 16;

 mov 32(%rbp),%rax
# ir_return A0;

cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$end:
 add $64,%rsp
 pop %r12
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nsystem__Nfree__Aptr__Topaque__Ausize:
# func free(&opaque, usize): {}
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov 24(%rbp),%rsi
 mov 16(%rbp),%rdi
 call cb__Nstd__Nlinux__Nsyscall__Nmunmap__Aptr__Topaque__Ausize
# ir_call cb__Nstd__Nlinux__Nsyscall__Nmunmap__Aptr__Topaque__Ausize A0 A1;

cb__Nstd__Nsystem__Nfree__Aptr__Topaque__Ausize$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags:
# func toKernelFlags(OpenFlags): int
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 xor %r10d,%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 0;

 mov $2,%r10d
 or $4,%r10d
 mov %r10d,%eax
# ir_or 2 4; (push)

 and %eax,%edi
 mov %edi,%eax
# ir_and A0 POP(); (push)

 cmp $0,%eax
 je cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1361$else
# ir_jmp_eq POP() 0 cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1361$else;

cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1361$body:
# ir_make_label cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1361$body;

 mov $2,%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 2;

 jmp cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1361$end
# ir_jmp cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1361$end;

cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1361$else:
# ir_make_label cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1361$else;

 and $2,%edi
 mov %edi,%eax
# ir_and A0 2; (push)

 cmp $0,%eax
 je cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1360$else
# ir_jmp_eq POP() 0 cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1360$else;

cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1360$body:
# ir_make_label cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1360$body;

 mov $1,%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 1;

 jmp cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1360$end
# ir_jmp cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1360$end;

cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1360$else:
# ir_make_label cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1360$else;

 and $4,%edi
 mov %edi,%eax
# ir_and A0 4; (push)

 cmp $0,%eax
 je cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1359$else
# ir_jmp_eq POP() 0 cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1359$else;

cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1359$body:
# ir_make_label cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1359$body;

 xor %r10d,%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 0;

cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1359$else:
# ir_make_label cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1359$else;

cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1360$end:
# ir_make_label cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1360$end;

cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1361$end:
# ir_make_label cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1361$end;

 and $1,%edi
 mov %edi,%eax
# ir_and A0 1; (push)

 cmp $0,%eax
 je cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1371$else
# ir_jmp_eq POP() 0 cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1371$else;

cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1371$body:
# ir_make_label cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1371$body;

 mov -4(%rbp),%r10d
 or $64,%r10d
 mov %r10d,%eax
# ir_or L0 64; (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1371$else:
# ir_make_label cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1371$else;

 and $8,%edi
 mov %edi,%eax
# ir_and A0 8; (push)

 cmp $0,%eax
 je cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1381$else
# ir_jmp_eq POP() 0 cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1381$else;

cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1381$body:
# ir_make_label cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1381$body;

 mov -4(%rbp),%r10d
 or $1024,%r10d
 mov %r10d,%eax
# ir_or L0 1024; (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1381$else:
# ir_make_label cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1381$else;

 and $16,%edi
 mov %edi,%eax
# ir_and A0 16; (push)

 cmp $0,%eax
 je cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1391$else
# ir_jmp_eq POP() 0 cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1391$else;

cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1391$body:
# ir_make_label cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1391$body;

 mov -4(%rbp),%r10d
 or $512,%r10d
 mov %r10d,%eax
# ir_or L0 512; (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1391$else:
# ir_make_label cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$if1391$else;

 mov -4(%rbp),%eax
# ir_return L0;

cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__TFileHandle__Terror__Aptr__Tslice__Tpure__Tuint8__AOpenFlags__Aint:
# func open(&{FileHandle, error}, &[]pure uint8, OpenFlags, int): &{FileHandle, error}
 mov %ecx,32(%rsp)
 mov %edx,24(%rsp)
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 mov %rsp,%rbp
 sub $56,%rsp
# prolog end

 mov 40(%rbp),%edi
 call cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags
# ir_call cb__Nstd__Nlinux__Nopen__NtoKernelFlags__AOpenFlags A2; (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

 mov 32(%rbp),%rbx
# ir_deref A1; (push)

 mov 48(%rbp),%r10d
 mov %r10w,%ax
# ir_cast A3; (push)

 mov %ax,%dx
 mov -4(%rbp),%esi
 mov 0(%rbx),%rdi
 call cb__Nstd__Nlinux__Nsyscall__Nopen__Aptr__Tpure__Tuint8__Aint__Aint16
# ir_call cb__Nstd__Nlinux__Nsyscall__Nopen__Aptr__Tpure__Tuint8__Aint__Aint16 [POP() . 0] L0 POP(); (push)

 mov %eax,-8(%rbp)
# ir_load L1 POP();

 mov 24(%rbp),%rbx
# ir_deref A0; (push)

 movsxd -8(%rbp),%rax
# ir_cast L1; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 xor %r10d,%r10d
 mov %r10d,8(%rax)
# ir_load [POP() . 1] 0;

 mov 24(%rbp),%rax
# ir_return A0;

cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__TFileHandle__Terror__Aptr__Tslice__Tpure__Tuint8__AOpenFlags__Aint$end:
 add $56,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nsystem__Nexit__Aint:
# func exit(int): {}
 mov %edi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov 16(%rbp),%edi
 call cb__Nstd__Nlinux__Nsyscall__Nexit__Aint
# ir_call cb__Nstd__Nlinux__Nsyscall__Nexit__Aint A0;

cb__Nstd__Nsystem__Nexit__Aint$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nstd__Nlinux__Nstart__NtestAlloc:
# func testAlloc(): {}
 push %rbp
 push %rbx
 mov %rsp,%rbp
 sub $88,%rsp
# prolog end

 lea -16(%rbp),%rax
# ir_load_addr L0; (push)

 mov $16,%esi
 mov %rax,%rdi
 call cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize
# ir_call cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize POP() 16;

 mov -16(%rbp),%r10
 mov %r10,-24(%rbp)
# ir_load L1 [L0 . 0];

 mov -8(%rbp),%r10d
 mov %r10d,-28(%rbp)
# ir_load L2 [L0 . 1];

 mov -28(%rbp),%r10d
 cmp $0,%r10d
 je cb__Nstd__Nlinux__Nstart__NtestAlloc$if1525$else
# ir_jmp_eq L2 0 cb__Nstd__Nlinux__Nstart__NtestAlloc$if1525$else;

cb__Nstd__Nlinux__Nstart__NtestAlloc$if1525$body:
# ir_make_label cb__Nstd__Nlinux__Nstart__NtestAlloc$if1525$body;

 lea .cbstr5,%rax
# ir_load_addr STR5; (push)

 mov %rax,-64(%rbp)
# ir_load [L4 . 0] POP();

 mov $13,%r10d
 mov %r10,-56(%rbp)
# ir_load [L4 . 1] 13;

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

 jmp cb__Nstd__Nlinux__Nstart__NtestAlloc$end
# ir_return #0;

cb__Nstd__Nlinux__Nstart__NtestAlloc$if1525$else:
# ir_make_label cb__Nstd__Nlinux__Nstart__NtestAlloc$if1525$else;

 lea .cbstr6,%rax
# ir_load_addr STR6; (push)

 mov %rax,-48(%rbp)
# ir_load [L3 . 0] POP();

 mov $14,%r10d
 mov %r10,-40(%rbp)
# ir_load [L3 . 1] 14;

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

 mov -24(%rbp),%rdi
 call cb__Nstd__Nmem__Nfree__Aptr__Topaque
# ir_call cb__Nstd__Nmem__Nfree__Aptr__Topaque L1;

cb__Nstd__Nlinux__Nstart__NtestAlloc$end:
 add $88,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nlinux__Nstart__NtestMain__Aint:
# func testMain(int): {}
 mov %edi,8(%rsp)
 push %rbp
 push %rbx
 push %r12
 push %r13
 mov %rsp,%rbp
 sub $200,%rsp
# prolog end

 mov $1,%eax
 neg %eax
# ir_neg 1; (push)

 movsxd %eax,%rax
# ir_cast POP(); (push)

 mov %rax,-8(%rbp)
# ir_load L0 POP();

 lea -48(%rbp),%rbx
# ir_load_addr L3; (push)

 mov $10,%rax
# ir_cast 10; (push)

 imul $4,%rax
# ir_mul POP() 4; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize
# ir_call cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize POP() POP();

 mov -48(%rbp),%r10
 mov %r10,-56(%rbp)
# ir_load L4 [L3 . 0];

 mov -40(%rbp),%r10d
 mov %r10d,-60(%rbp)
# ir_load L5 [L3 . 1];

 mov -60(%rbp),%r10d
 cmp $0,%r10d
 je cb__Nstd__Nlinux__Nstart__NtestMain__Aint$if1588$else
# ir_jmp_eq L5 0 cb__Nstd__Nlinux__Nstart__NtestMain__Aint$if1588$else;

cb__Nstd__Nlinux__Nstart__NtestMain__Aint$if1588$body:
# ir_make_label cb__Nstd__Nlinux__Nstart__NtestMain__Aint$if1588$body;

 mov $1,%edi
 call cb__Nstd__Nsystem__Nexit__Aint
# ir_call cb__Nstd__Nsystem__Nexit__Aint 1;

cb__Nstd__Nlinux__Nstart__NtestMain__Aint$if1588$else:
# ir_make_label cb__Nstd__Nlinux__Nstart__NtestMain__Aint$if1588$else;

 call cb__Nstd__Nsystem__Nstdout
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 mov $1412312,%esi
 mov %rax,%rdi
 call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint
# ir_call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint POP() 1412312;

 lea .cbstr0,%rax
# ir_load_addr STR0; (push)

 mov %rax,-80(%rbp)
# ir_load [L6 . 0] POP();

 mov $1,%r10d
 mov %r10,-72(%rbp)
# ir_load [L6 . 1] 1;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -80(%rbp),%rax
# ir_load_addr L6; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 mov -56(%rbp),%r10
 mov %r10d,%eax
# ir_cast L4; (push)

 mov %eax,%esi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint
# ir_call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint POP() POP();

 lea .cbstr0,%rax
# ir_load_addr STR0; (push)

 mov %rax,-96(%rbp)
# ir_load [L7 . 0] POP();

 mov $1,%r10d
 mov %r10,-88(%rbp)
# ir_load [L7 . 1] 1;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -96(%rbp),%rax
# ir_load_addr L7; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

 mov -56(%rbp),%r10
 mov %r10,-24(%rbp)
# ir_load [L1 . 0] L4;

 mov $10,%rax
# ir_cast 10; (push)

 mov %rax,-16(%rbp)
# ir_load [L1 . 1] POP();

 mov -24(%rbp),%rax
# ir_deref [L1 . 0]; (push)

 xor %r10,%r10
 lea 0(%rax,%r10,4),%rax
# ir_index POP() 0; (push)

 xor %r10d,%r10d
 mov %r10d,(%rax)
# ir_load POP() 0;

 mov -24(%rbp),%rax
# ir_deref [L1 . 0]; (push)

 mov $1,%r10
 lea 0(%rax,%r10,4),%rax
# ir_index POP() 1; (push)

 mov $1,%r10d
 mov %r10d,(%rax)
# ir_load POP() 1;

 mov $2,%r10d
 mov %r10d,-140(%rbp)
# ir_load [L11 . 0] 2;

 mov $10,%r10d
 mov %r10d,-136(%rbp)
# ir_load [L11 . 1] 10;

 mov -140(%rbp),%r10d
 mov %r10d,-132(%rbp)
# ir_load L10 [L11 . 0];

cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1679$cond:
# ir_make_label cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1679$cond;

 mov -132(%rbp),%r10d
 cmp -136(%rbp),%r10d
 jge cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1679$end
# ir_jmp_gte L10 [L11 . 1] cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1679$end;

cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1679$body:
# ir_make_label cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1679$body;

 mov -24(%rbp),%rax
# ir_deref [L1 . 0]; (push)

 movsxd -132(%rbp),%r10
 lea 0(%rax,%r10,4),%rbx
# ir_index POP() L10; (push)

 mov -24(%rbp),%r12
# ir_deref [L1 . 0]; (push)

 mov -132(%rbp),%r10d
 sub $1,%r10d
 mov %r10d,%eax
# ir_sub L10 1; (push)

 movsxd %eax,%r10
 lea 0(%r12,%r10,4),%r12
# ir_index POP() POP(); (push)

 mov -24(%rbp),%r13
# ir_deref [L1 . 0]; (push)

 mov -132(%rbp),%r10d
 sub $2,%r10d
 mov %r10d,%eax
# ir_sub L10 2; (push)

 movsxd %eax,%r10
 lea 0(%r13,%r10,4),%rax
# ir_index POP() POP(); (push)

 mov (%r12),%r10d
 add (%rax),%r10d
 mov %r10d,%eax
# ir_add POP() POP(); (push)

 mov %eax,(%rbx)
# ir_load POP() POP();

 mov -132(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L10 1; (push)

 mov %eax,-132(%rbp)
# ir_load L10 POP();

 jmp cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1679$cond
# ir_jmp cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1679$cond;

cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1679$end:
# ir_make_label cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1679$end;

 xor %r10d,%r10d
 mov %r10d,-152(%rbp)
# ir_load [L13 . 0] 0;

 mov $10,%r10d
 mov %r10d,-148(%rbp)
# ir_load [L13 . 1] 10;

 mov -152(%rbp),%r10d
 mov %r10d,-144(%rbp)
# ir_load L12 [L13 . 0];

cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1706$cond:
# ir_make_label cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1706$cond;

 mov -144(%rbp),%r10d
 cmp -148(%rbp),%r10d
 jge cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1706$end
# ir_jmp_gte L12 [L13 . 1] cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1706$end;

cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1706$body:
# ir_make_label cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1706$body;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 mov -24(%rbp),%rax
# ir_deref [L1 . 0]; (push)

 movsxd -144(%rbp),%r10
 lea 0(%rax,%r10,4),%rax
# ir_index POP() L12; (push)

 mov (%rax),%esi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint
# ir_call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint POP() POP();

 lea .cbstr7,%rax
# ir_load_addr STR7; (push)

 mov %rax,-168(%rbp)
# ir_load [L14 . 0] POP();

 mov $1,%r10d
 mov %r10,-160(%rbp)
# ir_load [L14 . 1] 1;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -168(%rbp),%rax
# ir_load_addr L14; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

 mov -144(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L12 1; (push)

 mov %eax,-144(%rbp)
# ir_load L12 POP();

 jmp cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1706$cond
# ir_jmp cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1706$cond;

cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1706$end:
# ir_make_label cb__Nstd__Nlinux__Nstart__NtestMain__Aint$f1706$end;

 lea .cbstr0,%rax
# ir_load_addr STR0; (push)

 mov %rax,-112(%rbp)
# ir_load [L8 . 0] POP();

 mov $1,%r10d
 mov %r10,-104(%rbp)
# ir_load [L8 . 1] 1;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -112(%rbp),%rax
# ir_load_addr L8; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

 call cb__Nstd__Nlinux__Nstart__NtestAlloc
# ir_call cb__Nstd__Nlinux__Nstart__NtestAlloc;

 mov -56(%rbp),%rdi
 call cb__Nstd__Nmem__Nfree__Aptr__Topaque
# ir_call cb__Nstd__Nmem__Nfree__Aptr__Topaque L4;

 lea .cbstr8,%rax
# ir_load_addr STR8; (push)

 mov %rax,-128(%rbp)
# ir_load [L9 . 0] POP();

 mov $27,%r10d
 mov %r10,-120(%rbp)
# ir_load [L9 . 1] 27;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -128(%rbp),%rax
# ir_load_addr L9; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

 mov -24(%rbp),%rax
# ir_deref [L1 . 0]; (push)

 xor %r10,%r10
 lea 0(%rax,%r10,4),%rax
# ir_index POP() 0; (push)

 mov (%rax),%r10d
 mov %r10d,-28(%rbp)
# ir_load L2 POP();

 mov 40(%rbp),%edi
 call cb__Nstd__Nsystem__Nexit__Aint
# ir_call cb__Nstd__Nsystem__Nexit__Aint A0;

cb__Nstd__Nlinux__Nstart__NtestMain__Aint$end:
 add $200,%rsp
 pop %r13
 pop %r12
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nlinux__Nstart__NtestBoolOp:
# func testBoolOp(): bool
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 xor %r10d,%r10d
 mov %r10d,-4(%rbp)
# ir_load L0 0;

 mov -4(%rbp),%r10d
 cmp $0,%r10d
 setg %al
# ir_cmp_gt L0 0; (push)

 mov %al,-5(%rbp)
# ir_load L1 POP();

 xor %al,%al
# ir_return 0;

cb__Nstd__Nlinux__Nstart__NtestBoolOp$end:
 add $16,%rsp
 pop %rbp
 ret


__carbon_main:
# func __carbon_main(int, &&pure uint8): {}
 mov %rsi,16(%rsp)
 mov %edi,8(%rsp)
 push %rbp
 push %rbx
 mov %rsp,%rbp
 sub $72,%rsp
# prolog end

 lea .cbstr9,%rax
# ir_load_addr STR9; (push)

 mov %rax,-24(%rbp)
# ir_load [L1 . 0] POP();

 mov $15,%r10d
 mov %r10,-16(%rbp)
# ir_load [L1 . 1] 15;

 call cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -24(%rbp),%rax
# ir_load_addr L1; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

 call cb__Naoc__Naoc01__Naoc01
# ir_call cb__Naoc__Naoc01__Naoc01; (push)

 mov %eax,-4(%rbp)
# ir_load L0 POP();

 mov -4(%rbp),%r10d
 cmp $1832,%r10d
 jne __carbon_main$if1804$else
# ir_jmp_neq L0 1832 __carbon_main$if1804$else;

__carbon_main$if1804$body:
# ir_make_label __carbon_main$if1804$body;

 lea .cbstr10,%rax
# ir_load_addr STR10; (push)

 mov %rax,-40(%rbp)
# ir_load [L2 . 0] POP();

 mov $9,%r10d
 mov %r10,-32(%rbp)
# ir_load [L2 . 1] 9;

 lea -40(%rbp),%rax
# ir_load_addr L2; (push)

 mov %rax,%rdi
 call cb__Naoc__Naoc01__Nprintln__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Naoc__Naoc01__Nprintln__Aptr__Tslice__Tpure__Tuint8 POP();

__carbon_main$if1804$else:
# ir_make_label __carbon_main$if1804$else;

 xor %edi,%edi
 call cb__Nstd__Nsystem__Nexit__Aint
# ir_call cb__Nstd__Nsystem__Nexit__Aint 0;

__carbon_main$end:
 add $72,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nlinux__Nsyscall__Nread__Auint__Aptr__Tuint8__Ausize:
# func read(uint, &uint8, usize): {}
 push %rbp
 mov %rsp,%rbp
# prolog end


    mov $0, %rax            # system call 0 is read
                            # file handle is already in rdi
                            # data is already in rsi
                            # number of bytes is already in rdx
    syscall


cb__Nstd__Nlinux__Nsyscall__Nread__Auint__Aptr__Tuint8__Ausize$end:
 pop %rbp
 ret


cb__Nstd__Nlinux__Nsyscall__Nwrite__Auint__Aptr__Tpure__Tuint8__Ausize:
# func write(uint, &pure uint8, usize): {}
 push %rbp
 mov %rsp,%rbp
# prolog end


    mov $1, %rax            # system call 1 is write
                            # file handle is already in rdi
                            # data is already in rsi
                            # number of bytes is already in rdx
    syscall


cb__Nstd__Nlinux__Nsyscall__Nwrite__Auint__Aptr__Tpure__Tuint8__Ausize$end:
 pop %rbp
 ret


cb__Nstd__Nlinux__Nsyscall__Nopen__Aptr__Tpure__Tuint8__Aint__Aint16:
# func open(&pure uint8, int, int16): int
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov $2, %rax
    syscall

cb__Nstd__Nlinux__Nsyscall__Nopen__Aptr__Tpure__Tuint8__Aint__Aint16$end:
 pop %rbp
 ret


cb__Nstd__Nlinux__Nsyscall__Nclose__Auint:
# func close(uint): {}
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov $3, %rax
    syscall

cb__Nstd__Nlinux__Nsyscall__Nclose__Auint$end:
 pop %rbp
 ret


cb__Nstd__Nlinux__Nsyscall__Nmmap__Aptr__Topaque__Ausize__Aint__Aint__Aint__Ausize:
# func mmap(&opaque, usize, int, int, int, usize): &opaque
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov $9, %rax
    mov %rcx, %r10
    syscall

cb__Nstd__Nlinux__Nsyscall__Nmmap__Aptr__Topaque__Ausize__Aint__Aint__Aint__Ausize$end:
 pop %rbp
 ret


cb__Nstd__Nlinux__Nsyscall__Nmunmap__Aptr__Topaque__Ausize:
# func munmap(&opaque, usize): {}
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov $0xB, %rax
    syscall

cb__Nstd__Nlinux__Nsyscall__Nmunmap__Aptr__Topaque__Ausize$end:
 pop %rbp
 ret


cb__Nstd__Nlinux__Nsyscall__Nexit__Aint:
# func exit(int): {}
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov $60, %rax           # system call 60 is exit
                            # code is already in rdi
    syscall

cb__Nstd__Nlinux__Nsyscall__Nexit__Aint$end:
 pop %rbp
 ret


cb__Nstd__Nmem__NallocInBlock__Aptr__TBlock__Ausize:
# func allocInBlock(&Block, usize): &opaque
 mov %rsi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 push %rbx
 mov %rsp,%rbp
 sub $72,%rsp
# prolog end

 mov 24(%rbp),%r10
 add $32,%r10
 mov %r10,%rax
# ir_add A0 32; (push)

 mov %rax,-8(%rbp)
# ir_load L0 POP();

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 mov -8(%rbp),%r10
 add 0(%rax),%r10
 mov %r10,%rax
# ir_add L0 [POP() . 0]; (push)

 mov %rax,-16(%rbp)
# ir_load L1 POP();

 mov 24(%rbp),%rbx
# ir_deref A0; (push)

# ir_stack_dup; (push)

 mov 0(%rbx),%r10
 add 32(%rbp),%r10
 mov %r10,%rax
# ir_add [POP() . 0] A1; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov 24(%rbp),%rbx
# ir_deref A0; (push)

# ir_stack_dup; (push)

 mov 16(%rbx),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add [POP() . 2] 1; (push)

 mov %rax,16(%rbx)
# ir_load [POP() . 2] POP();

 lea .cbstr11,%rax
# ir_load_addr STR11; (push)

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

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 mov 0(%rax),%r10
 mov %r10d,%eax
# ir_cast [POP() . 0]; (push)

 mov %eax,%esi
 mov %rbx,%rdi
 call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint
# ir_call cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint POP() POP();

 lea .cbstr12,%rax
# ir_load_addr STR12; (push)

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
 mov %rsp,%rbp
 sub $8,%rsp
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
 mov %rsp,%rbp
 sub $136,%rsp
# prolog end

 mov $16,%rsi
 mov 32(%rbp),%rdi
 call cb__Nstd__Nmem__Nalign__Ausize__Ausize
# ir_call cb__Nstd__Nmem__Nalign__Ausize__Ausize A1 16; (push)

 mov %rax,-24(%rbp)
# ir_load L2 POP();

 mov std__mem__lastBlock,%r10
 mov %r10,-8(%rbp)
# ir_load L0 ;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w2426$cond:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w2426$cond;

 mov -8(%rbp),%r10
 cmp $0,%r10
 je cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w2426$end
# ir_jmp_eq L0 0 cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w2426$end;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w2426$body:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w2426$body;

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov 0(%rax),%r10
 add -24(%rbp),%r10
 mov %r10,%rbx
# ir_add [POP() . 0] L2; (push)

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 cmp 8(%rax),%rbx
 jge cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2417$else
# ir_jmp_gte POP() [POP() . 1] cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2417$else;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2417$body:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2417$body;

 jmp cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w2426$end
# ir_jmp cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w2426$end;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2417$else:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2417$else;

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov 24(%rax),%r10
 mov %r10,-8(%rbp)
# ir_load L0 [POP() . 3];

 jmp cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w2426$cond
# ir_jmp cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w2426$cond;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w2426$end:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$w2426$end;

 mov -8(%rbp),%r10
 cmp $0,%r10
 je cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2442$else
# ir_jmp_eq L0 0 cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2442$else;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2442$body:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2442$body;

 mov 24(%rbp),%rbx
# ir_deref A0; (push)

 mov -24(%rbp),%rsi
 mov -8(%rbp),%rdi
 call cb__Nstd__Nmem__NallocInBlock__Aptr__TBlock__Ausize
# ir_call cb__Nstd__Nmem__NallocInBlock__Aptr__TBlock__Ausize L0 L2; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 xor %r10d,%r10d
 mov %r10d,8(%rax)
# ir_load [POP() . 1] 0;

 mov 24(%rbp),%rax
 jmp cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$end
# ir_return A0;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2442$else:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2442$else;

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
 je cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2476$else
# ir_jmp_eq L6 0 cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2476$else;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2476$body:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2476$body;

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 xor %r10,%r10
 mov %r10,0(%rax)
# ir_load [POP() . 0] 0;

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 mov -60(%rbp),%r10d
 mov %r10d,8(%rax)
# ir_load [POP() . 1] L6;

 mov 24(%rbp),%rax
 jmp cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$end
# ir_return A0;

cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2476$else:
# ir_make_label cb__Nstd__Nmem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$if2476$else;

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

 lea .cbstr13,%rax
# ir_load_addr STR13; (push)

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

 lea .cbstr12,%rax
# ir_load_addr STR12; (push)

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

 mov 24(%rbp),%rbx
# ir_deref A0; (push)

 mov -24(%rbp),%rsi
 mov -16(%rbp),%rdi
 call cb__Nstd__Nmem__NallocInBlock__Aptr__TBlock__Ausize
# ir_call cb__Nstd__Nmem__NallocInBlock__Aptr__TBlock__Ausize L1 L2; (push)

 mov %rax,0(%rbx)
# ir_load [POP() . 0] POP();

 mov 24(%rbp),%rax
# ir_deref A0; (push)

 xor %r10d,%r10d
 mov %r10d,8(%rax)
# ir_load [POP() . 1] 0;

 mov 24(%rbp),%rax
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
 mov %rsp,%rbp
 sub $72,%rsp
# prolog end

 mov std__mem__lastBlock,%r10
 mov %r10,-8(%rbp)
# ir_load L0 ;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$w2612$cond:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$w2612$cond;

 mov -8(%rbp),%r10
 cmp $0,%r10
 je cb__Nstd__Nmem__Nfree__Aptr__Topaque$w2612$end
# ir_jmp_eq L0 0 cb__Nstd__Nmem__Nfree__Aptr__Topaque$w2612$end;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$w2612$body:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$w2612$body;

 mov -8(%rbp),%r10
 add $32,%r10
 mov %r10,%rax
# ir_add L0 32; (push)

 mov %rax,-16(%rbp)
# ir_load L1 POP();

 mov 24(%rbp),%r10
 cmp -16(%rbp),%r10
 jl cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2603$else
# ir_jmp_lt A0 L1 cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2603$else;

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov -16(%rbp),%r10
 add 8(%rax),%r10
 mov %r10,%rax
# ir_add L1 [POP() . 1]; (push)

 mov 24(%rbp),%r10
 cmp %rax,%r10
 jge cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2603$else
# ir_jmp_gte A0 POP() cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2603$else;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2603$body:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2603$body;

 jmp cb__Nstd__Nmem__Nfree__Aptr__Topaque$w2612$end
# ir_jmp cb__Nstd__Nmem__Nfree__Aptr__Topaque$w2612$end;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2603$else:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2603$else;

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov 24(%rax),%r10
 mov %r10,-8(%rbp)
# ir_load L0 [POP() . 3];

 jmp cb__Nstd__Nmem__Nfree__Aptr__Topaque$w2612$cond
# ir_jmp cb__Nstd__Nmem__Nfree__Aptr__Topaque$w2612$cond;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$w2612$end:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$w2612$end;

 mov -8(%rbp),%r10
 cmp $0,%r10
 jne cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2620$else
# ir_jmp_neq L0 0 cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2620$else;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2620$body:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2620$body;

 jmp cb__Nstd__Nmem__Nfree__Aptr__Topaque$end
# ir_return #0;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2620$else:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2620$else;

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
 jne cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2677$else
# ir_jmp_neq [POP() . 2] 0 cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2677$else;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2677$body:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2677$body;

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov 24(%rax),%r10
 mov %r10,std__mem__lastBlock
# ir_load  [POP() . 3];

 lea .cbstr14,%rax
# ir_load_addr STR14; (push)

 mov %rax,-48(%rbp)
# ir_load [L3 . 0] POP();

 mov $28,%r10d
 mov %r10,-40(%rbp)
# ir_load [L3 . 1] 28;

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

 lea .cbstr12,%rax
# ir_load_addr STR12; (push)

 mov %rax,-32(%rbp)
# ir_load [L2 . 0] POP();

 mov $7,%r10d
 mov %r10,-24(%rbp)
# ir_load [L2 . 1] 7;

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

 mov -8(%rbp),%rax
# ir_deref L0; (push)

 mov 8(%rax),%rsi
 mov -8(%rbp),%rdi
 call cb__Nstd__Nsystem__Nfree__Aptr__Topaque__Ausize
# ir_call cb__Nstd__Nsystem__Nfree__Aptr__Topaque__Ausize L0 [POP() . 1];

cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2677$else:
# ir_make_label cb__Nstd__Nmem__Nfree__Aptr__Topaque$if2677$else;

cb__Nstd__Nmem__Nfree__Aptr__Topaque$end:
 add $72,%rsp
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8:
# func intToString(int, int, []uint8): int
 mov %rdx,24(%rsp)
 mov %esi,16(%rsp)
 mov %edi,8(%rsp)
 push %rbp
 push %rbx
 push %r12
 mov %rsp,%rbp
 sub $80,%rsp
# prolog end

 mov 40(%rbp),%r10d
 cmp $2,%r10d
 jl cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3244$body
# ir_jmp_lt A1 2 cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3244$body;

 mov 40(%rbp),%r10d
 cmp $36,%r10d
 jle cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3244$else
# ir_jmp_lte A1 36 cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3244$else;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3244$body:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3244$body;

 xor %eax,%eax
 jmp cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$end
# ir_return 0;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3244$else:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3244$else;

 mov 48(%rbp),%rax
# ir_deref A2; (push)

 push %rdi
 push %rsi
 lea -16(%rbp),%rdi
 lea 0(%rax),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L0 POP() 16;

 lea .cbstr15,%rax
# ir_load_addr STR15; (push)

 mov %rax,-72(%rbp)
# ir_load [L7 . 0] POP();

 mov $71,%r10d
 mov %r10,-64(%rbp)
# ir_load [L7 . 1] 71;

 mov 32(%rbp),%r10d
 mov %r10d,-20(%rbp)
# ir_load L1 A0;

 xor %r10d,%r10d
 mov %r10d,-24(%rbp)
# ir_load L2 0;

 mov $1,%eax
 neg %eax
# ir_neg 1; (push)

 mov %eax,-28(%rbp)
# ir_load L3 POP();

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3320$cond:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3320$cond;

 mov -28(%rbp),%r10d
 cmp $0,%r10d
 je cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3320$end
# ir_jmp_eq L3 0 cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3320$end;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3320$body:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3320$body;

 movsxd -24(%rbp),%rax
# ir_cast L2; (push)

 cmp -8(%rbp),%rax
 jl cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3285$else
# ir_jmp_lt POP() [L0 . 1] cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3285$else;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3285$body:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3285$body;

 mov -24(%rbp),%r10d
 sub $1,%r10d
 mov %r10d,%eax
# ir_sub L2 1; (push)

 mov %eax,-24(%rbp)
# ir_load L2 POP();

 jmp cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3320$end
# ir_jmp cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3320$end;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3285$else:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3285$else;

 mov 32(%rbp),%r10d
 mov %r10d,-20(%rbp)
# ir_load L1 A0;

 mov 32(%rbp),%eax
 cdq
 idivl 40(%rbp)
# ir_div A0 A1; (push)

 mov %eax,32(%rbp)
# ir_load A0 POP();

 mov 32(%rbp),%r10d
 mov %r10d,-28(%rbp)
# ir_load L3 A0;

 mov -16(%rbp),%rax
# ir_deref [L0 . 0]; (push)

 movsxd -24(%rbp),%r10
 lea 0(%rax,%r10,1),%rbx
# ir_index POP() L2; (push)

 mov -72(%rbp),%r12
# ir_deref [L7 . 0]; (push)

 mov 32(%rbp),%r10d
 imul 40(%rbp),%r10d
 mov %r10d,%eax
# ir_mul A0 A1; (push)

 mov -20(%rbp),%r10d
 sub %eax,%r10d
 mov %r10d,%eax
# ir_sub L1 POP(); (push)

 mov $35,%r10d
 add %eax,%r10d
 mov %r10d,%eax
# ir_add 35 POP(); (push)

 movsxd %eax,%r10
 lea 0(%r12,%r10,1),%rax
# ir_index POP() POP(); (push)

 mov (%rax),%r10b
 mov %r10b,(%rbx)
# ir_load POP() POP();

 mov -24(%rbp),%r10d
 add $1,%r10d
 mov %r10d,%eax
# ir_add L2 1; (push)

 mov %eax,-24(%rbp)
# ir_load L2 POP();

 jmp cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3320$cond
# ir_jmp cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3320$cond;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3320$end:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3320$end;

 mov -16(%rbp),%rax
# ir_deref [L0 . 0]; (push)

 movsxd -24(%rbp),%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() L2; (push)

 lea (%rax),%rax
# ir_load_addr POP(); (push)

 mov %rax,-40(%rbp)
# ir_load L4 POP();

 mov -16(%rbp),%rax
# ir_deref [L0 . 0]; (push)

 xor %r10,%r10
 lea 0(%rax,%r10,1),%rax
# ir_index POP() 0; (push)

 lea (%rax),%rax
# ir_load_addr POP(); (push)

 mov %rax,-48(%rbp)
# ir_load L5 POP();

 mov -20(%rbp),%r10d
 cmp $0,%r10d
 jge cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3360$else
# ir_jmp_gte L1 0 cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3360$else;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3360$body:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3360$body;

 mov -40(%rbp),%rax
# ir_deref L4; (push)

 mov $45,%r10b
 mov %r10b,0(%rax)
# ir_load POP() #45;

 mov -40(%rbp),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add L4 1; (push)

 mov %rax,-40(%rbp)
# ir_load L4 POP();

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3360$else:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$if3360$else;

 mov -40(%rbp),%rax
# ir_deref L4; (push)

 mov $0,%r10b
 mov %r10b,0(%rax)
# ir_load POP() #0;

 mov -40(%rbp),%r10
 sub $1,%r10
 mov %r10,%rax
# ir_sub L4 1; (push)

 mov %rax,-40(%rbp)
# ir_load L4 POP();

 xor %r10b,%r10b
 mov %r10b,-49(%rbp)
# ir_load L6 0;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3406$cond:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3406$cond;

 mov -48(%rbp),%r10
 cmp -40(%rbp),%r10
 jge cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3406$end
# ir_jmp_gte L5 L4 cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3406$end;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3406$body:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3406$body;

 mov -40(%rbp),%rax
# ir_deref L4; (push)

 mov 0(%rax),%r10b
 mov %r10b,-49(%rbp)
# ir_load L6 POP();

 mov -40(%rbp),%rbx
# ir_deref L4; (push)

 mov -48(%rbp),%rax
# ir_deref L5; (push)

 mov 0(%rax),%r10b
 mov %r10b,0(%rbx)
# ir_load POP() POP();

 mov -40(%rbp),%r10
 sub $1,%r10
 mov %r10,%rax
# ir_sub L4 1; (push)

 mov %rax,-40(%rbp)
# ir_load L4 POP();

 mov -48(%rbp),%rax
# ir_deref L5; (push)

 mov -49(%rbp),%r10b
 mov %r10b,0(%rax)
# ir_load POP() L6;

 mov -48(%rbp),%r10
 add $1,%r10
 mov %r10,%rax
# ir_add L5 1; (push)

 mov %rax,-48(%rbp)
# ir_load L5 POP();

 jmp cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3406$cond
# ir_jmp cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3406$cond;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3406$end:
# ir_make_label cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$w3406$end;

 mov -24(%rbp),%eax
# ir_return L2;

cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8$end:
 add $80,%rsp
 pop %r12
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint:
# func writeInt(FileHandle, int): {}
 mov %esi,16(%rsp)
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $112,%rsp
# prolog end

 xor %r10,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 0; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $1,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 1; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $2,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 2; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $3,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 3; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $4,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 4; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $5,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 5; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $6,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 6; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $7,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 7; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $8,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 8; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $9,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 9; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $10,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 10; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $11,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 11; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $12,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 12; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $13,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 13; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $14,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 14; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $15,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 15; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $16,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 16; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $17,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 17; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $18,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 18; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $19,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 19; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $20,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 20; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $21,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 21; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $22,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 22; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $23,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 23; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $24,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 24; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $25,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 25; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $26,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 26; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $27,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 27; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $28,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 28; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $29,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 29; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $30,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 30; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 mov $31,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 31; (push)

 xor %r10b,%r10b
 mov %r10b,(%rax)
# ir_load POP() 0;

 xor %r10,%r10
 lea -32(%rbp,%r10,1),%rax
# ir_index L0 0; (push)

 lea (%rax),%rax
# ir_load_addr POP(); (push)

 mov %rax,-48(%rbp)
# ir_load [L1 . 0] POP();

 mov $32,%r10
 mov %r10,-40(%rbp)
# ir_load [L1 . 1] 32;

 push %rdi
 push %rsi
 lea -64(%rbp),%rdi
 lea -48(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L2 L1 16;

 lea -64(%rbp),%rax
# ir_load_addr L2; (push)

 mov %rax,%rdx
 mov $10,%esi
 mov 24(%rbp),%edi
 call cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8
# ir_call cb__Nstd__Nsystem__NintToString__Aint__Aint__Aptr__Tslice__Tuint8 A1 10 POP(); (push)

 movsxd %eax,%rax
# ir_cast POP(); (push)

 mov %rax,-40(%rbp)
# ir_load [L1 . 1] POP();

 push %rdi
 push %rsi
 lea -80(%rbp),%rdi
 lea -48(%rbp),%rsi
 mov $16,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L3 L1 16;

 lea -80(%rbp),%rax
# ir_load_addr L3; (push)

 mov %rax,%rsi
 mov 16(%rbp),%rdi
 call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 A0 POP(); (push)

# ir_noop POP();

cb__Nstd__Nsystem__NwriteInt__AFileHandle__Aint$end:
 add $112,%rsp
 pop %rbp
 ret


