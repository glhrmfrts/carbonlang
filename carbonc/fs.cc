#include <cstdio>
#include "common.hh"
#include "fs.hh"

namespace carbon {

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

std::wstring widen(const char* const text, const int size)
{
    if(!size) return {};
    /* WCtoMB counts the trailing \0 into size, which we have to cut */
    std::wstring result(MultiByteToWideChar(CP_UTF8, 0, text, size, nullptr, 0) - (size == -1 ? 1 : 0), 0);
    MultiByteToWideChar(CP_UTF8, 0, text, size, &result[0], result.size());
    return result;
}

std::string narrow(const wchar_t* const text, const int size)
{
    if(!size) return {};
    /* WCtoMB counts the trailing \0 into size, which we have to cut */
    std::string result(WideCharToMultiByte(CP_UTF8, 0, text, size, nullptr, 0, nullptr, nullptr) - (size == -1 ? 1 : 0), 0);
    WideCharToMultiByte(CP_UTF8, 0, text, size, &result[0], result.size(), nullptr, nullptr);
    return result;
}

std::wstring widen(const std::string& text)
{
    return widen(text.data(), text.size());
}

std::string narrow(const std::wstring& text)
{
    return narrow(text.data(), text.size());
}

std::FILE* open_file(const char* path, const char* mode) {
    return _wfopen(widen(path, strlen(path)).c_str(), widen(mode, strlen(mode)).c_str());
}

#else

std::string widen(const std::string& text)
{
    return text;
}

std::string narrow(const std::string& text)
{
    return text;
}

#endif

std::size_t get_file_size(std::FILE* fh) {
    std::fseek(fh, 0, SEEK_END);
    std::size_t size = std::ftell(fh);
    std::rewind(fh);
    return size;
}

bool read_file_text(const std::string& path, std::string& str) {
    std::FILE* const fh = open_file(path.c_str(), "r");
    if (!fh) {
        return false;
    }
    scope_guard fh_close{ [fh]() { std::fclose(fh); } };

    std::size_t size = get_file_size(fh);
    char* buf = new char[size];
    scope_guard del_buf{ [buf]() { delete[] buf; } };

    std::size_t read = std::fread(buf, 1, size, fh);
    str = std::string{ buf, read };
    return true;
}

}