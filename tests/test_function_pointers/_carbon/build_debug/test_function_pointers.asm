global cb__Nmain__Nmain__Aref__Tslice__TU_String
global cb__Nmain__Nsquare__Aint
global cb__Nmain__Nidentity__Aint
global cb__Ninit__Ninit_command_line__Aref__Tmut_slice__TU_String
global cb__Ninit__Nfree_command_line__Aref__Tmut_slice__TU_String
global carbon_main
global cb__Nstd__Nalloc__Nalloc__Ausize
global cb__Nstd__Nalloc__Nfree__Arawptr
global cb__Nstd__Nalloc__Ncopy__Arawptr__Arawptr__Ausize
global cb__Nstd__Nalloc__Nset__Arawptr__Achar__Ausize
global cb__Nstd__Nio__Nprintln__Aptr__Tchar
extern puts
extern putc
extern exit
extern free
extern malloc
extern rand
extern system
extern strlen
extern HeapAlloc
extern HeapFree
extern GetProcessHeap
extern GetCommandLineA
global cb__Nstd__Nrawstring__Ncopy__Aptr__Tchar
global cb__Nstd__Nrawstring__Ncopy__Aptr__Tchar__Ausize
global cb__Nstd__Nrawstring__Ncopy__Aptr__Tchar__Aptr__Tchar__Ausize
global cb__Nstd__Nrawstring__Nset__Aptr__Tchar__Achar__Ausize
global cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar
global cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar
global cb__Nstd__Ntests1__Nok
section .data
$cbstr0: db 91,79,75,93,32,116,101,115,116,95,102,117,110,99,116,105,111,110,95,112,111,105,110,116,101,114,115,0
$cbstr1: db 91,78,79,75,93,32,116,101,115,116,95,102,117,110,99,116,105,111,110,95,112,111,105,110,116,101,114,115,0
$cbstr2: db 102,114,111,109,32,115,113,117,97,114,101,0
$cbstr3: db 102,114,111,109,32,105,100,101,110,116,105,116,121,0
section .code
cb__Nmain__Nmain__Aref__Tslice__TU_String:
 ;func main([*]String): int
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov rax,qword [rbp+16]
 ;ir_deref A0;

 mov rax,qword [rax+0]
 ;ir_deref [ST . 0];

 mov r10,0
 imul r10,16
 lea rax,qword [rax+r10*1]
 ;ir_index ST 0;

 mov rcx,qword [rax+0+0]
 call cb__Nstd__Nio__Nprintln__Aptr__Tchar
 ;ir_call cb__Nstd__Nio__Nprintln__Aptr__Tchar [ST . 0];

 lea rax,[cb__Nmain__Nsquare__Aint]
 ;ir_load_addr func(cb__Nmain__Nsquare__Aint);

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 mov ecx,5
 mov rax,qword [rbp-8]
 call rax
 ;ir_call L0 5;

 mov dword [rbp-12],eax
 ;ir_load L1 ST;

 lea rax,[cb__Nmain__Nidentity__Aint]
 ;ir_load_addr func(cb__Nmain__Nidentity__Aint);

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 mov ecx,10
 mov rax,qword [rbp-8]
 call rax
 ;ir_call L0 10;

 mov dword [rbp-16],eax
 ;ir_load L2 ST;

 mov r10d,dword [rbp-12]
 cmp r10d,25
 jne cb__Nmain__Nmain__Aref__Tslice__TU_String$if93$else
 ;ir_jmp_neq L1 25 cb__Nmain__Nmain__Aref__Tslice__TU_String$if93$else;

 mov r10d,dword [rbp-16]
 cmp r10d,10
 jne cb__Nmain__Nmain__Aref__Tslice__TU_String$if93$else
 ;ir_jmp_neq L2 10 cb__Nmain__Nmain__Aref__Tslice__TU_String$if93$else;

cb__Nmain__Nmain__Aref__Tslice__TU_String$if93$body:
 ;ir_make_label cb__Nmain__Nmain__Aref__Tslice__TU_String$if93$body;

 lea rax,[$cbstr0]
 ;ir_load_addr STR0;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__Aptr__Tchar
 ;ir_call cb__Nstd__Nio__Nprintln__Aptr__Tchar ST;

 jmp cb__Nmain__Nmain__Aref__Tslice__TU_String$if93$end
 ;ir_jmp cb__Nmain__Nmain__Aref__Tslice__TU_String$if93$end;

