//===- LoongArchFloatInstrInfo.td - Target Description for LoongArch Target -*- tablegen -*-=//
//
// This file contains the LoongArch implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Instructions specific format
//===----------------------------------------------------------------------===//

// Arithmetic and logical instructions with 3 register operands
class FP_ALU_3R<bits<17> op, string instr_asm, SDNode OpNode,
        InstrItinClass itin, RegisterClass RC, bit isComm = 0>
: FPFmt3R<op, (outs FPGPR:$fd), (ins RC:$fj, RC:$fk),
!strconcat(instr_asm, "\t$fd, $fj, $fk"),
[(set FPGPR:$fd, (OpNode RC:$fj, RC:$fk))], itin> {

let isCommutable = isComm;
let isReMaterializable = 1;
}

// Arithmetic and logical instructions with 2 register operands
class FP_ALU_2R<bits<22> op, string instr_asm, SDNode OpNode,
        InstrItinClass itin, RegisterClass RC, bit isComm = 0>
: FPFmt2R<op, (outs FPGPR:$fd), (ins RC:$fj),
!strconcat(instr_asm, "\t$fd, $fj"),
[(set FPGPR:$fd, (OpNode RC:$fj))], itin> {

let isCommutable = isComm;
let isReMaterializable = 1;
}



//===----------------------------------------------------------------------===//
// Instruction definition
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Single precision float instruction
//===----------------------------------------------------------------------===//

/// Arithmetic Instructions (3-Operand, 3Register-Type)
def FADD_S    : FP_ALU_3R<0b00000001000000001, "fadd.s", fadd, IIAlu, FPGPR, 1>;
def FSUB_S    : FP_ALU_3R<0b00000001000000101, "fsub.s", fsub, IIAlu, FPGPR, 1>;
def FMUL_S    : FP_ALU_3R<0b00000001000001001, "fmul.s", fmul, IIAlu, FPGPR, 1>;
def FDIV_S    : FP_ALU_3R<0b00000001000001101, "fdiv.s", fdiv, IIAlu, FPGPR, 1>;

/// Arithmetic Instructions (2-Operand, 2Register-Type)



//===----------------------------------------------------------------------===//
// Double precision float instruction
//===----------------------------------------------------------------------===//
/// Arithmetic Instructions (3-Operand, 3Register-Type)
def FADD_D    : FP_ALU_3R<0b00000001000000010, "fadd.d", fadd, IIAlu, FPGPR, 1>;
def FSUB_D    : FP_ALU_3R<0b00000001000000110, "fsub.d", fsub, IIAlu, FPGPR, 1>;
def FMUL_D    : FP_ALU_3R<0b00000001000001010, "fmul.d", fmul, IIAlu, FPGPR, 1>;
def FDIV_D    : FP_ALU_3R<0b00000001000001110, "fdiv.d", fdiv, IIAlu, FPGPR, 1>;