import rt

type SomeFlags := enumflags (
    OptionA
    OptionB
)

fun writeln(a : arrayview of byte) := do
    
end

fun main := do
    let bval : bool := false
    if not bval then
        writeln("false(bool) is false")
    end

    let err : error := nil
    if not err then
        writeln("nil(error) is false")
    end

    let flags : SomeFlags := nil
    if not flags then
        writeln("nil(enumflags) is false")
    end
end