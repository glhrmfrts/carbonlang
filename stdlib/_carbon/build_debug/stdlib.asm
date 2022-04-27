.global cb__Nstd__Nsystem__Nstdin
.global cb__Nstd__Nsystem__Nstdout
.global cb__Nstd__Nsystem__Nstderr
.global cb__Nstd__Nsystem__Nread__AFileHandle__Aptr__Tslice__Tuint8
.global cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
.global cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize
.global cb__Nstd__Nsystem__Nexit__Aint
.global __carbon_main
.global cb__Nstd__Nlinux__Nsyscall__Nwrite__Auint__Aptr__Tpure__Tuint8__Ausize
.global cb__Nstd__Nlinux__Nsyscall__Nread__Auint__Aptr__Tuint8__Ausize
.global cb__Nstd__Nlinux__Nsyscall__Nmmap__Aptr__Topaque__Ausize__Aint__Aint__Aint__Ausize
.global cb__Nstd__Nlinux__Nsyscall__Nexit__Aint
.extern cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize__Aptr__Topaque
.extern cb__Nstd__Nsystem__Nfree__Aptr__Topaque
.extern cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__TFileHandle__Terror__Aptr__Tslice__Tpure__Tuint8__AOpenFlags__Aint
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
.data
.cbstr0:
    .string "Hello, world\n"
.text
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

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 8(%rax),%rdx
 mov 0(%r12),%rsi
 mov %ebx,%edi
 callq cb__Nstd__Nlinux__Nsyscall__Nread__Auint__Aptr__Tuint8__Ausize
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

 mov 40(%rbp),%rax
# ir_deref A1; (push)

 mov 8(%rax),%rdx
 mov 0(%r12),%rsi
 mov %ebx,%edi
 callq cb__Nstd__Nlinux__Nsyscall__Nwrite__Auint__Aptr__Tpure__Tuint8__Ausize
# ir_call cb__Nstd__Nlinux__Nsyscall__Nwrite__Auint__Aptr__Tpure__Tuint8__Ausize POP() [POP() . 0] [POP() . 1];

cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8$end:
 add $32,%rsp
 pop %r12
 pop %rbx
 pop %rbp
 ret


cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize:
# func alloc(&{&opaque, error}, usize): &{&opaque, error}
 push %rbp
 mov %rsp,%rbp
# prolog end

cb__Nstd__Nsystem__Nalloc__Aptr__Ttuple__Tptr__Topaque__Terror__Ausize$end:
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
 callq cb__Nstd__Nlinux__Nsyscall__Nexit__Aint
# ir_call cb__Nstd__Nlinux__Nsyscall__Nexit__Aint A0;

cb__Nstd__Nsystem__Nexit__Aint$end:
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
 sub $40,%rsp
# prolog end

 lea .cbstr0,%rax
# ir_load_addr STR0; (push)

 mov %rax,-16(%rbp)
# ir_load [L0 . 0] POP();

 mov $13,%r10d
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] 13;

 callq cb__Nstd__Nsystem__Nstdout
 mov %rax,%rbx
# ir_call cb__Nstd__Nsystem__Nstdout; (push)

 lea -16(%rbp),%rax
# ir_load_addr L0; (push)

 mov %rax,%rsi
 mov %rbx,%rdi
 callq cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8
# ir_call cb__Nstd__Nsystem__Nwrite__AFileHandle__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

# ir_noop POP();

 mov 24(%rbp),%edi
 callq cb__Nstd__Nsystem__Nexit__Aint
# ir_call cb__Nstd__Nsystem__Nexit__Aint A0;

__carbon_main$end:
 add $40,%rsp
 pop %rbx
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


cb__Nstd__Nlinux__Nsyscall__Nmmap__Aptr__Topaque__Ausize__Aint__Aint__Aint__Ausize:
# func mmap(&opaque, usize, int, int, int, usize): {}
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov $9, %rax
    mov %rcx, %r10
    syscall

cb__Nstd__Nlinux__Nsyscall__Nmmap__Aptr__Topaque__Ausize__Aint__Aint__Aint__Ausize$end:
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


