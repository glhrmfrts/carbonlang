.global cb__Nstd__Nlinux__Nsyscall__Nread__Auint__Aptr__Tuint8__Ausize
.global cb__Nstd__Nlinux__Nsyscall__Nwrite__Auint__Aptr__Tpure__Tuint8__Ausize
.global cb__Nstd__Nlinux__Nsyscall__Nopen__Aptr__Tpure__Tuint8__Aint__Aint16
.global cb__Nstd__Nlinux__Nsyscall__Nclose__Auint
.global cb__Nstd__Nlinux__Nsyscall__Nstat__Aptr__Tpure__Tuint8__Aptr__Topaque
.global cb__Nstd__Nlinux__Nsyscall__Nfstat__Aint__Aptr__Topaque
.global cb__Nstd__Nlinux__Nsyscall__Nmmap__Aptr__Topaque__Ausize__Aint__Aint__Aint__Ausize
.global cb__Nstd__Nlinux__Nsyscall__Nmunmap__Aptr__Topaque__Ausize
.global cb__Nstd__Nlinux__Nsyscall__Nchdir__Aptr__Tpure__Tuint8
.global cb__Nstd__Nlinux__Nsyscall__Nrename__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8
.global cb__Nstd__Nlinux__Nsyscall__Nmkdir__Aptr__Tpure__Tuint8__Aint16
.global cb__Nstd__Nlinux__Nsyscall__Nrmdir__Aptr__Tpure__Tuint8
.global cb__Nstd__Nlinux__Nsyscall__Nunlink__Aptr__Tpure__Tuint8
.global cb__Nstd__Nlinux__Nsyscall__Nexit__Aint
.global cb__Nstd__Nlinux__Nsyscall__Nfork
.global cb__Nstd__Nlinux__Nsyscall__Nexecve__Aptr__Tpure__Tuint8__Aptr__Tptr__Tpure__Tuint8__Aptr__Tptr__Tpure__Tuint8
.global cb__Nstd__Nlinux__Nsyscall__Nwait4__Aint__Aptr__Tint__Aint__Aptr__Topaque
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
.text
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


cb__Nstd__Nlinux__Nsyscall__Nstat__Aptr__Tpure__Tuint8__Aptr__Topaque:
# func stat(&pure uint8, &opaque): int
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov $4, %rax
    syscall

cb__Nstd__Nlinux__Nsyscall__Nstat__Aptr__Tpure__Tuint8__Aptr__Topaque$end:
 pop %rbp
 ret


cb__Nstd__Nlinux__Nsyscall__Nfstat__Aint__Aptr__Topaque:
# func fstat(int, &opaque): int
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov $5, %rax
    syscall

cb__Nstd__Nlinux__Nsyscall__Nfstat__Aint__Aptr__Topaque$end:
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


cb__Nstd__Nlinux__Nsyscall__Nchdir__Aptr__Tpure__Tuint8:
# func chdir(&pure uint8): {}
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov $0x50, %rax
    syscall

cb__Nstd__Nlinux__Nsyscall__Nchdir__Aptr__Tpure__Tuint8$end:
 pop %rbp
 ret


cb__Nstd__Nlinux__Nsyscall__Nrename__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8:
# func rename(&pure uint8, &pure uint8): {}
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov $0x52, %rax
    syscall

cb__Nstd__Nlinux__Nsyscall__Nrename__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$end:
 pop %rbp
 ret


cb__Nstd__Nlinux__Nsyscall__Nmkdir__Aptr__Tpure__Tuint8__Aint16:
# func mkdir(&pure uint8, int16): {}
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov $0x53, %rax
    syscall

cb__Nstd__Nlinux__Nsyscall__Nmkdir__Aptr__Tpure__Tuint8__Aint16$end:
 pop %rbp
 ret


cb__Nstd__Nlinux__Nsyscall__Nrmdir__Aptr__Tpure__Tuint8:
# func rmdir(&pure uint8): {}
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov $0x54, %rax
    syscall

cb__Nstd__Nlinux__Nsyscall__Nrmdir__Aptr__Tpure__Tuint8$end:
 pop %rbp
 ret


cb__Nstd__Nlinux__Nsyscall__Nunlink__Aptr__Tpure__Tuint8:
# func unlink(&pure uint8): {}
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov $0x57, %rax
    syscall

cb__Nstd__Nlinux__Nsyscall__Nunlink__Aptr__Tpure__Tuint8$end:
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


cb__Nstd__Nlinux__Nsyscall__Nfork:
# func fork(): int
 sub $8,%rsp
# prolog end

    mov $57, %rax
    syscall

cb__Nstd__Nlinux__Nsyscall__Nfork$end:
 add $8,%rsp
 ret


cb__Nstd__Nlinux__Nsyscall__Nexecve__Aptr__Tpure__Tuint8__Aptr__Tptr__Tpure__Tuint8__Aptr__Tptr__Tpure__Tuint8:
# func execve(&pure uint8, &&pure uint8, &&pure uint8): {}
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov $59, %rax
    syscall

cb__Nstd__Nlinux__Nsyscall__Nexecve__Aptr__Tpure__Tuint8__Aptr__Tptr__Tpure__Tuint8__Aptr__Tptr__Tpure__Tuint8$end:
 pop %rbp
 ret


cb__Nstd__Nlinux__Nsyscall__Nwait4__Aint__Aptr__Tint__Aint__Aptr__Topaque:
# func wait4(int, &int, int, &opaque): {}
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov $61, %rax
    mov %rcx,%r10
    syscall

cb__Nstd__Nlinux__Nsyscall__Nwait4__Aint__Aptr__Tint__Aint__Aptr__Topaque$end:
 pop %rbp
 ret


