
#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCH_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCH_H

#include "MCTargetDesc/LoongArchMCTargetDesc.h"
#include "llvm/Target/TargetMachine.h"

namespace llvm {
  class LoongArchTargetMachine;
  class FunctionPass;

    FunctionPass *createLoongArchLongBranchPass(LoongArchTargetMachine &TM);

    FunctionPass *createLoongArchDelBPass(LoongArchTargetMachine &TM);
} // end namespace llvm;

#define ENABLE_GPRESTORE  // The $gp register caller saved register enable

#endif

