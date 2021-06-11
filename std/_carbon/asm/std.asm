global cb$Nstd$Nio$Nprintln$AB$Araw_string
extern puts
extern putc
extern exit
extern free
extern malloc
extern rand
extern system
extern strlen
global cb$Nstd$Nmemory$Nalloc$AB$Ausize
global cb$Nstd$Nmemory$Ndealloc$AB$Araw_ptr
global cb$Nstd$Nmemory$Ncopy$AB$Araw_ptr$Araw_ptr$Ausize
global cb$Nstd$Nmemory$Nset$AB$Araw_ptr$Achar$Ausize
global cb$Nstd$Nrawstring$Ncopy$AB$Araw_string
global cb$Nstd$Nrawstring$Ncopy$AB$Araw_string$Ausize
global cb$Nstd$Nrawstring$Ncopy$AB$Araw_string$Araw_string$Ausize
global cb$Nstd$Nrawstring$Nset$AB$Araw_string$Achar$Ausize
global cb$Nstd$Nrawstring$Nlen$AB$Araw_string
global cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string
global cb$Nstd$Ntests1$Nprint_the_char$AB$Achar$Aptr$$char$$
global cb$Nstd$Ntests1$Nlongfunc$AB$Aint$Aint$Aint$Aint$Aint$Aint$Aint$Aint
global cb$Nstd$Ntests1$Ntest_longfunc$AB
global cb$Nstd$Ntests1$Ntest_strcopy_len$AB
global cb$Nstd$Ntests1$Ntest_strcopy$AB
global cb$Nstd$Ntests1$Ntest_strcopy_saving$AB
global cb$Nstd$Ntests1$Ntest_while_statement$AB
global cb$Nstd$Ntests1$Ntest_short$AB
global cb$Nstd$Ntests1$Ntest_for_stmt$AB
global cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB
global cb$Nstd$Ntests1$Ntest_tuple_init$AB
global cb$Nstd$Ntests1$Ntest_array_zeroinit$AB
global cb$Nstd$Ntests1$Ntest_array_init$AB
global cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB
global cb$Nstd$Ntests1$Nsum_tuple$AB$Aref$$tuple$$int$int$int$$$$
global cb$Nstd$Ntests1$Ntest_tuple_argument$AB
global cb$Nstd$Ntests1$Ndo_stuff$AB$Aref$$tuple$$raw_string$bool$$$$
global cb$Nstd$Ntests1$Ntest_tuple_return_value$AB
global cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB
global cb$Nstd$Ntests1$Nsum_array$AB$Aref$$array$$int$$$$
global cb$Nstd$Ntests1$Ntest_array_argument$AB
global cb$Nstd$Ntests1$Nget_array_data$AB$Aref$$array$$int$$$$
global cb$Nstd$Ntests1$Ntest_array_return_value$AB
global cb$Nstd$Ntests1$Ntest_slice$AB
global cb$Nstd$Ntests1$Ntest_mutable_slice$AB
global cb$Nstd$Ntests1$Nget_result$AB
global main
section .data
$cbstr0: db 91,79,75,93,32,116,101,115,116,95,108,111,110,103,102,117,110,99,0
$cbstr1: db 91,78,79,75,93,32,116,101,115,116,95,108,111,110,103,102,117,110,99,0
$cbstr2: db 104,101,108,108,111,0
$cbstr3: db 91,79,75,93,32,116,101,115,116,95,115,116,114,99,111,112,121,95,108,101,110,0
$cbstr4: db 91,78,79,75,93,32,116,101,115,116,95,115,116,114,99,111,112,121,95,108,101,110,0
$cbstr5: db 91,79,75,93,32,116,101,115,116,95,115,116,114,99,111,112,121,0
$cbstr6: db 91,78,79,75,93,32,116,101,115,116,95,115,116,114,99,111,112,121,0
$cbstr7: db 91,79,75,93,32,116,101,115,116,95,115,116,114,99,111,112,121,95,115,97,118,105,110,103,0
$cbstr8: db 91,78,79,75,93,32,116,101,115,116,95,115,116,114,99,111,112,121,95,115,97,118,105,110,103,0
$cbstr9: db 97,115,100,97,115,100,0
$cbstr10: db 71,71,71,71,71,0
$cbstr11: db 102,111,111,98,97,114,0
$cbstr12: db 91,79,75,93,32,116,101,115,116,95,119,104,105,108,101,95,115,116,97,116,101,109,101,110,116,0
$cbstr13: db 91,78,79,75,93,32,116,101,115,116,95,119,104,105,108,101,95,115,116,97,116,101,109,101,110,116,0
$cbstr14: db 83,72,79,85,76,68,32,78,79,84,32,80,82,73,78,84,32,84,72,73,83,0
$cbstr15: db 104,101,108,108,111,119,111,114,108,100,0
$cbstr16: db 48,49,50,51,52,53,54,55,56,57,0
$cbstr17: db 91,79,75,93,32,116,101,115,116,95,102,111,114,95,115,116,109,116,0
$cbstr18: db 91,78,79,75,93,32,116,101,115,116,95,102,111,114,95,115,116,109,116,0
$cbstr19: db 0
$cbstr20: db 91,79,75,93,32,116,101,115,116,95,116,117,112,108,101,95,122,101,114,111,105,110,105,116,0
$cbstr21: db 91,78,79,75,93,32,116,101,115,116,95,116,117,112,108,101,95,122,101,114,111,105,110,105,116,0
$cbstr22: db 110,105,99,101,0
$cbstr23: db 115,101,99,111,110,100,0
$cbstr24: db 91,79,75,93,32,116,101,115,116,95,116,117,112,108,101,95,105,110,105,116,0
$cbstr25: db 91,78,79,75,93,32,116,101,115,116,95,116,117,112,108,101,95,105,110,105,116,0
$cbstr26: db 91,79,75,93,32,116,101,115,116,95,97,114,114,97,121,95,122,101,114,111,105,110,105,116,0
$cbstr27: db 91,78,79,75,93,32,116,101,115,116,95,97,114,114,97,121,95,122,101,114,111,105,110,105,116,0
$cbstr28: db 91,79,75,93,32,116,101,115,116,95,97,114,114,97,121,95,105,110,105,116,0
$cbstr29: db 91,78,79,75,93,32,116,101,115,116,95,97,114,114,97,121,95,105,110,105,116,0
$cbstr30: db 91,79,75,93,32,116,101,115,116,95,116,117,112,108,101,95,97,115,115,105,103,110,109,101,110,116,95,108,118,97,108,117,101,0
$cbstr31: db 91,78,79,75,93,32,116,101,115,116,95,116,117,112,108,101,95,97,115,115,105,103,110,109,101,110,116,95,108,118,97,108,117,101,0
$cbstr32: db 91,79,75,93,32,116,101,115,116,95,116,117,112,108,101,95,97,114,103,117,109,101,110,116,0
$cbstr33: db 91,78,79,75,93,32,116,101,115,116,95,116,117,112,108,101,95,97,114,103,117,109,101,110,116,0
$cbstr34: db 115,111,109,101,95,115,116,97,116,117,115,0
$cbstr35: db 91,79,75,93,32,116,101,115,116,95,116,117,112,108,101,95,114,101,116,117,114,110,95,118,97,108,117,101,0
$cbstr36: db 91,78,79,75,93,32,116,101,115,116,95,116,117,112,108,101,95,114,101,116,117,114,110,95,118,97,108,117,101,0
$cbstr37: db 91,79,75,93,32,116,101,115,116,95,97,114,114,97,121,95,97,115,115,105,103,110,109,101,110,116,95,108,118,97,108,117,101,0
$cbstr38: db 91,78,79,75,93,32,116,101,115,116,95,97,114,114,97,121,95,97,115,115,105,103,110,109,101,110,116,95,108,118,97,108,117,101,0
$cbstr39: db 91,79,75,93,32,116,101,115,116,95,97,114,114,97,121,95,97,114,103,117,109,101,110,116,0
$cbstr40: db 91,78,79,75,93,32,116,101,115,116,95,97,114,114,97,121,95,97,114,103,117,109,101,110,116,0
$cbstr41: db 91,79,75,93,32,116,101,115,116,95,97,114,114,97,121,95,114,101,116,117,114,110,95,118,97,108,117,101,0
$cbstr42: db 91,78,79,75,93,32,116,101,115,116,95,97,114,114,97,121,95,114,101,116,117,114,110,95,118,97,108,117,101,0
$cbstr43: db 91,79,75,93,32,116,101,115,116,95,115,108,105,99,101,0
$cbstr44: db 91,78,79,75,93,32,116,101,115,116,95,115,108,105,99,101,0
$cbstr45: db 91,79,75,93,32,116,101,115,116,95,109,117,116,97,98,108,101,95,115,108,105,99,101,0
$cbstr46: db 91,78,79,75,93,32,116,101,115,116,95,109,117,116,97,98,108,101,95,115,108,105,99,101,0
$cbstr47: db 97,115,100,97,115,100,97,115,100,97,115,100,0
$cbstr48: db 97,115,100,97,115,100,48,48,48,48,48,48,48,48,48,0
$cbstr49: db 0,0,10,0
section .code
cb$Nstd$Nio$Nprintln$AB$Araw_string:
 ;func println(raw_string): {}
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov rcx,qword [rbp+16]
 call puts
 ;ir_call puts A0;

cb$Nstd$Nio$Nprintln$AB$Araw_string$end:
 add rsp,32
 pop rbp
 ret


cb$Nstd$Nmemory$Nalloc$AB$Ausize:
 ;func alloc(usize): raw_ptr
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov rcx,qword [rbp+16]
 call malloc
 ;ir_call malloc A0;

 ;ir_return ST;

cb$Nstd$Nmemory$Nalloc$AB$Ausize$end:
 add rsp,32
 pop rbp
 ret


cb$Nstd$Nmemory$Ndealloc$AB$Araw_ptr:
 ;func dealloc(raw_ptr): {}
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov rcx,qword [rbp+16]
 call free
 ;ir_call free A0;

