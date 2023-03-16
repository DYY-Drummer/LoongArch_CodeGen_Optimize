//===- LoongArchInstrInfo.td - Target Description for LoongArch Target -*- tablegen -*-=//
//
// This file contains the LoongArch implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// LoongArch profiles and nodes
//===----------------------------------------------------------------------===//

//class SDTypeProfile<int numresults, int numoperands, list<SDTypeConstraint> constraints>
def SDT_LoongArchRet          : SDTypeProfile<1, 2, [SDTCisInt<0>]>;


// Hi and Lo nodes are used to handle global addresses. Used on
// LoongArchISelLowering to lower stuff like GlobalAddress, ExternalSymbol
// static model.
def LoongArchHi    : SDNode<"LoongArchISD::Hi", SDTIntUnaryOp>;
def LoongArchLo    : SDNode<"LoongArchISD::Lo", SDTIntUnaryOp>;
def LoongArchGPRel : SDNode<"LoongArchISD::GPRel", SDTIntUnaryOp>;

// Return
def LoongArchRet : SDNode<"LoongArchISD::Ret", SDTNone,
                     [SDNPHasChain, SDNPOptInGlue, SDNPVariadic]>;

def LoongArchWrapper : SDNode<"LoongArchISD::Wrapper", SDTIntBinOp>;

//===----------------------------------------------------------------------===//
// LoongArch Instruction Predicate Definitions.
//===----------------------------------------------------------------------===//
def EnableOverflow  : Predicate<"Subtarget->enableOverflow()">;
def DisableOverflow : Predicate<"Subtarget->disableOverflow()">;

def HasSlt          : Predicate<"Subtarget->hasSlt()">;

def RelocPIC        : Predicate<"TM.getRelocationModel() == Reloc::PIC_">;
//===----------------------------------------------------------------------===//
// Instruction format superclass
//===----------------------------------------------------------------------===//

include "LoongArchInstrFormats.td"
include "LoongArchFloatInstrFormats.td"


//===----------------------------------------------------------------------===//
// Floating Point Instruction
//===----------------------------------------------------------------------===//

include "LoongArchFloatInstrInfo.td"

//===----------------------------------------------------------------------===//
// Integer Instruction
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// LoongArch Operand, Complex Patterns and Transformations Definitions.
//===----------------------------------------------------------------------===//

// Instruction operand types

class LoongArchInstAlias<string Asm, dag Result, bit Emit = 0b1> :
InstAlias<Asm, Result, Emit>;

// B Series jump control, e.g. BEQ, BNE
def brtarget16    : Operand<OtherVT> {
let EncoderMethod = "getBranch16TargetOpValue";
let OperandType = "OPERAND_PCREL";
let DecoderMethod = "DecodeBranch16Target";
}

// jump target for Unconditional jump - B
def jmptarget    : Operand<OtherVT> {
let EncoderMethod = "getJumpTargetOpValue";
let OperandType = "OPERAND_PCREL";
}

// Signed Operand
def simm20      : Operand<i32> {
let DecoderMethod= "DecodeSimm20";
}
def simm16      : Operand<i32> {
  let DecoderMethod= "DecodeSimm16";
}
def simm12      : Operand<i32> {
let DecoderMethod= "DecodeSimm12";
}
//unsigned Operand
def uimm20 : Operand<i32> {
let PrintMethod = "printUnsignedImm";
}
def uimm16 : Operand<i32> {
let PrintMethod = "printUnsignedImm";
}
def uimm12 : Operand<i32> {
let PrintMethod = "printUnsignedImm";
}



def shamt  : Operand<i32>;

// Address operand
def mem : Operand<iPTR> {
  let PrintMethod = "printMemOperand";
  let MIOperandInfo = (ops GPR, simm12);
  let EncoderMethod = "getMemEncoding";
}

def mem_ea : Operand<iPTR> {
let PrintMethod = "printMemOperandEA";
let MIOperandInfo = (ops GPR, simm12);
let EncoderMethod = "getMemEncoding";
}

// Return an immediate subtracted from 32.
def ImmSubFrom32 : SDNodeXForm<imm, [{
return CurDAG->getTargetConstant(32 - N->getZExtValue(), SDLoc(N),
        N->getValueType(0));
}]>;

// Node immediate fits as N-bit sign extended on target immediate.
// e.g. addi.w
def immSExt16  : PatLeaf<(imm), [{ return isInt<16>(N->getSExtValue()); }]>;
def immSExt12  : PatLeaf<(imm), [{ return isInt<12>(N->getSExtValue()); }]>;

