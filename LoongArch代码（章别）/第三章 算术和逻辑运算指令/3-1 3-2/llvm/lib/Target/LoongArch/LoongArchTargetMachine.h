//===-- LoongArchTargetMachine.h - Define TargetMachine for LoongArch -----*- C++ -*-===//

// This file declares the LoongArch specific subclass of TargetMachine.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHTARGETMACHINE_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHTARGETMACHINE_H

#include "MCTargetDesc/LoongArchABIInfo.h"
#include "LoongArchSubtarget.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/SelectionDAGISel.h"
#include "llvm/CodeGen/TargetFrameLowering.h"
#include "llvm/Target/TargetMachine.h"

namespace llvm {
    class formatted_raw_ostream;
    class LoongArchRegisterInfo;

    class LoongArchTargetMachine : public LLVMTargetMachine {
        bool isLittle;
        std::unique_ptr<TargetLoweringObjectFile> TLOF;
        LoongArchABIInfo ABI;
        LoongArchSubtarget DefaultSubtarget;

        mutable StringMap<std::unique_ptr<LoongArchSubtarget>> SubtargetMap;
    public:
        LoongArchTargetMachine(const Target &T, const Triple &TT, StringRef CPU,
                          StringRef FS, const TargetOptions &Options,
                          Optional<Reloc::Model> RM, Optional<CodeModel::Model> CM,
                          CodeGenOpt::Level OL, bool JIT, bool isLittle);
        ~LoongArchTargetMachine() override;

        const LoongArchSubtarget *getSubtargetImpl() const {
            return &DefaultSubtarget;
        }

        // Can use this interface to fetch subtarget
        const LoongArchSubtarget *getSubtargetImpl(const Function &F) const override;

        // Pass Pipeline Configuration
        TargetPassConfig *createPassConfig(PassManagerBase &PM) override;

        TargetLoweringObjectFile *getObjFileLowering() const override {
            return TLOF.get();
        }
        bool isLittleEndian() const { return isLittle; }
        const LoongArchABIInfo &getABI() const { return ABI; }
    };

// default little endian LoongArch32 target machine.
    class LoongArch32TargetMachine : public LoongArchTargetMachine {
        virtual void anchor();
    public:
        LoongArch32TargetMachine(const Target &T, const Triple &TT, StringRef CPU,
                            StringRef FS, const TargetOptions &Options,
                            Optional<Reloc::Model> RM,
                            Optional<CodeModel::Model> CM,
                            CodeGenOpt::Level OL, bool JIT);
    };
} // End llvm namespace

#endif