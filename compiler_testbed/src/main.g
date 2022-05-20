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

local const EINTR: int		:= 4

-- Comment nice to see you

fun foo(state : MyStruct, result: in arrayview of byte) := do
    result[0] := 3
end
