//===-- LoongArchISelLowering.cpp - LoongArch DAG Lowering Implementation -*- C++ -*-===//
//
// This file defines the interfaces that LoongArch uses to lower LLVM code into a
// selection DAG.
//
//===----------------------------------------------------------------------===//

#include "LoongArchISelLowering.h"

#include "LoongArchMachineFunctionInfo.h"
#include "LoongArchTargetMachine.h"
#include "LoongArchTargetObjectFile.h"
#include "LoongArchSubtarget.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegionInfo.h"
#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/IR/CallingConv.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

#define DEBUG_TYPE "loongarch-lower"

const char *LoongArchTargetLowering::getTargetNodeName(unsigned Opcode) const {
    switch (Opcode) {
        case LoongArchISD::JmpLink        :  return "LoongArchISD::JmpLink";
        case LoongArchISD::TailCall       :  return "LoongArchISD::TailCall";
        case LoongArchISD::Hi             :  return "LoongArchISD::Hi";
        case LoongArchISD::Lo             :  return "LoongArchISD::Lo";
        case LoongArchISD::GPRel          :  return "LoongArchISD::GPRel";
        case LoongArchISD::Ret            :  return "LoongArchISD::Ret";
        case LoongArchISD::EH_RETURN      :  return "LoongArchISD::EH_RETURN";
        case LoongArchISD::DivRem         :  return "LoongArchISD::DivRem";
        case LoongArchISD::DivRemU        :  return "LoongArchISD::DivRemU";
        case LoongArchISD::Wrapper        :  return "LoongArchISD::Wrapper";
        default                      :  return NULL;
    }
}

LoongArchTargetLowering::LoongArchTargetLowering(const LoongArchTargetMachine &TM, const LoongArchSubtarget &STI)
        : TargetLowering(TM), Subtarget(STI), ABI(TM.getABI()) {
    // Set .align 2,
    // It will emit .align 2 later
    setMinFunctionAlignment(Align(2));

   
}



const LoongArchTargetLowering *
LoongArchTargetLowering::create(const LoongArchTargetMachine &TM,
                           const LoongArchSubtarget &STI) {
    return createLoongArchSETargetLowering(TM, STI);
}
//===----------------------------------------------------------------------===//
// Lower Helper Functions
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Misc Lower Operation Implementation
//===----------------------------------------------------------------------===//

#include "LoongArchGenCallingConv.inc"

//===----------------------------------------------------------------------===//
// Formal Arguments Calling Convention Implementation
//===----------------------------------------------------------------------===//

// Transform physical registers into virtual registers and generate load
// operations for arguments places on the stack.
SDValue
LoongArchTargetLowering::LowerFormalArguments(SDValue Chain,
                                         CallingConv::ID CallConv, bool IsVarArg,
                                         const SmallVectorImpl<ISD::InputArg> &Ins,
                                         const SDLoc &DL, SelectionDAG &DAG,
                                         SmallVectorImpl<SDValue> &InVals)
const {
    return Chain;  // Leave empty temporary
}

//===----------------------------------------------------------------------===//
// Return Value Calling Convention Implementation
//===----------------------------------------------------------------------===//

SDValue
LoongArchTargetLowering::LowerReturn(SDValue Chain,
                                CallingConv::ID CallConv, bool IsVarArg,
                                const SmallVectorImpl<ISD::OutputArg> &Outs,
                                const SmallVectorImpl<SDValue> &OutsVals,
                                const SDLoc &DL, SelectionDAG &DAG) const {
    return DAG.getNode(LoongArchISD::Ret, DL, MVT::Other, Chain,
                       DAG.getRegister(LoongArch::RA, MVT::i32));
}