typealias string = array of pure byte

macro append(arr, elem) = do
    let parr = &arr
    parr.len = _ + 1
    --ensure_capacity(parr)
    parr.ptr[parr.len - 1] = elem
end

fun to_cstr(str: string, buffer: in out array of byte) => &pure byte = do return nil end

fun main = do
    let arr : array of &pure byte
    let str : string
    let buf : array[4096] of byte
    append(arr, to_cstr(str, buf))
end