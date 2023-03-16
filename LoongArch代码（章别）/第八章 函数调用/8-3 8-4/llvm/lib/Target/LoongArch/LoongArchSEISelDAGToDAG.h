//===-- LoongArchSEISelDAGToDAG.h - A DAG to DAG Inst Selector for LoongArchSE -*- C++ -*-===//
//
// Subclass of LoongArchDAGToDAGISel specialized for loongarch32.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHSEISELDAGTODAG_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHSEISELDAGTODAG_H

#include "LoongArchISelDAGToDAG.h"

namespace llvm {

class LoongArchSEDAGToDAGISel : public LoongArchDAGToDAGISel {
public:
  explicit LoongArchSEDAGToDAGISel(LoongArchTargetMachine &TM, CodeGenOpt::Level OL)
      : LoongArchDAGToDAGISel(TM, OL) { }

private:

  bool runOnMachineFunction(MachineFunction &MF) override;

  void selectAddESubE(unsigned MOp, SDValue InFlag, SDValue CmpLHS,
                      const SDLoc &DL, SDNode *Node) const;

  bool trySelect(SDNode *Node) override;

  void processFunctionAfterISel(MachineFunction &MF) override;
};

// Create new instr selector, called in LoongArchTargetMachine.cpp for registrary pass
FunctionPass *createLoongArchSEISelDAG(LoongArchTargetMachine &TM,
                                  CodeGenOpt::Level OptLevel);

} // end of llvm namespace

#endif