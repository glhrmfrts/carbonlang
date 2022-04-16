extern GetCommandLineA
extern GetStdHandle
extern WriteFile
extern ReadFile
extern CreateFileA
extern SetFilePointer
extern CloseHandle
extern GetFileInformationByHandle
extern GetLastError
global cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
export cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
global cb__Nstd__Nsystem__Nread__Aint__Aptr__Tslice__Tuint8
export cb__Nstd__Nsystem__Nread__Aint__Aptr__Tslice__Tuint8
global cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint
export cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint
global cb__Nstd__Nsystem__Nseek__Aint__Aint64__Aint
export cb__Nstd__Nsystem__Nseek__Aint__Aint64__Aint
global cb__Nstd__Nsystem__Nstat__Aint__Aptr__Tstat_data
export cb__Nstd__Nsystem__Nstat__Aint__Aptr__Tstat_data
global cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data
export cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data
global cb__Nstd__Nsystem__Nclose__Aint
export cb__Nstd__Nsystem__Nclose__Aint
global cb__Nstd__Nsystem__Nget_stdin_fd
export cb__Nstd__Nsystem__Nget_stdin_fd
global cb__Nstd__Nsystem__Nget_stdout_fd
export cb__Nstd__Nsystem__Nget_stdout_fd
global cb__Nstd__Nsystem__Nget_stderr_fd
export cb__Nstd__Nsystem__Nget_stderr_fd
extern HeapAlloc
extern HeapFree
extern GetProcessHeap
global cb__Nstd__Nsystem__Nalloc__Aptr__Tmemory__Ausize
export cb__Nstd__Nsystem__Nalloc__Aptr__Tmemory__Ausize
global cb__Nstd__Nsystem__Nfree__Aptr__Tmemory
export cb__Nstd__Nsystem__Nfree__Aptr__Tmemory
extern cb__Nstd__Nsystem__Nalloc__Aptr__Tmemory__Ausize
extern cb__Nstd__Nsystem__Nalloc2__Aptr__Tmemory__Ausize__Arawptr
extern cb__Nstd__Nsystem__Nfree__Aptr__Tmemory
extern cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
extern cb__Nstd__Nsystem__Nread__Aint__Aptr__Tslice__Tuint8
extern cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tpure__Tuint8__Aint__Aint
extern cb__Nstd__Nsystem__Nget_stdout_fd
extern cb__Nstd__Nsystem__Nget_stderr_fd
extern cb__Nstd__Nsystem__Nget_stdin_fd
extern cb__Nstd__Nsystem__Nget_fd_flags__Aint
extern cb__Nstd__Nsystem__Nseek__Aint__Aint64__Aint
extern cb__Nstd__Nsystem__Nclose__Aint
extern cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data
extern cb__Nstd__Nsystem__Nstat__Aint__Aptr__Tstat_data
extern cb__Nstd__Nsystem__Nexit__Aint
extern QueryPerformanceFrequency
extern QueryPerformanceCounter
extern ExitProcess
global cb__Nstd__Nsystem__Nexit__Aint
export cb__Nstd__Nsystem__Nexit__Aint
global cb__Ntest__Ntest_defer
export cb__Ntest__Ntest_defer
global cb__Ntest__Ntest_file_write
export cb__Ntest__Ntest_file_write
global cb__Ntest__Nget_values__Aptr__Ttuple__Tslice__Tpure__Tuint8__Tint
export cb__Ntest__Nget_values__Aptr__Ttuple__Tslice__Tpure__Tuint8__Tint
global test_main
export test_main
section .data
$cbstr0: db 68,69,70,69,82,10,0
$cbstr1: db 102,105,108,101,46,116,120,116,0
$cbstr2: db 72,69,76,76,79,95,87,79,82,76,68,0
$cbstr3: db 10,0
$cbstr4: db 71,69,84,95,86,65,76,85,69,83,0
$cbstr5: db 44,32,52,56,0
$cbstr6: db 81,87,69,81,87,69,81,87,69,0
section .code
cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8:
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
 ;ir_deref A1; (push)

 mov rax,qword [rbp+40]
 ;ir_deref A1; (push)

 mov r10,qword [rax+8]
 mov edi,r10d
 ;ir_cast [POP() . 1]; (push)

 lea rax,dword [rbp-4]
 ;ir_load_addr L0; (push)

 mov qword [rsp+32],0
 mov r9,rax
 mov r8d,edi
 mov rdx,qword [rbx+0]
 mov ecx,dword [rbp+32]
 call WriteFile
 ;ir_call WriteFile A0 [POP() . 0] POP() POP() 0;

 movsxd rax,dword [rbp-4]
 ;ir_return L0;

cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8$end:
 add rsp,64
 pop rdi
 pop rbx
 pop rbp
 ret


