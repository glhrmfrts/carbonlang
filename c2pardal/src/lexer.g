import "rt"

-- TODO: init expressions should go back to generate assignments

type TokenType = enum (
    Identifier
    StringLiteral
    IntLiteral
    LeftParen
    RightParen
    LeftBrace
    RightBrace
)

type Token = struct of
    token_type : TokenType
    string_value : string
    int_value : int
end

type Lexer = struct of
    src : string
    offs : int
end

fun is_numeric(c: byte) => bool = do
    return c >= '0' and c <= '9'
end

-- TODO: validate all paths return something
-- TODO: init expressions are buggy
-- TODO: boolean operations are buggy

fun is_identifier_starter(c: byte) => bool = do
    let res = (c >= 'A' and c <= 'Z') or (c >= 'a' and c <= 'z') -- or (c == '_')
    --putln(c, " ", (c >= 'A' and c <= 'Z'), " ", (c >= 'a' and c <= 'z'), " ", (c == '_'), "  ", res)
    return res
end

fun is_identifier_char(c: byte) => bool = do
    return (c >= 'A' and c <= 'Z') or (c >= 'a' and c <= 'z') -- or (c == '_')
end

fun is_whitespace(c: byte) => bool = (c == ' ') or (c == '\t')

-- TODO: use this macro without parenthress
macro C = l.src[l.offs]

fun lex_number(l: in out Lexer) => Token = do
    return Token{}
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
    putln("lex_identifier: ", val)
    return res
end

fun lex_string_literal(l: in out Lexer) => Token = do
    return Token{}
end

fun lex_whitespace(l: in out Lexer) = do
    for is_whitespace(C()) do
        l.offs = _ + 1
    end
end

fun lex_chars(l: in out Lexer, num: int, token_type: TokenType) => Token = do
    l.offs = _ + num

    let res : Token
    res.token_type = token_type
    return res
end

fun lex_token(l: in out Lexer) => Token = do
    putln(C())
    if C() == '"' then
        return lex_string_literal(l)
    else if C() == '(' then
        putln("(")
        return lex_chars(l, 1, TokenType.LeftParen)
    else if C() == ')' then
        putln(")")
        return lex_chars(l, 1, TokenType.RightParen)
    else if C() == '{' then
        putln("{")
        return lex_chars(l, 1, TokenType.LeftBrace)
    else if C() == '}' then
        putln("}")
        return lex_chars(l, 1, TokenType.RightBrace)
    else if is_numeric(C()) then
        putln("lex_number")
        return lex_number(l)
    else if is_identifier_starter(C()) then
        putln("lex_identifier")
        return lex_identifier(l)
    else if is_whitespace(C()) then
        putln("lex_whiespace")
        lex_whitespace(l)
        return Token{}
    else
        putln("nothign")
        return Token{}
    end
end

fun lex(src: string) => array of Token = do
    let res : array of Token
    let l : Lexer = {}
    l.src = src
    l.offs = 0
    for l.offs < l.src.len do
        append(res, lex_token(l))
        l.offs = _ + 1
        --putln(l.offs)
    end
    return res
end