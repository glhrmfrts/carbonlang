#include <unordered_map>
#include "common.hh"

namespace carbon {

string_hash::string_hash(std::string str) {
    this->str = str;
    this->hash = std::hash<std::string>{}(str);
}

bool replace(std::string& str, const std::string& from, const std::string& to) {
    size_t start_pos = str.find(from);
    if(start_pos == std::string::npos)
        return false;
    str.replace(start_pos, from.length(), to);
    return true;
}

}