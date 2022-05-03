#include <iostream>
#include <fstream>
#include <cstdio>
#include <cstring>
#include <chrono>
#include <deque>
#include "common.hh"
#include "parser.hh"
#include "prettyprint.hh"
#include "fs.hh"
#include "exception.hh"
#include "type_system.hh"
#include "codegen.hh"
#include "ir.hh"

// TODO: search for .s files and compile them as well as individual objects
// TODO: look for a unit.cb file in a directory and treat that directory as a separate unit (?)

#ifdef _WIN32

#define WIN32_LEAN_AND_MEAN
#include <Windows.h>

#else

#include <unistd.h>

#endif

namespace carbon {

struct project_info {
    std::string working_dir;
    std::string target_name;
    std::string cb_path;
    std::string entrypoint;
    std::vector<std::string> asm_obj_files;
    target_type target;
    bool freestanding = false;
    bool embed_std = false;
    bool link_libc = false;
    bool objonly = false;
    bool verbose = false;
};

static project_info proj;

std::string run_assembler(const project_info& p, const std::string& asm_file);

std::string get_source_code_near(const std::string& src, const position& pos) {
    auto upuntil = src.substr(0, pos.src_offs);
    auto firstline = upuntil.find_last_of('\n');
    auto line = src.substr(firstline + 1, (src.find_first_of('\n', pos.src_offs) - firstline - 1));
    return line;
}

static int total_lines_parsed;

void compile_file(type_system& ts, const std::string& filename, const std::string& modname) {
    std::string src;
    if (!read_file_text(filename, src)) return;

    auto timebegin = std::chrono::system_clock::now();
    //std::cout << "carbonc - compiling file: " << filename << "\n";

    parser p{ *ts.ast_arena, src, filename, modname };
    arena_ptr<ast_node> ast{ nullptr, nullptr };

    try {
        ast = p.parse_code_unit();
        if (!ast) {
            throw parse_error("Sorry what", {});
        }
    }
    catch (const parse_error& e) {
        std::cerr << "carbonc - parse error: " << e.what() << "\n";
        auto line = get_source_code_near(src, e.pos);
        std::cerr << "                       " << line << "\n";
        exit(EXIT_FAILURE);
    }

    total_lines_parsed += p.get_lines_parsed();

    ts.process_code_unit(std::move(ast));

    auto dur = std::chrono::system_clock::now() - timebegin;
    //std::cout << "carbonc - parsing time: " << std::chrono::duration_cast<std::chrono::milliseconds>(dur).count() << "ms\n\n";
}

void process_directory(type_system& ts, const std::string& dir, const std::string& srcdir) {
    auto modname = dir;
    while (replace(modname, srcdir, ""));

    if (!modname.empty()) {
        while (modname.size() && modname[0] == '/') {
            modname = modname.substr(1);
        }
        while (modname.size() && modname[modname.size() - 1] == '/') {
            modname = modname.substr(0, modname.size() - 1);
        }
    }

    if (modname.empty()) {
        modname = "root";
    }
    ts.add_module(modname);

    for (const auto& file : list(dir)) {
        auto fullpath = join(dir, file);

        if (!is_directory(fullpath)) {
            if (file.find(".cb") != std::string::npos) {
                auto mname = fullpath.substr(srcdir.size() + 1);
                compile_file(ts, fullpath, mname);
            }

            if ((file.find(".s") != std::string::npos) || (file.find(".asm") != std::string::npos)) {
                auto modname = fullpath.substr(srcdir.size() + 1);
                while (replace(modname, "/", "_"));
                std::cout << "assembly file: " << modname << std::endl;

                auto asm_file = "_carbon/build_debug/" + modname;
                copyfile(fullpath, asm_file);
                proj.asm_obj_files.push_back(run_assembler(proj, asm_file));
            }
        }
    }
    ts.end_module();

    for (const auto& file : list(dir)) {
        auto fullpath = join(dir, file);

        if (is_directory(fullpath)) {
            process_directory(ts, fullpath, srcdir);
        }
    }
}

void process_source_directory(type_system& ts, const std::string& srcdir) {
    process_directory(ts, srcdir, srcdir);
}

const char* find_arg(const char* name, const char* shortname, int argc, const char* argv[]) {
    for (int i = 1; i < argc; i++) {
        if ((!strcmp(name, argv[i]) || !strcmp(shortname, argv[i])) && i < argc - 1) {
            return argv[i + 1];
        }
    }
    return NULL;
}

bool has_arg(const char* name, const char* shortname, int argc, const char* argv[]) {
    for (int i = 1; i < argc; i++) {
        if (!strcmp(name, argv[i]) || !strcmp(shortname, argv[i])) {
            return true;
        }
    }
    return false;
}

std::string run_assembler(const project_info& p, const std::string& asm_file) {
    std::string obj_file = asm_file;

#ifdef _WIN32
    replace(obj_file, ".asm", ".obj");

    auto nasm_cmd = p.cb_path + "/bin/win64/nasm.exe -fwin64 " + asm_file;
    if (p.verbose) {
        std::cout << "carbonc - running assembler: " << nasm_cmd << std::endl;
    }

    FILE* ph = _popen(nasm_cmd.c_str(), "r");
    _pclose(ph);
    
    return obj_file;
#else
    replace(obj_file, ".asm", ".o");
    replace(obj_file, ".s", ".o");

    std::string as_cmd = "as " + asm_file;
    as_cmd.append(" -o ");
    as_cmd.append(obj_file);

    if (p.verbose) {
        std::cout << "carbonc - running assembler: " << as_cmd << std::endl;
    }

    FILE* ph = popen(as_cmd.c_str(), "r");
    pclose(ph);

    return obj_file;
#endif
}

std::string run_linker(
    const project_info& p
) {
#ifdef _WIN32
    std::string out_file = "_carbon/build_debug/" + p.target_name + ".exe";
    std::string ld_file = p.asm_obj_files.front();
    replace(ld_file, ".obj", ".exe");

    auto cmd = p.cb_path + "/bin/win64/GoLink.exe ";
    for (const auto& objfile : p.asm_obj_files) {
        cmd.append(" ");
        cmd.append(objfile);
    }
    if (p.target == target_type::executable) {
        cmd.append(" /console /entry "+ p.entrypoint);
        replace(out_file, ".obj", ".exe");
    }
    else if (p.target == target_type::dynamic_library) {
        cmd.append(" /dll ");
        replace(out_file, ".exe", ".dll");
    }
    else {
        fprintf(stderr, "Static library not supported in windows, for now!");
        exit(EXIT_FAILURE);
    }

    cmd.append(" kernel32.dll shell32.dll ucrtbase.dll ");

    if (!p.freestanding && !p.embed_std) {
        cmd.append(p.cb_path + "/std/_carbon/out_debug/std.dll ");
    }

    if (p.verbose) {
        std::cout << "carbonc - running linker command: " << cmd << "\n";
    }

// Execute the command
    FILE* ph = _popen(cmd.c_str(), "r");
    while (!feof(ph)) {
        char buf[512];
        memset(buf, 0, sizeof(buf));
        fgets(buf, 512, ph);
        std::cout << buf;
    }
    _pclose(ph);

    MoveFileExA(ld_file.c_str(), out_file.c_str(), MOVEFILE_REPLACE_EXISTING);
    
    return out_file;
#else
    std::string out_file = "_carbon/build_debug/" + p.target_name;

    std::string cmd = "ld ";
    if (p.target == target_type::executable) {
        cmd.append(" -e "+ p.entrypoint);
    }
    else if (p.target == target_type::dynamic_library) {
        cmd.append(" -shared ");
        out_file = "_carbon/build_debug/" + p.target_name + ".so";
    }
    else {
        out_file = "_carbon/build_debug/" + p.target_name + ".a";
    }
    cmd.append(" -o ");
    cmd.append(out_file);

    for (const auto& obj_file : p.asm_obj_files) {
        cmd.append(" ");
        cmd.append(obj_file);
    }

    if (p.verbose) {
        std::cout << "carbonc - running linker command: " << cmd << "\n";
    }

// Execute the command
    FILE* ph = popen(cmd.c_str(), "r");
    while (!feof(ph)) {
        char buf[512];
        memset(buf, 0, sizeof(buf));
        fgets(buf, 512, ph);
        std::cout << buf;
    }
    pclose(ph);
    
    return out_file;
#endif
}

void parse_options(project_info& p, int argc, const char* argv[]) {
    bool embed_std_lib = has_arg("--embed-std", "-std", argc, argv);

    const char* entrypoint = find_arg("--entrypoint", "-e", argc, argv);
    if (!entrypoint) {
#ifdef _WIN32
        entrypoint = "carbon_main";
#else
        entrypoint = "_start";
#endif
    }

    const char* output_type = find_arg("--type", "-t", argc, argv);
    if (!output_type) {
        output_type = "executable";
    }

    target_type ttype = target_type::executable;
    if (!strcmp(output_type, "static")) {
        ttype = target_type::static_library;
    }
    else if (!strcmp(output_type, "dynamic")) {
        ttype = target_type::dynamic_library;
    }

    bool freestanding = has_arg("--freestanding", "-f", argc, argv);

    p.entrypoint = entrypoint;
    p.target = ttype;
    p.freestanding = freestanding;
    p.verbose = has_arg("--verbose", "-d", argc, argv);
    p.embed_std = embed_std_lib;
}

int run_project_mode(int argc, const char* argv[]) {
    auto timebegin = std::chrono::system_clock::now();

    char dirnamebuf[260];
    getworkingdir(sizeof(dirnamebuf), dirnamebuf);

    auto dirname = basename(from_native_path(std::string{ dirnamebuf }));

    std::cout << "carbonc - compiling target: " << dirname << "\n\n";

    const char* cbpath = getenv("CARBON_PATH");
    if (!cbpath) {
        cbpath = find_arg("--carbon-path", "-p", argc, argv);
    }

    if (!cbpath) {
        std::cerr << "carbonc - error: environment variable CARBON_PATH or command-line argument --carbon-path are required to compile!\n";
        return 1;
    }
    proj.cb_path = cbpath;
    proj.target_name = dirname;
    proj.working_dir = from_native_path(std::string{ dirnamebuf });

    memory_arena ast_arena{ 1024 * 1024 };
    type_system ts{ ast_arena };

    auto builtin_library_path = join(join(std::string{ cbpath }, "builtin"), "src");
    auto std_library_path = join(join(std::string{ cbpath }, "std"), "src");

    parse_options(proj, argc, argv);

    process_source_directory(ts, "./src");

    if (proj.embed_std) {
        process_source_directory(ts, std_library_path);
    }

    if (!proj.freestanding && (proj.target == target_type::executable)) {
        process_source_directory(ts, builtin_library_path);
    }

    if (proj.verbose) {
        auto cdur = std::chrono::system_clock::now() - timebegin;
        std::cout << "carbonc - parsing time: " << std::chrono::duration_cast<std::chrono::milliseconds>(cdur).count() << "ms\n\n";
    }

    {
        auto ctimebegin = std::chrono::system_clock::now();
        if (proj.verbose) {
            std::cout << "carbonc - type checking " << "\n";
        }
        ts.resolve_and_check();
        if (proj.verbose) {
            auto cdur = std::chrono::system_clock::now() - ctimebegin;
            std::cout << "carbonc - type checking time: " << std::chrono::duration_cast<std::chrono::milliseconds>(cdur).count() << "ms\n\n";
        }
    }

    if (!ts.errors.empty()) {
        int errcount = 0;
        int maxerrs = 10;

        for (const auto& err : ts.errors) {
            if (errcount >= maxerrs) break;

            errcount++;

            // TODO: please
            std::cerr << "----------------------------------------------------------------------------------\n";
            std::string src;
            if (!read_file_text(err.filename, src)) {
                std::cerr << err.msg << "";
                continue;
            }

            std::cerr << err.msg << "";
            auto line = get_source_code_near(src, err.pos);
            std::cerr << "\n[" << err.filename << ":" << err.pos.line_number << "] " << line << "\n";

            int extra_offs = err.filename.size() + std::to_string(err.pos.line_number).size() + 4;
            for (int i = 1; i < err.pos.col_offs + extra_offs; i++) {
                std::cerr << " ";
            }
            std::cerr << "^\n";
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

    std::deque<ir_program> irprogs;
    {
        auto ctimebegin = std::chrono::system_clock::now();
        if (proj.verbose) {
            std::cout << "carbonc - generating IR " << "\n";
        }

        for (auto& mod : ts.root->children) {
            irprogs.push_back(generate_ir(ts, *mod));
        }

        if (proj.verbose) {
            auto cdur = std::chrono::system_clock::now() - ctimebegin;
            std::cout << "carbonc - IR generation time: " << std::chrono::duration_cast<std::chrono::milliseconds>(cdur).count() << "ms\n\n";
        }
    }

    {
        auto ctimebegin = std::chrono::system_clock::now();
        if (proj.verbose) {
            std::cout << "carbonc - generating assembly " << "\n";
        }

        for (auto& mod : ts.root->children) {
            std::string asm_alias = mod->modname;
            while (replace(asm_alias, "/", "_"));

            std::string asm_file = "_carbon/build_debug/" + asm_alias + ".asm";
            codegen(irprogs.front(), &ts, asm_file);
            irprogs.pop_front();
            proj.asm_obj_files.push_back(run_assembler(proj, asm_file));
        }

        if (proj.verbose) {
            auto cdur = std::chrono::system_clock::now() - ctimebegin;
            std::cout << "carbonc - assembly generation time: " << std::chrono::duration_cast<std::chrono::milliseconds>(cdur).count() << "ms\n\n";
        }
    }

    bool objonly = has_arg("--obj", "-obj", argc, argv);
    if (!objonly) {
        auto ld_file = run_linker(proj);

        auto out_file = std::string{ "_carbon/out_debug/" } + basename(ld_file);

#ifdef _WIN32
        MoveFileExA(ld_file.c_str(), out_file.c_str(), MOVEFILE_REPLACE_EXISTING);
#else
        rename(ld_file.c_str(), out_file.c_str());
#endif
        

        const char* outpath = find_arg("--output", "-o", argc, argv);
        if (outpath) {
            //CopyFileA(out_file.c_str(), outpath, false);
        }
        else {
            outpath = out_file.c_str();
        }

        if (exists(outpath)) {
            std::cout << "carbonc - output: " << outpath << "\n";
        }
    }

    auto dur = std::chrono::system_clock::now() - timebegin;
    
    if (proj.verbose) {
        std::cout << "\ncarbonc - total lines parsed: " << total_lines_parsed;
        std::cout << "\ncarbonc - total compilation time: " << std::chrono::duration_cast<std::chrono::milliseconds>(dur).count() << "ms\n";
    }

    return 0;
}

int main(int argc, const char* argv[]) {
    memory_arena ast_arena{ 1024*1024 };

    if (true) {
        return run_project_mode(argc, argv);
    }

    return 0;
}

}