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


        // Expand Pseudo instructions into real backend instructions
        bool expandPostRAPseudo(MachineInstr &MI) const override;

        void storeRegToStack(MachineBasicBlock &MBB,
                             MachineBasicBlock::iterator MI,
                             unsigned SrcReg, bool isKill, int FrameIndex,
                             const TargetRegisterClass *RC,
                             const TargetRegisterInfo *TRI,
                             int64_t Offset) const override;

        void loadRegFromStack(MachineBasicBlock &MBB,
                              MachineBasicBlock::iterator MI,
                              unsigned DestReg, int FrameIndex,
                              const TargetRegisterClass *RC,
                              const TargetRegisterInfo *TRI,
                              int64_t Offset) const override ;

        // Adjust SP by Amount bytes.
        void adjustStackPtr(unsigned SP, int64_t Amount, MachineBasicBlock &MBB,
                            MachineBasicBlock::iterator I) const override;
        // Emit a series of instructions to load an immediate. If NewImm is a
        // non-NULL parameter, the last instruction is not emitted, but instead
        // its immediate operand is returned in NewImm.
        unsigned loadImmediate(int64_t Imm, MachineBasicBlock &MBB,
                               MachineBasicBlock::iterator II, const DebugLoc &DL,
                               unsigned *NewImm) const;

    private:
        void expandRetRA(MachineBasicBlock &MBB, MachineBasicBlock::iterator I) const;
    };
} // End llvm namespace

#endif