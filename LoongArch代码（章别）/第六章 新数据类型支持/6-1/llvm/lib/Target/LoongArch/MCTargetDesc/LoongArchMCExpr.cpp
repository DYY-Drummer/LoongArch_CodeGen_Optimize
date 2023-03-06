//===-- LoongArchMCExpr.cpp - LoongArch specific MC expression classes --------------===//


#include "LoongArch.h"

#include "LoongArchMCExpr.h"
#include "llvm/BinaryFormat/ELF.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCAssembler.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCObjectStreamer.h"
#include "llvm/MC/MCSymbolELF.h"

using namespace llvm;

#define DEBUG_TYPE "loongarchmcexpr"

const LoongArchMCExpr *LoongArchMCExpr::create(LoongArchMCExpr::LoongArchExprKind Kind,
                                     const MCExpr *Expr, MCContext &Ctx) {
  return new (Ctx) LoongArchMCExpr(Kind, Expr);
}

const LoongArchMCExpr *LoongArchMCExpr::create(const MCSymbol *Symbol, LoongArchMCExpr::LoongArchExprKind Kind,
                         MCContext &Ctx) {
  const MCSymbolRefExpr *MCSym =
      MCSymbolRefExpr::create(Symbol, MCSymbolRefExpr::VK_None, Ctx);
  return new (Ctx) LoongArchMCExpr(Kind, MCSym);
}

const LoongArchMCExpr *LoongArchMCExpr::createGpOff(LoongArchMCExpr::LoongArchExprKind Kind,
                                          const MCExpr *Expr, MCContext &Ctx) {
  return create(Kind, create(LEK_None, create(LEK_GPREL, Expr, Ctx), Ctx), Ctx);
}

void LoongArchMCExpr::printImpl(raw_ostream &OS, const MCAsmInfo *MAI) const {
  int64_t AbsVal;

  switch (Kind) {
  case LEK_None:
  case LEK_Special:
    llvm_unreachable("LEK_None and LEK_Special are invalid");
    break;
  case LEK_CALL_HI20:
    OS << "%call_hi";
    break;
  case LEK_CALL_LO12:
    OS << "%call_lo";
    break;
  case LEK_DTP_HI:
    OS << "%dtp_hi";
    break;
  case LEK_DTP_LO:
    OS << "%dtp_lo";
    break;
  case LEK_GOT:
    OS << "%got";
    break;
  case LEK_GOTTPREL:
    OS << "%gottprel";
    break;
  case LEK_GOT_CALL:
    OS << "%call16";
    break;
  case LEK_GOT_DISP:
    OS << "%got_disp";
    break;
  case LEK_GOT_HI20:
    OS << "%got_hi";
    break;
  case LEK_GOT_LO12:
    OS << "%got_lo";
    break;
  case LEK_GPREL:
    OS << "%gp_rel";
    break;
  case LEK_ABS_HI:
    OS << "%hi";
    break;
  case LEK_ABS_LO:
    OS << "%lo";
    break;
  case LEK_TLSGD:
    OS << "%tlsgd";
    break;
  case LEK_TLSLDM:
    OS << "%tlsldm";
    break;
  case LEK_TP_HI:
    OS << "%tp_hi";
    break;
  case LEK_TP_LO:
    OS << "%tp_lo";
    break;
  }

  OS << '(';
  if (Expr->evaluateAsAbsolute(AbsVal))
    OS << AbsVal;
  else
    Expr->print(OS, MAI, true);
  OS << ')';
}

bool
LoongArchMCExpr::evaluateAsRelocatableImpl(MCValue &Res,
                                      const MCAsmLayout *Layout,
                                      const MCFixup *Fixup) const {
  return getSubExpr()->evaluateAsRelocatable(Res, Layout, Fixup);
}

void LoongArchMCExpr::visitUsedExpr(MCStreamer &Streamer) const {
  Streamer.visitUsedExpr(*getSubExpr());
}

void LoongArchMCExpr::fixELFSymbolsInTLSFixups(MCAssembler &Asm) const {
  switch ((int)getKind()) {
  case LEK_None:
  case LEK_Special:
    llvm_unreachable("LEK_None and LEK_Special are invalid");
    break;
  case LEK_CALL_HI20:
  case LEK_CALL_LO12:
    break;
  }
}

bool LoongArchMCExpr::isGpOff(LoongArchExprKind &Kind) const {
  if (const LoongArchMCExpr *S1 = dyn_cast<const LoongArchMCExpr>(getSubExpr())) {
    if (const LoongArchMCExpr *S2 = dyn_cast<const LoongArchMCExpr>(S1->getSubExpr())) {
      if (S1->getKind() == LEK_None && S2->getKind() == LEK_GPREL) {
        Kind = getKind();
        return true;
      }
    }
  }
  return false;
}

