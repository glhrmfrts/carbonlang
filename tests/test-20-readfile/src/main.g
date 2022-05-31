-- Test a simple readfile routine using the most barebones language features

import rt

macro allocate_array(arr, len, cap) := do
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

macro allocate_array(arr, len) := do
    allocate_array(arr, len, len)
end

macro free_array(arr) := do
    let larr := &arr
    munmap(larr.ptr, larr.len)
    --putln("freeArray")
end

fun main := do
    let file : file_handle
    defer close(file)

    open(file, "file.txt", nil, 0)

    let statbuf : stat_type
    if stat("file.txt", statbuf) then |err|
        putln("stat error: ", err)
        return
    end

    let data : array of byte
    allocate_array(data, statbuf.size, 4096)
    defer free_array(data)

    putln(statbuf.size, " ", data.len, " ", data.cap)

    if read(file, data) then |err|
        putln("read error: ", err)
        return
    end

    putln(data)

    return
end