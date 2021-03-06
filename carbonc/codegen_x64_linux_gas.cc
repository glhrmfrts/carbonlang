#include <vector>
#include <string>
#include <unordered_map>
#include <cstdarg>
#include "type_id.hh"
#include "type_system.hh"
#include "ast.hh"
#include "codegen_x64.hh"
#include "codegen_x64_linux_gas.hh"

namespace carbon {

static const std::vector<gen_register> register_args = {
    rdi, rsi, rdx, rcx, r8, r9,
};

static const std::vector<gen_register> register_temp = {
    rbx, r12, r13, r14, r15,
};

static void append_offset(std::string& result, const gen_offset_expr& expr, bool comma) {
    if (auto reg = std::get_if<gen_register>(&expr); reg && (*reg != invalid)) {
        if (comma) {
            result.append(",");
        }
        result.append(std::string{ "%" } + std::string{ register_names[*reg] });
    }
    else if (auto off = std::get_if<int_type>(&expr); off && (off != 0)) {
        if (comma) {
            result.append(",");
        }
        result.append(std::to_string(*off));
    }
}

static std::string offset_tostr(const gen_addr& r) {
    // offset(base) or (base, offset, mult) if mult != 0

    std::string result = "";

    if (r.base == invalid && std::holds_alternative<gen_data_offset>(r.offset)) {
        result.append(std::get<gen_data_offset>(r.offset).label);
        result.append("(%rip)");
        return result;
    }

    append_offset(result, r.offset, false);

    result.append("(");
    result.append(std::string{ "%" } + register_names[r.base]);

    append_offset(result, r.index, true);

    if (r.mult != 0) {
        result.append(",");
        result.append(std::to_string(r.mult));
    }

    result.append(")");

    return result;
}

struct Nice {
    alignas(long long) bool first;
    alignas(long long) bool second;
};

static std::string tostr(const gen_destination& d) {
    sizeof(Nice);
    alignof(Nice);

    return std::visit(overload{
        [](gen_register r) -> std::string {
            return std::string{"%"} + register_names[r];
        },
        [](gen_data_offset r) -> std::string {
            std::string result = "";
            result.append(r.label);
            result.append("(%rip)");
            return result;
        },
        [](gen_addr r) -> std::string {
            return offset_tostr(r);
        }
    }, d);
}

static std::string tostr(const gen_operand& d) {
    return std::visit(overload{
        [](gen_register r) -> std::string {
            return std::string{"%"} + register_names[r];
        },
        [](gen_data_offset r) -> std::string {
            std::string result = "";
            result.append(r.label);
            result.append("(%rip)");
            return result;
        },
        [](gen_addr r) -> std::string {
            return offset_tostr(r);
        },
        [](int_type v) -> std::string {
            return std::string{"$"} + std::to_string(v);
        },
        [](char c) -> std::string {
            return std::string{"$"} + std::to_string(c);
        }
    }, d);
}

static std::string tostr_sized(const gen_destination& d) {
    return std::visit(overload{
        [](gen_register r) -> std::string {
            return std::string{"%"} + register_names[r];
        },
        [](gen_data_offset r) -> std::string {
            std::string result = "";
            result.append(r.label);
            result.append("(%rip)");
            return result;
        },
        [](gen_addr r) -> std::string {
            return offset_tostr(r);
        }
    }, d);
}

static std::string tostr_sized(const gen_operand& d) {
    return std::visit(overload{
        [](gen_register r) -> std::string {
            return std::string{"%"} + register_names[r];
        },
        [](gen_data_offset r) -> std::string {
            std::string result = "";
            result.append(r.label);
            result.append("(%rip)");
            return result;
        },
        [](gen_addr r) -> std::string {
            return offset_tostr(r);
        },
        [](int_type  v) -> std::string {
            return std::string{"$"} + std::to_string(v);
        },
        [](char c) -> std::string {
            return std::string{"$"} + std::to_string(c);
        }
    }, d);
}

std::string escape(std::string_view str) {
    std::string result = "";
    for (const auto c : str) {
        switch (c) {
        case '\n':
            result.append("\\n");
            break;
        case '\t':
            result.append("\\t");
            break;
        default:
            result.append(1, c);
            break;
        }
    }
    return result;
}

struct codegen_x64_linux_gas_emitter : public codegen_x64_emitter {

    explicit codegen_x64_linux_gas_emitter(std::string_view filename) : codegen_x64_emitter{filename} {
    }

    virtual ~codegen_x64_linux_gas_emitter() {}

    virtual std::vector<gen_register> args_registers() {
        return register_args;
    }

    virtual std::vector<gen_register> temp_registers() {
        return register_temp;
    }

    virtual void add_global_func_decl(const char* name) {
        out_file << ".global " << name << "\n";
    }