cb$Nstd$Nmemory$Ndealloc$AB$Araw_ptr$end:
 add rsp,32
 pop rbp
 ret


cb$Nstd$Nmemory$Ncopy$AB$Araw_ptr$Araw_ptr$Ausize:
 ;func copy(raw_ptr, raw_ptr, usize): {}
 push rbp
 mov rbp,rsp
 ;prolog end

push rdi
push rsi

mov rdi,rcx
mov rsi,rdx
mov rcx,r8
rep movsb

pop rsi
pop rdi
    
cb$Nstd$Nmemory$Ncopy$AB$Araw_ptr$Araw_ptr$Ausize$end:
 pop rbp
 ret


cb$Nstd$Nmemory$Nset$AB$Araw_ptr$Achar$Ausize:
 ;func set(raw_ptr, char, usize): {}
 push rbp
 mov rbp,rsp
 ;prolog end

push rdi

mov rdi,rcx
mov rax,rdx
mov rcx,r8
rep stosb

pop rdi
    
cb$Nstd$Nmemory$Nset$AB$Araw_ptr$Achar$Ausize$end:
 pop rbp
 ret


cb$Nstd$Nrawstring$Ncopy$AB$Araw_string:
 ;func copy(raw_string): raw_string
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,16
 ;prolog end

 mov rcx,qword [rbp+16]
 call cb$Nstd$Nrawstring$Nlen$AB$Araw_string
 ;ir_call cb$Nstd$Nrawstring$Nlen$AB$Araw_string A0;

 mov rdx,rax
 mov rcx,qword [rbp+16]
 call cb$Nstd$Nrawstring$Ncopy$AB$Araw_string$Ausize
 ;ir_call cb$Nstd$Nrawstring$Ncopy$AB$Araw_string$Ausize A0 ST;

 ;ir_return ST;

cb$Nstd$Nrawstring$Ncopy$AB$Araw_string$end:
 add rsp,16
 pop rbp
 ret


cb$Nstd$Nrawstring$Ncopy$AB$Araw_string$Ausize:
 ;func copy(raw_string, usize): raw_string
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,48
 ;prolog end

 mov r10,qword [rbp+24]
 add r10,1
 mov rax,r10
 ;ir_add A1 1;

 mov rcx,rax
 call cb$Nstd$Nmemory$Nalloc$AB$Ausize
 ;ir_call cb$Nstd$Nmemory$Nalloc$AB$Ausize ST;

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 mov r8,qword [rbp+24]
 mov rdx,qword [rbp+16]
 mov rcx,qword [rbp-8]
 call cb$Nstd$Nrawstring$Ncopy$AB$Araw_string$Araw_string$Ausize
 ;ir_call cb$Nstd$Nrawstring$Ncopy$AB$Araw_string$Araw_string$Ausize L0 A0 A1;

 mov rax,qword [rbp-8]
 ;ir_deref L0;

 mov r10,qword [rbp+24]
 lea rax,byte [rax+r10*1]
 ;ir_index ST A1;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov rax,qword [rbp-8]
 ;ir_return L0;

cb$Nstd$Nrawstring$Ncopy$AB$Araw_string$Ausize$end:
 add rsp,48
 pop rbp
 ret


cb$Nstd$Nrawstring$Ncopy$AB$Araw_string$Araw_string$Ausize:
 ;func copy(raw_string, raw_string, usize): {}
 mov qword [rsp+24],r8
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov r8,qword [rbp+32]
 mov rdx,qword [rbp+24]
 mov rcx,qword [rbp+16]
 call cb$Nstd$Nmemory$Ncopy$AB$Araw_ptr$Araw_ptr$Ausize
 ;ir_call cb$Nstd$Nmemory$Ncopy$AB$Araw_ptr$Araw_ptr$Ausize A0 A1 A2;

cb$Nstd$Nrawstring$Ncopy$AB$Araw_string$Araw_string$Ausize$end:
 add rsp,32
 pop rbp
 ret


cb$Nstd$Nrawstring$Nset$AB$Araw_string$Achar$Ausize:
 ;func set(raw_string, char, usize): {}
 mov qword [rsp+24],r8
 mov byte [rsp+16],dl
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov r8,qword [rbp+32]
 mov dl,byte [rbp+24]
 mov rcx,qword [rbp+16]
 call cb$Nstd$Nmemory$Nset$AB$Araw_ptr$Achar$Ausize
 ;ir_call cb$Nstd$Nmemory$Nset$AB$Araw_ptr$Achar$Ausize A0 A1 A2;

cb$Nstd$Nrawstring$Nset$AB$Araw_string$Achar$Ausize$end:
 add rsp,32
 pop rbp
 ret


cb$Nstd$Nrawstring$Nlen$AB$Araw_string:
 ;func len(raw_string): usize
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov rcx,qword [rbp+16]
 call strlen
 ;ir_call strlen A0;

 ;ir_return ST;

cb$Nstd$Nrawstring$Nlen$AB$Araw_string$end:
 add rsp,32
 pop rbp
 ret


cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string:
 ;func equals(raw_string, raw_string): bool
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,56
 ;prolog end

 mov rcx,qword [rbp+24]
 call cb$Nstd$Nrawstring$Nlen$AB$Araw_string
 mov rbx,rax
 ;ir_call cb$Nstd$Nrawstring$Nlen$AB$Araw_string A0;

 mov rcx,qword [rbp+32]
 call cb$Nstd$Nrawstring$Nlen$AB$Araw_string
 ;ir_call cb$Nstd$Nrawstring$Nlen$AB$Araw_string A1;

 cmp rbx,rax
 je cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$if337$else
 ;ir_jmp_eq ST ST cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$if337$else;

cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$if337$body:
 ;ir_make_label cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$if337$body;

 mov al,0
 jmp cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$end
 ;ir_return 0;

cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$if337$else:
 ;ir_make_label cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$if337$else;

 mov r10d,0
 mov dword [rbp-16],r10d
 ;ir_load [L0 . 0] 0;

 mov rcx,qword [rbp+24]
 call cb$Nstd$Nrawstring$Nlen$AB$Araw_string
 ;ir_call cb$Nstd$Nrawstring$Nlen$AB$Araw_string A0;

 mov qword [rbp-12],rax
 ;ir_load [L0 . 1] ST;

 mov r10d,dword [rbp-16]
 mov dword [rbp-24],r10d
 ;ir_load L2 [L0 . 0];

cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$f361$cond:
 ;ir_make_label cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$f361$cond;

 movsxd rax,dword [rbp-24]
 ;ir_cast L2;

 cmp rax,qword [rbp-12]
 jge cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$f361$end
 ;ir_jmp_gte ST [L0 . 1] cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$f361$end;

cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$f361$body:
 ;ir_make_label cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$f361$body;

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 movsxd r10,dword [rbp-24]
 lea rbx,byte [rax+r10*1]
 ;ir_index ST L2;

 mov rax,qword [rbp+32]
 ;ir_deref A1;

 movsxd r10,dword [rbp-24]
 lea rax,byte [rax+r10*1]
 ;ir_index ST L2;

 mov r10b,byte [rbx+0]
 cmp r10b,byte [rax+0]
 je cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$if358$else
 ;ir_jmp_eq ST ST cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$if358$else;

cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$if358$body:
 ;ir_make_label cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$if358$body;

 mov al,0
 jmp cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$end
 ;ir_return 0;

cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$if358$else:
 ;ir_make_label cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$if358$else;

 mov r10d,dword [rbp-24]
 add r10d,1
 mov eax,r10d
 ;ir_add L2 1;

 mov dword [rbp-24],eax
 ;ir_load L2 ST;

 jmp cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$f361$cond
 ;ir_jmp cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$f361$cond;

cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$f361$end:
 ;ir_make_label cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$f361$end;

 mov al,1
 ;ir_return 1;

cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string$end:
 add rsp,56
 pop rbx
 pop rbp
 ret


cb$Nstd$Ntests1$Nprint_the_char$AB$Achar$Aptr$$char$$:
 ;func print_the_char(char, *char): {}
 mov qword [rsp+16],rdx
 mov byte [rsp+8],cl
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 lea rax,byte [rbp+16]
 ;ir_load_addr A0;

 mov rcx,rax
 call puts
 ;ir_call puts ST;

cb$Nstd$Ntests1$Nprint_the_char$AB$Achar$Aptr$$char$$$end:
 add rsp,32
 pop rbp
 ret


cb$Nstd$Ntests1$Nlongfunc$AB$Aint$Aint$Aint$Aint$Aint$Aint$Aint$Aint:
 ;func longfunc(int, int, int, int, int, int, int, int): int
 push rbp
 mov rbp,rsp
 ;prolog end

 add ecx,edx
 mov eax,ecx
 ;ir_add A0 A1;

 add eax,r8d
 ;ir_add ST A2;

 add eax,r9d
 ;ir_add ST A3;

 add eax,dword [rbp+48]
 ;ir_add ST A4;

 add eax,dword [rbp+56]
 ;ir_add ST A5;

 add eax,dword [rbp+64]
 ;ir_add ST A6;

 add eax,dword [rbp+72]
 ;ir_add ST A7;

 ;ir_return ST;

cb$Nstd$Ntests1$Nlongfunc$AB$Aint$Aint$Aint$Aint$Aint$Aint$Aint$Aint$end:
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_longfunc$AB:
 ;func test_longfunc(): {}
 push rbp
 mov rbp,rsp
 sub rsp,80
 ;prolog end

 mov dword [rsp+56],8
 mov dword [rsp+48],7
 mov dword [rsp+40],6
 mov dword [rsp+32],5
 mov r9d,4
 mov r8d,3
 mov edx,2
 mov ecx,1
 call cb$Nstd$Ntests1$Nlongfunc$AB$Aint$Aint$Aint$Aint$Aint$Aint$Aint$Aint
 ;ir_call cb$Nstd$Ntests1$Nlongfunc$AB$Aint$Aint$Aint$Aint$Aint$Aint$Aint$Aint 1 2 3 4 5 6 7 8;

 mov dword [rbp-4],eax
 ;ir_load L0 ST;

 mov r10d,dword [rbp-4]
 cmp r10d,36
 jne cb$Nstd$Ntests1$Ntest_longfunc$AB$if494$else
 ;ir_jmp_neq L0 36 cb$Nstd$Ntests1$Ntest_longfunc$AB$if494$else;

