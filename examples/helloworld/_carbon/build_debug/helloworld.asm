global cb__Nmain__Nmain__Aptr__Tslice__TU_string
global carbon_main
global cb__Nstd__Nio__Nprintln__Aptr__TU_string
global cb__Nstd__Nio__Nprintln__A$rawstring
extern puts
extern putc
extern exit
extern free
extern malloc
extern rand
extern system
extern strlen
global cb__Nstd__Nmem__Narena__Nalign__Ausize__Ausize
global cb__Nstd__Nmem__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize
global cb__Nstd__Nmem__Narena__Nallocate_in_block__Aptr__TU_memory__Aptr__TU_arena_block__Ausize
global cb__Nstd__Nmem__Narena__Nmake_arena_allocator__Aptr__TU_arena__Ausize
global cb__Nstd__Nmem__Narena__Nfree__Aptr__TU_arena
global cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize
global cb__Nstd__Nmem__Ncopy__Arawptr__Arawptr__Ausize
global cb__Nstd__Nmem__Nset__Arawptr__Auint8__Ausize
global cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8
global cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Ausize
global cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8__Ausize
global cb__Nstd__Nrawstring__Nset__Aptr__Tpure__Tuint8__Apure__Tuint8__Ausize
global cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8
global cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8
global cb__Nstd__Nruntime__Nmemory__Nalloc__Aptr__TU_memory__Ausize
global cb__Nstd__Nruntime__Nmemory__Nfree__Aptr__TU_memory
global cb__Nstd__Nruntime__Nsyscalls__N_dummy
extern HeapAlloc
extern HeapFree
extern GetProcessHeap
extern GetCommandLineA
global cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__Tslice__Tuint8
global cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aint__Aptr__Tslice__Tuint8
global cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aptr__Tpure__Tuint8
global cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Aptr__Tslice__Tuint8
global cb__Nstd__Nstring__Nto_string__Aptr__TU_string__Abool
section .data
std__string__MAX_INTEGER_STRING_LEN: dd 0x0
$cbstr0: db 72,101,108,108,111,32,87,111,114,108,100,32,65,103,97,105,110,0
$cbstr1: db 122,121,120,119,118,117,116,115,114,113,112,111,110,109,108,107,106,105,104,103,102,101,100,99,98,97,57,56,55,54,53,52,51,50,49,48,49,50,51,52,53,54,55,56,57,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,0
$cbstr2: db 116,114,117,101,0
$cbstr3: db 102,97,108,115,101,0
section .code
cb__Nmain__Nmain__Aptr__Tslice__TU_string:
 ;func main([]string): int
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,16
 ;prolog end

 lea rax,[$cbstr0]
 ;ir_load_addr STR0;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__A$rawstring
 ;ir_call cb__Nstd__Nio__Nprintln__A$rawstring ST;

 mov eax,0
 ;ir_return 0;

cb__Nmain__Nmain__Aptr__Tslice__TU_string$end:
 add rsp,16
 pop rbp
 ret


carbon_main:
 ;func carbon_main(): int
 sub rsp,8
 ;prolog end

 mov eax,0
 ;ir_return 0;

carbon_main$end:
 add rsp,8
 ret


cb__Nstd__Nio__Nprintln__Aptr__TU_string:
 ;func println(string): {}
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov rax,qword [rbp+16]
 ;ir_deref A0;

 mov rcx,qword [rax+0]
 call puts
 ;ir_call puts [ST . 0];

 ;ir_noop ST;

cb__Nstd__Nio__Nprintln__Aptr__TU_string$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nio__Nprintln__A$rawstring:
 ;func println($rawstring): {}
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,48
 ;prolog end

 lea rax,qword [rbp-16]
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
 add rsp,48
 pop rbp
 ret


cb__Nstd__Nmem__Narena__Nalign__Ausize__Ausize:
 ;func align(usize, usize): usize
 push rbp
 mov rbp,rsp
 ;prolog end

 mov rax,rcx
 ;ir_return A0;

cb__Nstd__Nmem__Narena__Nalign__Ausize__Ausize$end:
 pop rbp
 ret


