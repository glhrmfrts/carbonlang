global main
section .data
section .text
main:
 push rbp
 lea rbp,qword [rsp]
 mov eax,157
 pop rbp
 ret
