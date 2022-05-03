global carbon_main
export carbon_main
section .data
$cmp16selector: db 
$cmp16selector: db 0x0,0x1,0x8,0x9,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80
section .rodata
section .code
carbon_main:
;func carbon_main(): int
 push rbp
 mov rbp,rsp
 sub rsp,48
;prolog end

 xor r10d,r10d
 mov qword[rbp-16],r10
;ir_load [L0 . 0] 0;

 xor r10b,r10b
 mov byte[rbp-8],r10b
;ir_load [L0 . 1] 0;

 xor r10d,r10d
 mov qword[rbp-32],r10
;ir_load [L1 . 0] 0;

 mov r10b,1
 mov byte[rbp-24],r10b
;ir_load [L1 . 1] 1;

 movdqa xmm0,[rbp-16]
 psadbw xmm0,[rbp-32]
 pshufb xmm0,[$cmp16selector]
 movq r10,xmm0
 cmp r10d,0
 sete al
;ir_cmp_eq L0 L1; (push)

 mov byte[rbp-33],al
;ir_load L2 POP();

 xor eax,eax
;ir_return 0;

carbon_main$end:
 add rsp,48
 pop rbp
 ret


