//===-- Cpu0InstPrinter.h - Convert MCInst to assembly syntax ---*- C++ -*-===//
//
// This class prints a Cpu0 MCInst to an assembly file.
//
//===----------------------------------------------------------------------===//
#ifndef LLVM_LIB_TARGET_CPU0_INSTPRINTER_CPU0INSTPRINTER_H
#define LLVM_LIB_TARGET_CPU0_INSTPRINTER_CPU0INSTPRINTER_H

#include "llvm/MC/MCInstPrinter.h"

namespace llvm {
// These enumeration declarations were orignally in Cpu0InstrInfo.h but
// had to be moved here to avoid circular dependencies between
// LLVMCpu0CodeGen and LLVMCpu0AsmPrinter.
    class TargetMachine;
    class Cpu0InstPrinter : public MCInstPrinter {
    public:
        Cpu0InstPrinter(const MCAsmInfo &MAI, const MCInstrInfo &MII,
                        const MCRegisterInfo &MRI)
                : MCInstPrinter(MAI, MII, MRI) {}
// Autogenerated by tblgen.

        void printInstruction(const MCInst *MI, uint64_t Address, raw_ostream &O);
        static const char *getRegisterName(unsigned RegNo);
        void printRegName(raw_ostream &OS, unsigned RegNo) const override;
        void printInst(const MCInst *MI, uint64_t Address, StringRef Annot,
                       const MCSubtargetInfo &STI, raw_ostream &O) override;

        bool printAliasInstr(const MCInst *MI, raw_ostream &OS);
        void printCustomAliasOperand(const MCInst *MI,
                                     unsigned OpIdx, unsigned PrintMethodIdx,
                                     raw_ostream &O);
    private:
        void printOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O);
        void printOperand(const MCInst *MI, uint64_t /*Address*/, unsigned OpNum,
                          raw_ostream &O) {
            printOperand(MI, OpNum, O);
        }
        void printUnsignedImm(const MCInst *MI, int opNum, raw_ostream &O);
        void printMemOperand(const MCInst *MI, int opNum, raw_ostream &O);
//#if CH >= CH7_1
        void printMemOperandEA(const MCInst *MI, int opNum, raw_ostream &O);
//#endif
    };
} // end namespace llvm
#endif