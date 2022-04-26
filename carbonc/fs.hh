#pragma once

#include <vector>
#include <string>

namespace carbon {
    
bool read_file_text(const std::string& path, std::string& str);

bool is_directory(const std::string& filename);

bool ensure_directory_exists(const std::string& path);

std::string basename(const std::string& path);

std::string from_native_path(std::string path);

bool exists(const std::string& filename);

std::string join(std::string path, std::string filename);

std::vector<std::string> list(const std::string& path);

bool split_extension(const std::string& filename, std::string& root, std::string& ext);

bool getworkingdir(size_t sz, char* buf);

}