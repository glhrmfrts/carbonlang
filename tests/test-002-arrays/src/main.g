import rt

fun test_len_size := do
    let arr : array(33) of int
    write("test_len_size: sizeof(arr): ") writeln(sizeof(arr))
end

fun test_zero_init := do
    let arr : array(32) of int
    let sum := 0
    for i := range 0, arr.len do
        sum := sum + arr[i]
    end
    write("test_zero_init: ") writeln(sum)
end

fun test_auto_size := do
    let arr : array(...) of int := { 0,1,2,3 }
    write("test_auto_size: sizeof(arr): ") writeln(sizeof(arr))
end

fun main := do
    test_len_size()
    test_zero_init()
    test_auto_size()
end