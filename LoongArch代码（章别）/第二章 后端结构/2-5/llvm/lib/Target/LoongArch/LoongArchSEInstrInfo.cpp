//===-- LoongArchSEInstrInfo.cpp - LoongArch32/64 Instruction Information -----------===//
//
//
// This file contains the LoongArch32/64 implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

#include "LoongArchSEInstrInfo.h"

#include "LoongArchMachineFunctionInfo.h"
#include "LoongArchTargetMachine.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

LoongArchSEInstrInfo::LoongArchSEInstrInfo(const LoongArchSubtarget &STI)
        : LoongArchInstrInfo(STI),
          RI(STI) {}

const LoongArchRegisterInfo &LoongArchSEInstrInfo::getRegisterInfo() const {
    return RI;
}


bool LoongArchSEInstrInfo::expandPostRAPseudo(MachineInstr &MI) const {
    MachineBasicBlock &MBB = *MI.getParent();

    switch(MI.getDesc().getOpcode()) {
        default:
            return false;
        case LoongArch::RetRA:
            expandRetRA(MBB, MI);
            break;
    }

    MBB.erase(MI);
    return true;
}

void LoongArchSEInstrInfo::expandRetRA(MachineBasicBlock &MBB,
                                  MachineBasicBlock::iterator I) const {
    BuildMI(MBB, I, I->getDebugLoc(), get(LoongArch::RET)).addReg(LoongArch::RA);
}

const LoongArchInstrInfo *llvm::createLoongArchSEInstrInfo(const LoongArchSubtarget &STI) {
    return new LoongArchSEInstrInfo(STI);
}