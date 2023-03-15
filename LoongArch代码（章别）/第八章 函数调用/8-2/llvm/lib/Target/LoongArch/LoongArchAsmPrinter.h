//===-- LoongArchAsmPrinter.h - LoongArch Assembly Printer ----------------*- C++ -*-===//
//
// LoongArch assembly printer class.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHASMPRINTER_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHASMPRINTER_H

#include "LoongArchMachineFunctionInfo.h"
#include "LoongArchMCInstLower.h"
#include "LoongArchSubtarget.h"
#include "LoongArchTargetMachine.h"
#include "llvm/CodeGen/AsmPrinter.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/Support/Compiler.h"
#include "llvm/Target/TargetMachine.h"

namespace llvm {
    class MCStreamer;
    class MachineInstr;
    class MachineBasicBlock;
    class Module;
    class raw_ostream;

    class LLVM_LIBRARY_VISIBILITY LoongArchAsmPrinter : public AsmPrinter {

    void EmitInstrWithMacroNoAT(const MachineInstr *MI);

    private:
    // lowerOperand : Convert a MachineOperand into the equivalent MCOperand
    bool lowerOperand(const MachineOperand &MO, MCOperand &MCOp);

    bool isLongBranchPseudo(int Opcode) const;

public:
    const LoongArchSubtarget *Subtarget;
    const LoongArchMachineFunctionInfo *LoongArchMFI;
    LoongArchMCInstLower MCInstLowering;

    explicit LoongArchAsmPrinter(TargetMachine &TM,
                                std::unique_ptr<MCStreamer> Streamer)
    : AsmPrinter(TM, std::move(Streamer)),
    MCInstLowering(*this) {
    Subtarget = static_cast<LoongArchTargetMachine &>(TM).getSubtargetImpl();
}

virtual StringRef getPassName() const override {
return "LoongArch Assembly Printer";
}

virtual bool runOnMachineFunction(MachineFunction &MF) override;

// EmitInstruction() must exists or will have run time error
void EmitInstruction(const MachineInstr *MI) override;
void printSavedRegsBitmask(raw_ostream &O);
void printHex32(unsigned int Value, raw_ostream &O);
void emitFrameDirective();
const char *getCurrentABIString() const;
void EmitFunctionEntryLabel() override;
void EmitFunctionBodyStart() override;
void EmitFunctionBodyEnd() override;
void EmitStartOfAsmFile(Module &M) override;
void PrinterDebugValueComment(const MachineInstr *MI, raw_ostream &OS);
};
} // end namespace llvm

#endif