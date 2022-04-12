#pragma once

namespace carbon {

enum class target_type {
    executable,
    static_library,
    dynamic_library,
};

using float_type = double;

using int_type = long long;

int main(int argc, const char* argv[]);

}