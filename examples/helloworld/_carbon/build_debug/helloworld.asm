global cb__Nmain__Nwhatever__Aint
global cb__Nmain__Nmain__Aptr__Tslice__Tslice__Tpure__Tuint8
global cb__Nstd__Nio__Nprint__Aptr__TU_string
global cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8
global cb__Nstd__Nio__Nprintln__Aptr__TU_string
global cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8
extern exit
extern rand
extern system
global cb__Nstd__Nmemory__Narena__Nalign__Ausize__Ausize
global cb__Nstd__Nmemory__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize
global cb__Nstd__Nmemory__Narena__Nallocate_in_block__Aptr__TU_memory__Aptr__TU_arena_block__Ausize
global cb__Nstd__Nmemory__Narena__Nmake_arena_allocator__Aptr__TU_arena__Ausize
global cb__Nstd__Nmemory__Narena__Nfree__Aptr__TU_arena
global cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize
global cb__Nstd__Nmemory__Ncopy__Arawptr__Arawptr__Ausize
global cb__Nstd__Nmemory__Nset__Arawptr__Auint8__Ausize
global cb__Nstd__Nmemory__Nset__Aptr__TU_memory__Auint8
global cb__Nstd__Nmemory__Nas_memory__Aptr__TU_memory__Aptr__Tarray__I32__Tuint8
global cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8
global cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Ausize
global cb__Nstd__Nrawstring__Ncopy__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8__Ausize
global cb__Nstd__Nrawstring__Nset__Aptr__Tpure__Tuint8__Apure__Tuint8__Ausize
global cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8
global cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8
global cb__Nstd__Nruntime__Nio__Nwrite__Aint__Aptr__Tpure__Tuint8__Ausize
global cb__Nstd__Nruntime__Nio__Nwrite__Aptr__Tslice__Tpure__Tuint8
global cb__Nstd__Nruntime__Nmemory__Nalloc__Aptr__TU_memory__Ausize
global cb__Nstd__Nruntime__Nmemory__Nfree__Aptr__TU_memory
global cb__Nstd__Nruntime__Nsyscalls__N_dummy
extern HeapAlloc
extern HeapFree
extern GetProcessHeap
extern GetCommandLineA
extern GetStdHandle
extern WriteFile
extern QueryPerformanceFrequency
extern QueryPerformanceCounter
global cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string
global cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__Tpure__Tuint8
global cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__Tslice__Tpure__Tuint8
global cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__TU_memory
global cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__Tslice__Tuint8
global cb__Nstd__Nstring__Nas_slice__Aptr__Tslice__Tpure__Tuint8__Aptr__Tpure__TU_string
global cb__Nstd__Nstring__Nto_string__Aint__Aptr__TU_string
global cb__Nstd__Nstring__Nto_string__Abool__Aptr__TU_string
global cb__Nstd__Nstring__Nappend__Aptr__Tslice__Tpure__Tuint8__Aptr__TU_string
global cb__Nstd__Ntime__Nget_tick_counter
global cb__Nstd__Ntime__Nto_duration__Aptr__TU_duration__AU_ticks
global cb__Nstd__Ntime__Nnow__Aptr__TU_timestamp
section .data
extern std__memory__default_allocator
std__string__MAX_INTEGER_STRING_LEN: dd 0x18
std__time__PRECISION_SECONDS: dd 0x1
std__time__RATIO_MILLISECONDS: dd 0x3e8
std__time__RATIO_MICROSECONDS: dd 0xf4240
$cbstr0: db 72,101,108,108,111,0
$cbstr1: db 10,0
$cbstr2: db 122,121,120,119,118,117,116,115,114,113,112,111,110,109,108,107,106,105,104,103,102,101,100,99,98,97,57,56,55,54,53,52,51,50,49,48,49,50,51,52,53,54,55,56,57,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,0
$cbstr3: db 116,114,117,101,0
$cbstr4: db 102,97,108,115,101,0
section .code
cb__Nmain__Nwhatever__Aint:
 ;func whatever(int): int
 push rbp
 mov rbp,rsp
 ;prolog end

 add ecx,2
 mov eax,ecx
 ;ir_add A0 2;

 ;ir_return ST;

cb__Nmain__Nwhatever__Aint$end:
 pop rbp
 ret


