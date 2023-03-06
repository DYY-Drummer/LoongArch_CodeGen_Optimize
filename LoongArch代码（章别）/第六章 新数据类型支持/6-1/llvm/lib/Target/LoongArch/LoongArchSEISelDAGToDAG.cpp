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

void LoongArchSEDAGToDAGISel::selectAddESubE(unsigned MOp, SDValue InFlag,
                                        SDValue CmpLHS, const SDLoc &DL,
                                        SDNode *Node) const {
    unsigned Opc = InFlag.getOpcode();
    assert(((Opc == ISD::ADDC || Opc == ISD::ADDE) ||
            (Opc == ISD::SUBC || Opc == ISD::SUBE)) &&
           "(ADD|SUB)E flag operand must come from (ADD|SUB)C/E insn");

    SDValue Ops[] = { CmpLHS, InFlag.getOperand(1) };
    SDValue LHS = Node->getOperand(0), RHS = Node->getOperand(1);
    EVT VT = LHS.getValueType();

    SDNode *Carry;

    assert(Subtarget->hasLoongArch32() && "Only support loongarch32 Now!");
    Carry = CurDAG->getMachineNode(LoongArch::SLTU, DL, VT, Ops);

    SDNode *AddCarry = CurDAG->getMachineNode(LoongArch::ADD_W, DL, VT,
                                              SDValue(Carry, 0), RHS);

    SDValue Operands[3] = {LHS, RHS, SDValue(AddCarry, 0)};
    CurDAG->SelectNodeTo(Node, MOp, VT, MVT::Glue, Operands);
}

bool LoongArchSEDAGToDAGISel::trySelect(SDNode *Node) {
    unsigned Opcode = Node->getOpcode();
    SDLoc DL(Node);

    // Instruction Selection not handled by the auto-generated
    // tablegen selection should be handled here.

    EVT NodeTy = Node->getValueType(0);
    unsigned MultOpc;

    switch(Opcode) {
        default: break;
        case ISD::SUBE: {
            SDValue InFlag = Node->getOperand(2);
            selectAddESubE(LoongArch::SUB_W, InFlag, InFlag.getOperand(0), DL, Node);
            return true;
        }
        case ISD::ADDE: {
            SDValue InFlag = Node->getOperand(2);
            selectAddESubE(LoongArch::ADD_W, InFlag, InFlag.getOperand(0), DL, Node);
            return true;
        }
        // multiply instruction which has two results (LO and HI part respectively)
        case ISD::SMUL_LOHI:
        case ISD::UMUL_LOHI: {
            MultOpc = (Opcode == ISD::UMUL_LOHI ? LoongArch::MULH_WU : LoongArch::MULH_W);
            SDNode *Lo = 0, *Hi = 0;

            Lo = CurDAG->getMachineNode(LoongArch::MUL_W, DL, NodeTy, Node->getOperand(0), Node->getOperand(1));

            Hi = CurDAG->getMachineNode(MultOpc, DL, NodeTy, Node->getOperand(0), Node->getOperand(1));

            std::pair<SDNode*, SDNode*> LoHi = std::make_pair(Lo, Hi);

            if (!SDValue(Node, 0).use_empty())
                ReplaceUses(SDValue(Node, 0), SDValue(LoHi.first, 0));

            if (!SDValue(Node, 1).use_empty())
                ReplaceUses(SDValue(Node, 1), SDValue(LoHi.second, 0));

            CurDAG->RemoveDeadNode(Node);
            return true;
        }
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