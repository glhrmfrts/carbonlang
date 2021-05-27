#include <stack>
#include "parser.hh"
#include "lexer.hh"
#include "memory.hh"
#include "common.hh"
#include "exception.hh"
#include <set>
#include <optional>

namespace carbon {

#define TOK      (lex->current())
#define TOK_CHAR token_to_char(TOK)

enum class parse_context {
    root,
    func_arg_decl,
    struct_or_tuple_field_decl,
};

struct parser_impl {
    std::unique_ptr<lexer> lex;
    memory_arena* ast_arena;
    std::string filename;
    std::stack<parse_context> ctx_stack;
    int func_body_level = 0;

    explicit parser_impl(memory_arena& arena, std::string_view src, const std::string& fn)
        : ast_arena{ &arena }, lex{ std::make_unique<lexer>(src, fn) }, filename{ fn }, ctx_stack{ {parse_context::root} }, func_body_level{ 0 } {}

    arena_ptr<ast_node> parse_code_unit() {
        auto pos = lex->pos();
        auto decls = parse_decl_list();
        if (decls) {
            return make_code_unit_node(*ast_arena, pos, filename, std::move(decls));
        }
        return arena_ptr<ast_node>{nullptr, nullptr};
    }

    // Section: types

    arena_ptr<ast_node> parse_type_expr(bool no_error = false, bool no_wrap = false) {
        auto pos = lex->pos();
        auto result = arena_ptr<ast_node>{nullptr, nullptr};

        if (TOK_CHAR == '{') {
            result = parse_struct_or_tuple_type_expr();
        }
        else if (TOK_CHAR == '[') {
            result = parse_array_type_expr();
        }
        else if (TOK_CHAR == '!') {
            lex->next();

            auto to_type = parse_type_expr(false, true); // no wrap
            if (to_type) {
                result = make_type_qualifier_node(*ast_arena, pos, type_qualifier::mutable_pointer, std::move(to_type));
            }
        }
        else if (TOK_CHAR == '*') {
            lex->next();

            auto to_type = parse_type_expr(false, true); // no wrap
            if (to_type) {
                result = make_type_qualifier_node(*ast_arena, pos, type_qualifier::pointer, std::move(to_type));
            }
        }
        else if (TOK_CHAR == '?') {
            lex->next();

            auto to_type = parse_type_expr(false, true); // no wrap
            if (to_type) {
                result = make_type_qualifier_node(*ast_arena, pos, type_qualifier::optional, std::move(to_type));
            }
        }
        else if (TOK_CHAR == '@') {
            /*
            lex->next();

            auto to_type = parse_type_expr(false, true); // no wrap
            if (to_type) {
                result = make_type_qualifier_node(*ast_arena, pos, type_qualifier::owner, std::move(to_type));
            }
            */
        }
        else if (TOK == token_type::identifier) {
            result = make_identifier_node(*ast_arena, lex->pos(), { lex->string_value() });

            lex->next();
            if (TOK_CHAR == '[') {
                auto arg_list = parse_arg_list(']', [this]() {
                    return parse_type_expr();
                });
                result = make_type_constructor_instance_node(*ast_arena, result->pos, std::move(result), std::move(arg_list));
            }
        }

        if (result) {
            if (!no_wrap) {
                return make_type_expr_node(*ast_arena, pos, std::move(result));
            }
            else {
                return result;
            }
        }

        if (!no_error) {
            throw parse_error(filename, lex->pos(), "invalid type expression");
        }
        return { nullptr, nullptr };
    }

