import "rt/syscall" as syscall

fun read(fh: file_handle, data: in out array of byte) ? = do
    let nread = syscall.read(fh, data.ptr, data.len)
    if nread < 0 then
        raise errno_to_error(-nread)
    end
end

fun read(fh: file_handle, data: in out array of byte, bytes_read: out int) ? = do
    let nread = syscall.read(fh, data.ptr, data.len)
    if nread < 0 then
        raise errno_to_error(-nread)
    end
    bytes_read = nread
end