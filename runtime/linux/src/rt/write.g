-- TODO: buffered output

import rt::syscall as syscall

fun write(fh : FileHandle, s : arrayview of pure byte) => int := do
    return syscall::write(cast(int) fh, s.ptr, s.len)
end

fun write(s : arrayview of pure byte) => int := do
    return write(stdout(), s)
end

fun write(n : nil) => int := do
    return write("nil")
end

fun write(b : bool) => int := do
    if b then
        return write("true")
    else
        return write("false")
    end
end

fun write(b : byte) => int := do
    return syscall::write(stdout(), &b, 1)
end

fun write(i : int) => int := do
    let buf : array(32) of byte
    let v := arrayview of byte { &buf[0], sizeof(buf) }
    int_to_string(i, 10, v)
    return write(v)
end

fun write(e : error) => int := do
    return write(error_string(e))
end

fun writeln(s : arrayview of pure byte) => int := do
    let res := write(stdout(), s)
    res := res + write(stdout(), "\n")
    return res
end

fun writeln(n : nil) => int := do
    return writeln("nil")
end

fun writeln(b : bool) => int := do
    let res := write(b)
    return res + writeln("")
end

fun writeln(i : int) => int := do
    let res := write(i)
    return res + writeln("")
end

fun writeln(e : error) => int := do
    return write(e) + writeln("")
end

local fun int_to_string(value: int, base: int, result: in out arrayview of byte) => int := do
    -- check that the base if valid
    if base < 2 or base > 36 then return 0 end

    let tpl_str := "zyxwvutsrqponmlkjihgfedcba9876543210123456789abcdefghijklmnopqrstuvwxyz"

    let tmp_value := value
    let offs : int
    let nvalue := -1

    for nvalue /= 0 do
        if offs >= result.len then
            offs := offs - 1
            break
        end
        
        tmp_value := value
        value := value / base
        nvalue := value

        result[offs] := tpl_str[35 + (tmp_value - value * base)]
        offs := offs + 1
    end

    let ptr:  &byte := &result[offs]
    let ptr1: &byte := &result[0]

    -- Apply negative sign
    if tmp_value < 0 then
        @ptr := '-'
        ptr := ptr + 1
        offs := offs + 1
    end

    @ptr := '\0'
    ptr := ptr - 1

    let tmp_char : byte
    for ptr1 < ptr do
        tmp_char := @ptr

        @ptr := @ptr1
        ptr := ptr - 1

        @ptr1 := tmp_char
        ptr1 := ptr1 + 1
    end

    result.len := offs
    return offs
end
