local macro make_array_ptr(parr, len, cap) := do
    let ptr := alloc(cap * #sizeof(@parr.ptr))
    if ptr = nil then
        panic("no memory")
    end

    if parr.ptr /= nil then
        memcpy(ptr, parr.ptr, len * #sizeof(@parr.ptr))
        free(parr.ptr)
    end

    parr.ptr := cast(#typeof(parr.ptr)) ptr
    parr.len := len
    parr.cap := cap
end

macro make_array(arr, len, cap) := do
    let parr := &arr
    let llen := len
    let lcap := cap
    make_array_ptr(parr, llen, lcap)
end

macro make_array(arr, len) := do
    make_array(arr, len, len)
end

macro free_array(arr) := do
    let larr := &arr
    free(larr.ptr)
end