#include <fstream>
#include <cstdarg>
#include <cassert>
#include <variant>
#include "codegen.hh"
#include "codegen_x64.hh"
#include "emitter_x64_windows.hh"
#include "common.hh"
#include "type_system.hh"
#include <stack>
#include <optional>
#include <set>

namespace carbon {

struct gen_node_data {
    std::optional<gen_register> bin_temp_register{};
    std::set<gen_register> func_used_temp_registers{};
    bool func_calls_extern_c = false;
};

static const gen_register_sizes register_sizes[] = {
    {},
    {rax, eax, invalid, invalid, invalid},
    {rbx, ebx, invalid, invalid, invalid},
    {rcx, ecx, invalid, invalid, invalid},
    {rdx, edx, invalid, invalid, invalid},
    {rdi, edi, invalid, invalid, invalid},
    {rsi, esi, invalid, invalid, invalid},
    {rbp, ebp, invalid, invalid, invalid},
    {rsp, esp, invalid, invalid, invalid},
    {r8, r8d, invalid, invalid, invalid},
    {r9, r9d, invalid, invalid, invalid},
    {r10, r10d, invalid, invalid, invalid},
    {r11, r11d, invalid, invalid, invalid},
    {r12, r12d, invalid, invalid, invalid},
    {r13, r13d, invalid, invalid, invalid},
    {r14, r14d, invalid, invalid, invalid},
    {r15, r15d, invalid, invalid, invalid},
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

struct generator {
    using finalizer_func = std::function<void(const gen_destination&, const gen_operand&)>;

    std::string_view filename;
    std::unique_ptr<emitter> em;
    std::vector<gen_register> arg_registers;
    std::vector<gen_register> temp_registers;
    std::vector<std::pair<std::string_view, std::string>> global_strings;
    std::stack<std::pair<gen_operand, finalizer_func>> operand_stack;
    std::unordered_map<std::size_t, gen_node_data> node_data;
    type_system* ts;
    int used_temp_registers = 0;

    explicit generator(std::unique_ptr<emitter>&& em, type_system* ts, std::string_view fn) {
        this->em = std::move(em);
        this->ts = ts;
        this->filename = fn;
        arg_registers = em->get_argument_registers();
        temp_registers = em->get_temp_registers();
    }

    // Section: helpers

    std::string find_or_add_global_string_data(std::string_view data) {
        for (const auto& str : global_strings) {
            if (data == str.first) {
                return str.second;
            }
        }

        auto label = "$cbstr" + std::to_string(global_strings.size());
        auto new_pair = std::make_pair(data, label);
        global_strings.push_back(new_pair);
        em->add_string_data(label, data);
        return label;
    }

    std::pair<std::int32_t, std::int32_t> get_func_stack_frame_size(ast_node& node) {
        assert(node.type == ast_type::func_decl);

        std::int32_t call_arg_size = 0;
        find_max_call_arg_size(*node.scope.body_node, call_arg_size);

        if (node_data[node.node_id].func_calls_extern_c) {
            call_arg_size = std::max(call_arg_size, 32);
        }

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


    void provide_operand(const gen_operand& op, finalizer_func&& f) {
        operand_stack.push({ op, std::move(f) });
    }

    void finalize_expr(const gen_destination& dest, finalizer_func&& f = {}) {
        if (!operand_stack.empty()) {
            auto op = std::move(operand_stack.top());
            operand_stack.pop();

            if (f) {
                f(dest, op.first);
            }
            else {
                // call default finalizer
                op.second(dest, op.first);
            }
        }
    }

    void discard_expr() {
        while (!operand_stack.empty()) {
            operand_stack.pop();
        }
    }

    gen_destination local_var_destination(local_def& local) {
        return gen_offset{ rbp, local.frame_offset, 0 };
    }

    std::optional<gen_register> use_temp_register() {
        if (used_temp_registers >= temp_registers.size()) {
            return {};
        }
        
        auto next_reg = temp_registers[used_temp_registers];
        used_temp_registers++;

        auto func_node = ts->find_nearest_scope(scope_kind::func_body)->self;
        auto& ndata = node_data[func_node->node_id];
        ndata.func_used_temp_registers.insert(next_reg);
        return next_reg;
    }

    void free_temp_register() {
        used_temp_registers--;
    }

    // Section: pre analysis

    void pre_analysis(ast_node& node) {
        for (auto& unit : node.children) {
            ts->enter_scope(*unit);
            analyse_node(*unit);
            ts->leave_scope();
        }
    }

    void analyse_node(ast_node& node) {
        switch (node.type) {
        case ast_type::func_decl: {
            auto name = node.type_def.mangled_name.str.c_str();
            if (node.scope.body_node) {
                em->add_global_func_decl(name);

                ts->enter_scope(node);
                {
                    for (auto& child : node.children) {
                        if (child) { analyse_node(*child); }
                    }
                }
                ts->leave_scope();
            }
            else {
                em->add_extern_func_decl(name);
            }
            break;
        }
        case ast_type::call_expr: {
            auto func_node = node.call.func_type_id.get().self;
            if (func_node->func.linkage == func_linkage::external_c) {
                auto curscope = ts->find_nearest_scope(scope_kind::func_body);
                node_data[curscope->self->node_id].func_calls_extern_c = true;
            }
            break;
        }
        case ast_type::binary_expr: {
            // create temporary variables for nested expressions
            auto& left = node.children[0];
            auto& right = node.children[1];
            std::optional<gen_register> temp_reg;

            if (!is_primary_expr(*right)) {
                temp_reg = use_temp_register();
                if (!temp_reg) {
                    ts->create_temp_variable_for_binary_expr(node);
                }
                else {
                    node_data[node.node_id].bin_temp_register = temp_reg;
                }
            }

            {
                for (auto& child : node.children) {
                    if (child) { analyse_node(*child); }
                }
            }

            if (temp_reg) {
                free_temp_register();
            }

            break;
        }
        default:
            {
                for (auto& child : node.children) {
                    if (child) { analyse_node(*child); }
                }
            }
            break;
        }
    }

    // Section: generators

    void generate_program(ast_node& node) {
        arg_registers = em->get_argument_registers();

        em->begin_data_segment();
        generate_node_data(node);

        em->begin_code_segment();
        generate_node(node);

        em->end();
    }

    // Section: data generators

    void generate_node_data(ast_node& node) {
        switch (node.type) {
        case ast_type::string_literal:
            generate_string_literal_data(node);
            break;
        default:
            for (auto& child : node.children) {
                if (child) {
                    generate_node_data(*child);
                }
            }
        }
    }

    void generate_string_literal_data(ast_node& node) {
        node.global_data.label = find_or_add_global_string_data(node.string_value);
    }

    // Section: code generators

    void generate_node(ast_node& node) {
        for (auto& child : node.pre_children) {
            if (child) {
                generate_node(*child);
            }
        }

        switch (node.type) {
        case ast_type::import_decl:
        case ast_type::type_expr:
            break;
        case ast_type::func_decl:
            generate_func(node);
            break;
        case ast_type::var_decl:
            generate_var(node);
            break;
        case ast_type::return_stmt:
            generate_return_stmt(node);
            break;
        case ast_type::asm_stmt:
            generate_asm_stmt(node);
            break;
        case ast_type::call_expr:
            generate_call_expr(node);
            break;
        case ast_type::binary_expr:
            generate_binary_expr(node);
            break;      
        case ast_type::identifier:
            generate_identifier(node);
            break;
        case ast_type::int_literal:
            generate_int_literal(node);
            break;  
        case ast_type::string_literal:
            generate_string_literal(node);
            break;
        case ast_type::stmt_list:
            for (auto& child : node.children) {
                if (child) {
                    generate_node(*child);
                    discard_expr();
                }
            }
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
        if (!node.scope.body_node) return;

        auto& ndata = node_data[node.node_id];

        auto [local_size,call_arg_size] = get_func_stack_frame_size(node);
        std::int32_t stack_size = local_size + call_arg_size;

        if (node.local.id_node->string_value == "main") {
            em->begin_func(node.local.id_node->string_value.data());
        }
        else {
            em->begin_func(node.type_def.mangled_name.str.c_str());
        }

        std::int32_t temp_regs_offset = node_data[node.node_id].func_used_temp_registers.size() * 8;
        if (!node.func.arguments.empty()) {
            // move arguments from registers to stack
            for (std::size_t i = node.func.arguments.size(); i > 0; i--) {
                auto arg = node.func.arguments[i - 1];
                auto src = adjust_for_type(gen_register{ arg_registers[i - 1] }, arg->type_id);
                auto dest = adjust_for_type(gen_offset{ rsp, arg->local.frame_offset, 0 }, arg->type_id);
                em->mov(dest, toop(src));
                arg->local.frame_offset += 8 + temp_regs_offset; // space for the rbp about to be pushed
            }
        }

        em->push(rbp);

        std::vector<gen_register> temp_regs;
        for (const auto& reg : ndata.func_used_temp_registers) {
            em->push(reg);
            temp_regs.push_back(reg);
        }

        em->lea(rbp, gen_offset{ rsp, 0, 8 });

        if (stack_size > 0) {
            // resize buffer
            em->sub(rsp, stack_size);
        }

        for (auto& child : node.scope.body_node->children) {
            if (child) {
                generate_node(*child);
            }
        }

        if (stack_size > 0) {
            em->add(rsp, stack_size);
        }

        for (std::size_t i = temp_regs.size(); i > 0; i--) {
            em->pop(temp_regs[i - 1]);
        }

        em->pop(rbp);
        em->ret();
        em->end_func();
    }

    void generate_var(ast_node& node) {
        if (node.local.value_node) {
            std::size_t size = node.type_id.get().size;
            generate_node(*node.local.value_node);
            finalize_expr(gen_offset{ rbp, node.local.frame_offset, size });
        }
    }

    void generate_return_stmt(ast_node& node) {
        auto& expr = node.children[0];
        if (expr) {
            generate_node(*expr);
            finalize_expr(rax);
        }
        else {
            em->mov(eax, 0);
        }
    }

    void generate_asm_stmt(ast_node& node) {
        em->emitln("%s", node.string_value.data());
    }

    void generate_call_expr(ast_node& node) {
        if (!node.call.args.empty()) {
            for (std::size_t i = node.call.args.size(); i > 0; i--) {
                auto dest = gen_register{ arg_registers[i - 1] };
                generate_node(*node.call.args[i - 1]);
                finalize_expr(dest);
            }
        }
        em->call(node.call.mangled_name.str.c_str());

        auto op = toop(adjust_for_type(gen_destination{ rax }, node.type_id));
        provide_operand(op, [this, &node, op](auto&& dest, auto&&) {
            auto adest = adjust_for_type(dest, node.type_id);
            if (!(toop(adest) == op)) {
                em->mov(adest, op);
            }
        });
    }

    void emit_binary_op(token_type op, const gen_destination& dest, const gen_operand& operand) {
        switch (token_to_char(op)) {
        case '+':
            em->add(dest, operand);
            break;
        case '-':
            em->sub(dest, operand);
            break;
        case '*':
            em->imul(dest, operand);
            break;
        }
    }

    void generate_binary_expr(ast_node& node) {
        auto& left = node.children[0];
        auto& right = node.children[1];
        auto& ndata = node_data[node.node_id];
        gen_destination leftdest = rax;

        if (node.local.self) {
            // needs spill temp variable
            leftdest = local_var_destination(node.local);
        }
        else if (ndata.bin_temp_register) {
            leftdest = *ndata.bin_temp_register;
        }

        generate_node(*left);
        finalize_expr(leftdest);

        generate_node(*right);
        finalize_expr(rax, [this, &node, leftdest](auto&&, auto&& op) {
            auto arax = adjust_for_type(rax, node.type_id);
            if (!(op == toop(arax))) {
                auto actual_op = op;
                /*
                if (std::holds_alternative<gen_offset>(op)) {
                    auto arcx = adjust_for_type(rcx, node.children[1]->type_id);
                    em->mov(arcx, actual_op); // reload temp variable
                    actual_op = toop(arcx);
                }
                */
                emit_binary_op(node.op, arax, actual_op);
            }
            else {
                auto actual_temp = adjust_for_type(leftdest, node.children[0]->type_id);
                /*
                if (std::holds_alternative<gen_offset>(leftdest)) {
                    auto arcx = adjust_for_type(rcx, node.children[0]->type_id);
                    em->mov(arcx, toop(actual_temp)); // reload temp variable
                    actual_temp = arcx;
                }
                */
                emit_binary_op(node.op, arax, toop(actual_temp));
            }
        });

        auto op = toop(adjust_for_type(rax, node.type_id));
        provide_operand(op, [this, &node, op](auto&& dest, auto&&) {
            auto adest = adjust_for_type(dest, node.type_id);
            if (!(toop(adest) == op)) {
                em->mov(adest, op);
            }
        });
    }

    void generate_identifier(ast_node& node) {
        if (node.lvalue.symbol.kind == symbol_kind::local) {
            auto local = node.lvalue.symbol.scope->local_defs[node.lvalue.symbol.local_index];
            auto op = toop(adjust_for_type(local_var_destination(*local), node.type_id));
            provide_operand(op, [this, &node, op](auto&& dest, auto&&) {
                em->mov(adjust_for_type(dest, node.type_id), op);
            });
        }
    }

    void generate_int_literal(ast_node& node) {
        provide_operand(gen_operand{ node.int_value }, [this, &node](const gen_destination& dest, auto&&) {
            auto adest = adjust_for_type(dest, node.type_id);
            if (node.int_value == 0) {
                em->xor(adest, toop(adest));
            }
            else {
                em->mov(adest, node.int_value);
            }
        });
    }

    void generate_string_literal(ast_node& node) {
        auto op = gen_data_offset{ node.global_data.label };
        provide_operand(op, [this, op, &node](const gen_destination& dest, auto&&) {
            load_address(adjust_for_type(dest, node.type_id), op, node.type_id);
        });
    }

    void load_address(const gen_destination& dest, const gen_destination& op, type_id tid) {
        if (std::holds_alternative<gen_register>(dest)) {
            em->lea(dest, op);
        }
        else {
            auto arax = adjust_for_type(rax, tid);
            em->lea(arax, op);
            em->mov(dest, toop(arax));
        }
    }
};

void codegen(ast_node& node, type_system* ts, std::string_view filename) {
    generator gen{std::make_unique<emitter>(filename), ts, filename};
    gen.pre_analysis(node);
    gen.generate_program(node);
}

}