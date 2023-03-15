//===-- LoongArchELFStreamer.h - LoongArch ELF Object Output --------------*- C++ -*-===//
//
// This is a custom MCELFStreamer which allows us to insert some hooks before
// emitting data into an actual object file.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHELFSTREAMER_H
#define LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHELFSTREAMER_H

#include "llvm/ADT/SmallVector.h"
#include "llvm/MC/MCELFStreamer.h"

#include <memory>

namespace llvm {

    class MCAsmBackend;
    class MCCodeEmitter;
    class MCContext;
    class MCSubtargetInfo;

    class LoongArchELFStreamer : public MCELFStreamer {

    public:
        LoongArchELFStreamer(MCContext &Context, std::unique_ptr<MCAsmBackend> MAB,
                        std::unique_ptr<MCObjectWriter> OW,
                        std::unique_ptr<MCCodeEmitter> Emitter);
    };

    MCELFStreamer *createLoongArchELFStreamer(MCContext &Context,
                                         std::unique_ptr<MCAsmBackend> MAB,
                                         std::unique_ptr<MCObjectWriter> OW,
                                         std::unique_ptr<MCCodeEmitter> Emitter,
                                         bool RelaxAll);
} // namespace llvm

#endif