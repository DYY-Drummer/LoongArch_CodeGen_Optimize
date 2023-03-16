//===-- LoongArchDelUselessB.cpp - LoongArch DelB -------------------------------===//
//
// Simple pass to fills delay slots with useful instructions.
//
//===----------------------------------------------------------------------===//

#include "LoongArch.h"

#include "LoongArchTargetMachine.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/Statistic.h"

using namespace llvm;

#define DEBUG_TYPE "del-b"

STATISTIC(NumDelB, "Number of useless b deleted");

static cl::opt<bool> EnableDelB(
  "enable-loongarch-del-useless-b",
  cl::init(true),
  cl::desc("Delete useless b instructions: b 0."),
  cl::Hidden);

namespace {
  struct DelB : public MachineFunctionPass {
    static char ID;
    DelB(TargetMachine &tm)
      : MachineFunctionPass(ID) { }

    StringRef getPassName() const override {
      return "LoongArch Del Useless b";
    }

    bool runOnMachineBasicBlock(MachineBasicBlock &MBB, MachineBasicBlock &MBBN);
    bool runOnMachineFunction(MachineFunction &F) override {
      bool Changed = false;
      if (EnableDelB) {
        MachineFunction::iterator FJ = F.begin();
        if (FJ != F.end())
          FJ++;
        if (FJ == F.end())
          return Changed;
        for (MachineFunction::iterator FI = F.begin(), FE = F.end();
             FJ != FE; ++FI, ++FJ)
          // In STL style, F.end() is the dummy BasicBlock() like '\0' in 
          //  C string. 
          // FJ is the next BasicBlock of FI; When FI range from F.begin() to 
          //  the PreviousBasicBlock of F.end() call runOnMachineBasicBlock().
          Changed |= runOnMachineBasicBlock(*FI, *FJ);
      }
      return Changed;
    }

  };
  char DelB::ID = 0;
} // end of anonymous namespace

bool DelB::
runOnMachineBasicBlock(MachineBasicBlock &MBB, MachineBasicBlock &MBBN) {
  bool Changed = false;

  MachineBasicBlock::iterator I = MBB.end();
  if (I != MBB.begin())
    I--;	// set I to the last instruction
  else
    return Changed;
    
  if (I->getOpcode() == LoongArch::B && I->getOperand(0).getMBB() == &MBBN) {
    // I is the instruction of "b #offset=0", as follows,
    //     b	$BB0_3
    // $BB0_3:
    //     addi.w	$r4, $sp, 16;
    ++NumDelB;
    MBB.erase(I);	// delete the "B 0" instruction
    Changed = true;	// Notify LLVM kernel Changed
  }
  return Changed;

}

/// createLoongArchDelBPass - Returns a pass that DelB in LoongArch MachineFunctions
FunctionPass *llvm::createLoongArchDelBPass(LoongArchTargetMachine &tm) {
  return new DelB(tm);
}

