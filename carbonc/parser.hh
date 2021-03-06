#pragma once

#include <string_view>
#include "ast.hh"
#include "memory.hh"

namespace carbon {

struct parser_impl;

struct parser {
    parser_impl* _impl;

    explicit parser(memory_arena& ast_arena, std::string_view src, const std::string& filename, const std::string& modname);

    ~parser();

    arena_ptr<ast_node> parse_code_unit();

    arena_ptr<ast_node> parse_decl_list();

    arena_ptr<ast_node> parse_expr();

    int get_lines_parsed();
};

}