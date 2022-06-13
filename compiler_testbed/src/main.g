typealias string = array of pure byte

fun write(x: array of pure byte) = do end

fun write(x: int) = do end

-- TODO: compute: validate that all possible paths compute a value
-- TODO: remove useless jumps from IR

macro putln(x) = do write(x) end

fun main = do
    let strarr = {"Hello", "World", "How", "Are", "You?"}
    for range 0,strarr.len do |i|
        putln(strarr[i])
    end
end