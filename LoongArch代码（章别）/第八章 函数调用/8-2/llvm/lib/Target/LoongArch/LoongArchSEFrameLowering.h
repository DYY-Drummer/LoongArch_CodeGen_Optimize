//===-- LoongArchSEFrameLowering.h - LoongArchSE Frame Lowering --------*- C++ -*-===//
//SE means standard edition, for LoongArch, is 32-bits edition

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHSEFRAMELOWERING_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHSEFRAMELOWERING_H

#include "LoongArchFrameLowering.h"

namespace llvm {
    class LoongArchSEFrameLowering : public LoongArchFrameLowering {
    public:
        explicit LoongArchSEFrameLowering(const LoongArchSubtarget &STI);

        // These methods insert prolog and epilog code into the function.
        void emitPrologue(MachineFunction &MF, MachineBasicBlock &MBB) const override;
        void emitEpilogue(MachineFunction &MF, MachineBasicBlock &MBB) const override;

		bool hasReservedCallFrame(const MachineFunction &MF) const override;
        void determineCalleeSaves(MachineFunction &MF, BitVector &SavedRegs,
                                  RegScavenger *RS) const override;
    };

} // End llvm namespace

#endif
