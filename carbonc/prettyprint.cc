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

    if (doindent) do_indent(stream, indent);

    if (node.pre_nodes.size() > 0) {
        stream << ".pre_nodes\n";
        for (const auto& child : node.pre_nodes) {
            if (child) {
                prettyprint(*child, stream, indent + 1, doindent); stream << "\n";
            }
        }
        if (doindent) do_indent(stream, indent);
    }

    switch (node.type) {
    case ast_type::invalid:
        stream << "invalid node";
        break;
    case ast_type::bool_literal:
        stream << "bool_literal " << std::boolalpha << bool(node.int_value);
        break;
    case ast_type::nil_literal:
        stream << "nil_literal";
        break;
    case ast_type::int_literal:
        stream << "int_literal " << node.int_value;
        break;
    case ast_type::float_literal:
        stream << "float_literal" << node.float_value;
        break;
    case ast_type::string_literal:
        stream << "string_literal " << "\"" << node.string_value << "\"";
        break;
    case ast_type::identifier:
        stream << "identifier " << build_identifier_value(node.id_parts) << "";
        break;
    case ast_type::unary_expr:
        stream << "unary ";
        stream << token_to_char(node.op) << "\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        break;
    case ast_type::binary_expr:
        stream << "binary ";
        stream << token_to_char(node.op) << "\n";
        if (node.children.front()) prettyprint(*node.children.front().get(), stream, indent + 1);
        stream << "\n";
        if (node.children.back()) prettyprint(*node.children.back().get(), stream, indent + 1);
        break;
    case ast_type::call_expr:
        stream << "call\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        stream << "\n";
        prettyprint(*node.children.back().get(), stream, indent + 1);
        break;
    case ast_type::index_expr:
        prettyprint(*node.children.front().get(), stream, indent + 1, false);
        stream << "[";
        prettyprint(*node.children.back().get(), stream, indent + 1, false);
        stream << "]";
        break;
    case ast_type::field_expr:
        stream << "field_expr\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        stream << "\n";
        prettyprint(*node.children.back().get(), stream, indent + 1);
        break;
    case ast_type::cast_expr: {
        stream << "cast_expr\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        stream << "\n";
        prettyprint(*node.children.back().get(), stream, indent + 1);
        break;
    }
    case ast_type::init_expr: {
        stream << "init_expr";
        auto init_type = node.children.front().get();
        if (init_type) {
            stream << "\n";
            prettyprint(*init_type, stream, indent + 1);
        }
        stream << "\n";
        prettyprint(*node.children.back().get(), stream, indent + 1);
        stream << "\n";
        do_indent(stream, indent);
        stream << "init_expr end";
        break;
    }
    case ast_type::type_decl:
        stream << "type_decl\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        if (node.children.at(ast_node::child_type_decl_contents).get()) {
            stream << "\n";
            prettyprint(*node.children.at(ast_node::child_var_decl_type).get(), stream, indent + 1);
        }
        break;
    case ast_type::var_decl:
        stream << "var_decl\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        if (node.children.at(ast_node::child_var_decl_type).get()) {
            stream << "\n";
            do_indent(stream, indent);
            stream << ".type\n";
            prettyprint(*node.children.at(ast_node::child_var_decl_type).get(), stream, indent + 1);
        }
        if (node.children.at(ast_node::child_var_decl_value).get()) {            
            stream << "\n";
            do_indent(stream, indent);
            stream << ".value\n";
            prettyprint(*node.children.at(ast_node::child_var_decl_value).get(), stream, indent + 1);
        }
        break;
    case ast_type::func_decl:
        stream << "func_decl\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        if (node.children.at(ast_node::child_func_decl_arg_list).get()) {
            stream << "\n";
            prettyprint(*node.children.at(ast_node::child_func_decl_arg_list).get(), stream, indent + 1);
        }
        if (node.children.at(ast_node::child_func_decl_ret_type).get()) {
            stream << "\n";
            prettyprint(*node.children.at(ast_node::child_func_decl_ret_type).get(), stream, indent + 1);
        }
        if (node.children.at(ast_node::child_func_decl_body).get()) {
            stream << "\n";
            prettyprint(*node.children.at(ast_node::child_func_decl_body).get(), stream, indent + 1);
        }
        break;
    case ast_type::arg_list:
        stream << "arg_list";
        for (std::size_t i = 0; i < node.children.size(); i++) {
            stream << "\n";
            prettyprint(*node.children[i].get(), stream, indent + 1);
        }
        stream << "\n";
        do_indent(stream, indent);
        stream << "arg_list end";
        break;
    case ast_type::decl_list:
        stream << "decl_list";
        for (std::size_t i = 0; i < node.children.size(); i++) {
            stream << "\n";
            prettyprint(*node.children[i].get(), stream, indent + 1);
        }
        stream << "\n";
        do_indent(stream, indent);
        stream << "decl_list end";
        break;
    case ast_type::stmt_list:
        stream << "stmt_list";
        for (std::size_t i = 0; i < node.children.size(); i++) {
            stream << "\n";
            prettyprint(*node.children[i].get(), stream, indent + 1);
        }
        stream << "\n";
        do_indent(stream, indent);
        stream << "stmt_list end";
        break;
    case ast_type::compound_stmt:
        stream << "compound_stmt";
        for (std::size_t i = 0; i < node.children.size(); i++) {            
            stream << "\n";
            prettyprint(*node.children[i].get(), stream, indent + 1);
        }
        stream << "\n";
        do_indent(stream, indent);
        stream << "compound_stmt end";
        break;
    case ast_type::return_stmt:
        stream << "return_stmt\n";
        if (node.children.front()) {
            prettyprint(*node.children.front().get(), stream, indent + 1);
        }
        break;
    case ast_type::defer_stmt:
        stream << "defer\n";
        if (node.children.front()) {
            prettyprint(*node.children.front().get(), stream, indent + 1);
        }
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
        stream << "type_expr\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        break;
    case ast_type::struct_type:
        stream << "struct_type\n";
        if (node.children.front()) {
            prettyprint(*node.children.front().get(), stream, indent + 1);
        }
        break;
    case ast_type::array_view_type:
        stream << "array_view_type ";
        stream << "[" << token_to_char(node.op) << "] ";
        stream << "\n";
        if (node.children.front()) { prettyprint(*node.children.front().get(), stream, indent + 1); }
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
        stream << "type_qualifier ";
        switch (node.type_qual) {
        case type_qualifier::ptr:
            stream << "ptr";
            break;
        case type_qualifier::in:
            stream << "in";
            break;
        }
        stream << "\n";
        prettyprint(*node.children.back().get(), stream, indent + 1);
        break;
    case ast_type::type_resolver:
        stream << "type_resolver ";
        stream << type_to_string(node.tid);
        break;
    case ast_type::linkage_specifier: {
        stream << "linkage_specifier ";
        stream << func_linkage_name(node.func.linkage);
        auto& content = node.children.front();
        if (content) {
            stream << "\n";
            prettyprint(*content, stream, indent + 1);
        }
        stream << "\n";
        do_indent(stream, indent);
        stream << "linkage_specifier end";
        break;
    }
    case ast_type::visibility_specifier: {
        stream << "visibility_specifier ";
        stream << func_linkage_name(node.func.linkage);
        auto& content = node.children.front();
        if (content) {
            stream << "\n";
            prettyprint(*content, stream, indent + 1);
        }
        stream << "\n";
        do_indent(stream, indent);
        stream << "visibility_specifier end";
        break;
    }
    case ast_type::imports_decl: {
        stream << "import_decl\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        auto& alias = node.children.back();
        if (alias) {
            stream << "\n";
            prettyprint(*alias, stream, indent + 1);
        }
        break;
    }
    case ast_type::code_unit:
        stream << "code_unit " << node.filename << "\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        stream << "\n";
        do_indent(stream, indent);
        stream << "code_unit " << node.filename << " end";
        break;
    case ast_type::module_:
        stream << "module " << node.modname << "\n";
        for (const auto& child : node.children) {
            if (child) {
                stream << "\n";
                prettyprint(*child, stream, indent + 1, doindent);
            }
        }
        stream << "\n";
        do_indent(stream, indent);
        stream << "module " << node.modname << " end";
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