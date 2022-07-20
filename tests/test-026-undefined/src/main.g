import "rt"

fun do_something = do
    return undefined
end

fun main = do
    let x = 42
    x = undefined
    putln(x) -- 42

    do_something()
end