cb__Nstd__Nsystem__Nread__Aint__Aptr__Tslice__Tuint8:
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
 ;ir_deref A1; (push)

 mov rax,qword [rbp+40]
 ;ir_deref A1; (push)

 mov r10,qword [rax+8]
 mov edi,r10d
 ;ir_cast [POP() . 1]; (push)

 lea rax,dword [rbp-4]
 ;ir_load_addr L0; (push)

 mov qword [rsp+32],0
 mov r9,rax
 mov r8d,edi
 mov rdx,qword [rbx+0]
 mov ecx,dword [rbp+32]
 call ReadFile
 ;ir_call ReadFile A0 [POP() . 0] POP() POP() 0; (push)

 ;ir_noop POP();

 movsxd rax,dword [rbp-4]
 ;ir_return L0;

cb__Nstd__Nsystem__Nread__Aint__Aptr__Tslice__Tuint8$end:
 add rsp,64
 pop rdi
 pop rbx
 pop rbp
 ret


cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint:
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
 ;ir_and A2 POP();

 cmp eax,0
 je cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if426$else
 ;ir_jmp_eq POP() 0 cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if426$else;

cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if426$body:
 ;ir_make_label cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if426$body;

 mov r10d,dword [rbp-4]
 or r10d,1073741824
 mov eax,r10d
 ;ir_or L0 1073741824;

 mov dword [rbp-4],eax
 ;ir_load L0 POP();

cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if426$else:
 ;ir_make_label cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if426$else;

 mov r10d,1
 or r10d,2
 mov eax,r10d
 ;ir_or 1 2;

 mov dword [rbp-8],eax
 ;ir_load L1 POP();

 mov r10d,3
 mov dword [rbp-12],r10d
 ;ir_load L2 3;

 mov r10d,dword [rbp+32]
 and r10d,1
 mov eax,r10d
 ;ir_and A2 1;

 cmp eax,0
 je cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if465$else
 ;ir_jmp_eq POP() 0 cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if465$else;

cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if465$body:
 ;ir_make_label cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if465$body;

 mov r10d,4
 mov dword [rbp-12],r10d
 ;ir_load L2 4;

cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if465$else:
 ;ir_make_label cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if465$else;

 mov r10d,128
 mov dword [rbp-16],r10d
 ;ir_load L3 128;

 mov r10d,0
 mov dword [rbp-20],r10d
 ;ir_load L4 0;

 mov rax,qword [rbp+24]
 ;ir_deref A1; (push)

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
 ;ir_call CreateFileA [POP() . 0] L0 L1 0 L2 L3 0; (push)

 mov dword [rbp-24],eax
 ;ir_load L5 POP();

 mov r10d,dword [rbp-24]
 cmp r10d,0
 je cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if514$else
 ;ir_jmp_eq L5 0 cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if514$else;

 mov r10d,dword [rbp+32]
 and r10d,8
 mov eax,r10d
 ;ir_and A2 8;

 cmp eax,0
 je cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if514$else
 ;ir_jmp_eq POP() 0 cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if514$else;

cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if514$body:
 ;ir_make_label cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if514$body;

 mov r9d,2
 mov r8,0
 mov edx,0
 mov ecx,dword [rbp-24]
 call SetFilePointer
 ;ir_call SetFilePointer L5 0 0 2; (push)

 ;ir_noop POP();

cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if514$else:
 ;ir_make_label cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$if514$else;

 mov rax,qword [rbp+16]
 ;ir_deref A0; (push)

 mov r10d,dword [rbp-24]
 mov dword [rax+0],r10d
 ;ir_load [POP() . 0] L5;

 mov rax,qword [rbp+16]
 ;ir_deref A0; (push)

 mov r10d,dword [rbp-20]
 mov dword [rax+4],r10d
 ;ir_load [POP() . 1] L4;

 mov rax,qword [rbp+16]
 ;ir_return A0;

cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint$end:
 add rsp,96
 pop rbp
 ret


cb__Nstd__Nsystem__Nseek__Aint__Aint64__Aint:
 ;func seek(int, int64, int): {}
 mov dword [rsp+24],r8d
 mov qword [rsp+16],rdx
 mov dword [rsp+8],ecx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov r10,qword [rbp+24]
 mov eax,r10d
 ;ir_cast A1; (push)

 mov r9d,dword [rbp+32]
 mov r8,0
 mov edx,eax
 mov ecx,dword [rbp+16]
 call SetFilePointer
 ;ir_call SetFilePointer A0 POP() 0 A2; (push)

 ;ir_noop POP();

