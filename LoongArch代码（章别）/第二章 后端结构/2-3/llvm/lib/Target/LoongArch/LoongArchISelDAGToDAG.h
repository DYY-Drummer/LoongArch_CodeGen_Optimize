//===-- LoongArchISelDAGToDAG.h - A DAG to DAG Inst Selector for LoongArch -*- C++ -*-===//
//
// This file defines an instruction selector for the LOONGARCH target.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHISELDAGTODAG_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHISELDAGTODAG_H

#include "LoongArch.h"
#include "LoongArchSubtarget.h"
#include "LoongArchTargetMachine.h"

#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/Debug.h"

//===----------------------------------------------------------------------===//
// Instruction Selector Implementation
//===----------------------------------------------------------------------===//
// LoongArchDAGToDAGISel - LOONGARCH specific code to select LOONGARCH machine
// instructions for SelectionDAG operations.
namespace llvm {
    class LoongArchDAGToDAGISel : public SelectionDAGISel {
    public:
        explicit LoongArchDAGToDAGISel(LoongArchTargetMachine &TM, CodeGenOpt::Level OL)
                : SelectionDAGISel(TM, OL), Subtarget(nullptr) { }

        StringRef getPassName() const override {
            return "LOONGARCH DAG to DAG Pattern Instruction Selection";
        }

        bool runOnMachineFunction(MachineFunction &MF) override;

    protected:

        // Keep a pointer to the LoongArchSubtarget around so that we can make the right
        // decision when generating code for different targets.
        const LoongArchSubtarget *Subtarget;

    private:
        // Include the pieces autogenerated from the target description.
#include "LoongArchGenDAGISel.inc"

        // Return a reference to the TargetMachine, casted to the target-specific type.
        const LoongArchTargetMachine &getTargetMachine() {
            return static_cast<const LoongArchTargetMachine &>(TM);
        }

        void Select(SDNode *N) override;

        virtual bool trySelect(SDNode *Node) = 0;

        // Complex Pattern
        bool SelectAddr(SDNode *Parent, SDValue N, SDValue &Base, SDValue &Offset);

        // Return a target constant with the specified value.
        inline SDValue getImm(const SDNode *Node, unsigned Imm) {
            return CurDAG->getTargetConstant(Imm, SDLoc(Node), Node->getValueType(0));
        }

        virtual void processFunctionAfterISel(MachineFunction &MF) = 0;
    };

} // end of llvm namespace

#endif