//===- LoongArchInstrInfo.td - Target Description for LoongArch Target -*- tablegen -*-=//
//===----------------------------------------------------------------------===//
//
// This file contains the LoongArch implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// LoongArch profiles and nodes
//===----------------------------------------------------------------------===//

def SDT_LoongArchRet          : SDTypeProfile<0, 1, [SDTCisInt<0>]>;

// Return
def LoongArchRet : SDNode<"LoongArchISD::Ret", SDTNone,
                     [SDNPHasChain, SDNPOptInGlue, SDNPVariadic]>;

//===----------------------------------------------------------------------===//
// Instruction format superclass
//===----------------------------------------------------------------------===//

include "LoongArchInstrFormats.td"

//===----------------------------------------------------------------------===//
// LoongArch Operand, Complex Patterns and Transformations Definitions.
//===----------------------------------------------------------------------===//
// Instruction operand types

// Signed Operand
def simm16      : Operand<i32> {
  let DecoderMethod= "DecodeSimm16";
}
def simm12      : Operand<i32> {
let DecoderMethod= "DecodeSimm12";
}

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

// Arithmetic and logical instructions with 2 register operands.
class ALU_2RI12<bits<10> op, string instr_asm, SDNode OpNode,
                  Operand Od, PatLeaf imm_type, RegisterClass RC> :
    Fmt2RI12<op, (outs GPROut:$rd), (ins RC:$rj, Od:$imm12),
     !strconcat(instr_asm, "\t$rd, $rj, $imm12"),
     [(set GPROut:$rd, (OpNode RC:$rj, imm_type:$imm12))], IIAlu> {
  let isReMaterializable = 1;
}

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
class JumpFR<bits<6> op, string instr_asm, RegisterClass RC>:
    Fmt2RI16<op, (outs), (ins RC:$rj),
     !strconcat(instr_asm, "\t$rj"), [(brind RC:$rj)], IIBranch> {
  let rd = 0;
  let imm16 = 0;
}
//@JumpFR }

/// Return instruction
class RetBase<RegisterClass RC>
        : JumpFR<0b010011, "ret", RC>{
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

/// Arithmetic Instructions (3-Operand, R-Type)

/// Shift Instructions

def JIRL      : JumpFR<0b010011, "jirl", GPROut>;



def RET     : RetBase<GPROut>;

/// No operation instruction
let imm26=0 in
  def NOP   : FmtI26<0, (outs), (ins), "nop", [], IIAlu>;

//use JIRL ZERO, RA, 0 to replace IR instruction "ret", since LoongArch doesn't have "ret" like Mips
let isReturn=1, isTerminator=1, hasDelaySlot=1, isBarrier=1, hasCtrlDep=1 in
  def PseudoRet  : LoongArchPseudo<(outs), (ins), "", [(LoongArchRet)]>;
//                  ,PseudoInstExpansion<(JIRL ZERO, RA, 0)>;

//===----------------------------------------------------------------------===//
//  Arbitrary patterns that map to one or more instructions
//===----------------------------------------------------------------------===//

// Small immediates
def : Pat<(i32 immSExt12:$in),
          (ADDI_W ZERO, imm:$in)>;

