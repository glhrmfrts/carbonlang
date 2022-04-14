extern GetCommandLineA
extern GetStdHandle
extern WriteFile
extern ReadFile
extern CreateFileA
extern CloseHandle
global cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
export cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
global cb__Nstd__Nplatform__Nread__Aint__Aptr__Tslice__Tuint8
export cb__Nstd__Nplatform__Nread__Aint__Aptr__Tslice__Tuint8
global cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint
export cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint
global cb__Nstd__Nplatform__Nclose__Aint
export cb__Nstd__Nplatform__Nclose__Aint
global cb__Nstd__Nplatform__Nget_stdin_fd
export cb__Nstd__Nplatform__Nget_stdin_fd
global cb__Nstd__Nplatform__Nget_stdout_fd
export cb__Nstd__Nplatform__Nget_stdout_fd
global cb__Nstd__Nplatform__Nget_stderr_fd
export cb__Nstd__Nplatform__Nget_stderr_fd
extern HeapAlloc
extern HeapFree
extern GetProcessHeap
global cb__Nstd__Nplatform__Nalloc__Aptr__Tmemory__Ausize
export cb__Nstd__Nplatform__Nalloc__Aptr__Tmemory__Ausize
global cb__Nstd__Nplatform__Nfree__Aptr__Tmemory
export cb__Nstd__Nplatform__Nfree__Aptr__Tmemory
extern QueryPerformanceFrequency
extern QueryPerformanceCounter
extern cb__Nstd__Nplatform__Nalloc__Aptr__Tmemory__Ausize
extern cb__Nstd__Nplatform__Nalloc2__Aptr__Tmemory__Ausize__Arawptr
extern cb__Nstd__Nplatform__Nfree__Aptr__Tmemory
extern cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
extern cb__Nstd__Nplatform__Nread__Aint__Aptr__Tslice__Tuint8
extern cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tpure__Tuint8__Aint__Aint
extern cb__Nstd__Nplatform__Nget_stdout_fd
extern cb__Nstd__Nplatform__Nget_stderr_fd
extern cb__Nstd__Nplatform__Nget_stdin_fd
extern cb__Nstd__Nplatform__Nget_fd_flags__Aint
extern cb__Nstd__Nplatform__Nclose__Aint
global cb__Ntest__Ntest_file_write
export cb__Ntest__Ntest_file_write
global test_main
export test_main
section .data
$cbstr0: db 102,105,108,101,46,116,120,116,0
$cbstr1: db 72,69,76,76,79,95,87,79,82,76,68,0
$cbstr2: db 10,0
$cbstr3: db 81,87,69,81,87,69,81,87,69,0
section .code
cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8:
 ;func write(int, []pure uint8): isize
 mov qword [rsp+16],rdx
 mov dword [rsp+8],ecx
 push rbp
 push rbx
 push rdi
 mov rbp,rsp
 sub rsp,64
 ;prolog end

 mov r10d,0
 mov dword [rbp-4],r10d
 ;ir_load L0 0;

 mov rbx,qword [rbp+40]
 ;ir_deref A1;

 mov rax,qword [rbp+40]
 ;ir_deref A1;

 mov r10,qword [rax+8]
 mov edi,r10d
 ;ir_cast [ST . 1];

 lea rax,dword [rbp-4]
 ;ir_load_addr L0;

 mov qword [rsp+32],0
 mov r9,rax
 mov r8d,edi
 mov rdx,qword [rbx+0]
 mov ecx,dword [rbp+32]
 call WriteFile
 ;ir_call WriteFile A0 [ST . 0] ST ST 0;

 movsxd rax,dword [rbp-4]
 ;ir_return L0;

cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8$end:
 add rsp,64
 pop rdi
 pop rbx
 pop rbp
 ret


cb__Nstd__Nplatform__Nread__Aint__Aptr__Tslice__Tuint8:
 ;func read(int, []uint8): isize
 mov qword [rsp+16],rdx
 mov dword [rsp+8],ecx
 push rbp
 push rbx
 push rdi
 mov rbp,rsp
 sub rsp,64
 ;prolog end

 mov r10d,0
 mov dword [rbp-4],r10d
 ;ir_load L0 0;

 mov rbx,qword [rbp+40]
 ;ir_deref A1;

 mov rax,qword [rbp+40]
 ;ir_deref A1;

 mov r10,qword [rax+8]
 mov edi,r10d
 ;ir_cast [ST . 1];

 lea rax,dword [rbp-4]
 ;ir_load_addr L0;

 mov qword [rsp+32],0
 mov r9,rax
 mov r8d,edi
 mov rdx,qword [rbx+0]
 mov ecx,dword [rbp+32]
 call ReadFile
 ;ir_call ReadFile A0 [ST . 0] ST ST 0;

 ;ir_noop ST;

 movsxd rax,dword [rbp-4]
 ;ir_return L0;

