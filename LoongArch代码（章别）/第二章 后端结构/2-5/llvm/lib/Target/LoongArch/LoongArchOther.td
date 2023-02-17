//===-- LoongArchOther.td - Describe the LoongArch Target Machine ----*- tablegen -*-===//
// This is the top level entry point for the LoongArch target.
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Target-independent interfaces
//===----------------------------------------------------------------------===//

include "llvm/Target/Target.td"

//===----------------------------------------------------------------------===//
// Target-dependent interfaces
//===----------------------------------------------------------------------===//

include "LoongArchRegisterInfo.td"
include "LoongArchRegisterInfoGPROutForOther.td" // except AsmParser
include "LoongArch.td"

