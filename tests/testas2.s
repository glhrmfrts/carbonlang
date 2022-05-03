	.file	"testas2.c"
	.text
	.data
	.type	alone_char, @object
	.size	alone_char, 1
alone_char:
	.byte	3
	.align 32
	.type	some_data, @object
	.size	some_data, 32
some_data:
	.string	"\004\005\006\007\b\t\004\005\006\007\b\t\004\005\006\007\b\t\004\005\006\007\b\t\004\005\006\007\b\t"
	.ascii	"\001"
	.section	.rodata
.LC0:
	.string	"Hello"
.LC1:
	.string	"sizeof(bool) = %zu\n"
.LC2:
	.string	"pagesize = %ld\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	count.2927(%rip), %eax
	addl	$1, %eax
	movl	%eax, count.2927(%rip)
	movl	count.2927(%rip), %eax
	testl	%eax, %eax
	setg	%al
	movzbl	%al, %eax
	movl	%eax, is_true.2926(%rip)
	movl	is_true.2926(%rip), %eax
	testl	%eax, %eax
	je	.L2
	leaq	.LC0(%rip), %rdi
	call	puts@PLT
.L2:
	movl	$1, %esi
	leaq	.LC1(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$30, %edi
	call	sysconf@PLT
	movq	%rax, %rsi
	leaq	.LC2(%rip), %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.local	count.2927
	.comm	count.2927,4,4
	.local	is_true.2926
	.comm	is_true.2926,4,4
	.ident	"GCC: (Ubuntu 9.3.0-10ubuntu2) 9.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	 1f - 0f
	.long	 4f - 1f
	.long	 5
0:
	.string	 "GNU"
1:
	.align 8
	.long	 0xc0000002
	.long	 3f - 2f
2:
	.long	 0x3
3:
	.align 8
4:
