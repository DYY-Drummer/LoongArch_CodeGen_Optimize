//===-- LoongArchInstrInfo.h - LoongArch Instruction Information ----------*- C++ -*-===//
// This file contains the LoongArch implementation of the TargetInstrInfo class.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHINSTRINFO_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHINSTRINFO_H

#include "LoongArch.h"
#include "LoongArchRegisterInfo.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/TargetInstrInfo.h"

#define GET_INSTRINFO_HEADER
#include "LoongArchGenInstrInfo.inc"

namespace llvm {

    class LoongArchInstrInfo : public LoongArchGenInstrInfo {
        virtual void anchor();
    protected:
        const LoongArchSubtarget &Subtarget;
    public:
        explicit LoongArchInstrInfo(const LoongArchSubtarget &STI);

        static const LoongArchInstrInfo *create(LoongArchSubtarget &STI);

        // TargetInstrInfo is a superset of MRegister info. As such, whenever a client
        // has an instance of instruction info, it should always be able to get
        // register info as well (through this method).
        virtual const LoongArchRegisterInfo &getRegisterInfo() const = 0;

        // Return the number of bytes of code the specified instruction may be.
        unsigned GetInstSizeInBytes(const MachineInstr &MI) const;
//protected:
    };

    const LoongArchInstrInfo *createLoongArchSEInstrInfo(const LoongArchSubtarget &STI);
}

#endif