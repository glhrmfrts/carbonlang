-- Test a simple readfile routine using the most barebones language features

import rt

macro allocate_array(arr, len, cap) := do
    let larr := &arr
    let llen := len
    let lcap := cap

    let ptr := mmap(llen * sizeof(@larr.ptr))
    if ptr = nil then
        writeln("no memory")
        exit(1)
    end

    larr.ptr := cast(&byte) ptr
    larr.len := llen
    larr.cap := lcap
end

macro allocate_array(arr, len) := do
    allocate_array(arr, len, len)
end

macro free_array(arr) := do
    let larr := &arr
    munmap(larr.ptr, larr.len)
end

fun main := do
    let file : FileHandle
    defer close(file)

    if open(file, "file.txt", OpenFlags::Read, 0) then |err|
        putln("open error: ", err)
        return
    end

    let statbuf : Stat
    if stat(file, statbuf) then |err|
        putln("stat error: ", err)
        return
    end

    let data : array of byte
    allocate_array(data, statbuf.size)
    defer free_array(data)

    if read(file, data) then |err|
        putln("read error: ", err)
        return
    end

    writeln(data)
end