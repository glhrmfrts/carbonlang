-- Test a simple readfile routine using the most barebones language features

import rt

macro allocateArray(arr, len, cap) := do
    -- To ensure arguments are evaluated only once
    let larr := &arr
    let llen := len
    let lcap := cap

    let ptr := mmap(lcap * sizeof(@larr.ptr))
    if ptr = nil then
        putln("no memory")
        exit(1)
    end

    larr.ptr := cast(&byte) ptr
    larr.len := llen
    larr.cap := lcap
end

macro allocateArray(arr, len) := do
    allocateArray(arr, len, len)
end

macro freeArray(arr) := do
    let larr := &arr
    munmap(larr.ptr, larr.len)
    --putln("freeArray")
end

fun main := do
    let file : FileHandle
    defer close(file)

    open(file, "file.txt", nil, 0)

    let statbuf : Stat
    if stat("file.txt", statbuf) then |err|
        putln("stat error: ", err)
        return
    end

    let data : array of byte
    allocateArray(data, statbuf.size, 4096)
    defer freeArray(data)

    putln(statbuf.size, " ", data.len, " ", data.cap)

    if read(file, data) then |err|
        putln("read error: ", err)
        return
    end

    putln(data)

    return
end