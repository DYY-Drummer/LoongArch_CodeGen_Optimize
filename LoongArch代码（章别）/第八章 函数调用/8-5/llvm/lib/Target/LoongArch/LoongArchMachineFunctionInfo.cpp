//===-- LoongArchMachineFunctionInfo.cpp - Private data used for LoongArch -*- C++ -*-===//
//===----------------------------------------------------------------------===//
//
// LoongArch specific subclass of MachineFunctionInfo.
//
//===----------------------------------------------------------------------===//

#include "LoongArchMachineFunctionInfo.h"
#include "MCTargetDesc/LoongArchBaseInfo.h"
#include "LoongArchInstrInfo.h"
#include "LoongArchSubtarget.h"
#include "llvm/IR/Function.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"

using namespace llvm;

bool FixGlobalBaseReg;

LoongArchMachineFunctionInfo::~LoongArchMachineFunctionInfo() { }

bool LoongArchMachineFunctionInfo::globalBaseRegFixed() const {
    return FixGlobalBaseReg;
}
bool LoongArchMachineFunctionInfo::globalBaseRegSet() const {
    return GlobalBaseReg;
}
unsigned LoongArchMachineFunctionInfo::getGlobalBaseReg() {
    return GlobalBaseReg = LoongArch::GP;
}


MachinePointerInfo LoongArchMachineFunctionInfo::callPtrInfo(const char *ES) {
    return MachinePointerInfo(MF.getPSVManager().getExternalSymbolCallEntry(ES));
}

MachinePointerInfo LoongArchMachineFunctionInfo::callPtrInfo(const GlobalValue *GV) {
    return MachinePointerInfo(MF.getPSVManager().getGlobalValueCallEntry(GV));
}
void LoongArchMachineFunctionInfo::anchor() { }