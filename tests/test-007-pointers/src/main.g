import "rt"

fun main = do
    let a = 123
    writeln(a) -- 123

    let aptr = &a
    @aptr = 256
    writeln(a) -- 256

    let anotherptr = &a
    writeln(anotherptr == aptr) -- true

    @anotherptr = 543
    write(@aptr) write(",") write(@anotherptr) write(",") writeln(a) -- 543,543,543
end