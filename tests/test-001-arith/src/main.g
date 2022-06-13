import "rt"

fun fib(n: int) => int = do
    if n == 0 then
        return 0
    else if n == 1 then
        return 1
    else
        return fib(n - 1) + fib(n - 2)
    end
end

fun main = do
    let i = 0
    i = i + 1
    writeln(i)

    let a = 2 + 5 * 10
    writeln(a) -- 52
    writeln(a / 2) -- 26

    writeln(-a) -- -52

    writeln(-a == -52) -- true

    writeln(-(-a)) -- 52
end