    arena_ptr<ast_node> parse_struct_or_tuple_type_expr() {
        enum { UNDEFINED, TUPLE, STRUCT };

        auto pos = lex->pos();
        int mode = UNDEFINED;
        // dont't eat the '{' because arg_list need it

        auto field_list = arena_ptr<ast_node>{ nullptr, nullptr };
        {
            ctx_stack.push(parse_context::struct_or_tuple_field_decl);
            scope_guard _{ [this]() { ctx_stack.pop();  } };

            field_list = parse_arg_list('}', [this, &mode]() {
                if (TOK_CHAR == ':' && mode != STRUCT) {
                    mode = TUPLE;
                    lex->next();
                    return parse_type_expr();
                }
                else if (mode != TUPLE && TOK == token_type::identifier) {
                    mode = STRUCT;
                    return parse_var_decl(token_type::let);
                }

                // we might get here if we have a trailing comma
                if (TOK_CHAR != '}') {
                    throw parse_error(filename, lex->pos(), "unexpected struct or tuple field");
                }
            });
        }

        if (mode == TUPLE) {
            return make_tuple_type_node(*ast_arena, pos, std::move(field_list));
        }
        else if (mode == STRUCT) {
            return make_struct_type_node(*ast_arena, pos, std::move(field_list));
        }
        else if (field_list->children.empty()) {
            return make_identifier_node(*ast_arena, lex->pos(), { "void" });
        }
    }

    arena_ptr<ast_node> parse_array_type_expr() {
        auto pos = lex->pos();
        lex->next(); // eat the '['

        auto size_expr = arena_ptr<ast_node>{ nullptr, nullptr };
        if (TOK_CHAR != ']') {
            size_expr = parse_expr();
            if (!size_expr) {
                throw parse_error(filename, lex->pos(), "error parsing array size expression");
            }

            if (TOK_CHAR != ']') {
                throw parse_error(filename, lex->pos(), "expected closing bracket in sized array");
            }
            lex->next();
        }
        else {
            lex->next();
        }

        auto item_type = parse_type_expr();
        if (!item_type) {
            throw parse_error(filename, lex->pos(), "error parsing array item type");
        }

        return make_array_type_node(*ast_arena, pos, std::move(size_expr), std::move(item_type));
    }

    // Section: statements

    arena_ptr<ast_node> parse_stmt() {
        switch (TOK_CHAR) {
        case '{':
            return parse_compound_stmt();
        }

        switch (TOK) {
        case token_type::while_:
            return parse_while_stmt();
        case token_type::if_:
            return parse_if_stmt();
        case token_type::return_:
            return parse_return_stmt();
        case token_type::asm_:
            return parse_asm_stmt();
        }

        return parse_expr();
    }

    arena_ptr<ast_node> parse_compound_stmt() {
        enum { LIMIT = 8 * 1024 };

        auto pos = lex->pos();
        lex->next(); // eat the '{'

        std::vector<arena_ptr<ast_node>> children;
        for (int i = 0; i < LIMIT; i++) {
            auto decl_list = parse_decl_list();
            auto stmt_list = parse_stmt_list();

            if (decl_list) children.push_back(std::move(decl_list));
            if (stmt_list) children.push_back(std::move(stmt_list));

            if (!decl_list && !stmt_list && (TOK_CHAR == '}' || TOK == token_type::eof)) break;
        }
        if (TOK_CHAR != '}') {
            throw parse_error(filename, lex->pos(), "expected closing brace in compound statement");
        }
        lex->next();

        return make_compound_stmt_node(*ast_arena, pos, std::move(children));
    }

    arena_ptr<ast_node> parse_decl_list() {
        enum { LIMIT = 8*1024 };

        auto pos = lex->pos();
        std::vector<arena_ptr<ast_node>> decls;
        for (int i = 0; i < LIMIT; i++) {
            auto decl = parse_decl();
            if (!decl) break;

            decls.push_back(std::move(decl));

            // optional semi-colon
            if (TOK_CHAR == ';') {
                lex->next();
            }
        }

        if (decls.empty()) {
            return { nullptr, nullptr };
        }

        return make_decl_list_node(*ast_arena, pos, std::move(decls));
    }

