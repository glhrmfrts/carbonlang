global cb__Nmain__Nmain__Aptr__Tslice__TU_string
global cb__Nmain__Ntest_div__Aint__Aint
global cb__Ninit__Ninit_command_line__Aptr__Tslice__TU_string
global cb__Ninit__Nfree_command_line__Aptr__Tslice__TU_string
global carbon_main
global cb__Nstd__Nalloc__Nalloc__Ausize
global cb__Nstd__Nalloc__Nfree__Apointer
global cb__Nstd__Nalloc__Ncopy__Apointer__Apointer__Ausize
global cb__Nstd__Nalloc__Nset__Apointer__Auint8__Ausize
global cb__Nstd__Nalloc__Nallocn__Cuint8__Ausize
global cb__Nstd__Nalloc__Nallocn__Cstring__Ausize
global cb__Nstd__Nalloc__Nmake_slice__Cstring__Aptr__Tslice__TU_string__Ausize
global cb__Nstd__Nio__Nprintln__Aint
global cb__Nstd__Nio__Nprintln__Abool
global cb__Nstd__Nio__Nprintln__A$rawstring
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
global cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8
global cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Ausize
global cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8__Ausize
global cb__Nstd__Nrawstring__Nset__Aptr__Tpure__Tuint8__Apure__Tuint8__Ausize
global cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8
global cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8
global cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint
global cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint
global cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aptr__Tpure__Tuint8
global cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool
global cb__Nstd__Ntests1__Nok
section .data
main__g_glob: dd 0x19
$cbstr0: db 104,101,108,108,111,32,119,111,114,108,100,0
$cbstr1: db 0
$cbstr2: db 122,121,120,119,118,117,116,115,114,113,112,111,110,109,108,107,106,105,104,103,102,101,100,99,98,97,57,56,55,54,53,52,51,50,49,48,49,50,51,52,53,54,55,56,57,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,0
$cbstr3: db 116,114,117,101,0
$cbstr4: db 102,97,108,115,101,0
section .code
cb__Nmain__Nmain__Aptr__Tslice__TU_string:
 ;func main([]string): int
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov edx,5
 mov ecx,10
 call cb__Nmain__Ntest_div__Aint__Aint
 ;ir_call cb__Nmain__Ntest_div__Aint__Aint 10 5;

 mov dword [rbp-4],eax
 ;ir_load L0 ST;

 mov r10d,9543
 mov [main__g_glob],r10d
 ;ir_load  9543;

 mov r10d,[main__g_glob]
 mov dword [rbp-8],r10d
 ;ir_load L1 ;

 mov ecx,dword [rbp-8]
 call cb__Nstd__Nio__Nprintln__Aint
 ;ir_call cb__Nstd__Nio__Nprintln__Aint L1;

 mov r10d,dword [rbp-8]
 cmp r10d,9543
 jne cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1491$else
 ;ir_jmp_neq L1 9543 cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1491$else;

cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1491$body:
 ;ir_make_label cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1491$body;

 mov r10b,1
 mov byte [rbp-9],r10b
 ;ir_load L2 1;

 jmp cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1491$end
 ;ir_jmp cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1491$end;

cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1491$else:
 ;ir_make_label cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1491$else;

 mov r10b,0
 mov byte [rbp-9],r10b
 ;ir_load L2 0;

cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1491$end:
 ;ir_make_label cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1491$end;

 mov cl,byte [rbp-9]
 call cb__Nstd__Nio__Nprintln__Abool
 ;ir_call cb__Nstd__Nio__Nprintln__Abool L2;

 mov r10d,dword [rbp-8]
 cmp r10d,95434
 jne cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1507$else
 ;ir_jmp_neq L1 95434 cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1507$else;

cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1507$body:
 ;ir_make_label cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1507$body;

 mov r10b,1
 mov byte [rbp-10],r10b
 ;ir_load L3 1;

 jmp cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1507$end
 ;ir_jmp cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1507$end;

cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1507$else:
 ;ir_make_label cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1507$else;

 mov r10b,0
 mov byte [rbp-10],r10b
 ;ir_load L3 0;

cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1507$end:
 ;ir_make_label cb__Nmain__Nmain__Aptr__Tslice__TU_string$if1507$end;

 mov cl,byte [rbp-10]
 call cb__Nstd__Nio__Nprintln__Abool
 ;ir_call cb__Nstd__Nio__Nprintln__Abool L3;

 lea rax,[$cbstr0]
 ;ir_load_addr STR0;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__A$rawstring
 ;ir_call cb__Nstd__Nio__Nprintln__A$rawstring ST;

 mov eax,dword [rbp-8]
 ;ir_return L1;

cb__Nmain__Nmain__Aptr__Tslice__TU_string$end:
 add rsp,32
 pop rbp
 ret


cb__Nmain__Ntest_div__Aint__Aint:
 ;func test_div(int, int): int
 mov dword [rsp+16],edx
 mov dword [rsp+8],ecx
 push rbp
 mov rbp,rsp
 ;prolog end

 mov eax,dword [rbp+16]
 cdq
 idiv dword [rbp+24]
 ;ir_div A0 A1;

 ;ir_return ST;

cb__Nmain__Ntest_div__Aint__Aint$end:
 pop rbp
 ret


cb__Ninit__Ninit_command_line__Aptr__Tslice__TU_string:
 ;func init_command_line(*[]string): *[]string
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 push rdi
 mov rbp,rsp
 sub rsp,64
 ;prolog end

 call GetCommandLineA
 ;ir_call GetCommandLineA;

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 lea rax,qword [rbp-24]
 ;ir_load_addr L1;

 mov edx,1
 mov rcx,rax
 call cb__Nstd__Nalloc__Nmake_slice__Cstring__Aptr__Tslice__TU_string__Ausize
 mov rbx,rax
 ;ir_call cb__Nstd__Nalloc__Nmake_slice__Cstring__Aptr__Tslice__TU_string__Ausize ST 1;

 mov rax,qword [rbp-24]
 ;ir_deref [L1 . 0];

 mov r10,0
 imul r10,24
 lea rax,qword [rax+r10*1]
 ;ir_index ST 0;

 mov r10,qword [rbp-8]
 mov qword [rax+0+0],r10
 ;ir_load [ST . 0] L0;

 mov rax,qword [rbp-24]
 ;ir_deref [L1 . 0];

 mov r10,0
 imul r10,24
 lea rdi,qword [rax+r10*1]
 ;ir_index ST 0;

 mov rcx,qword [rbp-8]
 call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8
 ;ir_call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8 L0;

 mov qword [rdi+0+8],rax
 ;ir_load [ST . 1] ST;

 mov rax,qword [rbp-24]
 ;ir_deref [L1 . 0];

 mov r10,0
 imul r10,24
 lea rax,qword [rax+r10*1]
 ;ir_index ST 0;

 mov r10b,0
 mov byte [rax+0+16],r10b
 ;ir_load [ST . 2] 0;

 mov rax,qword [rbp+32]
 ;ir_deref A0;

 push rdi
 push rsi
 lea rdi,qword [rax]
 lea rsi,qword [rbp-24]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy ST L1 16;

 mov rax,qword [rbp+32]
 ;ir_return A0;

cb__Ninit__Ninit_command_line__Aptr__Tslice__TU_string$end:
 add rsp,64
 pop rdi
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
 push rdi
 mov rbp,rsp
 sub rsp,64
 ;prolog end

 lea rax,qword [rbp-16]
 ;ir_load_addr L0;

 mov rcx,rax
 call cb__Ninit__Ninit_command_line__Aptr__Tslice__TU_string
 mov rbx,rax
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
 mov edi,eax
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

 mov eax,edi
 ;ir_return ST;

carbon_main$end:
 add rsp,64
 pop rdi
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


cb__Nstd__Nalloc__Nset__Apointer__Auint8__Ausize:
 ;func set(pointer, uint8, usize): {}
 push rbp
 mov rbp,rsp
 ;prolog end

push rdi

