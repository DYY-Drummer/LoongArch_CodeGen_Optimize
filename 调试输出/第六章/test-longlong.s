	.text
	.section .mdebug.abi ilp32s
	.previous
	.file	"test.c"
	.globl	test_longlong           # -- Begin function test_longlong
	.p2align	3
	.type	test_longlong,@function
	.ent	test_longlong           # @test_longlong
test_longlong:
# %bb.0:
	addi.w	$r3, $r3, -48
	addi.w	$r4, $r0, 3
	st.w	$r4, $r3, 44
	addi.w	$r4, $r0, 2
	st.w	$r4, $r3, 40
	addi.w	$r4, $r0, 1
	st.w	$r4, $r3, 36
	st.w	$r4, $r3, 32
	ld.w	$r4, $r3, 40
	ld.w	$r5, $r3, 44
	ld.w	$r6, $r3, 32
	ld.w	$r7, $r3, 36
	add.w	$r5, $r5, $r7
	add.w	$r6, $r4, $r6
	sltu	$r4, $r6, $r4
	add.w	$r4, $r5, $r4
	st.w	$r6, $r3, 24
	st.w	$r4, $r3, 28
	ld.w	$r4, $r3, 44
	ld.w	$r5, $r3, 40
	ld.w	$r6, $r3, 32
	ld.w	$r7, $r3, 36
	mul.w	$r7, $r5, $r7
	mulh.wu	$r8, $r5, $r6
	add.w	$r7, $r8, $r7
	mul.w	$r4, $r4, $r6
	add.w	$r4, $r7, $r4
	mul.w	$r5, $r5, $r6
	st.w	$r5, $r3, 16
	st.w	$r4, $r3, 20
	addi.w	$r4, $r0, -1
	st.w	$r4, $r3, 12
	addi.w	$r4, $r0, -4
	st.w	$r4, $r3, 8
	ld.w	$r4, $r3, 24
	ld.w	$r5, $r3, 28
	ld.w	$r6, $r3, 16
	ld.w	$r7, $r3, 20
	add.w	$r5, $r5, $r7
	add.w	$r6, $r4, $r6
	sltu	$r4, $r6, $r4
	add.w	$r5, $r5, $r4
	ld.w	$r7, $r3, 12
	ld.w	$r4, $r3, 8
	add.w	$r4, $r6, $r4
	sltu	$r6, $r4, $r6
	add.w	$r5, $r5, $r7
	add.w	$r5, $r5, $r6
	addi.w	$r3, $r3, 48
	jr	$r1
$func_end0:
	.size	test_longlong, ($func_end0)-test_longlong
                                        # -- End function
	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