// Transformation Function: get the lower 12 bits.
def LO12 : SDNodeXForm<imm, [{
return getImm(N, N->getZExtValue() & 0xfff);
}]>;

// Transformation Function: get the higher 20 bits.
def HI20 : SDNodeXForm<imm, [{
return getImm(N, (N->getZExtValue() >> 12) & 0xfffff);
}]>;

// Node immdiate fits as 12-bit zero extended on target immediate.
// The LO12 param means that only the lower 12 bits of the node
// immediate are caught.
// e.g. addi.w
def immZExt12 : PatLeaf<(imm), [{
if (N->getValueType(0) == MVT::i32)
    return (uint32_t)N->getZExtValue() == (unsigned short)N->getZExtValue();
else
    return (uint64_t)N->getZExtValue() == (unsigned short)N->getZExtValue();
}], LO12>;

// Immediate can be loaded with LU12I.W (32-bit int with lower 12-bit cleared).
def immLow12Zero : PatLeaf<(imm), [{
int64_t Val = N->getSExtValue();
return isInt<32>(Val) && !(Val & 0xfff);
}]>;

// shamt field must fit in 5 bits, e.g. SLLI.W.
def immZExt5 : ImmLeaf<i32, [{ return Imm == (Imm & 0x1f); }]>;

// LoongArch Address Mode! SDNode frameindex could possibily be a match
// since load and store instructions from stack used it.
def addr : 
  ComplexPattern<iPTR, 2, "SelectAddr", [frameindex], [SDNPWantParent]>;


//===----------------------------------------------------------------------===//
// Pattern fragment for load/store
//===----------------------------------------------------------------------===//

class AlignedLoad<PatFrag Node> :
  PatFrag<(ops node:$ptr), (Node node:$ptr), [{
  LoadSDNode *LD = cast<LoadSDNode>(N);
  return LD->getMemoryVT().getSizeInBits()/8 <= LD->getAlignment();
}]>;

class AlignedStore<PatFrag Node> :
  PatFrag<(ops node:$val, node:$ptr), (Node node:$val, node:$ptr), [{
  StoreSDNode *SD = cast<StoreSDNode>(N);
  return SD->getMemoryVT().getSizeInBits()/8 <= SD->getAlignment();
}]>;

// Load/Store PatFrags.
def load_a          : AlignedLoad<load>;
def store_a         : AlignedStore<store>;
//short int
def sextloadi16_a   : AlignedLoad<sextloadi16>;
def zextloadi16_a   : AlignedLoad<zextloadi16>;
def extloadi16_a    : AlignedLoad<extloadi16>;
def truncstorei16_a : AlignedStore<truncstorei16>;
//===----------------------------------------------------------------------===//
// Instructions specific format
//===----------------------------------------------------------------------===//

// Arithmetic and logical instructions with 3 register operands
class ALU_3R<bits<17> op, string instr_asm, SDNode OpNode,
        InstrItinClass itin, RegisterClass RC, bit isComm = 0>
: Fmt3R<op, (outs GPROut:$rd), (ins RC:$rj, RC:$rk),
!strconcat(instr_asm, "\t$rd, $rj, $rk"),
[(set GPROut:$rd, (OpNode RC:$rj, RC:$rk))], itin> {

let isCommutable = isComm;
let isReMaterializable = 1;
}

// Arithmetic and logical instructions with 2 register operands.

class ALU_2RI12<bits<10> op, string instr_asm, SDNode OpNode,
                  Operand Od, PatLeaf imm_type, RegisterClass RC> :
    Fmt2RI12<op, (outs GPROut:$rd), (ins RC:$rj, Od:$imm12),
     !strconcat(instr_asm, "\t$rd, $rj, $imm12"),
     [(set GPROut:$rd, (OpNode RC:$rj, imm_type:$imm12))], IIAlu> {
  let isReMaterializable = 1;
}

//  Logical
class LogicNOR<bits<17> op, string instr_asm, RegisterClass RC>:
Fmt3R<op, (outs RC:$rd), (ins RC:$rj, RC:$rk),
!strconcat(instr_asm, "\t$rd, $rj, $rk"),
[(set RC:$rd, (not (or RC:$rj, RC:$rk)))], IIAlu> {
let isCommutable = 1;
}

// Shifts
// Shifts with immediate value
class shift_rotate_imm<bits<17> op, bits<4> isRotate, string instr_asm,
        SDNode OpNode, PatFrag PF, Operand ImmOperand,
