	.text
	.section .mdebug.abi ilp32s
	.previous
	.file	"test.c"
	.globl	test_Float              # -- Begin function test_Float
	.p2align	3
	.type	test_Float,@function
	.ent	test_Float              # @test_Float
test_Float:
	lu12i.w	$r20, %hi(_gp_disp)
	ori	$r20, $r20, %lo(_gp_disp)
	add.w	$r20, $r20, $r19
# %bb.0:
	addi.w	$r3, $r3, -48
	st.w	$r1, $r3, 44            # 4-byte Folded Spill
	lu12i.w	$r4, 262758
	ori	$r4, $r4, 1638
	st.w	$r4, $r3, 40
	lu12i.w	$r4, 260096
	st.w	$r4, $r3, 36
	ld.w	$r4, $r3, 40
	ld.w	$r5, $r3, 36
	ld.w	$r19, $r20, %call16(__addsf3)
	jirl	$r1, $r19, 0
	st.w	$r4, $r3, 32
	ld.w	$r4, $r3, 32
	ld.w	$r19, $r20, %call16(__fixsfsi)
	jirl	$r1, $r19, 0
	ld.w	$r1, $r3, 44            # 4-byte Folded Reload
	addi.w	$r3, $r3, 48
	jr	$r1
$func_end0:
	.size	test_Float, ($func_end0)-test_Float
                                        # -- End function
	.globl	test_Double             # -- Begin function test_Double
	.p2align	3
	.type	test_Double,@function
	.ent	test_Double             # @test_Double
test_Double:
	lu12i.w	$r20, %hi(_gp_disp)
	ori	$r20, $r20, %lo(_gp_disp)
	add.w	$r20, $r20, $r19
# %bb.0:
	addi.w	$r3, $r3, -64
	st.w	$r1, $r3, 60            # 4-byte Folded Spill
	lu12i.w	$r4, 262220
	ori	$r4, $r4, 3276
	st.w	$r4, $r3, 52
	lu12i.w	$r4, 838860
	ori	$r4, $r4, 3277
	st.w	$r4, $r3, 48
	lu12i.w	$r4, 261888
	st.w	$r4, $r3, 44
	addi.w	$r4, $r0, 0
	st.w	$r4, $r3, 40
	ld.w	$r4, $r3, 48
	ld.w	$r5, $r3, 52
	ld.w	$r6, $r3, 40
	ld.w	$r7, $r3, 44
	ld.w	$r19, $r20, %call16(__adddf3)
	jirl	$r1, $r19, 0
	st.w	$r5, $r3, 36
	st.w	$r4, $r3, 32
	ld.w	$r4, $r3, 32
	ld.w	$r5, $r3, 36
	ld.w	$r1, $r3, 60            # 4-byte Folded Reload
	addi.w	$r3, $r3, 64
	jr	$r1
$func_end1:
	.size	test_Double, ($func_end1)-test_Double
                                        # -- End function
	.globl	test_sqrt               # -- Begin function test_sqrt
	.p2align	3
	.type	test_sqrt,@function
	.ent	test_sqrt               # @test_sqrt
test_sqrt:
	lu12i.w	$r20, %hi(_gp_disp)
	ori	$r20, $r20, %lo(_gp_disp)
	add.w	$r20, $r20, $r19
# %bb.0:
	addi.w	$r3, $r3, -48
	st.w	$r1, $r3, 44            # 4-byte Folded Spill
	ld.w	$r19, $r20, %call16(sqrt)
	addi.w	$r4, $r0, 0
	lu12i.w	$r5, 263200
	jirl	$r1, $r19, 0
	ld.w	$r19, $r20, %call16(__fixdfsi)
	jirl	$r1, $r19, 0
	st.w	$r4, $r3, 40
	ld.w	$r4, $r3, 40
	ld.w	$r1, $r3, 44            # 4-byte Folded Reload
	addi.w	$r3, $r3, 48
	jr	$r1
$func_end2:
	.size	test_sqrt, ($func_end2)-test_sqrt
                                        # -- End function
	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