cb__Nstd__Nmem__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize:
 ;func fits_in_block(&arena_block, usize): bool
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,24
 ;prolog end

 mov rax,rcx
 ;ir_deref A0;

 mov r10,qword [rax+16]
 add r10,rdx
 mov rbx,r10
 ;ir_add [ST . 1] A1;

 mov rax,rcx
 ;ir_deref A0;

 cmp rbx,qword [rax+-8]
 jg cb__Nstd__Nmem__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if1557$else
 ;ir_jmp_gt ST [ . 1] cb__Nstd__Nmem__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if1557$else;

cb__Nstd__Nmem__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if1557$body:
 ;ir_make_label cb__Nstd__Nmem__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if1557$body;

 mov r10,0
 mov byte [rbp-1],r10b
 ;ir_load L0 0;

 jmp cb__Nstd__Nmem__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if1557$end
 ;ir_jmp cb__Nstd__Nmem__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if1557$end;

cb__Nstd__Nmem__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if1557$else:
 ;ir_make_label cb__Nstd__Nmem__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if1557$else;

 mov r10,0
 mov byte [rbp-1],r10b
 ;ir_load L0 0;

cb__Nstd__Nmem__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if1557$end:
 ;ir_make_label cb__Nstd__Nmem__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if1557$end;

 mov al,byte [rbp-1]
 ;ir_return L0;

cb__Nstd__Nmem__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$end:
 add rsp,24
 pop rbx
 pop rbp
 ret


cb__Nstd__Nmem__Narena__Nallocate_in_block__Aptr__TU_memory__Aptr__TU_arena_block__Ausize:
 ;func allocate_in_block(&memory, &arena_block, usize): &memory
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,24
 ;prolog end

 mov rbx,rdx
 ;ir_deref A1;

 mov rax,rdx
 ;ir_deref A1;

 mov r10,qword [rbx+0]
 add r10,qword [rax+16]
 mov rax,r10
 ;ir_add [ . 0] [ST . 1];

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 mov rbx,rdx
 ;ir_deref A1;

 mov rax,rdx
 ;ir_deref A1;

 mov r10,qword [rax+16]
 add r10,r8
 mov rax,r10
 ;ir_add [ST . 1] A2;

 mov qword [rbx+16],rax
 ;ir_load [ST . 1] ST;

 mov rax,rcx
 ;ir_deref A0;

 mov r10,qword [rbp-8]
 mov qword [rax+0],r10
 ;ir_load [ST . 0] L0;

 mov rax,rcx
 ;ir_deref A0;

 mov qword [rax+8],r8
 ;ir_load [ST . 1] A2;

 mov rax,rcx
 ;ir_return A0;

cb__Nstd__Nmem__Narena__Nallocate_in_block__Aptr__TU_memory__Aptr__TU_arena_block__Ausize$end:
 add rsp,24
 pop rbx
 pop rbp
 ret


cb__Nstd__Nmem__Narena__Nmake_arena_allocator__Aptr__TU_arena__Ausize:
 ;func make_arena_allocator(&arena, usize): &arena
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,48
 ;prolog end

 mov r10,0
 mov qword [rbp-24],r10
 ;ir_load [L0 . 0] 0;

 mov r10,0
 mov qword [rbp-16],r10
 ;ir_load [L0 . 1] 0;

 mov r10,0
 mov qword [rbp-8],r10
 ;ir_load [L0 . 2] 0;

 mov r10,0
 mov qword [rbp-16],r10
 ;ir_load [L0 . 1] 0;

 mov rdx,qword [rbp-16]
 mov rcx,qword [rbp+24]
 call cb__Nstd__Nmem__Narena__Nalign__Ausize__Ausize
 ;ir_call cb__Nstd__Nmem__Narena__Nalign__Ausize__Ausize A1 [L0 . 1];

 mov qword [rbp-8],rax
 ;ir_load [L0 . 2] ST;

 mov r10,0
 mov qword [rbp-24],r10
 ;ir_load [L0 . 0] 0;

 mov rax,qword [rbp+16]
 ;ir_deref A0;

 push rdi
 push rsi
 lea rdi,qword [rax]
 lea rsi,qword [rbp-24]
 mov rcx,24
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy ST L0 24;

 mov rax,qword [rbp+16]
 ;ir_return A0;

