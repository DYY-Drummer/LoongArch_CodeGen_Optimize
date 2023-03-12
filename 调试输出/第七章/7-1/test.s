	.text
	.section .mdebug.abi ilp32s
	.previous
	.file	"test.c"
	.globl	test_JumpTable          # -- Begin function test_JumpTable
	.p2align	3
	.type	test_JumpTable,@function
	.ent	test_JumpTable          # @test_JumpTable
test_JumpTable:
	lu12i.w	$r20, %hi(_gp_disp)
	ori	$r20, $r20, %lo(_gp_disp)
	add.w	$r20, $r20, $r19
# %bb.0:
	addi.w	$r3, $r3, -16
	ld.w	$r4, $r20, %got(.L__const.test_JumpTable.flag)
	ori	$r4, $r4, %lo(.L__const.test_JumpTable.flag)
	ld.bu	$r5, $r4, 2
	st.b	$r5, $r3, 14
	ld.bu	$r5, $r4, 0
	ld.bu	$r4, $r4, 1
	slli.w	$r4, $r4, 8
	or	$r4, $r4, $r5
	st.h	$r4, $r3, 12
	addi.w	$r4, $r0, 0
	st.w	$r4, $r3, 8
	ld.bu	$r4, $r3, 12
	addi.w	$r5, $r0, 33
	beq	$r4, $r5, $BB0_3
	b	$BB0_1
$BB0_1:
	addi.w	$r5, $r0, 34
	beq	$r4, $r5, $BB0_4
	b	$BB0_2
$BB0_2:
	addi.w	$r5, $r0, 35
	beq	$r4, $r5, $BB0_5
	b	$BB0_6
$BB0_3:
	addi.w	$r4, $r0, 1
	st.w	$r4, $r3, 8
	b	$BB0_7
$BB0_4:
	addi.w	$r4, $r0, 2
	st.w	$r4, $r3, 8
	b	$BB0_7
$BB0_5:
	addi.w	$r4, $r0, 3
	st.w	$r4, $r3, 8
	b	$BB0_7
$BB0_6:
	addi.w	$r4, $r0, -1
	st.w	$r4, $r3, 8
	b	$BB0_7
$BB0_7:
	ld.w	$r4, $r3, 8
	addi.w	$r3, $r3, 16
	jr	$r1
$func_end0:
	.size	test_JumpTable, ($func_end0)-test_JumpTable
                                        # -- End function
	.globl	test_BlockAddress       # -- Begin function test_BlockAddress
	.p2align	3
	.type	test_BlockAddress,@function
	.ent	test_BlockAddress       # @test_BlockAddress
test_BlockAddress:
# %bb.0:
	addi.w	$r3, $r3, -16
	addi.w	$r4, $r0, 26
	st.w	$r4, $r3, 8
	ld.w	$r4, $r3, 8
	addi.w	$r5, $r0, 1
	blt	$r4, $r5, $BB1_2
	b	$BB1_1
$BB1_1:
	b	$BB1_3
$BB1_2:
	addi.w	$r4, $r0, 1
	st.w	$r4, $r3, 12
	b	$BB1_4
$BB1_3:
	addi.w	$r4, $r0, 0
	st.w	$r4, $r3, 12
	b	$BB1_4
$BB1_4:
	ld.w	$r4, $r3, 12
	addi.w	$r3, $r3, 16
	jr	$r1
$func_end1:
	.size	test_BlockAddress, ($func_end1)-test_BlockAddress
                                        # -- End function
	.globl	test_if_while_for_continue_break # -- Begin function test_if_while_for_continue_break
	.p2align	3
	.type	test_if_while_for_continue_break,@function
	.ent	test_if_while_for_continue_break # @test_if_while_for_continue_break
test_if_while_for_continue_break:
# %bb.0:
	addi.w	$r3, $r3, -16
	addi.w	$r4, $r0, 0
	st.w	$r4, $r3, 12
	addi.w	$r5, $r0, 26
	st.w	$r5, $r3, 8
	addi.w	$r5, $r0, 3
	st.w	$r5, $r3, 4
	st.w	$r4, $r3, 4
	b	$BB2_1
$BB2_1:                                 # =>This Inner Loop Header: Depth=1
	ld.w	$r4, $r3, 4
	addi.w	$r5, $r0, 3
	blt	$r5, $r4, $BB2_4
	b	$BB2_2
$BB2_2:                                 #   in Loop: Header=BB2_1 Depth=1
	ld.w	$r4, $r3, 12
	ld.w	$r5, $r3, 4
	add.w	$r4, $r4, $r5
	st.w	$r4, $r3, 12
	b	$BB2_3
$BB2_3:                                 #   in Loop: Header=BB2_1 Depth=1
	ld.w	$r4, $r3, 4
	addi.w	$r4, $r4, 1
	st.w	$r4, $r3, 4
	b	$BB2_1
$BB2_4:
	ld.w	$r4, $r3, 8
	bne	$r4, $r0, $BB2_6
	b	$BB2_5
$BB2_5:
	ld.w	$r4, $r3, 8
	addi.w	$r4, $r4, -1
	st.w	$r4, $r3, 8
	b	$BB2_9
$BB2_6:
	ld.w	$r4, $r3, 8
	addi.w	$r5, $r0, 1
	blt	$r4, $r5, $BB2_8
	b	$BB2_7
$BB2_7:
	ld.w	$r4, $r3, 8
	addi.w	$r4, $r4, 1
	st.w	$r4, $r3, 8
	b	$BB2_8
$BB2_8:
	b	$BB2_9
$BB2_9:
	b	$BB2_10
$BB2_10:                                # =>This Inner Loop Header: Depth=1
	ld.w	$r4, $r3, 4
	addi.w	$r5, $r0, 99
	blt	$r5, $r4, $BB2_14
	b	$BB2_11
$BB2_11:                                #   in Loop: Header=BB2_10 Depth=1
	ld.w	$r4, $r3, 12
	addi.w	$r4, $r4, 1
	st.w	$r4, $r3, 12
	ld.w	$r4, $r3, 4
	addi.w	$r4, $r4, 1
	st.w	$r4, $r3, 4
	ld.w	$r4, $r3, 12
	addi.w	$r5, $r0, 9
	bltu	$r5, $r4, $BB2_13
	b	$BB2_12
$BB2_12:                                #   in Loop: Header=BB2_10 Depth=1
	b	$BB2_10
$BB2_13:
	b	$BB2_15
$BB2_14:                                # %.loopexit
	b	$BB2_15
$BB2_15:
	ld.w	$r4, $r3, 12
	ld.w	$r5, $r3, 8
	add.w	$r4, $r4, $r5
	addi.w	$r3, $r3, 16
	jr	$r1
$func_end2:
	.size	test_if_while_for_continue_break, ($func_end2)-test_if_while_for_continue_break
                                        # -- End function
	.type	.L__const.test_JumpTable.flag,@object # @__const.test_JumpTable.flag
	.section	.rodata,"a",@progbits
.L__const.test_JumpTable.flag:
	.ascii	"!\"#"
	.size	.L__const.test_JumpTable.flag, 3

	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits

