import "rt"

fun show_file_size(path: string) ? = do
    let statbuf = stat(path)
    writeln(statbuf.size)
end

fun main = do
    try
        show_file_size("file.txt")
        show_file_size("nofile.txt")
    catch |err|
        putln("error: ", err)
    end
end
