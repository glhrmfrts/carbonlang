import "rt"

typealias string = array of byte

typealias string_view = array of pure byte

fun write(x: array of pure byte) = do end

fun write(x: int) => int = do return 5 end


macro __raise__(err) = do
    context.err = err
    return undefined
end

macro __check_err_call__(fcall) = do
    let res = fcall
    if context.err /= nil then
        return undefined
    end
    compute res
end

macro __try_err_call_discard__(fcall) = do
    discard fcall
    if context.err /= nil then
        -- TODO: this is not generating the correct code
        defer context.err = nil
        errbreak context.err
    end
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

fun get_something(x: string) ? => string = do
    return "something"
end

fun do_something ? = do
    let y = get_something("args")
    discard write(y)
end

fun main = do
    try
        do_something()
    catch |err|
        let x = err
        discard write("error")
    end
end