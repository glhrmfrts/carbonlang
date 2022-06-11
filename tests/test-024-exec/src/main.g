import "rt"

macro create_thread(th, fn, arg) = do
    let arg_heap = unsafe_cast(& #typeof(arg)) alloc(#sizeof(arg))
    @arg_heap = arg

    fun start_thread_func(x: rawptr) = do
        let targ = unsafe_cast(& #typeof(arg)) x
        fn(@targ)
    end

    fun start_thread_func(x: rawptr) = do
        let targ = unsafe_cast(& #typeof(arg)) x
        fn(@targ)
    end

    compute create_thread(th, start_thread_func, cast(rawptr) arg_heap)
end

type BluetoothClient = struct of
    requests: channel of int
end

fun client_start(#thread, client: in out BluetoothClient) = do
    
end

local let client : BluetoothClient

fun main = do
    if client_start(let thread : thread_handle, client) then |err|
        putln("Error creating thread: ", err)
        return
    end
    defer join(thread)

    if parse_int(str, 10, let num, let rest) then
        append(numbers, num)
    end

    let code : int
    if exec("/usr/bin/cat", array[...] of string{"src/main.g"}, code) then |err|
        putln("Error: ", err, " ", code)
        return
    end
    putln("Exit code: ", code)
end