cb__Nstd__Nsystem__Nseek__Aint__Aint64__Aint$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nsystem__Nstat__Aint__Aptr__Tstat_data:
 ;func stat(int, &stat_data): error
 mov qword [rsp+16],rdx
 mov dword [rsp+8],ecx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,104
 ;prolog end

 mov r10d,0
 mov dword [rbp-56],r10d
 ;ir_load [L0 . 0] 0;

 mov r10d,0
 mov qword [rbp-52],r10
 ;ir_load [L0 . 1] 0;

 mov r10d,0
 mov qword [rbp-40],r10
 ;ir_load [L0 . 2] 0;

 mov r10d,0
 mov qword [rbp-32],r10
 ;ir_load [L0 . 3] 0;

 mov r10d,0
 mov dword [rbp-24],r10d
 ;ir_load [L0 . 4] 0;

 mov r10d,0
 mov dword [rbp-20],r10d
 ;ir_load [L0 . 5] 0;

 mov r10d,0
 mov dword [rbp-16],r10d
 ;ir_load [L0 . 6] 0;

 mov r10d,0
 mov dword [rbp-12],r10d
 ;ir_load [L0 . 7] 0;

 mov r10d,0
 mov dword [rbp-8],r10d
 ;ir_load [L0 . 8] 0;

 mov r10d,0
 mov dword [rbp-4],r10d
 ;ir_load [L0 . 9] 0;

 lea rax,qword [rbp-56]
 ;ir_load_addr L0; (push)

 mov rdx,rax
 mov ecx,dword [rbp+24]
 call GetFileInformationByHandle
 ;ir_call GetFileInformationByHandle A0 POP(); (push)

 cmp al,0
 jne cb__Nstd__Nsystem__Nstat__Aint__Aptr__Tstat_data$if590$else
 ;ir_jmp_neq POP() 0 cb__Nstd__Nsystem__Nstat__Aint__Aptr__Tstat_data$if590$else;

cb__Nstd__Nsystem__Nstat__Aint__Aptr__Tstat_data$if590$body:
 ;ir_make_label cb__Nstd__Nsystem__Nstat__Aint__Aptr__Tstat_data$if590$body;

 call GetLastError
 ;ir_call GetLastError; (push)

 jmp cb__Nstd__Nsystem__Nstat__Aint__Aptr__Tstat_data$end
 ;ir_return POP();

cb__Nstd__Nsystem__Nstat__Aint__Aptr__Tstat_data$if590$else:
 ;ir_make_label cb__Nstd__Nsystem__Nstat__Aint__Aptr__Tstat_data$if590$else;

 mov rbx,qword [rbp+32]
 ;ir_deref A1; (push)

 mov r10d,dword [rbp-20]
 or r10d,dword [rbp-16]
 mov eax,r10d
 ;ir_or [L0 . 5] [L0 . 6];

 movsxd rax,eax
 ;ir_cast POP(); (push)

 mov qword [rbx+0],rax
 ;ir_load [POP() . 0] POP();

 mov rax,qword [rbp+32]
 ;ir_deref A1; (push)

 mov r10,qword [rbp-32]
 mov qword [rax+8],r10
 ;ir_load [POP() . 1] [L0 . 3];

 mov rax,qword [rbp+32]
 ;ir_deref A1; (push)

 mov r10,qword [rbp-40]
 mov qword [rax+16],r10
 ;ir_load [POP() . 2] [L0 . 2];

 mov rax,qword [rbp+32]
 ;ir_deref A1; (push)

 mov r10,qword [rbp-52]
 mov qword [rax+24],r10
 ;ir_load [POP() . 3] [L0 . 1];

 mov eax,0
 ;ir_return 0;

cb__Nstd__Nsystem__Nstat__Aint__Aptr__Tstat_data$end:
 add rsp,104
 pop rbx
 pop rbp
 ret


cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data:
 ;func stat([]pure uint8, &stat_data): error
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,56
 ;prolog end

 lea rax,qword [rbp-8]
 ;ir_load_addr L0; (push)

 mov r9d,0
 mov r8d,0
 mov rdx,qword [rbp+24]
 mov rcx,rax
 call cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint
 mov rbx,rax
 ;ir_call cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint POP() A0 0 0; (push)

 mov r10d,dword [rbp-8]
 mov dword [rbp-12],r10d
 ;ir_load L1 [L0 . 0];

 mov r10d,dword [rbp-4]
 mov dword [rbp-16],r10d
 ;ir_load L2 [L0 . 1];

 mov r10d,dword [rbp-16]
 cmp r10d,0
 je cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data$if669$else
 ;ir_jmp_eq L2 0 cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data$if669$else;

cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data$if669$body:
 ;ir_make_label cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data$if669$body;

 mov eax,dword [rbp-16]
 jmp cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data$end
 ;ir_return L2;

cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data$if669$else:
 ;ir_make_label cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data$if669$else;

 mov rdx,qword [rbp+32]
 mov ecx,dword [rbp-12]
 call cb__Nstd__Nsystem__Nstat__Aint__Aptr__Tstat_data
 ;ir_call cb__Nstd__Nsystem__Nstat__Aint__Aptr__Tstat_data L1 A1; (push)

 mov dword [rbp-8],eax
 ;ir_load L0 POP();

 mov r10d,dword [rbp-16]
 cmp r10d,0
 je cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data$if693$else
 ;ir_jmp_eq L2 0 cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data$if693$else;

cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data$if693$body:
 ;ir_make_label cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data$if693$body;

 mov ecx,dword [rbp-12]
 call cb__Nstd__Nsystem__Nclose__Aint
 ;ir_call cb__Nstd__Nsystem__Nclose__Aint L1; (push)

 ;ir_noop POP();

 mov eax,dword [rbp-16]
 jmp cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data$end
 ;ir_return L2;

cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data$if693$else:
 ;ir_make_label cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data$if693$else;

 mov ecx,dword [rbp-12]
 call cb__Nstd__Nsystem__Nclose__Aint
 ;ir_call cb__Nstd__Nsystem__Nclose__Aint L1; (push)

 ;ir_noop POP();

 mov eax,0
 ;ir_return 0;

cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data$end:
 add rsp,56
 pop rbx
 pop rbp
 ret


cb__Nstd__Nsystem__Nclose__Aint:
 ;func close(int): error
 mov dword [rsp+8],ecx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov ecx,dword [rbp+16]
 call CloseHandle
 ;ir_call CloseHandle A0; (push)

 ;ir_return POP();

cb__Nstd__Nsystem__Nclose__Aint$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nsystem__Nget_stdin_fd:
 ;func get_stdin_fd(): int
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov ecx,-10
 call GetStdHandle
 ;ir_call GetStdHandle -10; (push)

 ;ir_return POP();

cb__Nstd__Nsystem__Nget_stdin_fd$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nsystem__Nget_stdout_fd:
 ;func get_stdout_fd(): int
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov ecx,-11
 call GetStdHandle
 ;ir_call GetStdHandle -11; (push)

 ;ir_return POP();

cb__Nstd__Nsystem__Nget_stdout_fd$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nsystem__Nget_stderr_fd:
 ;func get_stderr_fd(): int
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov ecx,-12
 call GetStdHandle
 ;ir_call GetStdHandle -12; (push)

 ;ir_return POP();

cb__Nstd__Nsystem__Nget_stderr_fd$end:
 add rsp,32
 pop rbp
 ret


cb__Nstd__Nsystem__Nalloc__Aptr__Tmemory__Ausize:
 ;func alloc(&memory, usize): &memory
 mov qword [rsp+16],rdx
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,40
 ;prolog end

 mov rbx,qword [rbp+24]
 ;ir_deref A0; (push)

 call GetProcessHeap
 ;ir_call GetProcessHeap; (push)

 mov r8,qword [rbp+32]
 mov edx,0
 mov ecx,eax
 call HeapAlloc
 ;ir_call HeapAlloc POP() 0 A1; (push)

 mov qword [rbx+0],rax
 ;ir_load [POP() . 0] POP();

 mov rax,qword [rbp+24]
 ;ir_deref A0; (push)

 mov r10,qword [rbp+32]
 mov qword [rax+8],r10
 ;ir_load [POP() . 1] A1;

 mov rax,qword [rbp+24]
 ;ir_return A0;

cb__Nstd__Nsystem__Nalloc__Aptr__Tmemory__Ausize$end:
 add rsp,40
 pop rbx
 pop rbp
 ret


cb__Nstd__Nsystem__Nfree__Aptr__Tmemory:
 ;func free(&memory): {}
 mov qword [rsp+8],rcx
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,40
 ;prolog end

 call GetProcessHeap
 mov ebx,eax
 ;ir_call GetProcessHeap; (push)

 mov rax,qword [rbp+24]
 ;ir_deref A0; (push)

 mov r8,qword [rax+0]
 mov edx,0
 mov ecx,ebx
 call HeapFree
 ;ir_call HeapFree POP() 0 [POP() . 0]; (push)

 ;ir_noop POP();

 mov rax,qword [rbp+24]
 ;ir_deref A0; (push)

 mov r10,0
 mov qword [rax+0],r10
 ;ir_load [POP() . 0] 0;

cb__Nstd__Nsystem__Nfree__Aptr__Tmemory$end:
 add rsp,40
 pop rbx
 pop rbp
 ret


cb__Nstd__Nsystem__Nexit__Aint:
 ;func exit(int): {}
 mov dword [rsp+8],ecx
 push rbp
 mov rbp,rsp
 sub rsp,32
 ;prolog end

 mov ecx,dword [rbp+16]
 call ExitProcess
 ;ir_call ExitProcess A0;

cb__Nstd__Nsystem__Nexit__Aint$end:
 add rsp,32
 pop rbp
 ret


cb__Ntest__Ntest_defer:
 ;func test_defer(): {}
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,40
 ;prolog end

 lea rax,[$cbstr0]
 ;ir_load_addr STR0; (push)

 mov qword [rbp-16],rax
 ;ir_load [L0 . 0] POP();

 mov r10d,6
 mov qword [rbp-8],r10
 ;ir_load [L0 . 1] 6;

 call cb__Nstd__Nsystem__Nget_stdout_fd
 mov ebx,eax
 ;ir_call cb__Nstd__Nsystem__Nget_stdout_fd; (push)

 lea rax,qword [rbp-16]
 ;ir_load_addr L0; (push)

 mov rdx,rax
 mov ecx,ebx
 call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

 ;ir_noop POP();

