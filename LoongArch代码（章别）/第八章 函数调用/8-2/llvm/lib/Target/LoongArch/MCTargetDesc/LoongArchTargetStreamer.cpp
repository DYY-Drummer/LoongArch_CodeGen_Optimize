//===-- LoongArchTargetStreamer.cpp - LoongArch Target Streamer Methods -------------===//
//
// This file provides LoongArch specific target streamer methods.
//
//===----------------------------------------------------------------------===//

#include "InstPrinter/LoongArchInstPrinter.h"
#include "LoongArchMCTargetDesc.h"
#include "LoongArchTargetObjectFile.h"
#include "LoongArchTargetStreamer.h"
#include "llvm/BinaryFormat/ELF.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCSectionELF.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/MCSymbolELF.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/FormattedStream.h"

using namespace llvm;

LoongArchTargetStreamer::LoongArchTargetStreamer(MCStreamer &S)
    : MCTargetStreamer(S) {
}

LoongArchTargetAsmStreamer::LoongArchTargetAsmStreamer(MCStreamer &S,
                                             formatted_raw_ostream &OS)
    : LoongArchTargetStreamer(S), OS(OS) {}

