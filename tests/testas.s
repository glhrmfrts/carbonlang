	.file	"testas.c"
	.text
	.comm	arr,128,32
	.comm	otherarr,256,32
	.section	.rodata
.LC0:
	.string	"Hello World\n"
	.section	.data.rel.local,"aw"
	.align 8
	.type	msg, @object
	.size	msg, 8
msg:
	.quad	.LC0
	.local	global_first
	.comm	global_first,4,4
	.data
	.align 4
	.type	global_second, @object
	.size	global_second, 4
global_second:
	.long	3
	.align 2
	.type	global_short, @object
	.size	global_short, 2
global_short:
	.value	12
	.text
	.type	testf, @function
testf:
.LFB0:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$1056, %rsp
	movl	%edi, -1044(%rbp)
	movl	%esi, -1048(%rbp)
	movq	%rdx, -1056(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpl	$1, -1044(%rbp)
	jne	.L4
	cmpl	$2, -1048(%rbp)
	jne	.L4
	movl	-1044(%rbp), %eax
	movl	%eax, arr(%rip)
	movl	-1048(%rbp), %eax
	movl	%eax, 4+arr(%rip)
	movl	-1044(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rbp, %rax
	subq	$1040, %rax
	movq	$10, (%rax)
	movl	-1048(%rbp), %eax
	cltq
	salq	$4, %rax
	addq	%rbp, %rax
	subq	$1032, %rax
	movq	$20, (%rax)
	movq	-1056(%rbp), %rax
	movq	%rax, %rdi
	call	puts@PLT
.L4:
	nop
	movq	-8(%rbp), %rax
	xorq	%fs:40, %rax
	je	.L3
	call	__stack_chk_fail@PLT
.L3:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	testf, .-testf
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	msg(%rip), %rax
	movq	%rax, %rdx
	movl	$2, %esi
	movl	$1, %edi
	call	testf
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
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
