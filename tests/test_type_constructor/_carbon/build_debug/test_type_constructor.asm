global cb__Nmain__Nmain__Aptr__Tslice__TU_string
global cb__Nmain__Nmake_array__int__Aptr__TU_array__Tint__Ausize
global cb__Nmain__Nappend__Aptr__TU_array__Tint__Aint
global cb__Nmain__Nnth__Aptr__TU_array__Tint__Ausize
global cb__Nmain__Ndispose__Aptr__TU_array__Tint
global cb__Ninit__Ninit_command_line__Aptr__Tslice__TU_string
global cb__Ninit__Nfree_command_line__Aptr__Tslice__TU_string
global carbon_main
global cb__Nstd__Nalloc__Nalloc__Ausize
global cb__Nstd__Nalloc__Nfree__Apointer
global cb__Nstd__Nalloc__Ncopy__Apointer__Apointer__Ausize
global cb__Nstd__Nalloc__Nset__Apointer__Achar__Ausize
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
section .code
cb__Nmain__Nmain__Aptr__Tslice__TU_string:
 ;func main([]string): int
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,88
 ;prolog end

 mov rax,qword [rbp+24]
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

 lea rax,qword [rbp-24]
 ;ir_load_addr L0;

 mov edx,10
 mov rcx,rax
 call cb__Nmain__Nmake_array__int__Aptr__TU_array__Tint__Ausize
 ;ir_call cb__Nmain__Nmake_array__int__Aptr__TU_array__Tint__Ausize ST 10;

 lea rax,qword [rbp-48]
 ;ir_load_addr L1;

 mov edx,10
 mov rcx,rax
 call cb__Nmain__Nmake_array__int__Aptr__TU_array__Tint__Ausize
 ;ir_call cb__Nmain__Nmake_array__int__Aptr__TU_array__Tint__Ausize ST 10;

 mov r10,0
 mov qword [rbp-56],r10
 ;ir_load L2 0;

 lea rax,qword [rbp-24]
 ;ir_load_addr L0;

 mov edx,1
 mov rcx,rax
 call cb__Nmain__Nappend__Aptr__TU_array__Tint__Aint
 ;ir_call cb__Nmain__Nappend__Aptr__TU_array__Tint__Aint ST 1;

 lea rax,qword [rbp-24]
 ;ir_load_addr L0;

 mov edx,2
 mov rcx,rax
 call cb__Nmain__Nappend__Aptr__TU_array__Tint__Aint
 ;ir_call cb__Nmain__Nappend__Aptr__TU_array__Tint__Aint ST 2;

 mov r10,qword [rbp-8]
 mov ebx,r10d
 ;ir_cast [L0 . 2];

 lea rax,qword [rbp-48]
 ;ir_load_addr L1;

 mov rcx,rax
 call cb__Nmain__Ndispose__Aptr__TU_array__Tint
 ;ir_call cb__Nmain__Ndispose__Aptr__TU_array__Tint ST;

 lea rax,qword [rbp-24]
 ;ir_load_addr L0;

 mov rcx,rax
 call cb__Nmain__Ndispose__Aptr__TU_array__Tint
 ;ir_call cb__Nmain__Ndispose__Aptr__TU_array__Tint ST;

 mov eax,ebx
 ;ir_return ST;

cb__Nmain__Nmain__Aptr__Tslice__TU_string$end:
 add rsp,88
 pop rbx
 pop rbp
 ret


cb__Nmain__Nmake_array__int__Aptr__TU_array__Tint__Ausize:
 ;func make_array(&array(int), usize): &array(int)
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,40
 ;prolog end

 mov r10,qword [rbp+32]
 mov qword [rbp-8],r10
 ;ir_load L0 A1;

 mov r10,qword [rbp-8]
 cmp r10,0
 jne cb__Nmain__Nmake_array__int__Aptr__TU_array__Tint__Ausize$if240$else
 ;ir_jmp_neq L0 0 cb__Nmain__Nmake_array__int__Aptr__TU_array__Tint__Ausize$if240$else;

cb__Nmain__Nmake_array__int__Aptr__TU_array__Tint__Ausize$if240$body:
 ;ir_make_label cb__Nmain__Nmake_array__int__Aptr__TU_array__Tint__Ausize$if240$body;

 mov r10d,1
 mov qword [rbp-8],r10
 ;ir_load L0 1;

cb__Nmain__Nmake_array__int__Aptr__TU_array__Tint__Ausize$if240$else:
 ;ir_make_label cb__Nmain__Nmake_array__int__Aptr__TU_array__Tint__Ausize$if240$else;

 mov rbx,qword [rbp+24]
 ;ir_deref A0;

 mov r10,4
 imul r10,qword [rbp-8]
 mov rax,r10
 ;ir_mul 4 L0;

 mov rcx,rax
 call cb__Nstd__Nalloc__Nalloc__Ausize
 ;ir_call cb__Nstd__Nalloc__Nalloc__Ausize ST;

 mov qword [rbx+0],rax
 ;ir_load [ST . 0] ST;

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 mov r10,qword [rbp-8]
 mov qword [rax+8],r10
 ;ir_load [ST . 1] L0;

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 mov r10d,0
 mov qword [rax+16],r10
 ;ir_load [ST . 2] 0;

 mov rax,qword [rbp+24]
 ;ir_return A0;

