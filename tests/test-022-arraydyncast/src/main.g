import "rt"

fun test_dynamic_cast(xs: array of int) = do
    for range 0, xs.len do |i|
        write(xs[i])
        write(", ")
    end
    writeln("")
end

fun main = do
    let items : array(3) of int = {1, 2, 3}
    test_dynamic_cast(items)

    test_dynamic_cast(array(5) of int {5, 6, 7, 8, 9})
    test_dynamic_cast(array(...) of int {5, 6, 7, 8, 9, 10})
end