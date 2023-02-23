//===-- LoongArchSEISelLowering.cpp - LoongArchSE DAG Lowering Interface --*- C++ -*-===//
//
// Subclass of LoongArchTargetLowering specialized for LoongArch32.
//
//===----------------------------------------------------------------------===//
#include "LoongArchMachineFunctionInfo.h"
#include "LoongArchISelLowering.h"
#include "LoongArchSEISelLowering.h"

#include "LoongArchRegisterInfo.h"
#include "LoongArchTargetMachine.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegionInfo.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/CodeGen/TargetInstrInfo.h"

using namespace llvm;

#define DEBUG_TYPE "loongarch-isel"

static cl::opt<bool>
        EnableLoongArchTailCalls("enable-loongarch-tail-calls", cl::Hidden,
                            cl::desc("LOONGARCH: Enable tail calls."),
                            cl::init(false));

LoongArchSETargetLowering::LoongArchSETargetLowering(const LoongArchTargetMachine &TM,
                                           const LoongArchSubtarget &STI)
        : LoongArchTargetLowering(TM, STI) {
    // Set up the register classes
    // GPRRegClass defined in LoongArchGenRegisterInfo.inc,
    // originally come from def GPR : RegisterClass in LoongArchRegisterInfo.td
    addRegisterClass(MVT::i32, &LoongArch::GPRRegClass);

    // Once all of the register classes are added, this allows us to compute
    // deirved properties we expose.
    computeRegisterProperties(Subtarget.getRegisterInfo());
}

SDValue LoongArchSETargetLowering::LowerOperation(SDValue Op,
                                             SelectionDAG &DAG) const {
    return LoongArchTargetLowering::LowerOperation(Op, DAG);
}

const LoongArchTargetLowering *
llvm::createLoongArchSETargetLowering(const LoongArchTargetMachine &TM,
                                 const LoongArchSubtarget &STI) {
    return new LoongArchSETargetLowering(TM, STI);
}