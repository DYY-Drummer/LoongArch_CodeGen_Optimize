//===-- LoongArchAnalyzeImmediate.h - Analyze Immediates ------------*- C++ -*--===//

#ifndef LOONGARCH_ANALYZE_IMMEDIATE_H
#define LOONGARCH_ANALYZE_IMMEDIATE_H

#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/DataTypes.h"

namespace llvm {

    class LoongArchAnalyzeImmediate {
    public:
        struct Inst {
            unsigned Opc, ImmOperand;
            Inst(unsigned Opc, unsigned ImmOperand);
        };
        typedef SmallVector<Inst, 7 > InstSeq;

        /// Analyze - Get an instruction sequence to load immediate Imm. The last
        /// instruction in the sequence must be an ADDI_W if LastInstrIsADDI_W is
        /// true;
        const InstSeq &Analyze(uint64_t Imm, unsigned Size, bool LastInstrIsADDI_W);
    private:
        typedef SmallVector<InstSeq, 5> InstSeqLs;

        /// AddInstr - Add I to all instruction sequences in SeqLs.
        void AddInstr(InstSeqLs &SeqLs, const Inst &I);

        /// GetInstSeqLsADDI_W - Get instruction sequences which end with an ADDI_W to
        /// load immediate Imm
        void GetInstSeqLsADDI_W(uint64_t Imm, unsigned RemSize, InstSeqLs &SeqLs);

        /// GetInstSeqLsORI - Get instruction sequences which end with an ORI to
        /// load immediate Imm
        void GetInstSeqLsORI(uint64_t Imm, unsigned RemSize, InstSeqLs &SeqLs);

        /// GetInstSeqLsSLLI_W - Get instruction sequences which end with a SLLI_W to
        /// load immediate Imm
        void GetInstSeqLsSLLI_W(uint64_t Imm, unsigned RemSize, InstSeqLs &SeqLs);

        /// GetInstSeqLs - Get instruction sequences to load immediate Imm.
        void GetInstSeqLs(uint64_t Imm, unsigned RemSize, InstSeqLs &SeqLs);

        /// ReplaceADDI_WSLLI_WWithLU12I_W - Replace an ADDI_W & SLLI_W pair with a LU12I_W.
        void ReplaceADDI_WSLLI_WWithLU12I_W(InstSeq &Seq);

        /// GetShortestSeq - Find the shortest instruction sequence in SeqLs and
        /// return it in Insts.
        void GetShortestSeq(InstSeqLs &SeqLs, InstSeq &Insts);

        unsigned Size;
        unsigned ADDI_W, ORI, SLLI_W, LU12I_W;
        InstSeq Insts;
    };
}

#endif