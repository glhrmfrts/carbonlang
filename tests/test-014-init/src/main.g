import "rt"

type MyStruct = struct of
    x : int
    y : int
end

type Nested = struct of
    ms1 : MyStruct
    ms2 : MyStruct
end

fun writeMyStruct(strt : MyStruct) = do
    write(strt.x) write(",") write(strt.y) write("\n")
end

fun writeNested(n : Nested) = do
    writeMyStruct(n.ms1)
    writeMyStruct(n.ms2)
end

fun main = do
    let strt = MyStruct{10, 20}
    writeMyStruct(strt)

    writeln("array...")

    let arr = array[...] of MyStruct {
        {40,50},
        {80,90},
        {102,402},
    }
    writeMyStruct(arr[0])
    writeMyStruct(arr[1])
    writeMyStruct(arr[2])

    writeln("array of nested...")

    let narr = array[...] of Nested {
        {{80,90}, {40,50}},
        {{102,402}, {500, 900}},
    }
    writeNested(narr[0])
    writeNested(narr[1])

    let strarr = {"Hello", "World", "How", "Are", "You?"}
    for range 0,strarr.len do |i|
        write(strarr[i])
        write(" ")
    end
    writeln("")

    -- Test zero initialization
    let a : MyStruct
    writeMyStruct(a) -- 0,0

    let b : MyStruct = {24}
    writeMyStruct(b) -- 24,0
end