#pragma once

namespace carbon {

struct ast_node;
struct scope_def;
struct type_def;
struct local_def;
struct func_def;

struct type_id {
    scope_def* scope = nullptr;
    int type_index = -1;

    bool operator ==(const type_id& other) const { return scope == other.scope && type_index == other.type_index; }
    bool operator !=(const type_id& other) const { return !(*this == other); }

    type_def& get() const;

    bool valid() const;
};

}