mov rdi,rcx
mov rax,rdx
mov rcx,r8
rep stosb

pop rdi
    
cb__Nstd__Nalloc__Nset__Apointer__Auint8__Ausize$end:
 pop rbp
 ret


cb__Nstd__Nalloc__Nallocn__Cuint8__Ausize:
 ;func allocn(usize): *uint8
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,48
 ;prolog end

 mov r10,qword [rbp+16]
 imul r10,1
 mov rax,r10
 ;ir_mul A0 1;

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 mov rcx,qword [rbp-8]
 call cb__Nstd__Nalloc__Nalloc__Ausize
 ;ir_call cb__Nstd__Nalloc__Nalloc__Ausize L0;

 mov qword [rbp-16],rax
 ;ir_load L1 ST;

 mov r8,qword [rbp-8]
 mov dl,0
 mov rcx,qword [rbp-16]
 call cb__Nstd__Nalloc__Nset__Apointer__Auint8__Ausize
 ;ir_call cb__Nstd__Nalloc__Nset__Apointer__Auint8__Ausize L1 0 L0;

 mov rax,qword [rbp-16]
 ;ir_return L1;

cb__Nstd__Nalloc__Nallocn__Cuint8__Ausize$end:
 add rsp,48
 pop rbp
 ret


cb__Nstd__Nalloc__Nallocn__Cstring__Ausize:
 ;func allocn(usize): *string
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,48
 ;prolog end

 mov r10,qword [rbp+16]
 imul r10,24
 mov rax,r10
 ;ir_mul A0 24;

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 mov rcx,qword [rbp-8]
 call cb__Nstd__Nalloc__Nalloc__Ausize
 ;ir_call cb__Nstd__Nalloc__Nalloc__Ausize L0;

 mov qword [rbp-16],rax
 ;ir_load L1 ST;

 mov r8,qword [rbp-8]
 mov dl,0
 mov rcx,qword [rbp-16]
 call cb__Nstd__Nalloc__Nset__Apointer__Auint8__Ausize
 ;ir_call cb__Nstd__Nalloc__Nset__Apointer__Auint8__Ausize L1 0 L0;

 mov rax,qword [rbp-16]
 ;ir_return L1;

cb__Nstd__Nalloc__Nallocn__Cstring__Ausize$end:
 add rsp,48
 pop rbp
 ret


cb__Nstd__Nalloc__Nmake_slice__Cstring__Aptr__Tslice__TU_string__Ausize:
 ;func make_slice(*[]string, usize): *[]string
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov rcx,qword [rbp+24]
 call cb__Nstd__Nalloc__Nallocn__Cstring__Ausize
 ;ir_call cb__Nstd__Nalloc__Nallocn__Cstring__Ausize A1;

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 mov rax,qword [rbp+16]
 ;ir_deref A0;

 mov r10,qword [rbp-8]
 mov qword [rax+0],r10
 ;ir_load [ST . 0] L0;

 mov rax,qword [rbp+16]
 ;ir_deref A0;

 mov r10,qword [rbp+24]
 mov qword [rax+8],r10
 ;ir_load [ST . 1] A1;

 mov rax,qword [rbp+16]
 ;ir_return A0;

cb__Nstd__Nalloc__Nmake_slice__Cstring__Aptr__Tslice__TU_string__Ausize$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nio__Nprintln__Aint:
 ;func println(int): {}
 mov dword [rsp+8],ecx
 push rbp
 mov rbp,rsp
 sub rsp,64
 ;prolog end

 lea rax,qword [rbp-24]
 ;ir_load_addr L0;

 mov edx,dword [rbp+16]
 mov rcx,rax
 call cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint
 ;ir_call cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint ST A0;

 mov rax,rax
 ;ir_deref ST;

 mov rcx,qword [rax+0]
 call puts
 ;ir_call puts [ST . 0];

 ;ir_noop ST;

cb__Nstd__Nio__Nprintln__Aint$end:
 add rsp,64
 pop rbp
 ret


