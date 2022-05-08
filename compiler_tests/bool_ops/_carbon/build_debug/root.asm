global cb__Nroot__Nfree__Aptr__Topaque
export cb__Nroot__Nfree__Aptr__Topaque
global carbon_main
export carbon_main
global cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize
export cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize
global cb__Nroot__Nfree_slice__Aptr__Tslice__Tptr__Tpure__Tuint8
export cb__Nroot__Nfree_slice__Aptr__Tslice__Tptr__Tpure__Tuint8
global cb__Nroot__Nalloc_slice__Cptr__Tpure__Tint32__Aptr__Ttuple__Tslice__Tptr__Tpure__Tint32__Terror__Ausize
export cb__Nroot__Nalloc_slice__Cptr__Tpure__Tint32__Aptr__Ttuple__Tslice__Tptr__Tpure__Tint32__Terror__Ausize
global cb__Nroot__Nfree_slice__Aptr__Tslice__Tptr__Tpure__Tint32
export cb__Nroot__Nfree_slice__Aptr__Tslice__Tptr__Tpure__Tint32
section .data
$cmp16selector: db 0x0,0x1,0x8,0x9,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80
section .rodata
section .code
cb__Nroot__Nfree__Aptr__Topaque:
;func free(&opaque): {}
 push rbp
 mov rbp,rsp
;prolog end

cb__Nroot__Nfree__Aptr__Topaque$end:
 pop rbp
 ret


carbon_main:
;func carbon_main(): int
 push rbp
 mov rbp,rsp
 sub rsp,160
;prolog end

 lea rax,[rbp-32]
;ir_load_addr L0; (push)

 mov edx,1
 mov rcx,rax
 call cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize
;ir_call cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize POP() 1;

 push rdi
 push rsi
 lea rdi,[rbp-48]
 lea rsi,[rbp-32]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
;ir_copy L1 [L0 . 0] 16;

 mov r10d,dword[rbp-16]
 mov dword[rbp-52],r10d
;ir_load L2 [L0 . 1];

 push rdi
 push rsi
 lea rdi,[rbp-128]
 lea rsi,[rbp-48]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
;ir_copy L5 L1 16;

 lea rax,[rbp-128]
;ir_load_addr L5; (push)

 mov rcx,rax
 call cb__Nroot__Nfree_slice__Aptr__Tslice__Tptr__Tpure__Tuint8
;ir_call cb__Nroot__Nfree_slice__Aptr__Tslice__Tptr__Tpure__Tuint8 POP();

 lea rax,[rbp-96]
;ir_load_addr L3; (push)

 mov edx,1
 mov rcx,rax
 call cb__Nroot__Nalloc_slice__Cptr__Tpure__Tint32__Aptr__Ttuple__Tslice__Tptr__Tpure__Tint32__Terror__Ausize
;ir_call cb__Nroot__Nalloc_slice__Cptr__Tpure__Tint32__Aptr__Ttuple__Tslice__Tptr__Tpure__Tint32__Terror__Ausize POP() 1;

 push rdi
 push rsi
 lea rdi,[rbp-112]
 lea rsi,[rbp-96]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
;ir_copy L4 [L3 . 0] 16;

 mov r10d,dword[rbp-80]
 mov dword[rbp-52],r10d
;ir_load L2 [L3 . 1];

 push rdi
 push rsi
 lea rdi,[rbp-144]
 lea rsi,[rbp-112]
 mov rcx,16
 rep movsb
 pop rsi
 pop rdi
;ir_copy L6 L4 16;

 lea rax,[rbp-144]
;ir_load_addr L6; (push)

 mov rcx,rax
 call cb__Nroot__Nfree_slice__Aptr__Tslice__Tptr__Tpure__Tint32
;ir_call cb__Nroot__Nfree_slice__Aptr__Tslice__Tptr__Tpure__Tint32 POP();

