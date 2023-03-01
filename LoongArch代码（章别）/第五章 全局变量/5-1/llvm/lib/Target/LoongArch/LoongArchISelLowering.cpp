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

    setOperationAction(ISD::SIGN_EXTEND_INREG, MVT::i1 , Expand);
    setOperationAction(ISD::SIGN_EXTEND_INREG, MVT::i8 , Expand);
    setOperationAction(ISD::SIGN_EXTEND_INREG, MVT::i16 , Expand);
    setOperationAction(ISD::SIGN_EXTEND_INREG, MVT::i32 , Expand);
    setOperationAction(ISD::SIGN_EXTEND_INREG, MVT::Other , Expand);




    // It will emit ".p2align 3"
    // 3 means 2^3 bytes = 8 bytes
    // if alignment is not power of 2, llc command will fail.
    setMinFunctionAlignment(Align(8));

   
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
    // CCValAssign represent the assignment of the return value to a location
    SmallVector<CCValAssign, 16> RVLocs;
    MachineFunction &MF = DAG.getMachineFunction();

    // CCState represent the info about the registers and stack slot.
    CCState CCInfo(CallConv, IsVarArg, MF, RVLocs, *DAG.getContext());
    LoongArchCC LoongArchCCInfo(CallConv, ABI.IsILP32S(), CCInfo);
    // Analysis return values.
    LoongArchCCInfo.analyzeReturn(Outs, Subtarget.abiUsesSoftFloat(),
                             MF.getFunction().getReturnType());

    SDValue Flag;
    SmallVector<SDValue, 4> RetOps(1, Chain);

    // Copy the result values into the output registers.
    for (unsigned i = 0; i != RVLocs.size(); ++i) {
        SDValue Val = OutsVals[i];
        CCValAssign &VA = RVLocs[i];
        assert(VA.isRegLoc() && "Can only return in registers!");

        if (RVLocs[i].getValVT() != RVLocs[i].getLocVT())
            Val = DAG.getNode(ISD::BITCAST, DL, RVLocs[i].getLocVT(), Val);

        Chain = DAG.getCopyToReg(Chain, DL, VA.getLocReg(), Val, Flag);

        // Guarantee that all emitted copies are stuck together with flags.
        Flag = Chain.getValue(1);
        RetOps.push_back(DAG.getRegister(VA.getLocReg(), VA.getLocVT()));
    }

    // The LoongArch ABIs for returning structs by value requires that we copy the
    // sret argument into $RA for the return. We saved the argument into
    // a virtual register in the entry block, so now we copy the value out
    // and into $RA.
    if (MF.getFunction().hasStructRetAttr()) {
        LoongArchMachineFunctionInfo *LoongArchFI = MF.getInfo<LoongArchMachineFunctionInfo>();
        unsigned Reg = LoongArchFI->getSRetReturnReg();

        if (!Reg)
            llvm_unreachable("sret virtual register not created in the entry block");
        SDValue Val = DAG.getCopyFromReg(Chain, DL, Reg,
                                         getPointerTy(DAG.getDataLayout()));
        unsigned A0 = LoongArch::A0;

        Chain = DAG.getCopyToReg(Chain, DL, A0, Val, Flag);
        Flag = Chain.getValue(1);
        RetOps.push_back(DAG.getRegister(A0, getPointerTy(DAG.getDataLayout())));
    }

    RetOps[0] = Chain;    // Update chain.

    // Add the flag if we have it.
    if (Flag.getNode())
        RetOps.push_back(Flag);

    // Return on LoongArch is always a "ret $lr"
    return DAG.getNode(LoongArchISD::Ret, DL, MVT::Other, RetOps);
}

LoongArchTargetLowering::LoongArchCC::LoongArchCC(
        CallingConv::ID CC, bool IsILP32S_, CCState &Info,
        LoongArchCC::SpecialCallingConvType SpecialCallingConv_)
        : CCInfo(Info), CallConv(CC), IsILP32S(IsILP32S_) {
    // Pre-allocate reserved argument area.
    CCInfo.AllocateStack(reservedArgArea(), 1);
}

//===----------------------------------------------------------------------===//
// Methods implement for CallingConv
//===----------------------------------------------------------------------===//

template<typename Ty>
void LoongArchTargetLowering::LoongArchCC::
analyzeReturn(const SmallVectorImpl<Ty> &RetVals, bool IsSoftFloat,
              const SDNode *CallNode, const Type *RetTy) const {
    CCAssignFn *Fn;

    Fn = RetCC_LoongArch;

    for (unsigned I = 0, E = RetVals.size(); I < E; ++I) {
        MVT VT = RetVals[I].VT;
        ISD::ArgFlagsTy Flags = RetVals[I].Flags;
        MVT RegVT = this->getRegVT(VT, RetTy, CallNode, IsSoftFloat);

        if (Fn(I, VT, RegVT, CCValAssign::Full, Flags, this->CCInfo)) {
#ifndef NDEBUG
            dbgs() << "Call result #" << I << " has unhandled type "
                   << EVT(VT).getEVTString() << '\n';
#endif
            llvm_unreachable(nullptr);
        }
    }
}

void LoongArchTargetLowering::LoongArchCC::
analyzeCallResult(const SmallVectorImpl<ISD::InputArg> &Ins, bool IsSoftFloat,
                  const SDNode *CallNode, const Type *RetTy) const {
    analyzeReturn(Ins, IsSoftFloat, CallNode, RetTy);
}
void LoongArchTargetLowering::LoongArchCC::
analyzeReturn(const SmallVectorImpl<ISD::OutputArg> &Outs, bool IsSoftFloat,
              const Type *RetTy) const {
    analyzeReturn(Outs, IsSoftFloat, nullptr, RetTy);
}

unsigned LoongArchTargetLowering::LoongArchCC::reservedArgArea() const {
    return (IsILP32S && (CallConv != CallingConv::Fast)) ? 8 : 0;
}

MVT LoongArchTargetLowering::LoongArchCC::getRegVT(MVT VT, const Type *OrigTy,
                                         const SDNode *CallNode,
                                         bool IsSoftFloat) const {
    if (IsSoftFloat || IsILP32S)
        return VT;

    return VT;
}
