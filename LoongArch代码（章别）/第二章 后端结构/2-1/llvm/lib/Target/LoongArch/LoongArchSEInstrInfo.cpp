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

const LoongArchInstrInfo *llvm::createLoongArchSEInstrInfo(const LoongArchSubtarget &STI) {
    return new LoongArchSEInstrInfo(STI);
}