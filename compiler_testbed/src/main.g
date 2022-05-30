fun write(arg : array of pure byte) := do end

macro write(a, b, c) := do
    write(a)
    write(b)
    write(c)
    write("\n")
end

fun main := do
    write("Hello", "World", "You")
    write("Hello2", "World2", "You2")
end