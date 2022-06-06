import "rt"

type Data := struct of
    x : int
    y : int
end

fun main := do
    writeln(nil)

    let d : Data := nil
    write(d.x) write(",") write(d.y)
    writeln("")
end