import "rt"

fun get_something ? => int = do
    return 3
end

fun do_something ? = do
    let y = get_something()
end

fun main = do
    let x = get_something()
    putln("Hello world: ", x)
end