cb$Nstd$Ntests1$Ntest_longfunc$AB$if494$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_longfunc$AB$if494$body;

 lea rax,[$cbstr0]
 ;ir_load_addr STR0;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_longfunc$AB$if494$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_longfunc$AB$if494$end;

cb$Nstd$Ntests1$Ntest_longfunc$AB$if494$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_longfunc$AB$if494$else;

 lea rax,[$cbstr1]
 ;ir_load_addr STR1;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_longfunc$AB$if494$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_longfunc$AB$if494$end;

cb$Nstd$Ntests1$Ntest_longfunc$AB$end:
 add rsp,80
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_strcopy_len$AB:
 ;func test_strcopy_len(): {}
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,40
 ;prolog end

 lea rax,[$cbstr2]
 ;ir_load_addr STR2;

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 mov rcx,qword [rbp-8]
 call cb$Nstd$Nrawstring$Ncopy$AB$Araw_string
 ;ir_call cb$Nstd$Nrawstring$Ncopy$AB$Araw_string L0;

 mov qword [rbp-16],rax
 ;ir_load L1 ST;

 mov rcx,qword [rbp-8]
 call cb$Nstd$Nrawstring$Nlen$AB$Araw_string
 mov rbx,rax
 ;ir_call cb$Nstd$Nrawstring$Nlen$AB$Araw_string L0;

 mov rcx,qword [rbp-16]
 call cb$Nstd$Nrawstring$Nlen$AB$Araw_string
 ;ir_call cb$Nstd$Nrawstring$Nlen$AB$Araw_string L1;

 cmp rbx,rax
 jne cb$Nstd$Ntests1$Ntest_strcopy_len$AB$if528$else
 ;ir_jmp_neq ST ST cb$Nstd$Ntests1$Ntest_strcopy_len$AB$if528$else;

cb$Nstd$Ntests1$Ntest_strcopy_len$AB$if528$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_len$AB$if528$body;

 lea rax,[$cbstr3]
 ;ir_load_addr STR3;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_strcopy_len$AB$if528$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_strcopy_len$AB$if528$end;

cb$Nstd$Ntests1$Ntest_strcopy_len$AB$if528$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_len$AB$if528$else;

 lea rax,[$cbstr4]
 ;ir_load_addr STR4;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_strcopy_len$AB$if528$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_len$AB$if528$end;

 mov rcx,qword [rbp-16]
 call cb$Nstd$Nmemory$Ndealloc$AB$Araw_ptr
 ;ir_call cb$Nstd$Nmemory$Ndealloc$AB$Araw_ptr L1;

cb$Nstd$Ntests1$Ntest_strcopy_len$AB$end:
 add rsp,40
 pop rbx
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_strcopy$AB:
 ;func test_strcopy(): {}
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,40
 ;prolog end

 lea rax,[$cbstr2]
 ;ir_load_addr STR2;

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 mov rcx,qword [rbp-8]
 call cb$Nstd$Nrawstring$Ncopy$AB$Araw_string
 ;ir_call cb$Nstd$Nrawstring$Ncopy$AB$Araw_string L0;

 mov qword [rbp-16],rax
 ;ir_load L1 ST;

 mov rax,qword [rbp-8]
 ;ir_deref L0;

 mov r10,0
 lea rbx,byte [rax+r10*1]
 ;ir_index ST 0;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 mov r10,0
 lea rax,byte [rax+r10*1]
 ;ir_index ST 0;

 mov r10b,byte [rbx+0]
 cmp r10b,byte [rax+0]
 jne cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$else
 ;ir_jmp_neq ST ST cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$else;

 mov rax,qword [rbp-8]
 ;ir_deref L0;

 mov r10,1
 lea rbx,byte [rax+r10*1]
 ;ir_index ST 1;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 mov r10,1
 lea rax,byte [rax+r10*1]
 ;ir_index ST 1;

 mov r10b,byte [rbx+0]
 cmp r10b,byte [rax+0]
 jne cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$else
 ;ir_jmp_neq ST ST cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$else;

 mov rax,qword [rbp-8]
 ;ir_deref L0;

 mov r10,2
 lea rbx,byte [rax+r10*1]
 ;ir_index ST 2;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 mov r10,2
 lea rax,byte [rax+r10*1]
 ;ir_index ST 2;

 mov r10b,byte [rbx+0]
 cmp r10b,byte [rax+0]
 jne cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$else
 ;ir_jmp_neq ST ST cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$else;

 mov rax,qword [rbp-8]
 ;ir_deref L0;

 mov r10,3
 lea rbx,byte [rax+r10*1]
 ;ir_index ST 3;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 mov r10,3
 lea rax,byte [rax+r10*1]
 ;ir_index ST 3;

 mov r10b,byte [rbx+0]
 cmp r10b,byte [rax+0]
 jne cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$else
 ;ir_jmp_neq ST ST cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$else;

 mov rax,qword [rbp-8]
 ;ir_deref L0;

 mov r10,4
 lea rbx,byte [rax+r10*1]
 ;ir_index ST 4;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 mov r10,4
 lea rax,byte [rax+r10*1]
 ;ir_index ST 4;

 mov r10b,byte [rbx+0]
 cmp r10b,byte [rax+0]
 jne cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$else
 ;ir_jmp_neq ST ST cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$else;

cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$body;

 lea rax,[$cbstr5]
 ;ir_load_addr STR5;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$end;

cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$else;

 lea rax,[$cbstr6]
 ;ir_load_addr STR6;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy$AB$if603$end;

 mov rcx,qword [rbp-16]
 call cb$Nstd$Nmemory$Ndealloc$AB$Araw_ptr
 ;ir_call cb$Nstd$Nmemory$Ndealloc$AB$Araw_ptr L1;

cb$Nstd$Ntests1$Ntest_strcopy$AB$end:
 add rsp,40
 pop rbx
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_strcopy_saving$AB:
 ;func test_strcopy_saving(): {}
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,56
 ;prolog end

 lea rax,[$cbstr2]
 ;ir_load_addr STR2;

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 mov rcx,qword [rbp-8]
 call cb$Nstd$Nrawstring$Ncopy$AB$Araw_string
 ;ir_call cb$Nstd$Nrawstring$Ncopy$AB$Araw_string L0;

 mov qword [rbp-16],rax
 ;ir_load L1 ST;

 mov rax,qword [rbp-8]
 ;ir_deref L0;

 mov r10,0
 lea rbx,byte [rax+r10*1]
 ;ir_index ST 0;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 mov r10,0
 lea rax,byte [rax+r10*1]
 ;ir_index ST 0;

 mov r10b,byte [rbx+0]
 cmp r10b,byte [rax+0]
 jne cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2302$else
 ;ir_jmp_neq ST ST cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2302$else;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2302$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2302$body;

 mov r10b,1
 mov byte [rbp-17],r10b
 ;ir_load L2 1;

 jmp cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2302$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2302$end;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2302$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2302$else;

 mov r10b,0
 mov byte [rbp-17],r10b
 ;ir_load L2 0;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2302$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2302$end;

 mov rax,qword [rbp-8]
 ;ir_deref L0;

 mov r10,1
 lea rbx,byte [rax+r10*1]
 ;ir_index ST 1;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 mov r10,1
 lea rax,byte [rax+r10*1]
 ;ir_index ST 1;

 mov r10b,byte [rbx+0]
 cmp r10b,byte [rax+0]
 jne cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2310$else
 ;ir_jmp_neq ST ST cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2310$else;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2310$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2310$body;

 mov r10b,1
 mov byte [rbp-18],r10b
 ;ir_load L3 1;

 jmp cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2310$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2310$end;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2310$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2310$else;

 mov r10b,0
 mov byte [rbp-18],r10b
 ;ir_load L3 0;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2310$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2310$end;

 mov rax,qword [rbp-8]
 ;ir_deref L0;

 mov r10,2
 lea rbx,byte [rax+r10*1]
 ;ir_index ST 2;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 mov r10,2
 lea rax,byte [rax+r10*1]
 ;ir_index ST 2;

 mov r10b,byte [rbx+0]
 cmp r10b,byte [rax+0]
 jne cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2318$else
 ;ir_jmp_neq ST ST cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2318$else;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2318$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2318$body;

 mov r10b,1
 mov byte [rbp-19],r10b
 ;ir_load L4 1;

 jmp cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2318$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2318$end;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2318$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2318$else;

 mov r10b,0
 mov byte [rbp-19],r10b
 ;ir_load L4 0;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2318$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2318$end;

 mov rax,qword [rbp-8]
 ;ir_deref L0;

 mov r10,3
 lea rbx,byte [rax+r10*1]
 ;ir_index ST 3;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 mov r10,3
 lea rax,byte [rax+r10*1]
 ;ir_index ST 3;

 mov r10b,byte [rbx+0]
 cmp r10b,byte [rax+0]
 jne cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2326$else
 ;ir_jmp_neq ST ST cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2326$else;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2326$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2326$body;

 mov r10b,1
 mov byte [rbp-20],r10b
 ;ir_load L5 1;

 jmp cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2326$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2326$end;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2326$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2326$else;

 mov r10b,0
 mov byte [rbp-20],r10b
 ;ir_load L5 0;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2326$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2326$end;

 mov rax,qword [rbp-8]
 ;ir_deref L0;

 mov r10,4
 lea rbx,byte [rax+r10*1]
 ;ir_index ST 4;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 mov r10,4
 lea rax,byte [rax+r10*1]
 ;ir_index ST 4;

 mov r10b,byte [rbx+0]
 cmp r10b,byte [rax+0]
 jne cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2334$else
 ;ir_jmp_neq ST ST cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2334$else;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2334$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2334$body;

 mov r10b,1
 mov byte [rbp-21],r10b
 ;ir_load L6 1;

 jmp cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2334$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2334$end;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2334$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2334$else;

 mov r10b,0
 mov byte [rbp-21],r10b
 ;ir_load L6 0;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2334$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if2334$end;

 mov r10b,byte [rbp-17]
 cmp r10b,0
 je cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$else
 ;ir_jmp_eq L2 0 cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$else;

 mov r10b,byte [rbp-18]
 cmp r10b,0
 je cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$else
 ;ir_jmp_eq L3 0 cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$else;

 mov r10b,byte [rbp-19]
 cmp r10b,0
 je cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$else
 ;ir_jmp_eq L4 0 cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$else;

 mov r10b,byte [rbp-20]
 cmp r10b,0
 je cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$else
 ;ir_jmp_eq L5 0 cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$else;

 mov r10b,byte [rbp-21]
 cmp r10b,0
 je cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$else
 ;ir_jmp_eq L6 0 cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$else;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$body;

 lea rax,[$cbstr7]
 ;ir_load_addr STR7;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$end;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$else;

 lea rax,[$cbstr8]
 ;ir_load_addr STR8;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$if693$end;

 mov rcx,qword [rbp-16]
 call cb$Nstd$Nmemory$Ndealloc$AB$Araw_ptr
 ;ir_call cb$Nstd$Nmemory$Ndealloc$AB$Araw_ptr L1;

