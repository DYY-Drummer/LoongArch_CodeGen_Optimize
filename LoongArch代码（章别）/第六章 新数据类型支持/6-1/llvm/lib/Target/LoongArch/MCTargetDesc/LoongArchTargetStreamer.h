//===-- LoongArchTargetStreamer.h - LoongArch Target Streamer ------------*- C++ -*--===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_LOONGARCHTARGETSTREAMER_H
#define LLVM_LIB_TARGET_LOONGARCH_LOONGARCHTARGETSTREAMER_H


#include "llvm/MC/MCELFStreamer.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCStreamer.h"

namespace llvm {

class LoongArchTargetStreamer : public MCTargetStreamer {
public:
    LoongArchTargetStreamer(MCStreamer &S);
};

// This part is for ascii assembly output
class LoongArchTargetAsmStreamer : public LoongArchTargetStreamer {
  formatted_raw_ostream &OS;

public:
    LoongArchTargetAsmStreamer(MCStreamer &S, formatted_raw_ostream &OS);
};

}

#endif

