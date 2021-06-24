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

#define WIN32_LEAN_AND_MEAN
#include <Windows.h>

namespace carbon {

struct project_info {
    std::string working_dir;
    std::string target_name;
    std::string cb_path;
    bool objonly = false;
};

std::string get_source_code_near(const std::string& src, const position& pos) {
    auto upuntil = src.substr(0, pos.src_offs);
    auto firstline = upuntil.find_last_of('\n');
    auto line = src.substr(firstline + 1, (src.find_first_of('\n', pos.src_offs) - firstline - 1));
    return line;
}

void compile_file(type_system& ts, ast_node& target, const std::string& filename, const std::string& modname) {
    std::string src;
    if (!read_file_text(filename, src)) return;

    auto timebegin = std::chrono::system_clock::now();
    std::cout << "carbonc - compiling file: " << filename << "\n";

    parser p{ *ts.ast_arena, src, filename, modname };
    arena_ptr<ast_node> ast{ nullptr, nullptr };

    try {
        ast = p.parse_code_unit();
    }
    catch (const parse_error& e) {
        std::cerr << "carbonc - parse error: " << e.what() << "\n";
        auto line = get_source_code_near(src, e.pos);
        std::cerr << "                       " << line << "\n";
        exit(EXIT_FAILURE);
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
    //std::cout << "carbonc - parsing time: " << std::chrono::duration_cast<std::chrono::milliseconds>(dur).count() << "ms\n\n";
}

void process_directory(type_system& ts, ast_node& target, const std::string& dir, const std::string& srcdir) {
    for (const auto& file : list(dir)) {
        auto fullpath = join(dir, file);
        if (file.find(".cb") != std::string::npos) {
            compile_file(ts, target, fullpath, fullpath.substr(srcdir.size() + 1));
        }

        if (is_directory(join(dir, file))) {
            process_directory(ts, target, fullpath, srcdir);
        }
    }
}

void process_source_directory(type_system& ts, ast_node& target, const std::string& srcdir) {
    process_directory(ts, target, srcdir, srcdir);
}

const char* find_arg(const char* name, int argc, const char* argv[]) {
    for (int i = 1; i < argc; i++) {
        if (!strcmp(name, argv[i]) && i < argc - 1) {
            return argv[i + 1];
        }
    }
    return NULL;
}

bool has_arg(const char* name, int argc, const char* argv[]) {
    for (int i = 1; i < argc; i++) {
        if (!strcmp(name, argv[i])) {
            return true;
        }
    }
    return false;
}

std::string run_assembler(const project_info& p, const std::string& asm_file) {
#ifdef _WIN32
    auto nasm_cmd = p.cb_path + "/bin/win64/nasm.exe -fwin64 " + asm_file;
    FILE* ph = _popen(nasm_cmd.c_str(), "r");
    _pclose(ph);
    
    std::string obj_file = asm_file;
    replace(obj_file, ".asm", ".obj");
    return obj_file;
#endif
}

std::string run_linker(const project_info& p, const std::string& obj_file) {
#ifdef _WIN32
    auto cmd = p.cb_path + "/bin/win64/GoLink.exe " + obj_file + " /console /entry carbon_main kernel32.dll shell32.dll ucrtbase.dll";
    FILE* ph = _popen(cmd.c_str(), "r");
    _pclose(ph);

    std::string exe_file = obj_file;
    replace(exe_file, ".obj", ".exe");
    return exe_file;
#endif
}

int run_project_mode(int argc, const char* argv[]) {
    auto timebegin = std::chrono::system_clock::now();

    char dirnamebuf[_MAX_PATH];
    GetCurrentDirectory(sizeof(dirnamebuf), dirnamebuf);

    auto dirname = basename(from_native_path(std::string{ dirnamebuf }));

    std::cout << "carbonc - compiling target: " << dirname << "\n\n";

    project_info p;
    const char* cbpath = getenv("CARBON_PATH");
    if (!cbpath) {
        cbpath = find_arg("--carbon-path", argc, argv);
    }

    if (!cbpath) {
        std::cerr << "carbonc - error: environment variable CARBON_PATH or command-line argument --carbon-path are required to compile!\n";
        return 1;
    }
    p.cb_path = cbpath;
    p.target_name = dirname;
    p.working_dir = from_native_path(std::string{ dirnamebuf });

    memory_arena ast_arena{ 1024 * 1024 };
    type_system ts{ ast_arena };

    auto target_node = make_in_arena<ast_node>(ast_arena);
    target_node->type = ast_type::target;

    auto builtin_library_path = join(join(std::string{ cbpath }, "builtin"), "src");
    auto std_library_path = join(join(std::string{ cbpath }, "std"), "src");

    process_source_directory(ts, *target_node, "./src");
    process_source_directory(ts, *target_node, builtin_library_path);

    bool embed_std_lib = has_arg("--embed-std", argc, argv);
    if (embed_std_lib) {
        process_source_directory(ts, *target_node, std_library_path);
    }

    {
        auto ctimebegin = std::chrono::system_clock::now();
        //std::cout << "carbonc - type checking " << "\n";
        ts.resolve_and_check();
        auto cdur = std::chrono::system_clock::now() - ctimebegin;
        //std::cout << "carbonc - type checking time: " << std::chrono::duration_cast<std::chrono::milliseconds>(cdur).count() << "ms\n\n";
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

    ensure_directory_exists("_carbon/build_debug/.");
    ensure_directory_exists("_carbon/out_debug/.");

    {
        std::ofstream ast_file{"_carbon/build_debug/" + dirname + ".ast" };
        prettyprint(*target_node, ast_file);
        ast_file << "\n";
    }

    auto irprog = generate_ir(ts, *target_node);

    auto asm_file = "_carbon/build_debug/" + dirname + ".asm";

    {
        auto ctimebegin = std::chrono::system_clock::now();
        //std::cout << "carbonc - generating: std.asm " << "\n";
        codegen(irprog, &ts, asm_file);
        auto cdur = std::chrono::system_clock::now() - ctimebegin;
        //std::cout << "carbonc - code generation time: " << std::chrono::duration_cast<std::chrono::milliseconds>(cdur).count() << "ms\n\n";
    }

    auto obj_file = run_assembler(p, asm_file);
    bool objonly = has_arg("--obj", argc, argv);

    if (!objonly) {
        auto exe_file = run_linker(p, obj_file);
        auto out_file = std::string{ "_carbon/out_debug/" } + basename(exe_file);
        MoveFileExA(exe_file.c_str(), out_file.c_str(), MOVEFILE_REPLACE_EXISTING);
        const char* outpath = find_arg("-o", argc, argv);
        if (outpath) {
            CopyFileA(out_file.c_str(), outpath, false);
        }
        else {
            outpath = out_file.c_str();
        }

        std::cout << "carbonc - output: " << outpath << "\n";
    }

    auto dur = std::chrono::system_clock::now() - timebegin;
    std::cout << "\ncarbonc - compilation time: " << std::chrono::duration_cast<std::chrono::milliseconds>(dur).count() << "ms\n";

    return 0;
}

int main(int argc, const char* argv[]) {
    memory_arena ast_arena{ 1024*1024 };

    if (true) {
        return run_project_mode(argc, argv);
    }

#if 0
    auto parser_test_files = {
        "parse-000-expression.cb", "parse-001-var_declaration.cb", "parse-002-func_declaration.cb",
        "parse-003-type_declaration.cb", "parse-004-vecmath.cb", "parse-005-asm.cb", "parse-006-externfunc.cb",
        "parse-007-import.cb"
    };
    for (const std::string& filename : parser_test_files) {
        std::string src;
        if (!read_file_text("tests/"+filename, src)) continue;

        parser p{ ast_arena, src, "tests/" + filename, filename };
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