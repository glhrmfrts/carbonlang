#include "prettyprint.hh"
#include "ast.hh"

namespace carbon {

void do_indent(std::ostream& stream, int indent) {
    int spaces = indent*2;
    while (spaces) {
        stream << " ";
        spaces--;
    }
}

void prettyprint(const ast_node& node, std::ostream& stream, int indent, bool doindent) {
    if (doindent) do_indent(stream, indent);
    switch (node.type) {
    case ast_type::invalid:
        stream << "invalid node";
        break;
    case ast_type::bool_literal:
        stream << "bool_literal{" << std::boolalpha << bool(node.int_value) << "}";
        break;
    case ast_type::int_literal:
        stream << "int_literal{" << node.int_value << "}";
        break;
    case ast_type::float_literal:
        stream << "float_literal{" << node.float_value << "}";
        break;
    case ast_type::string_literal:
        stream << "string_literal{\"" << node.string_value << "\"}";
        break;
    case ast_type::identifier:
        stream << "identifier{\"" << build_identifier_value(node.id_parts) << "\"}";
        break;
    case ast_type::unary_expr:
        stream << "unary_expr{\n";
        do_indent(stream, indent + 1);
        stream << token_to_char(node.op) << "\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        stream << "}";
        break;
    case ast_type::binary_expr:
        stream << "binary_expr{\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        stream << "\n";
        do_indent(stream, indent + 1);
        stream << token_to_char(node.op) << "\n";
        prettyprint(*node.children.back().get(), stream, indent + 1);
        stream << "}";
        break;
    case ast_type::call_expr:
        stream << "call_expr{\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        stream << "\n";
        prettyprint(*node.children.back().get(), stream, indent + 1);
        stream << "}";
        break;
    case ast_type::index_expr:
        stream << "index_expr{\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        stream << "\n";
        prettyprint(*node.children.back().get(), stream, indent + 1);
        stream << "}";
        break;
    case ast_type::init_expr: {
        stream << "init_expr{\n";

        auto init_type = node.children.front().get();
        if (init_type) {
            do_indent(stream, indent + 1); stream << "type=";
            prettyprint(*init_type, stream, indent + 1, false);
            stream << "\n";
        }

        prettyprint(*node.children.back().get(), stream, indent + 1);
        stream << "}";
        break;
    }
    case ast_type::type_decl:
        stream << "type_decl{\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        if (node.children.at(ast_node::child_type_decl_contents).get()) {
            stream << "\n"; do_indent(stream, indent + 1);
            stream << "=";
            prettyprint(*node.children.at(ast_node::child_var_decl_type).get(), stream, indent + 1, false);
        }
        stream << "}";
        break;
    case ast_type::var_decl:
        stream << "var_decl{\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        if (node.children.at(ast_node::child_var_decl_type).get()) {
            stream << "\n"; do_indent(stream, indent + 1);
            stream << ":";
            prettyprint(*node.children.at(ast_node::child_var_decl_type).get(), stream, indent + 1, false);
        }
        if (node.children.at(ast_node::child_var_decl_value).get()) {
            stream << "\n"; do_indent(stream, indent + 1);
            stream << "=";
            prettyprint(*node.children.at(ast_node::child_var_decl_value).get(), stream, indent + 1, false);
        }
        stream << "}";
        break;
    case ast_type::func_decl:
        stream << "func_decl{\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        if (node.children.at(ast_node::child_func_decl_arg_list).get()) {
            stream << "\n";// do_indent(stream, indent);
            prettyprint(*node.children.at(ast_node::child_func_decl_arg_list).get(), stream, indent + 1);
        }
        if (node.children.at(ast_node::child_func_decl_ret_type).get()) {
            stream << "\n"; do_indent(stream, indent + 1);
            stream << ":";
            prettyprint(*node.children.at(ast_node::child_func_decl_ret_type).get(), stream, indent + 1, false);
        }
        if (node.children.at(ast_node::child_func_decl_body).get()) {
            stream << "\n";// do_indent(stream, indent + 1);
            prettyprint(*node.children.at(ast_node::child_func_decl_body).get(), stream, indent + 1, false);
        }
        stream << "}";
        break;
    case ast_type::arg_list:
        stream << "arg_list(";
        for (std::size_t i = 0; i < node.children.size(); i++) {
            stream << "\n";
            prettyprint(*node.children[i].get(), stream, indent + 1);
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
        stream << "compound_stmt{";
        for (std::size_t i = 0; i < node.children.size(); i++) {
            stream << "\n";
            prettyprint(*node.children[i].get(), stream, indent + 1);
        }
        stream << "}";
        break;
    case ast_type::return_stmt:
        stream << "return_stmt{\n";
        do_indent(stream, indent + 1);
        prettyprint(*node.children.front().get(), stream, indent + 1);
        stream << "}";
        break;
    case ast_type::asm_stmt:
        stream << "asm_stmt{\n";
        do_indent(stream, indent + 1);
        stream << node.string_value;
        stream << "}";
        break;
    case ast_type::type_expr:
        stream << "type_expr{\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        stream << "}";
        break;
    case ast_type::struct_type:
        stream << "struct_type{\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        stream << "}";
        break;
    case ast_type::tuple_type:
        stream << "tuple_type{\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        stream << "}";
        break;
    case ast_type::array_type: {
        stream << "array_type{\n";
        do_indent(stream, indent + 1);
        stream << "size=";

        auto size_expr = node.children.front().get();
        if (size_expr) { prettyprint(*size_expr, stream, indent + 1,false); }
        else { stream << "dynamic"; }

        stream << "\n";
        prettyprint(*node.children.back().get(), stream, indent + 1);
        stream << "}";
        break;
    }
    case ast_type::type_qualifier:
        stream << "type_qualifier{";
        switch (node.type_qual) {
        case type_qualifier::optional:
            stream << "optional,";
            break;
        case type_qualifier::reference:
            stream << "reference,";
            break;
        }
        stream << "\n";
        prettyprint(*node.children.back().get(), stream, indent + 1);
        stream << "}";
        break;
    case ast_type::linkage_specifier: {
        stream << "linkage_specifier{\n";
        do_indent(stream, indent + 1);
        stream << func_linkage_name(node.func.linkage);
        auto& content = node.children.front();
        if (content) {
            stream << "\n";
            prettyprint(*content, stream, indent + 1);
        }
        stream << "}";
        break;
    }
    case ast_type::visibility_specifier: {
        stream << "visibility_specifier{\n";
        do_indent(stream, indent + 1);
        stream << visibility_name(node.op);
        auto& content = node.children.front();
        if (content) {
            stream << "\n";
            prettyprint(*content, stream, indent + 1);
        }
        stream << "}";
        break;
    }
    case ast_type::import_decl: {
        stream << "import_decl{\n";
        prettyprint(*node.children.front().get(), stream, indent + 1);
        auto& alias = node.children.back();
        if (alias) {
            stream << "\n";
            prettyprint(*alias, stream, indent + 1);
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
    }
}

}