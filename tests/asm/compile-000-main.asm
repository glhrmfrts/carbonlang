global main
section .data
section .code
main:
 push rbp
 lea rbp,qword [rsp+0]
 mov eax,157
 pop rbp
 ret