cb__Nmain__Nmain__Aref__Tslice__TU_String$if93$else:
 ;ir_make_label cb__Nmain__Nmain__Aref__Tslice__TU_String$if93$else;

 lea rax,[$cbstr1]
 ;ir_load_addr STR1;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__Aptr__Tchar
 ;ir_call cb__Nstd__Nio__Nprintln__Aptr__Tchar ST;

cb__Nmain__Nmain__Aref__Tslice__TU_String$if93$end:
 ;ir_make_label cb__Nmain__Nmain__Aref__Tslice__TU_String$if93$end;

 mov eax,0
 ;ir_return 0;

cb__Nmain__Nmain__Aref__Tslice__TU_String$end:
 add rsp,32
 pop rbp
 ret


cb__Nmain__Nsquare__Aint:
 ;func square(int): int
 mov dword [rsp+8],ecx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov r10d,dword [rbp+16]
 imul r10d,dword [rbp+16]
 mov eax,r10d
 ;ir_mul A0 A0;

 mov dword [rbp-4],eax
 ;ir_load L0 ST;

 lea rax,[$cbstr2]
 ;ir_load_addr STR2;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__Aptr__Tchar
 ;ir_call cb__Nstd__Nio__Nprintln__Aptr__Tchar ST;

 mov eax,dword [rbp-4]
 ;ir_return L0;

cb__Nmain__Nsquare__Aint$end:
 add rsp,32
 pop rbp
 ret


cb__Nmain__Nidentity__Aint:
 ;func identity(int): int
 mov dword [rsp+8],ecx
 push rbp
 mov rbp,rsp
 sub rsp,16
 ;prolog end

 lea rax,[$cbstr3]
 ;ir_load_addr STR3;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__Aptr__Tchar
 ;ir_call cb__Nstd__Nio__Nprintln__Aptr__Tchar ST;

 mov eax,dword [rbp+16]
 ;ir_return A0;

cb__Nmain__Nidentity__Aint$end:
 add rsp,16
 pop rbp
 ret


cb__Ninit__Ninit_command_line__Aref__Tmut_slice__TU_String:
 ;func init_command_line(&[&]String): &[&]String
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,72
 ;prolog end

 call GetCommandLineA
 ;ir_call GetCommandLineA;

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 mov ecx,16
 call cb__Nstd__Nalloc__Nalloc__Ausize
 ;ir_call cb__Nstd__Nalloc__Nalloc__Ausize 16;

 mov qword [rbp-16],rax
 ;ir_load L1 ST;

 mov r10,qword [rbp-16]
 mov qword [rbp-32],r10
 ;ir_load [L2 . 0] L1;

 mov r10d,1
 mov qword [rbp-24],r10
 ;ir_load [L2 . 1] 1;

 mov rax,qword [rbp-32]
 ;ir_deref [L2 . 0];

 mov r10,0
 imul r10,16
 lea rax,qword [rax+r10*1]
 ;ir_index ST 0;

 mov r10,qword [rbp-8]
 mov qword [rax+0+0],r10
 ;ir_load [ST . 0] L0;

 mov rax,qword [rbp-32]
 ;ir_deref [L2 . 0];

 mov r10,0
 imul r10,16
 lea rbx,qword [rax+r10*1]
 ;ir_index ST 0;

 mov rcx,qword [rbp-8]
 call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar
 ;ir_call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar L0;

 mov qword [rbx+0+8],rax
 ;ir_load [ST . 1] ST;

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 push rdi
 push rsi
 lea rdi,qword [rax]
 lea rsi,qword [rbp-32]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy ST L2 16;

 mov rax,qword [rbp+24]
 ;ir_return A0;

cb__Ninit__Ninit_command_line__Aref__Tmut_slice__TU_String$end:
 add rsp,72
 pop rbx
 pop rbp
 ret


cb__Ninit__Nfree_command_line__Aref__Tmut_slice__TU_String:
 ;func free_command_line([&]String): {}
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,16
 ;prolog end

 mov rax,qword [rbp+16]
 ;ir_deref A0;

 mov rcx,qword [rax+0]
 call cb__Nstd__Nalloc__Nfree__Arawptr
 ;ir_call cb__Nstd__Nalloc__Nfree__Arawptr [ST . 0];

cb__Ninit__Nfree_command_line__Aref__Tmut_slice__TU_String$end:
 add rsp,16
 pop rbp
 ret


