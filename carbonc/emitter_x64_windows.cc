#include <cstdarg>
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
    "r8",
    "r9",
    "eax",
    "ebx",
    "ecx",
    "edx",
    "edi",
    "r8d",
    "r9d",
};

template <typename T> bool emit_if_stack(emitter* em, const char* fmt, T&& stack) {
    if (!stack.empty()) {
        auto val = stack.top();
        stack.pop();

        em->emit(fmt, val);
        return true;
    }
    return false;
}

template <typename T> bool emit_if_register_stack(emitter* em, const char* fmt, T&& stack) {
    if (!stack.empty()) {
        auto val = stack.top();
        stack.pop();

        em->emit(fmt, register_names[val]);
        return true;
    }
    return false;
}

}

emitter::emitter(std::string_view filename) {
    out_file = std::ofstream{ std::string{filename} };
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

void emitter::mov(gen_register reg, gen_register src) {
    emitln(" mov %s,%s", register_names[reg], register_names[src]);
}

void emitter::mov_offset(gen_register reg, gen_register src, std::size_t offs) {
    emitln(" mov %s,[%s+%lu]", register_names[reg], register_names[src], offs);
}

void emitter::mov_literal(gen_register reg, std::int32_t val) {
    emitln(" mov %s,%d", register_names[reg], val);
}

void emitter::add(gen_register a, gen_register b) {
    emitln(" add %s,%s", register_names[a], register_names[b]);
}

void emitter::sub(gen_register a, gen_register b) {
    emitln(" sub %s,%s", register_names[a], register_names[b]);
}

void emitter::imul(gen_register a, gen_register b) {
    emitln(" imul %s,%s", register_names[a], register_names[b]);
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