//===-- LoongArchInstrInfo.cpp - LoongArch Instruction Information --------*- C++ -*-===//
//===----------------------------------------------------------------------===//
//
// This file contains the LoongArch implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

#include "LoongArchInstrInfo.h"

#include "LoongArchTargetMachine.h"
#include "LoongArchMachineFunctionInfo.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

#define GET_INSTRINFO_CTOR_DTOR
#include "LoongArchGenInstrInfo.inc"

// Pin the vtable to this file
void LoongArchInstrInfo::anchor() { }

LoongArchInstrInfo::LoongArchInstrInfo(const LoongArchSubtarget &STI)
    : LoongArchGenInstrInfo(LoongArch::ADJCALLSTACKDOWN, LoongArch::ADJCALLSTACKUP),
      Subtarget(STI) { }

const LoongArchInstrInfo *LoongArchInstrInfo::create(LoongArchSubtarget &STI) {
    return llvm::createLoongArchSEInstrInfo(STI);
}

unsigned LoongArchInstrInfo::GetInstSizeInBytes(const MachineInstr &MI) const {
    switch (MI.getOpcode()) {
        default:
            return MI.getDesc().getSize();
    }
}

MachineMemOperand *
LoongArchInstrInfo::GetMemOperand(MachineBasicBlock &MBB, int FI,
                             MachineMemOperand::Flags Flags) const {
    MachineFunction &MF = *MBB.getParent();
    MachineFrameInfo &MFI = MF.getFrameInfo();
    unsigned Align = MFI.getObjectAlignment(FI);

    return MF.getMachineMemOperand(MachinePointerInfo::getFixedStack(MF, FI),
                                   Flags, MFI.getObjectSize(FI), Align);
}