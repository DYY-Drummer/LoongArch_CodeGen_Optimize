	.text
	.section .mdebug.abi ilp32s
	.previous
	.file	"test.ll"
	.globl	test_bool               # -- Begin function test_bool
	.p2align	3
	.type	test_bool,@function
	.ent	test_bool               # @test_bool
test_bool:
	.cfi_startproc
# %bb.0:                                # %entry
	addi.w	$r3, $r3, -16
	.cfi_def_cfa_offset 16
	addi.w	$r4, $r0, 1
	st.b	$r4, $r3, 15
	addi.w	$r3, $r3, 16
	jr	$r1
$func_end0:
	.size	test_bool, ($func_end0)-test_bool
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
