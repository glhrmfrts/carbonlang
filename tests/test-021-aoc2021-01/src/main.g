import "rt"

fun is_numeric(c: byte) => bool = do
    return c >= '0' and c <= '9'
end

fun trim_non_numeric(s: string) => string = do
    let count : int
    for range 0,s.len do |i|
        if is_numeric(s[i]) then break end
        count = _ + 1
    end

    let res = s
    res.ptr = cast(&pure byte) cast(opaque) (cast(uintptr) _ + cast(uintptr) count)
    res.len = _ - count
    res.cap = _ - count
    return res
end

fun to_int(s: string, radix: int, num: out int, rest: out string) => bool = do
    let value : int
    let count : int

    for range 0,s.len do |i|
        if is_numeric(s[i]) then
            value = _ * radix + cast(int)(s[i] + '0')
            count = _ + 1
        else
            break
        end
    end

    num = value

    rest = s
    rest.ptr = cast(&pure byte) cast(opaque) (cast(uintptr) _ + cast(uintptr) count)
    rest.len = _ - count
    rest.cap = _ - count

    return count > 0
end

fun main = do
    let file : file_handle
    defer close(file)

    if open(file, "aoc01.txt", open_flags.read, 0) then |err|
        putln("open error: ", err)
        return
    end

    let statbuf : stat_type
    if stat(file, statbuf) then |err|
        putln("stat error: ", err)
        return
    end

    let data : array of byte
    resize(data, statbuf.size)
    defer free_array(data)

    if read(file, data) then |err|
        putln("read error: ", err)
        return
    end

    let numbers : array of int
    defer free_array(numbers)

    for data.len > 0 do
        data = trim_non_numeric(data)

        let num : int
        let rest : string
        if to_int(data, 10, num, rest) then
            append(numbers, num)
            data = rest
            num = _ + 1
        else
            break
        end
    end

    let inc_count : int
    let sum_inc_count : int

-- part 1
    for range 1,numbers.len do |i|
        if numbers[i] > numbers[i - 1] then
            inc_count = _ + 1
        end
    end

    putln("increase count: ", inc_count)

-- part 2
    let sums : array of int
    defer free_array(sums)

    for range 0,numbers.len - 2 do |i|
        append(sums, numbers[i] + numbers[i + 1] + numbers[i + 2])
    end

    for range 1,numbers.len - 2 do |i|
        if sums[i] > sums[i - 1] then
            sum_inc_count = _ + 1
        end
    end

    putln("sum increase count: ", sum_inc_count)
end