//===-- LoongArchSubtarget.cpp - LoongArch Subtarget Information --------------------===//
//
// This file implements the LoongArch specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#include "LoongArchSubtarget.h"

#include "LoongArchMachineFunctionInfo.h"
#include "LoongArch.h"
#include "LoongArchRegisterInfo.h"

#include "LoongArchTargetMachine.h"
#include "llvm/IR/Attributes.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

#define DEBUG_TYPE "loongarch-subtarget"

#define GET_SUBTARGETINFO_TARGET_DESC
#define GET_SUBTARGETINFO_CTOR
#include "LoongArchGenSubtargetInfo.inc"

extern bool FixGlobalBaseReg;

void LoongArchSubtarget::anchor() { }

LoongArchSubtarget::LoongArchSubtarget(const Triple &TT, const std::string &CPU,
                             const std::string &FS, bool little,
                             const LoongArchTargetMachine &_TM) :
// LoongArchGenSubtargetInfo will display features by llc -march=loongarch -mcpu=help
        LoongArchGenSubtargetInfo(TT, CPU, FS),
        IsLittle(little), TM(_TM), TargetTriple(TT), TSInfo(),
        InstrInfo(
                LoongArchInstrInfo::create(initializeSubtargetDependencies(CPU, FS, TM))),
        FrameLowering(LoongArchFrameLowering::create(*this)),
        TLInfo(LoongArchTargetLowering::create(TM, *this)) {

}

bool LoongArchSubtarget::isPositionIndependent() const {
    return TM.isPositionIndependent();
}

LoongArchSubtarget &
LoongArchSubtarget::initializeSubtargetDependencies(StringRef CPU, StringRef FS,
                                               const TargetMachine &TM) {
    if (TargetTriple.getArch() == Triple::loongarch) {
        if (CPU.empty() || CPU == "generic") {
            CPU = "loongarch32";
        }
        else if (CPU == "help") {
            CPU = "";
            return *this;
        }
        else if (CPU != "loongarch32") {
            CPU = "loongarch32";
        }
    }
    else {
        errs() << "!!!Error, TargetTriple.getArch() = " << TargetTriple.getArch()
               <<  "CPU = " << CPU << "\n";
        exit(0);
    }

    if (CPU == "loongarch32")
        LoongArchArchVersion = LoongArch32;

    if (isLoongArch32()) {
        HasSlt = true;
    }else {
        errs() << "-mcpu must be empty(default:loongarch32)" << "\n";
    }

    // Parse features string.
    ParseSubtargetFeatures(CPU, FS);
    // Initialize scheduling itinerary for the specified CPU.
    InstrItins = getInstrItineraryForCPU(CPU);

    return *this;
}

bool LoongArchSubtarget::abiUsesSoftFloat() const {
//  return TM->Options.UseSoftFloat;
    return true;
}

const LoongArchABIInfo &LoongArchSubtarget::getABI() const { return TM.getABI(); }