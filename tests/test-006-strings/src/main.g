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
end