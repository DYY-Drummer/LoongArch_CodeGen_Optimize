//===-- LoongArchMCInstLower.cpp - Convert LoongArch MachineInstr to MCInst-*- C++ -*-===//
//
// This file contains code to lower LoongArch MachineInstrs to their corresponding
// MCInst records.
//
//===----------------------------------------------------------------------===//

#include "LoongArchMCInstLower.h"

#include "LoongArchAsmPrinter.h"
#include "LoongArchInstrInfo.h"
#include "MCTargetDesc/LoongArchBaseInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineOperand.h"
#include "llvm/IR/Mangler.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"

using namespace llvm;

LoongArchMCInstLower::LoongArchMCInstLower(LoongArchAsmPrinter &asmprinter)
        : AsmPrinter(asmprinter) { }

void LoongArchMCInstLower::Initialize(MCContext *C) {
    Ctx = C;
}

MCOperand LoongArchMCInstLower::LowerSymbolOperand(const MachineOperand &MO,
                                              MachineOperandType MOTy,
                                              unsigned Offset) const {
    MCSymbolRefExpr::VariantKind Kind = MCSymbolRefExpr::VK_None;
    LoongArchMCExpr::LoongArchExprKind TargetKind = LoongArchMCExpr::LEK_None;
    const MCSymbol *Symbol;

    switch(MO.getTargetFlags()) {
        default:
            llvm_unreachable("Invalid target flag!");
        case LoongArch::MO_NO_FLAG:
            break;
        case LoongArch::MO_GPREL:
            TargetKind = LoongArchMCExpr::LEK_GPREL;
            break;
        case LoongArch::MO_GOT_CALL:
            TargetKind = LoongArchMCExpr::LEK_GOT_CALL;
            break;
        case LoongArch::MO_GOT:
            TargetKind = LoongArchMCExpr::LEK_GOT;
            break;
        case LoongArch::MO_ABS_HI:
            TargetKind = LoongArchMCExpr::LEK_ABS_HI;
            break;
        case LoongArch::MO_ABS_LO:
            TargetKind = LoongArchMCExpr::LEK_ABS_LO;
            break;
        case LoongArch::MO_GOT_HI20:
            TargetKind = LoongArchMCExpr::LEK_GOT_HI20;
            break;
        case LoongArch::MO_GOT_LO12:
            TargetKind = LoongArchMCExpr::LEK_GOT_LO12;
            break;
    }

    switch (MOTy) {
        case MachineOperand::MO_GlobalAddress:
            Symbol = AsmPrinter.getSymbol(MO.getGlobal());
            Offset += MO.getOffset();
            break;

        case MachineOperand::MO_MachineBasicBlock:
            Symbol = MO.getMBB()->getSymbol();
            break;

        case MachineOperand::MO_BlockAddress:
            Symbol = AsmPrinter.GetBlockAddressSymbol(MO.getBlockAddress());
            Offset += MO.getOffset();
            break;
        case MachineOperand::MO_ExternalSymbol:
            Symbol = AsmPrinter.GetExternalSymbolSymbol(MO.getSymbolName());
            Offset += MO.getOffset();
            break;

        case MachineOperand::MO_JumpTableIndex:
            Symbol = AsmPrinter.GetJTISymbol(MO.getIndex());
            break;

        default:
            llvm_unreachable("unknown operand type");
    }

    const MCExpr *Expr = MCSymbolRefExpr::create(Symbol, Kind, *Ctx);

    if (Offset) {
        // Assume offset is never negative.
        assert(Offset > 0);
        Expr = MCBinaryExpr::createAdd(Expr, MCConstantExpr::create(Offset, *Ctx), *Ctx);
    }

    if (TargetKind != LoongArchMCExpr::LEK_None)
        Expr = LoongArchMCExpr::create(TargetKind, Expr, *Ctx);

    return MCOperand::createExpr(Expr);
}

static void CreateMCInst(MCInst &Inst, unsigned Opc, const MCOperand &Operand0,
                         const MCOperand &Operand1,
                         const MCOperand &Operand2 = MCOperand() ) {
    Inst.setOpcode(Opc);
    Inst.addOperand(Operand0);
    Inst.addOperand(Operand1);
    if (Operand2.isValid())
        Inst.addOperand(Operand2);
}

// Lower ".cpload $reg" to
//  "lu12i.w    $gp, %hi(_gp_disp)"
//  "addi.w  $gp, $gp, %lo(_gp_disp)"
//  "add.w   $gp, $gp, $t7"
void LoongArchMCInstLower::LowerCPLOAD(SmallVector<MCInst, 4>& MCInsts) {
    MCOperand GPReg = MCOperand::createReg(LoongArch::GP);
    MCOperand T7Reg = MCOperand::createReg(LoongArch::T7);
    StringRef SymName("_gp_disp");
    const MCSymbol *Sym = Ctx->getOrCreateSymbol(SymName);
    const LoongArchMCExpr *MCSym;

    MCSym = LoongArchMCExpr::create(Sym, LoongArchMCExpr::LEK_ABS_HI, *Ctx);
    MCOperand SymHi = MCOperand::createExpr(MCSym);
    MCSym = LoongArchMCExpr::create(Sym, LoongArchMCExpr::LEK_ABS_LO, *Ctx);
    MCOperand SymLo = MCOperand::createExpr(MCSym);

    MCInsts.resize(3);

    CreateMCInst(MCInsts[0], LoongArch::LU12I_W, GPReg, SymHi);
    CreateMCInst(MCInsts[1], LoongArch::ORI, GPReg, GPReg, SymLo);
    CreateMCInst(MCInsts[2], LoongArch::ADD_W, GPReg, GPReg, T7Reg);
}

