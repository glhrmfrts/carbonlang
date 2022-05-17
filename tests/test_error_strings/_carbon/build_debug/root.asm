.global cb__Nroot__Nmain
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
 movq %rsp,%rbp
 sub $16,%rsp
# prolog end

 xor %edi,%edi
 call cb__Nio__Nprintln__Aerror
# ir_call cb__Nio__Nprintln__Aerror 0;

 movl $1304468645,%edi
 call cb__Nio__Nprintln__Aerror
# ir_call cb__Nio__Nprintln__Aerror 1304468645;

 movl $3550758667,%edi
 call cb__Nio__Nprintln__Aerror
# ir_call cb__Nio__Nprintln__Aerror 3550758667;

 movl $1541895403,%edi
 call cb__Nio__Nprintln__Aerror
# ir_call cb__Nio__Nprintln__Aerror 1541895403;

 movl $2669138376,%edi
 call cb__Nio__Nprintln__Aerror
# ir_call cb__Nio__Nprintln__Aerror 2669138376;

.cb__Nroot__Nmain$end:
 add $16,%rsp
 pop %rbp
 ret


