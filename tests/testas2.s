	.file	"testas2.c"
	.text
	.comm	pointer_to_int,8,8
	.data
	.align 32
	.type	some_data, @object
	.size	some_data, 64
some_data:
	.value	0
	.value	1
	.value	2
	.value	3
	.zero	56
	.globl	other_value
	.align 4
	.type	other_value, @object
	.size	other_value, 4
other_value:
	.long	5
	.local	nice_value
	.comm	nice_value,4,4
	.section	.rodata
.LC0:
	.string	"Hello"
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
	movl	$32, other_value(%rip)
	movl	$44, nice_value(%rip)
	leaq	other_value(%rip), %rax
	movq	%rax, pointer_to_int(%rip)
	leaq	.LC0(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
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