    arena_ptr<ast_node> parse_stmt_list() {
        enum { LIMIT = 8 * 1024 };

        auto pos = lex->pos();
        std::vector<arena_ptr<ast_node>> stmts;
        for (int i = 0; i < LIMIT; i++) {
            auto stmt = parse_stmt();
            if (!stmt) break;

            stmts.push_back(std::move(stmt));

            if (TOK_CHAR != ';') break;
            lex->next();
        }

        if (stmts.empty()) {
            return { nullptr, nullptr };
        }

        return make_stmt_list_node(*ast_arena, pos, std::move(stmts));
    }

    arena_ptr<ast_node> parse_for_stmt() {
        auto pos = lex->pos();
        lex->next(); // eat the 'for'

        if (TOK_CHAR == '(') {
            lex->next(); // eat the '('

            auto ids = make_arg_list_node(*ast_arena, pos, {});
            auto expr = parse_expr();
            auto iter = arena_ptr<ast_node>{nullptr, nullptr};

            if (expr->type == ast_type::identifier) {
                if (TOK_CHAR == ',') {
                    lex->next();
                    ids->children.push_back(std::move(expr));

                    auto id2 = parse_primary_expr();
                    if (id2->type != ast_type::identifier) {
                        throw parse_error(filename, lex->pos(), "expecting another identifier after ',' in for statement");
                    }

                    ids->children.push_back(std::move(id2));
                }

                if (TOK == token_type::in_) {
                    lex->next();
                    iter = parse_expr();
                    if (!iter) {
                        throw parse_error(filename, lex->pos(), "expecting an expression after 'in' in for statement");
                    }
                }
            }

            if (!iter) {
                iter = std::move(expr);
            }

            if (TOK_CHAR != ')') {
                throw parse_error(filename, lex->pos(), "expected closing ')' in for statement");
            }
            lex->next();

            auto body = parse_stmt();

            return make_for_stmt_node(*ast_arena, pos, std::move(ids), std::move(iter), std::move(body));
        }

        throw parse_error(filename, lex->pos(), "expected opening '(' in for statement condition");
        return arena_ptr<ast_node>{nullptr, nullptr};
    }

    arena_ptr<ast_node> parse_while_stmt() {
        auto pos = lex->pos();
        lex->next(); // eat the 'while'

        if (TOK_CHAR == '(') {
            lex->next();
            auto cond = parse_expr();
            if (TOK_CHAR != ')') {
                throw parse_error(filename, lex->pos(), "expected closing ')' in while statement condition");
            }
            lex->next();

            auto body = parse_stmt();

            return make_while_stmt_node(*ast_arena, pos, std::move(cond), std::move(body));
        }

        throw parse_error(filename, lex->pos(), "expected opening '(' in while statement condition");
        return arena_ptr<ast_node>{nullptr, nullptr};
    }

    arena_ptr<ast_node> parse_if_stmt() {
        auto pos = lex->pos();
        lex->next(); // eat the 'if'

        if (TOK_CHAR == '(') {
            lex->next();
            auto cond = parse_expr();
            if (TOK_CHAR != ')') {
                throw parse_error(filename, lex->pos(), "expected closing ')' in if statement condition");
            }
            lex->next();

            auto body = parse_stmt();
            auto elsebody = arena_ptr<ast_node>{ nullptr, nullptr };
            if (TOK == token_type::else_) {
                lex->next();
                elsebody = parse_stmt();
            }

            return make_if_stmt_node(*ast_arena, pos, std::move(cond), std::move(body), std::move(elsebody));
        }

        throw parse_error(filename, lex->pos(), "expected opening '(' in if statement condition");
        return arena_ptr<ast_node>{nullptr, nullptr};
    }

    arena_ptr<ast_node> parse_return_stmt() {
        auto pos = lex->pos();
        lex->next(); // eat the 'return'

        auto expr = parse_expr();
        return make_return_stmt_node(*ast_arena, pos, std::move(expr));
    }

    arena_ptr<ast_node> parse_asm_stmt() {
        auto pos = lex->pos();
        lex->next(); // eat the 'asm'

        if (TOK_CHAR == '%') {
            lex->next();
            if (TOK_CHAR == '{') {
                lex->advance_char(1);
                lex->consume_string_until("}%asm");
                
                auto res = make_asm_stmt_node(*ast_arena, pos, lex->long_string_value());
                lex->next();
                return res;
            }
            else {
                throw parse_error(filename, lex->pos(), "expecting a '{' in asm statement");
            }
        }
        else {
            throw parse_error(filename, lex->pos(), "expecting a '%' in asm statement");
        }
    }

