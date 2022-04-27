.global cb__Nmain__Nexit__Aint
.global carbon_main
.data
.cbstr0:
    .string "somestring"
.text
cb__Nmain__Nexit__Aint:
# func exit(int): {}
 push %rbp
 mov %rsp,%rbp
# prolog end

    mov $60, %rax           # system call 60 is exit
                            # code is already in rdi
    syscall

cb__Nmain__Nexit__Aint$end:
 pop %rbp
 ret


carbon_main:
# func carbon_main(): {}
 push %rbp
 mov %rsp,%rbp
 sub $48,%rsp
# prolog end

 lea .cbstr0,%rax
# ir_load_addr STR0; (push)

 mov %rax,-16(%rbp)
# ir_load [L0 . 0] POP();

 mov $10,%r10d
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] 10;

 mov -8(%rbp),%r10
 mov %r10,-24(%rbp)
# ir_load L1 [L0 . 1];

 mov -24(%rbp),%r10
 mov %r10d,%eax
# ir_cast L1; (push)

 mov %eax,%edi
 callq cb__Nmain__Nexit__Aint
# ir_call cb__Nmain__Nexit__Aint POP();

carbon_main$end:
 add $48,%rsp
 pop %rbp
 ret