carbon_main:
 ;func carbon_main(): int
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,72
 ;prolog end

 lea rax,qword [rbp-16]
 ;ir_load_addr L0;

 mov rcx,rax
 call cb__Ninit__Ninit_command_line__Aref__Tmut_slice__TU_String
 ;ir_call cb__Ninit__Ninit_command_line__Aref__Tmut_slice__TU_String ST;

 push rdi
 push rsi
 lea rdi,qword [rbp-48]
 lea rsi,qword [rbp-16]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L2 L0 16;

 lea rax,qword [rbp-48]
 ;ir_load_addr L2;

 mov rcx,rax
 call cb__Nmain__Nmain__Aref__Tslice__TU_String
 mov ebx,eax
 ;ir_call cb__Nmain__Nmain__Aref__Tslice__TU_String ST;

 push rdi
 push rsi
 lea rdi,qword [rbp-32]
 lea rsi,qword [rbp-16]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L1 L0 16;

 lea rax,qword [rbp-32]
 ;ir_load_addr L1;

 mov rcx,rax
 call cb__Ninit__Nfree_command_line__Aref__Tmut_slice__TU_String
 ;ir_call cb__Ninit__Nfree_command_line__Aref__Tmut_slice__TU_String ST;

 mov eax,ebx
 ;ir_return ST;

carbon_main$end:
 add rsp,72
 pop rbx
 pop rbp
 ret


cb__Nstd__Nalloc__Nalloc__Ausize:
 ;func alloc(usize): rawptr
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 call GetProcessHeap
 ;ir_call GetProcessHeap;

 mov r8,qword [rbp+16]
 mov edx,0
 mov ecx,eax
 call HeapAlloc
 ;ir_call HeapAlloc ST 0 A0;

 ;ir_return ST;

cb__Nstd__Nalloc__Nalloc__Ausize$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nalloc__Nfree__Arawptr:
 ;func free(rawptr): {}
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 call GetProcessHeap
 ;ir_call GetProcessHeap;

 mov r8,qword [rbp+16]
 mov edx,0
 mov ecx,eax
 call HeapFree
 ;ir_call HeapFree ST 0 A0;

 ;ir_noop ST;

cb__Nstd__Nalloc__Nfree__Arawptr$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nalloc__Ncopy__Arawptr__Arawptr__Ausize:
 ;func copy(rawptr, rawptr, usize): {}
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
    
cb__Nstd__Nalloc__Ncopy__Arawptr__Arawptr__Ausize$end:
 pop rbp
 ret


cb__Nstd__Nalloc__Nset__Arawptr__Achar__Ausize:
 ;func set(rawptr, char, usize): {}
 push rbp
 mov rbp,rsp
 ;prolog end

push rdi

mov rdi,rcx
mov rax,rdx
mov rcx,r8
rep stosb

pop rdi
    
cb__Nstd__Nalloc__Nset__Arawptr__Achar__Ausize$end:
 pop rbp
 ret


cb__Nstd__Nio__Nprintln__Aptr__Tchar:
 ;func println(*char): {}
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov rcx,qword [rbp+16]
 call puts
 ;ir_call puts A0;

 ;ir_noop ST;

cb__Nstd__Nio__Nprintln__Aptr__Tchar$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nrawstring__Ncopy__Aptr__Tchar:
 ;func copy(*char): *char
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,16
 ;prolog end

 mov rcx,qword [rbp+16]
 call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar
 ;ir_call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar A0;

 mov rdx,rax
 mov rcx,qword [rbp+16]
 call cb__Nstd__Nrawstring__Ncopy__Aptr__Tchar__Ausize
 ;ir_call cb__Nstd__Nrawstring__Ncopy__Aptr__Tchar__Ausize A0 ST;

 ;ir_return ST;

cb__Nstd__Nrawstring__Ncopy__Aptr__Tchar$end:
 add rsp,16
 pop rbp
 ret


cb__Nstd__Nrawstring__Ncopy__Aptr__Tchar__Ausize:
 ;func copy(*char, usize): *char
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
 call cb__Nstd__Nalloc__Nalloc__Ausize
 ;ir_call cb__Nstd__Nalloc__Nalloc__Ausize ST;

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 mov r8,qword [rbp+24]
 mov rdx,qword [rbp+16]
 mov rcx,qword [rbp-8]
 call cb__Nstd__Nrawstring__Ncopy__Aptr__Tchar__Aptr__Tchar__Ausize
 ;ir_call cb__Nstd__Nrawstring__Ncopy__Aptr__Tchar__Aptr__Tchar__Ausize L0 A0 A1;

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

cb__Nstd__Nrawstring__Ncopy__Aptr__Tchar__Ausize$end:
 add rsp,48
 pop rbp
 ret


