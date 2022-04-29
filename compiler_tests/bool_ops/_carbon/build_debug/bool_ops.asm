global carbon_main
export carbon_main
section .data
section .rodata
section .code
carbon_main:
;func carbon_main(): int
 push rbp
 mov rbp,rsp
 sub rsp,16
;prolog end

 mov r10d,3
 cmp r10d,2
 setl al
;ir_cmp_lt 3 2; (push)

 mov byte[rbp-1],al
;ir_load L0 POP();

 mov r10d,3
 cmp r10d,5
 setg al
;ir_cmp_gt 3 5; (push)

 mov byte[rbp-2],al
;ir_load L1 POP();

 mov r10d,3
 cmp r10d,5
 setge al
;ir_cmp_gteq 3 5; (push)

 mov byte[rbp-3],al
;ir_load L2 POP();

 mov r10d,3
 cmp r10d,5
 setle al
;ir_cmp_lteq 3 5; (push)

 mov byte[rbp-1],al
;ir_load L0 POP();

 mov r10d,3
 cmp r10d,5
 sete al
;ir_cmp_eq 3 5; (push)

 mov byte[rbp-1],al
;ir_load L0 POP();

 mov r10d,8
 cmp r10d,10
 setne al
;ir_cmp_neq 8 10; (push)

 mov byte[rbp-1],al
;ir_load L0 POP();

 xor eax,eax
;ir_return 0;

carbon_main$end:
 add rsp,16
 pop rbp
 ret


