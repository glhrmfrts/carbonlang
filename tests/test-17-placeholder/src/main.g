import rt

fun identifier := do
    let a := 0
    a := _ + 1
    putln(a)
    a := _ + 1
    putln(a)
    a := _ + 1
    putln(a)
    a := _ + 1
    putln(a)
    a := _ + 1
    putln(a)
end

fun field := do
    type Data := struct of
        counter : int
    end

    let d : Data
    d.counter := _ + 10
    putln(d.counter)

    d.counter := _ * 2
    putln(d.counter)
end

fun main := do
    identifier()
    field()
end