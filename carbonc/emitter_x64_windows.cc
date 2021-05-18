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
    "rbp",
    "rsp",
    "r8",
    "r9",
    "eax",
    "ebx",
    "ecx",
    "edx",
    "edi",
    "ebp",
    "esp",
    "r8d",
    "r9d",
};

static std::unordered_map<std::size_t, const char*> ptrsizes = {
    {1, "BYTE PTR"},
    {2, "WORD PTR"},
    {4, "DWORD PTR"},
    {8, "QWORD PTR"},
};

static const std::vector<gen_register> register_args = {
    rcx, rdx, r8, r9,
};

template <class... Ts> struct overload : Ts... { using Ts::operator()...; };
template <class... Ts> overload(Ts...)->overload<Ts...>;

std::string tostr(const gen_destination& d) {
    return std::visit(overload{
        [](gen_register r) -> std::string {
            return register_names[r];
        },
        [](gen_offset r) -> std::string {
            auto result = "[" + std::string{register_names[r.reg]};
            if (r.offset < 0) {
                result.append("-");
                result.append(std::to_string(-r.offset));
            }
            else {
                result.append("+");
                result.append(std::to_string(r.offset));
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
        [](gen_offset r) -> std::string {
            auto result = "[" + std::string{register_names[r.reg]};
            if (r.offset < 0) {
                result.append("-");
                result.append(std::to_string(-r.offset));
            }
            else {
                result.append("+");
                result.append(std::to_string(r.offset));
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
        [](gen_offset r) -> std::string {
            auto ptrsize = std::string{ptrsizes[r.op_size]};
            auto result = ptrsize + " [" + std::string{register_names[r.reg]};
            if (r.offset < 0) {
                result.append("-");
                result.append(std::to_string(-r.offset));
            }
            else {
                result.append("+");
                result.append(std::to_string(r.offset));
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
        [](gen_offset r) -> std::string {
            auto ptrsize = std::string{ptrsizes[r.op_size]};
            auto result = ptrsize + " [" + std::string{ register_names[r.reg] };
            if (r.offset < 0) {
                result.append("-");
                result.append(std::to_string(-r.offset));
            }
            else {
                result.append("+");
                result.append(std::to_string(r.offset));
            }
            return result + "]";
        },
        [](std::int32_t v) -> std::string {
            return std::to_string(v);
        }
    }, d);
}

}

emitter::emitter(std::string_view filename) {
    out_file = std::ofstream{ std::string{filename} };
}

std::vector<gen_register> emitter::get_argument_registers() {
    return register_args;
}

void emitter::end() {
    out_file << "END\n";
}

void emitter::begin_data_segment() {
    out_file << ".data\n";
}

void emitter::begin_code_segment() {
    out_file << ".code\n";
}

void emitter::begin_func(const char* func_name) {
    current_func = func_name;
    out_file << func_name << " PROC\n";
}

void emitter::end_func() {
    out_file << current_func << " ENDP\n";
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
    emitln(" lea %s,%s", tostr(reg).c_str(), tostr(src).c_str());
}

void emitter::mov(gen_destination reg, gen_operand src) {
    emitln(" mov %s,%s", tostr_sized(reg).c_str(), tostr_sized(src).c_str());
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