RegisterClass RC>:
Fmt2RI5<op, (outs GPROut:$rd), (ins RC:$rj, ImmOperand:$imm5),
!strconcat(instr_asm, "\t$rd, $rj, $imm5"),
[(set GPROut:$rd, (OpNode RC:$rj, PF:$imm5))], IIAlu> {

}
// 32-bit shift instructions.
class shift_rotate_imm32<bits<17> op, bits<4> isRotate, string instr_asm,
        SDNode OpNode>:
shift_rotate_imm<op, isRotate, instr_asm, OpNode, immZExt5, shamt, GPR>;

// Shifts with register
class shift_rotate_reg<bits<17> op, bits<4> isRotate, string instrAsm,
        SDNode opNode, RegisterClass RC>
: Fmt3R<op, (outs GPROut:$rd), (ins RC:$rj, RC:$rk),
!strconcat(instrAsm, "\t$rd, $rj, $rk"),
[(set GPROut:$rd, (opNode RC:$rj, RC:$rk))], IIAlu> {

}


// Load Upper 20-bit Immediate
class LoadUpper<bits<7> op, string instrAsm, RegisterClass RC, Operand Imm>
: Fmt1RI20<op, (outs RC:$rd), (ins Imm:$imm20),
!strconcat(instrAsm, "\t$rd, $imm20"), [], IIAlu> {
let isReMaterializable = 1;
}

//Memory operation base class
class FMem<bits<10> op, dag outs, dag ins, string asmstr, list<dag> pattern,
          InstrItinClass itin>: Fmt2RI12<op, outs, ins, asmstr, pattern, itin> {
  bits<17> addr; //addr include 5-bit rj and 12-bit simm
  let Inst{9-5} = addr{16-12};   //rj
  let Inst{21-10}  = addr{11-0}; //I12
  let DecoderMethod = "DecodeMem";
}

// Memory Load/Store
let canFoldAsLoad = 1 in
class LOAD_2RI12<bits<10> op, string instr_asm, PatFrag OpNode, RegisterClass RC,
                 Operand MemOpnd, bit Pseudo>:
    FMem<op, (outs RC:$rd), (ins MemOpnd:$addr),
        !strconcat(instr_asm, "\t$rd, $addr"),
        [(set RC:$rd, (OpNode addr:$addr))], IILoad>{
    let isPseudo = Pseudo;
}


class STORE_2RI12<bits<10> op, string instr_asm, PatFrag OpNode, RegisterClass RC,
             Operand MemOpnd, bit Pseudo>:
  FMem<op, (outs), (ins RC:$rd, MemOpnd:$addr),
     !strconcat(instr_asm, "\t$rd, $addr"),
     [(OpNode RC:$rd, addr:$addr)], IIStore> {
  let isPseudo = Pseudo;
}

//@ 32-bit load.
class LoadM32<bits<10> op, string instr_asm, PatFrag OpNode,
                   bit Pseudo = 0>
  : LOAD_2RI12<op, instr_asm, OpNode, GPROut, mem, Pseudo> {
}

// 32-bit store.
class StoreM32<bits<10> op, string instr_asm, PatFrag OpNode,
                    bit Pseudo = 0>
  : STORE_2RI12<op, instr_asm, OpNode, GPROut, mem, Pseudo> {
}

/// Conditional Branch, e.g. BEQ $r1, $r2, brtarget16
// Note: the order of rj and rd here is different from other instructions.
class CBranch16<bits<6> op, string instr_asm, PatFrag cond_op, RegisterClass RC>:
Fmt2RI16<op, (outs), (ins RC:$rj, RC:$rd, brtarget16:$imm16),
!strconcat(instr_asm, "\t$rj, $rd, $imm16"),
[(brcond (i32 (cond_op RC:$rj, RC:$rd)), bb:$imm16)], IIBranch>,
Requires<[HasSlt]> {
let isBranch = 1;
let isTerminator = 1;
let hasDelaySlot = 1;
let Defs = [R21];
}

/// SetCC
class SetCC_R<bits<17> op, string instr_asm, PatFrag cond_op,
        RegisterClass RC>:
Fmt3R<op, (outs GPROut:$rd), (ins RC:$rj, RC:$rk),
!strconcat(instr_asm, "\t$rd, $rj, $rk"),
[(set GPROut:$rd, (cond_op RC:$rj, RC:$rk))],
IIAlu>, Requires<[HasSlt]> {
}

class SetCC_I<bits<10> op, string instr_asm, PatFrag cond_op, Operand Od,
PatLeaf imm_type, RegisterClass RC>:
Fmt2RI12<op, (outs GPROut:$rd), (ins RC:$rj, Od:$imm12),
!strconcat(instr_asm, "\t$rd, $rj, $imm12"),
[(set GPROut:$rd, (cond_op RC:$rj, imm_type:$imm12))],
IIAlu>, Requires<[HasSlt]> {
}

