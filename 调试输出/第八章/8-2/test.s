	.text
	.section .mdebug.abi ilp32s
	.previous
	.file	"test.c"
	.globl	sum_i                   # -- Begin function sum_i
	.p2align	3
	.type	sum_i,@function
	.ent	sum_i                   # @sum_i
sum_i:
# %bb.0:
	addi.w	$r3, $r3, -48
	st.w	$r4, $r3, 44
	st.w	$r5, $r3, 40
	st.w	$r6, $r3, 36
	st.w	$r7, $r3, 32
	st.w	$r8, $r3, 28
	st.w	$r9, $r3, 24
	st.w	$r10, $r3, 20
	st.w	$r11, $r3, 16
	ld.w	$r4, $r3, 44
	ld.w	$r5, $r3, 40
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 36
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 32
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 28
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 24
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 20
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 16
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 80
	add.w	$r4, $r4, $r5
	st.w	$r4, $r3, 12
	ld.w	$r4, $r3, 12
	addi.w	$r3, $r3, 48
	jr	$r1
$func_end0:
	.size	sum_i, ($func_end0)-sum_i
                                        # -- End function
	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
