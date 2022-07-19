#include <array>
#include <unordered_map>
#include <cstring>
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
    {CLEX_coloneq, token_type::coloneq},
    {CLEX_dotdot, token_type::dotdot},
    {CLEX_dotdotdot, token_type::dotdotdot},
    {CLEX_eq, token_type::eqeq},
    {CLEX_noteq, token_type::neq},
    {CLEX_greatereq, token_type::gteq},
    {CLEX_lesseq, token_type::lteq},
    {CLEX_andand, token_type::andand},
    {CLEX_oror, token_type::oror},
    {CLEX_arrow, token_type::arrow_right},
    {CLEX_eqarrow, token_type::double_arrow_right},
    {CLEX_diveq, token_type::div_assign},
    {CLEX_pluseq, token_type::plus_assign},
    {CLEX_minuseq, token_type::minus_assign},
    {CLEX_muleq, token_type::mul_assign},
    {CLEX_shl, token_type::shl},
    {CLEX_shr, token_type::shr},
    {CLEX_shleq, token_type::shl_assign},
    {CLEX_shreq, token_type::shr_assign},
    {CLEX_oreq, token_type::or_assign},
    {CLEX_andeq, token_type::and_assign}
};

struct lexer_impl {
    std::array<char, 1024*1024> store;
    std::string_view src;
    std::string long_string;
    std::string filename;
    stb_lexer l;
    token_type tok;
    token_type saved_token;
    char* saved_parse_point;

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

    char* parse_point() const {
        return l.parse_point;
    }

    void set_parse_point(char* pp) {
        l.parse_point = pp;
    }

    void save() {
        saved_parse_point = l.parse_point;
        saved_token = current();
    }

    void restore() {
        l.parse_point = saved_parse_point;
        tok = saved_token;
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
        case 1:
            if (!std::strcmp("_", l.string)) {
                return token_type::placeholder;
            }
        case 2:
            if (!std::strcmp("as", l.string)) {
                return token_type::as_;
            }
            if (!std::strcmp("if", l.string)) {
                return token_type::if_;
            }
            if (!std::strcmp("in", l.string)) {
                return token_type::in_;
            }
            if (!std::strcmp("of", l.string)) {
                return token_type::of_;
            }
            if (!std::strcmp("do", l.string)) {
                return token_type::do_;
            }
            if (!std::strcmp("or", l.string)) {
                return token_type::oror;
            }
            break;
        case 3:
            if (!std::strcmp("let", l.string)) {
                return token_type::let;
            }
            if (!std::strcmp("asm", l.string)) {
                return token_type::asm_;
            }
            if (!std::strcmp("for", l.string)) {
                return token_type::for_;
            }
            if (!std::strcmp("nil", l.string)) {
                return token_type::nil;
            }
            if (!std::strcmp("out", l.string)) {
                return token_type::out;
            }
            if (!std::strcmp("fun", l.string)) {
                return token_type::fun;
            }
            if (!std::strcmp("end", l.string)) {
                return token_type::end;
            }
            if (!std::strcmp("and", l.string)) {
                return token_type::andand;
            }
            if (!std::strcmp("not", l.string)) {
                return token_type::not_;
            }
            break;
        case 4:
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
            if (!std::strcmp("then", l.string)) {
                return token_type::then;
            }
            if (!std::strcmp("enum", l.string)) {
                return token_type::enum_;
            }
            if (!std::strcmp("pure", l.string)) {
                return token_type::pure;
            }
            break;
        case 5:
            if (!std::strcmp("range", l.string)) {
                return token_type::range;
            }
            if (!std::strcmp("array", l.string)) {
                return token_type::array_;
            }
            if (!std::strcmp("false", l.string)) {
                return token_type::bool_literal_false;
            }
            if (!std::strcmp("defer", l.string)) {
                return token_type::defer;
            }
            if (!std::strcmp("break", l.string)) {
                return token_type::break_;
            }
            if (!std::strcmp("const", l.string)) {
                return token_type::const_;
            }
            if (!std::strcmp("error", l.string)) {
                return token_type::error;
            }
            if (!std::strcmp("local", l.string)) {
                return token_type::local;
            }
            if (!std::strcmp("catch", l.string)) {
                return token_type::catch_;
            }
            if (!std::strcmp("macro", l.string)) {
                return token_type::macro;
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
            if (!std::strcmp("struct", l.string)) {
                return token_type::struct_;
            }
            if (!std::strcmp("noinit", l.string)) {
                return token_type::noinit;
            }
            if (!std::strcmp("assert", l.string)) {
                return token_type::assert_;
            }
            if (!std::strcmp("import", l.string)) {
                return token_type::import_;
            }
            if (!std::strcmp("export", l.string)) {
                return token_type::export_;
            }
            break;
        case 7:
            if (!std::strcmp("private", l.string)) {
                return token_type::private_;
            }
            if (!std::strcmp("compute", l.string)) {
                return token_type::compute;
            }
            if (!std::strcmp("discard", l.string)) {
                return token_type::discard;
            }
            break;
        case 8:
            if (!std::strcmp("internal", l.string)) {
                return token_type::internal_;
            }
            if (!std::strcmp("continue", l.string)) {
                return token_type::continue_;
            }
        case 9:
            if (!std::strcmp("typealias", l.string)) {
                return token_type::typealias;
            }
            if (!std::strcmp("enumflags", l.string)) {
                return token_type::enumflags;
            }
            if (!std::strcmp("enumerror", l.string)) {
                return token_type::enumerror;
            }
            if (!std::strcmp("arrayview", l.string)) {
                return token_type::arrayview_;
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

    comp_float_type float_value() {
        return l.real_number;
    }

    comp_int_type int_value() {
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

char* lexer::parse_point() const { return _impl->parse_point(); }

void lexer::set_parse_point(char* pp) { _impl->set_parse_point(pp); }

void lexer::save() { _impl->save(); }

void lexer::restore() { _impl->restore(); }

std::string lexer::string_value() { return _impl->string_value(); }

std::string lexer::long_string_value() { return _impl->long_string_value(); }

comp_float_type lexer::float_value() { return _impl->float_value(); }

comp_int_type lexer::int_value() { return _impl->int_value(); }

position lexer::pos() { return _impl->pos(); }

}