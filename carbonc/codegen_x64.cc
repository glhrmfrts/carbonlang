#include <fstream>
#include <cstdarg>
#include "codegen.hh"
#include "codegen_x64.hh"
#include "emitter_x64_windows.hh"
#include "common.hh"

namespace carbon {

struct exprarg {
    gen_register dest = invalid;
    bool parent_is_binary = false;
};

static const gen_register register_args[] = {
    ecx, edx, r8d, r9d,
    rcx, rdx, r8, r9,
};

static const gen_register_sizes register_sizes[] = {
    {},
    {rax, eax, invalid, invalid, invalid},
    {},
    {},
    {rdx, edx, invalid, invalid, invalid},
    {rdi, edi, invalid, invalid, invalid},
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


auto register_for_type(gen_register r, type_id tid) {
    auto tdef = tid.scope->scope.type_defs[tid.type_index];
    auto sizes = register_sizes[r];
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
    std::unique_ptr<emitter> em;

    void generate_program(ast_node& node) {
        em->begin_data_segment();

        em->begin_code_segment();
        emit_code_segment(node);

        em->end();
    }

    void emit_code_segment(ast_node& node) {
        generate_node(node);
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
        case ast_type::binary_expr:
            generate_binary_expr(node, arg);
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
        em->begin_func(node.local.id_node->string_value.data());
        for (auto& child : node.children) {
            if (child) {
                generate_node(*child);
            }
        }
        em->end_func();
    }

    void generate_return_stmt(ast_node& node) {
        auto& expr = node.children[0];
        if (expr) {
            exprarg arg = { rax };
            generate_node(*expr, &arg);
        }
        else {
            em->mov_literal(eax, 0);
        }
        em->ret();
    }

    void generate_binary_expr(ast_node& node, exprarg* arg) {
        auto& left = node.children[0];
        auto& right = node.children[1];

        bool left_is_binary = left->type == ast_type::binary_expr;
        bool right_is_binary = right->type == ast_type::binary_expr;

        if (left_is_binary)
        {
            {
                exprarg childarg = { arg->dest, true };
                generate_node(*left, &childarg);
            }
            {
                exprarg childarg = { rdx, true };
                generate_node(*right, &childarg);
            }
        }
        else
        {
            {
                exprarg childarg = { arg->dest, true };
                generate_node(*right, &childarg);
            }
            {
                exprarg childarg = { rdx, true };
                generate_node(*left, &childarg);
            }
        }

        gen_register rb = register_for_type((arg->dest == rax) ? rdx : rax, node.type_id);
        gen_register rdest = register_for_type(arg->dest, node.type_id);

        switch (token_to_char(node.op)) {
        case '+':
            em->add(rdest, rb);
            break;
        case '-':
            em->sub(rdest, rb);
            break;
        case '*':
            em->imul(rdest, rb);
            break;
        }
    }

    void generate_int_literal(ast_node& node, exprarg* arg) {
        em->mov_literal(register_for_type(arg->dest, node.type_id), node.int_value);
    }
};

void codegen(ast_node& node, std::string_view filename) {
    generator gen{};
    gen.filename = filename;
    gen.em = std::make_unique<emitter>(filename);
    gen.generate_program(node);
}

}