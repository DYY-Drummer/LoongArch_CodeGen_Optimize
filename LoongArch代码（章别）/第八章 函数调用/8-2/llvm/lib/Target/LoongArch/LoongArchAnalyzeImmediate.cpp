//===-- LoongArchAnalyzeImmediate.cpp - Analyze Immediates ---------------------===//

#include "LoongArchAnalyzeImmediate.h"
#include "LoongArch.h"

#include "llvm/Support/MathExtras.h"

using namespace llvm;

LoongArchAnalyzeImmediate::Inst::Inst(unsigned O, unsigned I) : Opc(O), ImmOperand(I) {}

// Add I to the instruction sequences.
void LoongArchAnalyzeImmediate::AddInstr(InstSeqLs &SeqLs, const Inst &I) {
    // Add an instruction seqeunce consisting of just I.
    if (SeqLs.empty()) {
        SeqLs.push_back(InstSeq(1, I));
        return;
    }

    for (InstSeqLs::iterator Iter = SeqLs.begin(); Iter != SeqLs.end(); ++Iter)
        Iter->push_back(I);
}

void LoongArchAnalyzeImmediate::GetInstSeqLsADDI_W(uint64_t Imm, unsigned RemSize,
                                             InstSeqLs &SeqLs) {
    GetInstSeqLs((Imm + 0x800ULL) & 0xfffffffffffff000ULL, RemSize, SeqLs);
    AddInstr(SeqLs, Inst(ADDI_W, Imm & 0xfffULL));
}

void LoongArchAnalyzeImmediate::GetInstSeqLsORI(uint64_t Imm, unsigned RemSize,
                                           InstSeqLs &SeqLs) {
    GetInstSeqLs(Imm & 0xfffffffffffff000ULL, RemSize, SeqLs);
    AddInstr(SeqLs, Inst(ORI, Imm & 0xfffULL));
}

void LoongArchAnalyzeImmediate::GetInstSeqLsSLLI_W(uint64_t Imm, unsigned RemSize,
                                           InstSeqLs &SeqLs) {
    unsigned Shamt = countTrailingZeros(Imm);
    GetInstSeqLs(Imm >> Shamt, RemSize - Shamt, SeqLs);
    AddInstr(SeqLs, Inst(SLLI_W, Shamt));
}

void LoongArchAnalyzeImmediate::GetInstSeqLs(uint64_t Imm, unsigned RemSize,
                                        InstSeqLs &SeqLs) {
    uint64_t MaskedImm = Imm & (0xffffffffffffffffULL >> (64 - Size));

    // Do nothing if Imm is 0.
    if (!MaskedImm)
        return;

    // A single ADDI_W will do if RemSize <= 12.
    if (RemSize <= 12) {
        AddInstr(SeqLs, Inst(ADDI_W, MaskedImm));
        return;
    }

    // Shift if the lower 12-bit is cleared.
    if (!(Imm & 0xfff)) {
        GetInstSeqLsSLLI_W(Imm, RemSize, SeqLs);
        return;
    }

    GetInstSeqLsADDI_W(Imm, RemSize, SeqLs);

    // If bit 12 is cleared, it doesn't make a difference whether the last
    // instruction is an ADDI_W or ORI. In that case, do not call GetInstSeqLsORI.
    if (Imm & 0x800) {
        InstSeqLs SeqLsORI;
        GetInstSeqLsORI(Imm, RemSize, SeqLsORI);
        SeqLs.insert(SeqLs.end(), SeqLsORI.begin(), SeqLsORI.end());
    }
}

// Replace a ADDI_W & SLLI_W pair with a LU12I_W.
// e.g. the following two instructions
//  ADDI_W 0x0111
//  SLLI_W 14
// are replaced with
//  LU12I_W 0x444
void LoongArchAnalyzeImmediate::ReplaceADDI_WSLLI_WWithLU12I_W(InstSeq &Seq) {
    // Check if the first two instructions are ADDI_W and SLLI_W and the shift amount
    // is at least 12.
    if ((Seq.size() < 2) || (Seq[0].Opc != ADDI_W) ||
        (Seq[1].Opc != SLLI_W) || (Seq[1].ImmOperand < 12))
        return;

    // Sign-extend and shift operand of ADDI_W and see if it fits in 20-bit.
    int64_t Imm = SignExtend64<12>(Seq[0].ImmOperand);
    int64_t ShiftedImm = (uint64_t)Imm << (Seq[1].ImmOperand - 12);

    if (!isInt<20>(ShiftedImm))
        return;

    // Replace the first instruction and erase the second.
    Seq[0].Opc = LU12I_W;
    Seq[0].ImmOperand = (unsigned)(ShiftedImm & 0xfffff);
    Seq.erase(Seq.begin() + 1);
}

void LoongArchAnalyzeImmediate::GetShortestSeq(InstSeqLs &SeqLs, InstSeq &Insts) {
    InstSeqLs::iterator ShortestSeq = SeqLs.end();
    // The length of an instruction sequence is at most 7.
    unsigned ShortestLength = 8;

    for (InstSeqLs::iterator S = SeqLs.begin(); S != SeqLs.end(); ++S) {
        ReplaceADDI_WSLLI_WWithLU12I_W(*S);
        assert(S->size() <= 7);

        if (S->size() < ShortestLength) {
            ShortestSeq = S;
            ShortestLength = S->size();
        }
    }

    Insts.clear();
    Insts.append(ShortestSeq->begin(), ShortestSeq->end());
}

const LoongArchAnalyzeImmediate::InstSeq
&LoongArchAnalyzeImmediate::Analyze(uint64_t Imm, unsigned Size,
                               bool LastInstrIsADDI_W) {
    this->Size = Size;

    ADDI_W = LoongArch::ADDI_W;
    ORI = LoongArch::ORI;
    SLLI_W = LoongArch::SLLI_W;
    LU12I_W = LoongArch::LU12I_W;

    InstSeqLs SeqLs;

    // Get the list of instruction sequences.
    if (LastInstrIsADDI_W | !Imm)
        GetInstSeqLsADDI_W(Imm, Size, SeqLs);
    else
        GetInstSeqLs(Imm, Size, SeqLs);

    // Set Insts to the shortest instruction sequence.
    GetShortestSeq(SeqLs, Insts);

    return Insts;
}