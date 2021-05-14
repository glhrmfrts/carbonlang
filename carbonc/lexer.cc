#include <array>
#include <unordered_map>
#include "lexer.hh"

#define STB_C_LEXER_IMPLEMENTATION
#include <stb_c_lexer.h>

namespace carbon {

static std::unordered_map<int, token_type> stb_to_token = {
    {CLEX_eof, token_type::eof},
    {CLEX_id, token_type::identifier},
    {CLEX_intlit, token_type::int_literal},
    {CLEX_floatlit, token_type::float_literal},
    {CLEX_dqstring, token_type::string_literal},
};

struct lexer_impl {
    std::array<char, 1024*1024> store;
    std::string_view src;
    stb_lexer l;
    token_type tok;

    explicit lexer_impl(std::string_view _src) : src{_src} {
        stb_c_lexer_init(&l, src.data(), src.data() + src.size(), store.data(), store.size());
        tok = next();
    }

    token_type current() const {
        return tok;
    }

    token_type next() {
        if (!stb_c_lexer_get_token(&l)) {
            return (tok = token_type::eof);
        }
        return (tok = transform_c_lexer_token(l.token));
    }

    token_type transform_c_lexer_token(int ct) const {
        switch (ct) {
        case CLEX_id:
            return transform_c_lexer_identifier();
        }

        auto it = stb_to_token.find(ct);
        if (it != stb_to_token.end()) return it->second;

        return token_from_char(char(ct));
    }

    token_type transform_c_lexer_identifier() const {
        switch (l.string_len) {
        case 3:
            if (!std::strcmp("let", l.string)) {
                return token_type::let;
            }
            if (!std::strcmp("var", l.string)) {
                return token_type::var;
            }
            break;
        case 4:
            if (!std::strcmp("func", l.string)) {
                return token_type::func;
            }
            if (!std::strcmp("true", l.string)) {
                return token_type::bool_literal_true;
            }
            if (!std::strcmp("type", l.string)) {
                return token_type::type;
            }
            break;
        case 5:
            if (!std::strcmp("false", l.string)) {
                return token_type::bool_literal_false;
            }
            if (!std::strcmp("const", l.string)) {
                return token_type::const_;
            }
            break;
        case 6:
            if (!std::strcmp("return", l.string)) {
                return token_type::return_;
            }
            break;
        }
        return token_type::identifier;
    }

    std::string string_value() {
        return std::string{ l.string, std::size_t(l.string_len) };
    }

    float_type float_value() {
        return l.real_number;
    }

    int_type int_value() {
        return l.int_number;
    }

    position pos() {
        return { (std::size_t)(uintptr_t)(l.parse_point - l.input_stream), l.line_number, l.col_offs + 1 };
    }
};

lexer::lexer(std::string_view src) : _impl{ new lexer_impl{src} } {
}

lexer::~lexer() { delete _impl; }

token_type lexer::current() const { return _impl->current(); }

token_type lexer::next() { return _impl->next(); }

std::string lexer::string_value() { return _impl->string_value(); }

float_type lexer::float_value() { return _impl->float_value(); }

int_type lexer::int_value() { return _impl->int_value(); }

position lexer::pos() { return _impl->pos(); }

}