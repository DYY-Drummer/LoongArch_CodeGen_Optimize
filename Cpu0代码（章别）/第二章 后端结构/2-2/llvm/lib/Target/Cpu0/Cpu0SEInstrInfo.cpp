//===-- Cpu0SEInstrInfo.cpp - Cpu032/64 Instruction Information -----------===//
//
//
// This file contains the Cpu032/64 implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

#include "Cpu0SEInstrInfo.h"

#include "Cpu0MachineFunctionInfo.h"
#include "Cpu0TargetMachine.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

Cpu0SEInstrInfo::Cpu0SEInstrInfo(const Cpu0Subtarget &STI)
        : Cpu0InstrInfo(STI),
          RI(STI) {} // A::B:C(),D()， B是A类的成员函数，对A中的成员变量C和D进行赋值初始化（初始化列表）

const Cpu0RegisterInfo &Cpu0SEInstrInfo::getRegisterInfo() const {
    return RI;
}

const Cpu0InstrInfo *llvm::createCpu0SEInstrInfo(const Cpu0Subtarget &STI) {
    return new Cpu0SEInstrInfo(STI);
}