//SExt and ZExt
class EXT<bits<22> op, string instr_asm, RegisterClass RC>:
Fmt2R<op, (outs GPROut:$rd), (ins RC:$rj),
!strconcat(instr_asm, "\t$rd, $rj"),
[], IIAlu> {
}

// Unconditional branch, B
class UncondBranch<bits<6> op, string instr_asm>:
FmtI26<op, (outs), (ins jmptarget:$addr),
!strconcat(instr_asm, "\t$addr"), [(br bb:$addr)], IIBranch> {
let isBranch = 1;
let isTerminator = 1;
let isBarrier = 1;
let hasDelaySlot = 0;
}

//@JumpFR {
let isBranch=1, isTerminator=1, isBarrier=1, imm16=0, hasDelaySlot = 1,
    isIndirectBranch = 1 in
class JumpFR<bits<6> op, string instr_asm, RegisterClass RC>:
    Fmt2RI16<op, (outs), (ins RC:$rj),
     !strconcat(instr_asm, "\t$rj"), [(brind RC:$rj)], IIBranch> {
  let rd = 0;
  let imm16 = 0;
}
//@JumpFR }


// Return
class RetBase<RegisterClass regClass> : JumpFR<0b010011, "jr", regClass> {
    let isReturn = 1;
    let isCodeGenOnly = 1;
    let hasCtrlDep = 1;
    let hasExtraSrcRegAllocReq = 1;
}

// Count Leading Ones/Zeros in Word
class CountLeading0<bits<22> op, string instr_asm, RegisterClass RC>:
Fmt2R<op, (outs GPROut:$rd), (ins RC:$rj),
!strconcat(instr_asm, "\t$rd, $rj"),
[(set GPROut:$rd, (ctlz RC:$rj))], II_CLZ> {

}
class CountLeading1<bits<22> op, string instr_asm, RegisterClass RC>:
Fmt2R<op, (outs GPROut:$rd), (ins RC:$rj),
!strconcat(instr_asm, "\t$rd, $rj"),
[(set GPROut:$rd, (ctlz (not RC:$rj)))], II_CLO> {

}

// Effective Address
class EffectiveAddress<string instrAsm, RegisterClass RC, Operand mem>
        : FMem<0b0000001010, (outs RC:$rd), (ins mem:$addr), instrAsm,
[(set RC:$rd, addr:$addr)], IIAlu>;

// Conditional moves: cond:int, data:int
// e.g. MASKEQZ, MASKNEZ
class CondMovIntInt<bits<17> op, string instr_asm,
        InstrItinClass itin, RegisterClass RC>
: Fmt3R<op, (outs GPROut:$rd), (ins RC:$rj, RC:$rk),
!strconcat(instr_asm, "\t$rd, $rj, $rk"), [], itin> {

}

//===----------------------------------------------------------------------===//
// Instruction definition
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// LoongArch Instructions
//===----------------------------------------------------------------------===//

/// Load and Store Instructions
///  aligned data
def LD_W     : LoadM32<0b0010100010,  "ld.w",  load_a>;  //load a sign-extended word from memory to $rd
def LD_H     : LoadM32<0b0010100001, "ld.h", sextloadi16_a>;//load a sign-extended half word from memory to $rd
def LD_HU    : LoadM32<0b0010101001, "ld.hu", zextloadi16_a>;//load a zero-extended half word from memory to $rd
def LD_B     : LoadM32<0b0010100000, "ld.b", sextloadi8>;//load a sign-extended byte from memory to $rd
def LD_BU    : LoadM32<0b0010101000, "ld.bu", zextloadi8>;//load a zero-extended byte from memory to $rd

def ST_W     : StoreM32<0b0010100110, "st.w",  store_a>; //store bit [31:0] of $rd to memory
def ST_H     : StoreM32<0b0010100101, "st.h", truncstorei16_a>;//store bit [15:0] of $rd to memory
def ST_B     : StoreM32<0b0010100100, "st.b", truncstorei8>;//store bit [7:0] of $rd to memory