cb__Nstd__Nmem__Narena__Nmake_arena_allocator__Aptr__TU_arena__Ausize$end:
 add rsp,48
 pop rbp
 ret


cb__Nstd__Nmem__Narena__Nfree__Aptr__TU_arena:
 ;func free(&arena): {}
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,48
 ;prolog end

 mov rax,qword [rbp+16]
 ;ir_deref A0;

 mov r10,qword [rax+0]
 mov qword [rbp-8],r10
 ;ir_load L0 [ST . 0];

cb__Nstd__Nmem__Narena__Nfree__Aptr__TU_arena$w387$cond:
 ;ir_make_label cb__Nstd__Nmem__Narena__Nfree__Aptr__TU_arena$w387$cond;

 mov r10,qword [rbp-8]
 cmp r10,0
 je cb__Nstd__Nmem__Narena__Nfree__Aptr__TU_arena$w387$end
 ;ir_jmp_eq L0 0 cb__Nstd__Nmem__Narena__Nfree__Aptr__TU_arena$w387$end;

cb__Nstd__Nmem__Narena__Nfree__Aptr__TU_arena$w387$body:
 ;ir_make_label cb__Nstd__Nmem__Narena__Nfree__Aptr__TU_arena$w387$body;

 mov r10,qword [rbp-8]
 mov qword [rbp-16],r10
 ;ir_load L1 L0;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 mov r10,qword [rax+24]
 mov qword [rbp-24],r10
 ;ir_load L2 [ST . 2];

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 lea rax,qword [rax+0]
 ;ir_load_addr [ST . 0];

 mov rcx,rax
 call cb__Nstd__Nruntime__Nmemory__Nfree__Aptr__TU_memory
 ;ir_call cb__Nstd__Nruntime__Nmemory__Nfree__Aptr__TU_memory ST;

 mov r10,qword [rbp-24]
 mov qword [rbp-8],r10
 ;ir_load L0 L2;

 jmp cb__Nstd__Nmem__Narena__Nfree__Aptr__TU_arena$w387$cond
 ;ir_jmp cb__Nstd__Nmem__Narena__Nfree__Aptr__TU_arena$w387$cond;

cb__Nstd__Nmem__Narena__Nfree__Aptr__TU_arena$w387$end:
 ;ir_make_label cb__Nstd__Nmem__Narena__Nfree__Aptr__TU_arena$w387$end;

cb__Nstd__Nmem__Narena__Nfree__Aptr__TU_arena$end:
 add rsp,48
 pop rbp
 ret


cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize:
 ;func alloc(&memory, &arena, usize): &memory
 mov qword [rsp+24],r8
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 push rdi
 push rsi
 mov rbp,rsp
 sub rsp,88
 ;prolog end

 mov rax,qword [rbp+48]
 ;ir_deref A1;

 mov rdx,qword [rax+8]
 mov rcx,qword [rbp+56]
 call cb__Nstd__Nmem__Narena__Nalign__Ausize__Ausize
 ;ir_call cb__Nstd__Nmem__Narena__Nalign__Ausize__Ausize A2 [ST . 1];

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 mov rax,qword [rbp+48]
 ;ir_deref A1;

 mov r10,qword [rax+0]
 mov qword [rbp-16],r10
 ;ir_load L1 [ST . 0];

cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w445$cond:
 ;ir_make_label cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w445$cond;

 mov r10,qword [rbp-16]
 cmp r10,0
 je cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w445$end
 ;ir_jmp_eq L1 0 cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w445$end;

cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w445$body:
 ;ir_make_label cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w445$body;

 mov r10,qword [rbp-16]
 mov qword [rbp-48],r10
 ;ir_load L4 L1;

 mov rdx,qword [rbp-8]
 mov rcx,qword [rbp-48]
 call cb__Nstd__Nmem__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize
 ;ir_call cb__Nstd__Nmem__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize L4 L0;

 cmp al,0
 je cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$if442$else
 ;ir_jmp_eq ST 0 cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$if442$else;

cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$if442$body:
 ;ir_make_label cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$if442$body;

 mov r8,qword [rbp-8]
 mov rdx,qword [rbp-48]
 mov rcx,qword [rbp+40]
 call cb__Nstd__Nmem__Narena__Nallocate_in_block__Aptr__TU_memory__Aptr__TU_arena_block__Ausize
 mov rbx,rax
 ;ir_call cb__Nstd__Nmem__Narena__Nallocate_in_block__Aptr__TU_memory__Aptr__TU_arena_block__Ausize A0 L4 L0;

 mov rax,qword [rbp+40]
 jmp cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$end
 ;ir_return A0;

 ;ir_noop ST;

cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$if442$else:
 ;ir_make_label cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$if442$else;

 jmp cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w445$cond
 ;ir_jmp cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w445$cond;

cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w445$end:
 ;ir_make_label cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w445$end;

 lea rdi,qword [rbp-32]
 ;ir_load_addr L2;

 mov rax,qword [rbp+48]
 ;ir_deref A1;

 mov r10,0
 add r10,qword [rax+16]
 mov rax,r10
 ;ir_add 0 [ST . 2];

 mov rdx,rax
 mov rcx,rdi
 call cb__Nstd__Nruntime__Nmemory__Nalloc__Aptr__TU_memory__Ausize
 mov rdi,rax
 ;ir_call cb__Nstd__Nruntime__Nmemory__Nalloc__Aptr__TU_memory__Ausize ST ST;

 mov r10,qword [rbp-32]
 mov qword [rbp-40],r10
 ;ir_load L3 [L2 . 0];

 mov rsi,qword [rbp-40]
 ;ir_deref L3;

 mov r10,qword [rbp-32]
 add r10,0
 mov rax,r10
 ;ir_add [L2 . 0] 0;

 mov qword [rsi+0],rax
 ;ir_load [ . 0] ST;

 mov rsi,qword [rbp-40]
 ;ir_deref L3;

 mov r10,qword [rbp-24]
 sub r10,0
 mov rax,r10
 ;ir_sub [L2 . 1] 0;

 mov qword [rsi+-8],rax
 ;ir_load [ . 1] ST;

 mov rax,qword [rbp-40]
 ;ir_deref L3;

 mov r10,0
 mov qword [rax+16],r10
 ;ir_load [ST . 1] 0;

 mov rsi,qword [rbp-40]
 ;ir_deref L3;

 mov rax,qword [rbp+48]
 ;ir_deref A1;

 mov r10,qword [rax+0]
 mov qword [rsi+24],r10
 ;ir_load [ST . 2] [ST . 0];

 mov rax,qword [rbp+48]
 ;ir_deref A1;

 mov r10,qword [rbp-40]
 mov qword [rax+0],r10
 ;ir_load [ST . 0] L3;

 mov r8,qword [rbp-8]
 mov rdx,qword [rbp-40]
 mov rcx,qword [rbp+40]
 call cb__Nstd__Nmem__Narena__Nallocate_in_block__Aptr__TU_memory__Aptr__TU_arena_block__Ausize
 mov rsi,rax
 ;ir_call cb__Nstd__Nmem__Narena__Nallocate_in_block__Aptr__TU_memory__Aptr__TU_arena_block__Ausize A0 L3 L0;

 mov rax,qword [rbp+40]
 jmp cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$end
 ;ir_return A0;

 ;ir_noop ST;

cb__Nstd__Nmem__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$end:
 add rsp,88
 pop rsi
 pop rdi
 pop rbx
 pop rbp
 ret


cb__Nstd__Nmem__Ncopy__Arawptr__Arawptr__Ausize:
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
    
cb__Nstd__Nmem__Ncopy__Arawptr__Arawptr__Ausize$end:
 pop rbp
 ret


cb__Nstd__Nmem__Nset__Arawptr__Auint8__Ausize:
 ;func set(rawptr, uint8, usize): {}
 push rbp
 mov rbp,rsp
 ;prolog end

push rdi

