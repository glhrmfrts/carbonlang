import "rt"

fun test_numeric_for = do
    let counter = 0
    for range 0,5 do |i|
        write("numeric_for: ")
        writeln(i)
        counter = counter + 1
    end
end

fun test_numeric_for_neg = do
    let counter = 10

    for range 5,0,-1 do |i|
        write("numeric_for_neg: ")
        writeln(i)
        counter = counter - 1
    end
end

fun get_limit => int = do
    writeln("get_limit")
    return 5
end

fun test_numeric_for_arg = do
    let counter = 0
    for range 0,get_limit() do |i|
        write("numeric_for_arg: ")
        writeln(i)
    end
end

fun test_numeric_for_step = do
    for range 0,20,5 do |i|
        write("numeric_for_step: ")
        writeln(i)
    end
end

fun test_numeric_for_step_neg = do
    for range 20,0,-5 do |i|
        write("numeric_for_step_neg: ")
        writeln(i)
    end
end

fun test_boolean_for = do
    let counter = 0
    for counter < 0 do
        counter = counter + 1
    end
    write("boolean_for: ")
    writeln(counter)
end

fun main = do
    test_numeric_for()
    test_numeric_for_neg()
    test_numeric_for_arg()
    test_numeric_for_step()
    test_numeric_for_step_neg()
    test_boolean_for()
end