    // Section: declarations

    arena_ptr<ast_node> parse_decl() {
        auto t = TOK;
        switch (t) {
        case token_type::var:
        case token_type::let:
            return parse_var_decl(t);
        case token_type::func:
            return parse_func_decl();
        case token_type::type:
            return parse_type_decl();
        case token_type::import_:
            return parse_import_decl();
        case token_type::asm_:
            return parse_asm_stmt();
        case token_type::extern_:
            return parse_linkage_decl();
        case token_type::public_:
        case token_type::private_:
        case token_type::internal_:
            return parse_visibility_specifier_decl();
        default:
            return arena_ptr<ast_node>{nullptr, nullptr};
        }
    }

    arena_ptr<ast_node> parse_visibility_specifier_decl() {
        auto pos = lex->pos();
        auto spec = lex->current();
        auto content = arena_ptr<ast_node>{ nullptr, nullptr };
        lex->next();

        if (TOK_CHAR == '{') {
            lex->next();

            auto decls = parse_decl_list();
            if (TOK_CHAR != '}') {
                throw parse_error(filename, lex->pos(), "expecting closing '}' in function linkage declaration");
            }
            lex->next();
            content = std::move(decls);
        }
        else {
            content = parse_decl();
        }

        return make_visibility_specifier_node(*ast_arena, pos, spec, std::move(content));
    }

    std::optional<func_linkage> parse_func_linkage() {
        if (TOK == token_type::identifier) {
            if (lex->string_value() == "C") {
                lex->next();
                return func_linkage::external_c;
            }
        }
        return {};
    }

    arena_ptr<ast_node> parse_linkage_decl() {
        auto pos = lex->pos();
        lex->next(); // eat the 'extern'

        func_linkage linkage = func_linkage::external_carbon;
        if (TOK_CHAR == '(') {
            lex->next();
            auto linkopt = parse_func_linkage();
            if (linkopt) {
                linkage = *linkopt;
            }

            if (TOK_CHAR != ')') {
                throw parse_error(filename, lex->pos(), "expecting closing ')' in function linkage declaration");
            }
            lex->next();
        }

        auto content = arena_ptr<ast_node>{ nullptr, nullptr };
        if (TOK == token_type::func) {
            content = parse_func_decl();
        }
        else if (TOK_CHAR == '{') {
            lex->next();

            auto decls = parse_decl_list();
            if (TOK_CHAR != '}') {
                throw parse_error(filename, lex->pos(), "expecting closing '}' in function linkage declaration");
            }
            lex->next();
            content = std::move(decls);
        }
        else {
            throw parse_error(filename, lex->pos(), "invalid linkage specifier declaration");
        }

        return make_linkage_specifier_node(*ast_arena, pos, linkage, std::move(content));
    }

    arena_ptr<ast_node> parse_import_decl() {
        auto pos = lex->pos();
        lex->next(); // eat the 'import'

        auto id = parse_qualified_identifier();
        auto alias = arena_ptr<ast_node>{ nullptr, nullptr };

        if (TOK == token_type::as_) {
            lex->next();
            if (TOK != token_type::identifier) {
                throw parse_error(filename, lex->pos(), "expecting identifier in import declaration alias");
            }
            
            alias = make_identifier_node(*ast_arena, lex->pos(), { lex->string_value() });
            lex->next();
        }

        return make_import_decl_node(*ast_arena, pos, std::move(id), std::move(alias));
    }

