//===-- LoongArchSEInstrInfo.h - LoongArch32/64 Instruction Information ---*- C++ -*-===//
// This file contains the LoongArch32/64 implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHSEINSTRINFO_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHSEINSTRINFO_H

#include "LoongArchInstrInfo.h"
#include "LoongArchSERegisterInfo.h"
#include "LoongArchMachineFunctionInfo.h"

namespace llvm {

    class LoongArchSEInstrInfo : public LoongArchInstrInfo {
        const LoongArchSERegisterInfo RI;

    public:
        explicit LoongArchSEInstrInfo(const LoongArchSubtarget &STI);

        const LoongArchRegisterInfo &getRegisterInfo() const override;

    };
} // End llvm namespace

#endif