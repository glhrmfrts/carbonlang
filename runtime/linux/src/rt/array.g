local macro resize_ptr(rp_parr, rp_len, rp_cap) = do
    let ptr = alloc(rp_cap * #sizeof(@rp_parr.ptr))
    if ptr == nil then
        panic("no memory")
    end

    if rp_parr.ptr /= nil then
        memcpy(ptr, rp_parr.ptr, rp_len * #sizeof(@rp_parr.ptr))
        free(rp_parr.ptr)
    end

    rp_parr.ptr = cast(#typeof(rp_parr.ptr)) ptr
    rp_parr.len = rp_len
    rp_parr.cap = rp_cap
end

macro resize(rr_arr, rr_len, rr_cap) = do
    let parr = &rr_arr
    let llen = rr_len
    let lcap = rr_cap
    resize_ptr(parr, llen, lcap)
end

macro resize(r_arr, r_len) = do
    resize(r_arr, r_len, r_len)
end

macro free_array(arr) = do
    let larr = &arr
    free(larr.ptr)
end

local macro ensure_capacity(ec_parr) = do
    if ec_parr.len >= ec_parr.cap then
        let newcap = 8
        if ec_parr.cap /= 0 then newcap = ec_parr.cap * 2 end
        resize_ptr(ec_parr, ec_parr.len, newcap)
    end
end

-- TODO: remove unreferenced locals from IR
-- TODO(future): overload guards with 'when condition'
macro append(arr, elem) = do
    let parr = &arr
    parr.len = _ + 1
    ensure_capacity(parr)
    parr.ptr[parr.len - 1] = elem
end