/// Arithmetic Instructions (ALU Immediate)
// IR "add" defined in include/llvm/Target/TargetSelectionDAG.td, line 315 (def add).
def ADDI_W   : ALU_2RI12<0b0000001010, "addi.w", add, simm12, immSExt12, GPR>;
def ORI      : ALU_2RI12<0b0000001110, "ori", or, uimm12, immZExt12, GPR>;
def LU12I_W  : LoadUpper<0b0001010, "lu12i.w", GPROut, uimm20>;
def ANDI     : ALU_2RI12<0b0000001101, "andi", and, uimm12, immZExt12, GPR>;
def XORI     : ALU_2RI12<0b0000001111, "xori", xor, uimm12, immZExt12, GPR>;

/// Arithmetic Instructions (3-Operand, 3Register-Type)
let Predicates = [DisableOverflow] in {
def ADD_W    : ALU_3R<0b00000000000100000, "add.w", add, IIAlu, GPR, 1>;
def SUB_W    : ALU_3R<0b00000000000100010, "sub.w", sub, IIAlu, GPR>;
}
def AND     : ALU_3R<0b00000000000101001, "and", and, IIAlu, GPR, 1>;
def OR      : ALU_3R<0b00000000000101010, "or", or, IIAlu, GPR, 1>;
def XOR     : ALU_3R<0b00000000000101011, "xor", xor, IIAlu, GPR, 1>;
def NOR     : LogicNOR<0b00000000000101000, "nor", GPR>;

/// Multiply and Divide Instructions.
def MUL_W   : ALU_3R<0b00000000000111000, "mul.w", mul, IIImul, GPR, 1>;
def MULH_W   : ALU_3R<0b00000000000111001, "mulh.w", mulhs, IIImul, GPR, 1>;
def MULH_WU   : ALU_3R<0b00000000000111010, "mulh.wu", mulhu, IIImul, GPR, 1>;
def DIV_W   : ALU_3R<0b00000000001000000, "div.w", sdiv, IIIdiv, GPR, 1>;
def DIV_WU   : ALU_3R<0b00000000001000010, "div.wu", udiv, IIIdiv, GPR, 1>;
def MOD_W   : ALU_3R<0b00000000001000001, "mod.w", srem, IIImod, GPR, 1>;
def MOD_WU   : ALU_3R<0b00000000001000011, "mod.wu", urem, IIImod, GPR, 1>;

/// Shift Instructions
// sra is IR node for ashr llvm IR instruction of .bc
// srl is IR node for lshr llvm IR instruction of .bc
// shift left logical
def SLLI_W : shift_rotate_imm32<0b00000000010000001, 0x00, "slli.w", shl>;
// shift right logical
def SRLI_W : shift_rotate_imm32<0b00000000010001001, 0x00, "srli.w", srl>;
// shift right arithmetic
def SRAI_W : shift_rotate_imm32<0b00000000010001001, 0x00, "srai.w", sra>;
// rotate shift right
def ROTRI_W : shift_rotate_imm32<0b00000000010011001, 0x01, "rotri.w", rotr>;

// shift left logical
def SLL_W    : shift_rotate_reg<0b00000000000101110, 0x00, "sll.w", shl, GPR>;
// shift right logical
def SRL_W    : shift_rotate_reg<0b00000000000101111, 0x00, "srl.w", srl, GPR>;
// shift right arithmetic
def SRA_W    : shift_rotate_reg<0b00000000000110000, 0x00, "sra.w", sra, GPR>;
// shift right arithmetic
def ROTR_W    : shift_rotate_reg<0b00000000000110110, 0x01, "rotr.w", rotr, GPR>;


let Predicates = [HasSlt] in {
def SLTI    : SetCC_I<0b0000001000, "slti", setlt, simm12, immSExt12, GPR>;
def SLTUI   : SetCC_I<0b0000001001, "sltui", setult, simm12, immSExt12, GPR>;
def SLT     : SetCC_R<0b00000000000100100, "slt", setlt, GPR>;
def SLTU    : SetCC_R<0b00000000000100101, "sltu", setult, GPR>;
}

/// Jump and Branch Instructions
let Predicates = [HasSlt] in {
def BEQ     : CBranch16<0b010110, "beq", seteq, GPROut>;
def BNE     : CBranch16<0b010111, "bne", setne, GPROut>;
def BLT     : CBranch16<0b011000, "blt", setlt, GPROut>;
def BGE     : CBranch16<0b011001, "bge", setge, GPROut>;
def BLTU     : CBranch16<0b011010, "bltu", setult, GPROut>;
def BGEU     : CBranch16<0b011011, "bgeu", setuge, GPROut>;
}
def B     : UncondBranch<0b010100, "b">;

//@ long branch support
let isBranch = 1, isTerminator = 1, isBarrier = 1,
    hasDelaySlot = 0, Defs = [RA] in