cb$Nstd$Ntests1$Ntest_strcopy_saving$AB$end:
 add rsp,56
 pop rbx
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_while_statement$AB:
 ;func test_while_statement(): {}
 push rbp
 mov rbp,rsp
 sub rsp,48
 ;prolog end

 lea rax,[$cbstr2]
 ;ir_load_addr STR2;

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 mov rcx,qword [rbp-8]
 call cb$Nstd$Nrawstring$Ncopy$AB$Araw_string
 ;ir_call cb$Nstd$Nrawstring$Ncopy$AB$Araw_string L0;

 mov qword [rbp-16],rax
 ;ir_load L1 ST;

 mov r10d,0
 mov dword [rbp-20],r10d
 ;ir_load L2 0;

cb$Nstd$Ntests1$Ntest_while_statement$AB$w735$cond:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_while_statement$AB$w735$cond;

 mov r10d,dword [rbp-20]
 cmp r10d,5
 jge cb$Nstd$Ntests1$Ntest_while_statement$AB$w735$end
 ;ir_jmp_gte L2 5 cb$Nstd$Ntests1$Ntest_while_statement$AB$w735$end;

cb$Nstd$Ntests1$Ntest_while_statement$AB$w735$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_while_statement$AB$w735$body;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 movsxd r10,dword [rbp-20]
 lea rax,byte [rax+r10*1]
 ;ir_index ST L2;

 mov r10b,71
 mov byte [rax+0],r10b
 ;ir_load ST 'G';

 mov r10d,dword [rbp-20]
 add r10d,1
 mov eax,r10d
 ;ir_add L2 1;

 mov dword [rbp-20],eax
 ;ir_load L2 ST;

 jmp cb$Nstd$Ntests1$Ntest_while_statement$AB$w735$cond
 ;ir_jmp cb$Nstd$Ntests1$Ntest_while_statement$AB$w735$cond;

cb$Nstd$Ntests1$Ntest_while_statement$AB$w735$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_while_statement$AB$w735$end;

 mov r10d,dword [rbp-20]
 cmp r10d,5
 jge cb$Nstd$Ntests1$Ntest_while_statement$AB$if746$else
 ;ir_jmp_gte L2 5 cb$Nstd$Ntests1$Ntest_while_statement$AB$if746$else;

cb$Nstd$Ntests1$Ntest_while_statement$AB$if746$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_while_statement$AB$if746$body;

 lea rax,[$cbstr9]
 ;ir_load_addr STR9;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_while_statement$AB$if746$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_while_statement$AB$if746$else;

 lea rax,[$cbstr10]
 ;ir_load_addr STR10;

 mov rdx,rax
 mov rcx,qword [rbp-16]
 call cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string
 ;ir_call cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string L1 ST;

 cmp al,0
 je cb$Nstd$Ntests1$Ntest_while_statement$AB$if772$else
 ;ir_jmp_eq ST 0 cb$Nstd$Ntests1$Ntest_while_statement$AB$if772$else;

 lea rax,[$cbstr11]
 ;ir_load_addr STR11;

 mov rdx,rax
 mov rcx,qword [rbp-16]
 call cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string
 ;ir_call cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string L1 ST;

 cmp al,0
 jne cb$Nstd$Ntests1$Ntest_while_statement$AB$if772$else
 ;ir_jmp_neq ST 0 cb$Nstd$Ntests1$Ntest_while_statement$AB$if772$else;

cb$Nstd$Ntests1$Ntest_while_statement$AB$if772$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_while_statement$AB$if772$body;

 lea rax,[$cbstr12]
 ;ir_load_addr STR12;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_while_statement$AB$if772$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_while_statement$AB$if772$end;

cb$Nstd$Ntests1$Ntest_while_statement$AB$if772$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_while_statement$AB$if772$else;

 lea rax,[$cbstr13]
 ;ir_load_addr STR13;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_while_statement$AB$if772$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_while_statement$AB$if772$end;

 mov rcx,qword [rbp-16]
 call cb$Nstd$Nmemory$Ndealloc$AB$Araw_ptr
 ;ir_call cb$Nstd$Nmemory$Ndealloc$AB$Araw_ptr L1;

cb$Nstd$Ntests1$Ntest_while_statement$AB$end:
 add rsp,48
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_short$AB:
 ;func test_short(): bool
 push rbp
 mov rbp,rsp
 sub rsp,16
 ;prolog end

 lea rax,[$cbstr14]
 ;ir_load_addr STR14;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 mov al,1
 ;ir_return 1;

cb$Nstd$Ntests1$Ntest_short$AB$end:
 add rsp,16
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_for_stmt$AB:
 ;func test_for_stmt(): {}
 push rbp
 mov rbp,rsp
 sub rsp,64
 ;prolog end

 lea rax,[$cbstr15]
 ;ir_load_addr STR15;

 mov rcx,rax
 call cb$Nstd$Nrawstring$Ncopy$AB$Araw_string
 ;ir_call cb$Nstd$Nrawstring$Ncopy$AB$Araw_string ST;

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 mov r10d,0
 mov dword [rbp-24],r10d
 ;ir_load [L1 . 0] 0;

 mov rcx,qword [rbp-8]
 call cb$Nstd$Nrawstring$Nlen$AB$Araw_string
 ;ir_call cb$Nstd$Nrawstring$Nlen$AB$Araw_string L0;

 mov qword [rbp-20],rax
 ;ir_load [L1 . 1] ST;

 mov r10d,dword [rbp-24]
 mov dword [rbp-32],r10d
 ;ir_load L3 [L1 . 0];

cb$Nstd$Ntests1$Ntest_for_stmt$AB$f829$cond:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_for_stmt$AB$f829$cond;

 movsxd rax,dword [rbp-32]
 ;ir_cast L3;

 cmp rax,qword [rbp-20]
 jge cb$Nstd$Ntests1$Ntest_for_stmt$AB$f829$end
 ;ir_jmp_gte ST [L1 . 1] cb$Nstd$Ntests1$Ntest_for_stmt$AB$f829$end;

cb$Nstd$Ntests1$Ntest_for_stmt$AB$f829$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_for_stmt$AB$f829$body;

 mov r10b,48
 add r10b,byte [rbp-32]
 mov al,r10b
 ;ir_add '0' L3;

 mov byte [rbp-33],al
 ;ir_load L4 ST;

 mov rax,qword [rbp-8]
 ;ir_deref L0;

 movsxd r10,dword [rbp-32]
 lea rax,byte [rax+r10*1]
 ;ir_index ST L3;

 mov r10b,byte [rbp-33]
 mov byte [rax+0],r10b
 ;ir_load ST L4;

 mov r10d,dword [rbp-32]
 add r10d,1
 mov eax,r10d
 ;ir_add L3 1;

 mov dword [rbp-32],eax
 ;ir_load L3 ST;

 jmp cb$Nstd$Ntests1$Ntest_for_stmt$AB$f829$cond
 ;ir_jmp cb$Nstd$Ntests1$Ntest_for_stmt$AB$f829$cond;

cb$Nstd$Ntests1$Ntest_for_stmt$AB$f829$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_for_stmt$AB$f829$end;

 lea rax,[$cbstr16]
 ;ir_load_addr STR16;

 mov rdx,rax
 mov rcx,qword [rbp-8]
 call cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string
 ;ir_call cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string L0 ST;

 cmp al,0
 je cb$Nstd$Ntests1$Ntest_for_stmt$AB$if848$else
 ;ir_jmp_eq ST 0 cb$Nstd$Ntests1$Ntest_for_stmt$AB$if848$else;

cb$Nstd$Ntests1$Ntest_for_stmt$AB$if848$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_for_stmt$AB$if848$body;

 lea rax,[$cbstr17]
 ;ir_load_addr STR17;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_for_stmt$AB$if848$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_for_stmt$AB$if848$end;

cb$Nstd$Ntests1$Ntest_for_stmt$AB$if848$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_for_stmt$AB$if848$else;

 lea rax,[$cbstr18]
 ;ir_load_addr STR18;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_for_stmt$AB$if848$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_for_stmt$AB$if848$end;

 mov rcx,qword [rbp-8]
 call cb$Nstd$Nmemory$Ndealloc$AB$Araw_ptr
 ;ir_call cb$Nstd$Nmemory$Ndealloc$AB$Araw_ptr L0;