cb__Nstd__Nplatform__Nread__Aint__Aptr__Tslice__Tuint8$end:
 add rsp,64
 pop rdi
 pop rbx
 pop rbp
 ret


cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint:
 ;func open(&{int, error}, &[]pure uint8, int, int): &{int, error}
 mov dword [rsp+32],r9d
 mov dword [rsp+24],r8d
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,96
 ;prolog end

 mov r10d,2147483648
 mov dword [rbp-4],r10d
 ;ir_load L0 2147483648;

 mov r10d,8
 or r10d,2
 mov eax,r10d
 ;ir_or 8 2;

 mov r10d,dword [rbp+32]
 and r10d,eax
 mov eax,r10d
 ;ir_and A2 ST;

 cmp eax,0
 je cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if312$else
 ;ir_jmp_eq ST 0 cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if312$else;

cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if312$body:
 ;ir_make_label cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if312$body;

 mov r10d,dword [rbp-4]
 or r10d,1073741824
 mov eax,r10d
 ;ir_or L0 1073741824;

 mov dword [rbp-4],eax
 ;ir_load L0 ST;

cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if312$else:
 ;ir_make_label cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if312$else;

 mov r10d,1
 or r10d,2
 mov eax,r10d
 ;ir_or 1 2;

 mov dword [rbp-8],eax
 ;ir_load L1 ST;

 mov r10d,3
 mov dword [rbp-12],r10d
 ;ir_load L2 3;

 mov r10d,dword [rbp+32]
 and r10d,1
 mov eax,r10d
 ;ir_and A2 1;

 cmp eax,0
 je cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if351$else
 ;ir_jmp_eq ST 0 cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if351$else;

cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if351$body:
 ;ir_make_label cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if351$body;

 mov r10d,4
 mov dword [rbp-12],r10d
 ;ir_load L2 4;

cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if351$else:
 ;ir_make_label cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if351$else;

 mov r10d,128
 mov dword [rbp-16],r10d
 ;ir_load L3 128;

 mov r10d,0
 mov dword [rbp-20],r10d
 ;ir_load L4 0;

 mov rax,qword [rbp+24]
 ;ir_deref A1;

 mov dword [rsp+48],0
 mov r10d,dword [rbp-16]
 mov dword [rsp+40],r10d
 mov r10d,dword [rbp-12]
 mov dword [rsp+32],r10d
 mov r9,0
 mov r8d,dword [rbp-8]
 mov edx,dword [rbp-4]
 mov rcx,qword [rax+0]
 call CreateFileA
 ;ir_call CreateFileA [ST . 0] L0 L1 0 L2 L3 0;

 mov dword [rbp-24],eax
 ;ir_load L5 ST;

 mov rax,qword [rbp+16]
 ;ir_deref A0;

 mov r10d,dword [rbp-24]
 mov dword [rax+0],r10d
 ;ir_load [ST . 0] L5;

 mov rax,qword [rbp+16]
 ;ir_deref A0;

 mov r10d,dword [rbp-20]
 mov dword [rax+4],r10d
 ;ir_load [ST . 1] L4;

 mov rax,qword [rbp+16]
 ;ir_return A0;

cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$end:
 add rsp,96
 pop rbp
 ret


cb__Nstd__Nplatform__Nclose__Aint:
 ;func close(int): error
 mov dword [rsp+8],ecx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov ecx,dword [rbp+16]
 call CloseHandle
 ;ir_call CloseHandle A0;

 ;ir_return ST;

cb__Nstd__Nplatform__Nclose__Aint$end:
 add rsp,32
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


cb__Nstd__Nplatform__Nalloc__Aptr__Tmemory__Ausize:
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

cb__Nstd__Nplatform__Nalloc__Aptr__Tmemory__Ausize$end:
 add rsp,40
 pop rbx
 pop rbp
 ret


cb__Nstd__Nplatform__Nfree__Aptr__Tmemory:
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

