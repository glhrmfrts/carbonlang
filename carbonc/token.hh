#pragma once

namespace carbon {

enum class token_type : unsigned int {
    eof = 256,
    bool_literal_false,
    bool_literal_true,
    float_literal,
    int_literal,
    string_literal,
    identifier,
    not,
    and,
    or,
    eqeq,
    neq,
    gteq,
    lteq,
    shl,
    shr,
    let,
    var,
    func,
    return_,
    extern_,
    const_,
    pure,
    type,
    asm_,
    private_,
    public_,
    internal_,
    import_,
    as_,
    coloncolon,
};

struct position {
    std::size_t src_offs;
    int line_number;
    int col_offs;
};

bool is_unary_op(token_type t);

bool is_binary_op(token_type t);

bool is_right_assoc(token_type t);

int precedence(token_type t);

int precedence_cmp(token_type a, token_type b);

token_type token_from_char(char c);

char token_to_char(token_type t);

inline bool token_is_char(token_type t, char c) { return t == token_from_char(c); }

}