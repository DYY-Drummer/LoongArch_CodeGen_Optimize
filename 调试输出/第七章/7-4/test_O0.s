	.text
	.section .mdebug.abi ilp32s
	.previous
	.file	"test.c"
	.globl	test_select             # -- Begin function test_select
	.p2align	3
	.type	test_select,@function
	.ent	test_select             # @test_select
test_select:
# %bb.0:
	addi.w	$r3, $r3, -16
	addi.w	$r4, $r0, 1
	st.w	$r4, $r3, 12
	addi.w	$r5, $r0, 0
	st.w	$r5, $r3, 8
	ld.w	$r6, $r3, 12
	xor	$r5, $r6, $r5
	sltu	$r5, $r0, $r5
	masknez	$r4, $r4, $r5
	addi.w	$r6, $r0, 2
	maskeqz	$r5, $r6, $r5
	or	$r4, $r5, $r4
	st.w	$r4, $r3, 8
	ld.w	$r4, $r3, 8
	addi.w	$r3, $r3, 16
	jr	$r1
$func_end0:
	.size	test_select, ($func_end0)-test_select
                                        # -- End function
	.globl	test_select_global      # -- Begin function test_select_global
	.p2align	3
	.type	test_select_global,@function
	.ent	test_select_global      # @test_select_global
test_select_global:
# %bb.0:
	addi.w	$r3, $r3, -16
	lu12i.w	$r4, %got_hi(g1)
	add.w	$r4, $r4, $r20
	ld.w	$r4, $r4, %got_lo(g1)
	ld.w	$r4, $r4, 0
	lu12i.w	$r5, %got_hi(g2)
	add.w	$r5, $r5, $r20
	ld.w	$r5, $r5, %got_lo(g2)
	ld.w	$r5, $r5, 0
	bge	$r4, $r5, $BB1_2
# %bb.1:
	lu12i.w	$r4, %got_hi(g3)
	add.w	$r4, $r4, $r20
	ld.w	$r4, $r4, %got_lo(g3)
	ld.w	$r4, $r4, 0
	st.w	$r4, $r3, 12
	b	$BB1_3
$BB1_2:
	lu12i.w	$r4, %got_hi(g4)
	add.w	$r4, $r4, $r20
	ld.w	$r4, $r4, %got_lo(g4)
	ld.w	$r4, $r4, 0
	st.w	$r4, $r3, 12
$BB1_3:
	ld.w	$r4, $r3, 12
	addi.w	$r3, $r3, 16
	jr	$r1
$func_end1:
	.size	test_select_global, ($func_end1)-test_select_global
                                        # -- End function
	.type	g1,@object              # @g1
	.data
	.globl	g1
	.p2align	2
g1:
	.word	1                       # 0x1
	.size	g1, 4

	.type	g2,@object              # @g2
	.globl	g2
	.p2align	2
g2:
	.word	2                       # 0x2
	.size	g2, 4

	.type	g3,@object              # @g3
	.globl	g3
	.p2align	2
g3:
	.word	100                     # 0x64
	.size	g3, 4

	.type	g4,@object              # @g4
	.globl	g4
	.p2align	2
g4:
	.word	50                      # 0x32
	.size	g4, 4

	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