cb__Nstd__Nplatform__Nfree__Aptr__Tmemory$end:
 add rsp,40
 pop rbx
 pop rbp
 ret


cb__Ntest__Ntest_file_write:
 ;func test_file_write(): bool
 push rbp
 push rbx
 push rdi
 push rsi
 mov rbp,rsp
 sub rsp,200
 ;prolog end

 lea rax,[$cbstr0]
 ;ir_load_addr STR0;

 mov qword [rbp-80],rax
 ;ir_load [L7 . 0] ST;

 mov r10d,8
 mov qword [rbp-72],r10
 ;ir_load [L7 . 1] 8;

 lea rbx,qword [rbp-40]
 ;ir_load_addr L2;

 lea rdi,qword [rbp-80]
 ;ir_load_addr L7;

 mov r10d,1
 or r10d,2
 mov eax,r10d
 ;ir_or 1 2;

 mov r9d,0
 mov r8d,eax
 mov rdx,rdi
 mov rcx,rbx
 call cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint
 mov rbx,rax
 ;ir_call cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint ST ST ST 0;

 mov r10d,dword [rbp-40]
 mov dword [rbp-44],r10d
 ;ir_load L3 [L2 . 0];

 mov r10d,dword [rbp-36]
 mov dword [rbp-48],r10d
 ;ir_load L4 [L2 . 1];

 lea rax,[$cbstr1]
 ;ir_load_addr STR1;

 mov qword [rbp-96],rax
 ;ir_load [L8 . 0] ST;

 mov r10d,11
 mov qword [rbp-88],r10
 ;ir_load [L8 . 1] 11;

 lea rax,qword [rbp-96]
 ;ir_load_addr L8;

 mov rdx,rax
 mov ecx,dword [rbp-44]
 call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 L3 ST;

 ;ir_noop ST;

 mov ecx,dword [rbp-44]
 call cb__Nstd__Nplatform__Nclose__Aint
 ;ir_call cb__Nstd__Nplatform__Nclose__Aint L3;

 lea rax,[$cbstr0]
 ;ir_load_addr STR0;

 mov qword [rbp-112],rax
 ;ir_load [L9 . 0] ST;

 mov r10d,8
 mov qword [rbp-104],r10
 ;ir_load [L9 . 1] 8;

 lea rdi,qword [rbp-56]
 ;ir_load_addr L5;

 lea rax,qword [rbp-112]
 ;ir_load_addr L9;

 mov r9d,0
 mov r8d,4
 mov rdx,rax
 mov rcx,rdi
 call cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint
 mov rdi,rax
 ;ir_call cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint ST ST 4 0;

 mov r10d,dword [rbp-56]
 mov dword [rbp-60],r10d
 ;ir_load L6 [L5 . 0];

 mov r10d,dword [rbp-52]
 mov dword [rbp-48],r10d
 ;ir_load L4 [L5 . 1];

 mov r10,0
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 0;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,1
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 1;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,2
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 2;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,3
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 3;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,4
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 4;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,5
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 5;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,6
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 6;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,7
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 7;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,8
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 8;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,9
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 9;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,10
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 10;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,11
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 11;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,0
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 0;

 lea rax,byte [rax+0]
 ;ir_load_addr ST;

 mov qword [rbp-32],rax
 ;ir_load [L1 . 0] ST;

 mov r10,12
 mov qword [rbp-24],r10
 ;ir_load [L1 . 1] 12;

 push rdi
 push rsi
 lea rdi,qword [rbp-128]
 lea rsi,qword [rbp-32]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L10 L1 16;

 lea rax,qword [rbp-128]
 ;ir_load_addr L10;

 mov rdx,rax
 mov ecx,dword [rbp-60]
 call cb__Nstd__Nplatform__Nread__Aint__Aptr__Tslice__Tuint8
 ;ir_call cb__Nstd__Nplatform__Nread__Aint__Aptr__Tslice__Tuint8 L6 ST;

 ;ir_noop ST;

 push rdi
 push rsi
 lea rdi,qword [rbp-144]
 lea rsi,qword [rbp-32]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L11 L1 16;

 call cb__Nstd__Nplatform__Nget_stdout_fd
 mov esi,eax
 ;ir_call cb__Nstd__Nplatform__Nget_stdout_fd;

 lea rax,qword [rbp-144]
 ;ir_load_addr L11;

 mov rdx,rax
 mov ecx,esi
 call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 ST ST;

 ;ir_noop ST;

 lea rax,[$cbstr2]
 ;ir_load_addr STR2;

 mov qword [rbp-160],rax
 ;ir_load [L12 . 0] ST;

 mov r10d,1
 mov qword [rbp-152],r10
 ;ir_load [L12 . 1] 1;

 call cb__Nstd__Nplatform__Nget_stdout_fd
 mov esi,eax
 ;ir_call cb__Nstd__Nplatform__Nget_stdout_fd;

 lea rax,qword [rbp-160]
 ;ir_load_addr L12;

 mov rdx,rax
 mov ecx,esi
 call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 ST ST;

 ;ir_noop ST;

 mov ecx,dword [rbp-60]
 call cb__Nstd__Nplatform__Nclose__Aint
 ;ir_call cb__Nstd__Nplatform__Nclose__Aint L6;

 mov al,1
 ;ir_return 1;

cb__Ntest__Ntest_file_write$end:
 add rsp,200
 pop rsi
 pop rdi
 pop rbx
 pop rbp
 ret


test_main:
 ;func test_main(): int
 push rbp
 push rbx
 push rdi
 push rsi
 mov rbp,rsp
 sub rsp,248
 ;prolog end

 call cb__Ntest__Ntest_file_write
 ;ir_call cb__Ntest__Ntest_file_write;

 ;ir_noop ST;

 mov r10,0
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 0;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,1
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 1;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,2
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 2;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,3
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 3;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,4
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 4;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,5
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 5;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,6
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 6;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,7
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 7;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,8
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 8;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,9
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 9;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,10
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 10;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,11
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 11;

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load ST 0;

 mov r10,0
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 0;

 lea rax,byte [rax+0]
 ;ir_load_addr ST;

 mov qword [rbp-32],rax
 ;ir_load [L1 . 0] ST;

 mov r10,12
 mov qword [rbp-24],r10
 ;ir_load [L1 . 1] 12;

 lea rax,[$cbstr0]
 ;ir_load_addr STR0;

 mov qword [rbp-104],rax
 ;ir_load [L8 . 0] ST;

 mov r10d,8
 mov qword [rbp-96],r10
 ;ir_load [L8 . 1] 8;

 lea rbx,qword [rbp-64]
 ;ir_load_addr L4;

 lea rax,qword [rbp-104]
 ;ir_load_addr L8;

 mov r9d,0
 mov r8d,4
 mov rdx,rax
 mov rcx,rbx
 call cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint
 mov rbx,rax
 ;ir_call cb__Nstd__Nplatform__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint ST ST 4 0;

 mov r10d,dword [rbp-64]
 mov dword [rbp-68],r10d
 ;ir_load L5 [L4 . 0];

 mov r10d,dword [rbp-60]
 mov dword [rbp-72],r10d
 ;ir_load L6 [L4 . 1];

 push rdi
 push rsi
 lea rdi,qword [rbp-120]
 lea rsi,qword [rbp-32]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L9 L1 16;

 lea rax,qword [rbp-120]
 ;ir_load_addr L9;

 mov rdx,rax
 mov ecx,dword [rbp-68]
 call cb__Nstd__Nplatform__Nread__Aint__Aptr__Tslice__Tuint8
 ;ir_call cb__Nstd__Nplatform__Nread__Aint__Aptr__Tslice__Tuint8 L5 ST;

 ;ir_noop ST;

 push rdi
 push rsi
 lea rdi,qword [rbp-136]
 lea rsi,qword [rbp-32]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L10 L1 16;

 call cb__Nstd__Nplatform__Nget_stdout_fd
 mov edi,eax
 ;ir_call cb__Nstd__Nplatform__Nget_stdout_fd;

 lea rax,qword [rbp-136]
 ;ir_load_addr L10;

 mov rdx,rax
 mov ecx,edi
 call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 ST ST;

 ;ir_noop ST;

 lea rax,[$cbstr2]
 ;ir_load_addr STR2;

 mov qword [rbp-152],rax
 ;ir_load [L11 . 0] ST;

 mov r10d,1
 mov qword [rbp-144],r10
 ;ir_load [L11 . 1] 1;

 call cb__Nstd__Nplatform__Nget_stdout_fd
 mov edi,eax
 ;ir_call cb__Nstd__Nplatform__Nget_stdout_fd;

 lea rax,qword [rbp-152]
 ;ir_load_addr L11;

 mov rdx,rax
 mov ecx,edi
 call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 ST ST;

 ;ir_noop ST;

 mov ecx,dword [rbp-68]
 call cb__Nstd__Nplatform__Nclose__Aint
 ;ir_call cb__Nstd__Nplatform__Nclose__Aint L5;

 lea rax,[$cbstr3]
 ;ir_load_addr STR3;

 mov qword [rbp-56],rax
 ;ir_load [L3 . 0] ST;

 mov r10d,9
 mov qword [rbp-48],r10
 ;ir_load [L3 . 1] 9;

 push rdi
 push rsi
 lea rdi,qword [rbp-168]
 lea rsi,qword [rbp-56]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L12 L3 16;

 call cb__Nstd__Nplatform__Nget_stdout_fd
 mov edi,eax
 ;ir_call cb__Nstd__Nplatform__Nget_stdout_fd;

 lea rax,qword [rbp-168]
 ;ir_load_addr L12;

 mov rdx,rax
 mov ecx,edi
 call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 ST ST;

 ;ir_noop ST;

 lea rdi,qword [rbp-88]
 ;ir_load_addr L7;

 mov r10,qword [rbp-48]
 add r10,1
 mov rax,r10
 ;ir_add [L3 . 1] 1;

 mov rdx,rax
 mov rcx,rdi
 call cb__Nstd__Nplatform__Nalloc__Aptr__Tmemory__Ausize
 mov rdi,rax
 ;ir_call cb__Nstd__Nplatform__Nalloc__Aptr__Tmemory__Ausize ST ST;

 mov r10,qword [rbp-88]
 mov qword [rbp-40],r10
 ;ir_load L2 [L7 . 0];

 mov r10d,0
 mov dword [rbp-200],r10d
 ;ir_load [L14 . 0] 0;

 mov r10,qword [rbp-48]
 mov qword [rbp-196],r10
 ;ir_load [L14 . 1] [L3 . 1];

 mov r10d,dword [rbp-200]
 mov dword [rbp-204],r10d
 ;ir_load L15 [L14 . 0];

