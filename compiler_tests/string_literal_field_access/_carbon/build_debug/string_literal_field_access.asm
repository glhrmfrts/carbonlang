global carbon_main
export carbon_main
section .data
$cbstr0: db 72,101,108,108,111,32,87,111,114,108,100,32,49,0
$cbstr1: db 72,101,108,108,111,32,87,111,114,108,100,32,50,0
section .code
carbon_main:
 ;func carbon_main(): int
 push rbp
 mov rbp,rsp
 sub rsp,48
 ;prolog end

 lea rax,[$cbstr0]
 ;ir_load_addr STR0; (push)

 mov qword [rbp-16],rax
 ;ir_load [L0 . 0] POP();

 mov r10d,13
 mov qword [rbp-8],r10
 ;ir_load [L0 . 1] 13;

 mov r10,qword [rbp-16]
 mov qword [rbp-24],r10
 ;ir_load L1 [L0 . 0];

 lea rax,[$cbstr1]
 ;ir_load_addr STR1; (push)

 mov qword [rbp-40],rax
 ;ir_load [L2 . 0] POP();

 mov r10d,13
 mov qword [rbp-32],r10
 ;ir_load [L2 . 1] 13;

 mov r10,qword [rbp-32]
 mov qword [rbp-48],r10
 ;ir_load L3 [L2 . 1];

 mov r10,qword [rbp-48]
 mov eax,r10d
 ;ir_cast L3; (push)

 ;ir_return POP();

carbon_main$end:
 add rsp,48
 pop rbp
 ret


