global main
section .data
section .code
main:
 push rbp
 lea rbp,qword [rsp+0]
 sub rsp,16
 mov dword [rbp-8],50
 mov dword [rbp-12],3
 mov eax,dword [rbp-8]
 imul eax,dword [rbp-12]
 add rsp,16
 pop rbp
 ret
