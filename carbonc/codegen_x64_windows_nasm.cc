#include <vector>
#include <string>
#include <unordered_map>
#include <cstdarg>
#include "type_id.hh"
#include "type_system.hh"
#include "ast.hh"
#include "codegen_x64.hh"

namespace carbon {

static std::unordered_map<std::size_t, const char*> ptrsizes = {
    {1, "byte"},
    {2, "word"},
    {4, "dword"},
    {8, "qword"},
};

static const std::vector<gen_register> register_args = {
    rcx, rdx, r8, r9,
};

static const std::vector<gen_register> register_temp = {
    rbx, rdi, rsi, r12, r13, r14, r15,
};

static std::string tostr(const gen_destination& d) {
    return std::visit(overload{
        [](gen_register r) -> std::string {
            return register_names[r];
        },
        [](gen_data_offset r) -> std::string {
            std::string result = "OFFSET:";
            result.append(r.label);
            return result;
        },
        [](gen_offset r) -> std::string {
            std::string result = "[";
            for (const auto& it : r.expr) {
                if (auto reg = std::get_if<gen_register>(&it); reg) {
                    result.append(std::string{ register_names[*reg] });
                }
                if (auto ch = std::get_if<char>(&it); ch) {
                    result.append(ch, 1);
                }
                if (auto off = std::get_if<int_type>(&it); off) {
                    result.append(std::to_string(*off));
                }
                if (auto d = std::get_if<gen_data_offset>(&it); d) {
                    result.append("OFFSET:");
                    result.append(d->label);
                }
            }
            return result + "]";
        }
    }, d);
}

static std::string tostr(const gen_operand& d) {
    return std::visit(overload{
        [](gen_register r) -> std::string {
            return register_names[r];
        },
        [](gen_data_offset r) -> std::string {
            std::string result = "OFFSET:";
            result.append(r.label);
            return result;
        },
        [](gen_offset r) -> std::string {
            std::string result = "[";
            for (const auto& it : r.expr) {
                if (auto reg = std::get_if<gen_register>(&it); reg) {
                    result.append(std::string{ register_names[*reg] });
                }
                if (auto ch = std::get_if<char>(&it); ch) {
                    result.append(ch, 1);
                }
                if (auto off = std::get_if<int_type>(&it); off) {
                    result.append(std::to_string(*off));
                }
                if (auto d = std::get_if<gen_data_offset>(&it); d) {
                    result.append("OFFSET:");
                    result.append(d->label);
                }
            }
            return result + "]";
        },
        [](int_type v) -> std::string {
            return std::to_string(v);
        },
        [](char c) -> std::string {
            return std::to_string(c);
        }
    }, d);
}

static std::string tostr_sized(const gen_destination& d) {
    return std::visit(overload{
        [](gen_register r) -> std::string {
            return register_names[r];
        },
        [](gen_data_offset r) -> std::string {
            std::string result = "[";
            result.append(r.label);
            result.append("]");
            return result;
        },
        [](gen_offset r) -> std::string {
            // guard for struct types
            std::size_t sz = std::min(r.op_size, std::size_t{8});
            std::string result = std::string{ptrsizes[sz]} + " [";
            for (const auto& it : r.expr) {
                if (auto reg = std::get_if<gen_register>(&it); reg) {
                    result.append(std::string{ register_names[*reg] });
                }
                if (auto ch = std::get_if<char>(&it); ch) {
                    result.append(ch, 1);
                }
                if (auto off = std::get_if<int_type>(&it); off) {
                    result.append(std::to_string(*off));
                }
                if (auto d = std::get_if<gen_data_offset>(&it); d) {
                    result.append("OFFSET:");
                    result.append(d->label);
                }
            }
            return result + "]";
        }
    }, d);
}

static std::string tostr_sized(const gen_operand& d) {
    return std::visit(overload{
        [](gen_register r) -> std::string {
            return register_names[r];
        },
        [](gen_data_offset r) -> std::string {
            std::string result = "[";
            result.append(r.label);
            result.append("]");
            return result;
        },
        [](gen_offset r) -> std::string {
            std::size_t sz = std::min(r.op_size, std::size_t{8});
            std::string result = std::string{ptrsizes[sz]} + " [";
            for (const auto& it : r.expr) {
                if (auto reg = std::get_if<gen_register>(&it); reg) {
                    result.append(std::string{ register_names[*reg] });
                }
                if (auto ch = std::get_if<char>(&it); ch) {
                    result.append(ch, 1);
                }
                if (auto off = std::get_if<int_type>(&it); off) {
                    result.append(std::to_string(*off));
                }
                if (auto d = std::get_if<gen_data_offset>(&it); d) {
                    result.append("OFFSET:");
                    result.append(d->label);
                }
            }
            return result + "]";
        },
        [](int_type  v) -> std::string {
            return std::to_string(v);
        },
        [](char c) -> std::string {
            return std::to_string(c);
        }
    }, d);
}

struct codegen_x64_windows_nasm_emitter : public codegen_x64_emitter {

