	.text
	.section .mdebug.abi ilp32s
	.previous
	.file	"test.c"
	.globl	test_struct_array       # -- Begin function test_struct_array
	.p2align	3
	.type	test_struct_array,@function
	.ent	test_struct_array       # @test_struct_array
test_struct_array:
	lu12i.w	$r20, %hi(_gp_disp)
	ori	$r20, $r20, %lo(_gp_disp)
	add.w	$r20, $r20, $r19
# %bb.0:
	addi.w	$r3, $r3, -32
	ld.w	$r4, $r20, %got(.L__const.test_struct_array.a)
	ori	$r4, $r4, %lo(.L__const.test_struct_array.a)
	ld.w	$r5, $r4, 8
	st.w	$r5, $r3, 28
	ld.w	$r5, $r4, 4
	st.w	$r5, $r3, 24
	ld.w	$r4, $r4, 0
	st.w	$r4, $r3, 20
	lu12i.w	$r4, %got_hi(date)
	add.w	$r4, $r4, $r20
	ld.w	$r4, $r4, %got_lo(date)
	ld.w	$r4, $r4, 8
	st.w	$r4, $r3, 16
	ld.w	$r4, $r3, 24
	st.w	$r4, $r3, 12
	ld.w	$r4, $r3, 12
	ld.w	$r5, $r3, 16
	add.w	$r4, $r4, $r5
	addi.w	$r3, $r3, 32
	jr	$r1
$func_end0:
	.size	test_struct_array, ($func_end0)-test_struct_array
                                        # -- End function
	.type	date,@object            # @date
	.data
	.globl	date
	.p2align	2
date:
	.word	2023                    # 0x7e7
	.word	3                       # 0x3
	.word	8                       # 0x8
	.size	date, 12

	.type	.L__const.test_struct_array.a,@object # @__const.test_struct_array.a
	.section	.rodata,"a",@progbits
	.p2align	2
.L__const.test_struct_array.a:
	.word	2023                    # 0x7e7
	.word	3                       # 0x3
	.word	8                       # 0x8
	.size	.L__const.test_struct_array.a, 12

	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
