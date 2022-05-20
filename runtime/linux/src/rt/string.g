typealias StringView := arrayview of pure byte

fun cstr_equals(p1 : &pure byte, p2 : &pure byte) => bool := do
    for @p1 /= 0 do
        if @p1 /= @p2 then return false end
        p1 := p1 + 1
        p2 := p2 + 1
    end
    return true
end

fun to_cstr(str : StringView, buffer : in out arrayview of byte) => &pure uint8 := do
    if str.len > buffer.len then return nil end

    memcpy(buffer.ptr, str.ptr, str.len)
    buffer[buffer.len] := '\0'
    return buffer.ptr
end