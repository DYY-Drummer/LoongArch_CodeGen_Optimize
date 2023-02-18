//===- LoongArchInstrInfo.td - Target Description for LoongArch Target -*- tablegen -*-=//
//===----------------------------------------------------------------------===//
//
// This file contains the LoongArch implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// LoongArch profiles and nodes
//===----------------------------------------------------------------------===//

//class SDTypeProfile<int numresults, int numoperands, list<SDTypeConstraint> constraints>
def SDT_LoongArchRet          : SDTypeProfile<1, 2, [SDTCisInt<0>]>;

// Return
def LoongArchRet : SDNode<"LoongArchISD::Ret", SDTNone,
                     [SDNPHasChain, SDNPOptInGlue, SDNPVariadic]>;

//===----------------------------------------------------------------------===//
// LoongArch Instruction Predicate Definitions.
//===----------------------------------------------------------------------===//
def EnableOverflow  : Predicate<"Subtarget->enableOverflow()">;
def DisableOverflow : Predicate<"Subtarget->disableOverflow()">;

def HasSlt          : Predicate<"Subtarget->hasSlt()">;

//===----------------------------------------------------------------------===//
// Instruction format superclass
//===----------------------------------------------------------------------===//

include "LoongArchInstrFormats.td"

//===----------------------------------------------------------------------===//
// LoongArch Operand, Complex Patterns and Transformations Definitions.
//===----------------------------------------------------------------------===//
// Instruction operand types

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
//操作符为ops的dag值，它用于指定多个子操作数，有子操作数的操作数称为复合操作数
  let MIOperandInfo = (ops GPROut, simm12);
  let EncoderMethod = "getMemEncoding";
}

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

//===----------------------------------------------------------------------===//
// Instructions specific format
//===----------------------------------------------------------------------===//

// Arithmetic and logical instructions with 3 register operands
class ALU_3R<bits<17> op, string instr_asm, SDNode OpNode,
        InstrItinClass itin, RegisterClass RC, bit isComm = 0>
: Fmt3R<op, (outs GPROut:$rd), (ins RC:$rj, RC:$rk),
!strconcat(instr_asm, "\t$rd, $rj, $rk"),
[(set GPROut:$rd, (OpNode RC:$rj, RC:$rk))], itin> {
let shamt = 0;
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

//@JumpFR {
let isBranch=1, isTerminator=1, isBarrier=1, imm16=0, hasDelaySlot = 1,
    isIndirectBranch = 1 in
class JumpFR<bits<6> op, string instr_asm, SDNode OpNode,
             Operand Od, PatLeaf imm_type, RegisterClass RC>:
    Fmt2RI16<op, (outs), (ins RC:$rj),
     !strconcat(instr_asm, "\t$rj"), [(brind RC:$rj)], IIBranch> {
  let rd = 0;
  let imm16 = 0;
}
//@JumpFR }


// Return
class RetBase<RegisterClass regClass> : JumpFR<0b010011, "jr", add, simm16, immSExt16, regClass> {
    let isReturn = 1;
    let isCodeGenOnly = 1;
    let hasCtrlDep = 1;
    let hasExtraSrcRegAllocReq = 1;
}
//===----------------------------------------------------------------------===//
// Instruction definition
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// LoongArch Instructions
//===----------------------------------------------------------------------===//

/// Load and Store Instructions
///  aligned
def LD_W     : LoadM32<0b0010100010,  "ld.w",  load_a>;  //load a sign-extended word from memory to $rd
def ST_W     : StoreM32<0b0010100110, "st.w",  store_a>; //store bit [31:0] of $rd to memory

/// Arithmetic Instructions (ALU Immediate)
// IR "add" defined in include/llvm/Target/TargetSelectionDAG.td, line 315 (def add).
def ADDI_W   : ALU_2RI12<0b0000001010, "addi.w", add, simm12, immSExt12, GPR>;
def ORI      : ALU_2RI12<0b0000001110, "ori", or, uimm12, immZExt12, GPR>;
def LU12I_W  : LoadUpper<0b0001010, "lu12i.w", GPROut, uimm20>;

/// Arithmetic Instructions (3-Operand, 3R-Type)
let Predicates = [DisableOverflow] in {
def ADD_W   : ALU_3R<0b00000000000100000, "add.w", add, IIAlu, GPR, 1>;
}

/// Shift Instructions

/// Jump Instructions
//def JIRL      : JumpFR<0b010011, "jirl", add, simm16, immSExt16, GPROut>;
def RET      : RetBase<GPROut>;



/// No operation instruction
let imm26=0 in
  def NOP   : FmtI26<0, (outs), (ins), "nop", [], IIAlu>;

//use JIRL ZERO, RA, 0 to replace IR instruction "ret", since LoongArch doesn't have "ret" like Mips
let isReturn=1, isTerminator=1, hasDelaySlot=1, isBarrier=1, hasCtrlDep=1 in
  def RetRA  : LoongArchPseudo<(outs), (ins), "", [(LoongArchRet)]>;
//                  ,PseudoInstExpansion<(JIRL ZERO, RA, 0)>;

//===----------------------------------------------------------------------===//
//  Arbitrary patterns that map to one or more instructions
//===----------------------------------------------------------------------===//

// Small immediates
def : Pat<(i32 immSExt12:$in), (ADDI_W ZERO, imm:$in)>;

def : Pat<(i32 immZExt12:$in), (ORI ZERO, imm:$in)>;

def : Pat<(i32 immLow12Zero:$in), (LU12I_W (HI20 imm:$in))>;

// Arbitrary immediates
def : Pat<(i32 imm:$imm), (ORI (LU12I_W (HI20 imm:$imm)), (LO12 imm:$imm))>;
//===----------------------------------------------------------------------===//
//  Instruction aliases
//===----------------------------------------------------------------------===//
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
//def : InstAlias<"jr $rj",                (JIRL      ZERO, GPROut:$rj, 0), 3>;
//def : InstAlias<"jr ${offset}(${rj})",   (JIRL      ZERO, GPROut:$rj, simm16:$offset)>;
//def : InstAlias<"ret",                   (JIRL      ZERO,      RA, 0), 4>;