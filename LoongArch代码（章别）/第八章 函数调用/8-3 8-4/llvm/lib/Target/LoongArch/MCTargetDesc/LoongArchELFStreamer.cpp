//===-- LoongArchELFStreamer.cpp - LoongArch ELF Object Output ------------*- C++ -*-===//


#include "LoongArchELFStreamer.h"
#include "LoongArchTargetStreamer.h"
#include "llvm/BinaryFormat/ELF.h"
#include "llvm/MC/MCAsmBackend.h"
#include "llvm/MC/MCAssembler.h"
#include "llvm/MC/MCCodeEmitter.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/MC/MCSymbolELF.h"
#include "llvm/Support/Casting.h"

using namespace llvm;

LoongArchELFStreamer::LoongArchELFStreamer(MCContext &Context,
                                 std::unique_ptr<MCAsmBackend> MAB,
                                 std::unique_ptr<MCObjectWriter> OW,
                                 std::unique_ptr<MCCodeEmitter> Emitter)
        : MCELFStreamer(Context, std::move(MAB), std::move(OW),
                        std::move(Emitter)) {}

MCELFStreamer *llvm::createLoongArchELFStreamer(MCContext &Context,
                                           std::unique_ptr<MCAsmBackend> MAB,
                                           std::unique_ptr<MCObjectWriter> OW,
                                           std::unique_ptr<MCCodeEmitter> Emitter,
                                           bool RelaxAll) {
    return new LoongArchELFStreamer(Context, std::move(MAB), std::move(OW),
                               std::move(Emitter));
}
