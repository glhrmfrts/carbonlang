import "rt"

enumerror ( InvalidValue )

let gvar : int

fun get_something => int = do
    return gvar
end

fun do_something ? = do
    let y = get_something()
    if y > 3 then
        raise InvalidValue
    end
    putln("do_something: ", y)
end

fun call_do_something() ? = do
    do_something()
    putln("succeeded doing something")
end

fun main = do
    gvar = 42
    do
        let err = call_do_something()?
        putln("main: ", err)
    end
    gvar = 2
    do
        let err = call_do_something()?
        putln("main: ", err)
    end
end
