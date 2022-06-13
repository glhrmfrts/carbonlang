-- TODO: buffered output

import "rt/syscall" as syscall

fun write(fh: file_handle, s: string) => int = do
    return syscall.write(cast(int) fh, s.ptr, s.len)
end

fun write(s: string) = do
    discard write(stdout(), s)
end

fun write(n: nil) = do
    write("nil")
end

fun write(b: bool) = do
    if b then
        write("true")
    else
        write("false")
    end
end

fun write(b: byte) = do
    discard syscall.write(stdout(), &b, 1)
end

fun write(i: int) = do
    let buf : array[32] of byte
    let v = array of byte { &buf[0], #sizeof(buf), #sizeof(buf) }
    discard int_to_string(i, 10, v)
    write(v)
end

fun write(e: error) = do
    write(error_string(e))
end

fun writeln(s: string) = do
    discard write(stdout(), s)
    discard write(stdout(), "\n")
end

fun writeln(n: nil) = do
    writeln("nil")
end

fun writeln(b: bool) = do
    write(b)
    writeln("")
end

fun writeln(i: int) = do
    write(i)
    writeln("")
end

fun writeln(e: error) = do
    write(e)
    writeln("")
end

local fun int_to_string(value: int, base: int, result: in out array of byte) => int = do
    -- check that the base if valid
    if base < 2 or base > 36 then return 0 end

    let tpl_str = "zyxwvutsrqponmlkjihgfedcba9876543210123456789abcdefghijklmnopqrstuvwxyz"

    let tmp_value = value
    let offs : int
    let nvalue = -1

    for nvalue /= 0 do
        if offs >= result.len then
            offs = offs - 1
            break
        end
        
        tmp_value = value
        value = value / base
        nvalue = value

        result[offs] = tpl_str[35 + (tmp_value - value * base)]
        offs = offs + 1
    end

    let ptr:  &byte = &result[offs]
    let ptr1: &byte = &result[0]

    -- Apply negative sign
    if tmp_value < 0 then
        @ptr = '-'
        ptr = cast(&byte) cast(rawptr) (cast(uintptr) _ + 1)
        offs = offs + 1
    end

    @ptr = '\0'
    ptr = cast(&byte) cast(rawptr) (cast(uintptr) _ - 1)

    let tmp_char : byte
    for ptr1 < ptr do
        tmp_char = @ptr

        @ptr = @ptr1
        ptr = cast(&byte) cast(rawptr) (cast(uintptr) _ - 1)

        @ptr1 = tmp_char
        ptr1 = cast(&byte) cast(rawptr) (cast(uintptr) _ + 1)
    end

    result.len = offs
    return offs
end