def BL: FmtI26<0b010101, (outs), (ins jmptarget:$addr), "bl\t$addr", [], IIBranch>,
            Requires<[HasSlt]>;

def JIRL     : Fmt2RI16<0b010011, (outs GPROut:$rd), (ins GPR:$rj, simm16:$imm16), "jirl", [], IIBranch>;
def RET      : RetBase<GPROut>;
def JR       : JumpFR<0b010011, "jr", GPROut>;
/// sext and zext
def EXT_W_B : EXT<0b0000000000000000010111, "ext.w.b", GPR>;
def EXT_W_H : EXT<0b0000000000000000010110, "ext.w.h", GPR>;


/// No operation instruction
let imm26=0 in
  def NOP   : FmtI26<0, (outs), (ins), "nop", [], IIAlu>;

/// Count Leading
def CLZ_W : CountLeading0<0b0000000000000000000101, "clz.w", GPR>;
def CLO_W : CountLeading1<0b0000000000000000000100, "clo.w", GPR>;

// LONG_BRANCH_XXX - We need these two pseudo instructions to avoid offset calculation for long
// branches.  Check the comment in file LoongArchLongBranch.cpp for detail
// Expands to: lu12i.w $dst, %hi($tgt - $bltgt)
def LONG_BRANCH_LU12I_W : LoongArchPseudo<(outs GPROut:$dst),
(ins jmptarget:$tgt, jmptarget:$bltgt), "", []>;

// Expands to: addi.w $dst, $src, %lo($tgt - $bltgt)
def LONG_BRANCH_ADDI_W : LoongArchPseudo<(outs GPROut:$dst),
(ins GPROut:$src, jmptarget:$tgt, jmptarget:$bltgt), "", []>;

// FrameIndexs are legalized when they are opreands from load/store instruction.
// The same not happens for stack address copies, so an add op with mem
// ComplexPattern is used and the stack address copy can be matched.
// It's similar to Sparc LEA_ADDRi
def LEA_ADDI_W : EffectiveAddress<"addi.w\t$rd, $addr", GPR, mem_ea> {
let isCodeGenOnly = 1;
}

//use JIRL ZERO, RA, 0 to replace IR instruction "ret", since LoongArch doesn't have "ret" like Mips
let isReturn=1, isTerminator=1, hasDelaySlot=1, isBarrier=1, hasCtrlDep=1 in
  def RetRA  : LoongArchPseudo<(outs), (ins), "", [(LoongArchRet)]>;
//                  ,PseudoInstExpansion<(JIRL ZERO, RA, 0)>;

// Condtional move
def MASKEQZ : CondMovIntInt<0b00000000000100110, "maskeqz", IIAlu, GPR>;
def MASKNEZ : CondMovIntInt<0b00000000000100111, "masknez", IIAlu, GPR>;

//===----------------------------------------------------------------------===//
//  Instruction aliases
//===----------------------------------------------------------------------===//
def : LoongArchInstAlias<"move $dst, $src",
(ADD_W GPROut:$dst, GPROut:$src, ZERO), 1>;
//  class InstAlias<string Asm, dag Result, int Emit = 0b1> {
//      string AsmString = Asm;      // The .s format to match the instruction with.
//      dag ResultInst = Result;     // The MCInst to generate.
//      //This determines which order the InstPrinter detects aliases for
//      // printing. A larger value makes the alias more likely to be
//      // emitted. The Instruction's own definition is notionally 0.5, so 0
//      // disables printing and 1 enables it if there are no conflicting aliases.
//      int EmitPriority = Emit;
//  }
//===----------------------------------------------------------------------===//
def : InstAlias<"jr $rj",                (JIRL      ZERO, GPROut:$rj, 0), 3>;
//def : InstAlias<"jr ${offset}(${rj})",   (JIRL      ZERO, GPROut:$rj, simm16:$offset)>;
//def : InstAlias<"ret",                   (JIRL      ZERO,      RA, 0), 4>;

//===----------------------------------------------------------------------===//
//  Arbitrary patterns that map to one or more instructions
//===----------------------------------------------------------------------===//

// Small immediates
def : Pat<(i32 immSExt12:$in), (ADDI_W ZERO, imm:$in)>;

def : Pat<(i32 immZExt12:$in), (ORI ZERO, imm:$in)>;

def : Pat<(i32 immLow12Zero:$in), (LU12I_W (HI20 imm:$in))>;

// Arbitrary immediates
def : Pat<(i32 imm:$imm), (ORI (LU12I_W (HI20 imm:$imm)), (LO12 imm:$imm))>;

