//===-- LoongArchBaseInfo.h - Top level definitions for LOONGARCH MC ------*- C++ -*-===//
//
// This file contains small standalone helper functions and enum definitions for
// the LoongArch target useful for the compiler back-end and the MC libraries.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHBASEINFO_H
#define LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHBASEINFO_H

#include "LoongArchMCTargetDesc.h"
#include "LoongArchFixupKinds.h"

#include "llvm/MC/MCExpr.h"
#include "llvm/Support/DataTypes.h"
#include "llvm/Support/ErrorHandling.h"

namespace llvm {

// LoongArch32 - This namespace holds all of the target specific flags that
// instruction info tracks
    namespace LoongArch{
        // Target Operand Flag enum.
        enum TOF {
            MO_NO_FLAG,

            // MO_GOT_CALL: Represents the offset into the global offset table at
            // which the address of a call site relocation entry symbol resides
            // during execution. This is different from the above since this flag
            // can only be present in call instructions.
            MO_GOT_CALL,
            // MO_GOT16: Represents the offset into the global offset table at which
            // the address the relocation entry symbol resides during execution.
            MO_GOT16,
            MO_GOT,
            // MO_GPREL: Represents the offset from the current gp value to be used
            // for the relocatable object file being produced.
            MO_GPREL,

            // MO_ABS_HI/LO: Represents the high or low part of an absolute symbol
            // address.
            MO_ABS_HI,
            MO_ABS_LO,

            // MO_GOT_HI16/LO16: Relocations used for large GOTs.
            MO_GOT_HI20,
            MO_GOT_LO12
        };

        // These are the standard/most common forms for LoongArch instructions.
        enum {
            // Pseudo: This represents an instruction that is a pseudo instruction
            // or one that has not been implemented yet. It is illegal to code generate
            // it, but tolerated for intermediate implementation stages.
            Pseudo = 0,

            // TODO: Add more forms.
        };

    } // end namespace LoongArchII
} // end namespace llvm

#endif