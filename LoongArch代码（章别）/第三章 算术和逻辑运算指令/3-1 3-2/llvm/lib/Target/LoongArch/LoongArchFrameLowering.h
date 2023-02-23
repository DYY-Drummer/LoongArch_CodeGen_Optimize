//===-- LoongArchFrameLowering.h - Frame Information for LoongArch --------*- C++ -*-===//


#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHFRAMELOWERING_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHFRAMELOWERING_H

#include "LoongArch.h"
#include "llvm/CodeGen/TargetFrameLowering.h"

namespace llvm {
    class LoongArchSubtarget;

    class LoongArchFrameLowering : public TargetFrameLowering {
    protected:
        const LoongArchSubtarget &STI;

    public:
        explicit  LoongArchFrameLowering(const LoongArchSubtarget &sti, unsigned Alignment)
                : TargetFrameLowering(StackGrowsDown, Align(Alignment), 0, Align(Alignment)),
                  STI(sti) { }

        static const LoongArchFrameLowering *create(const LoongArchSubtarget &ST);

        bool hasFP(const MachineFunction &MF) const override;

    };

// Create LoongArchFrameLowering objects.
    const LoongArchFrameLowering *createLoongArchSEFrameLowering(const LoongArchSubtarget &ST);

} // End llvm namespace

#endif