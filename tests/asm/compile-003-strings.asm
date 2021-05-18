.data
$cbstr0 DB 'hello world',00H
$cbstr1 DB '{somedata: true}',00H
.code
main PROC
 push rbp
 lea rbp,[rsp+0]
 sub rsp,32
 lea [rbp-8],OFFSET:$cbstr0
 lea [rbp-16],OFFSET:$cbstr1
 mov DWORD PTR [rbp-24],3
 xor eax,eax
 add rsp,32
 pop rbp
 ret
main ENDP
END
