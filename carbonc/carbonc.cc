#include <iostream>
#include <fstream>
#include <cstdio>
#include "common.hh"
#include "parser.hh"
#include "prettyprint.hh"
#include "fs.hh"
#include "exception.hh"
#include "type_system.hh"
#include "codegen.hh"

namespace carbon {

int main(int argc, const char* argv[]) {
    memory_arena ast_arena{ 1024*1024 };

    for (const std::string& filename : {"parse-000-expression.cb", "parse-001-var_declaration.cb", "parse-002-func_declaration.cb",
                                        "parse-003-type_declaration.cb", "parse-004-vecmath.cb"}) {
        std::string src;
        if (!read_file_text("tests/"+filename, src)) continue;

        parser p{ ast_arena, src, "tests/" + filename };
        arena_ptr<ast_node> ast{ nullptr, nullptr };

        try {
            ast = p.parse_decl_list();
        }
        catch (const parse_error& e) {
            std::cerr << "carbonc - parse error: " << e.what() << "\n";

            auto upuntil = src.substr(0, e.pos.src_offs);
            auto firstline = upuntil.find_last_of('\n');
            auto line = src.substr(firstline, (src.find_first_of('\n', e.pos.src_offs) - firstline) + 20);

            std::cerr << "                       " << line << "\n";
            return 1;
        }

        std::ofstream ast_file{"tests/ast/"+filename};
        prettyprint(*ast, ast_file);
        ast_file << "\n";

        type_system ts{ ast_arena };
        ts.process_ast_node(*ast);
    }

    for (const std::string& filename : {"compile-000-main.cb", "compile-001-local_vars.cb", "compile-002-func_call.cb", "compile-003-strings.cb"}) {
        std::string src;
        if (!read_file_text("tests/" + filename, src)) continue;

        parser p{ ast_arena, src, "tests/" + filename };
        arena_ptr<ast_node> ast{ nullptr, nullptr };

        try {
            ast = p.parse_decl_list();
        }
        catch (const parse_error& e) {
            std::cerr << "carbonc - parse error: " << e.what() << "\n";

            auto upuntil = src.substr(0, e.pos.src_offs);
            auto firstline = upuntil.find_last_of('\n');
            auto line = src.substr(firstline, (src.find_first_of('\n', e.pos.src_offs) - firstline) + 20);

            std::cerr << "                       " << line << "\n";
            return 1;
        }

        type_system ts{ ast_arena };
        ts.process_ast_node(*ast);
        ts.resolve_and_check();

        std::string fn{ filename.data() };
        replace(fn, ".cb", ".asm");
        codegen(*ast, "tests/asm/" + fn);

        std::cout << ("ml64.exe tests/asm/" + fn + " /link /entry:main") << std::endl;
        std::FILE* assembler = _popen(("ml64.exe tests/asm/"+ fn + " /link /entry:main").c_str(), "r");
        _pclose(assembler);
    }

    return 0;
}

}