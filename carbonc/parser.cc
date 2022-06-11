#include <stack>
#include "parser.hh"
#include "lexer.hh"
#include "memory.hh"
#include "common.hh"
#include "exception.hh"
#include <set>
#include <optional>
#include <iostream>

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
    std::string modname;
    std::stack<parse_context> ctx_stack;
    int func_body_level = 0;
    int lines_parsed = 0;
    bool decl_retry = false;
    func_linkage current_linkage;

    enum aggregate_mode { UNDEFINED, TUPLE, STRUCT };

    explicit parser_impl(memory_arena& arena, std::string_view src, const std::string& fn, const std::string& mname)
        : ast_arena{ &arena }, lex{ std::make_unique<lexer>(src, fn) }, filename{ fn }, modname{ mname }, ctx_stack{ {parse_context::root} }, func_body_level{ 0 } {}

    arena_ptr<ast_node> parse_code_unit() {
        auto pos = lex->pos();
        auto decls = parse_decl_list();

        lines_parsed += lex->pos().line_number - pos.line_number;

        if (decls) {
            return make_code_unit_node(*ast_arena, pos, filename, modname, std::move(decls));
        }
        throw parse_error(pos.filename, pos, "Empty code unit");
    }

    // Section: types

    arena_ptr<ast_node> parse_type_expr(bool no_error = false, bool no_wrap = false) {
        auto pos = lex->pos();
        auto result = arena_ptr<ast_node>{nullptr, nullptr};

        if (TOK == token_type::struct_) {
            result = parse_struct_type_expr();
        }
        else if (TOK == token_type::enum_ || TOK == token_type::enumflags) {
            result = parse_enum_type_expr(TOK == token_type::enumflags);
        }
        else if (TOK_CHAR == '&') {
            lex->next();

            auto to_type = parse_type_expr(false, true); // no wrap
            if (to_type) {
                result = make_type_qualifier_node(*ast_arena, pos, type_qualifier::ptr, std::move(to_type));
            }
        }
        else if (TOK == token_type::pure) {
            lex->next();

            auto to_type = parse_type_expr(false, true); // no wrap
            if (to_type) {
                result = make_type_qualifier_node(*ast_arena, pos, type_qualifier::pure, std::move(to_type));
            }
        }
        else if (TOK == token_type::in_) {
            if (ctx_stack.top() != parse_context::func_arg_decl) {
                throw parse_error(filename, lex->pos(), "can only use in/out in function arguments");
            }

            lex->next();

            auto to_type = parse_type_expr(false, true); // no wrap
            if (to_type) {
                result = make_type_qualifier_node(*ast_arena, pos, type_qualifier::in, std::move(to_type));
            }
        }
        else if (TOK == token_type::out) {
            if (ctx_stack.top() != parse_context::func_arg_decl) {
                throw parse_error(filename, lex->pos(), "can only use in/out in function arguments");
            }

            lex->next();

            auto to_type = parse_type_expr(false, true); // no wrap
            if (to_type) {
                result = make_type_qualifier_node(*ast_arena, pos, type_qualifier::out, std::move(to_type));
            }
        }
        else if (TOK == token_type::array_) {
            lex->next();

            arena_ptr<ast_node> size_expr{ nullptr, nullptr };

            if (TOK_CHAR == '[') {
                lex->next();
                size_expr = parse_expr();
                if (!size_expr) {
                    throw parse_error(filename, lex->pos(), "invalid array type expression, missing size expression");
                }
                if (TOK_CHAR != ']') {
                    throw parse_error(filename, lex->pos(), "invalid array type expression, missing ']'");
                }
                lex->next();
            }
            
            if (TOK != token_type::of_) {
                throw parse_error(filename, lex->pos(), "invalid array type expression, missing 'of'");
            }
            lex->next();

            auto to_type = parse_type_expr();
            if (to_type) {
                if (size_expr) {
                    result = make_static_array_type_node(*ast_arena, pos, std::move(size_expr), std::move(to_type));
                }
                else {
                    result = make_array_type_node(*ast_arena, pos, std::move(to_type));
                }
            }
        }
        else if (TOK == token_type::arrayview_) {
            throw parse_error(filename, lex->pos(), "invalid type expression (arrayview)");
        }
        else if (TOK == token_type::identifier) {
            result = parse_qualified_identifier();

            if (TOK_CHAR == '(') {
                auto arg_list = parse_arg_list(')', [this]() {
                    return parse_type_expr();
                });

                auto rpos = result->pos;
                result = make_type_constructor_instance_node(*ast_arena, rpos, make_type_expr_node(*ast_arena, rpos, std::move(result)), std::move(arg_list));
            }
            else if (TOK_CHAR == '.') {
                lex->next();
                auto id = parse_qualified_identifier();

                auto rpos = result->pos;
                result = make_field_expr_node(*ast_arena, rpos, std::move(result), std::move(id));
            }
        }
        else if (TOK == token_type::error) {
            result = make_identifier_node(*ast_arena, lex->pos(), { "$error" });
            lex->next();
        }
        else if (TOK == token_type::nil) {
            result = make_identifier_node(*ast_arena, lex->pos(), { "$nil" });
            lex->next();
        }
        else if (TOK_CHAR == '#') {
            // built-in function
            result = parse_primary_expr();
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

    arena_ptr<ast_node> parse_enum_type_expr(bool is_flags = false) {
        auto pos = lex->pos();
        lex->next();

        auto base_type = arena_ptr<ast_node>{nullptr, nullptr};
        if (TOK_CHAR == ':') {
            lex->next();
            base_type = parse_type_expr();
        }

        if (TOK_CHAR != '(') {
            throw parse_error(filename, lex->pos(), "expecting '(' in enum type");
        }
        lex->next();

        std::vector<arena_ptr<ast_node>> members;
        while (TOK == token_type::identifier) {
            auto id = parse_qualified_identifier();
            if (id) {
                members.push_back(std::move(id));
            }

            if (TOK_CHAR == ';') { // optional semi-colon
                lex->next();
            }
        }

        if (TOK_CHAR != ')') {
            throw parse_error(filename, lex->pos(), "expecting closing ')' in enum type");
        }
        lex->next();

        auto member_list = make_arg_list_node(*ast_arena, pos, std::move(members));
        return make_enum_type_node(*ast_arena, pos, std::move(base_type), std::move(member_list), is_flags);
    }

    arena_ptr<ast_node> parse_struct_type_expr() {
        auto pos = lex->pos();
        lex->next();

        auto field_list = arena_ptr<ast_node>{ nullptr, nullptr };
        if (TOK != token_type::of_) {
            throw parse_error(filename, lex->pos(), "expecting 'of' in struct type");
        }
        lex->next();

        {
            ctx_stack.push(parse_context::struct_or_tuple_field_decl);
            scope_guard _{ [this]() { ctx_stack.pop();  } };

            field_list = parse_struct_type_body();

            if (TOK != token_type::end) {
                throw parse_error(filename, lex->pos(), "expecting closing 'end' in struct body");
            }
            lex->next();
        }

        if (TOK == token_type::arrow_right) {
            lex->next();
            auto ret_type = parse_type_expr();
            if (!ret_type) {
                throw parse_error(filename, lex->pos(), "expecting function pointer type's return type");
            }
            return make_func_pointer_type_node(*ast_arena, pos, std::move(field_list), std::move(ret_type));
        }

        return make_struct_type_node(*ast_arena, pos, std::move(field_list));
    }

    arena_ptr<ast_node> parse_struct_type_body() {
        enum { LIMIT = 8 * 1024 };

        auto pos = lex->pos();
        std::vector<arena_ptr<ast_node>> decls;
        for (int i = 0; i < LIMIT; i++) {
            auto decl = parse_struct_entry();
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

    arena_ptr<ast_node> parse_struct_entry() {
        auto t = TOK;
        switch (t) {
        case token_type::identifier:
            return parse_arg_decl(token_type::let);
        case token_type::fun:
            return parse_func_decl();
        case token_type::type:
            return parse_type_decl();
        case token_type::typealias:
            return parse_type_decl(true);
        case token_type::import_:
            return parse_import_decl();
        case token_type::public_:
        case token_type::local:
            return parse_visibility_specifier_decl();
        default:
            return arena_ptr<ast_node>{nullptr, nullptr};
        }
    }

    // Section: statements

    arena_ptr<ast_node> parse_stmt() {
        switch (TOK) {
        case token_type::for_:
            return parse_for_stmt();
        case token_type::continue_:
            return parse_continue_stmt();
        case token_type::break_:
            return parse_break_stmt();
        case token_type::if_:
            return parse_if_stmt();
        case token_type::return_:
            return parse_return_stmt();
        case token_type::compute:
            return parse_compute_stmt();
        case token_type::asm_:
            return parse_asm_stmt();
        case token_type::defer:
            return parse_defer_stmt();
#if 0
        case token_type::catch_:
            return parse_catch_stmt();
#endif
        }
        return parse_assignment_stmt();
    }

    // assignment -> expr '=' expr
    arena_ptr<ast_node> parse_assignment_stmt() {
        auto pos = lex->pos();
        auto lhs = parse_expr();
        if (TOK_CHAR == '=') {
            lex->next();
            auto rhs = parse_expr();
            return make_assign_stmt_node(*ast_arena, pos, std::move(lhs), std::move(rhs));
        }
        else if (lhs) {
            if (lhs->type != ast_type::call_expr) {
                throw parse_error(filename, pos, "naked expression is not a function call");
            }
        }
        return lhs;
    }

    arena_ptr<ast_node> parse_break_stmt() {
        auto pos = lex->pos();
        scope_guard _{ [this]() { lex->next(); } };
        return make_break_stmt_node(*ast_arena, pos);
    }

    arena_ptr<ast_node> parse_continue_stmt() {
        auto pos = lex->pos();
        scope_guard _{ [this]() { lex->next(); } };
        return make_continue_stmt_node(*ast_arena, pos);
    }

    bool has_token_type(std::vector<token_type> finalizers, token_type tt) {
        for (const auto& f : finalizers) {
            if (f == tt) { return true; }
        }
        return false;
    }

    arena_ptr<ast_node> parse_compound_stmt(std::vector<token_type> finalizers, bool as_expr = false) {
        enum { LIMIT = 8 * 1024 };

        auto pos = lex->pos();
        lex->next(); // eat the 'do'

        std::vector<arena_ptr<ast_node>> children;

        // block parameters
        if (TOK_CHAR == '|') {
            lex->next();

            auto ids = parse_identifier_list();

            if (TOK_CHAR != '|') {
                throw parse_error(filename, lex->pos(), "expected closing '|' in block parameter list");
            }
            lex->next();

            ids->type = ast_type::block_parameter_list;
            children.push_back(std::move(ids));
        }

        for (int i = 0; i < LIMIT; i++) {
            auto decl_list = parse_decl_list();
            auto stmt_list = parse_stmt_list();

            if (decl_list) children.push_back(std::move(decl_list));
            if (stmt_list) children.push_back(std::move(stmt_list));

            if (!decl_list && !stmt_list && (TOK == token_type::end || TOK == token_type::eof || has_token_type(finalizers, TOK))) break;
        }

        if (has_token_type(finalizers, TOK)) {
            return make_compound_stmt_node(*ast_arena, pos, std::move(children), as_expr);
        }

        if (TOK != token_type::end) {
            throw parse_error(filename, lex->pos(), "expected 'end' in compound statement");
        }
        lex->next();

        return make_compound_stmt_node(*ast_arena, pos, std::move(children), as_expr);
    }

    arena_ptr<ast_node> parse_decl_list() {
        enum { LIMIT = 8*1024 };

        auto pos = lex->pos();
        std::vector<arena_ptr<ast_node>> decls;
        for (int i = 0; i < LIMIT; i++) {
            decl_retry = false;
            auto decl = parse_decl();
            if (!decl) {
                if (decl_retry) { continue; }
                else { break; }
            }

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

        auto ids = make_arg_list_node(*ast_arena, pos, {});
        auto expr = parse_expr();

        if (expr->type == ast_type::range_expr) {
            if (TOK != token_type::do_) {
                throw parse_error(filename, lex->pos(), "expecting 'do' in for statement body");
            }
            auto body = parse_compound_stmt({});
            return make_for_numeric_stmt_node(*ast_arena, pos, std::move(ids), std::move(expr), std::move(body));
        }
        else {
            if (TOK != token_type::do_) {
                throw parse_error(filename, lex->pos(), "expecting 'do' in for statement body");
            }
            auto body = parse_compound_stmt({});
            return make_for_cond_stmt_node(*ast_arena, pos, std::move(expr), std::move(body));
        }
    }

    arena_ptr<ast_node> parse_if_stmt(bool as_expr = false) {
        auto pos = lex->pos();
        lex->next(); // eat the 'if'

        auto cond = parse_expr();
        if (TOK != token_type::then) {
            throw parse_error(filename, lex->pos(), "expected 'then' in if statement");
        }

        auto body = parse_compound_stmt({ token_type::else_ });

        auto elsebody = arena_ptr<ast_node>{ nullptr, nullptr };
        if (TOK == token_type::else_) {
            lex->save();
            lex->next();
            if (TOK == token_type::if_) {
                elsebody = parse_stmt();
            }
            else {
                lex->restore();
                elsebody = parse_compound_stmt({ token_type::else_ });
            }
        }

        return make_if_stmt_node(*ast_arena, pos, std::move(cond), std::move(body), std::move(elsebody), as_expr);
    }

    arena_ptr<ast_node> parse_return_stmt() {
        auto pos = lex->pos();
        lex->next(); // eat the 'return'

        auto expr = parse_expr();
        return make_return_stmt_node(*ast_arena, pos, std::move(expr));
    }

    arena_ptr<ast_node> parse_compute_stmt() {
        auto pos = lex->pos();
        lex->next(); // eat the 'return'

        auto expr = parse_expr();
        if (!expr) {
            throw parse_error(filename, pos, "compute statement expects a expression");
        }
        return make_compute_stmt_node(*ast_arena, pos, std::move(expr));
    }

    arena_ptr<ast_node> parse_asm_stmt() {
        auto pos = lex->pos();
        lex->next(); // eat the 'asm'

        if (TOK_CHAR == '%') {
            lex->next();
            if (TOK == token_type::do_) {
                lex->advance_char(1);
                lex->consume_string_until("end%asm");
                
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

    arena_ptr<ast_node> parse_defer_stmt() {
        auto pos = lex->pos();
        lex->next();

        auto stmt = parse_stmt();
        return make_defer_stmt_node(*ast_arena, pos, std::move(stmt));
    }

    // Section: declarations

    arena_ptr<ast_node> parse_decl() {
        auto pos = lex->pos();
        auto t = TOK;

        if (TOK_CHAR == '#') {
            lex->next();
            return parse_tag_decl(pos);
        }

        switch (t) {
        case token_type::let:
            return parse_var_decl(token_type::let);
        case token_type::const_:
            return parse_var_decl(token_type::const_);
        case token_type::fun:
            return parse_func_decl();
        case token_type::macro:
            return parse_macro_decl();
        case token_type::type:
            return parse_type_decl();
        case token_type::typealias:
            return parse_type_decl(true);
        case token_type::error:
            return parse_error_decl();
        case token_type::import_:
            return parse_import_decl();
        case token_type::asm_:
            return parse_asm_stmt();
        case token_type::extern_:
            return parse_linkage_decl();
        case token_type::export_:
            return parse_export_decl();
        case token_type::public_:
        case token_type::local:        
            return parse_visibility_specifier_decl();
        case token_type::struct_:
            if (current_linkage == func_linkage::external_c) {
                lex->next();
                return parse_c_struct_decl();
            }
            return arena_ptr<ast_node>{nullptr, nullptr};
        default:
            return arena_ptr<ast_node>{nullptr, nullptr};
        }
    }

    arena_ptr<ast_node> parse_c_struct_decl() {
        auto pos = lex->pos();

        if (TOK != token_type::identifier) {
            throw parse_error(filename, lex->pos(), "expecting identifier in C struct declaration");
        }

        auto name = make_identifier_node(*ast_arena, lex->pos(), { lex->string_value() });
        lex->next();

        if (TOK_CHAR != '{') {
            throw parse_error(filename, lex->pos(), "expecting '{' in C struct declaration");
        }
        lex->next();

        std::vector<arena_ptr<ast_node>> fields;

        enum { LIMIT = 10000 };
        int i = 0;
        while (TOK_CHAR != '}') {
            auto field = parse_c_struct_field();
            if (field) {
                fields.push_back(std::move(field));
            }

            if (TOK_CHAR == ';') {
                lex->next();
            }

            if (i >= LIMIT) {
                throw parse_error(filename, lex->pos(), "excedeed limit of struct fields");
            }
            i++;
        }
        lex->next();

        auto field_list = make_decl_list_node(*ast_arena, pos, std::move(fields));
        return make_c_struct_decl_node(*ast_arena, pos, std::move(name), std::move(field_list));
    }

    arena_ptr<ast_node> parse_c_struct_field() {
        if (TOK != token_type::identifier) {
            return { nullptr,nullptr };
        }

        auto pos = lex->pos();

        std::vector<std::string> ids;
        while (TOK == token_type::identifier || (TOK == token_type::const_) || (TOK_CHAR == '*')) {
            if (TOK == token_type::identifier) {
                ids.push_back(lex->string_value());
            }
            else if (TOK == token_type::const_) {
                ids.push_back("const");
            }
            else if ((TOK_CHAR == '*')) {
                ids.push_back("*");
            }
            lex->next();
        }

        return make_c_struct_field_node(*ast_arena, pos, std::move(ids));
    }

    arena_ptr<ast_node> parse_tag_decl(const position& pos) {
        if (TOK == token_type::identifier) {
            if (lex->string_value() == "define") {
                lex->next();
                return parse_define_decl();
            }
            else {
                auto p = parse_error(filename, pos, "unrecognized tag: #", lex->string_value().c_str());
                std::cout << p.what() << std::endl;
                lex->next();
            }
        }
        decl_retry = true;
        return { nullptr,nullptr };
    }

    arena_ptr<ast_node> parse_define_decl() {
        auto pos = lex->pos();
        if (TOK != token_type::identifier) {
            throw parse_error(filename, lex->pos(), "expecting identifier in #define declaration");
        }

        auto id = make_identifier_node(*ast_arena, pos, { lex->string_value() });

        lex->next();

        auto value = parse_expr();
        
        return make_var_decl_node_single(*ast_arena, pos, token_type::const_, std::move(id), { nullptr,nullptr }, std::move(value), {});
    }

    arena_ptr<ast_node> parse_error_decl() {
        auto pos = lex->pos();
        lex->next();

        if (TOK_CHAR != '(') {
            throw parse_error(filename, lex->pos(), "expecting '(' in error declaration");
        }
        lex->next();

        std::vector<arena_ptr<ast_node>> ids;
        while (TOK == token_type::identifier) {
            ids.push_back(make_identifier_node(*ast_arena, lex->pos(), { lex->string_value() }));
            lex->next();
        }

        if (TOK_CHAR != ')') {
            throw parse_error(filename, lex->pos(), "expecting closing ')' in error declaration");
        }
        lex->next();

        return make_error_decl_node(*ast_arena, pos, std::move(ids));
    }

    arena_ptr<ast_node> parse_visibility_specifier_decl() {
        auto pos = lex->pos();
        auto spec = lex->current();
        auto content = arena_ptr<ast_node>{ nullptr, nullptr };
        lex->next();

        if (TOK_CHAR == '(') {
            lex->next();

            auto decls = parse_decl_list();
            if (TOK_CHAR != ')') {
                throw parse_error(filename, lex->pos(), "expecting closing ')' in visibility declaration");
            }
            lex->next();
            content = std::move(decls);
        }
        else {
            content = parse_decl();
        }

        decl_visibility vis = decl_visibility::public_;
        switch (spec) {
        case token_type::public_:
            vis = decl_visibility::public_;
            break;
        case token_type::local:
            vis = decl_visibility::local_;
            break;
        }

        return make_visibility_specifier_node(*ast_arena, pos, vis, std::move(content));
    }

    std::optional<func_linkage> parse_func_linkage() {
        if (TOK == token_type::identifier) {
            if (lex->string_value() == "C") {
                lex->next();
                return func_linkage::external_c;
            }
            if (lex->string_value() == "carbon") {
                lex->next();
                return func_linkage::external_carbon;
            }
        }
        return {};
    }

    arena_ptr<ast_node> parse_linkage_decl() {
        auto pos = lex->pos();
        lex->next(); // eat the 'extern'

        func_linkage linkage = func_linkage::external_carbon;
        arena_ptr<ast_node> alias{nullptr, nullptr};

        if (TOK_CHAR == '(') {
            lex->next();

            auto linkopt = parse_func_linkage();
            if (linkopt) {
                linkage = *linkopt;
            }

            if (TOK_CHAR == ',') {
                lex->next();
                alias = parse_qualified_identifier();
                if (!alias) {
                    throw parse_error(filename, lex->pos(), "expecting qualified identifier for alias in function linkage declaration");
                }
            }

            if (TOK_CHAR != ')') {
                throw parse_error(filename, lex->pos(), "expecting closing ')' in function linkage declaration");
            }
            lex->next();
        }

        auto prevlinkage = current_linkage;

        current_linkage = linkage;

        auto content = arena_ptr<ast_node>{ nullptr, nullptr };
        if (TOK == token_type::fun) {
            content = parse_func_decl();
        }
        else if (TOK == token_type::let) {
            content = parse_var_decl(token_type::let);
        }
        else if (TOK_CHAR == '(') {
            lex->next();

            auto decls = parse_decl_list();
            if (TOK_CHAR != ')') {
                throw parse_error(filename, lex->pos(), "expecting closing ')' in function linkage declaration");
            }
            lex->next();
            content = std::move(decls);
        }
        else {
            throw parse_error(filename, lex->pos(), "invalid linkage specifier declaration");
        }

        current_linkage = prevlinkage;

        return make_linkage_specifier_node(*ast_arena, pos, linkage, std::move(alias), std::move(content));
    }

    arena_ptr<ast_node> parse_export_decl() {
        auto pos = lex->pos();
        lex->next(); // eat the 'export'

        arena_ptr<ast_node> id{ nullptr, nullptr };

        if (TOK_CHAR == '(') {
            lex->next();

            id = parse_qualified_identifier();
            if (!id) {
                throw parse_error(filename, lex->pos(), "expecting qualified identifier in export declaration");
            }

            if (TOK_CHAR != ')') {
                throw parse_error(filename, lex->pos(), "expecting closing ')' in export declaration");
            }
            lex->next();
        }

        auto content = arena_ptr<ast_node>{ nullptr, nullptr };
        if (TOK == token_type::fun) {
            content = parse_func_decl();
        }
        else if (TOK == token_type::let) {
            content = parse_var_decl(token_type::let);
        }
        else if (TOK_CHAR == '{') {
            lex->next();

            auto decls = parse_decl_list();
            if (TOK_CHAR != '}') {
                throw parse_error(filename, lex->pos(), "expecting closing '}' in export declaration");
            }
            lex->next();
            content = std::move(decls);
        }
        else {
            throw parse_error(filename, lex->pos(), "invalid export declaration");
        }

        throw parse_error(filename, lex->pos(), "export not implemented");

        //return make_export_decl_node(*ast_arena, pos, id, std::move(content));
    }

    arena_ptr<ast_node> parse_import_decl() {
        auto pos = lex->pos();
        lex->next(); // eat the 'import'

        auto id = parse_primary_expr();
        if (id->type != ast_type::string_literal) {
            throw parse_error(filename, pos, "expecting string for import module path");
        }

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

    arena_ptr<ast_node> parse_type_decl(bool is_alias = false) {
        auto pos = lex->pos();
        lex->next(); // eat the 'type'

        if (TOK != token_type::identifier) {
            throw parse_error(filename, lex->pos(), "expected identifier in type declaration");
        }
        auto id = make_identifier_node(*ast_arena, lex->pos(), { lex->string_value() });
        lex->next();

        arena_ptr<ast_node> arg_list{ nullptr, nullptr };
        if (TOK_CHAR == '(') {
            arg_list = parse_arg_list(')', [this]() -> arena_ptr<ast_node> {
                return parse_arg_decl(token_type::let);
            });
        }

        auto contents = arena_ptr<ast_node>{ nullptr, nullptr };
        if (TOK_CHAR == '=') {
            lex->next();
            contents = parse_type_expr();
        }
        else {
            throw parse_error(filename, lex->pos(), "expected '=' in type declaration");
        }

        if (arg_list.get()) {
            return make_type_constructor_decl_node(*ast_arena, pos, std::move(id), std::move(arg_list), std::move(contents));
        }
        else {
            return make_type_decl_node(*ast_arena, pos, std::move(id), std::move(contents), is_alias);
        }
    }

    arena_ptr<ast_node> parse_macro_decl() {
        auto pos = lex->pos();
        lex->next(); // eat the 'func'

        arena_ptr<ast_node> id{ nullptr, nullptr };
        if (TOK != token_type::identifier) {
            throw parse_error(filename, lex->pos(), "expected identifier in macro declaration");
        }
        id = make_identifier_node(*ast_arena, lex->pos(), { lex->string_value() });
        lex->next();

        // parse the argument list
        auto arg_list = arena_ptr<ast_node>{ nullptr, nullptr };
        if (TOK_CHAR == '(') {
            ctx_stack.push(parse_context::func_arg_decl);
            scope_guard _{ [this]() { ctx_stack.pop(); } };

            arg_list = parse_arg_list(')', [this]() {
                return parse_func_arg_decl();
            });
        }
        else {
            arg_list = make_arg_list_node(*ast_arena, pos, {});
        }

        func_body_level++;
        scope_guard _{ [this]() { func_body_level--; } };

        auto body = arena_ptr<ast_node>{ nullptr, nullptr };
        if (TOK_CHAR == '=') {
            lex->next();
            body = parse_func_body();
        }

        return make_macro_decl_node(*ast_arena, pos, std::move(id), std::move(arg_list), std::move(body));
    }

    arena_ptr<ast_node> parse_func_arg_decl() {
        if (TOK == token_type::type) {
            return parse_primary_expr();
        }
        return parse_arg_decl(token_type::let);
    }

    // func_decl -> 'fun' identifier '(' arg_list ')' ['?'] ['=>' type_expr] compound_stmt
    arena_ptr<ast_node> parse_func_decl(bool as_expr = false) {
        auto pos = lex->pos();
        lex->next(); // eat the 'func'

        arena_ptr<ast_node> id{nullptr, nullptr};
        if (!as_expr) {
            if (TOK != token_type::identifier) {
                throw parse_error(filename, lex->pos(), "expected identifier in func declaration");
            }
            id = make_identifier_node(*ast_arena, lex->pos(), { lex->string_value() });
            lex->next();
        }

        // parse the argument list
        auto arg_list = arena_ptr<ast_node>{ nullptr, nullptr };
        if (TOK_CHAR == '(') {
            ctx_stack.push(parse_context::func_arg_decl);
            scope_guard _{ [this]() { ctx_stack.pop(); } };

            arg_list = parse_arg_list(')', [this]() {
                return parse_func_arg_decl();
            });
        }
        else {
            arg_list = make_arg_list_node(*ast_arena, pos, {});
        }

        bool raises = false;
        if (TOK_CHAR == '?') {
            lex->next();
            raises = true;
        }

        // parse return type
        auto ret_type = arena_ptr<ast_node>{ nullptr, nullptr };
        if (TOK == token_type::double_arrow_right) {
            lex->next();
            ret_type = parse_type_expr();
        }

        func_body_level++;
        scope_guard _{ [this]() { func_body_level--; } };

        auto body = arena_ptr<ast_node>{ nullptr, nullptr };
        if (TOK_CHAR == '=') {
            lex->next();
            body = parse_func_body();
        }

        if (as_expr) {
            //return make_func_expr_node(*ast_arena, pos, std::move(id), std::move(arg_list), std::move(ret_type), std::move(body), raises, func_linkage::local_carbon);
        }
        return make_func_decl_node(*ast_arena, pos, std::move(id), std::move(arg_list), std::move(ret_type), std::move(body), raises, func_linkage::local_carbon);
    }

    arena_ptr<ast_node> parse_func_body() {
        if (TOK == token_type::do_) {
            return parse_compound_stmt({});
        }
        else {
            return parse_expr();
        }
    }

    arena_ptr<ast_node> parse_arg_decl(token_type kind) {
        auto pos = lex->pos();

        auto modifiers = parse_var_modifiers();

        if (TOK != token_type::identifier) {
            throw parse_error(filename, lex->pos(), "expected identifier in argument declaration");
        }
        auto id = make_identifier_node(*ast_arena, lex->pos(), { lex->string_value() });
        lex->next();

        arena_ptr<ast_node> var_type{ nullptr, nullptr };
        if (TOK_CHAR == ':') {
            lex->next();
            var_type = parse_type_expr();
        }

        arena_ptr<ast_node> value{ nullptr, nullptr };
        if (TOK_CHAR == '=') {
            lex->next();
            value = parse_expr();
        }

        return make_var_decl_node_single(*ast_arena, pos, kind, std::move(id), std::move(var_type), std::move(value), modifiers);
    }

    arena_ptr<ast_node> parse_var_decl(token_type kind) {
        auto pos = lex->pos();

        auto modifiers = parse_var_modifiers();
        auto declkind = TOK;

        if (TOK == kind) {
            lex->next();
        }

        if (TOK_CHAR == '{') {
            lex->next();
        }

        auto ids = parse_identifier_list();
        if (!ids) {
            throw parse_error(filename, lex->pos(), "expected one or more identifiers in variable declaration");
        }

        if (TOK_CHAR == '}') {
            lex->next();
        }

        // ':' type
        arena_ptr<ast_node> var_type{nullptr, nullptr};
        if (TOK_CHAR == ':') {
            lex->next();
            var_type = parse_type_expr();
        }

        // '=' value
        arena_ptr<ast_node> value{nullptr, nullptr};
        if (TOK_CHAR == '=') {
            lex->next();
            value = parse_expr();
        }

        if (!var_type.get() && !value.get()) {
            throw parse_error(filename, lex->pos(), "variable declaration without type and initializer not allowed");
        }

        return make_var_decl_node(*ast_arena, pos, kind, std::move(ids), std::move(var_type), std::move(value), modifiers);
    }

    std::vector<token_type> parse_var_modifiers() {
        std::vector<token_type> mods;
        while (TOK == token_type::pure) {
            mods.push_back(TOK);
            lex->next();
        }
        return mods;
    }

    arena_ptr<ast_node> parse_identifier_list() {
        auto id = parse_qualified_identifier();
        if (!id) {
            return { nullptr, nullptr };
        }

        auto list = make_arg_list_node(*ast_arena, id->pos, {});
        list->children.push_back(std::move(id));

        while (TOK_CHAR == ',') {
            lex->next();

            if (TOK == token_type::identifier) {
                auto pos = lex->pos();

                auto curexpr = parse_qualified_identifier();
                if (curexpr) {
                    if (TOK == token_type::dotdotdot) {
                        lex->next();
                        curexpr = make_rest_expr_node(*ast_arena, pos, std::move(curexpr));
                    }
                    list->children.push_back(std::move(curexpr));
                }
                else {
                    break;
                }
            }
        }

        return list;
    }

    // Section: expressions

    arena_ptr<ast_node> parse_expr() {
        return parse_ternary_expr();
    }

    arena_ptr<ast_node> parse_ternary_expr() {
        auto expr = parse_binary_expr(parse_unary_expr(), 0);
        if (false && TOK == token_type::then) {
            lex->next();

            auto then_expr = parse_expr();
            if (!then_expr) {
                throw parse_error(filename, expr->pos, "expected then-expression in ternary operator");
            }

            if (TOK != token_type::else_) {
                throw parse_error(filename, expr->pos, "expected 'else' token in ternary operator");
            }
            lex->next();

            auto else_expr = parse_expr();
            if (!else_expr) {
                throw parse_error(filename, expr->pos, "expected else-expression in ternary operator");
            }

            return make_ternary_expr_node(*ast_arena, expr->pos, std::move(expr), std::move(then_expr), std::move(else_expr));
        }
        return expr;
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
                auto thisop = TOK;
                rhs = parse_binary_expr(std::move(rhs), precedence(thisop));
            }

            lhs = make_binary_expr_node(*ast_arena, pos, op, std::move(lhs), std::move(rhs));
        }

        return std::move(lhs);
    }

    // unary_expr -> unary_op cast_expr
    arena_ptr<ast_node> parse_unary_expr() {
        auto pos = lex->pos();
        auto op = TOK;
        
        if (is_unary_op(op)) {
            lex->next();
            return make_unary_expr_node(*ast_arena, pos, op, parse_cast_expr());
        }
        
        return parse_cast_expr();
    }

    // cast_expr -> 'cast' '(' type_expr ')' unary_expr
    arena_ptr<ast_node> parse_cast_expr() {
        auto pos = lex->pos();
        if (TOK == token_type::cast_) {
            lex->next();

            if (TOK_CHAR != '(') {
                throw parse_error(filename, lex->pos(), "invalid cast expression");
            }
            lex->next();

            auto type_expr = parse_type_expr();
            if (TOK_CHAR != ')') {
                throw parse_error(filename, lex->pos(), "invalid cast expression");
            }
            lex->next();

            auto value = parse_unary_expr();
            if (!value) {
                throw parse_error(filename, lex->pos(), "invalid cast expression");
            }

            return make_cast_expr_node(*ast_arena, pos, std::move(type_expr), std::move(value));
        }

        return parse_init_expr();
    }

    // init_expr -> (type_expr '{' init_list '}') | call_or_index_or_field_expr
    arena_ptr<ast_node> parse_init_expr() {
        auto pos = lex->pos();
        auto expr = parse_call_or_index_or_field_expr();
        if (expr) {
            if (TOK_CHAR == '{') {
                auto to_type_expr = transform_to_type_expr(std::move(expr));
                return parse_init_list_expr(std::move(to_type_expr));
            }
        }
        else {
            auto try_type = parse_type_expr(true);
            if (try_type) {
                return parse_init_list_expr(std::move(try_type));
            }
        }
        return expr;
    }

    // call_or_index_or_field_expr
    //      -> primary_expr '(' arg_list ')'
    //      -> primary_expr '[' braceless_tuple_expr ']'
    //      -> primary_expr '.' identifier
    arena_ptr<ast_node> parse_call_or_index_or_field_expr() {
        auto pos = lex->pos();
        auto expr = parse_primary_expr();
        while (expr && (TOK_CHAR == '(' || TOK_CHAR == '[' || TOK_CHAR == '.' || TOK_CHAR == ':')) {
            if (TOK_CHAR == '(') {
                auto arg_list = parse_arg_list(')', [this]() {
                    return parse_expr();
                });
                expr = make_call_expr_node(*ast_arena, pos, std::move(expr), std::move(arg_list));
            }
            else if (TOK_CHAR == ':') {
                auto arg_list = parse_arg_list(';', [this]() {
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

    arena_ptr<ast_node> parse_primary_expr() {
        auto pos = lex->pos();
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
        case token_type::nil: {
            scope_guard _{ [this]() { lex->next(); } };
            return make_nil_node(*ast_arena, lex->pos());
        }
        case token_type::noinit:
        case token_type::placeholder: {
            scope_guard _{ [this]() { lex->next(); } };
            return make_init_tag_node(*ast_arena, lex->pos(), TOK);
        }
        case token_type::identifier: {
            auto id = parse_qualified_identifier();
            if (TOK_CHAR == '\\') {
                lex->next();
                // function overload selector
                auto type = parse_type_expr();
                return make_func_overload_selector_expr_node(*ast_arena, id->pos, std::move(id), std::move(type));
            }
            return id;
        }
        case token_type::fun: {
            return parse_func_decl(/*as_expr=*/true);
        }
        case token_type::range: {
            return parse_range_expr();
        }
        case token_type::type: {
            auto pos = lex->pos();
            lex->next();

            auto expr = parse_type_expr();
            if (!expr) {
                throw parse_error(filename, lex->pos(), "expected type expression after 'type'");
            }
            return make_const_expr_node(*ast_arena, pos, std::move(expr));
        }
        case token_type::dotdotdot: {
            auto pos = lex->pos();
            lex->next();
            return make_rest_expr_node(*ast_arena, pos, { nullptr, nullptr });
        }
        case token_type::do_: {
            return parse_compound_stmt({}, true);
        }
        case token_type::if_: {
            return parse_if_stmt(true);
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
            case '#': {
                lex->next();
                auto expr = parse_call_or_index_or_field_expr();
                if (expr->type != ast_type::call_expr) {
                    throw parse_error(filename, lex->pos(), "expected built-in function call after '#'");
                }
                expr->type = ast_type::builtin_call_expr;
                return expr;
            }
            default: {
                if (is_unary_op(TOK)) {
                    auto op = TOK;
                    lex->next();
                    return make_unary_expr_node(*ast_arena, pos, op, parse_cast_expr());
                }
            }
            }

            if (TOK == token_type::eof) {
                throw parse_error(filename, lex->pos(), "unexpected end of file");
            }
        }
        }
        return arena_ptr<ast_node>{nullptr, nullptr};
    }

    arena_ptr<ast_node> parse_range_expr() {
        auto pos = lex->pos();

        lex->next();

        auto list = make_arg_list_node(*ast_arena, pos, {});
        
        auto expr = parse_expr();
        list->children.push_back(std::move(expr));

        while (TOK_CHAR == ',') {
            lex->next();
            auto curexpr = parse_expr();
            if (curexpr) {
                list->children.push_back(std::move(curexpr));
            }
            else {
                break;
            }
        }

        return make_range_expr_node(*ast_arena, pos, std::move(list));
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

                    if (TOK_CHAR == '=') {
                        throw parse_error(filename, lex->pos(), "expected '=' in designated initializer");
                    }
                    lex->next();

                    auto value = parse_expr();
                    if (!value) {
                        throw parse_error(filename, lex->pos(), "expected value in designated initializer");
                    }

                    // TODO: specialized node type needed?
                    return make_var_decl_node_single(*ast_arena, pos, token_type::let, std::move(id), { nullptr, nullptr }, std::move(value), {});
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
        auto pos = lex->pos();

        enum { LIMIT = 32 };
        int i = 0;

        std::vector<std::string> id_parts = { lex->string_value() };
        lex->next();
        
        return make_identifier_node(*ast_arena, pos, id_parts);
    }

    arena_ptr<ast_node> parse_arg_list(char end, std::function<arena_ptr<ast_node>()> parse_arg) {
        enum { LIMIT = 32*1000 };
        std::vector<arena_ptr<ast_node>> args;

        auto pos = lex->pos();
        lex->next(); // eat the '('

        // parse args
        if ((int)(TOK) != (int)end) {
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

        char tokchar = TOK_CHAR;

        if ((int)(TOK) != (int)end) {
            if (end != ';') {
                throw parse_error(filename, lex->pos(), "expected closing parentheses in argument list");
            }
        }
        else {
            lex->next();
        }

        return make_arg_list_node(*ast_arena, pos, std::move(args));
    }

    arena_ptr<ast_node> transform_to_type_expr(arena_ptr<ast_node>&& expr) {
        if (expr->type == ast_type::call_expr) {
            std::vector<arena_ptr<ast_node>> args;
            for (auto& arg : expr->children[1]->children) {
                args.push_back(transform_to_type_expr(std::move(arg)));
            }

            auto ctor = make_type_constructor_instance_node(*ast_arena, expr->pos,
                transform_to_type_expr(std::move(expr->children[0])),
                make_arg_list_node(*ast_arena, {}, std::move(args)));

            return make_type_expr_node(*ast_arena, expr->pos, std::move(ctor));
        }
        else if (expr->type == ast_type::identifier) {
            return make_type_expr_node(*ast_arena, expr->pos, std::move(expr));
        }
        else {
            return std::move(expr);
        }
    }

    parse_context ctx() const { return ctx_stack.top(); }
};

parser::parser(memory_arena& arena, std::string_view src, const std::string& filename, const std::string& modname) : _impl{ new parser_impl{arena, src, filename, modname} } {}

parser::~parser() { delete _impl; }

arena_ptr<ast_node> parser::parse_decl_list() { return _impl->parse_decl_list(); }

arena_ptr<ast_node> parser::parse_code_unit() { return _impl->parse_code_unit(); }

arena_ptr<ast_node> parser::parse_expr() { return _impl->parse_expr(); }

int parser::get_lines_parsed() { return _impl->lines_parsed; }

}