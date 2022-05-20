extern(C) fun WriteFile(handle: int, str: &pure byte, len: int, written: &int, ov: &opaque)

fun write(handle: file_handle, data: arrayview of pure byte) => int := do
    let written : int
    WriteFile(handle, data.ptr, data.len, &written, nil)
    return written
end