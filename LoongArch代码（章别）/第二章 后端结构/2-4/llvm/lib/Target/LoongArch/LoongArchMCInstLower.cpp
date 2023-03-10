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

static void CreateMCInst(MCInst &Inst, unsigned Opc, const MCOperand &Operand0,
                         const MCOperand &Operand1,
                         const MCOperand &Operand2 = MCOperand() ) {
    Inst.setOpcode(Opc);
    Inst.addOperand(Operand0);
    Inst.addOperand(Operand1);
    if (Operand2.isValid())
        Inst.addOperand(Operand2);
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
        case MachineOperand::MO_RegisterMask:
            break;
    }

    return MCOperand();
}

void LoongArchMCInstLower::Lower(const MachineInstr *MI, MCInst &OutMCInst) const {
    OutMCInst.setOpcode(MI->getOpcode());

    for (unsigned i = 0, e = MI->getNumOperands(); i != e; ++i) {
        const MachineOperand &MO = MI->getOperand(i);
        MCOperand MCOp = LowerOperand(MO);

        if (MCOp.isValid())
            OutMCInst.addOperand(MCOp);
    }
}