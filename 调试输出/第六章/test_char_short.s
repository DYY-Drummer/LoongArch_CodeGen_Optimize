	.text
	.section .mdebug.abi ilp32s
	.previous
	.file	"test.c"
	.globl	test_char               # -- Begin function test_char
	.p2align	3
	.type	test_char,@function
	.ent	test_char               # @test_char
test_char:
# %bb.0:
	addi.w	$r3, $r3, -16
	addi.w	$r4, $r0, 128
	st.b	$r4, $r3, 15
	ld.b	$r5, $r3, 15
	st.w	$r5, $r3, 8
	st.b	$r4, $r3, 7
	ld.bu	$r4, $r3, 7
	st.w	$r4, $r3, 0
	ld.w	$r4, $r3, 8
	addi.w	$r4, $r4, 2
	st.w	$r4, $r3, 8
	ld.w	$r4, $r3, 0
	addi.w	$r4, $r4, 2
	st.w	$r4, $r3, 0
	ld.w	$r4, $r3, 8
	ld.w	$r5, $r3, 0
	add.w	$r4, $r4, $r5
	addi.w	$r3, $r3, 16
	jr	$r1
$func_end0:
	.size	test_char, ($func_end0)-test_char
                                        # -- End function
	.globl	test_short              # -- Begin function test_short
	.p2align	3
	.type	test_short,@function
	.ent	test_short              # @test_short
test_short:
# %bb.0:
	addi.w	$r3, $r3, -16
	ori	$r4, $r0, 32768
	st.h	$r4, $r3, 14
	st.h	$r4, $r3, 12
	ld.h	$r4, $r3, 14
	st.w	$r4, $r3, 8
	ld.hu	$r4, $r3, 12
	st.w	$r4, $r3, 4
	ld.w	$r4, $r3, 8
	addi.w	$r4, $r4, 2
	st.w	$r4, $r3, 8
	ld.w	$r4, $r3, 4
	addi.w	$r4, $r4, 2
	st.w	$r4, $r3, 4
	ld.w	$r4, $r3, 8
	ld.w	$r5, $r3, 4
	add.w	$r4, $r4, $r5
	addi.w	$r3, $r3, 16
	jr	$r1
$func_end1:
	.size	test_short, ($func_end1)-test_short
                                        # -- End function
	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
