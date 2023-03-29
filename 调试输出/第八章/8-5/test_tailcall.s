	.text
	.section .mdebug.abi ilp32s
	.previous
	.file	"test.c"
	.globl	func_b                  # -- Begin function func_b
	.p2align	3
	.type	func_b,@function
	.ent	func_b                  # @func_b
func_b:
# %bb.0:
	addi.w	$r3, $r3, -48
	st.w	$r1, $r3, 44            # 4-byte Folded Spill
	st.w	$r23, $r3, 40           # 4-byte Folded Spill
	addi.w	$r23, $r4, 1
	addi.w	$r4, $r4, -1
	bl	flop
	mul.w	$r4, $r4, $r23
	ld.w	$r23, $r3, 40           # 4-byte Folded Reload
	ld.w	$r1, $r3, 44            # 4-byte Folded Reload
	addi.w	$r3, $r3, 48
	jr	$r1
$func_end0:
	.size	func_b, ($func_end0)-func_b
                                        # -- End function
	.globl	func_a                  # -- Begin function func_a
	.p2align	3
	.type	func_a,@function
	.ent	func_a                  # @func_a
func_a:
# %bb.0:
	addi.w	$r3, $r3, -48
	st.w	$r1, $r3, 44            # 4-byte Folded Spill
	st.w	$r23, $r3, 40           # 4-byte Folded Spill
	ori	$r23, $r0, $r4
	addi.w	$r4, $r23, -1
	bl	flip
	mul.w	$r4, $r4, $r23
	ld.w	$r23, $r3, 40           # 4-byte Folded Reload
	ld.w	$r1, $r3, 44            # 4-byte Folded Reload
	addi.w	$r3, $r3, 48
	jr	$r1
$func_end1:
	.size	func_a, ($func_end1)-func_a
                                        # -- End function
	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