cb__Nstd__Nrawstring__Ncopy__Aptr__Tchar__Aptr__Tchar__Ausize:
 ;func copy(*char, *char, usize): {}
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
 call cb__Nstd__Nalloc__Ncopy__Arawptr__Arawptr__Ausize
 ;ir_call cb__Nstd__Nalloc__Ncopy__Arawptr__Arawptr__Ausize A0 A1 A2;

cb__Nstd__Nrawstring__Ncopy__Aptr__Tchar__Aptr__Tchar__Ausize$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nrawstring__Nset__Aptr__Tchar__Achar__Ausize:
 ;func set(*char, char, usize): {}
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
 call cb__Nstd__Nalloc__Nset__Arawptr__Achar__Ausize
 ;ir_call cb__Nstd__Nalloc__Nset__Arawptr__Achar__Ausize A0 A1 A2;

cb__Nstd__Nrawstring__Nset__Aptr__Tchar__Achar__Ausize$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar:
 ;func strlen(*char): usize
 push rbp
 mov rbp,rsp
 sub rsp,16
 ;prolog end

 mov r10d,0
 mov qword [rbp-8],r10
 ;ir_load L0 0;

 mov qword [rbp-16],rcx
 ;ir_load L1 A0;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w678$cond:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w678$cond;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 movsx eax,byte [rax]
 ;ir_cast ST;

 cmp eax,0
 je cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w678$end
 ;ir_jmp_eq ST 0 cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w678$end;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w678$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w678$body;

 mov r10,qword [rbp-16]
 add r10,1
 mov rax,r10
 ;ir_add L1 1;

 mov qword [rbp-16],rax
 ;ir_load L1 ST;

 mov r10,qword [rbp-8]
 add r10,1
 mov rax,r10
 ;ir_add L0 1;

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 jmp cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w678$cond
 ;ir_jmp cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w678$cond;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w678$end:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w678$end;

 mov rax,qword [rbp-8]
 ;ir_return L0;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$end:
 add rsp,16
 pop rbp
 ret


cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar:
 ;func equals(*char, *char): bool
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 push rdi
 mov rbp,rsp
 sub rsp,56
 ;prolog end

 mov rcx,qword [rbp+24]
 call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar
 mov rdi,rax
 ;ir_call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar A0;

 mov rcx,qword [rbp+32]
 call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar
 ;ir_call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar A1;

 cmp rdi,rax
 je cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if710$else
 ;ir_jmp_eq ST ST cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if710$else;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if710$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if710$body;

 mov al,0
 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$end
 ;ir_return 0;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if710$else:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if710$else;

 mov r10d,0
 mov dword [rbp-16],r10d
 ;ir_load [L0 . 0] 0;

 mov rcx,qword [rbp+24]
 call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar
 ;ir_call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar A0;

 mov qword [rbp-12],rax
 ;ir_load [L0 . 1] ST;

 mov r10d,dword [rbp-16]
 mov dword [rbp-24],r10d
 ;ir_load L2 [L0 . 0];

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f734$cond:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f734$cond;

 movsxd rax,dword [rbp-24]
 ;ir_cast L2;

 cmp rax,qword [rbp-12]
 jge cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f734$end
 ;ir_jmp_gte ST [L0 . 1] cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f734$end;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f734$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f734$body;

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 movsxd r10,dword [rbp-24]
 lea rdi,byte [rax+r10*1]
 ;ir_index ST L2;

 mov rax,qword [rbp+32]
 ;ir_deref A1;

 movsxd r10,dword [rbp-24]
 lea rax,byte [rax+r10*1]
 ;ir_index ST L2;

 mov r10b,byte [rdi+0]
 cmp r10b,byte [rax+0]
 je cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if731$else
 ;ir_jmp_eq ST ST cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if731$else;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if731$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if731$body;

 mov al,0
 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$end
 ;ir_return 0;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if731$else:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if731$else;

 mov r10d,dword [rbp-24]
 add r10d,1
 mov eax,r10d
 ;ir_add L2 1;

 mov dword [rbp-24],eax
 ;ir_load L2 ST;

 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f734$cond
 ;ir_jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f734$cond;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f734$end:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f734$end;

 mov al,1
 ;ir_return 1;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$end:
 add rsp,56
 pop rdi
 pop rbp
 ret


cb__Nstd__Ntests1__Nok:
 ;func ok(): {}
 sub rsp,8
 ;prolog end

cb__Nstd__Ntests1__Nok$end:
 add rsp,8
 ret


