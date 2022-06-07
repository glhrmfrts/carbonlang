import "rt"

fun test_defer := do
    defer writeln("test_defer")
end

fun test_cond_defer_always(a: int) => int := do
    defer writeln("test_cond_defer_always")
    if a = 3 then
        return 5
    end
    return 0
end

fun test_cond_defer_maybe(a: int) => int := do
    if a = 3 then
        defer writeln("test_cond_defer_maybe")
        return 5
    end
    return 0
end

fun test_loop_defer := do
    for range 0,10 do |i|
        defer writeln(i)
        write("test_loop_defer: ")
    end
end

fun main := do
    test_defer()
    test_cond_defer_always(3)
    test_cond_defer_always(13)
    test_cond_defer_maybe(3)
    test_cond_defer_maybe(13)
    test_loop_defer()
end