cb__Nmain__Nmain__Aptr__Tslice__Tslice__Tpure__Tuint8:
 ;func main([][]pure uint8): int
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 push rdi
 mov rbp,rsp
 sub rsp,288
 ;prolog end

 mov rax,qword [rbp+32]
 ;ir_deref A0;

 mov rax,qword [rax+0]
 ;ir_deref [ST . 0];

 mov r10,0
 imul r10,16
 lea rax,qword [rax+r10*1]
 ;ir_index ST 0;

 push rdi
 push rsi
 lea rdi,qword [rbp-40]
 lea rsi,qword [rax+0]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L1 ST 16;

 lea rax,qword [rbp-40]
 ;ir_load_addr L1;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8 ST;

 mov r10,0
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 0;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,1
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 1;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,2
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 2;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,3
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 3;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,4
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 4;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,5
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 5;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,6
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 6;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,7
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 7;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,8
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 8;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,9
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 9;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,10
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 10;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,11
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 11;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,12
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 12;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,13
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 13;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,14
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 14;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,15
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 15;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,16
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 16;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,17
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 17;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,18
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 18;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,19
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 19;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,20
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 20;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,21
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 21;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,22
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 22;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,23
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 23;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,24
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 24;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,25
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 25;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,26
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 26;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,27
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 27;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,28
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 28;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,29
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 29;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,30
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 30;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,31
 lea rax,qword [rbp-80+r10*1]
 ;ir_index L3 31;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 lea rax,qword [rbp-80]
 ;ir_load_addr L3;

 mov rcx,rax
 call cb__Nstd__Nmemory__Nas_memory__Aptr__TU_memory__Aptr__Tarray__I32__Tuint8
 ;ir_call cb__Nstd__Nmemory__Nas_memory__Aptr__TU_memory__Aptr__Tarray__I32__Tuint8 ST;

 mov qword [rbp-48],rax
 ;ir_load L2 ST;

 lea rbx,qword [rbp-24]
 ;ir_load_addr L0;

 lea rax,qword [rbp-48]
 ;ir_load_addr L2;

 mov rdx,rax
 mov rcx,rbx
 call cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__Tpure__Tuint8
 mov rbx,rax
 ;ir_call cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__Tpure__Tuint8 ST ST;

 lea rax,qword [rbp-24]
 ;ir_load_addr L0;

 mov rdx,rax
 mov ecx,36345
 call cb__Nstd__Nstring__Nto_string__Aint__Aptr__TU_string
 ;ir_call cb__Nstd__Nstring__Nto_string__Aint__Aptr__TU_string 36345 ST;

 ;ir_noop ST;

 push rdi
 push rsi
 lea rdi,qword [rbp-104]
 lea rsi,qword [rbp-24]
 mov rcx,24
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L4 L0 24;

 lea rax,qword [rbp-104]
 ;ir_load_addr L4;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__Aptr__TU_string
 ;ir_call cb__Nstd__Nio__Nprintln__Aptr__TU_string ST;

 mov r10,qword [rbp-16]
 mov edi,r10d
 ;ir_cast [L0 . 1];

 lea rax,qword [rbp-24]
 ;ir_load_addr L0;

 mov rdx,rax
 mov ecx,edi
 call cb__Nstd__Nstring__Nto_string__Aint__Aptr__TU_string
 ;ir_call cb__Nstd__Nstring__Nto_string__Aint__Aptr__TU_string ST ST;

 ;ir_noop ST;

 push rdi
 push rsi
 lea rdi,qword [rbp-128]
 lea rsi,qword [rbp-24]
 mov rcx,24
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L5 L0 24;

 lea rax,qword [rbp-128]
 ;ir_load_addr L5;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__Aptr__TU_string
 ;ir_call cb__Nstd__Nio__Nprintln__Aptr__TU_string ST;

 mov r10,qword [rbp-8]
 mov edi,r10d
 ;ir_cast [L0 . 2];

 lea rax,qword [rbp-24]
 ;ir_load_addr L0;

 mov rdx,rax
 mov ecx,edi
 call cb__Nstd__Nstring__Nto_string__Aint__Aptr__TU_string
 ;ir_call cb__Nstd__Nstring__Nto_string__Aint__Aptr__TU_string ST ST;

 ;ir_noop ST;

 push rdi
 push rsi
 lea rdi,qword [rbp-152]
 lea rsi,qword [rbp-24]
 mov rcx,24
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L6 L0 24;

 lea rax,qword [rbp-152]
 ;ir_load_addr L6;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__Aptr__TU_string
 ;ir_call cb__Nstd__Nio__Nprintln__Aptr__TU_string ST;

 lea rax,[$cbstr0]
 ;ir_load_addr STR0;

 mov qword [rbp-168],rax
 ;ir_load [L7 . 0] ST;

 mov r10d,5
 mov qword [rbp-160],r10
 ;ir_load [L7 . 1] 5;

 lea rdi,qword [rbp-168]
 ;ir_load_addr L7;

 lea rax,qword [rbp-24]
 ;ir_load_addr L0;

 mov rdx,rax
 mov rcx,rdi
 call cb__Nstd__Nstring__Nappend__Aptr__Tslice__Tpure__Tuint8__Aptr__TU_string
 ;ir_call cb__Nstd__Nstring__Nappend__Aptr__Tslice__Tpure__Tuint8__Aptr__TU_string ST ST;

 ;ir_noop ST;

 push rdi
 push rsi
 lea rdi,qword [rbp-192]
 lea rsi,qword [rbp-24]
 mov rcx,24
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L8 L0 24;

 lea rax,qword [rbp-192]
 ;ir_load_addr L8;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__Aptr__TU_string
 ;ir_call cb__Nstd__Nio__Nprintln__Aptr__TU_string ST;

 mov r10,qword [rbp-16]
 mov edi,r10d
 ;ir_cast [L0 . 1];

 lea rax,qword [rbp-24]
 ;ir_load_addr L0;

 mov rdx,rax
 mov ecx,edi
 call cb__Nstd__Nstring__Nto_string__Aint__Aptr__TU_string
 ;ir_call cb__Nstd__Nstring__Nto_string__Aint__Aptr__TU_string ST ST;

 ;ir_noop ST;

 push rdi
 push rsi
 lea rdi,qword [rbp-216]
 lea rsi,qword [rbp-24]
 mov rcx,24
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L9 L0 24;

 lea rax,qword [rbp-216]
 ;ir_load_addr L9;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__Aptr__TU_string
 ;ir_call cb__Nstd__Nio__Nprintln__Aptr__TU_string ST;

 lea rax,qword [rbp-24]
 ;ir_load_addr L0;

 mov rdx,rax
 mov cl,1
 call cb__Nstd__Nstring__Nto_string__Abool__Aptr__TU_string
 ;ir_call cb__Nstd__Nstring__Nto_string__Abool__Aptr__TU_string 1 ST;

 push rdi
 push rsi
 lea rdi,qword [rbp-240]
 lea rsi,qword [rbp-24]
 mov rcx,24
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L10 L0 24;

 lea rax,qword [rbp-240]
 ;ir_load_addr L10;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__Aptr__TU_string
 ;ir_call cb__Nstd__Nio__Nprintln__Aptr__TU_string ST;

 lea rax,qword [rbp-24]
 ;ir_load_addr L0;

 mov rdx,rax
 mov cl,0
 call cb__Nstd__Nstring__Nto_string__Abool__Aptr__TU_string
 ;ir_call cb__Nstd__Nstring__Nto_string__Abool__Aptr__TU_string 0 ST;

 push rdi
 push rsi
 lea rdi,qword [rbp-264]
 lea rsi,qword [rbp-24]
 mov rcx,24
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L11 L0 24;

 lea rax,qword [rbp-264]
 ;ir_load_addr L11;

 mov rcx,rax
 call cb__Nstd__Nio__Nprintln__Aptr__TU_string
 ;ir_call cb__Nstd__Nio__Nprintln__Aptr__TU_string ST;

 mov eax,0
 ;ir_return 0;

cb__Nmain__Nmain__Aptr__Tslice__Tslice__Tpure__Tuint8$end:
 add rsp,288
 pop rdi
 pop rbx
 pop rbp
 ret


cb__Nstd__Nio__Nprint__Aptr__TU_string:
 ;func print(string): {}
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,40
 ;prolog end

 lea rax,qword [rbp-16]
 ;ir_load_addr L0;

 mov rdx,qword [rbp+24]
 mov rcx,rax
 call cb__Nstd__Nstring__Nas_slice__Aptr__Tslice__Tpure__Tuint8__Aptr__Tpure__TU_string
 mov rbx,rax
 ;ir_call cb__Nstd__Nstring__Nas_slice__Aptr__Tslice__Tpure__Tuint8__Aptr__Tpure__TU_string ST A0;

 lea rax,qword [rbp-16]
 ;ir_load_addr L0;

 mov rcx,rax
 call cb__Nstd__Nruntime__Nio__Nwrite__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nruntime__Nio__Nwrite__Aptr__Tslice__Tpure__Tuint8 ST;

 ;ir_noop ST;

cb__Nstd__Nio__Nprint__Aptr__TU_string$end:
 add rsp,40
 pop rbx
 pop rbp
 ret


cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8:
 ;func print([]pure uint8): {}
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov rax,qword [rbp+16]
 ;ir_deref A0;

 push rdi
 push rsi
 lea rdi,qword [rbp-16]
 lea rsi,qword [rax]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L0 ST 16;

 lea rax,qword [rbp-16]
 ;ir_load_addr L0;

 mov rcx,rax
 call cb__Nstd__Nruntime__Nio__Nwrite__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nruntime__Nio__Nwrite__Aptr__Tslice__Tpure__Tuint8 ST;

 ;ir_noop ST;

cb__Nstd__Nio__Nprint__Aptr__Tslice__Tpure__Tuint8$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nio__Nprintln__Aptr__TU_string:
 ;func println(string): {}
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,56
 ;prolog end

 lea rax,qword [rbp-16]
 ;ir_load_addr L0;

 mov rdx,qword [rbp+24]
 mov rcx,rax
 call cb__Nstd__Nstring__Nas_slice__Aptr__Tslice__Tpure__Tuint8__Aptr__Tpure__TU_string
 mov rbx,rax
 ;ir_call cb__Nstd__Nstring__Nas_slice__Aptr__Tslice__Tpure__Tuint8__Aptr__Tpure__TU_string ST A0;

 lea rax,qword [rbp-16]
 ;ir_load_addr L0;

 mov rcx,rax
 call cb__Nstd__Nruntime__Nio__Nwrite__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nruntime__Nio__Nwrite__Aptr__Tslice__Tpure__Tuint8 ST;

 ;ir_noop ST;

 lea rax,[$cbstr1]
 ;ir_load_addr STR1;

 mov qword [rbp-32],rax
 ;ir_load [L1 . 0] ST;

 mov r10d,1
 mov qword [rbp-24],r10
 ;ir_load [L1 . 1] 1;

 lea rax,qword [rbp-32]
 ;ir_load_addr L1;

 mov rcx,rax
 call cb__Nstd__Nruntime__Nio__Nwrite__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nruntime__Nio__Nwrite__Aptr__Tslice__Tpure__Tuint8 ST;

 ;ir_noop ST;

cb__Nstd__Nio__Nprintln__Aptr__TU_string$end:
 add rsp,56
 pop rbx
 pop rbp
 ret


cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8:
 ;func println([]pure uint8): {}
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,48
 ;prolog end

 mov rax,qword [rbp+16]
 ;ir_deref A0;

 push rdi
 push rsi
 lea rdi,qword [rbp-16]
 lea rsi,qword [rax]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L0 ST 16;

 lea rax,qword [rbp-16]
 ;ir_load_addr L0;

 mov rcx,rax
 call cb__Nstd__Nruntime__Nio__Nwrite__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nruntime__Nio__Nwrite__Aptr__Tslice__Tpure__Tuint8 ST;

 ;ir_noop ST;

 lea rax,[$cbstr1]
 ;ir_load_addr STR1;

 mov qword [rbp-32],rax
 ;ir_load [L1 . 0] ST;

 mov r10d,1
 mov qword [rbp-24],r10
 ;ir_load [L1 . 1] 1;

 lea rax,qword [rbp-32]
 ;ir_load_addr L1;

 mov rcx,rax
 call cb__Nstd__Nruntime__Nio__Nwrite__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nruntime__Nio__Nwrite__Aptr__Tslice__Tpure__Tuint8 ST;

 ;ir_noop ST;

cb__Nstd__Nio__Nprintln__Aptr__Tslice__Tpure__Tuint8$end:
 add rsp,48
 pop rbp
 ret


cb__Nstd__Nmemory__Narena__Nalign__Ausize__Ausize:
 ;func align(usize, usize): usize
 push rbp
 mov rbp,rsp
 ;prolog end

 mov rax,rcx
 ;ir_return A0;

cb__Nstd__Nmemory__Narena__Nalign__Ausize__Ausize$end:
 pop rbp
 ret


cb__Nstd__Nmemory__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize:
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
 jg cb__Nstd__Nmemory__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if2670$else
 ;ir_jmp_gt ST [ . 1] cb__Nstd__Nmemory__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if2670$else;

cb__Nstd__Nmemory__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if2670$body:
 ;ir_make_label cb__Nstd__Nmemory__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if2670$body;

 mov r10b,1
 mov byte [rbp-1],r10b
 ;ir_load L0 1;

 jmp cb__Nstd__Nmemory__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if2670$end
 ;ir_jmp cb__Nstd__Nmemory__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if2670$end;

cb__Nstd__Nmemory__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if2670$else:
 ;ir_make_label cb__Nstd__Nmemory__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if2670$else;

 mov r10b,0
 mov byte [rbp-1],r10b
 ;ir_load L0 0;

cb__Nstd__Nmemory__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if2670$end:
 ;ir_make_label cb__Nstd__Nmemory__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$if2670$end;

 mov al,byte [rbp-1]
 ;ir_return L0;

cb__Nstd__Nmemory__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize$end:
 add rsp,24
 pop rbx
 pop rbp
 ret


cb__Nstd__Nmemory__Narena__Nallocate_in_block__Aptr__TU_memory__Aptr__TU_arena_block__Ausize:
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

cb__Nstd__Nmemory__Narena__Nallocate_in_block__Aptr__TU_memory__Aptr__TU_arena_block__Ausize$end:
 add rsp,24
 pop rbx
 pop rbp
 ret


cb__Nstd__Nmemory__Narena__Nmake_arena_allocator__Aptr__TU_arena__Ausize:
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

 mov r10d,0
 mov qword [rbp-16],r10
 ;ir_load [L0 . 1] 0;

 mov r10d,0
 mov qword [rbp-8],r10
 ;ir_load [L0 . 2] 0;

 mov r10,8
 mov qword [rbp-16],r10
 ;ir_load [L0 . 1] 8;

 mov rdx,qword [rbp-16]
 mov rcx,qword [rbp+24]
 call cb__Nstd__Nmemory__Narena__Nalign__Ausize__Ausize
 ;ir_call cb__Nstd__Nmemory__Narena__Nalign__Ausize__Ausize A1 [L0 . 1];

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

cb__Nstd__Nmemory__Narena__Nmake_arena_allocator__Aptr__TU_arena__Ausize$end:
 add rsp,48
 pop rbp
 ret


cb__Nstd__Nmemory__Narena__Nfree__Aptr__TU_arena:
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

