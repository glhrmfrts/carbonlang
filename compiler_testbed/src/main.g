typealias string = array of pure byte

fun write(x: array of pure byte) = do end

fun write(x: int) = do end

-- TODO: compute: validate that all possible paths compute a value
-- TODO: remove useless jumps from IR

macro putln(x) = do write(x) end

fun main = do
    putln(do
        let n = 10
        for range 0,n do |i|
            if i == 5 then
                compute i
            end
        end
        compute 0
    end)
end