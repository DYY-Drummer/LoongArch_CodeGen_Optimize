//===-- LoongArchRegisterInfo.h - LoongArch Register Information Impl -----*- C++ -*-===//
//
// This file contains the LoongArch implementation of the TargetRegisterInfo class.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHREGISTERINFO_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHREGISTERINFO_H

#include "LoongArch.h"
#include "llvm/CodeGen/TargetRegisterInfo.h"

#define GET_REGINFO_HEADER
#include "LoongArchGenRegisterInfo.inc"

namespace llvm {
    class LoongArchSubtarget;
    class TargetInstrInfo;
    class Type;

    class LoongArchRegisterInfo : public LoongArchGenRegisterInfo {
    protected:
        const LoongArchSubtarget &Subtarget;

    public:
        LoongArchRegisterInfo(const LoongArchSubtarget &Subtarget);

        const MCPhysReg *getCalleeSavedRegs(const MachineFunction *MF) const override;

        const uint32_t *getCallPreservedMask(const MachineFunction &MF,
                                             CallingConv::ID) const override;

        BitVector getReservedRegs(const MachineFunction &MF) const override;

        bool requiresRegisterScavenging(const MachineFunction &MF) const override;

        bool trackLivenessAfterRegAlloc(const MachineFunction &MF) const override;

        /// Stack Frame Processing Methods
        void eliminateFrameIndex(MachineBasicBlock::iterator II,
                                 int SPAdj, unsigned FIOperandNum,
                                 RegScavenger *RS = nullptr) const override;

        /// Debug information queries.
        Register getFrameRegister(const MachineFunction &MF) const override;

        /// \brief Return GPR register class.
        virtual const TargetRegisterClass *intRegClass(unsigned Size) const = 0;
    };

} // end namespace llvm

#endif