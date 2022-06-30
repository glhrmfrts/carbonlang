import "rt"

-- TODO: 'opaque' instead of 'rawptr'
-- TODO: bring back tuple types (return in register optimization)
-- TODO: immutable function pointers by default
-- TODO: allow '-' in identifiers
-- TODO: pointer deref -> macro
-- TODO: array index -> macro
-- TODO: essential types
-- TODO: typed macros
-- TODO: basic generic functions using essential types

fun test_if_stmt(a: int) = do
    let x = if a>3 then compute "greater" else compute "smaller" end
    putln(x)
end

fun test_if_stmt_temp(a: int) = do
    putln(if a>3 then compute "greater" else compute "smaller" end)
end

macro get_cmp(x) = if x>3 then compute "greater" else compute "smaller" end
fun test_if_stmt_macro(a: int) = do
    putln(get_cmp(a))
end

fun test_do_stmt = do
    let x = do
        let n = 10
        for range 0,n do |i|
            if i == 5 then
                compute i
            end
        end
        compute 0
    end
    putln(x) -- 5
end

fun test_do_stmt_temp = do
    putln(do
        let n = 10
        for range 0,n do |i|
            if i == 5 then
                compute i
            end
        end
        compute 0
    end)
end

fun main = do
    test_if_stmt(2)
    test_if_stmt(4)
    test_if_stmt_temp(1)
    test_if_stmt_temp(5)
    test_if_stmt_macro(6)
    test_if_stmt_macro(1)
    test_do_stmt()
    test_do_stmt_temp()
end