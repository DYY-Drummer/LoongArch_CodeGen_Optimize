//===-- LoongArchABIInfo.h - Information about LoongArch ABI --------------*- C++ -*-===//
//
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHABIINFO_H
#define LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHABIINFO_H

#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/Triple.h"
#include "llvm/IR/CallingConv.h"
#include "llvm/MC/MCRegisterInfo.h"

namespace llvm {

    class MCTargetOptions;
    class StringRef;
    class TargetRegisterClass;

    class LoongArchABIInfo {
    public:
        enum class ABI { Unknown, ILP32S, ILP32F, ILP32D };

    protected:
        ABI ThisABI;

    public:
        LoongArchABIInfo(ABI ThisABI) : ThisABI(ThisABI) { }

        static LoongArchABIInfo Unknown() { return LoongArchABIInfo(ABI::Unknown); }
        static LoongArchABIInfo ILP32S() { return LoongArchABIInfo(ABI::ILP32S); }
        static LoongArchABIInfo ILP32F() { return LoongArchABIInfo(ABI::ILP32F); }
        static LoongArchABIInfo ILP32D() { return LoongArchABIInfo(ABI::ILP32D); }
        static LoongArchABIInfo computeTargetABI();

        bool IsKnown() const { return ThisABI != ABI::Unknown; }
        bool IsILP32S() const { return ThisABI == ABI::ILP32S; }
        bool IsILP32F() const { return ThisABI == ABI::ILP32F; }
        bool IsILP32D() const { return ThisABI == ABI::ILP32D; }
        ABI GetEnumValue() const { return ThisABI; }

        // The registers to use for byval arguments
        const ArrayRef<MCPhysReg> GetByValArgRegs() const;

        // The registers to use for variable argument list
        const ArrayRef<MCPhysReg> GetVarArgRegs() const;

        // Obtain the size of the area allocated by the callee for arguments
        unsigned GetCalleeAllocdArgSizeInBytes(CallingConv::ID CC) const;

        // LoongArchGenSubtargetInfo.inc will use this to resolve conflicts when given
        // multiple ABI options
        bool operator<(const LoongArchABIInfo Other) const {
            return ThisABI < Other.GetEnumValue();
        }

        unsigned GetStackPtr() const;
        unsigned GetFramePtr() const;
        unsigned GetNullPtr() const;

        unsigned GetEhDataReg(unsigned I) const;
        int EhDataRegSize() const;
    };
} // End llvm namespace

#endif