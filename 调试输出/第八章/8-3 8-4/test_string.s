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
	addi.w	$r3, $r3, -160
	st.w	$r1, $r3, 156           # 4-byte Folded Spill
	st.w	$r23, $r3, 152          # 4-byte Folded Spill
	addi.w	$r23, $r0, 0
	st.w	$r23, $r3, 148
	lu12i.w	$r4, %hi(.L__const.main.str_long)
	ori	$r5, $r4, %lo(.L__const.main.str_long)
	addi.w	$r4, $r3, 49
	addi.w	$r6, $r0, 99
	bl	memcpy
	lu12i.w	$r4, %hi(.L__const.main.str_short)
	ori	$r4, $r4, %lo(.L__const.main.str_short)
	ld.bu	$r5, $r4, 4
	ld.bu	$r6, $r4, 5
	slli.w	$r6, $r6, 8
	or	$r5, $r6, $r5
	st.h	$r5, $r3, 44
	ld.bu	$r5, $r4, 0
	ld.bu	$r6, $r4, 1
	slli.w	$r6, $r6, 8
	or	$r5, $r6, $r5
	ld.bu	$r6, $r4, 2
	ld.bu	$r4, $r4, 3
	slli.w	$r4, $r4, 8
	or	$r4, $r4, $r6
	slli.w	$r4, $r4, 16
	or	$r4, $r4, $r5
	st.w	$r4, $r3, 40
	ori	$r4, $r0, $r23
	ld.w	$r23, $r3, 152          # 4-byte Folded Reload
	ld.w	$r1, $r3, 156           # 4-byte Folded Reload
	addi.w	$r3, $r3, 160
	jr	$r1
$func_end0:
	.size	main, ($func_end0)-main
                                        # -- End function
	.type	.L__const.main.str_long,@object # @__const.main.str_long
	.section	.rodata,"a",@progbits
.L__const.main.str_long:
	.asciz	"Long long long string\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.size	.L__const.main.str_long, 99

	.type	.L__const.main.str_short,@object # @__const.main.str_short
	.section	.rodata.str1.1,"aMS",@progbits,1
.L__const.main.str_short:
	.asciz	"Hello"
	.size	.L__const.main.str_short, 6

	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
