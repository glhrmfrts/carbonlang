.data
.code
main PROC
 push rbp
 lea rbp,QWORD PTR [rsp+0]
 sub rsp,16
 mov DWORD PTR [rbp-8],50
 mov DWORD PTR [rbp-12],3
 mov eax,DWORD PTR [rbp-8]
 imul eax,DWORD PTR [rbp-12]
 add rsp,16
 pop rbp
 ret
main ENDP
END
