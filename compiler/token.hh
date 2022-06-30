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
    placeholder,
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
    fun,
    then,
    return_,
    compute,
    extern_,
    const_,
    catch_,
    macro,
    local,
    error,
    range,
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
    array_,
    arrayview_,
    coloncolon,
    coloneq,
    dotdot,
    dotdotdot,
    discard,
    nil,
    nullptr_,
    defer,
    continue_,
    break_,
    arrow_right, // ->
    double_arrow_right, // =>
    struct_,
    enum_,
    enumflags,
    enumerror,
    noinit,
    of_,
    do_,
    out,    
    end,
    assert_,
    plus_assign,
    minus_assign,
    mul_assign,
    div_assign,
    shl_assign,
    shr_assign,
    and_assign,
    or_assign
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

bool is_arith_binary_op(token_type t);

bool is_cmp_binary_op(token_type t);

bool is_right_assoc(token_type t);

bool is_assignment_sugar_op(token_type t);

int precedence(token_type t);

int precedence_cmp(token_type a, token_type b);

char token_to_char(token_type t);

constexpr token_type token_from_char(char c) {
    return token_type{ (unsigned int)c };
}

inline bool token_is_char(token_type t, char c) { return t == token_from_char(c); }

}