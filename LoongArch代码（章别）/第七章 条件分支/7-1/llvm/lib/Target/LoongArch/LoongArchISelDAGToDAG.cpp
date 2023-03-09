//===-- LoongArchISelDAGToDAG.cpp - A DAG to DAG Inst Selector for LoongArch -*- C++ -*-===//
//
// This file defines an instruction selector for the LoongArch target.
//
//===----------------------------------------------------------------------===//

#include "LoongArchISelDAGToDAG.h"
#include "LoongArch.h"

#include "LoongArchMachineFunctionInfo.h"
#include "LoongArchRegisterInfo.h"
#include "LoongArchSEISelDAGToDAG.h"
#include "LoongArchTargetMachine.h"

#include "llvm/CodeGen/MachineConstantPool.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
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

//===----------------------------------------------------------------------===//
// Instruction Selector Implementation
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// LOONGARCH specific code to select LOONGARCH machine instructions
// for SelectionDAG operations.
//===----------------------------------------------------------------------===//

bool LoongArchDAGToDAGISel::runOnMachineFunction(MachineFunction &MF) {
    bool Ret = SelectionDAGISel::runOnMachineFunction(MF);

    return Ret;
}

// Complex Pattern used on LoongArchInstrInfo
// Used on LoongArch Load/Store instructions
bool LoongArchDAGToDAGISel::SelectAddr(SDNode *Parent, SDValue Addr, SDValue &Base,
                                  SDValue &Offset) {
    EVT ValTy = Addr.getValueType();
    SDLoc DL(Addr);

    // If Parent is an unaligned f32 load or store, select a (base + index)
    // float point load/store instruction (luxcl or suxcl)
    const LSBaseSDNode *LS = 0;

    if (Parent && (LS = dyn_cast<LSBaseSDNode>(Parent))) {
        EVT VT = LS->getMemoryVT();

        if (VT.getSizeInBits() / 8 > LS->getAlignment()) {
            assert("Unaligned loads/stores not supported for this type.");
            if (VT == MVT::f32)
                return false;
        }
    }

    // If address is FI, get the TargetFrameIndex.
    if (FrameIndexSDNode *FIN = dyn_cast<FrameIndexSDNode>(Addr)) {
        Base = CurDAG->getTargetFrameIndex(FIN->getIndex(), ValTy);
        Offset = CurDAG->getTargetConstant(0, DL, ValTy);
        return true;
    }

    // on PIC code Load GA
    if (Addr.getOpcode() == LoongArchISD::Wrapper) {
        Base = Addr.getOperand(0);
        Offset = Addr.getOperand(1);
        return true;
    }

    // static
    if (TM.getRelocationModel() != Reloc::PIC_) {
        if ((Addr.getOpcode() == ISD::TargetExternalSymbol ||
             Addr.getOpcode() == ISD::TargetGlobalAddress))
            return false;
    }

    // adderss of base + const or fi + const
    if (CurDAG->isBaseWithConstantOffset(Addr)) {
        ConstantSDNode *CN = dyn_cast<ConstantSDNode>(Addr.getOperand(1));
        if (isInt<12>(CN->getSExtValue())) {
            // If the first operand is a FI, get the TargetFI Node
            if (FrameIndexSDNode *FIN = dyn_cast<FrameIndexSDNode>(Addr.getOperand(0)))
                Base = CurDAG->getTargetFrameIndex(FIN->getIndex(), ValTy);
            else
                Base = Addr.getOperand(0);

            Offset = CurDAG->getTargetConstant(CN->getZExtValue(), DL, ValTy);
            return true;
        }
    }

    Base = Addr;
    Offset = CurDAG->getTargetConstant(0, DL, ValTy);
    return true;
}

// Select instructions not customized!
// Used for expended, promoted and normal instructions
void LoongArchDAGToDAGISel::Select(SDNode *Node) {
    unsigned Opcode = Node->getOpcode();

    // Dump information about the Node being selected
    LLVM_DEBUG(errs() << "Selecting: "; Node->dump(CurDAG); errs() << "\n");

    // If we have a custom node, we already have selected.
    if (Node->isMachineOpcode()) {
        LLVM_DEBUG(errs() << "== "; Node->dump(CurDAG); errs() << "\n");
        Node->setNodeId(-1);
        return;
    }

    // See if subclasses (e.g. SEISelDAGToDAG) can handle this node.
    if (trySelect(Node))
        return;

    switch(Opcode) {
        default: break;
        // Get target GOT address.
        case ISD::GLOBAL_OFFSET_TABLE:
            ReplaceNode(Node, getGlobalBaseReg());
            return;
    }

    // Select the default instruction defined in LoongArchGenDAGISel.inc
    SelectCode(Node);
}

// Output the instructions required to put the GOT address into a register.
SDNode *LoongArchDAGToDAGISel::getGlobalBaseReg() {
    unsigned GlobalBaseReg = MF->getInfo<LoongArchMachineFunctionInfo>()->getGlobalBaseReg();
    return CurDAG->getRegister(GlobalBaseReg, getTargetLowering()->getPointerTy(
                    CurDAG->getDataLayout()))
            .getNode();
}