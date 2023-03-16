//===-- LoongArchInstrInfo.h - LoongArch Instruction Information ----------*- C++ -*-===//
// This file contains the LoongArch implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHINSTRINFO_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHINSTRINFO_H

#include "LoongArch.h"
#include "LoongArchRegisterInfo.h"
#include "LoongArchAnalyzeImmediate.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/TargetInstrInfo.h"

#define GET_INSTRINFO_HEADER
#include "LoongArchGenInstrInfo.inc"

namespace llvm {

    class LoongArchInstrInfo : public LoongArchGenInstrInfo {
        virtual void anchor();
    protected:
        const LoongArchSubtarget &Subtarget;
    public:
        explicit LoongArchInstrInfo(const LoongArchSubtarget &STI);

        static const LoongArchInstrInfo *create(LoongArchSubtarget &STI);

        // TargetInstrInfo is a superset of MRegister info. As such, whenever a client
        // has an instance of instruction info, it should always be able to get
        // register info as well (through this method).
        virtual const LoongArchRegisterInfo &getRegisterInfo() const = 0;

        // Return the number of bytes of code the specified instruction may be.
        unsigned GetInstSizeInBytes(const MachineInstr &MI) const;

        virtual unsigned getOppositeBranchOpc(unsigned Opc) const = 0;

        void storeRegToStackSlot(MachineBasicBlock &MBB,
                                 MachineBasicBlock::iterator MBBI,
                                 unsigned SrcReg, bool isKill, int FrameIndex,
                                 const TargetRegisterClass *RC,
                                 const TargetRegisterInfo *TRI) const override {
            storeRegToStack(MBB, MBBI, SrcReg, isKill, FrameIndex, RC, TRI, 0);
        }

        void loadRegFromStackSlot(MachineBasicBlock &MBB,
                                  MachineBasicBlock::iterator MBBI,
                                  unsigned DestReg, int FrameIndex,
                                  const TargetRegisterClass *RC,
                                  const TargetRegisterInfo *TRI) const override {
            loadRegFromStack(MBB, MBBI, DestReg, FrameIndex, RC, TRI, 0);
        }

        virtual void storeRegToStack(MachineBasicBlock &MBB,
                                     MachineBasicBlock::iterator MI,
                                     unsigned SrcReg, bool isKill, int FrameIndex,
                                     const TargetRegisterClass *RC,
                                     const TargetRegisterInfo *TRI,
                                     int64_t Offset) const = 0;

        virtual void loadRegFromStack(MachineBasicBlock &MBB,
                                      MachineBasicBlock::iterator MI,
                                      unsigned DestReg, int FrameIndex,
                                      const TargetRegisterClass *RC,
                                      const TargetRegisterInfo *TRI,
                                      int64_t Offset) const = 0;

        virtual void adjustStackPtr(unsigned SP, int64_t Amount,
                                    MachineBasicBlock &MBB,
                                    MachineBasicBlock::iterator I) const = 0;
    protected:
        MachineMemOperand *GetMemOperand(MachineBasicBlock &MBB, int FI,
                                         MachineMemOperand::Flags Flags) const;
    };

    const LoongArchInstrInfo *createLoongArchSEInstrInfo(const LoongArchSubtarget &STI);
}

#endif