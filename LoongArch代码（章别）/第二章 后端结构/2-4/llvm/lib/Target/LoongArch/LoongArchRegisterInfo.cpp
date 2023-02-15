//===-- LoongArchRegisterInfo.cpp - LOONGARCH Register Information -== --------------===//
//
// This file contains the LOONGARCH implementation of the TargetRegisterInfo class.
//
//===----------------------------------------------------------------------===//

#include "LoongArchRegisterInfo.h"

#include "LoongArch.h"
#include "LoongArchSubtarget.h"
#include "LoongArchMachineFunctionInfo.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

#define GET_REGINFO_TARGET_DESC
#include "LoongArchGenRegisterInfo.inc"

#define DEBUG_TYPE "loongarch-reg-info"

using namespace llvm;

LoongArchRegisterInfo::LoongArchRegisterInfo(const LoongArchSubtarget &ST)
        : LoongArchGenRegisterInfo(LoongArch::RA), Subtarget(ST) {}

//===----------------------------------------------------------------------===//
// Callee Saved Registers methods
//===----------------------------------------------------------------------===//
/// LoongArch Callee Saved Registers
// CSR_ILP32S_LP64S Callee Saved Registers,In LoongArchCallingConv.td
// def CSR_ILP32S_LP64S: CalleeSavedRegs<(add RA, FP, (sequence "S%u", 0, 8))>;
// llc create CSR_ILP32S_LP64S_SaveList and CSR_ILP32S_LP64S_RegMask from above defined.
const MCPhysReg *
LoongArchRegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
    return CSR_ILP32S_LP64S_SaveList;
}

const uint32_t *
LoongArchRegisterInfo::getCallPreservedMask(const MachineFunction &MF,
                                       CallingConv::ID) const {
    return CSR_ILP32S_LP64S_RegMask;
}

BitVector LoongArchRegisterInfo::
getReservedRegs(const MachineFunction &MF) const {
    static const uint16_t ReservedCPURegs[] = {
            LoongArch::ZERO, LoongArch::TP, LoongArch::SP, LoongArch::FP, LoongArch::R21, LoongArch::PC
    };
    BitVector Reserved(getNumRegs());

    for (unsigned I = 0; I < array_lengthof(ReservedCPURegs); ++I)
        Reserved.set(ReservedCPURegs[I]);

    return Reserved;
}

//- If no eliminateFrameIndex(), it will hang on run.
// FrameIndex represent objects inside a abstract stack.
// We must replace FrameIndex with an stack/frame pointer
// direct reference.
void LoongArchRegisterInfo::
eliminateFrameIndex(MachineBasicBlock::iterator II, int SPAdj,
                    unsigned FIOperandNum, RegScavenger *RS) const {
}

bool
LoongArchRegisterInfo::requiresRegisterScavenging(const MachineFunction &MF) const {
    return true;
}

bool
LoongArchRegisterInfo::trackLivenessAfterRegAlloc(const MachineFunction &MF) const {
    return true;
}

// pure virtual method
Register LoongArchRegisterInfo::
getFrameRegister(const MachineFunction &MF) const {
    const TargetFrameLowering *TFI = MF.getSubtarget().getFrameLowering();
    return TFI->hasFP(MF) ? (LoongArch::FP) :
           (LoongArch::SP);
}