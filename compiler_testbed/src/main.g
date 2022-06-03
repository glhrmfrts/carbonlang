type MyStruct := struct of
    x : int
    y : int
end

type Nested := struct of
    ms1 : MyStruct
    ms2 : MyStruct
end

fun main := do
    let narr := array(...) of Nested {
        {{80,90}, {40,50}},
        {{102,402}, {500, 900}},
    }
end