cb__Ntest__Ntest_defer$end:
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
 push r12
 mov rbp,rsp
 sub rsp,256
 ;prolog end

 lea rax,[$cbstr1]
 ;ir_load_addr STR1; (push)

 mov qword [rbp-120],rax
 ;ir_load [L8 . 0] POP();

 mov r10d,8
 mov qword [rbp-112],r10
 ;ir_load [L8 . 1] 8;

 lea rbx,qword [rbp-64]
 ;ir_load_addr L2; (push)

 lea rax,qword [rbp-120]
 ;ir_load_addr L8; (push)

 mov r9d,0
 mov r8d,8
 mov rdx,rax
 mov rcx,rbx
 call cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint
 mov rbx,rax
 ;ir_call cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint POP() POP() 8 0; (push)

 mov r10d,dword [rbp-64]
 mov dword [rbp-68],r10d
 ;ir_load L3 [L2 . 0];

 mov r10d,dword [rbp-60]
 mov dword [rbp-72],r10d
 ;ir_load L4 [L2 . 1];

 lea rax,[$cbstr2]
 ;ir_load_addr STR2; (push)

 mov qword [rbp-136],rax
 ;ir_load [L9 . 0] POP();

 mov r10d,11
 mov qword [rbp-128],r10
 ;ir_load [L9 . 1] 11;

 lea rax,qword [rbp-136]
 ;ir_load_addr L9; (push)

 mov rdx,rax
 mov ecx,dword [rbp-68]
 call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 L3 POP(); (push)

 ;ir_noop POP();

 mov ecx,dword [rbp-68]
 call cb__Nstd__Nsystem__Nclose__Aint
 ;ir_call cb__Nstd__Nsystem__Nclose__Aint L3; (push)

 ;ir_noop POP();

 lea rax,[$cbstr1]
 ;ir_load_addr STR1; (push)

 mov qword [rbp-152],rax
 ;ir_load [L10 . 0] POP();

 mov r10d,8
 mov qword [rbp-144],r10
 ;ir_load [L10 . 1] 8;

 lea rdi,qword [rbp-80]
 ;ir_load_addr L5; (push)

 lea rax,qword [rbp-152]
 ;ir_load_addr L10; (push)

 mov r9d,0
 mov r8d,4
 mov rdx,rax
 mov rcx,rdi
 call cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint
 mov rdi,rax
 ;ir_call cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint POP() POP() 4 0; (push)

 mov r10d,dword [rbp-80]
 mov dword [rbp-84],r10d
 ;ir_load L6 [L5 . 0];

 mov r10d,dword [rbp-76]
 mov dword [rbp-72],r10d
 ;ir_load L4 [L5 . 1];

 mov r10d,0
 mov qword [rbp-40],r10
 ;ir_load [L0 . 0] 0;

 mov r10d,0
 mov qword [rbp-32],r10
 ;ir_load [L0 . 1] 0;

 mov r10d,0
 mov qword [rbp-24],r10
 ;ir_load [L0 . 2] 0;

 mov r10d,0
 mov qword [rbp-16],r10
 ;ir_load [L0 . 3] 0;

 mov r10d,0
 mov dword [rbp-8],r10d
 ;ir_load [L0 . 4] 0;

 lea rax,[$cbstr1]
 ;ir_load_addr STR1; (push)

 mov qword [rbp-168],rax
 ;ir_load [L11 . 0] POP();

 mov r10d,8
 mov qword [rbp-160],r10
 ;ir_load [L11 . 1] 8;

 lea rsi,qword [rbp-168]
 ;ir_load_addr L11; (push)

 lea rax,qword [rbp-40]
 ;ir_load_addr L0; (push)

 mov rdx,rax
 mov rcx,rsi
 call cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data
 ;ir_call cb__Nstd__Nsystem__Nstat__Aptr__Tslice__Tpure__Tuint8__Aptr__Tstat_data POP() POP(); (push)

 ;ir_noop POP();

 lea rsi,qword [rbp-104]
 ;ir_load_addr L7; (push)

 mov r10,qword [rbp-40]
 add r10,1
 mov rax,r10
 ;ir_add [L0 . 0] 1; (push)

 mov rdx,rax
 mov rcx,rsi
 call cb__Nstd__Nsystem__Nalloc__Aptr__Tmemory__Ausize
 mov rsi,rax
 ;ir_call cb__Nstd__Nsystem__Nalloc__Aptr__Tmemory__Ausize POP() POP(); (push)

 mov r10,qword [rbp-104]
 mov qword [rbp-56],r10
 ;ir_load [L1 . 0] [L7 . 0];

 mov r10,qword [rbp-96]
 mov qword [rbp-48],r10
 ;ir_load [L1 . 1] [L7 . 1];

 push rdi
 push rsi
 lea rdi,qword [rbp-184]
 lea rsi,qword [rbp-56]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L12 L1 16;

 lea rax,qword [rbp-184]
 ;ir_load_addr L12; (push)

 mov rdx,rax
 mov ecx,dword [rbp-84]
 call cb__Nstd__Nsystem__Nread__Aint__Aptr__Tslice__Tuint8
 ;ir_call cb__Nstd__Nsystem__Nread__Aint__Aptr__Tslice__Tuint8 L6 POP(); (push)

 ;ir_noop POP();

 push rdi
 push rsi
 lea rdi,qword [rbp-200]
 lea rsi,qword [rbp-56]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L13 L1 16;

 call cb__Nstd__Nsystem__Nget_stdout_fd
 mov r12d,eax
 ;ir_call cb__Nstd__Nsystem__Nget_stdout_fd; (push)

 lea rax,qword [rbp-200]
 ;ir_load_addr L13; (push)

 mov rdx,rax
 mov ecx,r12d
 call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

 ;ir_noop POP();

 lea rax,[$cbstr3]
 ;ir_load_addr STR3; (push)

 mov qword [rbp-216],rax
 ;ir_load [L14 . 0] POP();

 mov r10d,1
 mov qword [rbp-208],r10
 ;ir_load [L14 . 1] 1;

 call cb__Nstd__Nsystem__Nget_stdout_fd
 mov r12d,eax
 ;ir_call cb__Nstd__Nsystem__Nget_stdout_fd; (push)

 lea rax,qword [rbp-216]
 ;ir_load_addr L14; (push)

 mov rdx,rax
 mov ecx,r12d
 call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

 ;ir_noop POP();

 lea rax,qword [rbp-104]
 ;ir_load_addr L7; (push)

 mov rcx,rax
 call cb__Nstd__Nsystem__Nfree__Aptr__Tmemory
 ;ir_call cb__Nstd__Nsystem__Nfree__Aptr__Tmemory POP();

 mov ecx,dword [rbp-84]
 call cb__Nstd__Nsystem__Nclose__Aint
 ;ir_call cb__Nstd__Nsystem__Nclose__Aint L6; (push)

 ;ir_noop POP();

 call cb__Ntest__Ntest_defer
 ;ir_call cb__Ntest__Ntest_defer;

 mov al,1
 ;ir_return 1;

