	.text
	.section .mdebug.abi ilp32s
	.previous
	.file	"test.c"
	.globl	main                    # -- Begin function main
	.p2align	3
	.type	main,@function
	.ent	main                    # @main
main:
# %bb.0:
	addi.w	$r3, $r3, -16
	addi.w	$r4, $r0, 0
	st.w	$r4, $r3, 12
	addi.w	$r4, $r0, 6
	st.w	$r4, $r3, 8
	addi.w	$r4, $r0, 2
	st.w	$r4, $r3, 4
	ld.w	$r4, $r3, 8
	ld.w	$r5, $r3, 4
	add.w	$r4, $r4, $r5
	addi.w	$r3, $r3, 16
	jr	$r1
$func_end0:
	.size	main, ($func_end0)-main
                                        # -- End function
	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
