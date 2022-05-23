import rt

type State := struct of value : int; value2 : int end

fun foo(state : out State, a : int) := do
    a := 3
end

fun main := do
end