test_main$f1015$cond:
 ;ir_make_label test_main$f1015$cond;

 movsxd rax,dword [rbp-204]
 ;ir_cast L15;

 cmp rax,qword [rbp-196]
 jge test_main$f1015$end
 ;ir_jmp_gte ST [L14 . 1] test_main$f1015$end;

test_main$f1015$body:
 ;ir_make_label test_main$f1015$body;

 mov rax,qword [rbp-40]
 ;ir_deref L2;

 movsxd r10,dword [rbp-204]
 lea rsi,byte [rax+r10*1]
 ;ir_index ST L15;

 mov rax,qword [rbp-56]
 ;ir_deref [L3 . 0];

 movsxd r10,dword [rbp-204]
 lea rax,byte [rax+r10*1]
 ;ir_index ST L15;

 mov r10b,byte [rax+0]
 mov byte [rsi+0],r10b
 ;ir_load ST ST;

 mov r10d,dword [rbp-204]
 add r10d,1
 mov eax,r10d
 ;ir_add L15 1;

 mov dword [rbp-204],eax
 ;ir_load L15 ST;

 jmp test_main$f1015$cond
 ;ir_jmp test_main$f1015$cond;

test_main$f1015$end:
 ;ir_make_label test_main$f1015$end;

 mov r10,qword [rbp-40]
 mov qword [rbp-184],r10
 ;ir_load [L13 . 0] L2;

 mov r10,qword [rbp-48]
 mov qword [rbp-176],r10
 ;ir_load [L13 . 1] [L3 . 1];

 call cb__Nstd__Nplatform__Nget_stdout_fd
 mov esi,eax
 ;ir_call cb__Nstd__Nplatform__Nget_stdout_fd;

 lea rax,qword [rbp-184]
 ;ir_load_addr L13;

 mov rdx,rax
 mov ecx,esi
 call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nplatform__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 ST ST;

 ;ir_noop ST;

 lea rax,qword [rbp-88]
 ;ir_load_addr L7;

 mov rcx,rax
 call cb__Nstd__Nplatform__Nfree__Aptr__Tmemory
 ;ir_call cb__Nstd__Nplatform__Nfree__Aptr__Tmemory ST;

 mov eax,0
 ;ir_return 0;

test_main$end:
 add rsp,248
 pop rsi
 pop rdi
 pop rbx
 pop rbp
 ret


