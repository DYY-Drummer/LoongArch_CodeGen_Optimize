//===-- LoongArchMachineFunctionInfo.cpp - Private data used for LoongArch -*- C++ -*-===//
//===----------------------------------------------------------------------===//
//
// LoongArch specific subclass of MachineFunctionInfo.
//
//===----------------------------------------------------------------------===//

#include "LoongArchMachineFunctionInfo.h"

#include "LoongArchInstrInfo.h"
#include "LoongArchSubtarget.h"
#include "llvm/IR/Function.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"

using namespace llvm;

bool FixGlobalBaseReg;

LoongArchMachineFunctionInfo::~LoongArchMachineFunctionInfo() { }

bool LoongArchFunctionInfo::globalBaseRegFixed() const {
    return FixGlobalBaseReg;
}
bool LoongArchFunctionInfo::globalBaseRegSet() const {
    return GlobalBaseReg;
}
unsigned LoongArchFunctionInfo::getGlobalBaseReg() {
    return GlobalBaseReg = LoongArch::GP;
}

void LoongArchMachineFunctionInfo::anchor() { }