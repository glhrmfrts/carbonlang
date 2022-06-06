import "rt/syscall" as syscall

fun read(fh: file_handle, data: in out array of byte) => error := do
    let nread := syscall.read(fh, data.ptr, data.len)
    if nread < 0 then
        return errno_to_error(-nread)
    end
    return nil
end

fun read(fh: file_handle, data: in out array of byte, bytes_read: out int) => error := do
    let nread := syscall.read(fh, data.ptr, data.len)
    if nread < 0 then
        return errno_to_error(-nread)
    end
    bytes_read := nread
    return nil
end