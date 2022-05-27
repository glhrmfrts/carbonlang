import rt

fun main := do
    let statbuf : Stat
    if stat("no_file.txt", statbuf) then
        writeln("error")
        return
    end
    writeln(statbuf.size)
end