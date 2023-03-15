//===-- LoongArchISelLowering.cpp - LoongArch DAG Lowering Implementation -*- C++ -*-===//
//
// This file defines the interfaces that LoongArch uses to lower LLVM code into a
// selection DAG.
//
//===----------------------------------------------------------------------===//

#include "LoongArchISelLowering.h"

#include "MCTargetDesc/LoongArchBaseInfo.h"
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
        case LoongArchISD::Wrapper        :  return "LoongArchISD::Wrapper";
        case LoongArchISD::LA_GOT         :  return "LoongArchISD::LA_GOT";
        default                      :  return NULL;
    }
}

LoongArchTargetLowering::LoongArchTargetLowering(const LoongArchTargetMachine &TM, const LoongArchSubtarget &STI)
        : TargetLowering(TM), Subtarget(STI), ABI(TM.getABI()) {

/// Expand Operations - Operations not directly supported by LoongArch.
    setOperationAction(ISD::BR_JT,           MVT::Other, Expand);
    setOperationAction(ISD::BR_CC,           MVT::i32, Expand);
    setOperationAction(ISD::SELECT_CC,       MVT::i32, Expand);
    setOperationAction(ISD::SELECT_CC,       MVT::Other, Expand);
    setOperationAction(ISD::CTPOP,           MVT::i32, Expand);
    setOperationAction(ISD::CTTZ,            MVT::i32, Expand);
    setOperationAction(ISD::CTTZ_ZERO_UNDEF, MVT::i32, Expand);
    setOperationAction(ISD::CTLZ_ZERO_UNDEF, MVT::i32, Expand);

    setOperationAction(ISD::SIGN_EXTEND_INREG, MVT::i1 , Expand);
    setOperationAction(ISD::SIGN_EXTEND_INREG, MVT::i8 , Expand);
    setOperationAction(ISD::SIGN_EXTEND_INREG, MVT::i16 , Expand);
    setOperationAction(ISD::SIGN_EXTEND_INREG, MVT::i32 , Expand);
    setOperationAction(ISD::SIGN_EXTEND_INREG, MVT::Other , Expand);

    // Handle i64 shl
    setOperationAction(ISD::SHL_PARTS, MVT::i32, Expand);
    setOperationAction(ISD::SRA_PARTS, MVT::i32, Expand);
    setOperationAction(ISD::SRL_PARTS, MVT::i32, Expand);

/// Custom Operations
    //let llc know we have customized global address computation define
    setOperationAction(ISD::GlobalAddress, MVT::i32,   Custom);
    setOperationAction(ISD::BlockAddress,  MVT::i32,   Custom);
    setOperationAction(ISD::JumpTable,     MVT::i32,   Custom);
    setOperationAction(ISD::BRCOND,        MVT::Other, Custom);
    setOperationAction(ISD::SELECT,        MVT::i32,   Custom);

/// Promote Operations
    // Load extented operations for i1 types must be promoted
    for (MVT VT : MVT::integer_valuetypes()) {
        setLoadExtAction(ISD::EXTLOAD, VT, MVT::i1, Promote);
        setLoadExtAction(ISD::ZEXTLOAD, VT, MVT::i1, Promote);
        setLoadExtAction(ISD::SEXTLOAD, VT, MVT::i1, Promote);
    }


    // LoongArch does not have i1 type, so use i32 for setcc operations results.
    setBooleanContents(ZeroOrOneBooleanContent);
    setBooleanVectorContents(ZeroOrNegativeOneBooleanContent);



    // Used by legalize types to correctly generate the setcc result.
    // Without this, every float setcc comes with a AND/OR with the result,
    // we don't want this, since the fpcmp result goes to a flag register,
    // which is used implicitly by brcond and select operations.
    AddPromotedToType(ISD::SETCC, MVT::i1, MVT::i32);

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

EVT LoongArchTargetLowering::getSetCCResultType(const DataLayout &, LLVMContext &,
                                           EVT VT) const {
    if (!VT.isVector())
        return MVT::i32;
    return VT.changeVectorElementTypeToInteger();
}

SDValue LoongArchTargetLowering::LowerOperation(SDValue Op, SelectionDAG &DAG) const {
    switch (Op.getOpcode()) {
        case ISD::BRCOND:             return lowerBRCOND(Op, DAG);
        case ISD::GlobalAddress:      return lowerGlobalAddress(Op, DAG);
        case ISD::BlockAddress:       return lowerBlockAddress(Op, DAG);
        case ISD::JumpTable:          return lowerJumpTable(Op, DAG);
        case ISD::SELECT:             return lowerSELECT(Op, DAG);
    }
    return SDValue();
}
//===----------------------------------------------------------------------===//
// Lower Helper Functions
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Misc Lower Operation Implementation
//===----------------------------------------------------------------------===//
SDValue LoongArchTargetLowering::
lowerBRCOND(SDValue Op, SelectionDAG &DAG) const
{
    return Op;
}

SDValue LoongArchTargetLowering::
lowerSELECT(SDValue Op, SelectionDAG &DAG) const
{
    return Op;
}

SDValue LoongArchTargetLowering::lowerGlobalAddress(SDValue Op, SelectionDAG &DAG) const {
    SDLoc DL(Op);
    const LoongArchTargetObjectFile *TLOF =
            static_cast<const LoongArchTargetObjectFile *>(
                    getTargetMachine().getObjFileLowering());

    EVT Ty = Op.getValueType();
    GlobalAddressSDNode *N = cast<GlobalAddressSDNode>(Op);
    const GlobalValue *GV = N->getGlobal();
    const GlobalObject *GO = GV->getBaseObject();

    if (!isPositionIndependent()) {
        // %gp_rel relocation
        if (GO && TLOF->IsGlobalInSmallSection(GO, getTargetMachine())) {
            SDValue GA = DAG.getTargetGlobalAddress(GV, DL, MVT::i32, 0,
                                                    LoongArch::MO_GPREL);
            SDValue GPRelNode = DAG.getNode(LoongArchISD::GPRel, DL,
                                            DAG.getVTList(MVT::i32), GA);
            SDValue GPReg = DAG.getRegister(LoongArch::GP, MVT::i32);
            return DAG.getNode(ISD::ADD, DL, MVT::i32, GPReg, GPRelNode);
        }

        // %hi/%lo relocation
        return getAddrNonPIC(N, Ty, DAG);
    }

    if (GV->hasInternalLinkage() || (GV->hasLocalLinkage() && !isa<Function>(GV)))
        return getAddrLocal(N, Ty, DAG);

    //@large section
    if (GO && !TLOF->IsGlobalInSmallSection(GO, getTargetMachine()))
        return getAddrGlobalLargeGOT(
                N, Ty, DAG, LoongArch::MO_GOT_HI20, LoongArch::MO_GOT_LO12,
                DAG.getEntryNode(),
                MachinePointerInfo::getGOT(DAG.getMachineFunction()));
    return getAddrGlobal(
            N, Ty, DAG, LoongArch::MO_GOT, DAG.getEntryNode(),
            MachinePointerInfo::getGOT(DAG.getMachineFunction()));
}

SDValue LoongArchTargetLowering::lowerBlockAddress(SDValue Op,
                                              SelectionDAG &DAG) const {
    BlockAddressSDNode *N = cast<BlockAddressSDNode>(Op);
    EVT Ty = Op.getValueType();

    if (!isPositionIndependent())
        return getAddrNonPIC(N, Ty, DAG);

    return getAddrLocal(N, Ty, DAG);
}

SDValue LoongArchTargetLowering::
lowerJumpTable(SDValue Op, SelectionDAG &DAG) const
{
    JumpTableSDNode *N = cast<JumpTableSDNode>(Op);
    EVT Ty = Op.getValueType();

    if (!isPositionIndependent())
        return getAddrNonPIC(N, Ty, DAG);

    return getAddrLocal(N, Ty, DAG);
}

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

    MachineFunction &MF = DAG.getMachineFunction();
    MachineFrameInfo &MFI = MF.getFrameInfo();
    LoongArchMachineFunctionInfo *LoongArchFI = MF.getInfo<LoongArchMachineFunctionInfo>();

    LoongArchFI->setVarArgsFrameIndex(0);

    // Assign locations to all of the incoming arguments.
    SmallVector<CCValAssign, 16> ArgLocs;
    CCState CCInfo(CallConv, IsVarArg, DAG.getMachineFunction(),
                   ArgLocs, *DAG.getContext());
    LoongArchCC LoongArchCCInfo(CallConv, ABI.IsILP32S(),
                      CCInfo);

    LoongArchFI->setFormalArgInfo(CCInfo.getNextStackOffset(),
                             LoongArchCCInfo.hasByValArg());
    return Chain;
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

bool LoongArchTargetLowering::isOffsetFoldingLegal(
        const GlobalAddressSDNode *GA) const {
    // The LoongArch target isn't yet aware of offsets.
    return false;
}

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

SDValue LoongArchTargetLowering::getGlobalReg(SelectionDAG &DAG, EVT Ty) const {
    LoongArchMachineFunctionInfo *FI = DAG.getMachineFunction()
            .getInfo<LoongArchMachineFunctionInfo>();
    return DAG.getRegister(FI->getGlobalBaseReg(), Ty);
}

SDValue LoongArchTargetLowering::getTargetNode(GlobalAddressSDNode *N, EVT Ty,
                                          SelectionDAG &DAG,
                                          unsigned Flag) const {
    return DAG.getTargetGlobalAddress(N->getGlobal(), SDLoc(N), Ty, 0, Flag);
}

SDValue LoongArchTargetLowering::getTargetNode(ExternalSymbolSDNode *N, EVT Ty,
                                          SelectionDAG &DAG,
                                          unsigned Flag) const {
    return DAG.getTargetExternalSymbol(N->getSymbol(), Ty, Flag);
}

SDValue LoongArchTargetLowering::getTargetNode(BlockAddressSDNode *N, EVT Ty,
                                          SelectionDAG &DAG,
                                          unsigned Flag) const {
    return DAG.getTargetBlockAddress(N->getBlockAddress(), Ty, 0, Flag);
}

SDValue LoongArchTargetLowering::getTargetNode(JumpTableSDNode *N, EVT Ty,
                                          SelectionDAG &DAG,
                                          unsigned Flag) const {
    return DAG.getTargetJumpTable(N->getIndex(), Ty, Flag);
}

