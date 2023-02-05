//===-- LoongArch.td - Describe the LoongArch Target Machine ---------*- tablegen -*-===//
//===----------------------------------------------------------------------===//
// Calling Conv, Instruction Descriptions
//===----------------------------------------------------------------------===//
include "llvm/Target/Target.td"
include "LoongArchRegisterInfo.td"
include "LoongArchSchedule.td"
include "LoongArchInstrInfo.td"

def LoongArchInstrInfo : InstrInfo;
//===----------------------------------------------------------------------===//
// LoongArch processors supported.
//===----------------------------------------------------------------------===//

// Will generate LoongArchGenAsmWrite.inc included by LoongArchInstPrinter.cpp, contents
//  as follows,
// void LoongArchInstPrinter::printInstruction(const MCInst *MI, raw_ostream &O) {...}
// const char *LoongArchInstPrinter::getRegisterName(unsigned RegNo) {...}
def LoongArch : Target {
// def LoongArchInstrInfo : InstrInfo as before.
  let InstructionSet = LoongArchInstrInfo;
}

