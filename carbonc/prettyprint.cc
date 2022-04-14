#include "prettyprint.hh"
#include "ast.hh"
#include "type_system.hh"

namespace carbon {

void do_indent(std::ostream& stream, int indent) {
    int spaces = indent*2;
    while (spaces) {
        stream << " ";
        spaces--;
    }
}

void prettyprint(const ast_node& node, std::ostream& stream, int indent, bool doindent) {
    if (node.disabled) return;

    for (const auto& child : node.pre_children) {
        if (child) { prettyprint(*child, stream, indent, doindent); stream << "\n"; }
    }
    if (doindent) do_indent(stream, indent);
    switch (node.type) {
    case ast_type::invalid:
        stream << "invalid node";
        break;
    case ast_type::bool_literal:
        stream << std::boolalpha << bool(node.int_value);
        break;
    case ast_type::int_literal:
        stream << node.int_value;
        break;
    case ast_type::float_literal:
        stream << node.float_value;
        break;
    case ast_type::string_literal:
        stream << "\"" << node.string_value << "\"";
        break;
    case ast_type::identifier:
        stream << "" << build_identifier_value(node.id_parts) << "";
        break;
    case ast_type::unary_expr:
        stream << "{";
        stream << token_to_char(node.op) << " ";
        prettyprint(*node.children.front().get(), stream, indent, false);
        stream << "}";
        break;
    case ast_type::binary_expr:
        stream << "{";
        if (node.children.front()) prettyprint(*node.children.front().get(), stream, indent, false);
        stream << " ";
        stream << token_to_char(node.op) << " ";
        if (node.children.back()) prettyprint(*node.children.back().get(), stream, indent, false);
        stream << "}";
        break;
    case ast_type::call_expr:
        stream << "call{";
        prettyprint(*node.children.front().get(), stream, indent, false);
        stream << " ";
        prettyprint(*node.children.back().get(), stream, indent, false);
        stream << "}";
        break;
    case ast_type::index_expr:
        prettyprint(*node.children.front().get(), stream, indent + 1, false);
        stream << "[";
        prettyprint(*node.children.back().get(), stream, indent + 1, false);
        stream << "]";
        break;
    case ast_type::field_expr:
        prettyprint(*node.children.front().get(), stream, indent + 1, false);
        stream << ".";
        prettyprint(*node.children.back().get(), stream, indent + 1, false);
        break;
    case ast_type::cast_expr: {
        stream << "cast_expr{";
        prettyprint(*node.children.front().get(), stream, indent + 1, false);
        stream << " ";
        prettyprint(*node.children.back().get(), stream, indent + 1, false);
        stream << "}";
        break;
    }
    case ast_type::init_expr: {
        stream << "init{";
        auto init_type = node.children.front().get();
        if (init_type) {
            stream << "type=";
            prettyprint(*init_type, stream, indent + 1, false);
            stream << " ";

        }
        if (!node.initlist.assignments.empty()) {
            stream << "\n";
            for (const auto& a : node.initlist.assignments) {
                prettyprint(*a, stream, indent + 1, true);
                stream << "\n";
            }
            do_indent(stream, indent + 1);
        }
        else {
            prettyprint(*node.children.back().get(), stream, indent + 1, false);
        }
        stream << "}";
        break;
    }
    case ast_type::type_decl:
        stream << "type_decl{";
        prettyprint(*node.children.front().get(), stream, indent + 1, false);
        if (node.children.at(ast_node::child_type_decl_contents).get()) {
            stream << " = ";
            prettyprint(*node.children.at(ast_node::child_var_decl_type).get(), stream, indent + 1, false);
        }
        stream << "}";
        break;
    case ast_type::var_decl:
        stream << "var_decl{";
        prettyprint(*node.children.front().get(), stream, indent + 1, false);
        if (node.children.at(ast_node::child_var_decl_type).get()) {
            stream << ": ";
            prettyprint(*node.children.at(ast_node::child_var_decl_type).get(), stream, indent + 1, false);
        }
        if (node.children.at(ast_node::child_var_decl_value).get()) {            
            stream << " = ";
            prettyprint(*node.children.at(ast_node::child_var_decl_value).get(), stream, indent + 1, false);
        }
        stream << "}";
        break;
    case ast_type::func_decl:
        stream << "func_decl{";
        prettyprint(*node.children.front().get(), stream, indent, false);
        stream << " ";
        if (node.children.at(ast_node::child_func_decl_arg_list).get()) {
            prettyprint(*node.children.at(ast_node::child_func_decl_arg_list).get(), stream, indent + 1, false);
        }
        if (node.children.at(ast_node::child_func_decl_ret_type).get()) {
            stream << ": ";
            prettyprint(*node.children.at(ast_node::child_func_decl_ret_type).get(), stream, indent + 1, false);
        }
        stream << " ";
        if (node.children.at(ast_node::child_func_decl_body).get()) {
            prettyprint(*node.children.at(ast_node::child_func_decl_body).get(), stream, indent + 1, false);
        }
        stream << "}";
        break;
    case ast_type::arg_list:
        stream << "(";
        for (std::size_t i = 0; i < node.children.size(); i++) {
            if (i > 0) { stream << ", "; }
            prettyprint(*node.children[i].get(), stream, indent + 1, false);
        }
        stream << ")";
        break;
    case ast_type::decl_list:
        stream << "decl_list{";
        for (std::size_t i = 0; i < node.children.size(); i++) {
            stream << "\n";
            prettyprint(*node.children[i].get(), stream, indent + 1);
        }
        stream << "}";
        break;
    case ast_type::stmt_list:
        stream << "stmt_list{";
        for (std::size_t i = 0; i < node.children.size(); i++) {
            stream << "\n";
            prettyprint(*node.children[i].get(), stream, indent + 1);
        }
        stream << "}";
        break;
    case ast_type::compound_stmt:
        stream << "{";
        for (std::size_t i = 0; i < node.children.size(); i++) {            
            stream << "\n";
            prettyprint(*node.children[i].get(), stream, indent + 1);
        }
        stream << "}";
        break;
    case ast_type::return_stmt:
        stream << "return{";
        if (node.children.front()) {
            prettyprint(*node.children.front().get(), stream, indent + 1, false);
        }
        stream << "}";
        break;
    case ast_type::defer_stmt:
        stream << "defer{";
        if (node.children.front()) {
            prettyprint(*node.children.front().get(), stream, indent + 1, false);
        }
        stream << "}";
        break;
    case ast_type::asm_stmt:
        stream << "asm{";
        stream << node.string_value;
        stream << "}";
        break;
    case ast_type::if_stmt: {
        stream << "if{";
        prettyprint(*node.children[0].get(), stream, indent + 1, false);
        stream << " ";
        prettyprint(*node.children[1].get(), stream, indent + 1, false);
        if (node.children.size() == 3) {
            stream << " else ";
            prettyprint(*node.children[2].get(), stream, indent + 1, false);
        }
        stream << "}";
        break;
    }
    case ast_type::type_expr:
        stream << "type_expr{";
        prettyprint(*node.children.front().get(), stream, indent + 1, false);
        stream << "}";
        break;
    case ast_type::struct_type:
        stream << "struct_type{";
        if (node.children.front()) {
            prettyprint(*node.children.front().get(), stream, indent + 1, false);
        }
        stream << "}";
        break;
    case ast_type::tuple_type:
        stream << "tuple_type{";
        if (node.children.front()) { prettyprint(*node.children.front().get(), stream, indent + 1, false); }
        stream << "}";
        break;
    case ast_type::slice_type:
        stream << "slice_type{";
        stream << "[" << token_to_char(node.op) << "] ";
        if (node.children.front()) { prettyprint(*node.children.front().get(), stream, indent + 1, false); }
        stream << "}";
        break;
    case ast_type::array_type: {
        stream << "array_type{";
        stream << "size=";

        auto size_expr = node.children.front().get();
        if (size_expr) { prettyprint(*size_expr, stream, indent + 1, false); }
        else { stream << "dynamic"; }

        stream << " ";
        prettyprint(*node.children.back().get(), stream, indent + 1, false);
        stream << "}";
        break;
    }
    case ast_type::type_qualifier:
        stream << "type_qualifier{";
        switch (node.type_qual) {
        case type_qualifier::ptr:
            stream << "optional,";
            break;
        case type_qualifier::nullableptr:
            stream << "pointer,";
            break;
        }
        stream << " ";
        prettyprint(*node.children.back().get(), stream, indent + 1, false);
        stream << "}";
        break;
    case ast_type::linkage_specifier: {
        stream << "linkage_specifier{ ";
        stream << func_linkage_name(node.func.linkage);
        auto& content = node.children.front();
        if (content) {
            stream << " ";
            prettyprint(*content, stream, indent + 1, false);
        }
        stream << "}";
        break;
    }
    case ast_type::visibility_specifier: {
        stream << "visibility_specifier{ ";
        stream << visibility_name(node.visibility);
        auto& content = node.children.front();
        if (content) {
            stream << " ";
            prettyprint(*content, stream, indent + 1, false);
        }
        stream << "}";
        break;
    }
    case ast_type::import_decl: {
        stream << "import_decl{ ";
        prettyprint(*node.children.front().get(), stream, indent + 1, false);
        auto& alias = node.children.back();
        if (alias) {
            stream << " ";
            prettyprint(*alias, stream, indent + 1, false);
        }
        stream << "}";
        break;
    }
    case ast_type::code_unit:
        stream << "code_unit{\n";
        do_indent(stream, indent + 1);
        stream << node.string_value << "\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        stream << "}";
        break;
    default: {
        for (const auto& child : node.children) {
            if (child) { prettyprint(*child, stream, indent + 1, doindent); }
        }
        break;
    }
    }
}

}