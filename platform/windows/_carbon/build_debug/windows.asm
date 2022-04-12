extern GetCommandLineA
extern GetStdHandle
extern WriteFile
extern ReadFile
global cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tpure__Tuint8__Ausize
export cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tpure__Tuint8__Ausize
global cb__Nstd__Nplatform__Nread__Aint__Aptr__Tuint8__Ausize
export cb__Nstd__Nplatform__Nread__Aint__Aptr__Tuint8__Ausize
global cb__Nstd__Nplatform__Nget_stdin_fd
export cb__Nstd__Nplatform__Nget_stdin_fd
global cb__Nstd__Nplatform__Nget_stdout_fd
export cb__Nstd__Nplatform__Nget_stdout_fd
global cb__Nstd__Nplatform__Nget_stderr_fd
export cb__Nstd__Nplatform__Nget_stderr_fd
extern HeapAlloc
extern HeapFree
extern GetProcessHeap
global cb__Nstd__Nplatform__Nalloc__Ausize
export cb__Nstd__Nplatform__Nalloc__Ausize
global cb__Nstd__Nplatform__Nfree__Arawptr
export cb__Nstd__Nplatform__Nfree__Arawptr
extern QueryPerformanceFrequency
extern QueryPerformanceCounter
global test_main
export test_main
section .data
$cbstr0: db 72,101,108,108,111,0
section .code
cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tpure__Tuint8__Ausize:
 ;func write(int, &pure uint8, usize): isize
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

 movsxd rax,dword [rbp-4]
 ;ir_return L0;

cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tpure__Tuint8__Ausize$end:
 add rsp,64
 pop rbp
 ret


cb__Nstd__Nplatform__Nread__Aint__Aptr__Tuint8__Ausize:
 ;func read(int, &uint8, usize): isize
 mov qword [rsp+24],r8
 mov qword [rsp+16],rdx
 mov dword [rsp+8],ecx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,72
 ;prolog end

 mov r10d,0
 mov dword [rbp-4],r10d
 ;ir_load L0 0;

 mov r10,qword [rbp+40]
 mov ebx,r10d
 ;ir_cast A2;

 lea rax,dword [rbp-4]
 ;ir_load_addr L0;

 mov qword [rsp+32],0
 mov r9,rax
 mov r8d,ebx
 mov rdx,qword [rbp+32]
 mov ecx,dword [rbp+24]
 call ReadFile
 ;ir_call ReadFile A0 A1 ST ST 0;

 ;ir_noop ST;

 movsxd rax,dword [rbp-4]
 ;ir_return L0;

cb__Nstd__Nplatform__Nread__Aint__Aptr__Tuint8__Ausize$end:
 add rsp,72
 pop rbx
 pop rbp
 ret


cb__Nstd__Nplatform__Nget_stdin_fd:
 ;func get_stdin_fd(): int
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov ecx,-10
 call GetStdHandle
 ;ir_call GetStdHandle -10;

 ;ir_return ST;

cb__Nstd__Nplatform__Nget_stdin_fd$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nplatform__Nget_stdout_fd:
 ;func get_stdout_fd(): int
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov ecx,-11
 call GetStdHandle
 ;ir_call GetStdHandle -11;

 ;ir_return ST;

cb__Nstd__Nplatform__Nget_stdout_fd$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nplatform__Nget_stderr_fd:
 ;func get_stderr_fd(): int
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov ecx,-12
 call GetStdHandle
 ;ir_call GetStdHandle -12;

 ;ir_return ST;

cb__Nstd__Nplatform__Nget_stderr_fd$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nplatform__Nalloc__Ausize:
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

cb__Nstd__Nplatform__Nalloc__Ausize$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nplatform__Nfree__Arawptr:
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

cb__Nstd__Nplatform__Nfree__Arawptr$end:
 add rsp,32
 pop rbp
 ret


test_main:
 ;func test_main(): int
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,104
 ;prolog end

 lea rax,[$cbstr0]
 ;ir_load_addr STR0;

 mov qword [rbp-16],rax
 ;ir_load [L0 . 0] ST;

 mov r10d,5
 mov qword [rbp-8],r10
 ;ir_load [L0 . 1] 5;

 call cb__Nstd__Nplatform__Nget_stdout_fd
 ;ir_call cb__Nstd__Nplatform__Nget_stdout_fd;

 mov r8,qword [rbp-8]
 mov rdx,qword [rbp-16]
 mov ecx,eax
 call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tpure__Tuint8__Ausize
 ;ir_call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tpure__Tuint8__Ausize ST [L0 . 0] [L0 . 1];

 ;ir_noop ST;

 mov r10,qword [rbp-8]
 add r10,1
 mov rax,r10
 ;ir_add [L0 . 1] 1;

 mov rcx,rax
 call cb__Nstd__Nplatform__Nalloc__Ausize
 ;ir_call cb__Nstd__Nplatform__Nalloc__Ausize ST;

 mov qword [rbp-24],rax
 ;ir_load L1 ST;

 mov r10,qword [rbp-24]
 mov qword [rbp-32],r10
 ;ir_load L2 L1;

 mov r10d,0
 mov dword [rbp-48],r10d
 ;ir_load [L3 . 0] 0;

 mov r10,qword [rbp-8]
 mov qword [rbp-44],r10
 ;ir_load [L3 . 1] [L0 . 1];

 mov r10d,dword [rbp-48]
 mov dword [rbp-56],r10d
 ;ir_load L5 [L3 . 0];

test_main$f380$cond:
 ;ir_make_label test_main$f380$cond;

 movsxd rax,dword [rbp-56]
 ;ir_cast L5;

 cmp rax,qword [rbp-44]
 jge test_main$f380$end
 ;ir_jmp_gte ST [L3 . 1] test_main$f380$end;

test_main$f380$body:
 ;ir_make_label test_main$f380$body;

 mov rax,qword [rbp-32]
 ;ir_deref L2;

 movsxd r10,dword [rbp-56]
 lea rbx,byte [rax+r10*1]
 ;ir_index ST L5;

 mov rax,qword [rbp-16]
 ;ir_deref [L0 . 0];

 movsxd r10,dword [rbp-56]
 lea rax,byte [rax+r10*1]
 ;ir_index ST L5;

 mov r10b,byte [rax+0]
 mov byte [rbx+0],r10b
 ;ir_load ST ST;

 mov r10d,dword [rbp-56]
 add r10d,1
 mov eax,r10d
 ;ir_add L5 1;

 mov dword [rbp-56],eax
 ;ir_load L5 ST;

 jmp test_main$f380$cond
 ;ir_jmp test_main$f380$cond;

test_main$f380$end:
 ;ir_make_label test_main$f380$end;

 call cb__Nstd__Nplatform__Nget_stdout_fd
 ;ir_call cb__Nstd__Nplatform__Nget_stdout_fd;

 mov r8,qword [rbp-8]
 mov rdx,qword [rbp-32]
 mov ecx,eax
 call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tpure__Tuint8__Ausize
 ;ir_call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tpure__Tuint8__Ausize ST L2 [L0 . 1];

 ;ir_noop ST;

 mov rcx,qword [rbp-32]
 call cb__Nstd__Nplatform__Nfree__Arawptr
 ;ir_call cb__Nstd__Nplatform__Nfree__Arawptr L2;

 mov eax,0
 ;ir_return 0;

test_main$end:
 add rsp,104
 pop rbx
 pop rbp
 ret


