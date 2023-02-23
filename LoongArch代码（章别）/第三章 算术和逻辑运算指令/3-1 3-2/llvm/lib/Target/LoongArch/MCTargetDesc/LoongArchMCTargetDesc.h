//===-- LoongArchMCTargetDesc.h - LoongArch Target Descriptions -----------*- C++ -*-===//
//
// This file provides LoongArch specific target descriptions.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHMCTARGETDESC_H
#define LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHMCTARGETDESC_H


#include "llvm/Support/DataTypes.h"

#include <memory>

namespace llvm {
    class Target;
    class Triple;
    class MCAsmBackend;
    class MCCodeEmitter;
    class MCContext;
    class MCInstrInfo;
    class MCObjectWriter;
    class MCRegisterInfo;
    class MCSubtargetInfo;
    class StringRef;

    class raw_ostream;

extern Target TheLoongArchTarget;

} // End llvm namespace

// Defines symbolic names for LoongArch registers.  This defines a mapping from
// register name to register number.
#define GET_REGINFO_ENUM
#include "LoongArchGenRegisterInfo.inc"

// Defines symbolic names for the LoongArch instructions.
#define GET_INSTRINFO_ENUM
#include "LoongArchGenInstrInfo.inc"

#define GET_SUBTARGETINFO_ENUM
#include "LoongArchGenSubtargetInfo.inc"

#endif