    explicit codegen_x64_windows_nasm_emitter(std::string_view filename) : codegen_x64_emitter{filename} {
    }

    virtual ~codegen_x64_windows_nasm_emitter() {}

    virtual std::vector<gen_register> args_registers() {
        return register_args;
    }

    virtual std::vector<gen_register> temp_registers() {
        return register_temp;
    }

    virtual void add_global_func_decl(const char* name) {
        out_file << "global " << name << "\n";
    }

    virtual void add_export_func_decl(const char* name) {
        out_file << "export " << name << "\n";
    }

    virtual void add_extern_func_decl(const char* name) {
        out_file << "extern " << name << "\n";
    }

    virtual void end() {
        //out_file << "END\n";
    }

    virtual void begin_data_segment() {
        out_file << "section .data\n";
    }

    virtual void add_string_data(std::string_view label, std::string_view data) {
        emit("%s: db ", label.data());
        for (char c : data) {
            emit("%d,", (int)c);
        }
        emitln("0");
    }

    virtual void add_global_int16(std::string_view label, int16_t v) {
        emitln("%s: dw 0x%x", label.data(), (int32_t)v);
    }

    virtual void add_global_int32(std::string_view label, int32_t v) {
        emitln("%s: dd 0x%x", label.data(), (int32_t)v);
    }

    virtual void add_global_int64(std::string_view label, int64_t v) {
        emitln("%s: dq 0x%llx", label.data(), v);
    }

    virtual void begin_code_segment() {
        out_file << "section .code\n";
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
        emitln(" lea %s,%s", tostr_sized(reg).c_str(), tostr_sized(src).c_str());
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
        emitln(" mov %s,%s", tostr_sized(reg).c_str(), tostr_sized(src).c_str());
    }

    virtual void movsx(gen_destination reg, gen_operand src) {
        std::size_t as = get_size(reg);
        std::size_t bs = get_size(src);

        // TODO: handle more sizes
        if ((as == 2 && bs == 1) || (as == 4 && bs == 1) || (as == 4 && bs == 2) || (as == 8 && bs == 1) || (as == 8 && bs == 2)) {
            emitln(" movsx %s,%s", tostr_sized(reg).c_str(), tostr_sized(src).c_str());
        }
        else if (as == 8 && bs == 4) {
            emitln(" movsxd %s,%s", tostr_sized(reg).c_str(), tostr_sized(src).c_str());
        }
        else {
            mov(reg, src);
        }
    }

    virtual void movzx(gen_destination reg, gen_operand src) {
        emitln(" movzx %s,%s", tostr_sized(reg).c_str(), tostr_sized(src).c_str());
    }

    virtual void add(gen_destination a, gen_operand b) {
        emitln(" add %s,%s", tostr_sized(a).c_str(), tostr_sized(b).c_str());
    }

    virtual void sub(gen_destination a, gen_operand b) {
        emitln(" sub %s,%s", tostr_sized(a).c_str(), tostr_sized(b).c_str());
    }

    virtual void imul(gen_destination a, gen_operand b) {
        emitln(" imul %s,%s", tostr_sized(a).c_str(), tostr_sized(b).c_str());
    }

    virtual void idiv(gen_destination b) {
        emitln(" idiv %s", tostr_sized(b).c_str());
    }

    virtual void and_(gen_destination a, gen_operand b) {
        emitln(" and %s,%s", tostr_sized(a).c_str(), tostr_sized(b).c_str());
    }

    virtual void or_(gen_destination a, gen_operand b) {
        emitln(" or %s,%s", tostr_sized(a).c_str(), tostr_sized(b).c_str());
    }

    virtual void neg(gen_destination a) {
        emitln(" neg %s", tostr_sized(a).c_str());
    }

    virtual void sal(gen_destination a, gen_operand b) {
        emitln(" sal %s,%s", tostr_sized(a).c_str(), tostr_sized(b).c_str());
    }

    virtual void sar(gen_destination a, gen_operand b) {
        emitln(" sar %s,%s", tostr_sized(a).c_str(), tostr_sized(b).c_str());
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
        emitln(" xor %s,%s", tostr_sized(a).c_str(), tostr_sized(b).c_str());
    }

    virtual void jmp(const char* label) {
        emitln(" jmp %s", label);
    }

    virtual void cmp(gen_operand a, gen_operand b) {
        emitln(" cmp %s,%s", tostr_sized(a).c_str(), tostr_sized(b).c_str());
    }

    virtual void label(const char* label) {
        emitln("%s:", label);
    }

    virtual void comment_prefix() {
        out_file << ";";
    }
};

std::unique_ptr<codegen_x64_emitter> make_x64_windows_nasm_emitter(std::string_view filename) {
    return std::make_unique<codegen_x64_windows_nasm_emitter>(filename);
}

}