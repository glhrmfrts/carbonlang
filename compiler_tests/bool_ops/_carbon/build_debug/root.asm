global carbon_main
export carbon_main
global cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Tslice__Tptr__Tpure__Tuint8__Ausize
export cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Tslice__Tptr__Tpure__Tuint8__Ausize
section .data
$cmp16selector: db 0x0,0x1,0x8,0x9,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80
section .rodata
section .code
carbon_main:
;func carbon_main(): int
 push rbp
 mov rbp,rsp
 sub rsp,32
;prolog end

 lea rax,[rbp-16]
;ir_load_addr L0; (push)

 mov edx,1
 mov rcx,rax
 call cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Tslice__Tptr__Tpure__Tuint8__Ausize
;ir_call cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Tslice__Tptr__Tpure__Tuint8__Ausize POP() 1;

carbon_main$end:
 add rsp,32
 pop rbp
 ret


cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Tslice__Tptr__Tpure__Tuint8__Ausize:
;func alloc_slice(&[]&pure uint8, usize): &[]&pure uint8
 push rbp
 mov rbp,rsp
 sub rsp,16
;prolog end

 mov qword[rbp-8],rcx
;ir_load L0 A0;

 mov rax,qword[rbp-8]
;ir_deref L0; (push)

 xor r10,r10
 mov qword[rax+0],r10
;ir_load [POP() . 0] 0;

 mov rax,qword[rbp-8]
;ir_deref L0; (push)

 xor r10d,r10d
 mov qword[rax+8],r10
;ir_load [POP() . 1] 0;

 mov rax,rcx
;ir_return A0;

cb__Nroot__Nalloc_slice__Cptr__Tpure__Tuint8__Aptr__Tslice__Tptr__Tpure__Tuint8__Ausize$end:
 add rsp,16
 pop rbp
 ret


