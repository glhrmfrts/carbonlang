local macro resize_ptr(parr, len, cap) := do
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

macro resize(arr, len, cap) := do
    let parr := &arr
    let llen := len
    let lcap := cap
    resize_ptr(parr, llen, lcap)
end

macro resize(arr, len) := do
    resize(arr, len, len)
end

macro free_array(arr) := do
    let larr := &arr
    free(larr.ptr)
end

local macro ensure_capacity(parr) := do
    if parr.len >= parr.cap then
        let newcap := 8
        if parr.cap /= 0 then newcap := parr.cap * 2 end
        resize_ptr(parr, parr.len, newcap)
    end
end

-- TODO: overload guards with 'when condition'
macro append(arr, elem) := do
    let parr := &arr
    parr.len := _ + 1
    ensure_capacity(parr)
    arr[arr.len - 1] := elem
end