    arena_ptr<ast_node> parse_type_decl() {
        auto pos = lex->pos();
        lex->next(); // eat the 'type'

        if (TOK != token_type::identifier) {
            throw parse_error(filename, lex->pos(), "expected identifier in type declaration");
        }
        auto id = make_identifier_node(*ast_arena, lex->pos(), { lex->string_value() });
        lex->next();

        auto contents = arena_ptr<ast_node>{ nullptr, nullptr };
        if (TOK_CHAR == '=') {
            lex->next();
            contents = parse_type_expr();
        }

        return make_type_decl_node(*ast_arena, pos, std::move(id), std::move(contents));
    }

    arena_ptr<ast_node> parse_func_arg_decl() {
        return parse_var_decl(token_type::let);
    }

    arena_ptr<ast_node> parse_func_decl() {
        auto pos = lex->pos();
        lex->next(); // eat the 'func'

        if (TOK != token_type::identifier) {
            throw parse_error(filename, lex->pos(), "expected identifier in func declaration");
        }
        auto id = make_identifier_node(*ast_arena, lex->pos(), { lex->string_value() });
        lex->next();

        auto arg_list = arena_ptr<ast_node>{ nullptr, nullptr };
        if (TOK_CHAR == '(') {
            ctx_stack.push(parse_context::func_arg_decl);
            scope_guard _{ [this]() { ctx_stack.pop(); } };

            arg_list = parse_arg_list(')', [this]() {
                return parse_func_arg_decl();
            });
        }

        // parse return type
        auto ret_type = arena_ptr<ast_node>{ nullptr, nullptr };
        if (TOK_CHAR == ':') {
            lex->next();
            ret_type = parse_type_expr();
        }

        func_body_level++;
        scope_guard _{ [this]() { func_body_level--; } };

        auto body = arena_ptr<ast_node>{ nullptr, nullptr };
        if (TOK_CHAR == '=') {
            lex->next();
            body = parse_expr();
        }
        else if (TOK_CHAR == '{') {
            body = parse_compound_stmt();
        }

        return make_func_decl_node(*ast_arena, pos, std::move(id), std::move(arg_list), std::move(ret_type), std::move(body), func_linkage::local_carbon);
    }

    arena_ptr<ast_node> parse_var_decl(token_type kind) {
        auto pos = lex->pos();
        if ((ctx() == parse_context::root)) {
            lex->next(); // eat the 'var' or 'let'
        }

        if (TOK != token_type::identifier) {
            throw parse_error(filename, lex->pos(), "expected identifier in variable declaration");
        }
        auto id = make_identifier_node(*ast_arena, lex->pos(), { lex->string_value() });
        lex->next();

        arena_ptr<ast_node> var_type{nullptr, nullptr};
        if (TOK_CHAR == ':') {
            lex->next();
            var_type = parse_type_expr();
        }

        arena_ptr<ast_node> value{nullptr, nullptr};
        if (TOK_CHAR == '=') {
            lex->next();
            value = parse_expr();
        } else if (kind != token_type::var && (ctx() == parse_context::root)) {
            throw parse_error(filename, lex->pos(), "expected initial value in let declaration");
        }

        return make_var_decl_node(*ast_arena, pos, kind, std::move(id), std::move(var_type), std::move(value));
    }

    // Section: expressions

    arena_ptr<ast_node> parse_expr() {
        return parse_binary_expr(parse_unary_expr(), 0);
    }

    arena_ptr<ast_node> parse_binary_expr(arena_ptr<ast_node>&& lhs, int min_prec) {
        auto pos = lex->pos();

        while (is_binary_op(TOK) && precedence(TOK) >= min_prec) {
            auto op = TOK;

            // TODO: assignment

            lex->next();
            if (token_is_char(TOK, '\n') || TOK == token_type::eof) {
                throw parse_error(filename, lex->pos(), "unfinished expression");
            }

            auto rhs = parse_unary_expr();
            while (is_binary_op(TOK) && (precedence_cmp(TOK, op) > 0 ||
                (is_right_assoc(TOK) && precedence_cmp(TOK, op) >= 0))) {
                rhs = parse_binary_expr(std::move(rhs), precedence(op));
            }

            lhs = make_binary_expr_node(*ast_arena, pos, op, std::move(lhs), std::move(rhs));
        }

        return std::move(lhs);
    }