cb__Ntest__Ntest_file_write$end:
 add rsp,256
 pop r12
 pop rsi
 pop rdi
 pop rbx
 pop rbp
 ret


cb__Ntest__Nget_values__Aptr__Ttuple__Tslice__Tpure__Tuint8__Tint:
 ;func get_values(&{[]pure uint8, int}): &{[]pure uint8, int}
 push rbp
 push rbx
 mov rbp,rsp
 sub rsp,8
 ;prolog end

 mov rax,rcx
 ;ir_deref A0; (push)

 lea rbx,qword [rax+0]
 ;ir_load_addr [POP() . 0]; (push)

 lea rax,[$cbstr4]
 ;ir_load_addr STR4; (push)

 mov qword [rbx+0],rax
 ;ir_load [POP() . 0] POP();

 mov rax,rcx
 ;ir_deref A0; (push)

 lea rax,qword [rax+0]
 ;ir_load_addr [POP() . 0]; (push)

 mov r10d,10
 mov qword [rax+8],r10
 ;ir_load [POP() . 1] 10;

 mov rax,rcx
 ;ir_deref A0; (push)

 mov r10d,48
 mov dword [rax+16],r10d
 ;ir_load [POP() . 1] 48;

 mov rax,rcx
 ;ir_return A0;

cb__Ntest__Nget_values__Aptr__Ttuple__Tslice__Tpure__Tuint8__Tint$end:
 add rsp,8
 pop rbx
 pop rbp
 ret


test_main:
 ;func test_main(): int
 push rbp
 push rbx
 push rdi
 push rsi
 push r12
 mov rbp,rsp
 sub rsp,352
 ;prolog end

 lea rax,qword [rbp-80]
 ;ir_load_addr L4; (push)

 mov rcx,rax
 call cb__Ntest__Nget_values__Aptr__Ttuple__Tslice__Tpure__Tuint8__Tint
 mov rbx,rax
 ;ir_call cb__Ntest__Nget_values__Aptr__Ttuple__Tslice__Tpure__Tuint8__Tint POP(); (push)

 push rdi
 push rsi
 lea rdi,qword [rbp-96]
 lea rsi,qword [rbp-80]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L5 [L4 . 0] 16;

 mov r10d,dword [rbp-64]
 mov dword [rbp-100],r10d
 ;ir_load L6 [L4 . 1];

 push rdi
 push rsi
 lea rdi,qword [rbp-152]
 lea rsi,qword [rbp-96]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L11 L5 16;

 call cb__Nstd__Nsystem__Nget_stdout_fd
 mov edi,eax
 ;ir_call cb__Nstd__Nsystem__Nget_stdout_fd; (push)

 lea rax,qword [rbp-152]
 ;ir_load_addr L11; (push)

 mov rdx,rax
 mov ecx,edi
 call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

 ;ir_noop POP();

 mov r10d,dword [rbp-100]
 cmp r10d,48
 jne test_main$if1476$else
 ;ir_jmp_neq L6 48 test_main$if1476$else;

test_main$if1476$body:
 ;ir_make_label test_main$if1476$body;

 lea rax,[$cbstr5]
 ;ir_load_addr STR5; (push)

 mov qword [rbp-296],rax
 ;ir_load [L20 . 0] POP();

 mov r10d,4
 mov qword [rbp-288],r10
 ;ir_load [L20 . 1] 4;

 call cb__Nstd__Nsystem__Nget_stdout_fd
 mov edi,eax
 ;ir_call cb__Nstd__Nsystem__Nget_stdout_fd; (push)

 lea rax,qword [rbp-296]
 ;ir_load_addr L20; (push)

 mov rdx,rax
 mov ecx,edi
 call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

 ;ir_noop POP();