    virtual void add_export_func_decl(const char* name) {
        //out_file << "export " << name << "\n";
    }

    virtual void add_extern_func_decl(const char* name) {
        out_file << ".extern " << name << "\n";
    }

    virtual void add_extern_var_decl(const char* name) {
        // out_file << ".extern " << name << "\n";
    }

    virtual void end() {
        //out_file << "END\n";
    }

    virtual void begin_text_segment() {
        out_file << ".text\n";
    }

    virtual void begin_data_segment() {
        out_file << ".data\n";
    }

    virtual void begin_readonly_data_segment() {
        out_file << ".section .rodata\n";
    }

    virtual void begin_error_segment() {
        out_file << ".section .error_array, \"a\"\n";
    }

    virtual void align(std::size_t bytes) {
        emitln("    .align %zu", bytes);
    }

    virtual void add_int32(std::int32_t value) {
        emitln("    .long %d", value);
    }

    virtual void add_stringz(std::string_view value) {
        auto escaped = escape(value);
        emitln("    .asciz \"%s\"", escaped.c_str());
    }

    virtual void add_string_data(std::string_view label, std::string_view data) {
        // TODO: escape string
        emitln("%s:", label.data());
        add_stringz(data);
    }

    virtual void add_global(std::string_view label, type_id type, decl_visibility vis) {
        if (vis != decl_visibility::public_) {
            emitln("    .local %s", label.data());
        }
        emitln("    .comm %s,%zu,%zu", label.data(), type.get().size, type.get().alignment);
    }

    virtual void add_global_declaration(std::string_view label) {
        emitln("    .global %s", label.data());
    }

    virtual void add_global_int16(std::string_view label, int16_t v) {
        emitln("    .balign 2");
        emitln("    .size %s, 2", label.data());
        emitln("%s:", label.data());
        emitln("    .value %d", (int32_t)v);
    }

    virtual void add_global_int32(std::string_view label, int32_t v) {
        emitln("    .balign 4");
        emitln("    .size %s, 4", label.data());
        emitln("%s:", label.data());
        emitln("    .value %d", (int32_t)v);
    }

    virtual void add_global_int64(std::string_view label, int64_t v) {
        emitln("    .balign 8");
        emitln("    .size %s, 8", label.data());
        emitln("%s:", label.data());
        emitln("    .value %lld", v);
    }

    virtual void add_global_bytes(std::string_view label, const std::vector<std::uint8_t>& bytes) {
        emitln("    .balign 16");
        emitln("    .size %s, %zu", label.data(), bytes.size());
        emitln("%s:", label.data());
        for (auto b : bytes) {
            emitln("    .byte 0x%x", (int)(b));
        }
    }

    virtual void begin_code_segment() {
        out_file << ".text\n";
    }

    virtual void begin_func(const char* func_name) {
        current_func = func_name;
        out_file << func_name << ":\n";
    }

    virtual void end_func() {

    }

    virtual void ret() {
        out_file << " ret\n";
    }

    virtual void call(const char* func_name) {
        emitln(" call %s", func_name);
    }

    virtual void calldest(gen_destination dest) {
        emitln(" call %s", tostr_sized(dest).c_str());
    }

    virtual void push(gen_operand reg) {
        emitln(" push %s", tostr_sized(reg).c_str());
    }

    virtual void pop(gen_operand reg) {
        emitln(" pop %s", tostr_sized(reg).c_str());
    }

    virtual void lea(gen_destination reg, gen_destination src) {
        emitln(" lea %s,%s", tostr_sized(src).c_str(), tostr_sized(reg).c_str());
    }

    virtual void mov(gen_destination reg, gen_operand src) {
#if 0
        std::size_t sza = get_size(reg);
        std::size_t szb = get_size(src);
        if (sza != szb) {
            printf(" mov %s,%s\n", tostr_sized(reg).c_str(), tostr_sized(src).c_str());
            if (is_reg(src)) {
                printf("AKJSHDKJAHSD\n");
            }
            printf("DIFFSIZE: %zu %zu\n", sza, szb);
        }
#endif
        if (std::holds_alternative<int_type>(src)) {
            if (std::get<int_type>(src) == 0 && std::holds_alternative<gen_register>(reg)) {
                auto regstr = tostr_sized(reg);
                emitln(" xor %s,%s", regstr.c_str(), regstr.c_str());
                return;
            }
        }
        emitln(" mov %s,%s", tostr_sized(src).c_str(), tostr_sized(reg).c_str());
    }

