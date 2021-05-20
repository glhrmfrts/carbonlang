.data
.code
other_stuff PROC
 push rbp
 lea rbp,QWORD PTR [rsp+0]
 mov eax,2
 add eax,3
 pop rbp
 ret
other_stuff ENDP
foobar_Aint32_Aint32_Aint32 PROC
 mov DWORD PTR [rsp+16],r8d
 mov DWORD PTR [rsp+12],edx
 mov DWORD PTR [rsp+8],ecx
 push rbp
 lea rbp,QWORD PTR [rsp+0]
 sub rsp,16
 mov DWORD PTR [rbp-8],50
 call other_stuff
 mov DWORD PTR [rbp-12],eax
 mov eax,DWORD PTR [rbp-8]
 imul eax,DWORD PTR [rbp-12]
 add eax,DWORD PTR [rbp+16]
 add eax,DWORD PTR [rbp+20]
 add eax,DWORD PTR [rbp+24]
 add rsp,16
 pop rbp
 ret
foobar_Aint32_Aint32_Aint32 ENDP
f_Aint32 PROC
 mov DWORD PTR [rsp+8],ecx
 push rbp
 lea rbp,QWORD PTR [rsp+0]
 mov eax,DWORD PTR [rbp+16]
 imul eax,2
 pop rbp
 ret
f_Aint32 ENDP
main PROC
 push rbp
 push r10
 push r11
 push r12
 lea rbp,QWORD PTR [rsp+0]
 sub rsp,32
 mov DWORD PTR [rbp-8],3
 mov eax,DWORD PTR [rbp-8]
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
main ENDP
END
