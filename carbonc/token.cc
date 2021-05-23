#include <unordered_map>
#include "token.hh"

namespace carbon {

constexpr int BINARY_OP = 1;
constexpr int UNARY_OP = 2;
constexpr int RIGHT_ASSOC = 4;

struct token_properties {
    int flags = 0;
    int precedence = 0;
};

static std::unordered_map<token_type, token_properties> token_props = {
    {token_type::not, { UNARY_OP, 0 }},

    {token_from_char('='), { BINARY_OP, 400 }},

    {token_type::or, { BINARY_OP, 490 }},
    {token_type::and, { BINARY_OP, 500 }},

    {token_from_char('|'), { BINARY_OP, 580 }},
    {token_from_char('^'), { BINARY_OP, 590 }},
    {token_from_char('&'), { BINARY_OP | UNARY_OP, 600 }},

    {token_type::eqeq, { BINARY_OP, 700 }},
    {token_type::neq, { BINARY_OP, 700 }},

    {token_from_char('>'), { BINARY_OP, 800 }},
    {token_type::gteq, { BINARY_OP, 800 }},
    {token_from_char('<'), { BINARY_OP, 800 }},
    {token_type::lteq, { BINARY_OP, 800 }},

    {token_type::shl, { BINARY_OP, 900 }},
    {token_type::shr, { BINARY_OP, 900 }},
    
    {token_from_char('+'), { BINARY_OP, 1000 }},
    {token_from_char('-'), { BINARY_OP | UNARY_OP, 1000 }},

    {token_from_char('*'), { BINARY_OP | UNARY_OP, 1100 }},
    {token_from_char('/'), { BINARY_OP, 1100 }},
    {token_from_char('%'), { BINARY_OP, 1100 }},
};

bool is_unary_op(token_type t) {
    return token_props[t].flags & UNARY_OP;
}

bool is_binary_op(token_type t) {
    return token_props[t].flags & BINARY_OP;
}

bool is_right_assoc(token_type t) {
    return token_props[t].flags & RIGHT_ASSOC;
}

int precedence(token_type t) {
    return token_props[t].precedence;
}

int precedence_cmp(token_type a, token_type b) {
    return (token_props[a].precedence - token_props[b].precedence);
}

token_type token_from_char(char c) {
    return token_type{(unsigned int)c};
}

char token_to_char(token_type t) {
    return (char)static_cast<unsigned int>(t);
}

}