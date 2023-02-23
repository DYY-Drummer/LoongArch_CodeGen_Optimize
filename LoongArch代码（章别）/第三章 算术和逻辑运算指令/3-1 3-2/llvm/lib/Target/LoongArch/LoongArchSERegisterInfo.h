//===-- LoongArchSERegisterInfo.h - LoongArch32 Register Information ------*- C++ -*-===//
// This file contains the LoongArch32/64 implementation of the TargetRegisterInfo
// class.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHSEREGISTERINFO_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHSEREGISTERINFO_H

#include "LoongArchRegisterInfo.h"

namespace llvm {
    class LoongArchSEInstrInfo;

    class LoongArchSERegisterInfo : public LoongArchRegisterInfo {
    public:
        LoongArchSERegisterInfo(const LoongArchSubtarget &Subtarget);

        const TargetRegisterClass *intRegClass(unsigned Size) const override;
    };

} // end namespace llvm

#endif