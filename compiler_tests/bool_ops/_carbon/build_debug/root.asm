global cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint
export cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint
global carbon_main
export carbon_main
section .data
$cmp16selector: db 0x0,0x1,0x8,0x9,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80
section .rodata
section .code
cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint:
;func parseIntRem(&{int, []pure uint8, bool}, &[]pure uint8, int): &{int, []pure uint8, bool}
 mov dword[rsp+24],r8d
 mov qword[rsp+16],rdx
 mov qword[rsp+8],rcx
 push rbp
 push rbx
 sub rsp,8
 mov rbp,rsp
 sub rsp,48
;prolog end

 xor r10d,r10d
 mov dword[rbp-4],r10d
;ir_load L0 0;

 xor r10,r10
 mov qword[rbp-16],r10
;ir_load L1 0;

 xor r10d,r10d
 mov dword[rbp-32],r10d
;ir_load [L2 . 0] 0;

 mov rax,qword[rbp+40]
;ir_deref A1; (push)

 mov r10,qword[rax+8]
 mov qword[rbp-24],r10
;ir_load [L2 . 1] [POP() . 1];

 mov r10d,dword[rbp-32]
 mov dword[rbp-36],r10d
;ir_load L3 [L2 . 0];

cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f72$cond:
;ir_make_label cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f72$cond;

 movsxd rax,dword[rbp-36]
;ir_cast L3; (push)

 cmp rax,qword[rbp-24]
 jge cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f72$end
;ir_jmp_gte POP() [L2 . 1] cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f72$end;

cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f72$body:
;ir_make_label cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f72$body;

 xor r10b,r10b
 cmp r10b,0
 je cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if69$else
;ir_jmp_eq 0 0 cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if69$else;

cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if69$body:
;ir_make_label cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if69$body;

 mov r10d,dword[rbp-4]
 imul r10d,dword[rbp+48]
 mov ebx,r10d
;ir_mul L0 A2; (push)

 mov rax,qword[rbp+40]
;ir_deref A1; (push)

 mov rax,qword[rax+0]
;ir_deref [POP() . 0]; (push)

 movsxd r10,dword[rbp-36]
 lea rax,byte[rax+0+r10*1]
;ir_index POP() L3; (push)

 mov r10b,byte[rax]
 sub r10b,48
 mov al,r10b
;ir_sub POP() #48; (push)

 movsx eax,al
;ir_cast POP(); (push)

 add ebx,eax
 mov eax,ebx
;ir_add POP() POP(); (push)

 mov dword[rbp-4],eax
;ir_load L0 POP();

 mov r10,qword[rbp-16]
 add r10,1
 mov rax,r10
;ir_add L1 1; (push)

 mov qword[rbp-16],rax
;ir_load L1 POP();

 jmp cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if69$end
;ir_jmp cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if69$end;

cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if69$else:
;ir_make_label cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if69$else;

 jmp cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f72$end
;ir_jmp cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f72$end;

cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if69$end:
;ir_make_label cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$if69$end;

 mov r10d,dword[rbp-36]
 add r10d,1
 mov eax,r10d
;ir_add L3 1; (push)

 mov dword[rbp-36],eax
;ir_load L3 POP();

 jmp cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f72$cond
;ir_jmp cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f72$cond;

cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f72$end:
;ir_make_label cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$f72$end;

 mov r10,qword[rbp+32]
 mov qword[rbp-48],r10
;ir_load L4 A0;

 mov rax,qword[rbp-48]
;ir_deref L4; (push)

 mov r10d,dword[rbp-4]
 mov dword[rax+0],r10d
;ir_load [POP() . 0] L0;

 mov rax,qword[rbp-48]
;ir_deref L4; (push)

 xor r10,r10
 mov [rax+16],r10
 mov [rax+24],r10
;ir_store [POP() . 1] 0 0 16;

 mov rbx,qword[rbp-48]
;ir_deref L4; (push)

 mov r10,qword[rbp-16]
 cmp r10,0
 setg al
;ir_cmp_gt L1 0; (push)

 mov byte[rbx+32],al
;ir_load [POP() . 2] POP();

 mov rax,qword[rbp+32]
;ir_return A0;

cb__Nroot__NparseIntRem__Aptr__Ttuple__Tint__Tslice__Tpure__Tuint8__Tbool__Aptr__Tslice__Tpure__Tuint8__Aint$end:
 add rsp,56
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
 mov [rbp-16],r10
 mov [rbp-8],r10
;ir_store L0 0 0 16;

 lea rax,qword[rbp-8]
;ir_load_addr [L0 . 1]; (push)

 mov qword[rbp-24],rax
;ir_load L1 POP();

 xor eax,eax
;ir_return 0;

carbon_main$end:
 add rsp,32
 pop rbp
 ret


