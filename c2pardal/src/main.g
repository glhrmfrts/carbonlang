fun read_entire_file(filename: string) ? => string = do
    let file = open(filename, open_flags.read, 0)
    defer close(file)

    let data : array of byte; resize(data, stat(file).size)
    read(file, data)
    return data
end

fun temp_wrapper() ? = do
    let contents = read_entire_file("tesdasst.c")
    defer free_array(contents)

    let tokens = primitive_lex(contents)
    for range 0, tokens.len do |i|
        let tok = tokens[i]
        print_token(tok)
    end
end

fun main = do
    let err = temp_wrapper()?
    if err /= nil then
        putln("error: ", err)
    end
end