cb__Nstd__Nmemory__Narena__Nfree__Aptr__TU_arena$w527$cond:
 ;ir_make_label cb__Nstd__Nmemory__Narena__Nfree__Aptr__TU_arena$w527$cond;

 mov r10,qword [rbp-8]
 cmp r10,0
 je cb__Nstd__Nmemory__Narena__Nfree__Aptr__TU_arena$w527$end
 ;ir_jmp_eq L0 0 cb__Nstd__Nmemory__Narena__Nfree__Aptr__TU_arena$w527$end;

cb__Nstd__Nmemory__Narena__Nfree__Aptr__TU_arena$w527$body:
 ;ir_make_label cb__Nstd__Nmemory__Narena__Nfree__Aptr__TU_arena$w527$body;

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

 jmp cb__Nstd__Nmemory__Narena__Nfree__Aptr__TU_arena$w527$cond
 ;ir_jmp cb__Nstd__Nmemory__Narena__Nfree__Aptr__TU_arena$w527$cond;

cb__Nstd__Nmemory__Narena__Nfree__Aptr__TU_arena$w527$end:
 ;ir_make_label cb__Nstd__Nmemory__Narena__Nfree__Aptr__TU_arena$w527$end;

cb__Nstd__Nmemory__Narena__Nfree__Aptr__TU_arena$end:
 add rsp,48
 pop rbp
 ret


cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize:
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
 call cb__Nstd__Nmemory__Narena__Nalign__Ausize__Ausize
 ;ir_call cb__Nstd__Nmemory__Narena__Nalign__Ausize__Ausize A2 [ST . 1];

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

 mov rax,qword [rbp+48]
 ;ir_deref A1;

 mov r10,qword [rax+0]
 mov qword [rbp-16],r10
 ;ir_load L1 [ST . 0];

cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w585$cond:
 ;ir_make_label cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w585$cond;

 mov r10,qword [rbp-16]
 cmp r10,0
 je cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w585$end
 ;ir_jmp_eq L1 0 cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w585$end;

cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w585$body:
 ;ir_make_label cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w585$body;

 mov r10,qword [rbp-16]
 mov qword [rbp-48],r10
 ;ir_load L4 L1;

 mov rdx,qword [rbp-8]
 mov rcx,qword [rbp-48]
 call cb__Nstd__Nmemory__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize
 ;ir_call cb__Nstd__Nmemory__Narena__Nfits_in_block__Aptr__TU_arena_block__Ausize L4 L0;

 cmp al,0
 je cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$if582$else
 ;ir_jmp_eq ST 0 cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$if582$else;

cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$if582$body:
 ;ir_make_label cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$if582$body;

 mov r8,qword [rbp-8]
 mov rdx,qword [rbp-48]
 mov rcx,qword [rbp+40]
 call cb__Nstd__Nmemory__Narena__Nallocate_in_block__Aptr__TU_memory__Aptr__TU_arena_block__Ausize
 mov rbx,rax
 ;ir_call cb__Nstd__Nmemory__Narena__Nallocate_in_block__Aptr__TU_memory__Aptr__TU_arena_block__Ausize A0 L4 L0;

 mov rax,qword [rbp+40]
 jmp cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$end
 ;ir_return A0;

 ;ir_noop ST;

cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$if582$else:
 ;ir_make_label cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$if582$else;

 jmp cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w585$cond
 ;ir_jmp cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w585$cond;

cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w585$end:
 ;ir_make_label cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$w585$end;

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

 mov r10d,0
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
 call cb__Nstd__Nmemory__Narena__Nallocate_in_block__Aptr__TU_memory__Aptr__TU_arena_block__Ausize
 mov rsi,rax
 ;ir_call cb__Nstd__Nmemory__Narena__Nallocate_in_block__Aptr__TU_memory__Aptr__TU_arena_block__Ausize A0 L3 L0;

 mov rax,qword [rbp+40]
 jmp cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$end
 ;ir_return A0;

 ;ir_noop ST;

cb__Nstd__Nmemory__Narena__Nalloc__Aptr__TU_memory__Aptr__TU_arena__Ausize$end:
 add rsp,88
 pop rsi
 pop rdi
 pop rbx
 pop rbp
 ret


cb__Nstd__Nmemory__Ncopy__Arawptr__Arawptr__Ausize:
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
    
cb__Nstd__Nmemory__Ncopy__Arawptr__Arawptr__Ausize$end:
 pop rbp
 ret


cb__Nstd__Nmemory__Nset__Arawptr__Auint8__Ausize:
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
    
cb__Nstd__Nmemory__Nset__Arawptr__Auint8__Ausize$end:
 pop rbp
 ret


cb__Nstd__Nmemory__Nset__Aptr__TU_memory__Auint8:
 ;func set(&memory, uint8): {}
 mov byte [rsp+16],dl
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,40
 ;prolog end

 mov rbx,qword [rbp+24]
 ;ir_deref A0;

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 mov r8,qword [rax+8]
 mov dl,byte [rbp+32]
 mov rcx,qword [rbx+0]
 call cb__Nstd__Nmemory__Nset__Arawptr__Auint8__Ausize
 ;ir_call cb__Nstd__Nmemory__Nset__Arawptr__Auint8__Ausize [ST . 0] A1 [ST . 1];

cb__Nstd__Nmemory__Nset__Aptr__TU_memory__Auint8$end:
 add rsp,40
 pop rbx
 pop rbp
 ret


cb__Nstd__Nmemory__Nas_memory__Aptr__TU_memory__Aptr__Tarray__I32__Tuint8:
 ;func as_memory(&memory, &[32]uint8): &memory
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,8
 ;prolog end

 mov rbx,rcx
 ;ir_deref A0;

 mov rax,rdx
 ;ir_deref A1;

 mov r10,0
 lea rax,qword [rax+r10*1]
 ;ir_index ST 0;

 lea rax,byte [rax+0]
 ;ir_load_addr ST;

 mov qword [rbx+0],rax
 ;ir_load [ST . 0] ST;

 mov rax,rcx
 ;ir_deref A0;

 mov r10,32
 mov qword [rax+8],r10
 ;ir_load [ST . 1] 32;

 mov rax,rcx
 ;ir_return A0;

cb__Nstd__Nmemory__Nas_memory__Aptr__TU_memory__Aptr__Tarray__I32__Tuint8$end:
 add rsp,8
 pop rbx
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
 call cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8
 ;ir_call cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8 A0;

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
 add r10,1
 mov rax,r10
 ;ir_add A1 1;

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
 call cb__Nstd__Nmemory__Ncopy__Arawptr__Arawptr__Ausize
 ;ir_call cb__Nstd__Nmemory__Ncopy__Arawptr__Arawptr__Ausize A0 A1 A2;

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
 call cb__Nstd__Nmemory__Nset__Arawptr__Auint8__Ausize
 ;ir_call cb__Nstd__Nmemory__Nset__Arawptr__Auint8__Ausize A0 A1 A2;

cb__Nstd__Nrawstring__Nset__Aptr__Tpure__Tuint8__Apure__Tuint8__Ausize$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8:
 ;func length(&pure uint8): usize
 push rbp
 mov rbp,rsp
 sub rsp,16
 ;prolog end

 mov r10,0
 mov qword [rbp-8],r10
 ;ir_load L0 0;

 mov qword [rbp-16],rcx
 ;ir_load L1 A0;

cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8$w1006$cond:
 ;ir_make_label cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8$w1006$cond;

 mov rax,qword [rbp-16]
 ;ir_deref L1;

 movzx eax,byte [rax]
 ;ir_cast ST;

 cmp eax,0
 je cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8$w1006$end
 ;ir_jmp_eq ST 0 cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8$w1006$end;

cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8$w1006$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8$w1006$body;

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

 jmp cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8$w1006$cond
 ;ir_jmp cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8$w1006$cond;

cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8$w1006$end:
 ;ir_make_label cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8$w1006$end;

 mov rax,qword [rbp-8]
 ;ir_return L0;

cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8$end:
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
 call cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8
 mov rbx,rax
 ;ir_call cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8 A0;

 mov rcx,qword [rbp+32]
 call cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8
 ;ir_call cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8 A1;

 cmp rbx,rax
 je cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if1042$else
 ;ir_jmp_eq ST ST cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if1042$else;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if1042$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if1042$body;

 mov al,0
 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$end
 ;ir_return 0;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if1042$else:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if1042$else;

 mov r10d,0
 mov dword [rbp-16],r10d
 ;ir_load [L0 . 0] 0;

 mov rcx,qword [rbp+24]
 call cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8
 ;ir_call cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8 A0;

 mov qword [rbp-12],rax
 ;ir_load [L0 . 1] ST;

 mov r10d,dword [rbp-16]
 mov dword [rbp-24],r10d
 ;ir_load L2 [L0 . 0];

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f1068$cond:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f1068$cond;

 movsxd rax,dword [rbp-24]
 ;ir_cast L2;

 cmp rax,qword [rbp-12]
 jge cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f1068$end
 ;ir_jmp_gte ST [L0 . 1] cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f1068$end;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f1068$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f1068$body;

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
 je cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if1065$else
 ;ir_jmp_eq ST ST cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if1065$else;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if1065$body:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if1065$body;

 mov al,0
 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$end
 ;ir_return 0;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if1065$else:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$if1065$else;

 mov r10d,dword [rbp-24]
 add r10d,1
 mov eax,r10d
 ;ir_add L2 1;

 mov dword [rbp-24],eax
 ;ir_load L2 ST;

 jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f1068$cond
 ;ir_jmp cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f1068$cond;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f1068$end:
 ;ir_make_label cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$f1068$end;

 mov al,1
 ;ir_return 1;

cb__Nstd__Nrawstring__Nequals__Aptr__Tpure__Tuint8__Aptr__Tpure__Tuint8$end:
 add rsp,56
 pop rbx
 pop rbp
 ret


cb__Nstd__Nruntime__Nio__Nwrite__Aint__Aptr__Tpure__Tuint8__Ausize:
 ;func write(int, &pure uint8, usize): int
 mov qword [rsp+24],r8
 mov qword [rsp+16],rdx
 mov dword [rsp+8],ecx
 push rbp
 mov rbp,rsp
 sub rsp,64
 ;prolog end

 mov r10d,0
 mov dword [rbp-4],r10d
 ;ir_load L0 0;

 lea rax,dword [rbp-4]
 ;ir_load_addr L0;

 mov qword [rsp+32],0
 mov r9,rax
 mov r8,qword [rbp+32]
 mov rdx,qword [rbp+24]
 mov ecx,dword [rbp+16]
 call WriteFile
 ;ir_call WriteFile A0 A1 A2 ST 0;

 mov eax,dword [rbp-4]
 ;ir_return L0;

cb__Nstd__Nruntime__Nio__Nwrite__Aint__Aptr__Tpure__Tuint8__Ausize$end:
 add rsp,64
 pop rbp
 ret


cb__Nstd__Nruntime__Nio__Nwrite__Aptr__Tslice__Tpure__Tuint8:
 ;func write([]pure uint8): int
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,56
 ;prolog end

 mov eax,11
 neg eax
 ;ir_neg 11;

 mov ecx,eax
 call GetStdHandle
 ;ir_call GetStdHandle ST;

 mov dword [rbp-4],eax
 ;ir_load L0 ST;

 mov rbx,qword [rbp+24]
 ;ir_deref A0;

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 mov r8,qword [rax+8]
 mov rdx,qword [rbx+0]
 mov ecx,dword [rbp-4]
 call cb__Nstd__Nruntime__Nio__Nwrite__Aint__Aptr__Tpure__Tuint8__Ausize
 ;ir_call cb__Nstd__Nruntime__Nio__Nwrite__Aint__Aptr__Tpure__Tuint8__Ausize L0 [ST . 0] [ST . 1];

 ;ir_return ST;

cb__Nstd__Nruntime__Nio__Nwrite__Aptr__Tslice__Tpure__Tuint8$end:
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
 mov edx,0
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
 mov edx,0
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


cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string:
 ;func int_to_string(int, int, &string): int
 mov qword [rsp+24],r8
 mov dword [rsp+16],edx
 mov dword [rsp+8],ecx
 push rbp
 push rbx
 push rdi
 mov rbp,rsp
 sub rsp,80
 ;prolog end

 mov r10d,dword [rbp+40]
 cmp r10d,2
 jl cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1383$body
 ;ir_jmp_lt A1 2 cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1383$body;

 mov r10d,dword [rbp+40]
 cmp r10d,36
 jle cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1383$else
 ;ir_jmp_lte A1 36 cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1383$else;

cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1383$body:
 ;ir_make_label cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1383$body;

 mov eax,0
 jmp cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$end
 ;ir_return 0;

cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1383$else:
 ;ir_make_label cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1383$else;

 mov rax,qword [rbp+48]
 ;ir_deref A2;

 push rdi
 push rsi
 lea rdi,qword [rbp-24]
 lea rsi,qword [rax]
 mov rcx,24
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L0 ST 24;

 lea rax,[$cbstr2]
 ;ir_load_addr STR2;

 mov qword [rbp-40],rax
 ;ir_load [L1 . 0] ST;

 mov r10d,71
 mov qword [rbp-32],r10
 ;ir_load [L1 . 1] 71;

 mov r10d,0
 mov dword [rbp-44],r10d
 ;ir_load L2 0;

 mov r10d,0
 mov dword [rbp-48],r10d
 ;ir_load L3 0;

cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1447$cond:
 ;ir_make_label cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1447$cond;

 mov r10d,dword [rbp+32]
 cmp r10d,0
 je cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1447$end
 ;ir_jmp_eq A0 0 cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1447$end;

cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1447$body:
 ;ir_make_label cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1447$body;

 movsxd rax,dword [rbp-48]
 ;ir_cast L3;

 cmp rax,qword [rbp-8]
 jl cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1416$else
 ;ir_jmp_lt ST [L0 . 2] cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1416$else;

cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1416$body:
 ;ir_make_label cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1416$body;

 mov r10d,dword [rbp-48]
 sub r10d,1
 mov eax,r10d
 ;ir_sub L3 1;

 mov dword [rbp-48],eax
 ;ir_load L3 ST;

 jmp cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1447$end
 ;ir_jmp cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1447$end;

cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1416$else:
 ;ir_make_label cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1416$else;

 mov r10d,dword [rbp+32]
 mov dword [rbp-44],r10d
 ;ir_load L2 A0;

 mov eax,dword [rbp+32]
 cdq
 idiv dword [rbp+40]
 ;ir_div A0 A1;

 mov dword [rbp+32],eax
 ;ir_load A0 ST;

 mov rax,qword [rbp-24]
 ;ir_deref [L0 . 0];

 movsxd r10,dword [rbp-48]
 lea rbx,byte [rax+r10*1]
 ;ir_index ST L3;

 mov rdi,qword [rbp-40]
 ;ir_deref [L1 . 0];

 mov r10d,dword [rbp+32]
 imul r10d,dword [rbp+40]
 mov eax,r10d
 ;ir_mul A0 A1;

 mov r10d,dword [rbp-44]
 sub r10d,eax
 mov eax,r10d
 ;ir_sub L2 ST;

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

 mov r10d,dword [rbp-48]
 add r10d,1
 mov eax,r10d
 ;ir_add L3 1;

 mov dword [rbp-48],eax
 ;ir_load L3 ST;

 jmp cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1447$cond
 ;ir_jmp cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1447$cond;

cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1447$end:
 ;ir_make_label cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1447$end;

 mov rax,qword [rbp-24]
 ;ir_deref [L0 . 0];

 movsxd r10,dword [rbp-48]
 lea rax,byte [rax+r10*1]
 ;ir_index ST L3;

 lea rax,byte [rax+0]
 ;ir_load_addr ST;

 mov qword [rbp-56],rax
 ;ir_load L4 ST;

 mov rax,qword [rbp-24]
 ;ir_deref [L0 . 0];

 mov r10,0
 lea rax,byte [rax+r10*1]
 ;ir_index ST 0;

 lea rax,byte [rax+0]
 ;ir_load_addr ST;

 mov qword [rbp-64],rax
 ;ir_load L5 ST;

 mov r10d,dword [rbp-44]
 cmp r10d,0
 jge cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1485$else
 ;ir_jmp_gte L2 0 cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1485$else;

cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1485$body:
 ;ir_make_label cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1485$body;

 mov rax,qword [rbp-56]
 ;ir_deref L4;

 mov r10b,45
 mov byte [rax],r10b
 ;ir_load ST #45;

 mov r10,qword [rbp-56]
 add r10,1
 mov rax,r10
 ;ir_add L4 1;

 mov qword [rbp-56],rax
 ;ir_load L4 ST;

cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1485$else:
 ;ir_make_label cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$if1485$else;

 mov rax,qword [rbp-56]
 ;ir_deref L4;

 mov r10b,0
 mov byte [rax],r10b
 ;ir_load ST #0;

 mov r10,qword [rbp-56]
 sub r10,1
 mov rax,r10
 ;ir_sub L4 1;

 mov qword [rbp-56],rax
 ;ir_load L4 ST;

 mov r10b,0
 mov byte [rbp-65],r10b
 ;ir_load L6 0;

cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1529$cond:
 ;ir_make_label cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1529$cond;

 mov r10,qword [rbp-64]
 cmp r10,qword [rbp-56]
 jge cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1529$end
 ;ir_jmp_gte L5 L4 cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1529$end;

cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1529$body:
 ;ir_make_label cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1529$body;

 mov rax,qword [rbp-56]
 ;ir_deref L4;

 mov r10b,byte [rax]
 mov byte [rbp-65],r10b
 ;ir_load L6 ST;

 mov rbx,qword [rbp-56]
 ;ir_deref L4;

 mov rax,qword [rbp-64]
 ;ir_deref L5;

 mov r10b,byte [rax]
 mov byte [rbx],r10b
 ;ir_load ST ST;

 mov r10,qword [rbp-56]
 sub r10,1
 mov rax,r10
 ;ir_sub L4 1;

 mov qword [rbp-56],rax
 ;ir_load L4 ST;

 mov rax,qword [rbp-64]
 ;ir_deref L5;

 mov r10b,byte [rbp-65]
 mov byte [rax],r10b
 ;ir_load ST L6;

 mov r10,qword [rbp-64]
 add r10,1
 mov rax,r10
 ;ir_add L5 1;

 mov qword [rbp-64],rax
 ;ir_load L5 ST;

 jmp cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1529$cond
 ;ir_jmp cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1529$cond;

cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1529$end:
 ;ir_make_label cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$w1529$end;

 mov rbx,qword [rbp+48]
 ;ir_deref A2;

 movsxd rax,dword [rbp-48]
 ;ir_cast L3;

 mov qword [rbx+8],rax
 ;ir_load [ST . 1] ST;

 mov eax,0
 ;ir_return 0;

cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string$end:
 add rsp,80
 pop rdi
 pop rbx
 pop rbp
 ret


cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__Tpure__Tuint8:
 ;func as_string(&string, &pure uint8): &string
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
 call cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8
 ;ir_call cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8 A1;

 mov qword [rbx+8],rax
 ;ir_load [ST . 1] ST;

 mov rbx,qword [rbp+24]
 ;ir_deref A0;

 mov rcx,qword [rbp+32]
 call cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8
 ;ir_call cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8 A1;

 mov qword [rbx+16],rax
 ;ir_load [ST . 2] ST;

 mov rax,qword [rbp+24]
 ;ir_return A0;

cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__Tpure__Tuint8$end:
 add rsp,24
 pop rbx
 pop rbp
 ret


cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__Tslice__Tpure__Tuint8:
 ;func as_string(&string, &[]pure uint8): &string
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
 mov qword [rbx+0],r10
 ;ir_load [ST . 0] [ST . 0];

 mov rbx,rcx
 ;ir_deref A0;

 mov rax,rdx
 ;ir_deref A1;

 mov r10,qword [rax+8]
 mov qword [rbx+8],r10
 ;ir_load [ST . 1] [ST . 1];

 mov rbx,rcx
 ;ir_deref A0;

 mov rax,rdx
 ;ir_deref A1;

 mov r10,qword [rax+8]
 add r10,1
 mov rax,r10
 ;ir_add [ST . 1] 1;

 mov qword [rbx+16],rax
 ;ir_load [ST . 2] ST;

 mov rax,rcx
 ;ir_return A0;

cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__Tslice__Tpure__Tuint8$end:
 add rsp,8
 pop rbx
 pop rbp
 ret


cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__TU_memory:
 ;func as_string(&string, &memory): &string
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,40
 ;prolog end

 mov rax,qword [rbp+32]
 ;ir_deref A1;

 mov r10,qword [rax+0]
 mov qword [rbp-8],r10
 ;ir_load L0 [ST . 0];

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 mov r10,qword [rbp-8]
 mov qword [rax+0],r10
 ;ir_load [ST . 0] L0;

 mov rbx,qword [rbp+24]
 ;ir_deref A0;

 mov rcx,qword [rbp-8]
 call cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8
 ;ir_call cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8 L0;

 mov qword [rbx+8],rax
 ;ir_load [ST . 1] ST;

 mov rbx,qword [rbp+24]
 ;ir_deref A0;

 mov rax,qword [rbp+32]
 ;ir_deref A1;

 mov r10,qword [rax+8]
 mov qword [rbx+16],r10
 ;ir_load [ST . 2] [ST . 1];

 mov rax,qword [rbp+24]
 ;ir_return A0;

cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__TU_memory$end:
 add rsp,40
 pop rbx
 pop rbp
 ret


cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__Tslice__Tuint8:
 ;func as_string(&string, &[]uint8): &string
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,24
 ;prolog end

 mov rbx,qword [rbp+24]
 ;ir_deref A0;

 mov rax,qword [rbp+32]
 ;ir_deref A1;

 mov r10,qword [rax+0]
 mov qword [rbx+0],r10
 ;ir_load [ST . 0] [ST . 0];

 mov rbx,qword [rbp+24]
 ;ir_deref A0;

 mov rax,qword [rbp+32]
 ;ir_deref A1;

 mov rcx,qword [rax+0]
 call cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8
 ;ir_call cb__Nstd__Nrawstring__Nlength__Aptr__Tpure__Tuint8 [ST . 0];

 mov qword [rbx+8],rax
 ;ir_load [ST . 1] ST;

 mov rbx,qword [rbp+24]
 ;ir_deref A0;

 mov rax,qword [rbp+32]
 ;ir_deref A1;

 mov r10,qword [rax+8]
 mov qword [rbx+16],r10
 ;ir_load [ST . 2] [ST . 1];

 mov rax,qword [rbp+24]
 ;ir_return A0;

cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__Tslice__Tuint8$end:
 add rsp,24
 pop rbx
 pop rbp
 ret


cb__Nstd__Nstring__Nas_slice__Aptr__Tslice__Tpure__Tuint8__Aptr__Tpure__TU_string:
 ;func as_slice(&[]pure uint8, &pure string): &[]pure uint8
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
 mov qword [rbx+0],r10
 ;ir_load [ST . 0] [ST . 0];

 mov rbx,rcx
 ;ir_deref A0;

 mov rax,rdx
 ;ir_deref A1;

 mov r10,qword [rax+8]
 mov qword [rbx+8],r10
 ;ir_load [ST . 1] [ST . 1];

 mov rax,rcx
 ;ir_return A0;

cb__Nstd__Nstring__Nas_slice__Aptr__Tslice__Tpure__Tuint8__Aptr__Tpure__TU_string$end:
 add rsp,8
 pop rbx
 pop rbp
 ret


cb__Nstd__Nstring__Nto_string__Aint__Aptr__TU_string:
 ;func to_string(int, &string): int
 mov qword [rsp+16],rdx
 mov dword [rsp+8],ecx
 push rbp
 mov rbp,rsp
 sub rsp,48
 ;prolog end

 mov r8,qword [rbp+24]
 mov edx,10
 mov ecx,dword [rbp+16]
 call cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string
 ;ir_call cb__Nstd__Nstring__Nint_to_string__Aint__Aint__Aptr__TU_string A0 10 A1;

 mov dword [rbp-4],eax
 ;ir_load L0 ST;

 mov eax,dword [rbp-4]
 ;ir_return L0;

cb__Nstd__Nstring__Nto_string__Aint__Aptr__TU_string$end:
 add rsp,48
 pop rbp
 ret


cb__Nstd__Nstring__Nto_string__Abool__Aptr__TU_string:
 ;func to_string(bool, &string): {}
 mov qword [rsp+16],rdx
 mov byte [rsp+8],cl
 push rbp
 mov rbp,rsp
 sub rsp,48
 ;prolog end

 mov r10b,byte [rbp+16]
 cmp r10b,0
 je cb__Nstd__Nstring__Nto_string__Abool__Aptr__TU_string$if1752$else
 ;ir_jmp_eq A0 0 cb__Nstd__Nstring__Nto_string__Abool__Aptr__TU_string$if1752$else;

cb__Nstd__Nstring__Nto_string__Abool__Aptr__TU_string$if1752$body:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Abool__Aptr__TU_string$if1752$body;

 lea rax,[$cbstr3]
 ;ir_load_addr STR3;

 mov qword [rbp-16],rax
 ;ir_load [L0 . 0] ST;

 mov r10d,4
 mov qword [rbp-8],r10
 ;ir_load [L0 . 1] 4;

 lea rax,qword [rbp-16]
 ;ir_load_addr L0;

 mov rdx,rax
 mov rcx,qword [rbp+24]
 call cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__Tslice__Tpure__Tuint8 A1 ST;

 ;ir_noop ST;

 jmp cb__Nstd__Nstring__Nto_string__Abool__Aptr__TU_string$if1752$end
 ;ir_jmp cb__Nstd__Nstring__Nto_string__Abool__Aptr__TU_string$if1752$end;

cb__Nstd__Nstring__Nto_string__Abool__Aptr__TU_string$if1752$else:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Abool__Aptr__TU_string$if1752$else;

 lea rax,[$cbstr4]
 ;ir_load_addr STR4;

 mov qword [rbp-32],rax
 ;ir_load [L1 . 0] ST;

 mov r10d,5
 mov qword [rbp-24],r10
 ;ir_load [L1 . 1] 5;

 lea rax,qword [rbp-32]
 ;ir_load_addr L1;

 mov rdx,rax
 mov rcx,qword [rbp+24]
 call cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nstring__Nas_string__Aptr__TU_string__Aptr__Tslice__Tpure__Tuint8 A1 ST;

 ;ir_noop ST;

