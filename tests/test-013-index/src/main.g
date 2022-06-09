import "rt"

type Data = struct of
    x       : int
    y       : int
    numbers : array[3] of int
end

fun get_array = array[3] of int {40,50,60}

fun get_array_of_arrays = array[3] of array[4] of int {
    array[4] of int {100, 200, 300, 400},
    array[4] of int {1000, 2000, 3000, 4000},
    array[4] of int {10000, 20000, 30000, 40000},
}

fun main = do
    let d : Data
    d.numbers[0] = 10
    d.numbers[1] = 20
    d.numbers[2] = 30
    writeln(d.numbers[0]) -- 10
    writeln(d.numbers[1]) -- 20
    writeln(d.numbers[2]) -- 30
    writeln(get_array()[0]) -- 40
    writeln(get_array()[1]) -- 50
    writeln(get_array()[2]) -- 60

    write(get_array_of_arrays()[0][0]) write(",") -- 100
    write(get_array_of_arrays()[0][1]) write(",") -- 200
    write(get_array_of_arrays()[0][2]) write(",") -- 300
    write(get_array_of_arrays()[0][3]) write("\n") -- 400

    write(get_array_of_arrays()[1][0]) write(",") -- 1000
    write(get_array_of_arrays()[1][1]) write(",") -- 2000
    write(get_array_of_arrays()[1][2]) write(",") -- 3000
    write(get_array_of_arrays()[1][3]) write("\n") -- 4000

    write(get_array_of_arrays()[2][0]) write(",") -- 10000
    write(get_array_of_arrays()[2][1]) write(",") -- 20000
    write(get_array_of_arrays()[2][2]) write(",") -- 30000
    write(get_array_of_arrays()[2][3]) write("\n") -- 40000
end