def : Pat<(rotl GPR:$rj, immZExt5:$imm), (ROTRI_W GPR:$rj, (ImmSubFrom32 immZExt5:$imm))>;

def : Pat<(not GPR:$in),(NOR GPR:$in, ZERO)>;



// hi/lo relocs
def : Pat<(LoongArchHi tglobaladdr:$in), (LU12I_W tglobaladdr:$in)>;
def : Pat<(LoongArchHi tblockaddress:$in), (LU12I_W tblockaddress:$in)>;
def : Pat<(LoongArchHi tjumptable:$in), (LU12I_W tjumptable:$in)>;

def : Pat<(LoongArchLo tglobaladdr:$in), (ORI ZERO, tglobaladdr:$in)>;
def : Pat<(LoongArchLo tblockaddress:$in), (ORI ZERO, tblockaddress:$in)>;
def : Pat<(LoongArchLo tjumptable:$in), (ORI ZERO, tjumptable:$in)>;

def : Pat<(add GPR:$hi, (LoongArchLo tglobaladdr:$lo)),
        (ORI GPR:$hi, tglobaladdr:$lo)>;
def : Pat<(add GPR:$hi, (LoongArchLo tblockaddress:$lo)),
        (ORI GPR:$hi, tblockaddress:$lo)>;
def : Pat<(add GPR:$hi, (LoongArchLo tjumptable:$lo)),
        (ORI GPR:$hi, tjumptable:$lo)>;

// gp_rel relocs
def : Pat<(add GPR:$gp, (LoongArchGPRel tglobaladdr:$in)),
        (ORI GPR:$gp, tglobaladdr:$in)>;

// wrapper_pic
class WrapperPat<SDNode node, Instruction ORIOp, RegisterClass RC>
        : Pat<(LoongArchWrapper RC:$gp, node:$in), (ORIOp RC:$gp, node:$in)>;
def : WrapperPat<tglobaladdr, ORI, GPROut>;
def : WrapperPat<tjumptable, ORI, GPROut>;

def : Pat<(i32 (extloadi1  addr:$src)), (LD_BU addr:$src)>;
def : Pat<(i32 (extloadi8  addr:$src)), (LD_BU addr:$src)>;
def : Pat<(i32 (extloadi16_a addr:$src)), (LD_HU addr:$src)>;


// brcond for slt instruction
multiclass BrcondPatsSlt<RegisterClass RC, Instruction BEQOp, Instruction BNEOp,
        Instruction BLTOp, Instruction BGEOp, Instruction BLTUOp, Instruction BGEUOp,
        Instruction SLTOp, Instruction SLTUOp, Instruction SLTIOp, Instruction SLTUIOp,
        Register ZEROReg> {
        def : Pat<(brcond (i32 (setne RC:$lhs, 0)), bb:$dst),
        (BNEOp RC:$lhs, ZEROReg, bb:$dst)>;
        def : Pat<(brcond (i32 (seteq RC:$lhs, 0)), bb:$dst),
        (BEQOp RC:$lhs, ZEROReg, bb:$dst)>;

        def : Pat<(brcond (i32 (seteq RC:$lhs, RC:$rhs)), bb:$dst),
        (BEQOp RC:$lhs, RC:$rhs, bb:$dst)>;
        def : Pat<(brcond (i32 (setueq RC:$lhs, RC:$rhs)), bb:$dst),
        (BEQOp RC:$lhs, RC:$rhs, bb:$dst)>;
        def : Pat<(brcond (i32 (setne RC:$lhs, RC:$rhs)), bb:$dst),
        (BNEOp RC:$lhs, RC:$rhs, bb:$dst)>;
        def : Pat<(brcond (i32 (setune RC:$lhs, RC:$rhs)), bb:$dst),
        (BNEOp RC:$lhs, RC:$rhs, bb:$dst)>;
        def : Pat<(brcond (i32 (setlt RC:$lhs, RC:$rhs)), bb:$dst),
        (BLTOp RC:$lhs, RC:$rhs, bb:$dst)>;
        def : Pat<(brcond (i32 (setult RC:$lhs, RC:$rhs)), bb:$dst),
        (BLTUOp RC:$lhs, RC:$rhs, bb:$dst)>;
        def : Pat<(brcond (i32 (setgt RC:$lhs, RC:$rhs)), bb:$dst),
        (BLTOp RC:$rhs, RC:$lhs, bb:$dst)>;
        def : Pat<(brcond (i32 (setugt RC:$lhs, RC:$rhs)), bb:$dst),
        (BLTUOp RC:$rhs, RC:$lhs, bb:$dst)>;
        def : Pat<(brcond (i32 (setle RC:$lhs, RC:$rhs)), bb:$dst),
        (BGEOp RC:$rhs, RC:$lhs, bb:$dst)>;
        def : Pat<(brcond (i32 (setule RC:$lhs, RC:$rhs)), bb:$dst),
        (BGEUOp  RC:$rhs, RC:$lhs, bb:$dst)>;
        def : Pat<(brcond (i32 (setge RC:$lhs, RC:$rhs)), bb:$dst),
        (BGEOp RC:$lhs, RC:$rhs, bb:$dst)>;
        def : Pat<(brcond (i32 (setuge RC:$lhs, RC:$rhs)), bb:$dst),
        (BGEUOp RC:$lhs, RC:$rhs, bb:$dst)>;

        def : Pat<(brcond RC:$cond, bb:$dst),
        (BNEOp RC:$cond, ZEROReg, bb:$dst)>;
}

