//===-- LoongArchFixupKinds.h - LoongArch Specific Fixup Entries ----------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHFIXUPKINDS_H
#define LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHFIXUPKINDS_H


#include "llvm/MC/MCFixup.h"

namespace llvm {
namespace  LoongArch {
  // Although most of the current fixup types reflect a unique relocation
  // one can have multiple fixup types for a given relocation and thus need
  // to be uniquely named.
  //
  // This table *must* be in the same order of
  // MCFixupKindInfo Infos[ LoongArch::NumTargetFixupKinds]
  // in  LoongArchAsmBackend.cpp.
  //@Fixups {
  enum Fixups {
    //@ Pure upper 32 bit fixup resulting in - R_LOONGARCH_32.
    fixup_LoongArch_32 = FirstTargetFixupKind,

    // Pure upper 20 bit fixup resulting in - R_LOONGARCH_HI20.
    fixup_LoongArch_HI20,

    // Pure lower 12 bit fixup resulting in - R_LOONGARCH_LO12.
    fixup_LoongArch_LO12,

    // 12 bit fixup for GP offest resulting in - R_LOONGARCH_GPREL12.
    fixup_LoongArch_GPREL12,

    // 12 bit fixup for GP offest resulting in - R_LOONGARCH_GPREL12.
    fixup_LoongArch_GPREL16,

    // GOT (Global Offset Table)
    // Symbol fixup resulting in - R_LOONGARCH_GOT12.
    fixup_LoongArch_GOT,

    // PC relative branch fixup resulting in - R_LOONGARCH_PC16.
    // LoongArch PC16, e.g. BEQ
    fixup_LoongArch_PC16,

    // PC relative branch fixup resulting in - R_LOONGARCH_PC26.
    // LoongArch PC26, e.g. B, BL
    fixup_LoongArch_PC26,

    // resulting in - R_LOONGARCH_CALL16.
    fixup_LoongArch_CALL16,

    // resulting in - R_LOONGARCH_GOT_HI20
    fixup_LoongArch_GOT_HI20,

    // resulting in - R_LOONGARCH_GOT_LO12
    fixup_LoongArch_GOT_LO12,

    // Marker
    LastTargetFixupKind,
    NumTargetFixupKinds = LastTargetFixupKind - FirstTargetFixupKind
  };
  //@Fixups }
} // namespace LoongArch
} // namespace llvm

#endif // LLVM_LOONGARCH_LOONGARCHFIXUPKINDS_H

