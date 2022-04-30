global carbon_main
export carbon_main
section .data
section .rodata
section .code
carbon_main:
;func carbon_main(): int
 push rbp
 mov rbp,rsp
 sub rsp,160
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

 xor r10d,r10d
 mov qword[rbp-152],r10
;ir_load [L3 . 0] 0;

 xor r10d,r10d
 mov qword[rbp-144],r10
;ir_load [L3 . 1] 0;

 xor r10d,r10d
 mov dword[rbp-136],r10d
;ir_load [L3 . 2] 0;

 xor r10d,r10d
 mov dword[rbp-132],r10d
;ir_load [L3 . 3] 0;

 xor r10d,r10d
 mov dword[rbp-128],r10d
;ir_load [L3 . 4] 0;

 xor r10d,r10d
 mov dword[rbp-124],r10d
;ir_load [L3 . 5] 0;

 xor r10d,r10d
 mov qword[rbp-120],r10
;ir_load [L3 . 6] 0;

 xor r10d,r10d
 mov qword[rbp-112],r10
;ir_load [L3 . 7] 0;

 xor r10d,r10d
 mov qword[rbp-104],r10
;ir_load [L3 . 8] 0;

 xor r10d,r10d
 mov dword[rbp-96],r10d
;ir_load [L3 . 9] 0;

 xor r10d,r10d
 mov dword[rbp-92],r10d
;ir_load [L3 . 10] 0;

 xor r10d,r10d
 mov qword[rbp-88],r10
;ir_load [L3 . 11] 0;

 xor r10d,r10d
 mov qword[rbp-80],r10
;ir_load [L3 . 12] 0;

 xor r10d,r10d
 mov qword[rbp-72],r10
;ir_load [L3 . 13] 0;

 xor r10d,r10d
 mov qword[rbp-64],r10
;ir_load [L3 . 14] 0;

 xor r10d,r10d
 mov qword[rbp-56],r10
;ir_load [L3 . 15] 0;

 xor r10d,r10d
 mov qword[rbp-48],r10
;ir_load [L3 . 16] 0;

 xor r10d,r10d
 mov qword[rbp-40],r10
;ir_load [L3 . 17] 0;

 xor r10d,r10d
 mov dword[rbp-32],r10d
;ir_load [L3 . 18] 0;

 xor r10d,r10d
 mov dword[rbp-28],r10d
;ir_load [L3 . 19] 0;

 mov r10,qword[rbp-16]
 add r10,qword[rbp-40]
 mov rax,r10
;ir_add L1 [L3 . 17]; (push)

 mov qword[rbp-160],rax
;ir_load L4 POP();

 xor eax,eax
;ir_return 0;

carbon_main$end:
 add rsp,160
 pop rbp
 ret


