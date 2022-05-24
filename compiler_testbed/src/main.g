import rt

fun writeln(b : int) := do end

type Data := struct of
    a: int
    b: int
    c: int
end

fun get_array := array(3) of int {40,50,60}

fun main := do
    let a := (Data{1,2,3}).a
end