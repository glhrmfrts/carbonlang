import "rt"

let a : int

fun side_effect => bool = do
    a = a + 1
    return true
end

fun main = do
    writeln(2 > 5) -- false
    writeln(2 < 5) -- true
    writeln(2 < 5 and 10 == 10) -- true
    writeln(2 < 5 and 10 == 11) -- false
    writeln(2 < 5 and 10 == 11 and 90 < 10) -- false
    writeln(2 < 5 or 10 == 10) -- true
    writeln(2 < 5 or 10 == 11 or 90 > 10) -- true

    -- to test jumps
    
    if 2 < 5 or 10 == 11 or 90 > 10 then
        writeln(true)
    else
        writeln(false)
    end
    -- true

    if 2 < 5 and 10 == 11 and 90 < 10 then
        writeln(true)
    else
        writeln(false)
    end
    -- false

    -- test short-circuiting
    let ok : bool

    ok = 2 > 5 and side_effect()
    writeln(a) -- 0

    ok = 2 > 5 or side_effect()
    writeln(a) -- 1

    ok = 2 < 5 or side_effect()
    writeln(a) -- 1
end