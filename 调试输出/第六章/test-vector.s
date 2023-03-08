	.text
	.section .mdebug.abi ilp32s
	.previous
	.file	"test.c"
	.globl	test_vector             # -- Begin function test_vector
	.p2align	3
	.type	test_vector,@function
	.ent	test_vector             # @test_vector
test_vector:
# %bb.0:
	addi.w	$r3, $r3, -128
	st.w	$r23, $r3, 124          # 4-byte Folded Spill
	addi.w	$r4, $r0, 0
	st.w	$r4, $r3, 92
	st.w	$r4, $r3, 88
	st.w	$r4, $r3, 84
	st.w	$r4, $r3, 80
	addi.w	$r5, $r0, 1
	st.w	$r5, $r3, 76
	st.w	$r5, $r3, 72
	st.w	$r5, $r3, 68
	st.w	$r5, $r3, 64
	st.w	$r5, $r3, 60
	st.w	$r5, $r3, 56
	st.w	$r5, $r3, 52
	st.w	$r5, $r3, 48
	st.w	$r4, $r3, 44
	st.w	$r4, $r3, 40
	st.w	$r4, $r3, 36
	st.w	$r4, $r3, 32
	ld.w	$r5, $r3, 92
	ld.w	$r6, $r3, 88
	ld.w	$r7, $r3, 84
	ld.w	$r8, $r3, 80
	ld.w	$r9, $r3, 76
	ld.w	$r10, $r3, 72
	ld.w	$r11, $r3, 68
	ld.w	$r12, $r3, 64
	ld.w	$r13, $r3, 60
	ld.w	$r14, $r3, 56
	ld.w	$r15, $r3, 52
	ld.w	$r16, $r3, 48
	ld.w	$r17, $r3, 44
	ld.w	$r18, $r3, 40
	ld.w	$r19, $r3, 36
	ld.w	$r23, $r3, 32
	slt	$r12, $r12, $r23
	sub.w	$r12, $r4, $r12
	slt	$r11, $r11, $r19
	sub.w	$r11, $r4, $r11
	slt	$r10, $r10, $r18
	sub.w	$r10, $r4, $r10
	slt	$r9, $r9, $r17
	sub.w	$r9, $r4, $r9
	slt	$r8, $r8, $r16
	sub.w	$r8, $r4, $r8
	slt	$r7, $r7, $r15
	sub.w	$r7, $r4, $r7
	slt	$r6, $r6, $r14
	sub.w	$r6, $r4, $r6
	slt	$r5, $r5, $r13
	sub.w	$r4, $r4, $r5
	st.w	$r4, $r3, 28
	st.w	$r6, $r3, 24
	st.w	$r7, $r3, 20
	st.w	$r8, $r3, 16
	st.w	$r9, $r3, 12
	st.w	$r10, $r3, 8
	st.w	$r11, $r3, 4
	st.w	$r12, $r3, 0
	ld.w	$r4, $r3, 28
	ld.w	$r4, $r3, 24
	ld.w	$r4, $r3, 20
	ld.w	$r4, $r3, 16
	ld.w	$r4, $r3, 12
	ld.w	$r4, $r3, 8
	ld.w	$r4, $r3, 4
	ld.w	$r4, $r3, 0
	ld.w	$r5, $r3, 28
	ld.w	$r5, $r3, 24
	ld.w	$r5, $r3, 20
	ld.w	$r5, $r3, 16
	ld.w	$r5, $r3, 12
	ld.w	$r5, $r3, 8
	ld.w	$r5, $r3, 0
	ld.w	$r5, $r3, 4
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 28
	ld.w	$r5, $r3, 24
	ld.w	$r5, $r3, 20
	ld.w	$r5, $r3, 16
	ld.w	$r5, $r3, 12
	ld.w	$r5, $r3, 4
	ld.w	$r5, $r3, 0
	ld.w	$r5, $r3, 8
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 28
	ld.w	$r5, $r3, 24
	ld.w	$r5, $r3, 20
	ld.w	$r5, $r3, 16
	ld.w	$r5, $r3, 8
	ld.w	$r5, $r3, 4
	ld.w	$r5, $r3, 0
	ld.w	$r5, $r3, 12
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 28
	ld.w	$r5, $r3, 24
	ld.w	$r5, $r3, 20
	ld.w	$r5, $r3, 12
	ld.w	$r5, $r3, 8
	ld.w	$r5, $r3, 4
	ld.w	$r5, $r3, 0
	ld.w	$r5, $r3, 16
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 28
	ld.w	$r5, $r3, 24
	ld.w	$r5, $r3, 16
	ld.w	$r5, $r3, 12
	ld.w	$r5, $r3, 8
	ld.w	$r5, $r3, 4
	ld.w	$r5, $r3, 0
	ld.w	$r5, $r3, 20
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 28
	ld.w	$r5, $r3, 20
	ld.w	$r5, $r3, 16
	ld.w	$r5, $r3, 12
	ld.w	$r5, $r3, 8
	ld.w	$r5, $r3, 4
	ld.w	$r5, $r3, 0
	ld.w	$r5, $r3, 24
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 24
	ld.w	$r5, $r3, 20
	ld.w	$r5, $r3, 16
	ld.w	$r5, $r3, 12
	ld.w	$r5, $r3, 8
	ld.w	$r5, $r3, 4
	ld.w	$r5, $r3, 0
	ld.w	$r5, $r3, 28
	add.w	$r4, $r4, $r5
	ld.w	$r23, $r3, 124          # 4-byte Folded Reload
	addi.w	$r3, $r3, 128
	jr	$r1
$func_end0:
	.size	test_vector, ($func_end0)-test_vector
                                        # -- End function
	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
