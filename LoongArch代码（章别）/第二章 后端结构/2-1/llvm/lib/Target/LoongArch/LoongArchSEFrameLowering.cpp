//===-- LoongArchSEFrameLowering.cpp - LoongArchSE Frame Information ----*- C++ -*-===//
//
// This file contains the LoongArch implementation of TargetFrameLowering class.
//
//===----------------------------------------------------------------------===//

#include "LoongArchSEFrameLowering.h"

#include "LoongArchMachineFunctionInfo.h"
#include "LoongArchSEInstrInfo.h"
#include "LoongArchSubtarget.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/MachineRegionInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/RegisterScavenging.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Target/TargetOptions.h"

using namespace llvm;

LoongArchSEFrameLowering::LoongArchSEFrameLowering(const LoongArchSubtarget &STI)
        : LoongArchFrameLowering(STI, STI.stackAlignment()) { }

void LoongArchSEFrameLowering::emitPrologue(MachineFunction &MF,
                                       MachineBasicBlock &MBB) const {
    /* Leave empty temporary */
}

void LoongArchSEFrameLowering::emitEpilogue(MachineFunction &MF,
                                       MachineBasicBlock &MBB) const {
    /* Leave empty temporary */
}

const LoongArchFrameLowering *llvm::createLoongArchSEFrameLowering(const LoongArchSubtarget
                                                         &ST) {
    return new LoongArchSEFrameLowering(ST);
}