    arena_ptr<ast_node> parse_unary_expr() {
        auto pos = lex->pos();
        auto op = TOK;
        
        if (is_unary_op(op)) {
            lex->next();
            return make_unary_expr_node(*ast_arena, pos, op, parse_cast_expr());
        }
        
        return parse_cast_expr();
    }

    arena_ptr<ast_node> parse_cast_expr() {
        auto pos = lex->pos();
        if (TOK == token_type::cast_) {
            lex->next();

            if (TOK_CHAR != '[') {
                throw parse_error(filename, lex->pos(), "invalid cast expression");
            }
            lex->next();

            auto type_expr = parse_type_expr();
            if (TOK_CHAR != ']') {
                throw parse_error(filename, lex->pos(), "invalid cast expression");
            }
            lex->next();

            auto value = parse_call_or_index_or_field_expr();
            if (!value) {
                throw parse_error(filename, lex->pos(), "invalid cast expression");
            }

            return make_cast_expr_node(*ast_arena, pos, std::move(type_expr), std::move(value));
        }

        return parse_call_or_index_or_field_expr();
    }

    arena_ptr<ast_node> parse_call_or_index_or_field_expr() {
        auto pos = lex->pos();
        auto expr = parse_init_expr();
        while (TOK_CHAR == '(' || TOK_CHAR == '[' || TOK_CHAR == '.') {
            if (TOK_CHAR == '(') {
                auto arg_list = parse_arg_list(')', [this]() {
                    return parse_expr();
                });
                expr = make_call_expr_node(*ast_arena, pos, std::move(expr), std::move(arg_list));
            }
            else if (TOK_CHAR == '.') {
                lex->next();
                if (TOK != token_type::identifier) {
                    throw parse_error(filename, lex->pos(), "expected identifier in field expression");
                }
                
                auto id = parse_qualified_identifier();

                expr = make_field_expr_node(*ast_arena, pos, std::move(expr), std::move(id));
            }
            else {
                lex->next();
                auto index_expr = parse_expr();
                if (TOK_CHAR != ']') {
                    throw parse_error(filename, lex->pos(), "expected closing ']' in index expression");
                }
                lex->next();
                
                expr = make_index_expr_node(*ast_arena, pos, std::move(expr), std::move(index_expr));
            }
        }
        return expr;
    }

    arena_ptr<ast_node> parse_init_expr() {
        auto pos = lex->pos();
        auto init_type = parse_primary_expr();
        if (init_type) {
            if (init_type->type == ast_type::identifier && TOK_CHAR == '{') {
                return parse_init_list_expr(std::move(init_type));
            }
        }
        else {
            auto try_type = parse_type_expr(true);
            if (try_type && TOK_CHAR == '{') {
                return parse_init_list_expr(std::move(try_type));
            }
        }
        return init_type;
    }

    arena_ptr<ast_node> parse_primary_expr() {
        switch (lex->current()) {
        case token_type::bool_literal_true:
        case token_type::bool_literal_false: {
            scope_guard _{[this]() { lex->next(); }};
            return make_bool_literal_node(*ast_arena, lex->pos(), lex->current() == token_type::bool_literal_true);
        }
        case token_type::float_literal: {
            scope_guard _{[this]() { lex->next(); }};
            return make_float_literal_node(*ast_arena, lex->pos(), lex->float_value());
        }
        case token_type::int_literal: {
            scope_guard _{[this]() { lex->next(); }};
            return make_int_literal_node(*ast_arena, lex->pos(), lex->int_value());
        }
        case token_type::char_literal: {
            scope_guard _{ [this]() {
                lex->next();
            } };
            return make_char_literal_node(*ast_arena, lex->pos(), lex->int_value());
        }
        case token_type::string_literal: {
            scope_guard _{ [this]() { lex->next(); } };
            return make_string_literal_node(*ast_arena, lex->pos(), lex->string_value());
        }
        case token_type::identifier: {
            return parse_qualified_identifier();
        }
        default: {
            char c = TOK_CHAR;
            switch (c) {
            case '(': {
                lex->next();
                auto expr = parse_expr();
                if (TOK_CHAR != ')') {
                    throw parse_error(filename, lex->pos(), "expected closing parentheses");
                }
                lex->next();
                return expr;
            }
            case '{': {
                // init list
                return parse_init_list_expr({nullptr, nullptr});
            }
            }

            if (TOK == token_type::eof) {
                throw parse_error(filename, lex->pos(), "unexpected end of file");
            }
        }
        }
        return arena_ptr<ast_node>{nullptr, nullptr};
    }

