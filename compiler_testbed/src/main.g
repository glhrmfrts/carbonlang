extern(C) fun write(fd : int, s : &byte) => int

fun scan_devices(timeout : int) := do

end

fun main := do
    let s := "Hello World\n"
    s[0] := "B"
end