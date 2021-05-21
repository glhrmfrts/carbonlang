#include <cstdio>
#include <cassert>
#include <algorithm>
#include "common.hh"
#include "fs.hh"

namespace carbon {

#ifdef _WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

LPCTSTR error_message(DWORD error)
    // Routine Description:
    //      Retrieve the system error message for the last-error code
{
    LPVOID lpMsgBuf;

    FormatMessage(
        FORMAT_MESSAGE_ALLOCATE_BUFFER |
        FORMAT_MESSAGE_FROM_SYSTEM |
        FORMAT_MESSAGE_IGNORE_INSERTS,
        NULL,
        error,
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        (LPTSTR)&lpMsgBuf,
        0, NULL);

    return((LPCTSTR)lpMsgBuf);
}

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

std::string get_directory(std::string filename)
{
    /* If filename is already a path, return it */
    if (!filename.empty() && filename.back() == '/')
        return filename.substr(0, filename.size() - 1);

    std::size_t pos = filename.find_last_of('/');

    /* Filename doesn't contain any slash (no path), return empty string */
    if (pos == std::string::npos) return {};

    /* Return everything to last slash */
    return filename.substr(0, pos);
}

bool exists(const std::string& filename)
{
#ifdef _WIN32
    return GetFileAttributesW(widen(filename).c_str()) != INVALID_FILE_ATTRIBUTES;
#endif
}

bool is_directory(const std::string& filename) {
    WIN32_FIND_DATAW data;
    HANDLE hFind = FindFirstFileW(widen(filename).c_str(), &data);
    bool res = (data.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY);
    FindClose(hFind);
    return res;
}

bool create(const std::string& path)
{
    if (path.empty()) return false;

    /* If path contains trailing slash, strip it */
    if (path.back() == '/')
        return create(path.substr(0, path.size() - 1));

    /* If parent directory doesn't exist, create it */
    const std::string parent = get_directory(path);
    if (!parent.empty() && !exists(parent) && !create(parent)) return false;

    /* Create directory, return true if successfully created or already exists */

#ifdef _WIN32
    if (CreateDirectoryW(widen(path).data(), nullptr) == 0 && GetLastError() != ERROR_ALREADY_EXISTS) {
        std::wstring werr = std::wstring((const wchar_t*)error_message(GetLastError()));
        std::string err = narrow(werr);
        return false;
    }
#endif

    return true;
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

bool ensure_directory_exists(const std::string& path) {
    /* If parent directory doesn't exist, create it */
    const std::string parent = get_directory(path);
    if (!parent.empty() && !exists(parent) && !create(parent)) return false;

    return true;
}


bool split_extension(const std::string& filename, std::string& root, std::string& ext)
{
    /* Find the last dot and the last slash -- for file.tar.gz we want just
    .gz as an extension; for /etc/rc.conf/bak we don't want to split at the
    folder name. */
    const std::size_t pos = filename.find_last_of('.');
    const std::size_t lastSlash = filename.find_last_of('/');

    /* Empty extension if there's no dot or if the dot is not inside the
       filename */
    if (pos == std::string::npos || (lastSlash != std::string::npos && pos < lastSlash)) {
        root = filename;
        ext = "";
        return false;
    }

    /* If the dot at the start of the filename (/root/.bashrc), it's also an
       empty extension. Multiple dots at the start (/home/mosra/../..) classify
       as no extension as well. */
    std::size_t prev = pos;
    while (prev && filename[prev - 1] == '.') --prev;
    assert(pos < filename.size());
    if (prev == 0 || filename[prev - 1] == '/') {
        root = filename;
        ext = "";
        return false;
    }

    /* Otherwise it's a real extension */
    root = filename.substr(0, pos);
    ext = filename.substr(pos);
    return true;
}

std::string join(std::string path, std::string filename)
{
    /* Empty path */
    if (path.empty()) return filename;

#ifdef _WIN32
    /* Absolute filename on Windows */
    if (filename.size() > 2 && filename[1] == ':' && filename[2] == '/')
        return filename;
#endif

    /* Absolute filename */
    if (!filename.empty() && filename[0] == '/')
        return filename;

    /* Add trailing slash to path, if not present */
    if (path.back() != '/')
        return path + '/' + filename;

    return path + filename;
}

std::vector<std::string> list(const std::string& path) {
    std::vector<std::string> list;

    /* POSIX-compliant Unix, Emscripten */
#if defined(CORRADE_TARGET_UNIX) || defined(CORRADE_TARGET_EMSCRIPTEN)
    DIR* directory = opendir(path.data());
    if (!directory) return list;

    dirent* entry;
    while ((entry = readdir(directory)) != nullptr) {
        if ((flags >= Flag::SkipDirectories) && entry->d_type == DT_DIR)
            continue;
#ifndef CORRADE_TARGET_EMSCRIPTEN
        if ((flags >= Flag::SkipFiles) && entry->d_type == DT_REG)
            continue;
        if ((flags >= Flag::SkipSpecial) && entry->d_type != DT_DIR && entry->d_type != DT_REG)
            continue;
#else
        if ((flags >= Flag::SkipFiles || flags >= Flag::SkipSpecial) && entry->d_type != DT_DIR)
            continue;
#endif

        std::string file{ entry->d_name };
        if ((flags >= Flag::SkipDotAndDotDot) && (file == "." || file == ".."))
            continue;

        list.push_back(std::move(file));
    }

    closedir(directory);

    /* Windows (not Store/Phone) */
#elif defined(_WIN32)
    WIN32_FIND_DATAW data;
    HANDLE hFile = FindFirstFileW(widen(join(path, "*")).data(), &data);
    if (hFile == INVALID_HANDLE_VALUE) return list;
    scope_guard closeHandle{ [hFile]() { FindClose(hFile); } };

    while (FindNextFileW(hFile, &data) != 0 || GetLastError() != ERROR_NO_MORE_FILES) {
        std::string file{ narrow(data.cFileName) };
        /* Not testing for dot, as it is not listed on Windows */
        if (file == "..")
            continue;

        list.push_back(std::move(file));
    }

    /* Other not implemented */
#else
    Warning() << "Utility::Directory::list(): not implemented on this platform";
    static_cast<void>(path);
#endif

    std::sort(list.begin(), list.end());
    return list;
}

}