    arena_ptr<ast_node> parse_init_list_expr(arena_ptr<ast_node>&& init_type) {
        auto pos = lex->pos();
        auto item_list = arena_ptr<ast_node>{ nullptr, nullptr };
        {
            item_list = parse_arg_list('}', [this]() {
                if (TOK_CHAR == '.') {
                    auto pos = lex->pos();

                    lex->next();
                    if (TOK != token_type::identifier) {
                        throw parse_error(filename, lex->pos(), "expected identifier in designated initializer");
                    }

                    auto id = make_identifier_node(*ast_arena, lex->pos(), { lex->string_value() });
                    lex->next();

                    if (TOK_CHAR != '=') {
                        throw parse_error(filename, lex->pos(), "expected '=' in designated initializer");
                    }
                    lex->next();

                    auto value = parse_expr();
                    if (!value) {
                        throw parse_error(filename, lex->pos(), "expected value in designated initializer");
                    }

                    // TODO: specialized node type needed?
                    return make_var_decl_node(*ast_arena, pos, token_type::let, std::move(id), { nullptr, nullptr }, std::move(value));
                }
                else {
                    return parse_expr();
                }
            });
        }

        return make_init_expr_node(*ast_arena, pos, std::move(init_type), std::move(item_list));
    }

    // Section: helpers

    arena_ptr<ast_node> parse_qualified_identifier() {
        enum { LIMIT = 32 };
        int i = 0;

        std::vector<std::string> id_parts = { lex->string_value() };
        lex->next();
        
        while (TOK == token_type::coloncolon && i++ < LIMIT) {
            lex->next();
            if (TOK != token_type::identifier) {
                throw parse_error(filename, lex->pos(), "expecting identifier");
            }
            id_parts.push_back(lex->string_value());
            lex->next();
        }
        return make_identifier_node(*ast_arena, lex->pos(), id_parts);
    }

    arena_ptr<ast_node> parse_arg_list(char end, std::function<arena_ptr<ast_node>()> parse_arg) {
        enum { LIMIT = 32 };
        std::vector<arena_ptr<ast_node>> args;

        auto pos = lex->pos();
        lex->next(); // eat the '('

        // parse args
        if (TOK_CHAR != end) {
            for (int i = 0; i < LIMIT; i++) {
                auto arg = parse_arg();
                if (arg) {
                    args.push_back(std::move(arg));
                }
                else {
                    break;
                }

                if (TOK_CHAR != ',') {
                    break;
                }
                else if (TOK_CHAR == end) {
                    break;
                }
                else {
                    lex->next();
                }
            }
        }

        if (TOK_CHAR != end) {
            throw parse_error(filename, lex->pos(), "expected closing parentheses in argument list");
        }
        lex->next();

        return make_arg_list_node(*ast_arena, pos, std::move(args));
    }

    parse_context ctx() const { return ctx_stack.top(); }
};

parser::parser(memory_arena& arena, std::string_view src, const std::string& filename) : _impl{ new parser_impl{arena, src, filename} } {}

parser::~parser() { delete _impl; }

arena_ptr<ast_node> parser::parse_decl_list() { return _impl->parse_decl_list(); }

arena_ptr<ast_node> parser::parse_code_unit() { return _impl->parse_code_unit(); }

arena_ptr<ast_node> parser::parse_expr() { return _impl->parse_expr(); }

}