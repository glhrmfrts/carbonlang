typealias string = array of pure byte

fun write(x: array of pure byte) = do end

fun write(x: int) = do end

-- TODO: implement compute for temporaries (expressions without an assignee)
-- TODO: implement compute for macros
-- TODO: validate that all possible paths compute a value
-- TODO: remove useless jumps from IR

fun main = do
    let x : int
    x = do
        if x == 4 then
            compute 76
        end
        compute 32
    end
    write(x)
end