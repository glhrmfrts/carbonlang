extern puts
global println_A
global main
section .data
$cbstr0: db 'hello world from Carbon extern func!',0
section .code
println_A:
 mov qword [rsp+8],rcx
 push rbp
 lea rbp,qword [rsp+0]
 sub rsp,32
 mov rcx,qword [rbp+16]
 call puts
 add rsp,32
 pop rbp
 ret
main:
 push rbp
 lea rbp,qword [rsp+0]
 sub rsp,16
 lea rcx,[$cbstr0]
 call println_A
 add rsp,16
 pop rbp
 ret