mov rdi,rcx
mov rax,rdx
mov rcx,r8
rep stosb

pop rdi
    
cb__Nstd__Nmem__Nset__Arawptr__Auint8__Ausize$end:
 pop rbp
 ret


cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8:
 ;func copy(&pure uint8): &uint8
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
 ;func copy(&pure uint8, usize): &uint8
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,72
 ;prolog end

 lea rbx,qword [rbp-16]
 ;ir_load_addr L0;

 mov r10,qword [rbp+32]
 add r10,0
 mov rax,r10
 ;ir_add A1 0;

 mov rdx,rax
 mov rcx,rbx
 call cb__Nstd__Nruntime__Nmemory__Nalloc__Aptr__TU_memory__Ausize
 mov rbx,rax
 ;ir_call cb__Nstd__Nruntime__Nmemory__Nalloc__Aptr__TU_memory__Ausize ST ST;

 mov r10,qword [rbp-16]
 mov qword [rbp-24],r10
 ;ir_load L1 [L0 . 0];

 mov r8,qword [rbp+32]
 mov rdx,qword [rbp+24]
 mov rcx,qword [rbp-24]
 call cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8__Ausize
 ;ir_call cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8__Ausize L1 A0 A1;

 mov rax,qword [rbp-24]
 ;ir_deref L1;

 mov r10,qword [rbp+32]
 lea rax,byte [rax+r10*1]
 ;ir_index ST A1;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST #0;

 mov rax,qword [rbp-24]
 ;ir_return L1;

cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Ausize$end:
 add rsp,72
 pop rbx
 pop rbp
 ret


cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8__Ausize:
 ;func copy(&pure uint8, &pure uint8, usize): {}
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
 call cb__Nstd__Nmem__Ncopy__Arawptr__Arawptr__Ausize
 ;ir_call cb__Nstd__Nmem__Ncopy__Arawptr__Arawptr__Ausize A0 A1 A2;

cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8__Ausize$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nrawstring__Nset__Aptr__Tpure__Tuint8__Apure__Tuint8__Ausize:
 ;func set(&pure uint8, pure uint8, usize): {}
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
 call cb__Nstd__Nmem__Nset__Arawptr__Auint8__Ausize
 ;ir_call cb__Nstd__Nmem__Nset__Arawptr__Auint8__Ausize A0 A1 A2;

cb__Nstd__Nrawstring__Nset__Aptr__Tpure__Tuint8__Apure__Tuint8__Ausize$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8:
 ;func strlen(&pure uint8): usize
 push rbp
 mov rbp,rsp
 sub rsp,16
 ;prolog end

 mov r10,0
 mov qword [rbp-8],r10
 ;ir_load L0 0;

 mov qword [rbp-16],rcx
 ;ir_load L1 A0;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w786$cond:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w786$cond;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 movzx eax,byte [rax]
 ;ir_cast ST;

 cmp eax,0
 je cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w786$end
 ;ir_jmp_eq ST 0 cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w786$end;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w786$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w786$body;

 mov r10,qword [rbp-16]
 add r10,0
 mov rax,r10
 ;ir_add L1 0;

 mov qword [rbp-16],rax
 ;ir_load L1 ST;

 mov r10,qword [rbp-8]
 add r10,0
 mov rax,r10
 ;ir_add L0 0;

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 jmp cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w786$cond
 ;ir_jmp cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w786$cond;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w786$end:
 ;ir_make_label cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$w786$end;

 mov rax,qword [rbp-8]
 ;ir_return L0;

cb__Nstd__Nrawstring__Nstrlen__Aptr__Tpure__Tuint8$end:
 add rsp,16
 pop rbp
 ret


cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8:
 ;func equals(&pure uint8, &pure uint8): bool
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
 je cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if822$else
 ;ir_jmp_eq ST ST cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if822$else;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if822$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if822$body;

 mov al,0
 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$end
 ;ir_return 0;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if822$else:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if822$else;

 mov r10,0
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

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f848$cond:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f848$cond;

 movsxd rax,dword [rbp-24]
 ;ir_cast L2;

 cmp rax,qword [rbp-12]
 jge cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f848$end
 ;ir_jmp_gte ST [L0 . 1] cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f848$end;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f848$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f848$body;

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
 je cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if845$else
 ;ir_jmp_eq ST ST cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if845$else;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if845$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if845$body;

 mov al,0
 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$end
 ;ir_return 0;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if845$else:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if845$else;

 mov r10d,dword [rbp-24]
 add r10d,0
 mov eax,r10d
 ;ir_add L2 0;

 mov dword [rbp-24],eax
 ;ir_load L2 ST;

 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f848$cond
 ;ir_jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f848$cond;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f848$end:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f848$end;

 mov al,0
 ;ir_return 0;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$end:
 add rsp,56
 pop rbx
 pop rbp
 ret


cb__Nstd__Nruntime__Nmemory__Nalloc__Aptr__TU_memory__Ausize:
 ;func alloc(&memory, usize): &memory
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,40
 ;prolog end

 mov rbx,qword [rbp+24]
 ;ir_deref A0;

 call GetProcessHeap
 ;ir_call GetProcessHeap;

 mov r8,qword [rbp+32]
 mov rdx,0
 mov ecx,eax
 call HeapAlloc
 ;ir_call HeapAlloc ST 0 A1;

 mov qword [rbx+0],rax
 ;ir_load [ST . 0] ST;

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 mov r10,qword [rbp+32]
 mov qword [rax+8],r10
 ;ir_load [ST . 1] A1;

 mov rax,qword [rbp+24]
 ;ir_return A0;

cb__Nstd__Nruntime__Nmemory__Nalloc__Aptr__TU_memory__Ausize$end:
 add rsp,40
 pop rbx
 pop rbp
 ret


cb__Nstd__Nruntime__Nmemory__Nfree__Aptr__TU_memory:
 ;func free(&memory): {}
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,40
 ;prolog end

 call GetProcessHeap
 mov ebx,eax
 ;ir_call GetProcessHeap;

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 mov r8,qword [rax+0]
 mov rdx,0
 mov ecx,ebx
 call HeapFree
 ;ir_call HeapFree ST 0 [ST . 0];

 ;ir_noop ST;

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 mov r10,0
 mov qword [rax+0],r10
 ;ir_load [ST . 0] 0;

cb__Nstd__Nruntime__Nmemory__Nfree__Aptr__TU_memory$end:
 add rsp,40
 pop rbx
 pop rbp
 ret


cb__Nstd__Nruntime__Nsyscalls__N_dummy:
 ;func _dummy(): {}
 sub rsp,8
 ;prolog end

cb__Nstd__Nruntime__Nsyscalls__N_dummy$end:
 add rsp,8
 ret


cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__Tslice__Tuint8:
 ;func int_to_string(int, int, []uint8): int
 mov qword [rsp+24],r8
 mov dword [rsp+16],edx
 mov dword [rsp+8],ecx
 push rbp
 push rbx
 push rdi
 mov rbp,rsp
 sub rsp,48
 ;prolog end

 mov r10d,dword [rbp+40]
 cmp r10d,0
 jl cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__Tslice__Tuint8$if1019$body
 ;ir_jmp_lt A1 0 cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__Tslice__Tuint8$if1019$body;

 mov r10d,dword [rbp+40]
 cmp r10d,0
 jle cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__Tslice__Tuint8$if1019$else
 ;ir_jmp_lte A1 0 cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__Tslice__Tuint8$if1019$else;

cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__Tslice__Tuint8$if1019$body:
 ;ir_make_label cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__Tslice__Tuint8$if1019$body;

 mov eax,0
 jmp cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__Tslice__Tuint8$end
 ;ir_return 0;

cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__Tslice__Tuint8$if1019$else:
 ;ir_make_label cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__Tslice__Tuint8$if1019$else;

 lea rax,[$cbstr1]
 ;ir_load_addr STR1;

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 mov r10,0
 mov dword [rbp-12],r10d
 ;ir_load L1 0;

 mov r10,0
 mov dword [rbp-16],r10d
 ;ir_load L2 0;

cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__Tslice__Tuint8$w1077