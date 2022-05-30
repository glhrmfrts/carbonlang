import rt::syscall as syscall

fun read(fh: FileHandle, data: in out array of byte) => error := do
    let nread := syscall::read(fh, data.ptr, data.len)
    if nread < 0 then
        return errno_to_error(-nread)
    end
    return nil
end

fun read(fh: FileHandle, data: in out array of byte, nread : out int) => error := do
    nread := syscall::read(fh, data.ptr, data.len)
    if nread < 0 then
        return errno_to_error(-nread)
    end
    return nil
end