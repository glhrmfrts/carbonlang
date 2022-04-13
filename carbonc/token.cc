#include <unordered_map>
#include "token.hh"

namespace carbon {

constexpr int BINARY_OP = 1;
constexpr int UNARY_OP = 2;
constexpr int RIGHT_ASSOC = 4;
constexpr int ASSIGN_SUGAR = 8;

struct token_properties {
    int flags = 0;
    int precedence = 0;
};

static std::unordered_map<token_type, token_properties> token_props = {
    {token_from_char('!'), { UNARY_OP, 0 }},
    {token_from_char('@'), { UNARY_OP, 0 }},

    {token_from_char('='), { BINARY_OP, 400 }},
    {token_type::plus_assign, { BINARY_OP | ASSIGN_SUGAR, 400 }},
    {token_type::minus_assign, { BINARY_OP | ASSIGN_SUGAR, 400 }},
    {token_type::mul_assign, { BINARY_OP | ASSIGN_SUGAR, 400 }},
    {token_type::div_assign, { BINARY_OP | ASSIGN_SUGAR, 400 }},
    {token_type::and_assign, { BINARY_OP | ASSIGN_SUGAR, 400 }},
    {token_type::or_assign, { BINARY_OP | ASSIGN_SUGAR, 400 }},
    {token_type::shl_assign, { BINARY_OP | ASSIGN_SUGAR, 400 }},
    {token_type::shr_assign, { BINARY_OP | ASSIGN_SUGAR, 400 }},

    {token_type::oror, { BINARY_OP, 490 }},
    {token_type::andand, { BINARY_OP, 500 }},

    {token_type::dotdot, { BINARY_OP, 550 }},

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

    {token_from_char('*'), { BINARY_OP, 1100 }},
    {token_from_char('/'), { BINARY_OP, 1100 }},
    {token_from_char('%'), { BINARY_OP, 1100 }},

    {token_type::arrow_right, { BINARY_OP, 1200 }},
};

bool is_unary_op(token_type t) {
    return token_props[t].flags & UNARY_OP;
}

bool is_binary_op(token_type t) {
    return token_props[t].flags & BINARY_OP;
}

bool is_logic_binary_op(token_type t) {
    return (t == token_type::andand || t == token_type::oror);
}

bool is_cmp_binary_op(token_type t) {
    switch (token_to_char(t)) {
    case '>':
    case '<':
        return true;
    }

    switch (t) {
    case token_type::gteq:
    case token_type::lteq:
    case token_type::eqeq:
    case token_type::neq:
        return true;
    }

    return false;
}

bool is_right_assoc(token_type t) {
    return token_props[t].flags & RIGHT_ASSOC;
}

bool is_assignment_sugar_op(token_type t) {
    return token_props[t].flags & ASSIGN_SUGAR;
}

int precedence(token_type t) {
    return token_props[t].precedence;
}

int precedence_cmp(token_type a, token_type b) {
    return (token_props[a].precedence - token_props[b].precedence);
}

char token_to_char(token_type t) {
    auto it = static_cast<unsigned int>(t);
    if (it >= 256) {
        return 0;
    }
    return (char)it;
}

}