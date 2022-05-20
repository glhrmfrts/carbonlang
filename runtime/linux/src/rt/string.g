typealias StringView := arrayview of pure byte

fun cstr_equals(p1 : &pure byte, p2 : &pure byte) => bool := do
    for @p1 /= 0 do
        if @p2 = 0      then return false end
        if @p1 /= @p2   then return false end
        p1 := p1 + 1
        p2 := p2 + 1
    end
    return true
end