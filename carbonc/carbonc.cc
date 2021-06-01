#include <iostream>
#include <fstream>
#include <cstdio>
#include <chrono>
#include "common.hh"
#include "parser.hh"
#include "prettyprint.hh"
#include "fs.hh"
#include "exception.hh"
#include "type_system.hh"
#include "codegen.hh"
#include "ir.hh"

namespace carbon {

std::string get_source_code_near(const std::string& src, const position& pos) {
    auto upuntil = src.substr(0, pos.src_offs);
    auto firstline = upuntil.find_last_of('\n');
    auto line = src.substr(firstline + 1, (src.find_first_of('\n', pos.src_offs) - firstline - 1));
    return line;
}

void compile_file(type_system& ts, ast_node& target, const std::string& filename) {
    std::string src;
    if (!read_file_text(filename, src)) return;

    auto timebegin = std::chrono::system_clock::now();
    std::cout << "carbonc - parsing file: " << filename << "\n";

    parser p{ *ts.ast_arena, src, filename };
    arena_ptr<ast_node> ast{ nullptr, nullptr };

    try {
        ast = p.parse_code_unit();
    }
    catch (const parse_error& e) {
        std::cerr << "carbonc - parse error: " << e.what() << "\n";
        auto line = get_source_code_near(src, e.pos);
        std::cerr << "                       " << line << "\n";
        return;
    }

    if (true) {
        ensure_directory_exists("../../tests/ast/" + filename);
        std::ofstream ast_file{ "../../tests/ast/" + filename };
        prettyprint(*ast, ast_file);
        ast_file << "\n";
    }

    ts.process_code_unit(*ast);
    target.children.push_back(std::move(ast));

    auto dur = std::chrono::system_clock::now() - timebegin;
    std::cout << "carbonc - parsing time: " << std::chrono::duration_cast<std::chrono::milliseconds>(dur).count() << "ms\n\n";
}

void process_directory(type_system& ts, ast_node& target, const std::string& dir) {
    for (const auto& file : list(dir)) {
        if (file.find(".cb") != std::string::npos) {
            compile_file(ts, target, join(dir, file));
        }

        if (is_directory(join(dir, file))) {
            process_directory(ts, target, join(dir, file));
        }
    }
}

int run_project_mode() {
    auto timebegin = std::chrono::system_clock::now();
    std::cout << "carbonc - compiling target: std " << "\n\n";

    memory_arena ast_arena{ 1024 * 1024 };
    type_system ts{ ast_arena };

    auto target_node = make_in_arena<ast_node>(ast_arena);
    target_node->type = ast_type::target;

    process_directory(ts, *target_node, "std");

    {
        auto ctimebegin = std::chrono::system_clock::now();
        std::cout << "carbonc - type checking " << "\n";
        ts.resolve_and_check();
        auto cdur = std::chrono::system_clock::now() - ctimebegin;
        std::cout << "carbonc - type checking time: " << std::chrono::duration_cast<std::chrono::milliseconds>(cdur).count() << "ms\n\n";
    }

    if (!ts.errors.empty()) {
        int errcount = 0;
        int maxerrs = 10;

        for (const auto& err : ts.errors) {
            if (errcount >= maxerrs) break;

            // TODO: please
            std::cerr << "----------------------------------------------------------------------------------\n";
            std::string src;
            if (!read_file_text(err.filename, src)) return 1;

            std::cerr << err.msg << "";
            auto line = get_source_code_near(src, err.pos);
            std::cerr << "\n[" << err.filename << ":" << err.pos.line_number << "] " << line << "\n";

            int extra_offs = err.filename.size() + std::to_string(err.pos.line_number).size() + 4;
            for (int i = 1; i < err.pos.col_offs + extra_offs; i++) {
                std::cerr << " ";
            }
            std::cerr << "^\n";
            errcount++;
        }

        if (ts.errors.size() > errcount) {
            std::cerr << "----------------------------------------------------------------------------------\n";
            std::cerr << "carbonc - more " << (ts.errors.size() - errcount) << " errors were found, but only " << maxerrs << " were reported\n";
            std::cerr << "carbonc - use the '--maxerrors {n}' option to change the error limit\n";
        }
        return 1;
    }

    auto irprog = generate_ir(ts, *target_node);

    ensure_directory_exists("../_carbon/build/std.asm");

    {
        auto ctimebegin = std::chrono::system_clock::now();
        std::cout << "carbonc - generating: std.asm " << "\n";
        codegen(irprog, &ts, "../_carbon/build/std.asm");
        auto cdur = std::chrono::system_clock::now() - ctimebegin;
        std::cout << "carbonc - code generation time: " << std::chrono::duration_cast<std::chrono::milliseconds>(cdur).count() << "ms\n\n";
    }

    auto dur = std::chrono::system_clock::now() - timebegin;
    std::cout << "carbonc - compilation time: " << std::chrono::duration_cast<std::chrono::milliseconds>(dur).count() << "ms\n";

    return 0;
}

int main(int argc, const char* argv[]) {
    memory_arena ast_arena{ 1024*1024 };

    if (true) {
        return run_project_mode();
    }

    auto parser_test_files = {
        "parse-000-expression.cb", "parse-001-var_declaration.cb", "parse-002-func_declaration.cb",
        "parse-003-type_declaration.cb", "parse-004-vecmath.cb", "parse-005-asm.cb", "parse-006-externfunc.cb",
        "parse-007-import.cb"
    };
    for (const std::string& filename : parser_test_files) {
        std::string src;
        if (!read_file_text("tests/"+filename, src)) continue;

        parser p{ ast_arena, src, "tests/" + filename };
        arena_ptr<ast_node> ast{ nullptr, nullptr };

        try {
            ast = p.parse_code_unit();
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
    }

#if 0
    auto compiler_test_files = {
        "compile-000-main.cb", "compile-001-local_vars.cb", "compile-002-func_call.cb", "compile-003-strings.cb",
        "compile-004-asm.cb", "compile-005-externfunc.cb"
    };
    for (const std::string& filename : compiler_test_files) {
        std::string src;
        if (!read_file_text("tests/" + filename, src)) continue;

        auto timebegin = std::chrono::system_clock::now();
        std::cout << "compiling file: " << filename << "\n";

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
        codegen(*ast, &ts, "tests/asm/" + fn);

        auto dur = std::chrono::system_clock::now() - timebegin;
        std::cout << "compilation took " << std::chrono::duration_cast<std::chrono::milliseconds>(dur).count() << "ms\n\n";

        //std::cout << ("ml64.exe tests/asm/" + fn + " /link /entry:main") << std::endl;
        //std::FILE* assembler = _popen(("ml64.exe tests/asm/"+ fn + " /link /entry:main").c_str(), "r");
        //_pclose(assembler);
    }
#endif

    return 0;
}

}