-- Test a simple readfile routine using the most barebones language features.

import "rt"

fun main := do
    let file : file_handle
    defer close(file)

    if open(file, "file.txt", open_flags.read, 0) then |err|
        putln("open error: ", err)
        return
    end

    let statbuf : stat_type
    if stat(file, statbuf) then |err|
        putln("stat error: ", err)
        return
    end

    let data : array of byte
    make_array(data, statbuf.size)
    defer free_array(data)

    if read(file, data) then |err|
        putln("read error: ", err)
        return
    end

    putln(data)
end