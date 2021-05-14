#pragma once

#include <string>
#include "carbonc.hh"
#include "token.hh"

namespace carbon {

struct lexer_impl;

struct lexer {
    lexer_impl* _impl;

    explicit lexer(std::string_view);

    ~lexer();

    token_type current() const;

    token_type next();

    std::string string_value();

    float_type float_value();

    int_type int_value();

    position pos();
};

}