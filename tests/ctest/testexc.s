	.file	"testexc.cpp"
	.text
	.section	.text._ZNSt9exceptionC2Ev,"axG",@progbits,_ZNSt9exceptionC5Ev,comdat
	.align 2
	.weak	_ZNSt9exceptionC2Ev
	.type	_ZNSt9exceptionC2Ev, @function
_ZNSt9exceptionC2Ev:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	leaq	16+_ZTVSt9exception(%rip), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	_ZNSt9exceptionC2Ev, .-_ZNSt9exceptionC2Ev
	.weak	_ZNSt9exceptionC1Ev
	.set	_ZNSt9exceptionC1Ev,_ZNSt9exceptionC2Ev
	.section	.rodata
	.type	_ZStL19piecewise_construct, @object
	.size	_ZStL19piecewise_construct, 1
_ZStL19piecewise_construct:
	.zero	1
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
	.section	.text._ZN11MyExceptionC2Ei,"axG",@progbits,_ZN11MyExceptionC5Ei,comdat
	.align 2
	.weak	_ZN11MyExceptionC2Ei
	.type	_ZN11MyExceptionC2Ei, @function
_ZN11MyExceptionC2Ei:
.LFB1523:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	_ZNSt9exceptionC2Ev
	leaq	16+_ZTV11MyException(%rip), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-8(%rbp), %rax
	movl	-12(%rbp), %edx
	movl	%edx, 8(%rax)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1523:
	.size	_ZN11MyExceptionC2Ei, .-_ZN11MyExceptionC2Ei
	.weak	_ZN11MyExceptionC1Ei
	.set	_ZN11MyExceptionC1Ei,_ZN11MyExceptionC2Ei
	.text
	.globl	_Z6MyFunci
	.type	_Z6MyFunci, @function
_Z6MyFunci:
.LFB1525:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$24, %rsp
	.cfi_offset 3, -24
	movl	%edi, -20(%rbp)
	cmpl	$5, -20(%rbp)
	jle	.L5
	movl	$16, %edi
	call	__cxa_allocate_exception@PLT
	movq	%rax, %rbx
	movl	$5, %esi
	movq	%rbx, %rdi
	call	_ZN11MyExceptionC1Ei
	leaq	_ZN11MyExceptionD1Ev(%rip), %rdx
	leaq	_ZTI11MyException(%rip), %rsi
	movq	%rbx, %rdi
	call	__cxa_throw@PLT
.L5:
	nop
	addq	$24, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1525:
	.size	_Z6MyFunci, .-_Z6MyFunci
	.section	.rodata
.LC0:
	.string	"Nice"
	.text
	.globl	main
	.type	main, @function
main:
.LFB1532:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	.LC0(%rip), %rsi
	leaq	_ZSt4cout(%rip), %rdi
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc@PLT
	movq	%rax, %rdx
	movq	_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@GOTPCREL(%rip), %rax
	movq	%rax, %rsi
	movq	%rdx, %rdi
	call	_ZNSolsEPFRSoS_E@PLT
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1532:
	.size	main, .-main
	.weak	_ZTV11MyException
	.section	.data.rel.ro._ZTV11MyException,"awG",@progbits,_ZTV11MyException,comdat
	.align 8
	.type	_ZTV11MyException, @object
	.size	_ZTV11MyException, 40
_ZTV11MyException:
	.quad	0
	.quad	_ZTI11MyException
	.quad	_ZN11MyExceptionD1Ev
	.quad	_ZN11MyExceptionD0Ev
	.quad	_ZNKSt9exception4whatEv
	.section	.text._ZN11MyExceptionD2Ev,"axG",@progbits,_ZN11MyExceptionD5Ev,comdat
	.align 2
	.weak	_ZN11MyExceptionD2Ev
	.type	_ZN11MyExceptionD2Ev, @function
_ZN11MyExceptionD2Ev:
.LFB2022:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	leaq	16+_ZTV11MyException(%rip), %rdx
	movq	-8(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	_ZNSt9exceptionD2Ev@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2022:
	.size	_ZN11MyExceptionD2Ev, .-_ZN11MyExceptionD2Ev
	.weak	_ZN11MyExceptionD1Ev
	.set	_ZN11MyExceptionD1Ev,_ZN11MyExceptionD2Ev
	.section	.text._ZN11MyExceptionD0Ev,"axG",@progbits,_ZN11MyExceptionD5Ev,comdat
	.align 2
	.weak	_ZN11MyExceptionD0Ev
	.type	_ZN11MyExceptionD0Ev, @function
_ZN11MyExceptionD0Ev:
.LFB2024:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	_ZN11MyExceptionD1Ev
	movq	-8(%rbp), %rax
	movl	$16, %esi
	movq	%rax, %rdi
	call	_ZdlPvm@PLT
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2024:
	.size	_ZN11MyExceptionD0Ev, .-_ZN11MyExceptionD0Ev
	.weak	_ZTI11MyException
	.section	.data.rel.ro._ZTI11MyException,"awG",@progbits,_ZTI11MyException,comdat
	.align 8
	.type	_ZTI11MyException, @object
	.size	_ZTI11MyException, 24
_ZTI11MyException:
	.quad	_ZTVN10__cxxabiv120__si_class_type_infoE+16
	.quad	_ZTS11MyException
	.quad	_ZTISt9exception
	.weak	_ZTS11MyException
	.section	.rodata._ZTS11MyException,"aG",@progbits,_ZTS11MyException,comdat
	.align 8
	.type	_ZTS11MyException, @object
	.size	_ZTS11MyException, 14
_ZTS11MyException:
	.string	"11MyException"
	.text
	.type	_Z41__static_initialization_and_destruction_0ii, @function
_Z41__static_initialization_and_destruction_0ii:
.LFB2025:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	cmpl	$1, -4(%rbp)
	jne	.L12
	cmpl	$65535, -8(%rbp)
	jne	.L12
	leaq	_ZStL8__ioinit(%rip), %rdi
	call	_ZNSt8ios_base4InitC1Ev@PLT
	leaq	__dso_handle(%rip), %rdx
	leaq	_ZStL8__ioinit(%rip), %rsi
	movq	_ZNSt8ios_base4InitD1Ev@GOTPCREL(%rip), %rax
	movq	%rax, %rdi
	call	__cxa_atexit@PLT

	call some_function
	cmp $0,%ecx
	je .cb_cont12

	mov %ecx, (local_temp_error_code)

	// defer statements for this point

	mov (local_temp_error_code), %ecx
	jmp .cb_catch512

.cb_cont12:
	mov %rax,(result)
	aasdasd
	aasdasd
	asd

	jmp .cb_catchend512

.cb_catch512:


.cb_catchend512:


.cb_end5123:
	add $24,%rsp
	pop %rbp
	ret

.L12:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2025:
	.size	_Z41__static_initialization_and_destruction_0ii, .-_Z41__static_initialization_and_destruction_0ii
	.type	_GLOBAL__sub_I__Z6MyFunci, @function
_GLOBAL__sub_I__Z6MyFunci:
.LFB2026:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$65535, %esi
	movl	$1, %edi
	call	_Z41__static_initialization_and_destruction_0ii
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2026:
	.size	_GLOBAL__sub_I__Z6MyFunci, .-_GLOBAL__sub_I__Z6MyFunci
	.section	.init_array,"aw"
	.align 8
	.quad	_GLOBAL__sub_I__Z6MyFunci
	.hidden	__dso_handle
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
