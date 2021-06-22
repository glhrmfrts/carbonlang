global cb__Nmain__Nmain__Aref__Tslice__TU_String
global cb__Ninit__Ninit_command_line__Aref__Tmut_slice__TU_String
global cb__Ninit__Nfree_command_line__Aref__Tmut_slice__TU_String
global carbon_main
global cb__Nstd__Nalloc__Nalloc__Ausize
global cb__Nstd__Nalloc__Nfree__Araw_ptr
global cb__Nstd__Nalloc__Ncopy__Araw_ptr__Araw_ptr__Ausize
global cb__Nstd__Nalloc__Nset__Araw_ptr__Achar__Ausize
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
$cbstr0: db 110,105,99,101,0
$cbstr1: db 115,101,99,111,110,100,0
$cbstr2: db 91,79,75,93,32,116,101,115,116,95,116,117,112,108,101,95,105,110,105,116,0
$cbstr3: db 91,78,79,75,93,32,116,101,115,116,95,116,117,112,108,101,95,105,110,105,116,0
section .code
cb__Nmain__Nmain__Aref__Tslice__TU_String:
 ;func main([*]String): int
 mov qword [rsp+8],rcx
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

 lea rax,[$cbstr0]
 ;ir_load_addr STR0;

 mov qword [rbp-40],rax
 ;ir_load [L1 . 0] ST;

 lea rax,[$cbstr1]
 ;ir_load_addr STR1;

 mov qword [rbp-32],rax
 ;ir_load [L1 . 1] ST;

 mov r10b,0
 mov byte [rbp-24],r10b
 ;ir_load [L1 . 2] 0;

 mov r10d,dword [rbp-12]
 cmp r10d,3
 jne cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$else
 ;ir_jmp_neq [L0 . 0] 3 cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$else;

 mov r10d,dword [rbp-8]
 cmp r10d,4
 jne cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$else
 ;ir_jmp_neq [L0 . 1] 4 cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$else;

 mov r10d,dword [rbp-4]
 cmp r10d,5
 jne cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$else
 ;ir_jmp_neq [L0 . 2] 5 cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$else;

 lea rax,[$cbstr0]
 ;ir_load_addr STR0;

 mov rdx,rax
 mov rcx,qword [rbp-40]
 call cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar
 ;ir_call cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar [L1 . 0] ST;

 cmp al,0
 je cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$else
 ;ir_jmp_eq ST 0 cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$else;

 lea rax,[$cbstr1]
 ;ir_load_addr STR1;

 mov rdx,rax
 mov rcx,qword [rbp-32]
 call cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar
 ;ir_call cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar [L1 . 1] ST;

 cmp al,0
 je cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$else
 ;ir_jmp_eq ST 0 cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$else;

 mov r10b,byte [rbp-24]
 cmp r10b,0
 jne cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$else
 ;ir_jmp_neq [L1 . 2] 0 cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$else;

cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$body:
 ;ir_make_label cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$body;

 lea rax,[$cbstr2]
 ;ir_load_addr STR2;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__Aptr__Tchar
 ;ir_call cb__Nstd__Nio__Nprintln__Aptr__Tchar ST;

 mov eax,1
 jmp cb__Nmain__Nmain__Aref__Tslice__TU_String$end
 ;ir_return 1;

 jmp cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$end
 ;ir_jmp cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$end;

cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$else:
 ;ir_make_label cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$else;

 lea rax,[$cbstr3]
 ;ir_load_addr STR3;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__Aptr__Tchar
 ;ir_call cb__Nstd__Nio__Nprintln__Aptr__Tchar ST;

 mov eax,0
 jmp cb__Nmain__Nmain__Aref__Tslice__TU_String$end
 ;ir_return 0;

cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$end:
 ;ir_make_label cb__Nmain__Nmain__Aref__Tslice__TU_String$if85$end;

cb__Nmain__Nmain__Aref__Tslice__TU_String$end:
 add rsp,64
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
 call cb__Nstd__Nalloc__Nfree__Araw_ptr
 ;ir_call cb__Nstd__Nalloc__Nfree__Araw_ptr [ST . 0];

cb__Ninit__Nfree_command_line__Aref__Tmut_slice__TU_String$end:
 add rsp,16
 pop rbp
 ret