    virtual void movsx(gen_destination reg, gen_operand src) {
        std::size_t destsize = get_size(reg);
        std::size_t fromsize = get_size(src);

        // TODO: handle more sizes
        if ((destsize == 2 && fromsize == 1) || (destsize == 4 && fromsize == 1)
            || (destsize == 4 && fromsize == 2) || (destsize == 8 && fromsize == 1)
            || (destsize == 8 && fromsize == 2)) {
            emitln(" movsx %s,%s", tostr_sized(src).c_str(), tostr_sized(reg).c_str());
        }
        else if (destsize == 8 && fromsize == 4) {
            emitln(" movsxd %s,%s", tostr_sized(src).c_str(), tostr_sized(reg).c_str());
        }
        else {
            mov(reg, src);
        }
    }

    virtual void movzx(gen_destination reg, gen_operand src) {
        std::size_t destsize = get_size(reg);
        std::size_t fromsize = get_size(src);
        if (fromsize >= 4) {
            emitln(" mov %s,%s", tostr_sized(src).c_str(), tostr_sized(reg).c_str());
        }
        else {
            emitln(" movzx %s,%s", tostr_sized(src).c_str(), tostr_sized(reg).c_str());
        }
    }

    virtual void movq(gen_destination reg, gen_operand src) {
        emitln(" movq %s,%s", tostr_sized(src).c_str(), tostr_sized(reg).c_str());
    }

    virtual void movdqa(gen_destination reg, gen_operand src) {
        emitln(" movdqa %s,%s", tostr_sized(src).c_str(), tostr_sized(reg).c_str());
    }

    virtual void psadbw(gen_destination reg, gen_operand src) {
        emitln(" psadbw %s,%s", tostr_sized(src).c_str(), tostr_sized(reg).c_str());
    }

    virtual void pshufb(gen_destination reg, gen_operand src) {
        emitln(" pshufb %s,%s", tostr_sized(src).c_str(), tostr_sized(reg).c_str());
    }

    virtual void add(gen_destination a, gen_operand b) {
        emitln(" add %s,%s", tostr_sized(b).c_str(), tostr_sized(a).c_str());
    }

    virtual void sub(gen_destination a, gen_operand b) {
        emitln(" sub %s,%s", tostr_sized(b).c_str(), tostr_sized(a).c_str());
    }

    virtual void imul(gen_destination a, gen_operand b) {
        emitln(" imul %s,%s", tostr_sized(b).c_str(), tostr_sized(a).c_str());
    }

    virtual void idiv(gen_destination b) {
        std::size_t sz = get_size(b);
        switch (sz) {
        case 1:
            emitln(" idivb %s", tostr_sized(b).c_str());
            break;
        case 2:
            emitln(" idivw %s", tostr_sized(b).c_str());
            break;
        case 4:
            emitln(" idivl %s", tostr_sized(b).c_str());
            break;
        case 8:
            emitln(" idivq %s", tostr_sized(b).c_str());
            break;
        }
    }

    virtual void and_(gen_destination a, gen_operand b) {
        emitln(" and %s,%s", tostr_sized(b).c_str(), tostr_sized(a).c_str());
    }

    virtual void or_(gen_destination a, gen_operand b) {
        emitln(" or %s,%s", tostr_sized(b).c_str(), tostr_sized(a).c_str());
    }

    virtual void neg(gen_destination a) {
        emitln(" neg %s", tostr_sized(a).c_str());
    }

    virtual void sal(gen_destination a, gen_operand b) {
        emitln(" sal %s,%s", tostr_sized(b).c_str(), tostr_sized(a).c_str());
    }

    virtual void sar(gen_destination a, gen_operand b) {
        emitln(" sar %s,%s", tostr_sized(b).c_str(), tostr_sized(a).c_str());
    }

    virtual void cdq(type_id t) {
        switch (t.get().size)
        {
        case 2:
            emitln(" cwd");
            break;
        case 4:
            emitln(" cdq");
            break;
        case 8:
            emitln(" cqo");
            break;
        default:
            break;
        }
    }

    virtual void xor_(gen_destination a, gen_operand b) {
        emitln(" xor %s,%s", tostr_sized(b).c_str(), tostr_sized(a).c_str());
    }

    virtual void jmp(const char* label) {
        emitln(" jmp %s", label);
    }

    virtual void cmp(gen_operand a, gen_operand b) {
        emitln(" cmp %s,%s", tostr_sized(b).c_str(), tostr_sized(a).c_str());
    }

    virtual void set(const char* rel, gen_destination d) {
        emitln(" set%s %s", rel, tostr_sized(d).c_str());
    }

    virtual void label(const char* label) {
        emitln("%s:", label);
    }

    virtual void comment_prefix() {
        out_file << "# ";
    }

    virtual std::string special_label(const std::string& label) {
        return std::string{"."} + label;
    }
};

std::unique_ptr<codegen_x64_emitter> make_x64_linux_gas_emitter(std::string_view filename) {
    return std::make_unique<codegen_x64_linux_gas_emitter>(filename);
}
}