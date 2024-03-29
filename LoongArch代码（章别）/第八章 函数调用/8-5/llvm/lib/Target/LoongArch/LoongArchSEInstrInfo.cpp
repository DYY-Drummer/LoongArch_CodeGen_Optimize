//===-- LoongArchSEInstrInfo.cpp - LoongArch32/64 Instruction Information -----------===//
//
//
// This file contains the LoongArch32/64 implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

#include "LoongArchSEInstrInfo.h"

#include "LoongArchMachineFunctionInfo.h"
#include "LoongArchTargetMachine.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

LoongArchSEInstrInfo::LoongArchSEInstrInfo(const LoongArchSubtarget &STI)
        : LoongArchInstrInfo(STI),
          RI(STI) {}

const LoongArchRegisterInfo &LoongArchSEInstrInfo::getRegisterInfo() const {
    return RI;
}

// ORI $Dest, $ZERO, $SRC
void LoongArchSEInstrInfo::copyPhysReg(MachineBasicBlock &MBB,
                                  MachineBasicBlock::iterator I,
                                  const DebugLoc &DL, MCRegister DestReg,
                                  MCRegister SrcReg, bool KillSrc) const {
    unsigned Opc = 0, ZeroReg = 0;

    if (LoongArch::GPRRegClass.contains(DestReg)) { // Copy to CPU Reg.
        if (LoongArch::GPRRegClass.contains(SrcReg))
            Opc = LoongArch::ORI, ZeroReg = LoongArch::ZERO;
    }
    else if (LoongArch::GPRRegClass.contains(SrcReg)) { // Copy from CPU Reg.
       // Leave empty for now
    }

    assert(Opc && "Cannot copy registers");

    MachineInstrBuilder MIB = BuildMI(MBB, I, DL, get(Opc));

    if (DestReg)
        MIB.addReg(DestReg, RegState::Define);

    if (ZeroReg)
        MIB.addReg(ZeroReg);

    if (SrcReg)
        MIB.addReg(SrcReg, getKillRegState(KillSrc));
}

bool LoongArchSEInstrInfo::expandPostRAPseudo(MachineInstr &MI) const {
    MachineBasicBlock &MBB = *MI.getParent();

    switch(MI.getDesc().getOpcode()) {
        default:
            return false;
        case LoongArch::RetRA:
            expandRetRA(MBB, MI);
            break;
        case LoongArch::JARA:
            expandJARA(MBB, MI);
            break;
    }

    MBB.erase(MI);
    return true;
}


void LoongArchSEInstrInfo::
storeRegToStack(MachineBasicBlock &MBB, MachineBasicBlock::iterator I,
                unsigned SrcReg, bool isKill, int FI,
                const TargetRegisterClass *RC, const TargetRegisterInfo *TRI,
                int64_t Offset) const {
    DebugLoc DL;
    MachineMemOperand *MMO = GetMemOperand(MBB, FI, MachineMemOperand::MOStore);

    unsigned Opc = 0;

    Opc = LoongArch::ST_W;
    assert(Opc && "Register class not handled!");
    BuildMI(MBB, I, DL, get(Opc)).addReg(SrcReg, getKillRegState(isKill))
            .addFrameIndex(FI).addImm(Offset).addMemOperand(MMO);
}

void LoongArchSEInstrInfo::
loadRegFromStack(MachineBasicBlock &MBB, MachineBasicBlock::iterator I,
                 unsigned DestReg, int FI, const TargetRegisterClass *RC,
                 const TargetRegisterInfo *TRI, int64_t Offset) const {
    DebugLoc DL;
    if (I != MBB.end()) DL = I->getDebugLoc();
    MachineMemOperand *MMO = GetMemOperand(MBB, FI, MachineMemOperand::MOLoad);
    unsigned Opc = 0;

    Opc = LoongArch::LD_W;
    assert(Opc && "Register class not handled!");
    BuildMI(MBB, I, DL, get(Opc), DestReg).addFrameIndex(FI).addImm(Offset)
            .addMemOperand(MMO);
}


