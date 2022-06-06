import "rt"

fun show_file_size(path : string) := do
    let statbuf : stat_type
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