cb__Nmain__Nmake_array__int__Aptr__TU_array__Tint__Ausize$end:
 add rsp,40
 pop rbx
 pop rbp
 ret


cb__Nmain__Nappend__Aptr__TU_array__Tint__Aint:
 ;func append(&array(int), int): {}
 mov dword [rsp+16],edx
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,24
 ;prolog end

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 mov rdx,qword [rax+16]
 mov rcx,qword [rbp+24]
 call cb__Nmain__Nnth__Aptr__TU_array__Tint__Ausize
 ;ir_call cb__Nmain__Nnth__Aptr__TU_array__Tint__Ausize A0 [ST . 2];

 mov rax,rax
 ;ir_deref ST;

 mov r10d,dword [rbp+32]
 mov dword [rax],r10d
 ;ir_load ST A1;

 mov rbx,qword [rbp+24]
 ;ir_deref A0;

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 mov r10,qword [rax+16]
 add r10,1
 mov rax,r10
 ;ir_add [ST . 2] 1;

 mov qword [rbx+16],rax
 ;ir_load [ST . 2] ST;

cb__Nmain__Nappend__Aptr__TU_array__Tint__Aint$end:
 add rsp,24
 pop rbx
 pop rbp
 ret


cb__Nmain__Nnth__Aptr__TU_array__Tint__Ausize:
 ;func nth(&array(int), usize): &int
 push rbp
 mov rbp,rsp
 ;prolog end

 mov rax,rcx
 ;ir_deref A0;

 mov rax,qword [rax+0]
 ;ir_deref [ST . 0];

 mov r10,rdx
 lea rax,dword [rax+r10*4]
 ;ir_index ST A1;

 lea rax,dword [rax+0]
 ;ir_load_addr ST;

 ;ir_return ST;

cb__Nmain__Nnth__Aptr__TU_array__Tint__Ausize$end:
 pop rbp
 ret


cb__Nmain__Ndispose__Aptr__TU_array__Tint:
 ;func dispose(&array(int)): {}
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,16
 ;prolog end

 mov rax,qword [rbp+16]
 ;ir_deref A0;

 mov rcx,qword [rax+0]
 call cb__Nstd__Nalloc__Nfree__Apointer
 ;ir_call cb__Nstd__Nalloc__Nfree__Apointer [ST . 0];

cb__Nmain__Ndispose__Aptr__TU_array__Tint$end:
 add rsp,16
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

 mov rcx,16
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
 call cb__Nstd__Nalloc__Nfree__Apointer
 ;ir_call cb__Nstd__Nalloc__Nfree__Apointer [ST . 0];

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
 ;func alloc(usize): pointer
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


cb__Nstd__Nalloc__Nfree__Apointer:
 ;func free(pointer): {}
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

cb__Nstd__Nalloc__Nfree__Apointer$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nalloc__Ncopy__Apointer__Apointer__Ausize:
 ;func copy(pointer, pointer, usize): {}
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
    
cb__Nstd__Nalloc__Ncopy__Apointer__Apointer__Ausize$end:
 pop rbp
 ret


cb__Nstd__Nalloc__Nset__Apointer__Achar__Ausize:
 ;func set(pointer, char, usize): {}
 push rbp
 mov rbp,rsp
 ;prolog end

push rdi

mov rdi,rcx
mov rax,rdx
mov rcx,r8
rep stosb

pop rdi
    
cb__Nstd__Nalloc__Nset__Apointer__Achar__Ausize$end:
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
 call cb__Nstd__Nalloc__Ncopy__Apointer__Apointer__Ausize
 ;ir_call cb__Nstd__Nalloc__Ncopy__Apointer__Apointer__Ausize A0 A1 A2;

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
 call cb__Nstd__Nalloc__Nset__Apointer__Achar__Ausize
 ;ir_call cb__Nstd__Nalloc__Nset__Apointer__Achar__Ausize A0 A1 A2;

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

 mov r10,0
 mov qword [rbp-8],r10
 ;ir_load L0 0;

 mov qword [rbp-16],rcx
 ;ir_load L1 A0;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w843$cond:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w843$cond;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 movsx eax,byte [rax]
 ;ir_cast ST;

 cmp eax,0
 je cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w843$end
 ;ir_jmp_eq ST 0 cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w843$end;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w843$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w843$body;

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

 jmp cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w843$cond
 ;ir_jmp cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w843$cond;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w843$end:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tchar$w843$end;

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
 je cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if875$else
 ;ir_jmp_eq ST ST cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if875$else;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if875$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if875$body;

 mov al,0
 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$end
 ;ir_return 0;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if875$else:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if875$else;

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

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f899$cond:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f899$cond;

 movsxd rax,dword [rbp-24]
 ;ir_cast L2;

 cmp rax,qword [rbp-12]
 jge cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f899$end
 ;ir_jmp_gte ST [L0 . 1] cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f899$end;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f899$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f899$body;

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
 je cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if896$else
 ;ir_jmp_eq ST ST cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if896$else;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if896$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if896$body;

 mov al,0
 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$end
 ;ir_return 0;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if896$else:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$if896$else;

 mov r10d,dword [rbp-24]
 add r10d,1
 mov eax,r10d
 ;ir_add L2 1;

 mov dword [rbp-24],eax
 ;ir_load L2 ST;

 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f899$cond
 ;ir_jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f899$cond;

cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f899$end:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tchar__Aptr__Tchar$f899$end;

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