cb__Nstd__Nstring__Nto_string__Abool__Aptr__TU_string$if1752$end:
 ;ir_make_label cb__Nstd__Nstring__Nto_string__Abool__Aptr__TU_string$if1752$end;

cb__Nstd__Nstring__Nto_string__Abool__Aptr__TU_string$end:
 add rsp,48
 pop rbp
 ret


cb__Nstd__Nstring__Nappend__Aptr__Tslice__Tpure__Tuint8__Aptr__TU_string:
 ;func append([]pure uint8, &string): usize
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,56
 ;prolog end

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 mov r10,qword [rax+8]
 mov qword [rbp-8],r10
 ;ir_load L0 [ST . 1];

 mov rax,qword [rbp+32]
 ;ir_deref A1;

 mov r10,qword [rbp-8]
 add r10,qword [rax+8]
 mov rbx,r10
 ;ir_add L0 [ST . 1];

 mov rax,qword [rbp+32]
 ;ir_deref A1;

 cmp rbx,qword [rax+16]
 jle cb__Nstd__Nstring__Nappend__Aptr__Tslice__Tpure__Tuint8__Aptr__TU_string$if1798$else
 ;ir_jmp_lte ST [ST . 2] cb__Nstd__Nstring__Nappend__Aptr__Tslice__Tpure__Tuint8__Aptr__TU_string$if1798$else;

cb__Nstd__Nstring__Nappend__Aptr__Tslice__Tpure__Tuint8__Aptr__TU_string$if1798$body:
 ;ir_make_label cb__Nstd__Nstring__Nappend__Aptr__Tslice__Tpure__Tuint8__Aptr__TU_string$if1798$body;

 mov rbx,qword [rbp+32]
 ;ir_deref A1;

 mov rax,qword [rbp+32]
 ;ir_deref A1;

 mov r10,qword [rbx+16]
 sub r10,qword [rax+8]
 mov rax,r10
 ;ir_sub [ST . 2] [ST . 1];

 mov qword [rbp-8],rax
 ;ir_load L0 ST;

cb__Nstd__Nstring__Nappend__Aptr__Tslice__Tpure__Tuint8__Aptr__TU_string$if1798$else:
 ;ir_make_label cb__Nstd__Nstring__Nappend__Aptr__Tslice__Tpure__Tuint8__Aptr__TU_string$if1798$else;

 mov rbx,qword [rbp+32]
 ;ir_deref A1;

 mov rax,qword [rbp+32]
 ;ir_deref A1;

 mov r10,qword [rbx+0]
 add r10,qword [rax+8]
 mov rbx,r10
 ;ir_add [ST . 0] [ST . 1];

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 mov r8,qword [rbp-8]
 mov rdx,qword [rax+0]
 mov rcx,rbx
 call cb__Nstd__Nmemory__Ncopy__Arawptr__Arawptr__Ausize
 ;ir_call cb__Nstd__Nmemory__Ncopy__Arawptr__Arawptr__Ausize ST [ST . 0] L0;

 mov rbx,qword [rbp+32]
 ;ir_deref A1;

 mov rax,qword [rbp+32]
 ;ir_deref A1;

 mov r10,qword [rax+8]
 add r10,qword [rbp-8]
 mov rax,r10
 ;ir_add [ST . 1] L0;

 mov qword [rbx+8],rax
 ;ir_load [ST . 1] ST;

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 mov r10,qword [rax+8]
 sub r10,qword [rbp-8]
 mov rax,r10
 ;ir_sub [ST . 1] L0;

 ;ir_return ST;

cb__Nstd__Nstring__Nappend__Aptr__Tslice__Tpure__Tuint8__Aptr__TU_string$end:
 add rsp,56
 pop rbx
 pop rbp
 ret


cb__Nstd__Ntime__Nget_tick_counter:
 ;func get_tick_counter(): ticks
 push rbp
 mov rbp,rsp
 sub rsp,48
 ;prolog end

 mov r10,0
 mov qword [rbp-8],r10
 ;ir_load L0 0;

 lea rax,qword [rbp-8]
 ;ir_load_addr L0;

 mov rcx,rax
 call QueryPerformanceCounter
 ;ir_call QueryPerformanceCounter ST;

 cmp al,0
 je cb__Nstd__Ntime__Nget_tick_counter$if1913$else
 ;ir_jmp_eq ST 0 cb__Nstd__Ntime__Nget_tick_counter$if1913$else;

cb__Nstd__Ntime__Nget_tick_counter$if1913$body:
 ;ir_make_label cb__Nstd__Ntime__Nget_tick_counter$if1913$body;

 mov rax,qword [rbp-8]
 jmp cb__Nstd__Ntime__Nget_tick_counter$end
 ;ir_return L0;

cb__Nstd__Ntime__Nget_tick_counter$if1913$else:
 ;ir_make_label cb__Nstd__Ntime__Nget_tick_counter$if1913$else;

 mov rax,0
 ;ir_return 0;

cb__Nstd__Ntime__Nget_tick_counter$end:
 add rsp,48
 pop rbp
 ret


cb__Nstd__Ntime__Nto_duration__Aptr__TU_duration__AU_ticks:
 ;func to_duration(&duration, ticks): &duration
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,56
 ;prolog end

 mov r10,0
 mov qword [rbp-8],r10
 ;ir_load L0 0;

 lea rax,qword [rbp-8]
 ;ir_load_addr L0;

 mov rcx,rax
 call QueryPerformanceFrequency
 ;ir_call QueryPerformanceFrequency ST;

 ;ir_noop ST;

 mov r10,qword [rbp+32]
 imul r10,[std__time__RATIO_MICROSECONDS]
 mov rax,r10
 ;ir_mul A1 ;

 cqo
 idiv qword [rbp-8]
 ;ir_div ST L0;

 mov qword [rbp-16],rax
 ;ir_load L1 ST;

 mov rbx,qword [rbp+24]
 ;ir_deref A0;

 mov rax,qword [rbp-16]
 cqo
 mov r10,[std__time__RATIO_MICROSECONDS]
 idiv r10
 ;ir_div L1 ;

 mov qword [rbx+0],rax
 ;ir_load [ST . 0] ST;

 mov rax,qword [rbp+24]
 ;ir_deref A0;

 mov r10,qword [rax]
 mov qword [rbx+8],r10
 ;ir_load [ST . 1] ST;

 mov rax,qword [rbp+24]
 ;ir_return A0;

cb__Nstd__Ntime__Nto_duration__Aptr__TU_duration__AU_ticks$end:
 add rsp,56
 pop rbx
 pop rbp
 ret


cb__Nstd__Ntime__Nnow__Aptr__TU_timestamp:
 ;func now(&timestamp): &timestamp
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

cb__Nstd__Ntime__Nnow__Aptr__TU_timestamp$end:
 pop rbp
 ret


