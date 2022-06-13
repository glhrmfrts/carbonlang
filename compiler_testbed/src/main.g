typealias string = array of byte

typealias string_view = array of pure byte

fun write(x: array of pure byte) = do end

fun write(x: int) => int = do return 5 end

-- TODO: compute: validate that all possible paths compute a value
-- TODO: remove useless jumps from IR

macro putln(x) = do write(x) end

macro append(arr, elem) = do arr[0] = elem end

fun append(s: in out string, what: string) = do
    for range 0, what.len do |i|
        append(s, what[i])
    end
end

fun main = do
    let strarr : string
    append(strarr, "asd")
    discard write(2)
end