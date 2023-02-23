//===-- LoongArchSEISelLowering.h - LoongArchSE DAG Lowering Interface ---*- C++ -*-===//
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHSEISELLOWERING_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHSEISELLOWERING_H

#include "LoongArchISelLowering.h"
#include "LoongArchRegisterInfo.h"

namespace llvm {
    class LoongArchSETargetLowering : public LoongArchTargetLowering {
    public:
        explicit LoongArchSETargetLowering(const LoongArchTargetMachine &TM,
                                      const LoongArchSubtarget &STI);

        SDValue LowerOperation(SDValue Op, SelectionDAG &DAG) const override;
    };

}// End llvm namespace

#endif