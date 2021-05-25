#include <cstdarg>
#include <string>
#include "emitter_x64_windows.hh"
#include "common.hh"

namespace carbon {

namespace {

static const char* register_names[] = {
    "invalid",
    "rax",
    "rbx",
    "rcx",
    "rdx",
    "rdi",
    "rsi",
    "rbp",
    "rsp",
    "r8",
    "r9",
    "r10",
    "r11",
    "r12",
    "r13",
    "r14",
    "r15",
    "eax",
    "ebx",
    "ecx",
    "edx",
    "edi",
    "esi",
    "ebp",
    "esp",
    "r8d",
    "r9d",
    "r10d",
    "r11d",
    "r12d",
    "r13d",
    "r14d",
    "r15d",
    "ax",
    "bx",
    "cx",
    "dx",
    "di",
    "si",
    "bp",
    "sp",
    "r8",
    "r9w",
    "r10w",
    "r11w",
    "r12w",
    "r13w",
    "r14w",
    "r15w",
    "al",
    "bl",
    "cl",
    "dl",
    "dil",
    "sil",
    "bpl",
    "spl",
    "r8b",
    "r9b",
    "r10b",
    "r11b",
    "r12b",
    "r13b",
    "r14b",
    "r15b",
};

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
    r10, r11, r12, r13, r14, r15,
};

template <class... Ts> struct overload : Ts... { using Ts::operator()...; };
template <class... Ts> overload(Ts...)->overload<Ts...>;

std::string tostr(const gen_destination& d) {
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
                if (auto off = std::get_if<std::int32_t>(&it); off) {
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

std::string tostr(const gen_operand& d) {
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
                if (auto off = std::get_if<std::int32_t>(&it); off) {
                    result.append(std::to_string(*off));
                }
                if (auto d = std::get_if<gen_data_offset>(&it); d) {
                    result.append("OFFSET:");
                    result.append(d->label);
                }
            }
            return result + "]";
        },
        [](std::int32_t v) -> std::string {
            return std::to_string(v);
        }
    }, d);
}

std::string tostr_sized(const gen_destination& d) {
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
            std::string result = std::string{ptrsizes[r.op_size]} + " [";
            for (const auto& it : r.expr) {
                if (auto reg = std::get_if<gen_register>(&it); reg) {
                    result.append(std::string{ register_names[*reg] });
                }
                if (auto ch = std::get_if<char>(&it); ch) {
                    result.append(ch, 1);
                }
                if (auto off = std::get_if<std::int32_t>(&it); off) {
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

std::string tostr_sized(const gen_operand& d) {
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
            std::string result = std::string{ptrsizes[r.op_size]} + " [";
            for (const auto& it : r.expr) {
                if (auto reg = std::get_if<gen_register>(&it); reg) {
                    result.append(std::string{ register_names[*reg] });
                }
                if (auto ch = std::get_if<char>(&it); ch) {
                    result.append(ch, 1);
                }
                if (auto off = std::get_if<std::int32_t>(&it); off) {
                    result.append(std::to_string(*off));
                }
                if (auto d = std::get_if<gen_data_offset>(&it); d) {
                    result.append("OFFSET:");
                    result.append(d->label);
                }
            }
            return result + "]";
        },
        [](std::int32_t v) -> std::string {
            return std::to_string(v);
        }
    }, d);
}

std::size_t get_size(const gen_destination& v) {
    return std::visit(overload{
        [](gen_register r) -> std::size_t {
            if (r >= al) return 1;
            if (r >= ax) return 2;
            if (r >= eax) return 4;
            if (r >= rax) return 8;
            return 0;
        },
        [](gen_data_offset r) -> std::size_t {
            return sizeof(void*);
        },
        [](gen_offset r) -> std::size_t {
            return r.op_size;
        }
    }, v);
}

