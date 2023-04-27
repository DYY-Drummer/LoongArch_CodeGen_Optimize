//===-- Cpu0CallingConv.td - Calling Conventions for Cpu0 --*- tablegen -*-===//
//===----------------------------------------------------------------------===//
//
// This describes the calling conventions for Cpu0 architecture.
//
//===----------------------------------------------------------------------===//

// Match if the current subtarget has a feature F.
class CCIfSubtarget<string F, CCAction A>
        : CCIf<!strconcat("State.getTarget().getSubtarget<Cpu0Subtarget>().", F), A>;

def CSR_032 : CalleeSavedRegs<(add LR, FP, (sequence "S%u", 1, 0))>;