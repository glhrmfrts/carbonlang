-- Test a simple readfile routine using the most barebones language features.

-- TODO: change import to accept a path-like string like "library/module".
-- TODO: change the qualified identifier handling for modules and enums, use a dot-expression instead.
import rt

fun test_defer() := do
    putln("test_defer")
end

fun main := do
    let file : file_handle
    defer close(file)

    defer test_defer()

    if open(file, "file.txt", nil, 0) then |err|
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