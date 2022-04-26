.global carbon_main
.data
.cbstr0:
    .string "Hello World 1"
.cbstr1:
    .string "Hello World 2"
.text
carbon_main:
# func carbon_main(): int
 push %rbp
 mov %rsp,%rbp
 sub %rsp,48
# prolog end

 lea .cbstr0,%rax
# ir_load_addr STR0; (push)

 mov %rax, -16(%rbp)
# ir_load [L0 . 0] POP();

 mov $13,%r10d
 mov %r10,-8(%rbp)
# ir_load [L0 . 1] 13;

 mov  [rbp-16],%r10
 mov %r10, [rbp-24]
# ir_load L1 [L0 . 0];

 lea .cbstr1,%rax
# ir_load_addr STR1; (push)

 mov %rax, [rbp-40]
# ir_load [L2 . 0] POP();

 mov 13,%r10d
 mov %r10, [rbp-32]
# ir_load [L2 . 1] 13;

 mov  [rbp-32],%r10
 mov %r10, [rbp-48]
# ir_load L3 [L2 . 1];

 mov  [rbp-48],%r10
 mov %r10d,%eax
# ir_cast L3; (push)

# ir_return POP();

carbon_main$end:
 add %rsp,48
 pop %rbp
 ret


