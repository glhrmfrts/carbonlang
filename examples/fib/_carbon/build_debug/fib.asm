global cb__Nmain__Nmakedata1__Aptr__TU_data1
global cb__Nmain__Nmakedata2__Aptr__TU_data1__Aptr__TU_data1
global myentrypoint
section .data
extern main__default_allocator
section .code
cb__Nmain__Nmakedata1__Aptr__TU_data1:
 ;func makedata1(&data1): &data1
 push rbp
 mov rbp,rsp
 ;prolog end

 mov rax,rcx
 ;ir_deref A0;

 mov r10d,0
 mov qword [rax+0],r10
 ;ir_load [ST . 0] 0;

 mov rax,rcx
 ;ir_deref A0;

 mov r10d,0
 mov qword [rax+8],r10
 ;ir_load [ST . 1] 0;

 mov rax,rcx
 ;ir_return A0;

cb__Nmain__Nmakedata1__Aptr__TU_data1$end:
 pop rbp
 ret


cb__Nmain__Nmakedata2__Aptr__TU_data1__Aptr__TU_data1:
 ;func makedata2(&data1, &data1): &data1
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,8
 ;prolog end

 mov rbx,rcx
 ;ir_deref A0;

 mov rax,rdx
 ;ir_deref A1;

 mov r10,qword [rax+0]
 add r10,2
 mov rax,r10
 ;ir_add [ST . 0] 2;

 mov qword [rbx+0],rax
 ;ir_load [ST . 0] ST;

 mov rbx,rcx
 ;ir_deref A0;

 mov rax,rdx
 ;ir_deref A1;

 mov r10,qword [rax+8]
 add r10,2
 mov rax,r10
 ;ir_add [ST . 1] 2;

 mov qword [rbx+8],rax
 ;ir_load [ST . 1] ST;

 mov rax,rcx
 ;ir_return A0;

cb__Nmain__Nmakedata2__Aptr__TU_data1__Aptr__TU_data1$end:
 add rsp,8
 pop rbx
 pop rbp
 ret


myentrypoint:
 ;func myentrypoint(): int
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,56
 ;prolog end

 call cb__Nmain__Nmakedata1__Aptr__TU_data1
 ;ir_call cb__Nmain__Nmakedata1__Aptr__TU_data1;

 mov qword [rbp-24],rax
 ;ir_load L1 ST;

 lea rbx,qword [rbp-16]
 ;ir_load_addr L0;

 lea rax,qword [rbp-24]
 ;ir_load_addr L1;

 mov rdx,rax
 mov rcx,rbx
 call cb__Nmain__Nmakedata2__Aptr__TU_data1__Aptr__TU_data1
 mov rbx,rax
 ;ir_call cb__Nmain__Nmakedata2__Aptr__TU_data1__Aptr__TU_data1 ST ST;

 mov eax,0
 ;ir_return 0;

myentrypoint$end:
 add rsp,56
 pop rbx
 pop rbp
 ret


