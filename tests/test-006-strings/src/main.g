import "rt"

fun main = do
    writeln("a string")

    let str = "a string"
    writeln(str.ptr == "a string".ptr) -- true

    writeln("a string".len) -- 8
    writeln("a string".cap) -- 9

    writeln(str[0] == 'a') -- true

    -- null-termination for string literals
    writeln(str.ptr[str.len] == '\0') -- true

    -- TODO: properly implement range indexing / slicing, evaluate arguments only once
    --let sub = str[range 2,5]
    --write(sub) write(",") writeln(sub.len) -- str,3

    --sub = str[range 0,1]
    --write(sub) write(",") writeln(sub.len) -- a,1

    -- TODO: str[range 2,...]
end