global cb__Nmain__Nfib__Aint
global cb__Nmain__Nmain__Aptr__Tslice__TU_string
global cb__Ninit__Ninit_command_line__Aptr__Tslice__TU_string
global cb__Ninit__Nfree_command_line__Aptr__Tslice__TU_string
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
$cbstr0: db 104,101,108,108,111,0
$cbstr1: db 101,110,100,101,100,0
section .code
cb__Nmain__Nfib__Aint:
 ;func fib(int): int
 mov dword [rsp+8],ecx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,24
 ;prolog end

 mov r10d,dword [rbp+24]
 cmp r10d,2
 jg cb__Nmain__Nfib__Aint$if50$else
 ;ir_jmp_gt A0 2 cb__Nmain__Nfib__Aint$if50$else;

cb__Nmain__Nfib__Aint$if50$body:
 ;ir_make_label cb__Nmain__Nfib__Aint$if50$body;

 mov eax,1
 jmp cb__Nmain__Nfib__Aint$end
 ;ir_return 1;

cb__Nmain__Nfib__Aint$if50$else:
 ;ir_make_label cb__Nmain__Nfib__Aint$if50$else;

 mov r10d,dword [rbp+24]
 sub r10d,1
 mov eax,r10d
 ;ir_sub A0 1;

 mov ecx,eax
 call cb__Nmain__Nfib__Aint
 mov ebx,eax
 ;ir_call cb__Nmain__Nfib__Aint ST;

 mov r10d,dword [rbp+24]
 sub r10d,2
 mov eax,r10d
 ;ir_sub A0 2;

 mov ecx,eax
 call cb__Nmain__Nfib__Aint
 ;ir_call cb__Nmain__Nfib__Aint ST;

 add ebx,eax
 mov eax,ebx
 ;ir_add ST ST;

 ;ir_return ST;

cb__Nmain__Nfib__Aint$end:
 add rsp,24
 pop rbx
 pop rbp
 ret


cb__Nmain__Nmain__Aptr__Tslice__TU_string:
 ;func main([]string): int
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,24
 ;prolog end

 lea rax,[$cbstr0]
 ;ir_load_addr STR0;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__Aptr__Tchar
 ;ir_call cb__Nstd__Nio__Nprintln__Aptr__Tchar ST;

 mov ecx,39
 call cb__Nmain__Nfib__Aint
 mov ebx,eax
 ;ir_call cb__Nmain__Nfib__Aint 39;

 lea rax,[$cbstr1]
 ;ir_load_addr STR1;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__Aptr__Tchar
 ;ir_call cb__Nstd__Nio__Nprintln__Aptr__Tchar ST;

 mov eax,ebx
 ;ir_return ST;

cb__Nmain__Nmain__Aptr__Tslice__TU_string$end:
 add rsp,24
 pop rbx
 pop rbp
 ret


cb__Ninit__Ninit_command_line__Aptr__Tslice__TU_string:
 ;func init_command_line(&[]string): &[]string
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

cb__Ninit__Ninit_command_line__Aptr__Tslice__TU_string$end:
 add rsp,72
 pop rbx
 pop rbp
 ret


cb__Ninit__Nfree_command_line__Aptr__Tslice__TU_string:
 ;func free_command_line([]string): {}
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

cb__Ninit__Nfree_command_line__Aptr__Tslice__TU_string$end:
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
 call cb__Ninit__Ninit_command_line__Aptr__Tslice__TU_string
 ;ir_call cb__Ninit__Ninit_command_line__Aptr__Tslice__TU_string ST;

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
 call cb__Nmain__Nmain__Aptr__Tslice__TU_string
 mov ebx,eax
 ;ir_call cb__Nmain__Nmain__Aptr__Tslice__TU_string ST;

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
 call cb__Ninit__Nfree_command_line__Aptr__Tslice__TU_string
 ;ir_call cb__Ninit__Nfree_command_line__Aptr__Tslice__TU_string ST;

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
 ;func println(&char): {}
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
 ;func copy(&char): &char
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
 ;func copy(&char, usize): &char
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
 ;func copy(&char, &char, usize): {}
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
 ;func set(&char, char, usize): {}
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
 ;func strlen(&char): usize
 push rbp
 mov rbp,rsp
 sub rsp,16
 ;prolog end

 mov r10d,0
 mov qword [rbp-8],r10
 ;ir_load L0 0;

 mov qword [rbp-16],rcx
 ;ir_load L1 A0;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w636$cond:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w636$cond;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 movsx eax,byte [rax]
 ;ir_cast ST;

 cmp eax,0
 je cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w636$end
 ;ir_jmp_eq ST 0 cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w636$end;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w636$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w636$body;

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

 jmp cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w636$cond
 ;ir_jmp cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w636$cond;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w636$end:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w636$end;

 mov rax,qword [rbp-8]
 ;ir_return L0;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$end:
 add rsp,16
 pop rbp
 ret


cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar:
 ;func equals(&char, &char): bool
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
 je cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if668$else
 ;ir_jmp_eq ST ST cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if668$else;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if668$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if668$body;

 mov al,0
 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$end
 ;ir_return 0;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if668$else:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if668$else;

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

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f692$cond:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f692$cond;

 movsxd rax,dword [rbp-24]
 ;ir_cast L2;

 cmp rax,qword [rbp-12]
 jge cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f692$end
 ;ir_jmp_gte ST [L0 . 1] cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f692$end;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f692$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f692$body;

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
 je cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if689$else
 ;ir_jmp_eq ST ST cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if689$else;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if689$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if689$body;

 mov al,0
 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$end
 ;ir_return 0;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if689$else:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if689$else;

 mov r10d,dword [rbp-24]
 add r10d,1
 mov eax,r10d
 ;ir_add L2 1;

 mov dword [rbp-24],eax
 ;ir_load L2 ST;

 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f692$cond
 ;ir_jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f692$cond;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f692$end:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f692$end;

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


