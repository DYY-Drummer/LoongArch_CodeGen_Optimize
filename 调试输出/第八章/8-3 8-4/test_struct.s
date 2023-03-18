	.text
	.section .mdebug.abi ilp32s
	.previous
	.file	"test_struct.cpp"
	.globl	_Z7getDatev             # -- Begin function _Z7getDatev
	.p2align	3
	.type	_Z7getDatev,@function
	.ent	_Z7getDatev             # @_Z7getDatev
_Z7getDatev:
# %bb.0:
	lu12i.w	$r5, %hi(today)
	ori	$r5, $r5, %lo(today)
	ld.w	$r6, $r5, 8
	st.w	$r6, $r4, 8
	ld.w	$r6, $r5, 4
	st.w	$r6, $r4, 4
	ld.w	$r5, $r5, 0
	st.w	$r5, $r4, 0
	jr	$r1
$func_end0:
	.size	_Z7getDatev, ($func_end0)-_Z7getDatev
                                        # -- End function
	.globl	_Z14copyDate_byVal4Date # -- Begin function _Z14copyDate_byVal4Date
	.p2align	3
	.type	_Z14copyDate_byVal4Date,@function
	.ent	_Z14copyDate_byVal4Date # @_Z14copyDate_byVal4Date
_Z14copyDate_byVal4Date:
# %bb.0:
	addi.w	$r3, $r3, -16
	st.w	$r5, $r3, 0
	st.w	$r6, $r3, 4
	st.w	$r7, $r3, 8
	ld.w	$r5, $r3, 8
	st.w	$r5, $r4, 8
	ld.w	$r5, $r3, 4
	st.w	$r5, $r4, 4
	ld.w	$r5, $r3, 0
	st.w	$r5, $r4, 0
	addi.w	$r3, $r3, 16
	jr	$r1
$func_end1:
	.size	_Z14copyDate_byVal4Date, ($func_end1)-_Z14copyDate_byVal4Date
                                        # -- End function
	.globl	_Z18copyDate_byPointerP4Date # -- Begin function _Z18copyDate_byPointerP4Date
	.p2align	3
	.type	_Z18copyDate_byPointerP4Date,@function
	.ent	_Z18copyDate_byPointerP4Date # @_Z18copyDate_byPointerP4Date
_Z18copyDate_byPointerP4Date:
# %bb.0:
	addi.w	$r3, $r3, -16
	st.w	$r5, $r3, 12
	ld.w	$r5, $r3, 12
	ld.w	$r6, $r5, 8
	st.w	$r6, $r4, 8
	ld.w	$r6, $r5, 4
	st.w	$r6, $r4, 4
	ld.w	$r5, $r5, 0
	st.w	$r5, $r4, 0
	addi.w	$r3, $r3, 16
	jr	$r1
$func_end2:
	.size	_Z18copyDate_byPointerP4Date, ($func_end2)-_Z18copyDate_byPointerP4Date
                                        # -- End function
	.globl	_Z11test_structv        # -- Begin function _Z11test_structv
	.p2align	3
	.type	_Z11test_structv,@function
	.ent	_Z11test_structv        # @_Z11test_structv
_Z11test_structv:
# %bb.0:
	addi.w	$r3, $r3, -112
	st.w	$r1, $r3, 108           # 4-byte Folded Spill
	st.w	$r23, $r3, 104          # 4-byte Folded Spill
	addi.w	$r23, $r3, 88
	ori	$r4, $r0, $r23
	bl	_Z7getDatev
	ld.w	$r4, $r3, 96
	st.w	$r4, $r3, 64
	ld.w	$r4, $r3, 92
	st.w	$r4, $r3, 60
	ld.w	$r4, $r3, 88
	st.w	$r4, $r3, 56
	ld.w	$r5, $r3, 56
	ld.w	$r6, $r3, 60
	ld.w	$r7, $r3, 64
	addi.w	$r4, $r3, 72
	bl	_Z14copyDate_byVal4Date
	addi.w	$r4, $r3, 40
	ori	$r5, $r0, $r23
	bl	_Z18copyDate_byPointerP4Date
	ld.w	$r4, $r3, 88
	addi.w	$r5, $r0, 2023
	bne	$r4, $r5, $BB3_3
# %bb.1:
	ld.w	$r4, $r3, 92
	addi.w	$r5, $r0, 3
	bne	$r4, $r5, $BB3_3
# %bb.2:
	ld.w	$r4, $r3, 96
	addi.w	$r5, $r0, 18
	beq	$r4, $r5, $BB3_4
$BB3_3:
	addi.w	$r4, $r0, 1
	st.w	$r4, $r3, 100
	b	$BB3_9
$BB3_4:
	ld.w	$r4, $r3, 72
	addi.w	$r5, $r0, 2023
	bne	$r4, $r5, $BB3_7
# %bb.5:
	ld.w	$r4, $r3, 76
	addi.w	$r5, $r0, 3
	bne	$r4, $r5, $BB3_7
# %bb.6:
	ld.w	$r4, $r3, 80
	addi.w	$r5, $r0, 18
	beq	$r4, $r5, $BB3_8
$BB3_7:
	addi.w	$r4, $r0, 1
	st.w	$r4, $r3, 100
	b	$BB3_9
$BB3_8:
	addi.w	$r4, $r0, 0
	st.w	$r4, $r3, 100
$BB3_9:
	ld.w	$r4, $r3, 100
	ld.w	$r23, $r3, 104          # 4-byte Folded Reload
	ld.w	$r1, $r3, 108           # 4-byte Folded Reload
	addi.w	$r3, $r3, 112
	jr	$r1
$func_end3:
	.size	_Z11test_structv, ($func_end3)-_Z11test_structv
                                        # -- End function
	.type	today,@object           # @today
	.data
	.globl	today
	.p2align	2
today:
	.word	2023                    # 0x7e7
	.word	3                       # 0x3
	.word	18                      # 0x12
	.size	today, 12

	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
