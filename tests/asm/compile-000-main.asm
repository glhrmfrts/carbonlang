.data
.code
other_stuff PROC
 mov eax,3
 mov edx,2
 add eax,edx
 ret
other_stuff ENDP
main PROC
 mov eax,2
 mov edx,1
 add eax,edx
 mov edx,4
 add eax,edx
 ret
main ENDP
END
