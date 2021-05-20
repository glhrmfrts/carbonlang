global other_stuff
global foobar_Aint32_Aint32_Aint32
global f_Aint32
global main
section .data
section .code
other_stuff:
 push rbp
 lea rbp,qword [rsp+0]
 mov eax,2
 add eax,3
 pop rbp
 ret
foobar_Aint32_Aint32_Aint32:
 mov dword [rsp+16],r8d
 mov dword [rsp+12],edx
 mov dword [rsp+8],ecx
 push rbp
 lea rbp,qword [rsp+0]
 sub rsp,16
 mov dword [rbp-8],50
 call other_stuff
 mov dword [rbp-12],eax
 mov eax,dword [rbp-8]
 imul eax,dword [rbp-12]
 add eax,dword [rbp+16]
 add eax,dword [rbp+20]
 add eax,dword [rbp+24]
 add rsp,16
 pop rbp
 ret
f_Aint32:
 mov dword [rsp+8],ecx
 push rbp
 lea rbp,qword [rsp+0]
 mov eax,dword [rbp+16]
 imul eax,2
 pop rbp
 ret
main:
 push rbp
 push r10
 push r11
 push r12
 lea rbp,qword [rsp+0]
 sub rsp,32
 mov dword [rbp-8],3
 mov eax,dword [rbp-8]
 imul eax,7
 mov r11d,eax
 mov r12d,50
 mov ecx,1
 call f_Aint32
 imul eax,r12d
 add eax,r11d
 mov r10d,eax
 mov ecx,2
 call f_Aint32
 imul eax,70
 add eax,23
 mov r11d,eax
 mov ecx,3
 call f_Aint32
 imul eax,4
 add eax,r11d
 add eax,r10d
 add rsp,32
 pop r12
 pop r11
 pop r10
 pop rbp
 ret
