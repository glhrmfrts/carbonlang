import "rt"

fun read_entire_file(filename: string) ?=> string = do
    let file = open(filename, open_flags.read, 0)
    defer close(file)

    let statbuf = stat(file)
    let data = make_array(byte, statbuf.size)
    read(file, data)
    return data
end

fun main = do
    try
        let contents = read_entire_file()
        defer free_array(contents)

        let tokens = primitive_lex(contents)
        for range 0, tokens.len do |i|
            let tok = tokens[i]
            print_token(tok)
        end

        let root = parse(tokens)
    catch |err|
        if err == LexError then
            print(lex_err_position, lex_err_message)
            return
        else if err == ParseError then
            print(parse_err_position, parse_err_message)
            return
        else
            panic(err)
        end
    end
end