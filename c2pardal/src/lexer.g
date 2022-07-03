import "rt"

-- TODO: init expressions should go back to generate assignments

type TokenType = enum (Invalid; Char; Identifier; StringLiteral; IntLiteral; Whitespace)

type Token = struct of
    token_type      : TokenType

    -- if token_type == Identifier|StringLiteral
    string_value    : string

    -- if token_type == IntLiteral
    int_value       : int

    -- if token_type == Char
    char            : byte
end

type Lexer = struct of
    src : string
    offs : int
end

fun is_numeric(c: byte) => bool = do
    --putln("\tis_numeric: ", c)
    return c >= '0' and c <= '9'
end

-- TODO: validate all paths return something

fun is_identifier_starter(c: byte) => bool = do
    --putln("\tis_identifier_starter: ", c)
    let res = (c >= 'A' and c <= 'Z') or (c >= 'a' and c <= 'z') or (c == '_')
    return res
end

fun is_identifier_char(c: byte) => bool = do
    return (c >= 'A' and c <= 'Z') or (c >= 'a' and c <= 'z') or (c == '_')
end

fun is_whitespace(c: byte) => bool = do
    --putln("\tis_whitespace: ", c)
    return (c == ' ') or (c == '\n')
end

macro C = l.src[l.offs]

fun lex_number(l: in out Lexer) => Token = do
    let res : Token
    return res
end

fun lex_identifier(l: in out Lexer) => Token = do
    let val : string
    for is_identifier_char(C()) do
        append(val, C())
        l.offs = _ + 1
    end
    let res : Token
    res.token_type = TokenType.Identifier
    res.string_value = val
    --putln("lex_identifier: ", val)
    return res
end

fun lex_string_literal(l: in out Lexer) => Token = do
    let res : Token
    return res
end

fun lex_whitespace(l: in out Lexer) = do
    for is_whitespace(C()) do
        l.offs = _ + 1
    end
end

fun lex_char(l: in out Lexer) => Token = do
    let res : Token
    res.token_type = TokenType.Char
    res.char = l.src[l.offs]
    l.offs = _ + 1
    return res
end

fun lex_chars(l: in out Lexer, num: int, token_type: TokenType) => Token = do
    l.offs = _ + num

    let res : Token
    res.token_type = token_type
    return res
end

fun is_quote(l: in out Lexer) => bool = do
    --putln("\tis_quote: ", C())
    return C() == '"'
end

fun is_left_paren(l: in out Lexer) => bool = do
    --putln("\tis_left_paren: ", C())
    return C() == '('
end

fun is_right_paren(l: in out Lexer) => bool = do
    --putln("\tis_right_paren: ", C())
    return C() == ')'
end

fun is_left_brace(l: in out Lexer) => bool = do
    --putln("\tis_left_brace: ", C())
    return C() == '{'
end

fun is_right_brace(l: in out Lexer) => bool = do
    --putln("\tis_right_brace: ", C())
    return C() == '}'
end

fun lex_token(l: in out Lexer) => Token = do
    --putln(C(), " ", l.offs)
    if is_quote(l) then
        return lex_string_literal(l)
    else if is_left_paren(l) then
        return lex_char(l)
    else if is_right_paren(l) then
        return lex_char(l)
    else if is_left_brace(l) then
        return lex_char(l)
    else if is_right_brace(l) then
        return lex_char(l)
    else if is_whitespace(l.src[l.offs]) then
        lex_whitespace(l)
        let res : Token
        res.token_type = TokenType.Whitespace
        return res
    else if is_numeric(l.src[l.offs]) then
        return lex_number(l)
    else if is_identifier_starter(l.src[l.offs]) then
        return lex_identifier(l)
    else
        let res : Token
        return res
    end
end

fun print_token(tok: Token) = do
    --putln(cast(int)tok.token_type)
    if tok.token_type == TokenType.Char then
        putln("char: ", tok.char)
    else if tok.token_type == TokenType.Identifier then
        putln("identifier: ", tok.string_value)
    else if tok.token_type == TokenType.IntLiteral then
        putln("int_literal: ", tok.int_value)
    else if tok.token_type == TokenType.StringLiteral then
        putln("string_literal: ", tok.string_value)
    else if tok.token_type == TokenType.Invalid then
        putln("invalid")
    else if tok.token_type == TokenType.Whitespace then
        putln("whitespace")
    end
end

fun primitive_lex(src: string) => array of Token = do
    let res : array of Token
    let l : Lexer = {}
    l.src = src
    l.offs = 0
    let i = 0
    for l.offs < l.src.len do
        append(res, lex_token(l))
        if i > 20 then
            break
        end
        i = _ + 1
    end
    return res
end