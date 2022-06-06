import "rt"

macro putln(a, b) := do
    write(a)
    write(b)
    write("\n")
end

macro putln(a, b, c) := do
    write(a)
    write(b)
    write(c)
    write("\n")
end

macro putln(a, b, c, d) := do
    putln(a,b,c)
    write(d)
    write("\n")
end

fun main := do
    putln("Hello ", "World")
    putln("Hello ", "World ", "You!")
    putln("Hello ", "World ", "Recursive", "You!")
end