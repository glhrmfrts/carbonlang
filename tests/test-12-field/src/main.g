-- Test the ability to have any expression in the left-side of a field selector

import rt

type Data := struct of
    a: int
    b: int
    c: int
end

fun get_data := Data{10,20,30}

fun main := do
    let d := Data{1,2,3}
    write(d.a) write(",") -- 1
    write(d.b) write(",") -- 2
    write(d.c) write("\n") -- 3

    write((Data{1,2,3}).a) write(",") -- 1
    write((Data{4,5,6}).b) write(",") -- 5
    write((Data{7,8,9}).c) write("\n") -- 9

    write(get_data().a) write(",") -- 10
    write(get_data().b) write(",") -- 20
    write(get_data().c) write("\n") -- 30

    -- TODO: test init expressions because of buggy array of structs
    let array_of_datas : array(3) of Data

    array_of_datas[0].a := 50
    array_of_datas[0].b := 60
    array_of_datas[0].c := 70

    write(array_of_datas[0].a) write(",") -- 50
    write(array_of_datas[0].b) write(",") -- 60
    write(array_of_datas[0].c) write("\n") -- 70

    -- TODO: parse Data{1,2,3}.a
    let a := (Data{1,2,3}).a
    let b := (Data{4,5,6}).b
    let c := (Data{7,8,9}).c

    writeln(a) -- 1
    writeln(b) -- 5
    writeln(c) -- 9
end