carbon_main$end:
 add rsp,160
 pop rbp
 ret


cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize:
;func alloc_slice(&{[]&pure uint8, error}, usize): &{[]&pure uint8, error}
 mov qword[rsp+16],rdx
 mov qword[rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,64
;prolog end

 xor r10,r10
 mov qword[rbp-16],r10
;ir_load [L0 . 0] 0;

 xor r10d,r10d
 mov dword[rbp-8],r10d
;ir_load [L0 . 1] 0;

 mov r10,qword[rbp-16]
 mov qword[rbp-24],r10
;ir_load L1 [L0 . 0];

 mov r10d,dword[rbp-8]
 mov dword[rbp-28],r10d
;ir_load L2 [L0 . 1];

 mov r10d,dword[rbp-28]
 cmp r10d,0
 je cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize$if164$else
;ir_jmp_eq L2 0 cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize$if164$else;

cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize$if164$body:
;ir_make_label cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize$if164$body;

 mov r10,qword[rbp+16]
 mov qword[rbp-56],r10
;ir_load L4 A0;

 mov rax,qword[rbp-56]
;ir_deref L4; (push)

 xor r10,r10
 mov [rax+0],r10
 mov [rax+8],r10
;ir_store [POP() . 0] 0 0 16;

 mov rax,qword[rbp-56]
;ir_deref L4; (push)

 mov r10d,dword[rbp-28]
 mov dword[rax+16],r10d
;ir_load [POP() . 1] L2;

 mov rax,qword[rbp+16]
 jmp cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize$end
;ir_return A0;

cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize$if164$else:
;ir_make_label cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize$if164$else;

 mov r10,qword[rbp-24]
 mov qword[rbp-48],r10
;ir_load [L3 . 0] L1;

 mov r10,qword[rbp+24]
 mov qword[rbp-40],r10
;ir_load [L3 . 1] A1;

 mov r10,qword[rbp+16]
 mov qword[rbp-64],r10
;ir_load L5 A0;

 mov rax,qword[rbp-64]
;ir_deref L5; (push)

 mov r10,[rbp-48]
 mov [rax+0],r10
;ir_load [POP() . 0] L3;

 mov rax,qword[rbp-64]
;ir_deref L5; (push)

 xor r10d,r10d
 mov dword[rax+16],r10d
;ir_load [POP() . 1] 0;

 mov rax,qword[rbp+16]
;ir_return A0;

cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Ttuple__Tslice__Tptr__Tpure__Tuint8__Terror__Ausize$end:
 add rsp,64
 pop rbp
 ret


cb__Nroot__Nfree_slice__Aptr__Tslice__Tptr__Tpure__Tuint8:
;func free_slice([]&pure uint8): {}
 mov qword[rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,16
;prolog end

 mov rax,qword[rbp+16]
;ir_deref A0; (push)

 mov rcx,qword[rax+0]
 call cb__Nroot__Nfree__Aptr__Topaque
;ir_call cb__Nroot__Nfree__Aptr__Topaque [POP() . 0];

cb__Nroot__Nfree_slice__Aptr__Tslice__Tptr__Tpure__Tuint8$end:
 add rsp,16
 pop rbp
 ret


cb__Nroot__Nalloc_slice__Cptr__Tpure__Tint32__Aptr__Ttuple__Tslice__Tptr__Tpure__Tint32__Terror__Ausize:
;func alloc_slice(&{[]&pure int32, error}, usize): &{[]&pure int32, error}
 mov qword[rsp+16],rdx
 mov qword[rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,64
;prolog end

 xor r10,r10
 mov qword[rbp-16],r10
;ir_load [L0 . 0] 0;

 xor r10d,r10d
 mov dword[rbp-8],r10d
;ir_load [L0 . 1] 0;

 mov r10,qword[rbp-16]
 mov qword[rbp-24],r10
;ir_load L1 [L0 . 0];

 mov r10d,dword[rbp-8]
 mov dword[rbp-28],r10d
;ir_load L2 [L0 . 1];

 mov r10d,dword[rbp-28]
 cmp r10d,0
 je cb__Nroot__Nalloc_slice__Cptr__Tpure__Tint32__Aptr__Ttuple__Tslice__Tptr__Tpure__Tint32__Terror__Ausize$if331$else
;ir_jmp_eq L2 0 cb__Nroot__Nalloc_slice__Cptr__Tpure__Tint32__Aptr__Ttuple__Tslice__Tptr__Tpure__Tint32__Terror__Ausize$if331$else;

cb__Nroot__Nalloc_slice__Cptr__Tpure__Tint32__Aptr__Ttuple__Tslice__Tptr__Tpure__Tint32__Terror__Ausize$if331$body:
;ir_make_label cb__Nroot__Nalloc_slice__Cptr__Tpure__Tint32__Aptr__Ttuple__Tslice__Tptr__Tpure__Tint32__Terror__Ausize$if331$body;

 mov r10,qword[rbp+16]
 mov qword[rbp-56],r10
;ir_load L4 A0;

 mov rax,qword[rbp-56]
;ir_deref L4; (push)

 xor r10,r10
 mov [rax+0],r10
 mov [rax+8],r10
;ir_store [POP() . 0] 0 0 16;

 mov rax,qword[rbp-56]
;ir_deref L4; (push)

 mov r10d,dword[rbp-28]
 mov dword[rax+16],r10d
;ir_load [POP() . 1] L2;

 mov rax,qword[rbp+16]
 jmp cb__Nroot__Nalloc_slice__Cptr__Tpure__Tint32__Aptr__Ttuple__Tslice__Tptr__Tpure__Tint32__Terror__Ausize$end
;ir_return A0;

cb__Nroot__Nalloc_slice__Cptr__Tpure__Tint32__Aptr__Ttuple__Tslice__Tptr__Tpure__Tint32__Terror__Ausize$if331$else:
;ir_make_label cb__Nroot__Nalloc_slice__Cptr__Tpure__Tint32__Aptr__Ttuple__Tslice__Tptr__Tpure__Tint32__Terror__Ausize$if331$else;

 mov r10,qword[rbp-24]
 mov qword[rbp-48],r10
;ir_load [L3 . 0] L1;

 mov r10,qword[rbp+24]
 mov qword[rbp-40],r10
;ir_load [L3 . 1] A1;

 mov r10,qword[rbp+16]
 mov qword[rbp-64],r10
;ir_load L5 A0;

 mov rax,qword[rbp-64]
;ir_deref L5; (push)

 mov r10,[rbp-48]
 mov [rax+0],r10
;ir_load [POP() . 0] L3;

 mov rax,qword[rbp-64]
;ir_deref L5; (push)

 xor r10d,r10d
 mov dword[rax+16],r10d
;ir_load [POP() . 1] 0;

 mov rax,qword[rbp+16]
;ir_return A0;

cb__Nroot__Nalloc_slice__Cptr__Tpure__Tint32__Aptr__Ttuple__Tslice__Tptr__Tpure__Tint32__Terror__Ausize$end:
 add rsp,64
 pop rbp
 ret


cb__Nroot__Nfree_slice__Aptr__Tslice__Tptr__Tpure__Tint32:
;func free_slice([]&pure int32): {}
 mov qword[rsp+8],rcx
 push rbp
 mov rbp,rsp
 sub rsp,16
;prolog end

 mov rax,qword[rbp+16]
;ir_deref A0; (push)

 mov rcx,qword[rax+0]
 call cb__Nroot__Nfree__Aptr__Topaque
;ir_call cb__Nroot__Nfree__Aptr__Topaque [POP() . 0];

cb__Nroot__Nfree_slice__Aptr__Tslice__Tptr__Tpure__Tint32$end:
 add rsp,16
 pop rbp
 ret


