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
    {CLEX_charlit, token_type::char_literal},
    {CLEX_dqstring, token_type::string_literal},
    {CLEX_coloncolon, token_type::coloncolon},
    {CLEX_eq, token_type::eqeq},
    {CLEX_noteq, token_type::neq},
    {CLEX_greatereq, token_type::gteq},
    {CLEX_lesseq, token_type::lteq},
    {CLEX_andand, token_type::andand},
    {CLEX_oror, token_type::oror}
};

struct lexer_impl {
    std::array<char, 1024*1024> store;
    std::string_view src;
    std::string long_string;
    std::string filename;
    stb_lexer l;
    token_type tok;

    explicit lexer_impl(std::string_view _src, std::string fn) : src{ _src }, filename{ fn } {
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

    void advance_char(std::size_t count) {
        l.parse_point += count;
    }

    void consume_string_until(const char* chars) {
        enum { LIMIT = 0xffffff };

        std::size_t len = std::strlen(chars);
        long_string.clear();

        char* begin = l.parse_point;
        char* end = nullptr;

        for (int i = 0; i < LIMIT; i++) {
            char* before = l.parse_point;

            if (!(*l.parse_point)) {
                // TODO: error
                break;
            }

            if (*l.parse_point == chars[0]) {
                l.parse_point++;

                bool all_equal = true;
                for (int ci = 1; ci < len; ci++) {
                    if (*l.parse_point != chars[ci]) {
                        all_equal = false;
                        break;
                    }
                    else {
                        l.parse_point++;
                    }
                }

                if (all_equal) {
                    end = l.parse_point - len;
                    break;
                }
                else {
                    l.parse_point = before;
                }
            }
            l.parse_point++;
        }

        if (end != nullptr) {
            long_string.append(begin, end - begin);
        }
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
        case 2:
            if (!std::strcmp("as", l.string)) {
                return token_type::as_;
            }
            if (!std::strcmp("if", l.string)) {
                return token_type::if_;
            }
            break;
        case 3:
            if (!std::strcmp("let", l.string)) {
                return token_type::let;
            }
            if (!std::strcmp("var", l.string)) {
                return token_type::var;
            }
            if (!std::strcmp("asm", l.string)) {
                return token_type::asm_;
            }
            if (!std::strcmp("for", l.string)) {
                return token_type::for_;
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
            if (!std::strcmp("cast", l.string)) {
                return token_type::cast_;
            }
            if (!std::strcmp("else", l.string)) {
                return token_type::else_;
            }
            break;
        case 5:
            if (!std::strcmp("false", l.string)) {
                return token_type::bool_literal_false;
            }
            if (!std::strcmp("const", l.string)) {
                return token_type::const_;
            }
            if (!std::strcmp("while", l.string)) {
                return token_type::while_;
            }
            break;
        case 6:
            if (!std::strcmp("return", l.string)) {
                return token_type::return_;
            }
            if (!std::strcmp("extern", l.string)) {
                return token_type::extern_;
            }
            if (!std::strcmp("public", l.string)) {
                return token_type::public_;
            }
            if (!std::strcmp("import", l.string)) {
                return token_type::import_;
            }
            break;
        case 7:
            if (!std::strcmp("private", l.string)) {
                return token_type::private_;
            }
            break;
        case 8:
            if (!std::strcmp("internal", l.string)) {
                return token_type::internal_;
            }
            break;
        }
        return token_type::identifier;
    }

    std::string string_value() {
        return std::string{ l.string, std::size_t(l.string_len) };
    }

    std::string long_string_value() {
        return long_string;
    }

    float_type float_value() {
        return l.real_number;
    }

    int_type int_value() {
        return l.int_number;
    }

    position pos() {
        return { filename, (std::size_t)(uintptr_t)(l.parse_point - l.input_stream), l.line_number, l.col_offs + 1 };
    }
};

lexer::lexer(std::string_view src, std::string filename) : _impl{ new lexer_impl{src, filename} } {
}

lexer::~lexer() { delete _impl; }

token_type lexer::current() const { return _impl->current(); }

token_type lexer::next() { return _impl->next(); }

void lexer::advance_char(std::size_t count) { _impl->advance_char(count); }

void lexer::consume_string_until(const char* chars) { _impl->consume_string_until(chars); }

std::string lexer::string_value() { return _impl->string_value(); }

std::string lexer::long_string_value() { return _impl->long_string_value(); }

float_type lexer::float_value() { return _impl->float_value(); }

int_type lexer::int_value() { return _impl->int_value(); }

position lexer::pos() { return _impl->pos(); }

}