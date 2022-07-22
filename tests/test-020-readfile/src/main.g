-- Test a simple readfile routine using the most barebones language features.

import "rt"

fun main = do
    try
        let file = open("file.txt", open_flags.read, 0)
        defer close(file)

        let statbuf = file->stat()

        let data : array of byte; resize(data, statbuf.size)
        defer data->free_array()
        file->read(data)

        putln(data)
    catch |err|
        putln("error: ", err)
    end
end