test_main$if1476$else:
 ;ir_make_label test_main$if1476$else;

 lea rax,[$cbstr3]
 ;ir_load_addr STR3; (push)

 mov qword [rbp-168],rax
 ;ir_load [L12 . 0] POP();

 mov r10d,1
 mov qword [rbp-160],r10
 ;ir_load [L12 . 1] 1;

 call cb__Nstd__Nsystem__Nget_stdout_fd
 mov edi,eax
 ;ir_call cb__Nstd__Nsystem__Nget_stdout_fd; (push)

 lea rax,qword [rbp-168]
 ;ir_load_addr L12; (push)

 mov rdx,rax
 mov ecx,edi
 call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

 ;ir_noop POP();

 call cb__Ntest__Ntest_file_write
 ;ir_call cb__Ntest__Ntest_file_write; (push)

 ;ir_noop POP();

 mov r10,0
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 0; (push)

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load POP() 0;

 mov r10,1
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 1; (push)

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load POP() 0;

 mov r10,2
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 2; (push)

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load POP() 0;

 mov r10,3
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 3; (push)

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load POP() 0;

 mov r10,4
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 4; (push)

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load POP() 0;

 mov r10,5
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 5; (push)

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load POP() 0;

 mov r10,6
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 6; (push)

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load POP() 0;

 mov r10,7
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 7; (push)

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load POP() 0;

 mov r10,8
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 8; (push)

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load POP() 0;

 mov r10,9
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 9; (push)

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load POP() 0;

 mov r10,10
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 10; (push)

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load POP() 0;

 mov r10,11
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 11; (push)

 mov r10b,0
 mov byte [rax+0],r10b
 ;ir_load POP() 0;

 mov r10,0
 lea rax,qword [rbp-12+r10*1]
 ;ir_index L0 0; (push)

 lea rax,byte [rax+0]
 ;ir_load_addr POP(); (push)

 mov qword [rbp-32],rax
 ;ir_load [L1 . 0] POP();

 mov r10,12
 mov qword [rbp-24],r10
 ;ir_load [L1 . 1] 12;

 lea rax,[$cbstr1]
 ;ir_load_addr STR1; (push)

 mov qword [rbp-184],rax
 ;ir_load [L13 . 0] POP();

 mov r10d,8
 mov qword [rbp-176],r10
 ;ir_load [L13 . 1] 8;

 lea rdi,qword [rbp-108]
 ;ir_load_addr L7; (push)

 lea rax,qword [rbp-184]
 ;ir_load_addr L13; (push)

 mov r9d,0
 mov r8d,4
 mov rdx,rax
 mov rcx,rdi
 call cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint
 mov rdi,rax
 ;ir_call cb__Nstd__Nsystem__Nopen__Aptr__Ttuple__Tint__Terror__Aptr__Tslice__Tpure__Tuint8__Aint__Aint POP() POP() 4 0; (push)

 mov r10d,dword [rbp-108]
 mov dword [rbp-112],r10d
 ;ir_load L8 [L7 . 0];

 mov r10d,dword [rbp-104]
 mov dword [rbp-116],r10d
 ;ir_load L9 [L7 . 1];

 push rdi
 push rsi
 lea rdi,qword [rbp-200]
 lea rsi,qword [rbp-32]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L14 L1 16;

 lea rax,qword [rbp-200]
 ;ir_load_addr L14; (push)

 mov rdx,rax
 mov ecx,dword [rbp-112]
 call cb__Nstd__Nsystem__Nread__Aint__Aptr__Tslice__Tuint8
 ;ir_call cb__Nstd__Nsystem__Nread__Aint__Aptr__Tslice__Tuint8 L8 POP(); (push)

 ;ir_noop POP();

 push rdi
 push rsi
 lea rdi,qword [rbp-216]
 lea rsi,qword [rbp-32]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L15 L1 16;

 call cb__Nstd__Nsystem__Nget_stdout_fd
 mov esi,eax
 ;ir_call cb__Nstd__Nsystem__Nget_stdout_fd; (push)

 lea rax,qword [rbp-216]
 ;ir_load_addr L15; (push)

 mov rdx,rax
 mov ecx,esi
 call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

 ;ir_noop POP();

 lea rax,[$cbstr3]
 ;ir_load_addr STR3; (push)

 mov qword [rbp-232],rax
 ;ir_load [L16 . 0] POP();

 mov r10d,1
 mov qword [rbp-224],r10
 ;ir_load [L16 . 1] 1;

 call cb__Nstd__Nsystem__Nget_stdout_fd
 mov esi,eax
 ;ir_call cb__Nstd__Nsystem__Nget_stdout_fd; (push)

 lea rax,qword [rbp-232]
 ;ir_load_addr L16; (push)

 mov rdx,rax
 mov ecx,esi
 call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

 ;ir_noop POP();

 mov ecx,dword [rbp-112]
 call cb__Nstd__Nsystem__Nclose__Aint
 ;ir_call cb__Nstd__Nsystem__Nclose__Aint L8; (push)

 ;ir_noop POP();

 lea rax,[$cbstr6]
 ;ir_load_addr STR6; (push)

 mov qword [rbp-56],rax
 ;ir_load [L3 . 0] POP();

 mov r10d,9
 mov qword [rbp-48],r10
 ;ir_load [L3 . 1] 9;

 push rdi
 push rsi
 lea rdi,qword [rbp-248]
 lea rsi,qword [rbp-56]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
 ;ir_copy L17 L3 16;

 call cb__Nstd__Nsystem__Nget_stdout_fd
 mov esi,eax
 ;ir_call cb__Nstd__Nsystem__Nget_stdout_fd; (push)

 lea rax,qword [rbp-248]
 ;ir_load_addr L17; (push)

 mov rdx,rax
 mov ecx,esi
 call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

 ;ir_noop POP();

 lea rax,[$cbstr3]
 ;ir_load_addr STR3; (push)

 mov qword [rbp-264],rax
 ;ir_load [L18 . 0] POP();

 mov r10d,1
 mov qword [rbp-256],r10
 ;ir_load [L18 . 1] 1;

 call cb__Nstd__Nsystem__Nget_stdout_fd
 mov esi,eax
 ;ir_call cb__Nstd__Nsystem__Nget_stdout_fd; (push)

 lea rax,qword [rbp-264]
 ;ir_load_addr L18; (push)

 mov rdx,rax
 mov ecx,esi
 call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

 ;ir_noop POP();

 lea rsi,qword [rbp-136]
 ;ir_load_addr L10; (push)

 mov r10,qword [rbp-48]
 add r10,1
 mov rax,r10
 ;ir_add [L3 . 1] 1; (push)

 mov rdx,rax
 mov rcx,rsi
 call cb__Nstd__Nsystem__Nalloc__Aptr__Tmemory__Ausize
 mov rsi,rax
 ;ir_call cb__Nstd__Nsystem__Nalloc__Aptr__Tmemory__Ausize POP() POP(); (push)

 mov r10,qword [rbp-136]
 mov qword [rbp-40],r10
 ;ir_load L2 [L10 . 0];

 mov r10d,0
 mov dword [rbp-312],r10d
 ;ir_load [L21 . 0] 0;

 mov r10,qword [rbp-48]
 mov qword [rbp-308],r10
 ;ir_load [L21 . 1] [L3 . 1];

 mov r10d,dword [rbp-312]
 mov dword [rbp-316],r10d
 ;ir_load L22 [L21 . 0];

