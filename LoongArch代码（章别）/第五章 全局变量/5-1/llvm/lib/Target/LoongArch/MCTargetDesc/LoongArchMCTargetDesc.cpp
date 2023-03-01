//===-- LoongArchMCTargetDesc.cpp - LoongArch Target Descriptions ---------*- C++ -*-===//
//
// This file provides LoongArch specific target descirptions.
//
//===----------------------------------------------------------------------===//

#include "LoongArchMCTargetDesc.h"
#include "InstPrinter/LoongArchInstPrinter.h"
#include "LoongArchAsmBackend.h"
#include "LoongArchELFStreamer.h"
#include "LoongArchMCAsmInfo.h"
#include "LoongArchTargetStreamer.h"
#include "llvm/ADT/Triple.h"
#include "llvm/MC/MCCodeEmitter.h"
#include "llvm/MC/MachineLocation.h"
#include "llvm/MC/MCELFStreamer.h"
#include "llvm/MC/MCInstrAnalysis.h"
#include "llvm/MC/MCInstPrinter.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/FormattedStream.h"
#include "llvm/Support/TargetRegistry.h"

using namespace llvm;

#define GET_INSTRINFO_MC_DESC
#include "LoongArchGenInstrInfo.inc"

#define GET_SUBTARGETINFO_MC_DESC
#include "LoongArchGenSubtargetInfo.inc"

#define GET_REGINFO_MC_DESC
#include "LoongArchGenRegisterInfo.inc"

// Select the LoongArch Architecture Feature for the given triple and cpu name.
// The function will be called at command 'llvm-objdump -d' for LoongArch elf input.
static StringRef selectLoongArchArchFeature(const Triple &TT, StringRef CPU) {
    std::string LoongArchArchFeature;
    if (CPU.empty() || CPU == "generic") {
        if (TT.getArch() == Triple::loongarch) {
            if (CPU.empty() || CPU == "loongarch32") {
                LoongArchArchFeature = "+loongarch32";
            }
        }
    }
    return LoongArchArchFeature;
}

static MCInstrInfo *createLoongArchMCInstrInfo() {
    MCInstrInfo *X = new MCInstrInfo();
    InitLoongArchMCInstrInfo(X); // defined in LoongArchGenInstrInfo.inc
    return X;
}

static MCRegisterInfo *createLoongArchMCRegisterInfo(const Triple &TT) {
    MCRegisterInfo *X = new MCRegisterInfo();
    InitLoongArchMCRegisterInfo(X, LoongArch::RA); // defined in LoongArchGenRegisterInfo.inc
    return X;
}

static MCSubtargetInfo *createLoongArchMCSubtargetInfo(const Triple &TT,
                                                  StringRef CPU, StringRef FS) {
    std::string ArchFS = selectLoongArchArchFeature(TT, CPU);
    if (!FS.empty()) {
        if (!ArchFS.empty()) {
            ArchFS = ArchFS + "," + FS.str();
        } else {
            ArchFS = FS;
        }
    }
    return createLoongArchMCSubtargetInfoImpl(TT, CPU, ArchFS);
    // createLoongArchMCSubtargetInfoImpl defined in LoongArchGenSubtargetInfo.inc
}

static MCAsmInfo *createLoongArchMCAsmInfo(const MCRegisterInfo &MRI,
                                      const Triple &TT,
                                      const MCTargetOptions &Options) {
    MCAsmInfo *MAI = new LoongArchMCAsmInfo(TT);

    unsigned SP = MRI.getDwarfRegNum(LoongArch::SP, true);
    MCCFIInstruction Inst = MCCFIInstruction::createDefCfa(nullptr, SP, 0);
    MAI->addInitialFrameState(Inst);

    return MAI;
}

static MCInstPrinter *createLoongArchMCInstPrinter(const Triple &TT,
                                              unsigned SyntaxVariant,
                                              const MCAsmInfo &MAI,
                                              const MCInstrInfo &MII,
                                              const MCRegisterInfo &MRI) {
    return new LoongArchInstPrinter(MAI, MII, MRI);
}

namespace {
    class LoongArchMCInstrAnalysis : public MCInstrAnalysis {
    public:
        LoongArchMCInstrAnalysis(const MCInstrInfo *Info) : MCInstrAnalysis(Info) { }
    };
}

static MCInstrAnalysis *createLoongArchMCInstrAnalysis(const MCInstrInfo *Info) {
    return new LoongArchMCInstrAnalysis(Info);
}

static MCStreamer *createMCStreamer(const Triple &TT, MCContext &Context,
                                    std::unique_ptr<MCAsmBackend> &&MAB,
                                    std::unique_ptr<MCObjectWriter> &&OW,
                                    std::unique_ptr<MCCodeEmitter> &&Emitter,
                                    bool RelaxAll) {
    return createELFStreamer(Context, std::move(MAB), std::move(OW),
                             std::move(Emitter), RelaxAll);;
}

static MCTargetStreamer *createLoongArchAsmTargetStreamer(MCStreamer &S,
                                                     formatted_raw_ostream &OS,
                                                     MCInstPrinter *InstPrint,
                                                     bool isVerboseAsm) {
    return new LoongArchTargetAsmStreamer(S, OS);
}

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeLoongArchTargetMC() {

    for (Target *T : {&TheLoongArchTarget}) {
        // Register the MC asm info
        RegisterMCAsmInfoFn X(*T, createLoongArchMCAsmInfo);

        // Register the MC instruction info
        TargetRegistry::RegisterMCInstrInfo(*T, createLoongArchMCInstrInfo);

        // Register the MC register info
        TargetRegistry::RegisterMCRegInfo(*T, createLoongArchMCRegisterInfo);

        // Register the elf streamer.
        TargetRegistry::RegisterELFStreamer(*T, createMCStreamer);

        // Register the asm target streamer.
        TargetRegistry::RegisterAsmTargetStreamer(*T, createLoongArchAsmTargetStreamer);

        // Register the asm backend.
        TargetRegistry::RegisterMCAsmBackend(*T, createLoongArchAsmBackend);

        // Register the MC Subtarget info
        TargetRegistry::RegisterMCSubtargetInfo(*T, createLoongArchMCSubtargetInfo);

        // Register the MC instruction analyzer
        TargetRegistry::RegisterMCInstrAnalysis(*T, createLoongArchMCInstrAnalysis);

        // Register the MC instruction printer
        TargetRegistry::RegisterMCInstPrinter(*T, createLoongArchMCInstPrinter);
    }
    // Register the MC Code Emitter
    TargetRegistry::RegisterMCCodeEmitter(TheLoongArchTarget,
                                          createLoongArchMCCodeEmitter);
}
