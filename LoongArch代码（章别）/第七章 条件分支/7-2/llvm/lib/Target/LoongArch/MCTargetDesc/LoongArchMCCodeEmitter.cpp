//===-- LoongArchMCCodeEmitter.cpp - Convert LoongArch Code to Machine Code ---------===//
//
// This file implements the LoongArchMCCodeEmitter class.
//
//===----------------------------------------------------------------------===//
//

#include "LoongArchMCCodeEmitter.h"

#include "MCTargetDesc/LoongArchBaseInfo.h"
#include "MCTargetDesc/LoongArchFixupKinds.h"
#include "MCTargetDesc/LoongArchMCExpr.h"
#include "MCTargetDesc/LoongArchMCTargetDesc.h"
#include "llvm/ADT/APFloat.h"
#include "llvm/MC/MCCodeEmitter.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/raw_ostream.h"

#define DEBUG_TYPE "mccodeemitter"

#define GET_INSTRMAP_INFO
#include "LoongArchGenInstrInfo.inc"
#undef GET_INSTRMAP_INFO

using namespace llvm;

MCCodeEmitter *llvm::createLoongArchMCCodeEmitter(const MCInstrInfo &MCII,
                                               const MCRegisterInfo &MRI,
                                               MCContext &Ctx) {
  return new LoongArchMCCodeEmitter(MCII, Ctx, false);
}


void LoongArchMCCodeEmitter::EmitByte(unsigned char C, raw_ostream &OS) const {
  OS << (char)C;
}

void LoongArchMCCodeEmitter::EmitInstruction(uint64_t Val, unsigned Size, raw_ostream &OS) const {
  // Output the instruction encoding in little endian byte order.
  for (unsigned i = 0; i < Size; ++i) {
    unsigned Shift = IsLittleEndian ? i * 8 : (Size - 1 - i) * 8;
    EmitByte((Val >> Shift) & 0xff, OS);
  }
}

/// encodeInstruction - Emit the instruction.
/// Size the instruction (currently only 4 bytes)
void LoongArchMCCodeEmitter::
encodeInstruction(const MCInst &MI, raw_ostream &OS,
                  SmallVectorImpl<MCFixup> &Fixups,
                  const MCSubtargetInfo &STI) const
{
  uint32_t Binary = getBinaryCodeForInstr(MI, Fixups, STI);

  // Remain: Check for unimplemented opcodes which will come in with Binary == 0
  //  unsigned Opcode = MI.getOpcode();
  //  if ((Opcode != LoongArch::NOP) && (Opcode != LoongArch::ROL) && !Binary)
  //    llvm_unreachable("unimplemented opcode in encodeInstruction()");

    // Pseudo instructions don't get encoded and shouldn't be here
    // in the first place!
  const MCInstrDesc &Desc = MCII.get(MI.getOpcode());
  bool isPseudo = Desc.isPseudo();
  if (isPseudo)
      llvm_unreachable("Pseudo opcode found in encodeInstruction()");



  // For now all instructions are 4 bytes
  int Size = 4; // FIXME: Have Desc.getSize() return the correct value!

  EmitInstruction(Binary, Size, OS);
}

//@CH8_1 {
/// getBranch16TargetOpValue - Return binary encoding of the branch
/// target operand. If the machine operand requires relocation,
/// record the relocation and return zero.
unsigned LoongArchMCCodeEmitter::
getBranch16TargetOpValue(const MCInst &MI, unsigned OpNo,
                         SmallVectorImpl<MCFixup> &Fixups,
                         const MCSubtargetInfo &STI) const {
    const MCOperand &MO = MI.getOperand(OpNo);

    // If the destination is an immediate, we have nothing to do.
    if (MO.isImm()) return MO.getImm();
    assert(MO.isExpr() && "getBranch16TargetOpValue expects only expressions");

    const MCExpr *Expr = MO.getExpr();
    Fixups.push_back(MCFixup::create(0, Expr,
                                     MCFixupKind(LoongArch::fixup_LoongArch_PC16)));
  return 0;
}

/// getBranch21TargetOpValue - Return binary encoding of the branch
/// target operand. If the machine operand requires relocation,
/// record the relocation and return zero.
unsigned LoongArchMCCodeEmitter::
getBranch21TargetOpValue(const MCInst &MI, unsigned OpNo,
                       SmallVectorImpl<MCFixup> &Fixups,
                       const MCSubtargetInfo &STI) const {
    //TODO
  return 0;
}

/// getBranch26TargetOpValue - Return binary encoding of the branch
/// target operand. If the machine operand requires relocation,
/// record the relocation and return zero.
unsigned LoongArchMCCodeEmitter::
getBranch26TargetOpValue(const MCInst &MI, unsigned OpNo,
                         SmallVectorImpl<MCFixup> &Fixups,
                         const MCSubtargetInfo &STI) const {
    const MCOperand &MO = MI.getOperand(OpNo);

    // If the destination is an immediate, we have nothing to do.
    if (MO.isImm()) return MO.getImm();
    assert(MO.isExpr() && "getBranch26TargetOpValue expects only expressions");

    const MCExpr *Expr = MO.getExpr();
    Fixups.push_back(MCFixup::create(0, Expr,
                                     MCFixupKind(LoongArch::fixup_LoongArch_PC26)));
    return 0;
}

