import "rt"

fun main := do
    let code : int
    if exec("/usr/bin/cat", array(...) of string{"src/main.g"}, code) then |err|
        putln("Error: ", err)
        return
    end
    putln(code)
end