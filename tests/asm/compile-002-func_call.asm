.data
.code
other_stuff PROC
 mov eax,3
 mov edx,2
 add eax,edx
 ret
other_stuff ENDP
foobar_Aint32_Aint32_Aint32 PROC
 mov DWORD PTR [rsp+16],r8d
 mov DWORD PTR [rsp+12],edx
 mov DWORD PTR [rsp+8],ecx
 push rbp
 lea rbp,[rsp+0]
 sub rsp,16
 mov DWORD PTR [rbp-8],50
 call other_stuff
 mov DWORD PTR [rbp-12],eax
 mov eax,DWORD PTR [rbp-12]
 mov edx,DWORD PTR [rbp-8]
 imul eax,edx
 mov edx,DWORD PTR [rbp+16]
 add eax,edx
 mov edx,DWORD PTR [rbp+20]
 add eax,edx
 mov edx,DWORD PTR [rbp+24]
 add eax,edx
 add rsp,16
 pop rbp
 ret
foobar_Aint32_Aint32_Aint32 ENDP
main PROC
 push rbp
 lea rbp,[rsp+0]
 sub rsp,32
 mov DWORD PTR [rbp-8],30
 xor r8d,r8d
 mov edx,100
 mov ecx,DWORD PTR [rbp-8]
 call foobar_Aint32_Aint32_Aint32
 mov DWORD PTR [rbp-12],eax
 mov eax,DWORD PTR [rbp-12]
 mov edx,DWORD PTR [rbp-8]
 add eax,edx
 add rsp,32
 pop rbp
 ret
main ENDP
END