/// getJumpTargetOpValue - Return binary encoding of the jump
/// target operand, such as B.
/// If the machine operand requires relocation,
/// record the relocation and return zero.
//@getJumpTargetOpValue {
unsigned LoongArchMCCodeEmitter::
getJumpTargetOpValue(const MCInst &MI, unsigned OpNo,
                     SmallVectorImpl<MCFixup> &Fixups,
                     const MCSubtargetInfo &STI) const {
    unsigned Opcode = MI.getOpcode();
    const MCOperand &MO = MI.getOperand(OpNo);
    // If the destination is an immediate, we have nothing to do.
    if (MO.isImm()) return MO.getImm();
    assert(MO.isExpr() && "getJumpTargetOpValue expects only expressions");

    const MCExpr *Expr = MO.getExpr();
    if (Opcode == LoongArch::B)
        Fixups.push_back(MCFixup::create(0, Expr,
                                         MCFixupKind(LoongArch::fixup_LoongArch_PC26)));
    else
        llvm_unreachable("unexpect opcode in getJumpAbsoluteTargetOpValue()");
  return 0;
}
//@CH8_1 }

//@getExprOpValue {
unsigned LoongArchMCCodeEmitter::
getExprOpValue(const MCExpr *Expr,SmallVectorImpl<MCFixup> &Fixups,
               const MCSubtargetInfo &STI) const {
//@getExprOpValue body {
  MCExpr::ExprKind Kind = Expr->getKind();
  if (Kind == MCExpr::Constant) {
    return cast<MCConstantExpr>(Expr)->getValue();
  }

  if (Kind == MCExpr::Binary) {
    unsigned Res = getExprOpValue(cast<MCBinaryExpr>(Expr)->getLHS(), Fixups, STI);
    Res += getExprOpValue(cast<MCBinaryExpr>(Expr)->getRHS(), Fixups, STI);
    return Res;
  }

  if (Kind == MCExpr::Target) {
    const LoongArchMCExpr *LoongArchExpr = cast<LoongArchMCExpr>(Expr);

      LoongArch::Fixups FixupKind = LoongArch::Fixups(0);
    switch (LoongArchExpr->getKind()) {
        default: llvm_unreachable("Unsupported fixup kind for target expression!");
        case LoongArchMCExpr::LEK_GPREL:
            FixupKind = LoongArch::fixup_LoongArch_GPREL16;
            break;
        case LoongArchMCExpr::LEK_GOT:
            FixupKind = LoongArch::fixup_LoongArch_GOT;
            break;
        case LoongArchMCExpr::LEK_ABS_HI:
            FixupKind = LoongArch::fixup_LoongArch_HI20;
            break;
        case LoongArchMCExpr::LEK_ABS_LO:
            FixupKind = LoongArch::fixup_LoongArch_LO12;
            break;
        case LoongArchMCExpr::LEK_GOT_HI20:
            FixupKind = LoongArch::fixup_LoongArch_GOT_HI20;
            break;
        case LoongArchMCExpr::LEK_GOT_LO12:
            FixupKind = LoongArch::fixup_LoongArch_GOT_LO12;
            break;
    } // switch
    Fixups.push_back(MCFixup::create(0, Expr, MCFixupKind(FixupKind)));
    return 0;
  }

  // All of the information is in the fixup.
  return 0;
}

/// getMachineOpValue - Return binary encoding of operand. If the machine
/// operand requires relocation, record the relocation and return zero.
unsigned LoongArchMCCodeEmitter::
getMachineOpValue(const MCInst &MI, const MCOperand &MO,
                  SmallVectorImpl<MCFixup> &Fixups,
                  const MCSubtargetInfo &STI) const {
  if (MO.isReg()) {
    unsigned Reg = MO.getReg();
    unsigned RegNo = Ctx.getRegisterInfo()->getEncodingValue(Reg);
    return RegNo;
  } else if (MO.isImm()) {
    return static_cast<unsigned>(MO.getImm());
  } else if (MO.isFPImm()) {
    return static_cast<unsigned>(APFloat(MO.getFPImm())
        .bitcastToAPInt().getHiBits(32).getLimitedValue());
  }
  // MO must be an Expr.
  assert(MO.isExpr());
  return getExprOpValue(MO.getExpr(),Fixups, STI);
}

/// getMemEncoding - Return binary encoding of memory related operand.
/// If the offset operand requires relocation, record the relocation.
unsigned
LoongArchMCCodeEmitter::getMemEncoding(const MCInst &MI, unsigned OpNo,
                                  SmallVectorImpl<MCFixup> &Fixups,
                                  const MCSubtargetInfo &STI) const {
  // Base register is encoded in bits 9-5, offset is encoded in bits 21-10.
  assert(MI.getOperand(OpNo).isReg());
  unsigned RegBits = getMachineOpValue(MI, MI.getOperand(OpNo), Fixups, STI) << 5;
  unsigned OffBits = getMachineOpValue(MI, MI.getOperand(OpNo+1), Fixups, STI) << 10;

  return (OffBits & 0b1111111111110000000000) | RegBits;
}

#include "LoongArchGenMCCodeEmitter.inc"

