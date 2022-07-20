import "rt"

typealias string = array of byte

typealias string_view = array of pure byte

fun write(x: array of pure byte) = do end

fun write(x: int) => int = do return 5 end


macro __raise__(err) = do
    context.err = err
    return undefined
end

macro __check_err_call_discard__(fcall) = do
    discard fcall
    if context.err /= nil then
        --putln("error: ", context.err)
        return undefined
    end
end

macro __catch_err_call_discard__(fcall) = do
    discard fcall
    defer context.err = nil
    compute context.err
end

enumerror ( SomeError )

fun get_something => int = do
    return 42
end

fun do_something ? = do
    let y = get_something()
    if y > 3 then
        --raise SomeError
        __raise__(SomeError)
    end
    --putln("do_something: ", y)
end

fun call_do_something ? = do
    __check_err_call_discard__(do_something())
    --putln("succeeded doing something")
end

fun main = do
    let err : error = call_do_something()?
    --putln("main: ", err)
end