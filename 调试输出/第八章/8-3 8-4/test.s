	.text
	.section .mdebug.abi ilp32s
	.previous
	.file	"test.c"
	.globl	sum                     # -- Begin function sum
	.p2align	3
	.type	sum,@function
	.ent	sum                     # @sum
sum:
# %bb.0:
	addi.w	$r3, $r3, -48
	st.w	$r4, $r3, 44
	st.w	$r5, $r3, 40
	st.w	$r6, $r3, 36
	st.w	$r7, $r3, 32
	st.w	$r8, $r3, 28
	st.w	$r9, $r3, 24
	st.w	$r10, $r3, 20
	st.w	$r11, $r3, 16
	ld.w	$r4, $r3, 44
	ld.w	$r5, $r3, 40
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 36
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 32
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 28
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 24
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 20
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 16
	add.w	$r4, $r4, $r5
	ld.w	$r5, $r3, 80
	add.w	$r4, $r4, $r5
	st.w	$r4, $r3, 12
	ld.w	$r4, $r3, 12
	addi.w	$r3, $r3, 48
	jr	$r1
$func_end0:
	.size	sum, ($func_end0)-sum
                                        # -- End function
	.globl	sub                     # -- Begin function sub
	.p2align	3
	.type	sub,@function
	.ent	sub                     # @sub
sub:
# %bb.0:
	addi.w	$r3, $r3, -16
	st.w	$r4, $r3, 12
	st.w	$r5, $r3, 8
	ld.w	$r4, $r3, 12
	ld.w	$r5, $r3, 8
	sub.w	$r4, $r4, $r5
	st.w	$r4, $r3, 4
	ld.w	$r4, $r3, 4
	addi.w	$r3, $r3, 16
	jr	$r1
$func_end1:
	.size	sub, ($func_end1)-sub
                                        # -- End function
	.globl	main                    # -- Begin function main
	.p2align	3
	.type	main,@function
	.ent	main                    # @main
main:
	lu12i.w	$r20, %hi(_gp_disp)
	ori	$r20, $r20, %lo(_gp_disp)
	add.w	$r20, $r20, $r19
# %bb.0:
	addi.w	$r3, $r3, -80
	st.w	$r1, $r3, 76            # 4-byte Folded Spill
	st.w	$r23, $r3, 72           # 4-byte Folded Spill
	st.w	$r24, $r3, 68           # 4-byte Folded Spill
	addi.w	$r4, $r0, 0
	st.w	$r4, $r3, 64
	addi.w	$r4, $r0, 9
	st.w	$r4, $r3, 32
	ld.w	$r19, $r20, %call16(sum)
	addi.w	$r23, $r0, 1
	addi.w	$r24, $r0, 2
	addi.w	$r6, $r0, 3
	addi.w	$r7, $r0, 4
	addi.w	$r8, $r0, 5
	addi.w	$r9, $r0, 6
	addi.w	$r10, $r0, 7
	addi.w	$r11, $r0, 8
	ori	$r4, $r0, $r23
	ori	$r5, $r0, $r24
	jirl	$r1, $r19, 0
	st.w	$r4, $r3, 60
	ld.w	$r19, $r20, %call16(sub)
	ori	$r4, $r0, $r23
	ori	$r5, $r0, $r24
	jirl	$r1, $r19, 0
	st.w	$r4, $r3, 56
	ld.w	$r4, $r3, 60
	ld.w	$r5, $r3, 56
	add.w	$r4, $r4, $r5
	ld.w	$r24, $r3, 68           # 4-byte Folded Reload
	ld.w	$r23, $r3, 72           # 4-byte Folded Reload
	ld.w	$r1, $r3, 76            # 4-byte Folded Reload
	addi.w	$r3, $r3, 80
	jr	$r1
$func_end2:
	.size	main, ($func_end2)-main
                                        # -- End function
	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