cb$Nstd$Ntests1$Ntest_for_stmt$AB$end:
 add rsp,64
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB:
 ;func test_tuple_zeroinit(): {}
 push rbp
 mov rbp,rsp
 sub rsp,48
 ;prolog end

 mov r10d,0
 mov dword [rbp-8],r10d
 ;ir_load [L0 . 0] 0;

 mov r10d,0
 mov dword [rbp-4],r10d
 ;ir_load [L0 . 1] 0;

 lea rax,[$cbstr19]
 ;ir_load_addr STR19;

 mov qword [rbp-24],rax
 ;ir_load [L1 . 0] ST;

 mov r10b,0
 mov byte [rbp-16],r10b
 ;ir_load [L1 . 1] 0;

 mov r10d,dword [rbp-8]
 cmp r10d,0
 jne cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB$if918$else
 ;ir_jmp_neq [L0 . 0] 0 cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB$if918$else;

 mov r10d,dword [rbp-4]
 cmp r10d,0
 jne cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB$if918$else
 ;ir_jmp_neq [L0 . 1] 0 cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB$if918$else;

 lea rax,[$cbstr19]
 ;ir_load_addr STR19;

 mov rdx,rax
 mov rcx,qword [rbp-24]
 call cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string
 ;ir_call cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string [L1 . 0] ST;

 cmp al,0
 je cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB$if918$else
 ;ir_jmp_eq ST 0 cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB$if918$else;

 mov r10b,byte [rbp-16]
 cmp r10b,0
 jne cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB$if918$else
 ;ir_jmp_neq [L1 . 1] 0 cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB$if918$else;

cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB$if918$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB$if918$body;

 lea rax,[$cbstr20]
 ;ir_load_addr STR20;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB$if918$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB$if918$end;

cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB$if918$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB$if918$else;

 lea rax,[$cbstr21]
 ;ir_load_addr STR21;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB$if918$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB$if918$end;

cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB$end:
 add rsp,48
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_tuple_init$AB:
 ;func test_tuple_init(): {}
 push rbp
 mov rbp,rsp
 sub rsp,64
 ;prolog end

 mov r10d,3
 mov dword [rbp-12],r10d
 ;ir_load [L0 . 0] 3;

 mov r10d,4
 mov dword [rbp-8],r10d
 ;ir_load [L0 . 1] 4;

 mov r10d,5
 mov dword [rbp-4],r10d
 ;ir_load [L0 . 2] 5;

 lea rax,[$cbstr22]
 ;ir_load_addr STR22;

 mov qword [rbp-40],rax
 ;ir_load [L1 . 0] ST;

 lea rax,[$cbstr23]
 ;ir_load_addr STR23;

 mov qword [rbp-32],rax
 ;ir_load [L1 . 1] ST;

 mov r10b,0
 mov byte [rbp-24],r10b
 ;ir_load [L1 . 2] 0;

 mov r10d,dword [rbp-12]
 cmp r10d,3
 jne cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$else
 ;ir_jmp_neq [L0 . 0] 3 cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$else;

 mov r10d,dword [rbp-8]
 cmp r10d,4
 jne cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$else
 ;ir_jmp_neq [L0 . 1] 4 cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$else;

 mov r10d,dword [rbp-4]
 cmp r10d,5
 jne cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$else
 ;ir_jmp_neq [L0 . 2] 5 cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$else;

 lea rax,[$cbstr22]
 ;ir_load_addr STR22;

 mov rdx,rax
 mov rcx,qword [rbp-40]
 call cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string
 ;ir_call cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string [L1 . 0] ST;

 cmp al,0
 je cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$else
 ;ir_jmp_eq ST 0 cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$else;

 lea rax,[$cbstr23]
 ;ir_load_addr STR23;

 mov rdx,rax
 mov rcx,qword [rbp-32]
 call cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string
 ;ir_call cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string [L1 . 1] ST;

 cmp al,0
 je cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$else
 ;ir_jmp_eq ST 0 cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$else;

 mov r10b,byte [rbp-24]
 cmp r10b,0
 jne cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$else
 ;ir_jmp_neq [L1 . 2] 0 cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$else;

cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$body;

 lea rax,[$cbstr24]
 ;ir_load_addr STR24;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$end;

cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$else;

 lea rax,[$cbstr25]
 ;ir_load_addr STR25;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_tuple_init$AB$if989$end;

cb$Nstd$Ntests1$Ntest_tuple_init$AB$end:
 add rsp,64
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_array_zeroinit$AB:
 ;func test_array_zeroinit(): {}
 push rbp
 mov rbp,rsp
 sub rsp,80
 ;prolog end

 mov r10,0
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 0;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,1
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 1;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,2
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 2;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,3
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 3;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,4
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 4;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,5
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 5;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,6
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 6;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,7
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 7;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,8
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 8;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,9
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 9;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,10
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 10;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,11
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 11;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,12
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 12;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,13
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 13;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,14
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 14;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,15
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 15;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,0
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 0;

 mov r10d,dword [rax+0]
 cmp r10d,0
 jne cb$Nstd$Ntests1$Ntest_array_zeroinit$AB$if1026$else
 ;ir_jmp_neq ST 0 cb$Nstd$Ntests1$Ntest_array_zeroinit$AB$if1026$else;

 mov r10,12
 lea rax,qword [rbp-64+r10*4]
 ;ir_index L0 12;

 mov r10d,dword [rax+0]
 cmp r10d,0
 jne cb$Nstd$Ntests1$Ntest_array_zeroinit$AB$if1026$else
 ;ir_jmp_neq ST 0 cb$Nstd$Ntests1$Ntest_array_zeroinit$AB$if1026$else;

cb$Nstd$Ntests1$Ntest_array_zeroinit$AB$if1026$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_array_zeroinit$AB$if1026$body;

 lea rax,[$cbstr26]
 ;ir_load_addr STR26;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_array_zeroinit$AB$if1026$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_array_zeroinit$AB$if1026$end;

cb$Nstd$Ntests1$Ntest_array_zeroinit$AB$if1026$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_array_zeroinit$AB$if1026$else;

 lea rax,[$cbstr27]
 ;ir_load_addr STR27;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_array_zeroinit$AB$if1026$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_array_zeroinit$AB$if1026$end;

cb$Nstd$Ntests1$Ntest_array_zeroinit$AB$end:
 add rsp,80
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_array_init$AB:
 ;func test_array_init(): {}
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov r10,0
 lea rax,qword [rbp-12+r10*4]
 ;ir_index L0 0;

 mov r10d,1
 mov dword [rax+0],r10d
 ;ir_load ST 1;

 mov r10,1
 lea rax,qword [rbp-12+r10*4]
 ;ir_index L0 1;

 mov r10d,2
 mov dword [rax+0],r10d
 ;ir_load ST 2;

 mov r10,2
 lea rax,qword [rbp-12+r10*4]
 ;ir_index L0 2;

 mov r10d,3
 mov dword [rax+0],r10d
 ;ir_load ST 3;

 mov r10,0
 lea rax,qword [rbp-12+r10*4]
 ;ir_index L0 0;

 mov r10d,dword [rax+0]
 cmp r10d,1
 jne cb$Nstd$Ntests1$Ntest_array_init$AB$if1074$else
 ;ir_jmp_neq ST 1 cb$Nstd$Ntests1$Ntest_array_init$AB$if1074$else;

 mov r10,1
 lea rax,qword [rbp-12+r10*4]
 ;ir_index L0 1;

 mov r10d,dword [rax+0]
 cmp r10d,2
 jne cb$Nstd$Ntests1$Ntest_array_init$AB$if1074$else
 ;ir_jmp_neq ST 2 cb$Nstd$Ntests1$Ntest_array_init$AB$if1074$else;

 mov r10,2
 lea rax,qword [rbp-12+r10*4]
 ;ir_index L0 2;

 mov r10d,dword [rax+0]
 cmp r10d,3
 jne cb$Nstd$Ntests1$Ntest_array_init$AB$if1074$else
 ;ir_jmp_neq ST 3 cb$Nstd$Ntests1$Ntest_array_init$AB$if1074$else;

cb$Nstd$Ntests1$Ntest_array_init$AB$if1074$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_array_init$AB$if1074$body;

 lea rax,[$cbstr28]
 ;ir_load_addr STR28;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_array_init$AB$if1074$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_array_init$AB$if1074$end;

cb$Nstd$Ntests1$Ntest_array_init$AB$if1074$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_array_init$AB$if1074$else;

 lea rax,[$cbstr29]
 ;ir_load_addr STR29;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_array_init$AB$if1074$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_array_init$AB$if1074$end;

cb$Nstd$Ntests1$Ntest_array_init$AB$end:
 add rsp,32
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB:
 ;func test_tuple_assignment_lvalue(): {}
 push rbp
 mov rbp,rsp
 sub rsp,64
 ;prolog end

 mov r10d,3
 mov dword [rbp-12],r10d
 ;ir_load [L0 . 0] 3;

 mov r10d,4
 mov dword [rbp-8],r10d
 ;ir_load [L0 . 1] 4;

 mov r10d,5
 mov dword [rbp-4],r10d
 ;ir_load [L0 . 2] 5;

 push rdi
 push rsi
 push rcx
 lea rdi,qword [rbp-24]
 lea rsi,qword [rbp-12]
 mov rcx,12
 rep movsb
 pop rcx
 pop rsi
 pop rdi
 ;ir_copy L1 L0 12;

 mov r10d,0
 mov dword [rbp-36],r10d
 ;ir_load [L2 . 0] 0;

 mov r10d,1
 mov dword [rbp-32],r10d
 ;ir_load [L2 . 1] 1;

 mov r10d,2
 mov dword [rbp-28],r10d
 ;ir_load [L2 . 2] 2;

 push rdi
 push rsi
 push rcx
 lea rdi,qword [rbp-36]
 lea rsi,qword [rbp-24]
 mov rcx,12
 rep movsb
 pop rcx
 pop rsi
 pop rdi
 ;ir_copy L2 L1 12;

 mov r10d,dword [rbp-12]
 cmp r10d,dword [rbp-24]
 jne cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB$if1136$else
 ;ir_jmp_neq [L0 . 0] [L1 . 0] cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB$if1136$else;

 mov r10d,dword [rbp-8]
 cmp r10d,dword [rbp-20]
 jne cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB$if1136$else
 ;ir_jmp_neq [L0 . 1] [L1 . 1] cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB$if1136$else;

 mov r10d,dword [rbp-4]
 cmp r10d,dword [rbp-16]
 jne cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB$if1136$else
 ;ir_jmp_neq [L0 . 2] [L1 . 2] cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB$if1136$else;

cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB$if1136$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB$if1136$body;

 lea rax,[$cbstr30]
 ;ir_load_addr STR30;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB$if1136$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB$if1136$end;

cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB$if1136$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB$if1136$else;

 lea rax,[$cbstr31]
 ;ir_load_addr STR31;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB$if1136$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB$if1136$end;

cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB$end:
 add rsp,64
 pop rbp
 ret


cb$Nstd$Ntests1$Nsum_tuple$AB$Aref$$tuple$$int$int$int$$$$:
 ;func sum_tuple({int, int, int}): int
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,8
 ;prolog end

 mov rbx,rcx
 ;ir_deref A0;

 mov rax,rcx
 ;ir_deref A0;

 mov r10d,dword [rbx+0]
 add r10d,dword [rax+4]
 mov ebx,r10d
 ;ir_add [ST . 0] [ST . 1];

 mov rax,rcx
 ;ir_deref A0;

 add ebx,dword [rax+8]
 mov eax,ebx
 ;ir_add ST [ST . 2];

 ;ir_return ST;

cb$Nstd$Ntests1$Nsum_tuple$AB$Aref$$tuple$$int$int$int$$$$$end:
 add rsp,8
 pop rbx
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_tuple_argument$AB:
 ;func test_tuple_argument(): {}
 push rbp
 mov rbp,rsp
 sub rsp,48
 ;prolog end

 mov r10d,3
 mov dword [rbp-12],r10d
 ;ir_load [L0 . 0] 3;

 mov r10d,4
 mov dword [rbp-8],r10d
 ;ir_load [L0 . 1] 4;

 mov r10d,5
 mov dword [rbp-4],r10d
 ;ir_load [L0 . 2] 5;

 push rdi
 push rsi
 push rcx
 lea rdi,qword [rbp-28]
 lea rsi,qword [rbp-12]
 mov rcx,12
 rep movsb
 pop rcx
 pop rsi
 pop rdi
 ;ir_copy L2 L0 12;

 lea rax,qword [rbp-28]
 ;ir_load_addr L2;

 mov rcx,rax
 call cb$Nstd$Ntests1$Nsum_tuple$AB$Aref$$tuple$$int$int$int$$$$
 ;ir_call cb$Nstd$Ntests1$Nsum_tuple$AB$Aref$$tuple$$int$int$int$$$$ ST;

 mov dword [rbp-16],eax
 ;ir_load L1 ST;

 mov r10d,3
 add r10d,4
 mov eax,r10d
 ;ir_add 3 4;

 add eax,5
 ;ir_add ST 5;

 mov r10d,dword [rbp-16]
 cmp r10d,eax
 jne cb$Nstd$Ntests1$Ntest_tuple_argument$AB$if1205$else
 ;ir_jmp_neq L1 ST cb$Nstd$Ntests1$Ntest_tuple_argument$AB$if1205$else;

cb$Nstd$Ntests1$Ntest_tuple_argument$AB$if1205$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_tuple_argument$AB$if1205$body;

 lea rax,[$cbstr32]
 ;ir_load_addr STR32;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_tuple_argument$AB$if1205$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_tuple_argument$AB$if1205$end;

cb$Nstd$Ntests1$Ntest_tuple_argument$AB$if1205$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_tuple_argument$AB$if1205$else;

 lea rax,[$cbstr33]
 ;ir_load_addr STR33;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_tuple_argument$AB$if1205$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_tuple_argument$AB$if1205$end;

cb$Nstd$Ntests1$Ntest_tuple_argument$AB$end:
 add rsp,48
 pop rbp
 ret


cb$Nstd$Ntests1$Ndo_stuff$AB$Aref$$tuple$$raw_string$bool$$$$:
 ;func do_stuff(&{raw_string, bool}): &{raw_string, bool}
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,8
 ;prolog end

 mov rbx,rcx
 ;ir_deref A0;

 lea rax,[$cbstr34]
 ;ir_load_addr STR34;

 mov qword [rbx+0],rax
 ;ir_load [ST . 0] ST;

 mov rax,rcx
 ;ir_deref A0;

 mov r10b,1
 mov byte [rax+8],r10b
 ;ir_load [ST . 1] 1;

 mov rax,rcx
 ;ir_return A0;

cb$Nstd$Ntests1$Ndo_stuff$AB$Aref$$tuple$$raw_string$bool$$$$$end:
 add rsp,8
 pop rbx
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_tuple_return_value$AB:
 ;func test_tuple_return_value(): {}
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 lea rax,qword [rbp-16]
 ;ir_load_addr L0;

 mov rcx,rax
 call cb$Nstd$Ntests1$Ndo_stuff$AB$Aref$$tuple$$raw_string$bool$$$$
 ;ir_call cb$Nstd$Ntests1$Ndo_stuff$AB$Aref$$tuple$$raw_string$bool$$$$ ST;

 lea rax,[$cbstr34]
 ;ir_load_addr STR34;

 mov rdx,rax
 mov rcx,qword [rbp-16]
 call cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string
 ;ir_call cb$Nstd$Nrawstring$Nequals$AB$Araw_string$Araw_string [L0 . 0] ST;

 cmp al,0
 je cb$Nstd$Ntests1$Ntest_tuple_return_value$AB$if1262$else
 ;ir_jmp_eq ST 0 cb$Nstd$Ntests1$Ntest_tuple_return_value$AB$if1262$else;

 mov r10b,byte [rbp-8]
 cmp r10b,1
 jne cb$Nstd$Ntests1$Ntest_tuple_return_value$AB$if1262$else
 ;ir_jmp_neq [L0 . 1] 1 cb$Nstd$Ntests1$Ntest_tuple_return_value$AB$if1262$else;

cb$Nstd$Ntests1$Ntest_tuple_return_value$AB$if1262$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_tuple_return_value$AB$if1262$body;

 lea rax,[$cbstr35]
 ;ir_load_addr STR35;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_tuple_return_value$AB$if1262$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_tuple_return_value$AB$if1262$end;

cb$Nstd$Ntests1$Ntest_tuple_return_value$AB$if1262$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_tuple_return_value$AB$if1262$else;

 lea rax,[$cbstr36]
 ;ir_load_addr STR36;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_tuple_return_value$AB$if1262$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_tuple_return_value$AB$if1262$end;

cb$Nstd$Ntests1$Ntest_tuple_return_value$AB$end:
 add rsp,32
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB:
 ;func test_array_assignment_lvalue(): {}
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,72
 ;prolog end

 mov r10,0
 lea rax,qword [rbp-24+r10*4]
 ;ir_index L0 0;

 mov r10d,3
 mov dword [rax+0],r10d
 ;ir_load ST 3;

 mov r10,1
 lea rax,qword [rbp-24+r10*4]
 ;ir_index L0 1;

 mov r10d,5
 mov dword [rax+0],r10d
 ;ir_load ST 5;

 mov r10,2
 lea rax,qword [rbp-24+r10*4]
 ;ir_index L0 2;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,3
 lea rax,qword [rbp-24+r10*4]
 ;ir_index L0 3;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,4
 lea rax,qword [rbp-24+r10*4]
 ;ir_index L0 4;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,5
 lea rax,qword [rbp-24+r10*4]
 ;ir_index L0 5;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 push rdi
 push rsi
 push rcx
 lea rdi,qword [rbp-48]
 lea rsi,qword [rbp-24]
 mov rcx,24
 rep movsb
 pop rcx
 pop rsi
 pop rdi
 ;ir_copy L1 L0 24;

 mov r10,0
 lea rbx,qword [rbp-24+r10*4]
 ;ir_index L0 0;

 mov r10,0
 lea rax,qword [rbp-48+r10*4]
 ;ir_index L1 0;

 mov r10d,dword [rbx+0]
 cmp r10d,dword [rax+0]
 jne cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB$if1318$else
 ;ir_jmp_neq ST ST cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB$if1318$else;

 mov r10,1
 lea rbx,qword [rbp-24+r10*4]
 ;ir_index L0 1;

 mov r10,1
 lea rax,qword [rbp-48+r10*4]
 ;ir_index L1 1;

 mov r10d,dword [rbx+0]
 cmp r10d,dword [rax+0]
 jne cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB$if1318$else
 ;ir_jmp_neq ST ST cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB$if1318$else;

 mov r10,2
 lea rbx,qword [rbp-24+r10*4]
 ;ir_index L0 2;

 mov r10,2
 lea rax,qword [rbp-48+r10*4]
 ;ir_index L1 2;

 mov r10d,dword [rbx+0]
 cmp r10d,dword [rax+0]
 jne cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB$if1318$else
 ;ir_jmp_neq ST ST cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB$if1318$else;

cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB$if1318$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB$if1318$body;

 lea rax,[$cbstr37]
 ;ir_load_addr STR37;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB$if1318$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB$if1318$end;

cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB$if1318$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB$if1318$else;

 lea rax,[$cbstr38]
 ;ir_load_addr STR38;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB$if1318$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB$if1318$end;

cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB$end:
 add rsp,72
 pop rbx
 pop rbp
 ret


cb$Nstd$Ntests1$Nsum_array$AB$Aref$$array$$int$$$$:
 ;func sum_array([6]int): int
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov r10d,0
 mov dword [rbp-4],r10d
 ;ir_load L0 0;

 mov r10d,0
 mov dword [rbp-12],r10d
 ;ir_load [L1 . 0] 0;

 mov r10d,6
 mov dword [rbp-8],r10d
 ;ir_load [L1 . 1] 6;

 mov r10d,dword [rbp-12]
 mov dword [rbp-20],r10d
 ;ir_load L3 [L1 . 0];

