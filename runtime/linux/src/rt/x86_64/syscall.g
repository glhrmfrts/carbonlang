fun read(fd: int, ptr: &byte, len: int) => int := do
    asm%do

        mov $0, %rax            # system call 0 is read
                                # file handle is already in rdi
                                # data is already in rsi
                                # number of bytes is already in rdx
        syscall

    end%asm   
end

fun write(fd: int, ptr: &pure byte, len: int) => int := do
    asm%do

        mov $1, %rax            # system call 1 is write
                                # file handle is already in rdi
                                # data is already in rsi
                                # number of bytes is already in rdx
        syscall

    end%asm
end

fun open(path: &pure byte, flags: int, mode: int) => int := do
    asm%do

        mov $2, %rax
        syscall

    end%asm
end

fun close(fd : int) => int := do
    asm%do
        mov $3, %rax
        syscall
    end%asm
end

fun exit(code : int) := do
    asm%do
        
        mov $60, %rax
        syscall

    end%asm
end