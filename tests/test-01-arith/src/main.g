import rt

fun main := do
    let i := 0
    i := i + 1
    writeln(i)

    let a := 2 + 5 * 10
    writeln(a) -- 52
    writeln(a / 2) -- 26

    writeln(-a) -- -52

    writeln(-a = -52) -- true

    writeln(-(-a)) -- 52
end