cb__Nstd__Nio__Nprintln__Abool:
 ;func println(bool): {}
 mov byte [rsp+8],cl
 push rbp
 mov rbp,rsp
 sub rsp,64
 ;prolog end

 lea rax,qword [rbp-24]
 ;ir_load_addr L0;

 mov dl,byte [rbp+16]
 mov rcx,rax
 call cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool
 ;ir_call cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool ST A0;

 mov rax,rax
 ;ir_deref ST;

 mov rcx,qword [rax+0]
 call puts
 ;ir_call puts [ST . 0];

 ;ir_noop ST;

cb__Nstd__Nio__Nprintln__Abool$end:
 add rsp,64
 pop rbp
 ret


cb__Nstd__Nio__Nprintln__A$rawstring:
 ;func println($rawstring): {}
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,64
 ;prolog end

 lea rax,qword [rbp-24]
 ;ir_load_addr L0;

 mov rdx,qword [rbp+16]
 mov rcx,rax
 call cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aptr__Tpure__Tuint8
 ;ir_call cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aptr__Tpure__Tuint8 ST A0;

 mov rax,rax
 ;ir_deref ST;

 mov rcx,qword [rax+0]
 call puts
 ;ir_call puts [ST . 0];

 ;ir_noop ST;

cb__Nstd__Nio__Nprintln__A$rawstring$end:
 add rsp,64
 pop rbp
 ret


cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8:
 ;func copy(*pure uint8): *uint8
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,16
 ;prolog end

 mov rcx,qword [rbp+16]
 call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8
 ;ir_call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8 A0;

 mov rdx,rax
 mov rcx,qword [rbp+16]
 call cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Ausize
 ;ir_call cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Ausize A0 ST;

 ;ir_return ST;

cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8$end:
 add rsp,16
 pop rbp
 ret


cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Ausize:
 ;func copy(*pure uint8, usize): *uint8
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
 call cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8__Ausize
 ;ir_call cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8__Ausize L0 A0 A1;

 mov rax,qword [rbp-8]
 ;ir_deref L0;

 mov r10,qword [rbp+24]
 lea rax,byte [rax+r10*1]
 ;ir_index ST A1;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST #0;

 mov rax,qword [rbp-8]
 ;ir_return L0;

cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Ausize$end:
 add rsp,48
 pop rbp
 ret


cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8__Ausize:
 ;func copy(*pure uint8, *pure uint8, usize): {}
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

cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8__Ausize$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nrawstring__Nset__Aptr__Tpure__Tuint8__Apure__Tuint8__Ausize:
 ;func set(*pure uint8, pure uint8, usize): {}
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
 call cb__Nstd__Nalloc__Nset__Apointer__Auint8__Ausize
 ;ir_call cb__Nstd__Nalloc__Nset__Apointer__Auint8__Ausize A0 A1 A2;

cb__Nstd__Nrawstring__Nset__Aptr__Tpure__Tuint8__Apure__Tuint8__Ausize$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8:
 ;func strlen(*pure uint8): usize
 push rbp
 mov rbp,rsp
 sub rsp,16
 ;prolog end

 mov r10,0
 mov qword [rbp-8],r10
 ;ir_load L0 0;

 mov qword [rbp-16],rcx
 ;ir_load L1 A0;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w694$cond:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w694$cond;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 movzx eax,byte [rax]
 ;ir_cast ST;

 cmp eax,0
 je cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w694$end
 ;ir_jmp_eq ST 0 cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w694$end;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w694$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w694$body;

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

 jmp cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w694$cond
 ;ir_jmp cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w694$cond;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w694$end:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w694$end;

 mov rax,qword [rbp-8]
 ;ir_return L0;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$end:
 add rsp,16
 pop rbp
 ret


cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8:
 ;func equals(*pure uint8, *pure uint8): bool
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,56
 ;prolog end

 mov rcx,qword [rbp+24]
 call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8
 mov rbx,rax
 ;ir_call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8 A0;

 mov rcx,qword [rbp+32]
 call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8
 ;ir_call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8 A1;

 cmp rbx,rax
 je cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if730$else
 ;ir_jmp_eq ST ST cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if730$else;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if730$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if730$body;

 mov al,0
 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$end
 ;ir_return 0;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if730$else:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if730$else;

 mov r10d,0
 mov dword [rbp-16],r10d
 ;ir_load [L0 . 0] 0;

 mov rcx,qword [rbp+24]
 call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8
 ;ir_call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8 A0;

 mov qword [rbp-12],rax
 ;ir_load [L0 . 1] ST;

 mov r10d,dword [rbp-16]
 mov dword [rbp-24],r10d
 ;ir_load L2 [L0 . 0];

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f756$cond:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f756$cond;

 movsxd rax,dword [rbp-24]
 ;ir_cast L2;

 cmp rax,qword [rbp-12]
 jge cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f756$end
 ;ir_jmp_gte ST [L0 . 1] cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f756$end;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f756$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f756$body;

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
 je cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if753$else
 ;ir_jmp_eq ST ST cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if753$else;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if753$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if753$body;

 mov al,0
 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$end
 ;ir_return 0;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if753$else:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if753$else;

 mov r10d,dword [rbp-24]
 add r10d,1
 mov eax,r10d
 ;ir_add L2 1;

 mov dword [rbp-24],eax
 ;ir_load L2 ST;

 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f756$cond
 ;ir_jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f756$cond;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f756$end:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f756$end;

 mov al,1
 ;ir_return 1;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$end:
 add rsp,56
 pop rbx
 pop rbp
 ret


cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint:
 ;func to_string(*string, int, int): *string
 mov dword [rsp+24],r8d
 mov dword [rsp+16],edx
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 push rdi
 mov rbp,rsp
 sub rsp,80
 ;prolog end

 mov r10d,dword [rbp+48]
 cmp r10d,2
 jl cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if820$body
 ;ir_jmp_lt A2 2 cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if820$body;

 mov r10d,dword [rbp+48]
 cmp r10d,36
 jle cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if820$else
 ;ir_jmp_lte A2 36 cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if820$else;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if820$body:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if820$body;

 mov rbx,qword [rbp+32]
 ;ir_deref A0;

 lea rax,[$cbstr1]
 ;ir_load_addr STR1;

 mov qword [rbx+0],rax
 ;ir_load [ST . 0] ST;

 mov rax,qword [rbp+32]
 ;ir_deref A0;

 mov r10d,0
 mov qword [rax+8],r10
 ;ir_load [ST . 1] 0;

 mov rax,qword [rbp+32]
 ;ir_deref A0;

 mov r10b,1
 mov byte [rax+16],r10b
 ;ir_load [ST . 2] 1;

 mov rax,qword [rbp+32]
 jmp cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$end
 ;ir_return A0;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if820$else:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if820$else;

 mov r10d,0
 mov dword [rbp-4],r10d
 ;ir_load L0 0;

 mov r10d,0
 mov dword [rbp-8],r10d
 ;ir_load L1 0;

 mov ecx,25
 call cb__Nstd__Nalloc__Nallocn__Cuint8__Ausize
 ;ir_call cb__Nstd__Nalloc__Nallocn__Cuint8__Ausize 25;

 mov qword [rbp-32],rax
 ;ir_load [L2 . 0] ST;

 mov r10d,24
 mov qword [rbp-24],r10
 ;ir_load [L2 . 1] 24;

 mov r10b,0
 mov byte [rbp-16],r10b
 ;ir_load [L2 . 2] 0;

 mov rax,qword [rbp-32]
 ;ir_deref [L2 . 0];

 mov r10,24
 lea rax,byte [rax+r10*1]
 ;ir_index ST 24;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST #0;

 lea rax,[$cbstr2]
 ;ir_load_addr STR2;

 mov qword [rbp-40],rax
 ;ir_load L3 ST;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w897$cond:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w897$cond;

 mov r10d,dword [rbp+40]
 cmp r10d,0
 je cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w897$end
 ;ir_jmp_eq A1 0 cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w897$end;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w897$body:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w897$body;

 mov r10d,dword [rbp-8]
 cmp r10d,24
 jl cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if866$else
 ;ir_jmp_lt L1 24 cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if866$else;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if866$body:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if866$body;

 jmp cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w897$end
 ;ir_jmp cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w897$end;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if866$else:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if866$else;

 mov r10d,dword [rbp+40]
 mov dword [rbp-4],r10d
 ;ir_load L0 A1;

 mov eax,dword [rbp+40]
 cdq
 idiv dword [rbp+48]
 ;ir_div A1 A2;

 mov dword [rbp+40],eax
 ;ir_load A1 ST;

 mov rax,qword [rbp-32]
 ;ir_deref [L2 . 0];

 movsxd r10,dword [rbp-8]
 lea rbx,byte [rax+r10*1]
 ;ir_index ST L1;

 mov rdi,qword [rbp-40]
 ;ir_deref L3;

 mov r10d,dword [rbp+40]
 imul r10d,dword [rbp+48]
 mov eax,r10d
 ;ir_mul A1 A2;

 mov r10d,dword [rbp-4]
 sub r10d,eax
 mov eax,r10d
 ;ir_sub L0 ST;

 mov r10d,35
 add r10d,eax
 mov eax,r10d
 ;ir_add 35 ST;

 movsxd r10,eax
 lea rax,byte [rdi+r10*1]
 ;ir_index ST ST;

 mov r10b,byte [rax+0]
 mov byte [rbx+0],r10b
 ;ir_load ST ST;

 mov r10d,dword [rbp-8]
 add r10d,1
 mov eax,r10d
 ;ir_add L1 1;

 mov dword [rbp-8],eax
 ;ir_load L1 ST;

 jmp cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w897$cond
 ;ir_jmp cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w897$cond;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w897$end:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w897$end;

 mov rax,qword [rbp-32]
 ;ir_deref [L2 . 0];

 movsxd r10,dword [rbp-8]
 lea rax,byte [rax+r10*1]
 ;ir_index ST L1;

 lea rax,byte [rax+0]
 ;ir_load_addr ST;

 mov qword [rbp-48],rax
 ;ir_load L4 ST;

 mov r10,qword [rbp-32]
 mov qword [rbp-56],r10
 ;ir_load L5 [L2 . 0];

 mov r10d,dword [rbp-4]
 cmp r10d,0
 jge cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if926$else
 ;ir_jmp_gte L0 0 cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if926$else;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if926$body:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if926$body;

 mov rax,qword [rbp-48]
 ;ir_deref L4;

 mov r10b,45
 mov byte [rax],r10b
 ;ir_load ST #45;

 mov r10,qword [rbp-48]
 add r10,1
 mov rax,r10
 ;ir_add L4 1;

 mov qword [rbp-48],rax
 ;ir_load L4 ST;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if926$else:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$if926$else;

 mov rax,qword [rbp-48]
 ;ir_deref L4;

 mov r10b,0
 mov byte [rax],r10b
 ;ir_load ST #0;

 mov r10,qword [rbp-48]
 sub r10,1
 mov rax,r10
 ;ir_sub L4 1;

 mov qword [rbp-48],rax
 ;ir_load L4 ST;

 mov r10b,0
 mov byte [rbp-57],r10b
 ;ir_load L6 0;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w970$cond:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w970$cond;

 mov r10,qword [rbp-56]
 cmp r10,qword [rbp-48]
 jge cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w970$end
 ;ir_jmp_gte L5 L4 cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w970$end;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w970$body:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w970$body;

 mov rax,qword [rbp-48]
 ;ir_deref L4;

 mov r10b,byte [rax]
 mov byte [rbp-57],r10b
 ;ir_load L6 ST;

 mov rbx,qword [rbp-48]
 ;ir_deref L4;

 mov rax,qword [rbp-56]
 ;ir_deref L5;

 mov r10b,byte [rax]
 mov byte [rbx],r10b
 ;ir_load ST ST;

 mov r10,qword [rbp-48]
 sub r10,1
 mov rax,r10
 ;ir_sub L4 1;

 mov qword [rbp-48],rax
 ;ir_load L4 ST;

 mov rax,qword [rbp-56]
 ;ir_deref L5;

 mov r10b,byte [rbp-57]
 mov byte [rax],r10b
 ;ir_load ST L6;

 mov r10,qword [rbp-56]
 add r10,1
 mov rax,r10
 ;ir_add L5 1;

 mov qword [rbp-56],rax
 ;ir_load L5 ST;

 jmp cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w970$cond
 ;ir_jmp cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w970$cond;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w970$end:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$w970$end;

 mov rax,qword [rbp+32]
 ;ir_deref A0;

 push rdi
 push rsi
 lea rdi,qword [rax]
 lea rsi,qword [rbp-32]
 mov rcx,24
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy ST L2 24;

 mov rax,qword [rbp+32]
 ;ir_return A0;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint$end:
 add rsp,80
 pop rdi
 pop rbx
 pop rbp
 ret


cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint:
 ;func to_string(*string, int): *string
 mov dword [rsp+16],edx
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,40
 ;prolog end

 mov r8d,10
 mov edx,dword [rbp+32]
 mov rcx,qword [rbp+24]
 call cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint
 mov rbx,rax
 ;ir_call cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aint A0 A1 10;

 mov rax,qword [rbp+24]
 jmp cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint$end
 ;ir_return A0;

 ;ir_noop ST;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint$end:
 add rsp,40
 pop rbx
 pop rbp
 ret


cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aptr__Tpure__Tuint8:
 ;func to_string(*string, *pure uint8): *string
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,24
 ;prolog end

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 mov r10,qword [rbp+32]
 mov qword [rax+0],r10
 ;ir_load [ST . 0] A1;

 mov rbx,qword [rbp+24]
 ;ir_deref A0;

 mov rcx,qword [rbp+32]
 call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8
 ;ir_call cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8 A1;

 mov qword [rbx+8],rax
 ;ir_load [ST . 1] ST;

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 mov r10b,1
 mov byte [rax+16],r10b
 ;ir_load [ST . 2] 1;

 mov rax,qword [rbp+24]
 ;ir_return A0;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aptr__Tpure__Tuint8$end:
 add rsp,24
 pop rbx
 pop rbp
 ret


cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool:
 ;func to_string(*string, bool): *string
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,8
 ;prolog end

 cmp dl,0
 je cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool$if1042$else
 ;ir_jmp_eq A1 0 cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool$if1042$else;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool$if1042$body:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool$if1042$body;

 mov rbx,rcx
 ;ir_deref A0;

 lea rax,[$cbstr3]
 ;ir_load_addr STR3;

 mov qword [rbx+0],rax
 ;ir_load [ST . 0] ST;

 mov rax,rcx
 ;ir_deref A0;

 mov r10d,4
 mov qword [rax+8],r10
 ;ir_load [ST . 1] 4;

 mov rax,rcx
 ;ir_deref A0;

 mov r10b,1
 mov byte [rax+16],r10b
 ;ir_load [ST . 2] 1;

 mov rax,rcx
 jmp cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool$end
 ;ir_return A0;

 jmp cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool$if1042$end
 ;ir_jmp cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool$if1042$end;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool$if1042$else:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool$if1042$else;

 mov rbx,rcx
 ;ir_deref A0;

 lea rax,[$cbstr4]
 ;ir_load_addr STR4;

 mov qword [rbx+0],rax
 ;ir_load [ST . 0] ST;

 mov rax,rcx
 ;ir_deref A0;

 mov r10d,5
 mov qword [rax+8],r10
 ;ir_load [ST . 1] 5;

 mov rax,rcx
 ;ir_deref A0;

 mov r10b,1
 mov byte [rax+16],r10b
 ;ir_load [ST . 2] 1;

 mov rax,rcx
 jmp cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool$end
 ;ir_return A0;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool$if1042$end:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool$if1042$end;

cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool$end:
 add rsp,8
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


