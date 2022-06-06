import "rt"

fun main := do
    let val := 1
    val := val << 2
    writeln(val) -- 4

    val := val >> 1
    writeln(val) -- 2

    val := (val << 7) - 1
    writeln(val) -- 255

    val := val | 0xFF00
    writeln(val) -- 65535

    val := val & 0xFF
    writeln(val) -- 255

    val := val & 0x0F
    writeln(val) -- 15

    val := val ^ 0xF0
    writeln(val) -- 255

    val := ~val
    writeln(val) -- -256
end