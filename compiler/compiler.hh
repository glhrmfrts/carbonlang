#pragma once

namespace carbon {

constexpr auto SOURCE_EXTENSION = ".g";

enum class target_type {
    executable,
    static_library,
    dynamic_library,
};

using comp_float_type = double;

using comp_int_type = long long;

int main(int argc, const char* argv[]);

}