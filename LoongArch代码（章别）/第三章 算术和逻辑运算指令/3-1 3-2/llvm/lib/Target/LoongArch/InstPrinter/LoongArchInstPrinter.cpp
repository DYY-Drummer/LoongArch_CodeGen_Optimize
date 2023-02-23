//===-- LoongArchInstPrinter.cpp - Convert MCInst to assembly syntax -*- C++ -*-===//
//
//===----------------------------------------------------------------------===//
//
// This class prints an LoongArch MCInst to an assembly file.
//
//===----------------------------------------------------------------------===//

#include "LoongArchInstPrinter.h"

#include "LoongArchInstrInfo.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

#define DEBUG_TYPE "asm-printer"

#define PRINT_ALIAS_INSTR
#include "LoongArchGenAsmWriter.inc"

void LoongArchInstPrinter::printRegName(raw_ostream &OS, unsigned RegNo) const {
    // getRegisterName(RegNo) defiend in LoongArchGenAsmWriter.inc which indicate in LoongArch.td
    OS << '$' << StringRef(getRegisterName(RegNo)).lower();
}

void LoongArchInstPrinter::printInst(const MCInst *MI, uint64_t Address,
                                StringRef Annot, const MCSubtargetInfo &STI,
                                raw_ostream &O) {
// Try to print any aliases first.
    if (!printAliasInstr(MI, O))
        printInstruction(MI, Address, O);
    printAnnotation(O, Annot);
}

void LoongArchInstPrinter::printOperand(const MCInst *MI, unsigned OpNo,
                                   raw_ostream &O) {
    const MCOperand &Op = MI->getOperand(OpNo);
    if (Op.isReg()) {
        printRegName(O, Op.getReg());
        return;
    }

    if (Op.isImm()) {
        O << Op.getImm();
        return;
    }

    assert(Op.isExpr() && "unknown operand kind in printOperand");
    Op.getExpr()->print(O, &MAI, true);
}

void LoongArchInstPrinter::printUnsignedImm(const MCInst *MI, int OpNum,
                                       raw_ostream &O) {
    const MCOperand &MO = MI->getOperand(OpNum);
    if (MO.isImm())
        O << (unsigned short int)MO.getImm();
    else
        printOperand(MI, OpNum, O);
}

void LoongArchInstPrinter::printMemOperand(const MCInst *MI, int OpNum,
                                      raw_ostream &O) {
    // Load/Store memory operands => $reg, imm

    // Print the base address register.
    printOperand(MI, OpNum, O);
    O << ", ";
    // Print the offset operand.
    printOperand(MI, OpNum+1, O);
}

void LoongArchInstPrinter::
printMemOperandEA(const MCInst *MI, int opNum, raw_ostream &O) {
// when using stack locations for not load/store instructions
// print the same way as all normal 3 operand instructions.
    printOperand(MI, opNum, O);
    O << ", ";
    printOperand(MI, opNum+1, O);
    return;
}