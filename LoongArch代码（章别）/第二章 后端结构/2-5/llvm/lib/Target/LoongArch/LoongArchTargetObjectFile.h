//===-- LoongArchTargetObjectFile.h - LoongArch Object Info ---------------*- C++ -*-===//

//===----------------------------------------------------------------------===//
#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHTARGETOBJECTFILE_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHTARGETOBJECTFILE_H

#include "LoongArchTargetMachine.h"
#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"

namespace llvm {
    class LoongArchTargetMachine;
    class LoongArchTargetObjectFile : public TargetLoweringObjectFileELF {
        MCSection *SmallDataSection;
        MCSection *SmallBSSSection;
        const LoongArchTargetMachine *TM;
    public:
        void Initialize(MCContext &Ctx, const TargetMachine &TM) override;

    };
} // end namespace llvm

#endif