MCOperand LoongArchMCInstLower::LowerOperand(const MachineOperand &MO,
                                        unsigned offset) const {
    MachineOperandType MOTy = MO.getType();

    switch (MOTy) {
        default: llvm_unreachable("unknown operand type");
        case MachineOperand::MO_Register:
            // Ignore all implicit register operands
            if (MO.isImplicit()) break;
            return MCOperand::createReg(MO.getReg());
        case MachineOperand::MO_Immediate:
            return MCOperand::createImm(MO.getImm() + offset);
        case MachineOperand::MO_MachineBasicBlock:
        case MachineOperand::MO_ExternalSymbol:
        case MachineOperand::MO_JumpTableIndex:
        case MachineOperand::MO_BlockAddress:
        case MachineOperand::MO_GlobalAddress:
            return LowerSymbolOperand(MO, MOTy, offset);
        case MachineOperand::MO_RegisterMask:
            break;
    }

    return MCOperand();
}

MCOperand LoongArchMCInstLower::createSub(MachineBasicBlock *BB1,
                                     MachineBasicBlock *BB2,
                                          LoongArchMCExpr::LoongArchExprKind Kind) const {
    const MCSymbolRefExpr *Sym1 = MCSymbolRefExpr::create(BB1->getSymbol(), *Ctx);
    const MCSymbolRefExpr *Sym2 = MCSymbolRefExpr::create(BB2->getSymbol(), *Ctx);
    const MCBinaryExpr *Sub = MCBinaryExpr::createSub(Sym1, Sym2, *Ctx);

    return MCOperand::createExpr(LoongArchMCExpr::create(Kind, Sub, *Ctx));
}

void LoongArchMCInstLower::
lowerLongBranchLU12I_W(const MachineInstr *MI, MCInst &OutMI) const {
    OutMI.setOpcode(LoongArch::LU12I_W);

    // Lower register operand.
    OutMI.addOperand(LowerOperand(MI->getOperand(0)));

    // Create %hi($tgt-$bltgt).
    OutMI.addOperand(createSub(MI->getOperand(1).getMBB(),
                               MI->getOperand(2).getMBB(),
                               LoongArchMCExpr::LEK_ABS_HI));
}

void LoongArchMCInstLower::
lowerLongBranchADDI_W(const MachineInstr *MI, MCInst &OutMI, int Opcode,
                     LoongArchMCExpr::LoongArchExprKind Kind) const {
    OutMI.setOpcode(Opcode);

    // Lower two register operands.
    for (unsigned I = 0, E = 2; I != E; ++I) {
        const MachineOperand &MO = MI->getOperand(I);
        OutMI.addOperand(LowerOperand(MO));
    }

    // Create %lo($tgt-$bltgt) or %hi($tgt-$bltgt).
    OutMI.addOperand(createSub(MI->getOperand(2).getMBB(),
                               MI->getOperand(3).getMBB(), Kind));
}

bool LoongArchMCInstLower::lowerLongBranch(const MachineInstr *MI,
                                      MCInst &OutMI) const {
    switch (MI->getOpcode()) {
        default:
            return false;
        case LoongArch::LONG_BRANCH_LU12I_W:
            lowerLongBranchLU12I_W(MI, OutMI);
            return true;
        case LoongArch::LONG_BRANCH_ADDI_W:
            lowerLongBranchADDI_W(MI, OutMI, LoongArch::ADDI_W,
                                  LoongArchMCExpr::LEK_ABS_LO);
            return true;
    }
}

/// lower (JARA $rj) into (JIRL RA, $rj, 0)
void LoongArchMCInstLower::lowerJARA(const MachineInstr *MI,
                                           MCInst &OutMI) const {
    OutMI.setOpcode(LoongArch::JIRL);

    OutMI.addOperand(MCOperand::createReg(LoongArch::RA));

    // Lower register operand $rj.
    OutMI.addOperand(LowerOperand(MI->getOperand(1)));

    OutMI.addOperand(MCOperand::createImm(0));

}

void LoongArchMCInstLower::Lower(const MachineInstr *MI, MCInst &OutMCInst) const {
    // No need to lower again if long branch handler can handle it
    if (lowerLongBranch(MI, OutMCInst))
        return;
  /*  else if(MI->getOpcode()==LoongArch::JARA){
        lowerJARA(MI,OutMCInst);
        return;
    }*/

    OutMCInst.setOpcode(MI->getOpcode());

    for (unsigned i = 0, e = MI->getNumOperands(); i != e; ++i) {
        const MachineOperand &MO = MI->getOperand(i);
        MCOperand MCOp = LowerOperand(MO);

        if (MCOp.isValid())
            OutMCInst.addOperand(MCOp);
    }
}