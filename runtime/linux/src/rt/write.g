import rt::x86_64 as syscall

fun write(fh : FileHandle, s : arrayview of pure byte) => int := do
    return syscall::write(cast(int) fh, s.ptr, s.len)
end

fun write(s : arrayview of pure byte) := do
    write(stdout(), s)
end

fun writeln(s : arrayview of pure byte) := do
    write(stdout(), s)
    write(stdout(), "\n")
end

private fun int_to_string(value: int, base: int, result: out arrayview of byte) := do
    // check that the base if valid
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

    // Apply negative sign
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

    return offs
end

fun writeln(i : int) := do
    let buf : array(32) of byte
    let v := arrayview of byte { &buf, sizeof(buf) }
    int_to_string(i, 10, v)
    writeln(v)
end