typealias string = array of byte

typealias string_view = array of pure byte

proc write(x: array of pure byte) = do end

proc write(x: int) => int = do return 5 end

proc replace(str: in out string, from: string, to: string) => bool = do

end

struct of
    refblock: opaque
    ptr: opaque
    len: int
end

object of
    state: int
    counter: int
end

type string = array of byte

type My_Type = struct of
    ptr : pointer of Object

    -- ERROR: struct member of closable type in non-closable struct
    -- NOTE: annotate the struct with <close: closeproc> or annotate the member with <noclose>
end

proc my_close(self: in out My_Type) = do
    close(self.ptr)
end

proc trim(str: string, pattern: string) => string = do
    keep.str = str
end

proc write_log(arg: opaque) = do
    let param <noclose> = cast(pointer of write_log_param_t) arg
    defer free(param)

    -- ERROR: local variable 'str' of type 'string' is never closed, returned or assigned to out paramaters
    -- NOTE: the close function for type 'string' is 'free(array)', declared in blalba.par:42:1
    -- NOTE: annotate the variable with 'noclose' to supress this error

    -- ERROR: local variable 'x' of type 'My_Type' is never closed, returned or assigned to out parameters
    -- NOTE: the close function for type 'My_Type' is 'my_close', declared in bla.par:45:3
    -- NOTE: annotate the variable with 'noclose' to supress this error

    -- ERROR: local variable 'param' of type 'pointer of write_log_param_t' is never closed, returned or assigned to out paramaters
    -- NOTE: the cleanup function for type 'pointer of write_log_param_t' is 'free(pointer)', declared in blabla.par:31:3
    -- NOTE: annotate the variable with 'nofree' in case you don't own this pointer
end

type write-log-param-type = struct of
    logfmt: format-expr
    pos: source-position
end

proc write-log(arg: opaque) = do
    let param <close> = cast(pointer of write-log-param-type) arg
    -- ERROR: local variable 'param' of type 'pointer of write-log-param-type' is never closed, returned, or assigned to out parameters
    -- NOTE: this variable's type requires closing, returning, or being assigned to out parameters
    -- NOTE: consider adding '<close>', '<close-on-err>' or '<no-close>' attributes to suppress this error

end

proc whatever(param <close>: pointer of write-log-param-type) = do

end

proc spawn-write-log(logfmt: format-expr, pos: source-position, result: out pointer of write-log-param-type) => error = do
    -- ERROR: local variable 'param' of type 'pointer of write-log-param-type' is never closed, returned, or assigned to out parameters
    -- NOTE: this variable's type requires closing, returning, or being assigned to out parameters
    -- NOTE: consider adding '<close>', '<close-on-err>' or '<no-close>' attributes to suppress this error
    let param = make(write-log-param-type, {
        logfmt = logfmt,
        pos = pos,
    })
    let param__close : bool = true

    if somecondition then
        param__close = false
        result = param
        return nil
    else
        result = nil
        return SOME_ERROR
    end

    return nil
end

proc spawn-write-log(str: in out string, from: string, to: string) => int = do
    try
        let filename <close-on-err> = format("%s/ecg-queue/%s/%s.bin" % {UPLOADER_STATE_PATH, exam-uuid, timestamp-str})
        let param <close-on-err> = alloc(write-log-param-type)
        param.filename = filename
        add_job(queue, write_log, cast(opaque) param)?
    else |err|
        print("error")
    end
end

proc replace_all(str: in out string, from: string, to: string) => int = do

end

proc connect(sock: in out Socket, host: string, port: string) => enumerror = do

end

proc parse(str: string, radix: int, result: out int, chars_read: out int) => bool = do

end


type Vector = array of float
type Matrix = array of Vector
type Sprite = struct of
    kind: string[32]
    pos: vector
end

macro try(let x) = do
    if x /= nil then
        result = x
        return
    end
end

proc mat_vec_mul(mat: Matrix, vec: Vector) => Vector = do
    resize(result, len(mat))
    for range 0, len(mat) do |i|
        result[i] = result[i] + mat[i][j] * vec[j]
    end
end

proc rot(turn: float) => Matrix = do
    let rad = 2 * pi * turn
    result = Matrix{
        Vector{cos(rad), -sin(rad)},
        Vector{sin(rad), cos(rad)}
    }
end

proc main = do
    let sprite = Sprite{kind: 'robot', pos: {1, 1}}
    let view_pos = mat_vec_mul(rot(1 / 4), sprite.pos)
    print(sprite.kind, ' rotated to ', view_pos[0], view_pos[1])
end

typealias String = array[...] of byte

typealias DynamicString = array of byte

type MACAddressString = string[16]

type UUIDString = string[36]

type DeviceState = struct of
    addr : MACAddressString
    uuid : UUIDString
end

let device_states: array[max: MAX_DEVICES_PER_CYCLE] of DeviceState

proc spawn_connector(addr: MACAddressString, slot: int) => error = do
    let new_device_state : DeviceState
    new_device_state.addr = addr
    new_device_state.slot = slot
    error = append(arr: device_states, element: new_device_state)
end

proc execute_connector_process(addr: MACAddressString, slot: int) = do
    case exec(exe: "/usr/bin/quoreone-connector",
              args: {addr, to_string(slot)},
              exit_code: out let exit_code) of
        when EXEC_CHILD_SIGNAL =>
            print("child signaled")
        when nil =>
            print("no error")
        when ... => |err|
            print("nice")
    end
end

proc get_slot_for_device(addr: MACAddressString, slot: out int) => bool = do
    result = slot.allocate(slot)
end

proc scan_devices(timeout: int) => error = do
    let devices : array[max: MAX_DEVICES_SCANNED] of ble.DeviceInfo
    error = ble.scan(timeout, devices)
    for range devices do |i|
        let in device = devices[i]
        if is_quoreone_device(device) and is_device_charging(device) then
            if get_slot_for_device(device.addr, out let slot) then
                spawn_connector(device.addr, slot)
            end
        end
    end
end

proc send_log_tcp(log: DynamicString, ctx: DynamicString) => (result: int, err: error) = do
    defer if err then

    end

    const NUM_TRIES = 2
    for range 0, NUM_TRIES do |i|
        if tcp.send(socket, log) then |err|
            try (if err /= TCP_CLOSED_BY_REMOTE then compute err else compute nil)
            try tcp.connect(socket, HOST, PORT)
        end
    end

    result = 3
end

proc main => error or discard = do
    let num_written, err = send_log_tcp(); if err /= nil then

    end
    print(num_written)
end

type DeviceStatus = (DeviceAvailable, DeviceUploading, DeviceCooldown)

proc active_connectors_count => int = do
    for range device_states of |i|
        if device_states[i].state == DeviceUploading then
            result = _ + 1
        end
    end
end

proc parse(str: string, radix: int, result: out int, chars_read: out int) => bool = do
    if parse(str, 10, let num, ...) then
        print(num)
    end
end

proc parse(str: string, radix: int, result: out int) => bool = do
    return parse(str, radix, result, <unused> let chars_read)
end

proc parse(str: string, radix: int, result: out float64) => bool = do

end

proc parse_int(str: string, radix: int) => {value: int, chars_read: int, ok: bool} = do
    return {
        value = 0
        chars_read = 0
        ok = false
    }
end

proc main = do
    let num = do
        let res = parse("asdasd", 10)
        if res.ok then
            compute res.value
        else
            compute 0
        end
    end
end

fun main = do
    let x = do
        let n = 10
        for range 0,n do |i|
            if i == 5 then
                compute i
            end
        end
        compute 0
    end
end