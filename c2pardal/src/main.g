import "rt"

fun read_entire_file(filename: string, contents: out string) => error = do
    let file: file_handle
    defer close(file)

    if open(file, filename, open_flags.read, 0) then |err|
        putln("open error: ", err)
        return err
    end

    let statbuf : stat_type
    if stat(file, statbuf) then |err|
        putln("stat error: ", err)
        return err
    end

    let data : array of byte
    resize(data, statbuf.size)

    if read(file, data) then |err|
        putln("read error: ", err)
        return err
    end

    contents = data
    return nil
end

fun main = do
    let contents : string
    if read_entire_file("test.c", contents) then |err|
        putln("cannot read input file: ", err)
        return
    end

    let tokens = primitive_lex(contents)
    for range 0, tokens.len do |i|
        let tok = tokens[i]
        print_token(tok)
    end
end