carbon_main:
 ;func carbon_main(): int
 push rbp
 mov rbp,rsp
 sub rsp,80
 ;prolog end

 lea rax,qword [rbp-16]
 ;ir_load_addr L0;

 mov rcx,rax
 call cb__Ninit__Ninit_command_line__Aref__Tmut_slice__TU_String
 ;ir_call cb__Ninit__Ninit_command_line__Aref__Tmut_slice__TU_String ST;

 push rdi
 push rsi
 lea rdi,qword [rbp-56]
 lea rsi,qword [rbp-16]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L3 L0 16;

 lea rax,qword [rbp-56]
 ;ir_load_addr L3;

 mov rcx,rax
 call cb__Nmain__Nmain__Aref__Tslice__TU_String
 ;ir_call cb__Nmain__Nmain__Aref__Tslice__TU_String ST;

 mov dword [rbp-20],eax
 ;ir_load L1 ST;

 push rdi
 push rsi
 lea rdi,qword [rbp-40]
 lea rsi,qword [rbp-16]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L2 L0 16;

 lea rax,qword [rbp-40]
 ;ir_load_addr L2;

 mov rcx,rax
 call cb__Ninit__Nfree_command_line__Aref__Tmut_slice__TU_String
 ;ir_call cb__Ninit__Nfree_command_line__Aref__Tmut_slice__TU_String ST;

 mov eax,dword [rbp-20]
 ;ir_return L1;

carbon_main$end:
 add rsp,80
 pop rbp
 ret


cb__Nstd__Nalloc__Nalloc__Ausize:
 ;func alloc(usize): raw_ptr
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


cb__Nstd__Nalloc__Nfree__Araw_ptr:
 ;func free(raw_ptr): {}
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

cb__Nstd__Nalloc__Nfree__Araw_ptr$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nalloc__Ncopy__Araw_ptr__Araw_ptr__Ausize:
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
    
cb__Nstd__Nalloc__Ncopy__Araw_ptr__Araw_ptr__Ausize$end:
 pop rbp
 ret


cb__Nstd__Nalloc__Nset__Araw_ptr__Achar__Ausize:
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
    
cb__Nstd__Nalloc__Nset__Araw_ptr__Achar__Ausize$end:
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
 call cb__Nstd__Nalloc__Ncopy__Araw_ptr__Araw_ptr__Ausize
 ;ir_call cb__Nstd__Nalloc__Ncopy__Araw_ptr__Araw_ptr__Ausize A0 A1 A2;

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
 call cb__Nstd__Nalloc__Nset__Araw_ptr__Achar__Ausize
 ;ir_call cb__Nstd__Nalloc__Nset__Araw_ptr__Achar__Ausize A0 A1 A2;

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

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w662$cond:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w662$cond;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 movsx eax,byte [rax]
 ;ir_cast ST;

 cmp eax,0
 je cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w662$end
 ;ir_jmp_eq ST 0 cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w662$end;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w662$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w662$body;

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

 jmp cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w662$cond
 ;ir_jmp cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w662$cond;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w662$end:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w662$end;

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
 push rbx
 mov rbp,rsp
 sub rsp,56
 ;prolog end

 mov rcx,qword [rbp+24]
 call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar
 mov rbx,rax
 ;ir_call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar A0;

 mov rcx,qword [rbp+32]
 call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar
 ;ir_call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar A1;

 cmp rbx,rax
 je cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if694$else
 ;ir_jmp_eq ST ST cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if694$else;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if694$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if694$body;

 mov al,0
 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$end
 ;ir_return 0;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if694$else:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if694$else;

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

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f718$cond:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f718$cond;

 movsxd rax,dword [rbp-24]
 ;ir_cast L2;

 cmp rax,qword [rbp-12]
 jge cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f718$end
 ;ir_jmp_gte ST [L0 . 1] cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f718$end;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f718$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f718$body;

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
 je cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if715$else
 ;ir_jmp_eq ST ST cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if715$else;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if715$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if715$body;

 mov al,0
 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$end
 ;ir_return 0;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if715$else:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if715$else;

 mov r10d,dword [rbp-24]
 add r10d,1
 mov eax,r10d
 ;ir_add L2 1;

 mov dword [rbp-24],eax
 ;ir_load L2 ST;

 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f718$cond
 ;ir_jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f718$cond;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f718$end:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f718$end;

 mov al,1
 ;ir_return 1;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$end:
 add rsp,56
 pop rbx
 pop rbp
 ret


cb__Nstd__Ntests1__Nok:
 ;func ok(): {}
 sub rsp,8
 ;prolog end

cb__Nstd__Ntests1__Nok$end:
 add rsp,8
 ret


