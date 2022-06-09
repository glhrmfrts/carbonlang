extern(C) fun syscall_1(code: int, arg1: int) => int

extern(C) fun syscall_2(code: int, arg1: int, arg2: int) => int

extern(C) fun syscall_3(code: int, arg1: int, arg2: int, arg3: int) => int

extern(C) fun syscall_4(code: int, arg1: int, arg2: int, arg3: int, arg4: int) => int

extern(C) fun syscall_5(code: int, arg1: int, arg2: int, arg3: int, arg4: int, arg5: int) => int

extern(C) fun syscall_6(code: int, arg1: int, arg2: int, arg3: int, arg4: int, arg5: int, arg6: int) => int

-- Convenience wrappers

fun read(fd: int, ptr: &byte, len: int) => int = do
    return syscall_3(SYS_read, fd, cast(int)cast(uintptr)ptr, len)
end

fun write(fd: int, ptr: &pure byte, len: int) => int = do
    return syscall_3(SYS_write, fd, cast(int)cast(uintptr)ptr, len)
end

fun open(path: &pure byte, flags: int, mode: int) => int = do
    return syscall_3(SYS_open, cast(int)cast(uintptr)path, flags, mode)
end

fun close(fd : int) => int = do
    return syscall_1(SYS_close, fd)
end

fun stat(filename: &pure byte, buf: &opaque) => int = do
    return syscall_2(SYS_stat, cast(int)cast(uintptr)filename, cast(int)cast(uintptr)buf)
end

fun fstat(fd: int, buf: &opaque) => int = do
    return syscall_2(SYS_fstat, fd, cast(int)cast(uintptr)buf)
end

fun mmap(addr: &opaque, size: int, prot: int, flags: int, fd: int, offs: int) => &opaque = do
    return cast(&opaque)cast(uintptr) syscall_6(SYS_mmap, cast(int)cast(uintptr)addr, size, prot, flags, fd, offs)
end

fun munmap(addr: &opaque, size: int) = do
    syscall_2(SYS_munmap, cast(int)cast(uintptr)addr, size)
end

fun exit(code : int) = do
    syscall_1(SYS_exit, code)
end

fun fork() => int = do
    return syscall_1(SYS_fork, 0)
end

fun wait4(pid: int, status: &int, options: int, usage: &opaque) = do
    syscall_4(SYS_wait4, pid, cast(int)cast(uintptr)status, options, cast(int)cast(uintptr)usage)
end

fun execve(cmdline: &pure byte, argv: & &pure byte, envp: & &pure byte) = do
    syscall_3(
        SYS_execve,
        cast(int)cast(uintptr)cmdline,
        cast(int)cast(uintptr)argv,
        cast(int)cast(uintptr)envp
    )
end