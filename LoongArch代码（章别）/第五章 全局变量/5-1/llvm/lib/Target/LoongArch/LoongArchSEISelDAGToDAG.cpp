//===-- LoongArchSEISelDAGToDAG.cpp - A DAG to DAG Inst Selector for LoongArchSE -*-C++ -*-===//
//
// Subclass of LoongArchDAGToDAGISel specialized for loongarch32.
//
//===----------------------------------------------------------------------===//

#include "LoongArchSEISelDAGToDAG.h"

#include "MCTargetDesc/LoongArchBaseInfo.h"
#include "LoongArch.h"
#include "LoongArchMachineFunctionInfo.h"
#include "LoongArchRegisterInfo.h"

#include "llvm/CodeGen/MachineConstantPool.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/SelectionDAGNodes.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetMachine.h"

using namespace llvm;

#define DEBUG_TYPE "loongarch-isel"

bool LoongArchSEDAGToDAGISel::runOnMachineFunction(MachineFunction &MF) {
    Subtarget = &static_cast<const LoongArchSubtarget &>(MF.getSubtarget());
    return LoongArchDAGToDAGISel::runOnMachineFunction(MF);
}

void LoongArchSEDAGToDAGISel::processFunctionAfterISel(MachineFunction &MF) {
}

bool LoongArchSEDAGToDAGISel::trySelect(SDNode *Node) {
    unsigned Opcode = Node->getOpcode();
    SDLoc DL(Node);

    // Instruction Selection not handled by the auto-generated
    // tablegen selection should be handled here.

    switch(Opcode) {
        default: break;
        case ISD::Constant: {
            const ConstantSDNode *CN = dyn_cast<ConstantSDNode>(Node);
            unsigned Size = CN->getValueSizeInBits(0);

            if (Size == 32)
                break;

            return true;
        }
    }

    return false;
}

FunctionPass *llvm::createLoongArchSEISelDAG(LoongArchTargetMachine &TM,
                                        CodeGenOpt::Level OptLevel) {
    return new LoongArchSEDAGToDAGISel(TM, OptLevel);
}