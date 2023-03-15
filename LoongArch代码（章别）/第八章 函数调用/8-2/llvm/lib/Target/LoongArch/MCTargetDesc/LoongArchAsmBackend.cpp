//===-- LoongArchAsmBackend.cpp - LoongArch Asm Backend  ----------------------------===//
//
// This file implements the LoongArchAsmBackend class.
//
//===----------------------------------------------------------------------===//
//

#include "MCTargetDesc/LoongArchFixupKinds.h"
#include "MCTargetDesc/LoongArchAsmBackend.h"
#include "MCTargetDesc/LoongArchMCTargetDesc.h"

#include "llvm/MC/MCAsmBackend.h"
#include "llvm/MC/MCAssembler.h"
#include "llvm/MC/MCDirectives.h"
#include "llvm/MC/MCELFObjectWriter.h"
#include "llvm/MC/MCFixupKindInfo.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

static cl::opt<bool> HasLLD(
  "has-lld",
  cl::init(false),
  cl::desc("LOONGARCH: Has lld linker for LoongArch."),
  cl::Hidden);

//@adjustFixupValue {
// Prepare value for the target space for it
static unsigned adjustFixupValue(const MCFixup &Fixup, uint64_t Value,
                                 MCContext &Ctx) {

  unsigned Kind = Fixup.getKind();

  // Add/subtract and shift
  switch (Kind) {
  default:
    return 0;
  case FK_GPRel_4:
  case FK_Data_4:
  case LoongArch::fixup_LoongArch_LO12:
  case LoongArch::fixup_LoongArch_GOT_LO12:
    break;
  case LoongArch::fixup_LoongArch_PC16:
  case LoongArch::fixup_LoongArch_PC26:
          // So far we are only using this type for branches and jump.
          // For branches we start 1 instruction after the branch
          // so the displacement will be one instruction size less.
    Value -= 4;
    break;
  case LoongArch::fixup_LoongArch_HI20:
  case LoongArch::fixup_LoongArch_GOT:
  case LoongArch::fixup_LoongArch_GOT_HI20:
    // Get the higher 20-bits. Also add 1 if bit 19 is 1.
    Value = (Value >> 12) & 0xfffff;
    break;
  }

  return Value;
}
//@adjustFixupValue }

std::unique_ptr<MCObjectTargetWriter>
LoongArchAsmBackend::createObjectTargetWriter() const {
  return createLoongArchELFObjectWriter(TheTriple);
}

/// ApplyFixup - Apply the \p Value for given \p Fixup into the provided
/// data fragment, at the offset specified by the fixup and following the
/// fixup kind as appropriate.
void LoongArchAsmBackend::applyFixup(const MCAssembler &Asm, const MCFixup &Fixup,
                                const MCValue &Target,
                                MutableArrayRef<char> Data, uint64_t Value,
                                bool IsResolved,
                                const MCSubtargetInfo *STI) const {
  MCFixupKind Kind = Fixup.getKind();
  MCContext &Ctx = Asm.getContext();
  Value = adjustFixupValue(Fixup, Value, Ctx);

  if (!Value)
    return; // Doesn't change encoding.

  // Where do we start in the object
  unsigned Offset = Fixup.getOffset();
  // Number of bytes we need to fixup
  unsigned NumBytes = (getFixupKindInfo(Kind).TargetSize + 7) / 8;
  // Used to point to big endian bytes
  unsigned FullSize;

  switch ((unsigned)Kind) {
  default:
    FullSize = 4;
    break;
  }

  // Grab current value, if any, from bits.
  uint64_t CurVal = 0;

  for (unsigned i = 0; i != NumBytes; ++i) {
    unsigned Idx = TheTriple.isLittleEndian() ? i : (FullSize - 1 - i);
    CurVal |= (uint64_t)((uint8_t)Data[Offset + Idx]) << (i*8);
  }

  uint64_t Mask = ((uint64_t)(-1) >>
                    (64 - getFixupKindInfo(Kind).TargetSize));
  CurVal |= Value & Mask;

  // Write out the fixed up bytes back to the code/data bits.
  for (unsigned i = 0; i != NumBytes; ++i) {
    unsigned Idx = TheTriple.isLittleEndian() ? i : (FullSize - 1 - i);
    Data[Offset + Idx] = (uint8_t)((CurVal >> (i*8)) & 0xff);
  }
}

//@getFixupKindInfo {
const MCFixupKindInfo &LoongArchAsmBackend::
getFixupKindInfo(MCFixupKind Kind) const {
  unsigned JSUBReloRec = 0;
  if (HasLLD) {
    JSUBReloRec = MCFixupKindInfo::FKF_IsPCRel;
  }
  else {
    JSUBReloRec = MCFixupKindInfo::FKF_IsPCRel | MCFixupKindInfo::FKF_Constant;
  }
  const static MCFixupKindInfo Infos[LoongArch::NumTargetFixupKinds] = {
    // This table *must* be in same the order of fixup_* kinds in
    // LoongArchFixupKinds.h.
    //
    // name                        offset  bits  flags
    { "fixup_LoongArch_32",             0,     32,   0 },
    { "fixup_LoongArch_HI20",           0,     20,   0 },
    { "fixup_LoongArch_LO12",           0,     12,   0 },
    { "fixup_LoongArch_GPREL12",        0,     12,   0 },
    { "fixup_LoongArch_GPREL16",        0,     16,   0 },
    { "fixup_LoongArch_GOT",            0,     20,   0 },
    { "fixup_LoongArch_PC16",           0,     16,  MCFixupKindInfo::FKF_IsPCRel },
    { "fixup_LoongArch_PC26",           0,     26,  JSUBReloRec },
    { "fixup_LoongArch_GOT_HI20",       0,     20,   0 },
    { "fixup_LoongArch_GOT_LO12",       0,     12,   0 }
  };

  if (Kind < FirstTargetFixupKind)
    return MCAsmBackend::getFixupKindInfo(Kind);

  assert(unsigned(Kind - FirstTargetFixupKind) < getNumFixupKinds() &&
         "Invalid kind!");
  return Infos[Kind - FirstTargetFixupKind];
}
//@getFixupKindInfo }

/// WriteNopData - Write an (optimal) nop sequence of Count bytes
/// to the given output. If the target cannot generate such a sequence,
/// it should return an error.
///
/// \return - True on success.
bool LoongArchAsmBackend::writeNopData(raw_ostream &OS, uint64_t Count) const {
  return true;
}

// MCAsmBackend
MCAsmBackend *llvm::createLoongArchAsmBackend(const Target &T,
                                         const MCSubtargetInfo &STI,
                                         const MCRegisterInfo &MRI,
                                         const MCTargetOptions &Options) {
  return new LoongArchAsmBackend(T, STI.getTargetTriple());
}

