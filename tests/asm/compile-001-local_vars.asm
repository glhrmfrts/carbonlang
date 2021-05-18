.data
.code
main PROC
 push rbp
 lea rbp,[rsp+0]
 sub rsp,16
 mov DWORD PTR [rbp-8],50
 mov DWORD PTR [rbp-12],3
 mov eax,DWORD PTR [rbp-12]
 mov edx,DWORD PTR [rbp-8]
 imul eax,edx
 add rsp,16
 pop rbp
 ret
main ENDP
END
