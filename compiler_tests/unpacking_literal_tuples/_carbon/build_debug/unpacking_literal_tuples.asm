global cb__Nmain__Nget_values__Aptr__Ttuple__Tslice__Tpure__Tuint8__Tint
export cb__Nmain__Nget_values__Aptr__Ttuple__Tslice__Tpure__Tuint8__Tint
global carbon_main
export carbon_main
section .data
$cbstr0: db 78,105,99,101,0
$cbstr1: db 72,101,108,108,111,0
section .code
cb__Nmain__Nget_values__Aptr__Ttuple__Tslice__Tpure__Tuint8__Tint:
 ;func get_values(&{[]pure uint8, int}): &{[]pure uint8, int}
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,8
 ;prolog end

 mov rax,rcx
 ;ir_deref A0; (push)

 lea rbx,qword [rax+0]
 ;ir_load_addr [POP() . 0]; (push)

 lea rax,[$cbstr0]
 ;ir_load_addr STR0; (push)

 mov qword [rbx+0],rax
 ;ir_load [POP() . 0] POP();

 mov rax,rcx
 ;ir_deref A0; (push)

 lea rax,qword [rax+0]
 ;ir_load_addr [POP() . 0]; (push)

 mov r10d,4
 mov qword [rax+8],r10
 ;ir_load [POP() . 1] 4;

 mov rax,rcx
 ;ir_deref A0; (push)

 mov r10d,2
 mov dword [rax+16],r10d
 ;ir_load [POP() . 1] 2;

 mov rax,rcx
 ;ir_return A0;

cb__Nmain__Nget_values__Aptr__Ttuple__Tslice__Tpure__Tuint8__Tint$end:
 add rsp,8
 pop rbx
 pop rbp
 ret


carbon_main:
 ;func carbon_main(): int
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 lea rax,[$cbstr1]
 ;ir_load_addr STR1; (push)

 mov qword [rbp-16],rax
 ;ir_load [L0 . 0] POP();

 mov r10d,5
 mov qword [rbp-8],r10
 ;ir_load [L0 . 1] 5;

 mov r10,qword [rbp-8]
 mov qword [rbp-24],r10
 ;ir_load L1 [L0 . 1];

 mov r10,qword [rbp-24]
 mov eax,r10d
 ;ir_cast L1; (push)

 ;ir_return POP();

carbon_main$end:
 add rsp,32
 pop rbp
 ret


