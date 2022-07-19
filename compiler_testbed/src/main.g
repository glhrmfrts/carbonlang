import "rt"

typealias string = array of byte

typealias string_view = array of pure byte

fun write(x: array of pure byte) = do end

fun write(x: int) => int = do return 5 end

fun trim_non_numeric(x : string) => string = do
    return @x
end

fun main = do
    let data : string
    data = trim_non_numeric(data)
end