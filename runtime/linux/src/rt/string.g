typealias string = array of byte

typealias string_view = array of pure byte

fun memcpy(dest: rawptr, src: rawptr, n: int) = do
    asm%do
        mov %rdx,%rcx
        rep movsb
    end%asm
end

fun memset(dest: rawptr, value: byte, count: int) = do
    asm%do
        mov %rsi,%rax
        mov %rdx,%rcx
        rep stosb
    end%asm
end

fun cstr_equals(p1 : &pure byte, p2 : &pure byte) => bool = do
    for @p1 /= '\0' do
        if @p1 /= @p2 then return false end
        p1 = cast(&pure byte) cast(rawptr) (cast(uintptr) _ + 1)
        p2 = cast(&pure byte) cast(rawptr) (cast(uintptr) _ + 1)
    end
    return true
end

fun cstrlen(ptr: &pure byte) => int = do
    if ptr == nil then return 0 end

    let count : int
    for @ptr /= '\0' do
        count = count + 1
        ptr = cast(&pure byte) cast(rawptr) (cast(uintptr) _ + 1)
    end
    return count
end

fun to_cstr(str : string, buffer : in out array of byte) => &pure byte = do
    if str.len > buffer.len - 1 then return nil end

    memcpy(buffer.ptr, str.ptr, str.len)
    buffer[str.len] = '\0'
    return buffer.ptr
end

fun from_cstr(ptr : &pure byte) => string = do
    return string{ ptr, cstrlen(ptr) }
end

