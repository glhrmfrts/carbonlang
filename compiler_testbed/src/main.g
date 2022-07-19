import "rt"

typealias string = array of byte

typealias string_view = array of pure byte

fun write(x: array of pure byte) = do end

fun write(x: int) => int = do return 5 end

type Token = struct of
    token_type : int
    value : int
    length : int
    start : int
    stop : int
end

fun make_token => Token = do
    return {3}
end

fun main = do
    let t = make_token()
end