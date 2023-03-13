	.text
	.section .mdebug.abi ilp32s
	.previous
	.file	"test.c"
	.globl	test_DelUselessJMP      # -- Begin function test_DelUselessJMP
	.p2align	3
	.type	test_DelUselessJMP,@function
	.ent	test_DelUselessJMP      # @test_DelUselessJMP
test_DelUselessJMP:
# %bb.0:
	addi.w	$r3, $r3, -16
	addi.w	$r4, $r0, 1
	st.w	$r4, $r3, 12
	addi.w	$r4, $r0, -2
	st.w	$r4, $r3, 8
	ld.w	$r4, $r3, 8
	bne	$r4, $r0, $BB0_3
# %bb.1:
	b	$BB0_2
$BB0_2:
	ld.w	$r4, $r3, 12
	addi.w	$r4, $r4, 3
	st.w	$r4, $r3, 12
	ld.w	$r4, $r3, 8
	addi.w	$r4, $r4, 1
	st.w	$r4, $r3, 8
	b	$BB0_7
$BB0_3:
	ld.w	$r4, $r3, 8
	addi.w	$r5, $r0, -1
	blt	$r5, $r4, $BB0_6
# %bb.4:
	b	$BB0_5
$BB0_5:
	ld.w	$r4, $r3, 12
	ld.w	$r5, $r3, 8
	add.w	$r4, $r4, $r5
	st.w	$r4, $r3, 12
	ld.w	$r4, $r3, 8
	addi.w	$r4, $r4, -1
	st.w	$r4, $r3, 8
	b	$BB0_6
$BB0_6:
	b	$BB0_7
$BB0_7:
	ld.w	$r4, $r3, 12
	addi.w	$r3, $r3, 16
	jr	$r1
$func_end0:
	.size	test_DelUselessJMP, ($func_end0)-test_DelUselessJMP
                                        # -- End function
	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
