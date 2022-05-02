global carbon_main
export carbon_main
section .data
section .rodata
$cbstr0: db 72,101,108,108,111,32,119,111,114,108,100,0
section .code
carbon_main:
;func carbon_main(): int
 push rbp
 mov rbp,rsp
 sub rsp,176
;prolog end

 lea rax,[$cbstr0]
;ir_load_addr STR0; (push)

 mov qword[rbp-16],rax
;ir_load [L0 . 0] POP();

 mov r10d,11
 mov qword[rbp-8],r10
;ir_load [L0 . 1] 11;

 mov rax,qword[rbp-16]
;ir_deref [L0 . 0]; (push)

 mov r10,2
 lea rax,byte[rax+0+r10*1]
;ir_index POP() 2; (push)

 lea rax,byte[rax]
;ir_load_addr POP(); (push)

 mov qword[rbp-32],rax
;ir_load [L1 . 0] POP();

 mov r10d,5
 sub r10d,2
 mov eax,r10d
;ir_sub 5 2; (push)

 movsxd rax,eax
;ir_cast POP(); (push)

 mov qword[rbp-24],rax
;ir_load [L1 . 1] POP();

 xor r10d,r10d
 mov qword[rbp-160],r10
;ir_load [L2 . 0] 0;

 xor r10d,r10d
 mov qword[rbp-152],r10
;ir_load [L2 . 1] 0;

 xor r10d,r10d
 mov dword[rbp-144],r10d
;ir_load [L2 . 2] 0;

 xor r10d,r10d
 mov dword[rbp-140],r10d
;ir_load [L2 . 3] 0;

 xor r10d,r10d
 mov dword[rbp-136],r10d
;ir_load [L2 . 4] 0;

 xor r10d,r10d
 mov dword[rbp-132],r10d
;ir_load [L2 . 5] 0;

 xor r10d,r10d
 mov qword[rbp-128],r10
;ir_load [L2 . 6] 0;

 xor r10d,r10d
 mov qword[rbp-120],r10
;ir_load [L2 . 7] 0;

 xor r10d,r10d
 mov qword[rbp-112],r10
;ir_load [L2 . 8] 0;

 xor r10d,r10d
 mov dword[rbp-104],r10d
;ir_load [L2 . 9] 0;

 xor r10d,r10d
 mov dword[rbp-100],r10d
;ir_load [L2 . 10] 0;

 xor r10d,r10d
 mov qword[rbp-96],r10
;ir_load [L2 . 11] 0;

 xor r10d,r10d
 mov qword[rbp-88],r10
;ir_load [L2 . 12] 0;

 xor r10d,r10d
 mov qword[rbp-80],r10
;ir_load [L2 . 13] 0;

 xor r10d,r10d
 mov qword[rbp-72],r10
;ir_load [L2 . 14] 0;

 xor r10d,r10d
 mov qword[rbp-64],r10
;ir_load [L2 . 15] 0;

 xor r10d,r10d
 mov qword[rbp-56],r10
;ir_load [L2 . 16] 0;

 xor r10d,r10d
 mov qword[rbp-48],r10
;ir_load [L2 . 17] 0;

 xor r10d,r10d
 mov dword[rbp-40],r10d
;ir_load [L2 . 18] 0;

 xor r10d,r10d
 mov dword[rbp-36],r10d
;ir_load [L2 . 19] 0;

 mov r10,qword[rbp-88]
 mov qword[rbp-168],r10
;ir_load L3 [L2 . 12];

 xor eax,eax
;ir_return 0;

carbon_main$end:
 add rsp,176
 pop rbp
 ret


