fun mmap(sz : int) => &opaque := nil

fun munmap(ptr : &opaque, sz : int) := do end

fun putln(a : array of pure byte) := do end

fun exit(code : int) := do end

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
end

fun main := do
    let data : array of byte
    allocateArray(data, 1024)
    freeArray(data)
end