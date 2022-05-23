import rt

fun sum(a: int, b: int, c: int, d: int, e: int, f: int, g: int, h: int, j: int) := do
    return a + b + c + d + e + f + g + h + j
end

type State := struct of
    value : int
    value2 : int
    value3 : int
end

fun modify(state: in out State, a: int) := do
    state.value := state.value + a
end

fun init(state: out State, a: int) := do
    state.value := state.value + a
end

fun return_aggregate => State := do
    return State{1,2,3}
end

fun return_aggregate2 => State := do
    return return_aggregate()
end

fun main := do
    writeln(sum(1,1,1,1,1,1,1,1,1)) -- 9

    let state : State
    writeln(state.value) -- 0
    modify(state, 42)
    writeln(state.value) -- 42
    modify(state, 42)
    writeln(state.value) -- 84
    init(state, 42)
    writeln(state.value) -- 42

    let newstate := return_aggregate()
    write(newstate.value)  write(",")
    write(newstate.value2) write(",")
    writeln(newstate.value3)
    -- 1,2,3

    let newstate2 := return_aggregate2()
    write(newstate2.value)  write(",")
    write(newstate2.value2) write(",")
    writeln(newstate2.value3)
    -- 1,2,3
end