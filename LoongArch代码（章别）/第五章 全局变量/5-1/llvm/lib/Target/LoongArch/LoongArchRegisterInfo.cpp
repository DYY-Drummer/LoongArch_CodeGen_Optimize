//===-- LoongArchRegisterInfo.cpp - LOONGARCH Register Information -== --------------===//
//
// This file contains the LOONGARCH implementation of the TargetRegisterInfo class.
//
//===----------------------------------------------------------------------===//

#include "LoongArchRegisterInfo.h"

#include "LoongArch.h"
#include "LoongArchSubtarget.h"
#include "LoongArchMachineFunctionInfo.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

#define GET_REGINFO_TARGET_DESC
#include "LoongArchGenRegisterInfo.inc"

#define DEBUG_TYPE "loongarch-reg-info"

using namespace llvm;

LoongArchRegisterInfo::LoongArchRegisterInfo(const LoongArchSubtarget &ST)
        : LoongArchGenRegisterInfo(LoongArch::RA), Subtarget(ST) {}

//===----------------------------------------------------------------------===//
// Callee Saved Registers methods
//===----------------------------------------------------------------------===//
/// LoongArch Callee Saved Registers
// CSR_ILP32S_LP64S Callee Saved Registers,In LoongArchCallingConv.td
// def CSR_ILP32S_LP64S: CalleeSavedRegs<(add RA, FP, (sequence "S%u", 0, 8))>;
// llc create CSR_ILP32S_LP64S_SaveList and CSR_ILP32S_LP64S_RegMask from above defined.
const MCPhysReg *
LoongArchRegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
    return CSR_ILP32S_LP64S_SaveList;
}

const uint32_t *
LoongArchRegisterInfo::getCallPreservedMask(const MachineFunction &MF,
                                       CallingConv::ID) const {
    return CSR_ILP32S_LP64S_RegMask;
}

BitVector LoongArchRegisterInfo::
getReservedRegs(const MachineFunction &MF) const {
    static const uint16_t ReservedCPURegs[] = {
            LoongArch::ZERO, LoongArch::TP, LoongArch::SP, LoongArch::FP, LoongArch::R21, LoongArch::PC
    };
    BitVector Reserved(getNumRegs());

    for (unsigned I = 0; I < array_lengthof(ReservedCPURegs); ++I)
        Reserved.set(ReservedCPURegs[I]);

#ifdef ENABLE_GPRESTORE
    const LoongArchMachineFunctionInfo *LoongArchFI = MF.getInfo<LoongArchMachineFunctionInfo>();
    // Reserve GP if globalBaseRegFixed()
    if (LoongArchFI->globalBaseRegFixed())
#endif
        Reserved.set(LoongArch::GP);
    return Reserved;
}

//- If no eliminateFrameIndex(), it will hang on run.
// FrameIndex represent objects inside a abstract stack.
// We must replace FrameIndex with an stack/frame pointer
// direct reference.
void LoongArchRegisterInfo::
eliminateFrameIndex(MachineBasicBlock::iterator II, int SPAdj,
                    unsigned FIOperandNum, RegScavenger *RS) const {
    MachineInstr &MI = *II;
    MachineFunction &MF = *MI.getParent()->getParent();
    MachineFrameInfo &MFI = MF.getFrameInfo();
    LoongArchMachineFunctionInfo *LoongArchFI = MF.getInfo<LoongArchMachineFunctionInfo>();

    unsigned i = 0;
    while (!MI.getOperand(i).isFI()) {
        ++i;
        assert(i < MI.getNumOperands() &&
               "Instr doesn't have FrameIndex operand!");
    }

    LLVM_DEBUG(errs() << "\nFunction : " << MF.getFunction().getName() << "\n";
    errs() << "<---------->\n" << MI);

    int FrameIndex = MI.getOperand(i).getIndex();
    uint64_t stackSize = MF.getFrameInfo().getStackSize();
    int64_t spOffset = MF.getFrameInfo().getObjectOffset(FrameIndex);

    LLVM_DEBUG(errs() << "FrameIndex : " << FrameIndex << "\n"
                      << "spOffset   : " << spOffset   << "\n"
                      << "stackSize  : " << stackSize  << "\n");

    const std::vector<CalleeSavedInfo> &CSI = MFI.getCalleeSavedInfo();
    int MinCSFI = 0;
    int MaxCSFI = -1;

    if (CSI.size()) {
        MinCSFI = CSI[0].getFrameIdx();
        MaxCSFI = CSI[CSI.size() - 1].getFrameIdx();
    }

    // The following stack frame objects are always referenced relative to $sp:
    //  1. Outgoing arguments.
    //  2. Pointer to dynamically allocated stack space.
    //  3. Locations for callee-saved registers.
    // Everything else is referenced relative to whatever register
    // getFrameRegister() returns.
    unsigned FrameReg;

    FrameReg = LoongArch::SP;

    // Calculate final offset.
    // There is no need to change the offset if the frame object is one of the
    // following: an outgoing argument, pointer to a dynamically allocated
    // stack space or a $gp restore location,
    // If the frame object is any of the following, its offset must be adjusted
    // by adding the size of the stack: incoming argument, callee-saved register
    // location or local variable.
    int64_t Offset;
    Offset = spOffset + (int64_t)stackSize;

    Offset += MI.getOperand(i+1).getImm();

    LLVM_DEBUG(errs() << "Offset : " << Offset << "\n"
                      << "<---------->\n");

    // If MI is not a debug value, make sure Offset fits in the 12-bit immediate
    // field.
    if (!MI.isDebugValue() && !isInt<12>(Offset)) {
        assert("(!MI.isDebugValue() && !isInt<12>(Offset))");
    }

    MI.getOperand(i).ChangeToRegister(FrameReg, false);
    MI.getOperand(i+1).ChangeToImmediate(Offset);
}

bool
LoongArchRegisterInfo::requiresRegisterScavenging(const MachineFunction &MF) const {
    return true;
}

bool
LoongArchRegisterInfo::trackLivenessAfterRegAlloc(const MachineFunction &MF) const {
    return true;
}

// pure virtual method
Register LoongArchRegisterInfo::
getFrameRegister(const MachineFunction &MF) const {
    const TargetFrameLowering *TFI = MF.getSubtarget().getFrameLowering();
    return TFI->hasFP(MF) ? (LoongArch::FP) :
           (LoongArch::SP);
}