import "rt"

fun main = do
    let code : int
    if exec("/usr/bin/cat", {"src/main.g"}, code) then |err|
        putln("Error: ", err, " ", code)
        return
    end
    putln("Exit code: ", code)
end
