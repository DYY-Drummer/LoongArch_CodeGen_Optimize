//===-- LoongArchMachineFunctionInfo.h - Private data used for LoongArch --*- C++ -*-===//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHMACHINEFUNCTIONINFO_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHMACHINEFUNCTIONINFO_H

#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineMemOperand.h"
#include "llvm/CodeGen/PseudoSourceValue.h"
#include "llvm/CodeGen/TargetFrameLowering.h"
#include "llvm/Target/TargetMachine.h"
#include <map>

namespace llvm {
    // This class is derived from MachineFunction private LoongArch target-specific
    // information for each MachineFunction.
    class LoongArchMachineFunctionInfo : public MachineFunctionInfo {
    public:
        LoongArchMachineFunctionInfo(MachineFunction &MF)
                : MF(MF), VarArgsFrameIndex(0), MaxCallFrameSize(0) { }

        ~LoongArchMachineFunctionInfo();

        int getVarArgsFrameIndex() const { return VarArgsFrameIndex; }
        void setVarArgsFrameIndex(int Index) { VarArgsFrameIndex = Index; }

        bool getEmitNOAT() const { return EmitNOAT; }
        void setEmitNOAT() { EmitNOAT = true; }
    private:
        virtual void anchor();

        MachineFunction &MF;

        // Frame index for start of varargs area
        int VarArgsFrameIndex;

        unsigned MaxCallFrameSize;

        bool EmitNOAT;
    };
} // End llvm namespace
#endif