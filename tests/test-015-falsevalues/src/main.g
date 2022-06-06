import "rt"

type SomeFlags := enumflags (
    OptionA
    OptionB
)

fun main := do
    let bval : bool := false
    if bval then
        writeln("false(bool) is not false")
    end

    let err : error := nil
    if err then
        writeln("nil(error) is not false")
    end

    let flags : SomeFlags := nil
    if flags then
        writeln("nil(enumflags) is not false")
    end
end