let Predicates = [HasSlt] in {
defm : BrcondPatsSlt<GPR, BEQ, BNE, BLT, BGE, BLTU, BGEU, SLT, SLTU, SLTI, SLTUI, ZERO>;
}


// setcc for slt instruction
multiclass SeteqPatsSlt<RegisterClass RC, Instruction SLTUIOp, Instruction XOROp,
        Instruction SLTUOp, Register ZEROReg> {
// a == b
        def : Pat<(seteq RC:$lhs, RC:$rhs),
        (SLTUIOp (XOROp RC:$lhs, RC:$rhs), 1)>;
// a != b
        def : Pat<(setne RC:$lhs, RC:$rhs),
        (SLTUOp ZEROReg, (XOROp RC:$lhs, RC:$rhs))>;
}

// a <= b
multiclass SetlePatsSlt<RegisterClass RC, Instruction SLTOp, Instruction SLTUOp> {
        def : Pat<(setle RC:$lhs, RC:$rhs),
// a <= b is equal to (XORI (b < a), 1)
        (XORI (SLTOp RC:$rhs, RC:$lhs), 1)>;
        def : Pat<(setule RC:$lhs, RC:$rhs),
        (XORI (SLTUOp RC:$rhs, RC:$lhs), 1)>;
}

// a > b
multiclass SetgtPatsSlt<RegisterClass RC, Instruction SLTOp, Instruction SLTUOp> {
        def : Pat<(setgt RC:$lhs, RC:$rhs),
// a > b is equal to b < a is equal to setlt(b, a)
        (SLTOp RC:$rhs, RC:$lhs)>;
        def : Pat<(setugt RC:$lhs, RC:$rhs),
        (SLTUOp RC:$rhs, RC:$lhs)>;
}

// a >= b
multiclass SetgePatsSlt<RegisterClass RC, Instruction SLTOp, Instruction SLTUOp> {
        def : Pat<(setge RC:$lhs, RC:$rhs),
// a >= b is equal to b <= a
        (XORI (SLTOp RC:$lhs, RC:$rhs), 1)>;
        def : Pat<(setuge RC:$lhs, RC:$rhs),
        (XORI (SLTUOp RC:$lhs, RC:$rhs), 1)>;
}

multiclass SetgeImmPatsSlt<RegisterClass RC, Instruction SLTIOp,
        Instruction SLTUIOp> {
        def : Pat<(setge RC:$lhs, immSExt12:$rhs),
        (XORI (SLTIOp RC:$lhs, immSExt12:$rhs), 1)>;
        def : Pat<(setuge RC:$lhs, immSExt12:$rhs),
        (XORI (SLTUIOp RC:$lhs, immSExt12:$rhs), 1)>;
}

let Predicates = [HasSlt] in {
defm : SeteqPatsSlt<GPR, SLTUI, XOR, SLTU, ZERO>;
defm : SetlePatsSlt<GPR, SLT, SLTU>;
defm : SetgtPatsSlt<GPR, SLT, SLTU>;
defm : SetgePatsSlt<GPR, SLT, SLTU>;
defm : SetgeImmPatsSlt<GPR, SLTI, SLTUI>;
}

def : Pat<(sext_inreg GPR:$rj, i8), (EXT_W_B GPR:$rj)>;
def : Pat<(sext_inreg GPR:$rj, i16), (EXT_W_H GPR:$rj)>;

// select
def : Pat<(select GPR:$cond, GPR:$t, GPR:$f),
          (OR (MASKEQZ GPR:$t, GPR:$cond), (MASKNEZ GPR:$f, GPR:$cond))>;