// Adjust SP by Amount bytes.
void LoongArchSEInstrInfo::adjustStackPtr(unsigned SP, int64_t Amount,
                                     MachineBasicBlock &MBB,
                                     MachineBasicBlock::iterator I) const {
    DebugLoc DL = I != MBB.end() ? I->getDebugLoc() : DebugLoc();
    unsigned ADD_W = LoongArch::ADD_W;
    unsigned ADDI_W = LoongArch::ADDI_W;

    if (isInt<12>(Amount)) {
        // addi.w sp, sp, amount
        BuildMI(MBB, I, DL, get(ADDI_W), SP).addReg(SP).addImm(Amount);
    }
    else { // Expand immediate that doesn't fit in 12-bit.
        unsigned Reg = loadImmediate(Amount, MBB, I, DL, nullptr);
        BuildMI(MBB, I, DL, get(ADD_W), SP).addReg(SP).addReg(Reg, RegState::Kill);
    }
}

// This function generates the sequence of instructions needed to get the
// result of adding register REG and immediate IMM.
unsigned LoongArchSEInstrInfo::loadImmediate(int64_t Imm, MachineBasicBlock &MBB,
                                        MachineBasicBlock::iterator II,
                                        const DebugLoc &DL,
                                        unsigned *NewImm) const {
    LoongArchAnalyzeImmediate AnalyzeImm;
    unsigned Size = 32;
    unsigned LUi = LoongArch::LU12I_W;
    unsigned ZEROReg = LoongArch::ZERO;
    unsigned R21Reg = LoongArch::R21;
    bool LastInstrIsADDI_W = NewImm;

    const LoongArchAnalyzeImmediate::InstSeq &Seq =
            AnalyzeImm.Analyze(Imm, Size, LastInstrIsADDI_W);
    LoongArchAnalyzeImmediate::InstSeq::const_iterator Inst = Seq.begin();

    assert(Seq.size() && (!LastInstrIsADDI_W || (Seq.size() > 1)));

    // The first instruction can be a LUi, which is different from other
    // instructions (ADDI_W, ORI and SLL) in that it does not have a register
    // operand.
    if (Inst->Opc == LUi)
        BuildMI(MBB, II, DL, get(LUi), R21Reg).addImm(SignExtend64<20>(Inst->ImmOperand));
    else
        BuildMI(MBB, II, DL, get(Inst->Opc), R21Reg).addReg(ZEROReg)
                .addImm(SignExtend64<12>(Inst->ImmOperand));

    // Build the remaining instructions in Seq.
    for (++Inst; Inst != Seq.end() - LastInstrIsADDI_W; ++Inst)
        BuildMI(MBB, II, DL, get(Inst->Opc), R21Reg).addReg(R21Reg)
                .addImm(SignExtend64<12>(Inst->ImmOperand));

    if (LastInstrIsADDI_W)
        *NewImm = Inst->ImmOperand;

    return R21Reg;
}

void LoongArchSEInstrInfo::expandRetRA(MachineBasicBlock &MBB,
                                  MachineBasicBlock::iterator I) const {
    BuildMI(MBB, I, I->getDebugLoc(), get(LoongArch::RET)).addReg(LoongArch::RA);
}

void LoongArchSEInstrInfo::expandJARA(MachineBasicBlock &MBB,
                                       MachineBasicBlock::iterator I) const {
    BuildMI(MBB, I, I->getDebugLoc(), get(LoongArch::JIRL),(unsigned)LoongArch::RA).addReg(LoongArch::T7).addImm(0);
}

/// getOppositeBranchOpc - Return the inverse of the specified
/// opcode, e.g. turning BEQ to BNE.
unsigned LoongArchSEInstrInfo::getOppositeBranchOpc(unsigned Opc) const {
    switch (Opc) {
        default:           llvm_unreachable("Illegal opcode!");
        case LoongArch::BEQ:    return LoongArch::BNE;
        case LoongArch::BNE:    return LoongArch::BEQ;
        case LoongArch::BLT:    return LoongArch::BGE;
        case LoongArch::BGE:    return LoongArch::BLT;
        case LoongArch::BLTU:    return LoongArch::BGEU;
        case LoongArch::BGEU:    return LoongArch::BLTU;
    }
}

const LoongArchInstrInfo *llvm::createLoongArchSEInstrInfo(const LoongArchSubtarget &STI) {
    return new LoongArchSEInstrInfo(STI);
}