test_main$f1625$cond:
 ;ir_make_label test_main$f1625$cond;

 movsxd rax,dword [rbp-316]
 ;ir_cast L22; (push)

 cmp rax,qword [rbp-308]
 jge test_main$f1625$end
 ;ir_jmp_gte POP() [L21 . 1] test_main$f1625$end;

test_main$f1625$body:
 ;ir_make_label test_main$f1625$body;

 mov rax,qword [rbp-40]
 ;ir_deref L2; (push)

 movsxd r10,dword [rbp-316]
 lea r12,byte [rax+r10*1]
 ;ir_index POP() L22; (push)

 mov rax,qword [rbp-56]
 ;ir_deref [L3 . 0]; (push)

 movsxd r10,dword [rbp-316]
 lea rax,byte [rax+r10*1]
 ;ir_index POP() L22; (push)

 mov r10b,byte [rax+0]
 mov byte [r12+0],r10b
 ;ir_load POP() POP();

 mov r10d,dword [rbp-316]
 add r10d,1
 mov eax,r10d
 ;ir_add L22 1; (push)

 mov dword [rbp-316],eax
 ;ir_load L22 POP();

 jmp test_main$f1625$cond
 ;ir_jmp test_main$f1625$cond;

test_main$f1625$end:
 ;ir_make_label test_main$f1625$end;

 mov r10,qword [rbp-40]
 mov qword [rbp-280],r10
 ;ir_load [L19 . 0] L2;

 mov r10,qword [rbp-48]
 mov qword [rbp-272],r10
 ;ir_load [L19 . 1] [L3 . 1];

 call cb__Nstd__Nsystem__Nget_stdout_fd
 mov r12d,eax
 ;ir_call cb__Nstd__Nsystem__Nget_stdout_fd; (push)

 lea rax,qword [rbp-280]
 ;ir_load_addr L19; (push)

 mov rdx,rax
 mov ecx,r12d
 call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8
 ;ir_call cb__Nstd__Nsystem__Nwrite__Aint__Aptr__Tslice__Tpure__Tuint8 POP() POP(); (push)

 ;ir_noop POP();

 lea rax,qword [rbp-136]
 ;ir_load_addr L10; (push)

 mov rcx,rax
 call cb__Nstd__Nsystem__Nfree__Aptr__Tmemory
 ;ir_call cb__Nstd__Nsystem__Nfree__Aptr__Tmemory POP();

 mov eax,0
 ;ir_return 0;

test_main$end:
 add rsp,352
 pop r12
 pop rsi
 pop rdi
 pop rbx
 pop rbp
 ret


