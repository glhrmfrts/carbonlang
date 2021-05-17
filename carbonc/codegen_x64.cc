#include <fstream>
#include <cstdarg>
#include "codegen.hh"
#include "common.hh"

namespace carbon {

enum gen_register {
    invalid,
    rax,
    rbx,
    rcx,
    rdx,
    r8,
    r9,
    eax,
    ebx,
    ecx,
    edx,
    r8d,
    r9d,
};

struct gen_register_sizes {
    gen_register r64;
    gen_register r32;
    gen_register r16;
    gen_register r8high;
    gen_register r8low;
};

struct exprarg {
    gen_register dest;
};

static const gen_register arg_registers[] = {
    ecx, edx, r8d, r9d,
    rcx, rdx, r8, r9,
};

static const gen_register_sizes rsizes[] = {
    {},
    {rax, eax, invalid, invalid, invalid},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
};

static const char* rnames[] = {
    "invalid",
    "rax",
    "rbx",
    "rcx",
    "rdx",
    "r8",
    "r9",
    "eax",
    "ebx",
    "ecx",
    "edx",
    "r8d",
    "r9d",
};

auto rfortype(gen_register r, type_id tid) {
    auto tdef = tid.scope->scope.type_defs[tid.type_index];
    auto sizes = rsizes[r];
    switch (tdef->size) {
    case 1:
        return sizes.r8low;
    case 2:
        return sizes.r16;
    case 4:
        return sizes.r32;
    case 8:
        return sizes.r64;
    }
}

struct generator {
    std::string_view filename;
    std::ofstream asm_file;

    void generate_program(ast_node& node) {
        std::string fn{filename.data()};
        replace(fn, ".cb", ".asm");
        asm_file.open(fn);

        emit_data_segment();
        emit_code_segment(node);

        asm_file << "END";
        asm_file.close();
    }

    void emit_data_segment() {
        asm_file << ".data\n";
    }

    void emit_code_segment(ast_node& node) {
        asm_file << ".code\n";

        generate_node(node);
    }

    template <typename T> void emit(T&& single) {
        asm_file << single;
    }

    template <typename Arg, typename... Args> void emit(Arg&& arg, Args&&... args) {
        emit(arg);
        emit(std::forward<Args>(args)...);
    }

    void emitf(const char* fmt, ...) {
        static char buffer[1024];
        std::va_list args;
        va_start(args, fmt);
        std::vsnprintf(buffer, sizeof(buffer), fmt, args);
        va_end(args);
        emit(buffer);
        emit("\n");
    }

    void generate_node(ast_node& node, exprarg* arg = nullptr) {
        switch (node.type) {
        case ast_type::func_decl:
            generate_func(node);
            break;
        case ast_type::return_stmt:
            generate_return_stmt(node);
            break;
        case ast_type::int_literal:
            generate_int_literal(node, arg);
            break;
        default:
            for (auto& child : node.children) {
                if (child) {
                    generate_node(*child);
                }
            }
        }
    }

    void generate_func(ast_node& node) {
        emit(node.local.id_node->string_value, " PROC\n");
        for (auto& child : node.children) {
            if (child) {
                generate_node(*child);
            }
        }
        emit(node.local.id_node->string_value, " ENDP\n");
    }

    void generate_return_stmt(ast_node& node) {
        auto& expr = node.children[0];
        if (expr) {
            exprarg arg = { rax };
            generate_node(*expr, &arg);
        }
        emit(" ret\n");
    }

    void generate_int_literal(ast_node& node, exprarg* arg) {
        emitf(" mov %s,%d", rnames[rfortype(arg->dest, node.type_id)], node.int_value);
    }
};

void codegen(ast_node& node, std::string_view filename) {
    generator gen;
    gen.filename = filename;
    gen.generate_program(node);
}

}