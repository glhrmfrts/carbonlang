.global cb__Nroot__Nmain
.global cb__Nroot__Nprint_size__Auint8
.global cb__Nroot__Nprint_size__Auint16
.global cb__Nroot__Nprint_size__Auint32
.global cb__Nroot__Nprint_size__Auint64
.global cb__Nroot__Nprint_size__Aptr__TData
.global cb__Nroot__Nprint_size_type__Cint8
.global cb__Nroot__Nprint_size_type__Cint16
.global cb__Nroot__Nprint_size_type__Cint32
.global cb__Nroot__Nprint_size_type__Cint64
.global cb__Nroot__Nprint_size_type__CData
.data
    .balign 16
    .size .cmp16selector, 16
.cmp16selector:
    .byte 0x0
    .byte 0x1
    .byte 0x8
    .byte 0x9
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
    .byte 0x80
.section .rodata
.text
cb__Nroot__Nmain:
# func main(): {}
 push %rbp
 mov %rsp,%rbp
 sub $96,%rsp
# prolog end

 xor %r10b,%r10b
 mov %r10b,-1(%rbp)
# ir_load L0 0;

 xor %r10w,%r10w
 mov %r10w,-4(%rbp)
# ir_load L1 0;

 xor %r10d,%r10d
 mov %r10d,-8(%rbp)
# ir_load L2 0;

 xor %r10,%r10
 mov %r10,-16(%rbp)
# ir_load L3 0;

 xor %r10,%r10
 mov %r10,-48(%rbp)
 mov %r10,-40(%rbp)
 mov %r10,-32(%rbp)
 mov %r10,-24(%rbp)
# ir_store L4 0 0 32;

 mov -1(%rbp),%dil
 call cb__Nroot__Nprint_size__Auint8
# ir_call cb__Nroot__Nprint_size__Auint8 L0;

 mov -4(%rbp),%di
 call cb__Nroot__Nprint_size__Auint16
# ir_call cb__Nroot__Nprint_size__Auint16 L1;

 mov -8(%rbp),%edi
 call cb__Nroot__Nprint_size__Auint32
# ir_call cb__Nroot__Nprint_size__Auint32 L2;

 mov -16(%rbp),%rdi
 call cb__Nroot__Nprint_size__Auint64
# ir_call cb__Nroot__Nprint_size__Auint64 L3;

 push %rdi
 push %rsi
 lea -80(%rbp),%rdi
 lea -48(%rbp),%rsi
 mov $32,%rcx
 rep movsb
 pop %rsi
 pop %rdi
# ir_copy L5 L4 32;

 lea -80(%rbp),%rax
# ir_load_addr L5; (push)

 mov %rax,%rdi
 call cb__Nroot__Nprint_size__Aptr__TData
# ir_call cb__Nroot__Nprint_size__Aptr__TData POP();

 call cb__Nroot__Nprint_size_type__Cint8
# ir_call cb__Nroot__Nprint_size_type__Cint8;

 call cb__Nroot__Nprint_size_type__Cint16
# ir_call cb__Nroot__Nprint_size_type__Cint16;

 call cb__Nroot__Nprint_size_type__Cint32
# ir_call cb__Nroot__Nprint_size_type__Cint32;

 call cb__Nroot__Nprint_size_type__Cint64
# ir_call cb__Nroot__Nprint_size_type__Cint64;

 call cb__Nroot__Nprint_size_type__CData
# ir_call cb__Nroot__Nprint_size_type__CData;

.cb__Nroot__Nmain$end:
 add $96,%rsp
 pop %rbp
 ret


cb__Nroot__Nprint_size__Auint8:
# func print_size(uint8): {}
 mov %dil,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov $1,%rdi
 call cb__Nstd__Nio__Nprintln__Ausize
# ir_call cb__Nstd__Nio__Nprintln__Ausize 1;

.cb__Nroot__Nprint_size__Auint8$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nroot__Nprint_size__Auint16:
# func print_size(uint16): {}
 mov %di,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov $2,%rdi
 call cb__Nstd__Nio__Nprintln__Ausize
# ir_call cb__Nstd__Nio__Nprintln__Ausize 2;

.cb__Nroot__Nprint_size__Auint16$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nroot__Nprint_size__Auint32:
# func print_size(uint32): {}
 mov %edi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov $4,%rdi
 call cb__Nstd__Nio__Nprintln__Ausize
# ir_call cb__Nstd__Nio__Nprintln__Ausize 4;

.cb__Nroot__Nprint_size__Auint32$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nroot__Nprint_size__Auint64:
# func print_size(uint64): {}
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov $8,%rdi
 call cb__Nstd__Nio__Nprintln__Ausize
# ir_call cb__Nstd__Nio__Nprintln__Ausize 8;

.cb__Nroot__Nprint_size__Auint64$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nroot__Nprint_size__Aptr__TData:
# func print_size(Data): {}
 mov %rdi,8(%rsp)
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov $32,%rdi
 call cb__Nstd__Nio__Nprintln__Ausize
# ir_call cb__Nstd__Nio__Nprintln__Ausize 32;

.cb__Nroot__Nprint_size__Aptr__TData$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nroot__Nprint_size_type__Cint8:
# func print_size_type(): {}
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov $1,%rdi
 call cb__Nstd__Nio__Nprintln__Ausize
# ir_call cb__Nstd__Nio__Nprintln__Ausize 1;

.cb__Nroot__Nprint_size_type__Cint8$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nroot__Nprint_size_type__Cint16:
# func print_size_type(): {}
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov $2,%rdi
 call cb__Nstd__Nio__Nprintln__Ausize
# ir_call cb__Nstd__Nio__Nprintln__Ausize 2;

.cb__Nroot__Nprint_size_type__Cint16$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nroot__Nprint_size_type__Cint32:
# func print_size_type(): {}
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov $4,%rdi
 call cb__Nstd__Nio__Nprintln__Ausize
# ir_call cb__Nstd__Nio__Nprintln__Ausize 4;

.cb__Nroot__Nprint_size_type__Cint32$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nroot__Nprint_size_type__Cint64:
# func print_size_type(): {}
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov $8,%rdi
 call cb__Nstd__Nio__Nprintln__Ausize
# ir_call cb__Nstd__Nio__Nprintln__Ausize 8;

.cb__Nroot__Nprint_size_type__Cint64$end:
 add $16,%rsp
 pop %rbp
 ret


cb__Nroot__Nprint_size_type__CData:
# func print_size_type(): {}
 push %rbp
 mov %rsp,%rbp
 sub $16,%rsp
# prolog end

 mov $32,%rdi
 call cb__Nstd__Nio__Nprintln__Ausize
# ir_call cb__Nstd__Nio__Nprintln__Ausize 32;

.cb__Nroot__Nprint_size_type__CData$end:
 add $16,%rsp
 pop %rbp
 ret


