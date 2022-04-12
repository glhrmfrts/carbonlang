#pragma once

namespace carbon {

enum class token_type : unsigned int {
    eof = 256,
    bool_literal_false,
    bool_literal_true,
    float_literal,
    int_literal,
    char_literal,
    string_literal,
    identifier,
    not_,
    andand,
    oror,
    eqeq,
    neq,
    gteq,
    lteq,
    shl,
    shr,
    band,
    bor,
    bxor,
    bnot,
    let,
    auto_,
    func,
    then,
    return_,
    extern_,
    const_,
    pure,
    type,
    typealias,
    asm_,
    private_,
    public_,
    internal_,
    import_,
    export_,
    as_,
    in_,
    cast_,
    if_,
    else_,
    for_,
    while_,
    coloncolon,
    dotdot,
    nil,
    nullptr_,
    defer,
    continue_,
    break_,
    arrow_right, // ->
    double_arrow_right, // =>
    struct_,
    plus_assign,
    minus_assign,
    mul_assign,
    div_assign,
};

struct position {
    std::string filename;
    std::size_t src_offs;
    int line_number;
    int col_offs;
};

constexpr char DEREF_OP = '@';
constexpr char ADDR_OP = '&';

bool is_unary_op(token_type t);

bool is_binary_op(token_type t);

bool is_logic_binary_op(token_type t);

bool is_cmp_binary_op(token_type t);

bool is_right_assoc(token_type t);

int precedence(token_type t);

int precedence_cmp(token_type a, token_type b);

token_type token_from_char(char c);

char token_to_char(token_type t);

inline bool token_is_char(token_type t, char c) { return t == token_from_char(c); }

}