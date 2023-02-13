//===-- LoongArchTargetMachine.cpp - Define TargetMachine for LoongArch ---*- C++ -*-===//
//
// Implements the info about LoongArch target spec
//
//===----------------------------------------------------------------------===//

#include "LoongArchTargetMachine.h"
#include "LoongArch.h"
#include "LoongArchTargetObjectFile.h"
#include "LoongArchSubtarget.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/CodeGen.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/CodeGen/Passes.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/Support/TargetRegistry.h"
#include "llvm/Target/TargetOptions.h"

using namespace llvm;

#define DEBUG_TYPE "loongarch"

extern "C" void LLVMInitializeLoongArchTarget() {
    // Register the target.
    // Little endian LoongArch32 Target Machine
    // llvm::TheLoongArchTarget defined in TargetInfo/LoongArchTargetInfo.cpp
    RegisterTargetMachine<LoongArch32TargetMachine> X(TheLoongArchTarget);
}

static std::string computeDataLayout(const Triple &TT, StringRef CPU,
                                     const TargetOptions &Options,
                                     bool isLittle) {
    //little endian
    std::string Ret = "e";

    //m:o for Mac, m:e for Linux
    Ret += "-m:e";

    // Pointer size and alignment
    Ret += "-p:32:32";

    // 8 and 16 bits integers only need to have natural alignment, but try to
    // align them to 32 bits. 64 bits integers have natural alignment.
    Ret += "-i8:8:32-i16:16:32-i64:64";

    // 32 bits registers are always available and the stack is at least 128 bits aligned
    Ret += "-n32-s128";

    return Ret;
}

static Reloc::Model getEffectiveRelocModel(bool JIT,
                                           Optional<Reloc::Model> RM) {
    if (!RM.hasValue() || JIT)
        return Reloc::Static;
    return *RM;
}
// DataLayout --> Big-endian, 32-bit pointer/ABI/alignment
// The stack is always 8 byte aligned
// On function prologue, the stack is created by decrementing
// its pointer. Once decremented, all references are done with positive
// offset from the stack/frame pointer, using StackGrowsUp enables
// an easier handling.
LoongArchTargetMachine::LoongArchTargetMachine(const Target &T, const Triple &TT,
                                     StringRef CPU, StringRef FS,
                                     const TargetOptions &Options,
                                     Optional<Reloc::Model> RM,
                                     Optional<CodeModel::Model> CM,
                                     CodeGenOpt::Level OL, bool JIT,
                                     bool isLittle)
        : LLVMTargetMachine(T, computeDataLayout(TT, CPU, Options, isLittle), TT,
                            CPU, FS, Options, getEffectiveRelocModel(JIT, RM),
                            getEffectiveCodeModel(CM, CodeModel::Small), OL),
          isLittle(isLittle), TLOF(std::make_unique<LoongArchTargetObjectFile>()),
          ABI(LoongArchABIInfo::computeTargetABI()),
          DefaultSubtarget(TT, CPU, FS, isLittle, *this) {
    initAsmInfo();
}

LoongArchTargetMachine::~LoongArchTargetMachine() { }



void LoongArch32TargetMachine::anchor() { }

LoongArch32TargetMachine::LoongArch32TargetMachine(const Target &T, const Triple &TT,
                                         StringRef CPU, StringRef FS,
                                         const TargetOptions &Options,
                                         Optional<Reloc::Model> RM,
                                         Optional<CodeModel::Model> CM,
                                         CodeGenOpt::Level OL, bool JIT)
        : LoongArchTargetMachine(T, TT, CPU, FS, Options, RM, CM, OL, JIT, true) { }

const LoongArchSubtarget *
LoongArchTargetMachine::getSubtargetImpl(const Function &F) const {
    Attribute CPUAttr = F.getFnAttribute("target-cpu");
    Attribute FSAttr = F.getFnAttribute("target-features");

    std::string CPU = !CPUAttr.hasAttribute(Attribute::None)
                      ? CPUAttr.getValueAsString().str()
                      : TargetCPU;
    std::string FS = !FSAttr.hasAttribute(Attribute::None)
                     ? FSAttr.getValueAsString().str()
                     : TargetFS;

    auto &I = SubtargetMap[CPU + FS];
    if (!I) {
        // This needs to be done before we create a new subtarget since any
        // creation will depend on the TM and the code generation flags on the
        // function that reside in TargetOptions.
        resetTargetOptions(F);
        I = std::make_unique<LoongArchSubtarget>(TargetTriple, CPU, FS, isLittle,
                                             *this);
    }
    return I.get();
}

namespace {
// LoongArch Code Generator Pass Configuration Options.
    class LoongArchPassConfig : public TargetPassConfig {
    public:
        LoongArchPassConfig(LoongArchTargetMachine &TM, PassManagerBase &PM)
                : TargetPassConfig(TM, PM) { }

        LoongArchTargetMachine &getLoongArchTargetMachine() const {
            return getTM<LoongArchTargetMachine>();
        }

        const LoongArchSubtarget &getLoongArchSubtarget() const {
            return *getLoongArchTargetMachine().getSubtargetImpl();
        }
        bool addInstSelector() override;
    };
} // end namespace

TargetPassConfig *LoongArchTargetMachine::createPassConfig(PassManagerBase &PM) {
    return new LoongArchPassConfig(*this, PM);
}

// Install an instruction selector pass using
// the ISelDag to gen LoongArch code.
bool LoongArchPassConfig::addInstSelector() {
    addPass(createLoongArchSEISelDag(getLoongArchTargetMachine(), getOptLevel()));
    return false;
}