//===-- LoongArchMCInstLower.h - Lower MachineInstr to MCInst --------*- C++ -*-===//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHMCINSTLOWER_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHMCINSTLOWER_H

#include "MCTargetDesc/LoongArchMCExpr.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/CodeGen/MachineOperand.h"
#include "llvm/Support/Compiler.h"

namespace llvm {
    class MCContext;
    class MCInst;
    class MCOperand;
    class MachineInstr;
    class MachineFunction;
    class LoongArchAsmPrinter;

    class LLVM_LIBRARY_VISIBILITY LoongArchMCInstLower {
            typedef MachineOperand::MachineOperandType MachineOperandType;
            MCContext *Ctx;
            LoongArchAsmPrinter &AsmPrinter;
    public:
            LoongArchMCInstLower(LoongArchAsmPrinter &asmprinter);
            void Initialize(MCContext *C);
            void Lower(const MachineInstr *MI, MCInst &OutMI) const;
            MCOperand LowerOperand(const MachineOperand &MO, unsigned offset = 0) const;
            void LowerCPLOAD(SmallVector<MCInst, 4>& MCInsts);
    private:
            MCOperand LowerSymbolOperand(const MachineOperand &MO,
                                         MachineOperandType MOTy, unsigned Offset) const;
    };

} // end namespace llvm

#endif