cb$Nstd$Ntests1$Nsum_array$AB$Aref$$array$$int$$$$$f1352$cond:
 ;ir_make_label cb$Nstd$Ntests1$Nsum_array$AB$Aref$$array$$int$$$$$f1352$cond;

 mov r10d,dword [rbp-20]
 cmp r10d,dword [rbp-8]
 jge cb$Nstd$Ntests1$Nsum_array$AB$Aref$$array$$int$$$$$f1352$end
 ;ir_jmp_gte L3 [L1 . 1] cb$Nstd$Ntests1$Nsum_array$AB$Aref$$array$$int$$$$$f1352$end;

cb$Nstd$Ntests1$Nsum_array$AB$Aref$$array$$int$$$$$f1352$body:
 ;ir_make_label cb$Nstd$Ntests1$Nsum_array$AB$Aref$$array$$int$$$$$f1352$body;

 mov rax,rcx
 ;ir_deref A0;

 movsxd r10,dword [rbp-20]
 lea rax,qword [rax+r10*4]
 ;ir_index ST L3;

 mov r10d,dword [rbp-4]
 add r10d,dword [rax+0]
 mov eax,r10d
 ;ir_add L0 ST;

 mov dword [rbp-4],eax
 ;ir_load L0 ST;

 mov r10d,dword [rbp-20]
 add r10d,1
 mov eax,r10d
 ;ir_add L3 1;

 mov dword [rbp-20],eax
 ;ir_load L3 ST;

 jmp cb$Nstd$Ntests1$Nsum_array$AB$Aref$$array$$int$$$$$f1352$cond
 ;ir_jmp cb$Nstd$Ntests1$Nsum_array$AB$Aref$$array$$int$$$$$f1352$cond;

cb$Nstd$Ntests1$Nsum_array$AB$Aref$$array$$int$$$$$f1352$end:
 ;ir_make_label cb$Nstd$Ntests1$Nsum_array$AB$Aref$$array$$int$$$$$f1352$end;

 mov eax,dword [rbp-4]
 ;ir_return L0;

cb$Nstd$Ntests1$Nsum_array$AB$Aref$$array$$int$$$$$end:
 add rsp,32
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_array_argument$AB:
 ;func test_array_argument(): {}
 push rbp
 mov rbp,rsp
 sub rsp,48
 ;prolog end

 mov r10,0
 lea rax,qword [rbp-28+r10*4]
 ;ir_index L1 0;

 mov r10d,1
 mov dword [rax+0],r10d
 ;ir_load ST 1;

 mov r10,1
 lea rax,qword [rbp-28+r10*4]
 ;ir_index L1 1;

 mov r10d,2
 mov dword [rax+0],r10d
 ;ir_load ST 2;

 mov r10,2
 lea rax,qword [rbp-28+r10*4]
 ;ir_index L1 2;

 mov r10d,3
 mov dword [rax+0],r10d
 ;ir_load ST 3;

 mov r10,3
 lea rax,qword [rbp-28+r10*4]
 ;ir_index L1 3;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,4
 lea rax,qword [rbp-28+r10*4]
 ;ir_index L1 4;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,5
 lea rax,qword [rbp-28+r10*4]
 ;ir_index L1 5;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 lea rax,qword [rbp-28]
 ;ir_load_addr L1;

 mov rcx,rax
 call cb$Nstd$Ntests1$Nsum_array$AB$Aref$$array$$int$$$$
 ;ir_call cb$Nstd$Ntests1$Nsum_array$AB$Aref$$array$$int$$$$ ST;

 mov dword [rbp-4],eax
 ;ir_load L0 ST;

 mov r10d,1
 add r10d,2
 mov eax,r10d
 ;ir_add 1 2;

 add eax,3
 ;ir_add ST 3;

 mov r10d,dword [rbp-4]
 cmp r10d,eax
 jne cb$Nstd$Ntests1$Ntest_array_argument$AB$if1396$else
 ;ir_jmp_neq L0 ST cb$Nstd$Ntests1$Ntest_array_argument$AB$if1396$else;

cb$Nstd$Ntests1$Ntest_array_argument$AB$if1396$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_array_argument$AB$if1396$body;

 lea rax,[$cbstr39]
 ;ir_load_addr STR39;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_array_argument$AB$if1396$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_array_argument$AB$if1396$end;

cb$Nstd$Ntests1$Ntest_array_argument$AB$if1396$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_array_argument$AB$if1396$else;

 lea rax,[$cbstr40]
 ;ir_load_addr STR40;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_array_argument$AB$if1396$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_array_argument$AB$if1396$end;

cb$Nstd$Ntests1$Ntest_array_argument$AB$end:
 add rsp,48
 pop rbp
 ret


cb$Nstd$Ntests1$Nget_array_data$AB$Aref$$array$$int$$$$:
 ;func get_array_data(&[6]int): &[6]int
 push rbp
 mov rbp,rsp
 ;prolog end

 mov rax,rcx
 ;ir_deref A0;

 mov r10,0
 lea rax,qword [rax+r10*4]
 ;ir_index ST 0;

 mov r10d,5
 mov dword [rax+0],r10d
 ;ir_load ST 5;

 mov rax,rcx
 ;ir_deref A0;

 mov r10,1
 lea rax,qword [rax+r10*4]
 ;ir_index ST 1;

 mov r10d,6
 mov dword [rax+0],r10d
 ;ir_load ST 6;

 mov rax,rcx
 ;ir_deref A0;

 mov r10,2
 lea rax,qword [rax+r10*4]
 ;ir_index ST 2;

 mov r10d,7
 mov dword [rax+0],r10d
 ;ir_load ST 7;

 mov rax,rcx
 ;ir_deref A0;

 mov r10,3
 lea rax,qword [rax+r10*4]
 ;ir_index ST 3;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov rax,rcx
 ;ir_deref A0;

 mov r10,4
 lea rax,qword [rax+r10*4]
 ;ir_index ST 4;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov rax,rcx
 ;ir_deref A0;

 mov r10,5
 lea rax,qword [rax+r10*4]
 ;ir_index ST 5;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov rax,rcx
 ;ir_return A0;

cb$Nstd$Ntests1$Nget_array_data$AB$Aref$$array$$int$$$$$end:
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_array_return_value$AB:
 ;func test_array_return_value(): {}
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,56
 ;prolog end

 lea rax,qword [rbp-24]
 ;ir_load_addr L0;

 mov rcx,rax
 call cb$Nstd$Ntests1$Nget_array_data$AB$Aref$$array$$int$$$$
 ;ir_call cb$Nstd$Ntests1$Nget_array_data$AB$Aref$$array$$int$$$$ ST;

 lea rax,qword [rbp-24]
 ;ir_load_addr L0;

 mov rcx,rax
 call cb$Nstd$Ntests1$Nsum_array$AB$Aref$$array$$int$$$$
 mov ebx,eax
 ;ir_call cb$Nstd$Ntests1$Nsum_array$AB$Aref$$array$$int$$$$ ST;

 mov r10d,5
 add r10d,6
 mov eax,r10d
 ;ir_add 5 6;

 add eax,7
 ;ir_add ST 7;

 cmp ebx,eax
 jne cb$Nstd$Ntests1$Ntest_array_return_value$AB$if1447$else
 ;ir_jmp_neq ST ST cb$Nstd$Ntests1$Ntest_array_return_value$AB$if1447$else;

cb$Nstd$Ntests1$Ntest_array_return_value$AB$if1447$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_array_return_value$AB$if1447$body;

 lea rax,[$cbstr41]
 ;ir_load_addr STR41;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_array_return_value$AB$if1447$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_array_return_value$AB$if1447$end;

cb$Nstd$Ntests1$Ntest_array_return_value$AB$if1447$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_array_return_value$AB$if1447$else;

 lea rax,[$cbstr42]
 ;ir_load_addr STR42;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_array_return_value$AB$if1447$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_array_return_value$AB$if1447$end;

cb$Nstd$Ntests1$Ntest_array_return_value$AB$end:
 add rsp,56
 pop rbx
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_slice$AB:
 ;func test_slice(): {}
 push rbp
 mov rbp,rsp
 sub rsp,80
 ;prolog end

 mov r10,0
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 0;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,1
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 1;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,2
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 2;

 mov r10d,1
 mov dword [rax+0],r10d
 ;ir_load ST 1;

 mov r10,3
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 3;

 mov r10d,2
 mov dword [rax+0],r10d
 ;ir_load ST 2;

 mov r10,4
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 4;

 mov r10d,3
 mov dword [rax+0],r10d
 ;ir_load ST 3;

 mov r10,5
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 5;

 mov r10d,4
 mov dword [rax+0],r10d
 ;ir_load ST 4;

 mov r10,6
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 6;

 mov r10d,5
 mov dword [rax+0],r10d
 ;ir_load ST 5;

 mov r10,7
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 7;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,8
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 8;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,9
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 9;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,2
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 2;

 lea rax,dword [rax+0]
 ;ir_load_addr ST;

 mov qword [rbp-56],rax
 ;ir_load [L1 . 0] ST;

 mov r10d,7
 sub r10d,2
 mov eax,r10d
 ;ir_sub 7 2;

 movsxd rax,eax
 ;ir_cast ST;

 mov qword [rbp-48],rax
 ;ir_load [L1 . 1] ST;

 mov rax,qword [rbp-56]
 ;ir_deref [L1 . 0];

 mov r10,0
 lea rax,dword [rax+r10*4]
 ;ir_index ST 0;

 mov r10d,dword [rax+0]
 cmp r10d,1
 jne cb$Nstd$Ntests1$Ntest_slice$AB$if1511$else
 ;ir_jmp_neq ST 1 cb$Nstd$Ntests1$Ntest_slice$AB$if1511$else;

 mov rax,qword [rbp-56]
 ;ir_deref [L1 . 0];

 mov r10,1
 lea rax,dword [rax+r10*4]
 ;ir_index ST 1;

 mov r10d,dword [rax+0]
 cmp r10d,2
 jne cb$Nstd$Ntests1$Ntest_slice$AB$if1511$else
 ;ir_jmp_neq ST 2 cb$Nstd$Ntests1$Ntest_slice$AB$if1511$else;

 mov r10,qword [rbp-48]
 cmp r10,5
 jne cb$Nstd$Ntests1$Ntest_slice$AB$if1511$else
 ;ir_jmp_neq [L1 . 1] 5 cb$Nstd$Ntests1$Ntest_slice$AB$if1511$else;

