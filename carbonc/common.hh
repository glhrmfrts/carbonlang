#pragma once

#include <functional>

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

}