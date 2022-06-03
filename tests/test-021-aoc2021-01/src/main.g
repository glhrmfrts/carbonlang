import rt

local macro ensure_capacity(parr) := do
    if parr.len >= parr.cap then
        let newcap := 8
        if parr.cap /= 0 then newcap := parr.cap * 2 end
        make_array_ptr(parr, parr.len, newcap)
    end
end

macro append(arr, elem) := do
    let parr := &arr
    parr.len := _ + 1
    ensure_capacity(parr)
    arr[arr.len] := elem
end

fun count_lines(s : string) => int := do
    let count : int
    for i := range 0,s.len do
        if s[i] = '\n' then
            count := _ + 1
        end
    end
    return count
end

fun is_numeric(c : byte) => bool := do
    return c >= '0' and c <= '9'
end

fun trim_non_numeric(s : string) => string := do
    let count : int
    for i := range 0,s.len do
        if isNumeric(s[i]) then break end
        count := _ + 1
    end
    return string{s.ptr + count, s.len - count, s.cap - count}
end

fun to_int(s : string, radix : int, num : out int, rest : out string) => bool := do
    let value : int
    let count : int

    for i := range 0,s.len do
        if is_numeric(s[i]) then
            value := _ * radix + cast(int)(s[i] + '0')
            count := _ + 1
        else
            break
        end
    end

    num := value
    rest := string{ s.ptr + count, s.len - count, s.cap - count }
    return count > 0
end

fun main := do
    let file : file_handle
    defer close(file)

    if open(file, "aoc01.txt", nil, 0) then |err|
        putln("open error: ", err)
        return
    end

    let statbuf : stat_type
    if stat(file, statbuf) then |err|
        putln("stat error: ", err)
        return
    end

    let data : array of byte
    make_array(data, statbuf.size)
    defer free_array(data)

    if read(file, data) then |err|
        putln("read error: ", err)
        return
    end

    let numbers : array of int
    defer free_array(numbers)

    for data.len > 0 do
        data := trim_non_numeric(data)
        
        let num : int
        let rest : string
        if to_int(data, 10, num, rest) then
            append(numbers, num)
            data := rest
            num := _ + 1
        else
            break
        end
    end

    let inc_count : int
    let sum_inc_count : int

-- part 1
    for i := range 1,numbers.len do
        if numbers[i] > numbers[i - 1] then
            inc_count := _ + 1
        end
    end

    putln("increase count: ", inc_count)

-- part 2
    let sums : array of int
    defer free_array(sums)

    for range 0,numbers.len do |i|
        if i < numbers.len - 2 then
            append(sums, numbers[i] + numbers[i + 1] + numbers[i + 2])
        end
    end

    for range 1,numbers.len do |i|
        if sums[i] > sums[i - 1] then
            sum_inc_count := _ + 1
        end
    end

    putln("sum increase count: ", sum_inc_count)

    return
end