cb$Nstd$Ntests1$Ntest_slice$AB$if1511$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_slice$AB$if1511$body;

 lea rax,[$cbstr43]
 ;ir_load_addr STR43;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_slice$AB$if1511$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_slice$AB$if1511$end;

cb$Nstd$Ntests1$Ntest_slice$AB$if1511$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_slice$AB$if1511$else;

 lea rax,[$cbstr44]
 ;ir_load_addr STR44;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_slice$AB$if1511$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_slice$AB$if1511$end;

cb$Nstd$Ntests1$Ntest_slice$AB$end:
 add rsp,80
 pop rbp
 ret


cb$Nstd$Ntests1$Ntest_mutable_slice$AB:
 ;func test_mutable_slice(): {}
 push rbp
 mov rbp,rsp
 sub rsp,96
 ;prolog end

 mov r10,0
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 0;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,1
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 1;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,2
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 2;

 mov r10d,1
 mov dword [rax+0],r10d
 ;ir_load ST 1;

 mov r10,3
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 3;

 mov r10d,2
 mov dword [rax+0],r10d
 ;ir_load ST 2;

 mov r10,4
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 4;

 mov r10d,3
 mov dword [rax+0],r10d
 ;ir_load ST 3;

 mov r10,5
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 5;

 mov r10d,4
 mov dword [rax+0],r10d
 ;ir_load ST 4;

 mov r10,6
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 6;

 mov r10d,5
 mov dword [rax+0],r10d
 ;ir_load ST 5;

 mov r10,7
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 7;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,8
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 8;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,9
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 9;

 mov r10d,0
 mov dword [rax+0],r10d
 ;ir_load ST 0;

 mov r10,2
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 2;

 lea rax,dword [rax+0]
 ;ir_load_addr ST;

 mov qword [rbp-56],rax
 ;ir_load [L1 . 0] ST;

 mov r10d,7
 sub r10d,2
 mov eax,r10d
 ;ir_sub 7 2;

 movsxd rax,eax
 ;ir_cast ST;

 mov qword [rbp-48],rax
 ;ir_load [L1 . 1] ST;

 mov r10,0
 lea rax,qword [rbp-40+r10*4]
 ;ir_index L0 0;

 lea rax,dword [rax+0]
 ;ir_load_addr ST;

 mov qword [rbp-72],rax
 ;ir_load [L2 . 0] ST;

 mov r10d,7
 sub r10d,0
 mov eax,r10d
 ;ir_sub 7 0;

 movsxd rax,eax
 ;ir_cast ST;

 mov qword [rbp-64],rax
 ;ir_load [L2 . 1] ST;

 mov rax,qword [rbp-56]
 ;ir_deref [L1 . 0];

 mov r10,0
 lea rax,dword [rax+r10*4]
 ;ir_index ST 0;

 mov r10d,3
 mov dword [rax+0],r10d
 ;ir_load ST 3;

 mov rax,qword [rbp-72]
 ;ir_deref [L2 . 0];

 mov r10,2
 lea rax,dword [rax+r10*4]
 ;ir_index ST 2;

 mov r10d,10
 mov dword [rax+0],r10d
 ;ir_load ST 10;

 mov rax,qword [rbp-72]
 ;ir_deref [L2 . 0];

 mov r10,3
 lea rax,dword [rax+r10*4]
 ;ir_index ST 3;

 mov r10d,20
 mov dword [rax+0],r10d
 ;ir_load ST 20;

 mov rax,qword [rbp-56]
 ;ir_deref [L1 . 0];

 mov r10,0
 lea rax,dword [rax+r10*4]
 ;ir_index ST 0;

 mov r10d,dword [rax+0]
 cmp r10d,10
 jne cb$Nstd$Ntests1$Ntest_mutable_slice$AB$if1609$else
 ;ir_jmp_neq ST 10 cb$Nstd$Ntests1$Ntest_mutable_slice$AB$if1609$else;

 mov rax,qword [rbp-56]
 ;ir_deref [L1 . 0];

 mov r10,1
 lea rax,dword [rax+r10*4]
 ;ir_index ST 1;

 mov r10d,dword [rax+0]
 cmp r10d,20
 jne cb$Nstd$Ntests1$Ntest_mutable_slice$AB$if1609$else
 ;ir_jmp_neq ST 20 cb$Nstd$Ntests1$Ntest_mutable_slice$AB$if1609$else;

 mov r10,qword [rbp-48]
 cmp r10,5
 jne cb$Nstd$Ntests1$Ntest_mutable_slice$AB$if1609$else
 ;ir_jmp_neq [L1 . 1] 5 cb$Nstd$Ntests1$Ntest_mutable_slice$AB$if1609$else;

 mov r10,qword [rbp-64]
 cmp r10,7
 jne cb$Nstd$Ntests1$Ntest_mutable_slice$AB$if1609$else
 ;ir_jmp_neq [L2 . 1] 7 cb$Nstd$Ntests1$Ntest_mutable_slice$AB$if1609$else;

cb$Nstd$Ntests1$Ntest_mutable_slice$AB$if1609$body:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_mutable_slice$AB$if1609$body;

 lea rax,[$cbstr45]
 ;ir_load_addr STR45;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

 jmp cb$Nstd$Ntests1$Ntest_mutable_slice$AB$if1609$end
 ;ir_jmp cb$Nstd$Ntests1$Ntest_mutable_slice$AB$if1609$end;

cb$Nstd$Ntests1$Ntest_mutable_slice$AB$if1609$else:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_mutable_slice$AB$if1609$else;

 lea rax,[$cbstr46]
 ;ir_load_addr STR46;

 mov rcx,rax
 call cb$Nstd$Nio$Nprintln$AB$Araw_string
 ;ir_call cb$Nstd$Nio$Nprintln$AB$Araw_string ST;

cb$Nstd$Ntests1$Ntest_mutable_slice$AB$if1609$end:
 ;ir_make_label cb$Nstd$Ntests1$Ntest_mutable_slice$AB$if1609$end;

cb$Nstd$Ntests1$Ntest_mutable_slice$AB$end:
 add rsp,96
 pop rbp
 ret


cb$Nstd$Ntests1$Nget_result$AB:
 ;func get_result(): int
 sub rsp,8
 ;prolog end

 mov eax,2
 ;ir_return 2;

cb$Nstd$Ntests1$Nget_result$AB$end:
 add rsp,8
 ret


main:
 ;func main(): int
 push rbp
 push rbx
 push rdi
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov r10d,0
 mov dword [rbp-16],r10d
 ;ir_load [L0 . 0] 0;

 mov r10d,0
 mov dword [rbp-12],r10d
 ;ir_load [L0 . 1] 0;

 lea rax,[$cbstr19]
 ;ir_load_addr STR19;

 mov qword [rbp-8],rax
 ;ir_load [L0 . 2] ST;

 mov r10d,3
 mov dword [rbp-16],r10d
 ;ir_load [L0 . 0] 3;

 mov r10d,1023
 mov dword [rbp-12],r10d
 ;ir_load [L0 . 1] 1023;

 lea rax,[$cbstr47]
 ;ir_load_addr STR47;

 mov qword [rbp-8],rax
 ;ir_load [L0 . 2] ST;

 call cb$Nstd$Ntests1$Ntest_longfunc$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_longfunc$AB;

 call cb$Nstd$Ntests1$Ntest_strcopy_len$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_strcopy_len$AB;

 call cb$Nstd$Ntests1$Ntest_strcopy$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_strcopy$AB;

 call cb$Nstd$Ntests1$Ntest_strcopy_saving$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_strcopy_saving$AB;

 call cb$Nstd$Ntests1$Ntest_while_statement$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_while_statement$AB;

 call cb$Nstd$Ntests1$Ntest_for_stmt$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_for_stmt$AB;

 call cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_tuple_zeroinit$AB;

 call cb$Nstd$Ntests1$Ntest_tuple_init$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_tuple_init$AB;

 call cb$Nstd$Ntests1$Ntest_array_zeroinit$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_array_zeroinit$AB;

 call cb$Nstd$Ntests1$Ntest_array_init$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_array_init$AB;

 call cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_tuple_assignment_lvalue$AB;

 call cb$Nstd$Ntests1$Ntest_tuple_argument$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_tuple_argument$AB;

 call cb$Nstd$Ntests1$Ntest_tuple_return_value$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_tuple_return_value$AB;

 call cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_array_assignment_lvalue$AB;

 call cb$Nstd$Ntests1$Ntest_array_argument$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_array_argument$AB;

 call cb$Nstd$Ntests1$Ntest_array_return_value$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_array_return_value$AB;

 call cb$Nstd$Ntests1$Ntest_slice$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_slice$AB;

 call cb$Nstd$Ntests1$Ntest_mutable_slice$AB
 ;ir_call cb$Nstd$Ntests1$Ntest_mutable_slice$AB;

 lea rax,[$cbstr48]
 ;ir_load_addr STR48;

 mov qword [rbp-24],rax
 ;ir_load L1 ST;

 lea rax,[$cbstr49]
 ;ir_load_addr STR49;

 mov qword [rbp-32],rax
 ;ir_load L2 ST;

 mov rbx,qword [rbp-24]
 ;ir_deref L1;

 mov rdi,qword [rbp-32]
 ;ir_deref L2;

 call cb$Nstd$Ntests1$Nget_result$AB
 ;ir_call cb$Nstd$Ntests1$Nget_result$AB;

 movsxd r10,eax
 lea rax,byte [rdi+r10*1]
 ;ir_index ST ST;

 movsx r10,byte [rax+0]
 lea rax,byte [rbx+r10*1]
 ;ir_index ST ST;

 movsx eax,byte [rax+0]
 ;ir_return ST;

main$end:
 add rsp,32
 pop rdi
 pop rbx
 pop rbp
 ret


