#pragma once

#include <functional>
#include <set>

namespace carbon {

struct scope_guard {
    explicit scope_guard(std::function<void()> func) : _func{func} {}

    scope_guard(const scope_guard &) = delete;

    scope_guard(scope_guard &&) = delete;

    scope_guard &operator=(const scope_guard &) = delete;

    scope_guard &operator=(scope_guard &&) = delete;

    ~scope_guard() {
        if (_func)
            _func();
    };

    void disable() { _func = {}; }

    std::function<void()> _func;
};

struct string_hash {
    using hash_type = std::size_t;

    std::string str;
    hash_type hash = 0;

    string_hash() {}

    string_hash(std::string str);

    bool operator ==(const string_hash& other) const {
        return hash == other.hash;
    }
};

bool replace(std::string& str, const std::string& from, const std::string& to);

std::vector<std::string> split(const std::string& s, char delimiter);

template <typename T> T align(T number, T alignment) {
    T offset = number % alignment;
    if (offset) {
        number = number - offset + alignment;
    }

    return number;
}

}

namespace std {
    template<> struct hash<carbon::string_hash> {
        carbon::string_hash::hash_type operator()(const carbon::string_hash& hash) const {
            return hash.hash;
        }
    };
}