#include <fstream>
#include <cstdarg>
#include <cassert>
#include <variant>
#include "codegen.hh"
#include "codegen_x64.hh"
#include "emitter_x64_windows.hh"
#include "common.hh"
#include "type_system.hh"

namespace carbon {

struct exprarg {
    gen_destination dest;
};

static const gen_register_sizes register_sizes[] = {
    {},
    {rax, eax, invalid, invalid, invalid},
    {},
    {rcx, ecx, invalid, invalid, invalid},
    {rdx, edx, invalid, invalid, invalid},
    {rdi, edi, invalid, invalid, invalid},
    {rbp, ebp, invalid, invalid, invalid},
    {rsp, esp, invalid, invalid, invalid},
    {r8, r8d, invalid, invalid, invalid},
    {r9, r9d, invalid, invalid, invalid},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
};

gen_destination adjust_for_type(gen_destination dest, type_id tid) {
    auto tdef = tid.scope->type_defs[tid.type_index];
    if (std::holds_alternative<gen_register>(dest)) {
        auto sizes = register_sizes[std::get<gen_register>(dest)];
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
    else if (std::holds_alternative<gen_offset>(dest)) {
        gen_offset offs = std::get<gen_offset>(dest);
        offs.op_size = tdef->size;
        return offs;
    }
    return dest;
}

gen_operand toop(gen_destination dest) {
    if (std::holds_alternative<gen_register>(dest)) {
        return std::get<gen_register>(dest);
    }
    if (std::holds_alternative<gen_offset>(dest)) {
        return std::get<gen_offset>(dest);
    }
}

template <typename T> T align(T number, T alignment) {
    T offset = number % alignment;
    if (offset) {
        number = number - offset + alignment;
    }

    return number;
}

void find_max_call_arg_size(ast_node& node, std::int32_t& sz) {
    if (node.type == ast_type::call_expr) {
        std::int32_t args_size = 0;
        for (auto& arg : node.call.args) {
            auto tdef = arg->type_id.get();
            std::int32_t asize = std::min(8,std::int32_t(tdef.size));
            args_size += asize;
            args_size = align(args_size, std::int32_t(tdef.alignment));
        }
        sz = std::max(sz, args_size);
    }
    for (auto& child : node.children) {
        if (child) {
            find_max_call_arg_size(*child, sz);
        }
    }
}

std::pair<std::int32_t, std::int32_t> get_func_stack_frame_size(ast_node& node) {
    assert(node.type == ast_type::func_decl);

    std::int32_t call_arg_size = 0;
    find_max_call_arg_size(*node.scope.body_node, call_arg_size);

    std::int32_t own_arg_size = 0;
    std::int32_t local_size = 0;
    for (auto& local : node.scope.local_defs) {
        auto& tdef = local->self->type_id.get();
        if (local->is_argument) {
            local->frame_offset = own_arg_size + 8; // offset from rbp + space for the return-instruction pointer
            own_arg_size += std::int32_t(tdef.size);
            own_arg_size = align(own_arg_size, std::int32_t(tdef.alignment));
        }
        else {
            local->frame_offset = -(local_size + 8); // offset from rbp + space for pushed rbp
            local_size += std::int32_t(tdef.size);
            local_size = align(local_size, std::int32_t(tdef.alignment));
        }
    }

    local_size = align(local_size, 16);
    call_arg_size = align(call_arg_size, 16);
    return std::make_pair(local_size, call_arg_size);
}

struct generator {
    std::string_view filename;
    std::unique_ptr<emitter> em;
    std::vector<gen_register> arg_registers;

    void generate_program(ast_node& node) {
        arg_registers = em->get_argument_registers();

        em->begin_data_segment();

        em->begin_code_segment();
        generate_node(node);

        em->end();
    }

    void generate_node(ast_node& node, exprarg* arg = nullptr) {
        switch (node.type) {
        case ast_type::func_decl:
            generate_func(node);
            break;
        case ast_type::var_decl:
            generate_var(node);
            break;
        case ast_type::return_stmt:
            generate_return_stmt(node);
            break;
        case ast_type::call_expr:
            generate_call_expr(node, arg);
            break;
        case ast_type::binary_expr:
            generate_binary_expr(node, arg);
            break;
        case ast_type::int_literal:
            generate_int_literal(node, arg);
            break;        
        case ast_type::identifier:
            generate_identifier(node, arg);
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
        auto [local_size,call_arg_size] = get_func_stack_frame_size(node);
        std::int32_t stack_size = local_size + call_arg_size;

        if (node.local.id_node->string_value == "main") {
            em->begin_func(node.local.id_node->string_value.data());
        }
        else {
            em->begin_func(node.type_def.mangled_name.str.c_str());
        }

        if (!node.func.arguments.empty()) {
            // move arguments from registers to stack
            for (std::size_t i = node.func.arguments.size(); i > 0; i--) {
                auto arg = node.func.arguments[i - 1];
                auto src = adjust_for_type(gen_register{ arg_registers[i - 1] }, arg->type_id);
                auto dest = adjust_for_type(gen_offset{ rsp, arg->local.frame_offset, 0 }, arg->type_id);
                em->mov(dest, toop(src));
                arg->local.frame_offset += 8; // space for the rbp about to be pushed
            }
        }

        if (stack_size > 0) {
            // resize buffer
            em->push(rbp);
            em->lea(rbp, gen_offset{ rsp, 0, 0 });
            em->sub(rsp, stack_size);
        }

        for (auto& child : node.scope.body_node->children) {
            if (child) {
                generate_node(*child);
            }
        }

        if (stack_size > 0) {
            em->add(rsp, stack_size);
            em->pop(rbp);
        }

        em->ret();
        em->end_func();
    }

    void generate_var(ast_node& node) {
        if (node.local.value_node) {
            std::size_t size = node.type_id.get().size;
            exprarg arg = { gen_offset{ rbp, node.local.frame_offset, size } };
            generate_node(*node.local.value_node, &arg);
        }
    }

    void generate_return_stmt(ast_node& node) {
        auto& expr = node.children[0];
        if (expr) {
            exprarg arg = { rax };
            generate_node(*expr, &arg);
        }
        else {
            em->mov(eax, 0);
        }
    }

    void generate_call_expr(ast_node& node, exprarg* arg) {
        if (!node.call.args.empty()) {
            for (std::size_t i = node.call.args.size(); i > 0; i--) {
                auto dest = gen_register{ arg_registers[i - 1] };
                exprarg arg = { dest };
                generate_node(*node.call.args[i - 1], &arg);
            }
        }
        em->call(node.call.mangled_name.str.c_str());

        if (!(arg->dest == adjust_for_type(gen_destination{ rax }, node.type_id))) {
            em->mov(
                adjust_for_type(arg->dest, node.type_id),
                toop(adjust_for_type(gen_destination{ rax }, node.type_id))
            );
        }
    }

    void generate_binary_expr(ast_node& node, exprarg* arg) {
        auto& left = node.children[0];
        auto& right = node.children[1];

        bool left_is_binary = left->type == ast_type::binary_expr;
        bool right_is_binary = right->type == ast_type::binary_expr;

        bool needsmove = false;

        gen_destination ldest;
        if (std::holds_alternative<gen_register>(arg->dest)) {
            ldest = arg->dest;
        }
        else {
            ldest = rax;
            needsmove = true;
        }

        if (left_is_binary)
        {
            {
                exprarg childarg = { ldest };
                generate_node(*left, &childarg);
            }
            {
                exprarg childarg = { rdx };
                generate_node(*right, &childarg);
            }
        }
        else
        {
            {
                exprarg childarg = { ldest };
                generate_node(*right, &childarg);
            }
            {
                exprarg childarg = { rdx };
                generate_node(*left, &childarg);
            }
        }

        auto rb = adjust_for_type((ldest == gen_destination{ rax }) ? rdx : rax, node.type_id);
        auto rdest = adjust_for_type(ldest, node.type_id);

        switch (token_to_char(node.op)) {
        case '+':
            em->add(rdest, toop(rb));
            break;
        case '-':
            em->sub(rdest, toop(rb));
            break;
        case '*':
            em->imul(rdest, toop(rb));
            break;
        }

        if (needsmove) {
            em->mov(adjust_for_type(arg->dest, node.type_id), toop(rdest));
        }
    }

    void generate_identifier(ast_node& node, exprarg* arg) {
        if (node.lvalue.symbol.kind == symbol_kind::local) {
            auto local = node.lvalue.symbol.scope->local_defs[node.lvalue.symbol.local_index];

            /*gen_register reg = rbp;
            if (local->is_argument) {
                reg = rsp;
            }*/

            em->mov(
                adjust_for_type(arg->dest, node.type_id),
                toop(adjust_for_type(gen_offset{ rbp, local->frame_offset, 0 }, node.type_id))
            );
        }
    }

    void generate_int_literal(ast_node& node, exprarg* arg) {
        auto adest = adjust_for_type(arg->dest, node.type_id);
        if (node.int_value == 0) {
            em->xor(adest, toop(adest));
        }
        else {
            em->mov(adest, node.int_value);
        }
    }
};

void codegen(ast_node& node, std::string_view filename) {
    generator gen{};
    gen.filename = filename;
    gen.em = std::make_unique<emitter>(filename);
    gen.generate_program(node);
}

}