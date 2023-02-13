//===-- LoongArchCallingConv.td - Calling Conventions for LoongArch --*- tablegen -*-===//
//===----------------------------------------------------------------------===//
//
// This describes the calling conventions for LoongArch architecture.
//
//===----------------------------------------------------------------------===//

// Match if the current subtarget has a feature F.
class CCIfSubtarget<string F, CCAction A>
        : CCIf<!strconcat("State.getTarget().getSubtarget<LoongArchSubtarget>().", F), A>;

// determine the callee saved registers(R1, FP, S0, ...S8), see LoongArch ABI document for details
// callee saved register is also called static register
def CSR_ILP32S_LP64S
: CalleeSavedRegs<(add RA, FP, (sequence "S%u", 0, 8))>;

//def CSR_ILP32F_LP64F
//: CalleeSavedRegs<(add CSR_ILP32S_LP64S, (sequence "F%u", 24, 31))>;
//
//def CSR_ILP32D_LP64D
//: CalleeSavedRegs<(add CSR_ILP32S_LP64S, (sequence "F%u_64", 24, 31))>;

// Needed for implementation of LoongArchRegisterInfo::getNoPreservedMask()
def CSR_NoRegs : CalleeSavedRegs<(add)>;