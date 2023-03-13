	.text
	.section .mdebug.abi ilp32s
	.previous
	.file	"test.c"
	.globl	test_longbranch         # -- Begin function test_longbranch
	.p2align	3
	.type	test_longbranch,@function
	.ent	test_longbranch         # @test_longbranch
test_longbranch:
# %bb.0:
	addi.w	$r3, $r3, -16
	addi.w	$r4, $r0, 2
	st.w	$r4, $r3, 12
	addi.w	$r4, $r0, 1
	st.w	$r4, $r3, 8
	addi.w	$r4, $r0, 0
	st.w	$r4, $r3, 4
	ld.w	$r4, $r3, 12
	ld.w	$r5, $r3, 8
	bge	$r4, $r5, $BB0_2
	b	$BB0_1
$BB0_1:
	addi.w	$r4, $r0, 1
	st.w	$r4, $r3, 4
	b	$BB0_2
$BB0_2:
	ld.w	$r4, $r3, 4
	addi.w	$r3, $r3, 16
	jr	$r1
$func_end0:
	.size	test_longbranch, ($func_end0)-test_longbranch
                                        # -- End function
	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
