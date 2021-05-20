global main
section .data
$cbstr0: db 'hello world',0
$cbstr1: db '{somedata: true}',0
section .code
main:
 push rbp
 lea rbp,qword [rsp+0]
 sub rsp,32
 lea rax,[$cbstr0]
 mov qword [rbp-8],rax
 lea rax,[$cbstr1]
 mov qword [rbp-16],rax
 mov dword [rbp-24],3
 xor eax,eax
 add rsp,32
 pop rbp
 ret
