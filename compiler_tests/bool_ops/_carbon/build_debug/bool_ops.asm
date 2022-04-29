global cb__Nmain__NisNumeric__Auint8
export cb__Nmain__NisNumeric__Auint8
global cb__Nmain__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8
export cb__Nmain__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8
global carbon_main
export carbon_main
section .data
section .rodata
section .code
cb__Nmain__NisNumeric__Auint8:
;func isNumeric(uint8): bool
 push rbp
 mov rbp,rsp
 sub rsp,16
;prolog end

 cmp cl,48
 jl cb__Nmain__NisNumeric__Auint8$if182$else
;ir_jmp_lt A0 #48 cb__Nmain__NisNumeric__Auint8$if182$else;

 cmp cl,57
 jg cb__Nmain__NisNumeric__Auint8$if182$else
;ir_jmp_gt A0 #57 cb__Nmain__NisNumeric__Auint8$if182$else;

cb__Nmain__NisNumeric__Auint8$if182$body:
;ir_make_label cb__Nmain__NisNumeric__Auint8$if182$body;

 mov r10b,1
 mov byte[rbp-1],r10b
;ir_load L0 1;

 jmp cb__Nmain__NisNumeric__Auint8$if182$end
;ir_jmp cb__Nmain__NisNumeric__Auint8$if182$end;

cb__Nmain__NisNumeric__Auint8$if182$else:
;ir_make_label cb__Nmain__NisNumeric__Auint8$if182$else;

 xor r10b,r10b
 mov byte[rbp-1],r10b
;ir_load L0 0;

cb__Nmain__NisNumeric__Auint8$if182$end:
;ir_make_label cb__Nmain__NisNumeric__Auint8$if182$end;

 mov al,byte[rbp-1]
;ir_return L0;

cb__Nmain__NisNumeric__Auint8$end:
 add rsp,16
 pop rbp
 ret


cb__Nmain__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8:
;func trimNonNumeric(&[]pure uint8, &[]pure uint8): &[]pure uint8
 mov qword[rsp+16],rdx
 mov qword[rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,40
;prolog end

 xor r10,r10
 mov qword[rbp-8],r10
;ir_load L0 0;

 mov rax,qword[rbp+32]
;ir_deref A1; (push)

 mov rax,qword[rax+0]
;ir_deref [POP() . 0]; (push)

 xor r10,r10
 lea rax,byte[rax+0+r10*1]
;ir_index POP() 0; (push)

 mov cl,byte[rax]
 call cb__Nmain__NisNumeric__Auint8
;ir_call cb__Nmain__NisNumeric__Auint8 POP(); (push)

 cmp al,0
 jne cb__Nmain__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if53$else
;ir_jmp_neq POP() 0 cb__Nmain__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if53$else;

cb__Nmain__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if53$body:
;ir_make_label cb__Nmain__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if53$body;

 mov r10,qword[rbp-8]
 add r10,1
 mov rax,r10
;ir_add L0 1; (push)

 mov qword[rbp-8],rax
;ir_load L0 POP();

cb__Nmain__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if53$else:
;ir_make_label cb__Nmain__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$if53$else;

 mov rbx,qword[rbp+24]
;ir_deref A0; (push)

 mov rax,qword[rbp+32]
;ir_deref A1; (push)

 mov r10,qword[rax+0]
 add r10,qword[rbp-8]
 mov rax,r10
;ir_add [POP() . 0] L0; (push)

 mov qword[rbx+0],rax
;ir_load [POP() . 0] POP();

 mov rbx,qword[rbp+24]
;ir_deref A0; (push)

 mov rax,qword[rbp+32]
;ir_deref A1; (push)

 mov r10,qword[rax+8]
 sub r10,qword[rbp-8]
 mov rax,r10
;ir_sub [POP() . 1] L0; (push)

 mov qword[rbx+8],rax
;ir_load [POP() . 1] POP();

 mov rax,qword[rbp+24]
;ir_return A0;

cb__Nmain__NtrimNonNumeric__Aptr__Tslice__Tpure__Tuint8__Aptr__Tslice__Tpure__Tuint8$end:
 add rsp,40
 pop rbx
 pop rbp
 ret


carbon_main:
;func carbon_main(): int
 push rbp
 mov rbp,rsp
 sub rsp,32
;prolog end

 xor r10,r10
 mov qword[rbp-8],r10
;ir_load L0 0;

 xor r10,r10
 mov qword[rbp-16],r10
;ir_load L1 0;

 mov r10,qword[rbp-16]
 cmp r10,qword[rbp-8]
 setl al
;ir_cmp_lt L1 L0; (push)

 mov byte[rbp-17],al
;ir_load L2 POP();

 mov r10,qword[rbp-16]
 add r10,1
 mov rax,r10
;ir_add L1 1; (push)

 mov qword[rbp-32],rax
;ir_load L3 POP();

 mov r10,qword[rbp-32]
 add r10,1
 mov rax,r10
;ir_add L3 1; (push)

 mov qword[rbp-32],rax
;ir_load L3 POP();

 xor eax,eax
;ir_return 0;

carbon_main$end:
 add rsp,32
 pop rbp
 ret


