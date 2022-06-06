import "rt"

-- TODO(bug): consider overloads from multiple modules
-- TODO(bug): overload candidate reporting is broken for macros

macro my_putln(a, b) := do
    write(a)
    write(b)
    write("\n")
end

macro my_putln(a, b, c) := do
    write(a)
    write(b)
    write(c)
    write("\n")
end

macro my_putln(a, b, c, d) := do
    my_putln(a,b,c)
    write(d)
    write("\n")
end

macro adder(a, b) := a * b

macro muladd(a, b, c) := adder(a, b) + c

fun main := do
    my_putln("Hello ", "World")
    my_putln("Hello ", "World ", "You!")
    my_putln("Hello ", "World ", "Recursive", "You!")

    -- Test expression macros
    let val := adder(5, 10)
    writeln(val) -- 50

    let res := muladd(2, 5, 3)
    writeln(res) -- 13
end