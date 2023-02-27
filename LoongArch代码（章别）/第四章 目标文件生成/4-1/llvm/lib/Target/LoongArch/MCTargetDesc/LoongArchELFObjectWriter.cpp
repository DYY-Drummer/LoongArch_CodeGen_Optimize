//===-- LoongArchELFObjectWriter.cpp - LoongArch ELF Writer -------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//


#include "MCTargetDesc/LoongArchBaseInfo.h"
#include "MCTargetDesc/LoongArchFixupKinds.h"
#include "MCTargetDesc/LoongArchMCTargetDesc.h"
#include "llvm/MC/MCAssembler.h"
#include "llvm/MC/MCELFObjectWriter.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCSection.h"
#include "llvm/MC/MCValue.h"
#include "llvm/Support/ErrorHandling.h"
#include <list>

using namespace llvm;

namespace {
  class LoongArchELFObjectWriter : public MCELFObjectTargetWriter {
  public:
      LoongArchELFObjectWriter(uint8_t OSABI, bool HasRelocationAddend, bool Is64);

	~LoongArchELFObjectWriter() = default;

    unsigned getRelocType(MCContext &Ctx, const MCValue &Target,
                        const MCFixup &Fixup, bool IsPCRel) const override;
    bool needsRelocateWithSymbol(const MCSymbol &Sym,
                                 unsigned Type) const override;
  };
}

LoongArchELFObjectWriter::LoongArchELFObjectWriter(uint8_t OSABI,
                                         bool HasRelocationAddend, bool Is64)
    : MCELFObjectTargetWriter(/*Is64Bit_=false*/ Is64, OSABI, ELF::EM_LOONGARCH,
          /*HasRelocationAddend_ = false*/ HasRelocationAddend) {}

//@GetRelocType {
unsigned LoongArchELFObjectWriter::getRelocType(MCContext &Ctx,
                                           const MCValue &Target,
                                           const MCFixup &Fixup,
                                           bool IsPCRel) const {
  // determine the type of the relocation
  unsigned Type = (unsigned)ELF::R_LOONGARCH_NONE;
  unsigned Kind = (unsigned)Fixup.getKind();

  switch (Kind) {
  default:
    llvm_unreachable("invalid fixup kind!");
  case FK_Data_4:
    Type = ELF::R_LOONGARCH_32;
    break;
  case LoongArch::fixup_LoongArch_32:
    Type = ELF::R_LOONGARCH_32;
    break;
  case LoongArch::fixup_LoongArch_GPREL16:
    Type = ELF::R_LOONGARCH_GPREL16;
    break;
  case LoongArch::fixup_LoongArch_GOT:
    Type = ELF::R_LOONGARCH_GOT16;
    break;
  case LoongArch::fixup_LoongArch_HI20:
    Type = ELF::R_LOONGARCH_HI20;
    break;
  case LoongArch::fixup_LoongArch_LO12:
    Type = ELF::R_LOONGARCH_LO12;
    break;
  case LoongArch::fixup_LoongArch_GOT_HI20:
    Type = ELF::R_LOONGARCH_GOT_HI20;
    break;
  case LoongArch::fixup_LoongArch_GOT_LO12:
    Type = ELF::R_LOONGARCH_GOT_LO12;
    break;
  }

  return Type;
}
//@GetRelocType }

bool
LoongArchELFObjectWriter::needsRelocateWithSymbol(const MCSymbol &Sym,
                                             unsigned Type) const {
  // FIXME: This is extremelly conservative. This really needs to use a
  // whitelist with a clear explanation for why each realocation needs to
  // point to the symbol, not to the section.
  switch (Type) {
  default:
    return true;

  case ELF::R_LOONGARCH_GOT16:
  // For LoongArch pic mode, I think it's OK to return true but I didn't confirm.
  //  llvm_unreachable("Should have been handled already");
    return true;

  // These relocations might be paired with another relocation. The pairing is
  // done by the static linker by matching the symbol. Since we only see one
  // relocation at a time, we have to force them to relocate with a symbol to
  // avoid ending up with a pair where one points to a section and another
  // points to a symbol.
  case ELF::R_LOONGARCH_HI20:
  case ELF::R_LOONGARCH_LO12:
  // R_LOONGARCH_32 should be a relocation record, I don't know why Mips set it to
  // false.
  case ELF::R_LOONGARCH_32:
    return true;

  case ELF::R_LOONGARCH_GPREL16:
    return false;
  }
}

std::unique_ptr<MCObjectTargetWriter> 
llvm::createLoongArchELFObjectWriter(const Triple &TT) {
  uint8_t OSABI = MCELFObjectTargetWriter::getOSABI(TT.getOS());
  bool IsN64 = false;
  bool HasRelocationAddend = TT.isArch64Bit();
  return std::make_unique<LoongArchELFObjectWriter>(OSABI, HasRelocationAddend,
                                               IsN64);
}

