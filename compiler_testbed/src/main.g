import rt

type MyStruct := struct of
    a : int
    b : int
end

type state_kind := enum (
    invalid
    expr
    stmt
)

fun foo(state : MyStruct, result: out arrayview of byte) := do
    result[0] := 3
end

fun main := do end