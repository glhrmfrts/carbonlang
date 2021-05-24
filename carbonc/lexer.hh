#pragma once

#include <string>
#include "carbonc.hh"
#include "token.hh"

namespace carbon {

struct lexer_impl;

struct lexer {
    lexer_impl* _impl;

    explicit lexer(std::string_view, std::string);

    ~lexer();

    token_type current() const;

    token_type next();

    void advance_char(std::size_t count);

    void consume_string_until(const char* chars);

    std::string string_value();

    std::string long_string_value();

    float_type float_value();

    int_type int_value();

    position pos();
};

}