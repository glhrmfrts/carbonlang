#pragma once

#include <sstream>
#include "token.hh"

namespace carbon {

class exception {
private:
    std::string _message;

public:
    inline const std::string &what() const { return _message; }

    void set_message(std::ostringstream &) {}

    template<typename Arg, typename... Args>
    void set_message(std::ostringstream &oss, Arg&& arg, Args&&... args) {
        oss << std::forward<Arg>(arg);
        set_message(oss, std::forward<Args>(args)...);
    }

    template<typename... Args>
    void set_message(Args&&... args) {
        std::ostringstream oss;
        set_message(oss, std::forward<Args>(args)...);
        _message = oss.str();
    }
};

class parse_error : public exception {
public:
    position pos;

    template<typename... Args> parse_error(const std::string& filename, const position &pos, Args&&... args) {
        this->pos = pos;
        set_message(filename, ':', pos.line_number + 1, ':', pos.col_offs + 1, ' ', std::forward<Args>(args)...);
    }
};

}