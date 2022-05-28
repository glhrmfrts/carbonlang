-- Test a simple readfile routine using the most barebones language features

import rt

fun allocate_buffer(size: int) => arrayview of byte := do
    let ptr := mmap(size)
    if ptr = nil then
        writeln("no memory")
        return nil
    end

    let result := arrayview of byte { cast(&byte) ptr, size }
    return result
end

fun free_buffer(b : arrayview of byte) := do
    munmap(b.ptr, b.len)
end

fun main := do
    let file : file_handle
    if open(file, "file.txt", open_flags::read, 0) then |err|
        writeln("open error")
        return
    end
    defer close(file)

    let statbuf : stat_type
    if stat(file, statbuf) then |err|
        putln("stat error")
        return
    end

    let data : array of byte
    if read(file, data) then |err|
        putln("read error")
        return
    end

    writeln(data)
end