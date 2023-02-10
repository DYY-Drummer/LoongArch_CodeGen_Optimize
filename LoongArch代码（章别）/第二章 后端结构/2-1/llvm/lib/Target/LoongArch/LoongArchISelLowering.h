//===-- LoongArchISelLowering.h - LoongArch DAG Lowering Interface --------*- C++ -*-===//
//

//
// This file defines the interfaces that LoongArch uses to lower LLVM IR code into a
// selection DAG.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHISELLOWERING_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHISELLOWERING_H

#include "MCTargetDesc/LoongArchABIInfo.h"
#include "LoongArch.h"
#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/CodeGen/TargetLowering.h"
#include "llvm/IR/Function.h"
#include <deque>

namespace llvm {
    namespace LoongArchISD {
        enum NodeType {
            // Start the numbering from where ISD NodeType finishes.
            FIRST_NUMBER = ISD::BUILTIN_OP_END,

            // Jump and link (call)
            JmpLink,

            // Tail call
            TailCall,

            // Get the Higher 16 bits from a 32-bit immediate
            // No relation with LoongArch Hi register
            Hi,

            // Get the Lower 16 bits from a 32-bit immediate
            // No relation with LoongArch Lo register
            Lo,

            // Handle gp_rel (small data/bss sections) relocation.
            GPRel,

            // Thread Pointer
            ThreadPointer,

            // Return
            Ret,

            EH_RETURN,

            // DivRem(u)
            DivRem,
            DivRemU,

            Wrapper,
            DynAlloc,

            Sync
        };
    } // End LoongArchISD namespace

//===----------------------------------------------------------------------===//
// TargetLowering Implementation
//===----------------------------------------------------------------------===//
    class LoongArchFunctionInfo;
    class LoongArchSubtarget;

    class LoongArchTargetLowering : public TargetLowering {
    public:
        explicit LoongArchTargetLowering(const LoongArchTargetMachine &TM,
                                    const LoongArchSubtarget &STI);

        static const LoongArchTargetLowering *create(const LoongArchTargetMachine &TM,
                                                const LoongArchSubtarget &STI);

        // This method returns the name of a target specific DAG node.
        const char *getTargetNodeName(unsigned Opcode) const override;

    protected:
        // Byval argument information.
        struct ByValArgInfo {
            unsigned FirstIdx;  // Index of the first register used.
            unsigned NumRegs;   // Number of registers used for this argument.
            unsigned Address;   // Offset of the stack area used to pass this argument.

            ByValArgInfo() : FirstIdx(0), NumRegs(0), Address(0) { }
        };

        // Subtarget Info
        const LoongArchSubtarget &Subtarget;
        // Cache the ABI from the TargetMachine, we use it everywhere.
        const LoongArchABIInfo &ABI;

    private:
        // Lower Operand specifics
        SDValue LowerGlobalAddress(SDValue Op, SelectionDAG &DAG) const;

        SDValue LowerFormalArguments(SDValue Chain,
                                     CallingConv::ID CallConv, bool IsVarArg,
                                     const SmallVectorImpl<ISD::InputArg> &Ins,
                                     const SDLoc &dl, SelectionDAG &DAG,
                                     SmallVectorImpl<SDValue> &InVals) const override;

        SDValue LowerReturn(SDValue Chain,
                            CallingConv::ID CallConv, bool IsVarArg,
                            const SmallVectorImpl<ISD::OutputArg> &Outs,
                            const SmallVectorImpl<SDValue> &OutVals,
                            const SDLoc &dl, SelectionDAG &DAG) const override;
    };

    const LoongArchTargetLowering *
    createLoongArchSETargetLowering(const LoongArchTargetMachine &TM,
                               const LoongArchSubtarget &STI);

} // End llvm namespace


#endif