std::size_t get_size(const gen_operand& v) {
    return std::visit(overload{
        [](gen_register r) -> std::size_t {
            if (r >= al) return 1;
            if (r >= ax) return 2;
            if (r >= eax) return 4;
            if (r >= rax) return 8;
            return 0;
        },
        [](gen_data_offset r) -> std::size_t {
            return sizeof(void*);
        },
        [](gen_offset r) -> std::size_t {
            return r.op_size;
        },
        [](std::int32_t v) -> std::size_t {
            return 4;
        },
        [](char v) -> std::size_t {
            return 1;
        }
        }, v);
}

}

emitter::emitter(std::string_view filename) {
    out_file = std::ofstream{ std::string{filename} };
}

std::vector<gen_register> emitter::get_argument_registers() {
    return register_args;
}

std::vector<gen_register> emitter::get_temp_registers() {
    return register_temp;
}

void emitter::end() {
    //out_file << "END\n";
}

void emitter::add_global_func_decl(const char* name) {
    out_file << "global " << name << "\n";
}

void emitter::add_extern_func_decl(const char* name) {
    out_file << "extern " << name << "\n";
}

void emitter::begin_data_segment() {
    out_file << "section .data\n";
}

void emitter::add_string_data(std::string_view label, std::string_view data) {
    emit("%s: db ", label.data());
    for (char c : data) {
        emit("%d,", (int)c);
    }
    emitln("0");
}

void emitter::begin_code_segment() {
    out_file << "section .code\n";
}

void emitter::begin_func(const char* func_name) {
    current_func = func_name;
    out_file << func_name << ":\n";
}

void emitter::end_func() {
    //out_file << current_func << " ENDP\n";
}

void emitter::ret() {
    out_file << " ret\n";
}

void emitter::call(const char* func_name) {
    emitln(" call %s", func_name);
}

void emitter::push(gen_operand reg) {
    emitln(" push %s", tostr_sized(reg).c_str());
}

void emitter::pop(gen_operand reg) {
    emitln(" pop %s", tostr_sized(reg).c_str());
}

void emitter::lea(gen_destination reg, gen_destination src) {
    emitln(" lea %s,%s", tostr_sized(reg).c_str(), tostr_sized(src).c_str());
}

void emitter::mov(gen_destination reg, gen_operand src) {
    emitln(" mov %s,%s", tostr_sized(reg).c_str(), tostr_sized(src).c_str());
}

void emitter::movsx(gen_destination reg, gen_operand src) {
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

void emitter::add(gen_destination a, gen_operand b) {
    emitln(" add %s,%s", tostr_sized(a).c_str(), tostr_sized(b).c_str());
}

void emitter::sub(gen_destination a, gen_operand b) {
    emitln(" sub %s,%s", tostr_sized(a).c_str(), tostr_sized(b).c_str());
}

void emitter::imul(gen_destination a, gen_operand b) {
    emitln(" imul %s,%s", tostr_sized(a).c_str(), tostr_sized(b).c_str());
}

void emitter::xor(gen_destination a, gen_operand b) {
    emitln(" xor %s,%s", tostr_sized(a).c_str(), tostr_sized(b).c_str());
}

void emitter::jmp(const char* label) {
    emitln(" jmp %s", label);
}

void emitter::cmp(gen_operand a, gen_operand b) {
    emitln(" cmp %s,%s", tostr_sized(a).c_str(), tostr_sized(b).c_str());
}

void emitter::label(const char* label) {
    emitln("%s:", label);
}

void emitter::emit(const char* fmt, ...) {
    static char buffer[1024];
    std::va_list args;
    va_start(args, fmt);
    std::vsnprintf(buffer, sizeof(buffer), fmt, args);
    va_end(args);
    out_file << buffer;
}

void emitter::emitln(const char* fmt, ...) {
    static char buffer[1024];
    std::va_list args;
    va_start(args, fmt);
    std::vsnprintf(buffer, sizeof(buffer), fmt, args);
    va_end(args);
    out_file << buffer << "\n";
}

}