import "rt"

fun read_entire_file(filename: string, contents: out string) => error = do
    -- Declare a file_handle object that will contain the handle to the file
    let file: file_handle

    -- Automatically close the file when the current block exits.
    -- 'close' may return an error but we don't care, so we 'discard' the result
    defer close(file)

    -- Opens the file specified by the filename, opening the file can fail, so handle any errors
    if open(file, filename, open_flags.read, 0) then |err|
        putln("open error: ", err)
        return err
    end

    -- Get the file 'stat' data
    let statbuf : stat_type
    if stat(file, statbuf) then |err|
        putln("stat error: ", err)
        return err
    end

    -- Create an array with enough space for the entire file
    let data : array of byte; resize(data, statbuf.size)

    -- Read the file into the data array and handle any errors
    if read(file, data) then |err|
        putln("read error: ", err)
        return err
    end

    -- Assign the file data to the out parameter
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