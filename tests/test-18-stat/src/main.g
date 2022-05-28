import rt

fun show_file_size(path : String) := do
    let statbuf : Stat
    if stat(path, statbuf) then |err|
        write("error: ") writeln(err)
        return
    end
    writeln(statbuf.size)
end

fun main := do
    show_file_size("file.txt")
    show_file_size("nofile.txt")
end
