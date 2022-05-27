-- Test a simple readfile routine using the most barebones language features

import rt

fun allocate_buffer(size: int) => arrayview of byte := do
    let ptr := mmap(size)
    if ptr = nil then
        writeln("no memory")
        return nil
    end

    let result := arrayview of byte{ cast(&byte) ptr, size }
    return result
end

fun free_buffer(b : arrayview of byte) := do
    munmap(b.ptr, b.length)
end

fun main := do
    let file : FileHandle
    let err_open := open(file, "file.txt", OpenFlags::Read, 0)
    if err_open then
        writeln("open error")
        return
    end
    defer close(file)

    let statbuf : Stat
    let err_stat := stat(file, statbuf)
    if err_stat then
        writeln("stat error")
        return
    end

    let buffer := allocate_buffer(statbuf.size)
    defer free_buffer(buffer)

    let err_read := read(file, buffer)
    if err_read then
        writeln("read error")
        return
    end

    writeln(buffer)
end