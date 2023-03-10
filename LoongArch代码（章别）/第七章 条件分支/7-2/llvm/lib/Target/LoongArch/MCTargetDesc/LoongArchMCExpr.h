//===-- LoongArchMCExpr.h - LoongArch specific MC expression classes ------*- C++ -*-===//

#ifndef LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHMCEXPR_H
#define LLVM_LIB_TARGET_LOONGARCH_MCTARGETDESC_LOONGARCHMCEXPR_H

#include "llvm/MC/MCAsmLayout.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCValue.h"

namespace llvm {

class LoongArchMCExpr : public MCTargetExpr {
public:
  enum LoongArchExprKind {
    LEK_None,
    LEK_ABS_HI,
    LEK_ABS_LO,
    LEK_CALL_HI20,
    LEK_CALL_LO12,
    LEK_DTP_HI,
    LEK_DTP_LO,
    LEK_GOT,
    LEK_GOTTPREL,
    LEK_GOT_CALL,
    LEK_GOT_DISP,
    LEK_GOT_HI20,
    LEK_GOT_LO12,
    LEK_GPREL,
    LEK_TLSGD,
    LEK_TLSLDM,
    LEK_TP_HI,
    LEK_TP_LO,
    LEK_Special,
  };

private:
  const LoongArchExprKind Kind;
  const MCExpr *Expr;

  explicit LoongArchMCExpr(LoongArchExprKind Kind, const MCExpr *Expr)
    : Kind(Kind), Expr(Expr) {}

public:
  static const LoongArchMCExpr *create(LoongArchExprKind Kind, const MCExpr *Expr,
                                  MCContext &Ctx);
  static const LoongArchMCExpr *create(const MCSymbol *Symbol,
                                       LoongArchMCExpr::LoongArchExprKind Kind, MCContext &Ctx);
  static const LoongArchMCExpr *createGpOff(LoongArchExprKind Kind, const MCExpr *Expr,
                                       MCContext &Ctx);

  /// Get the kind of this expression.
  LoongArchExprKind getKind() const { return Kind; }

  /// Get the child of this expression.
  const MCExpr *getSubExpr() const { return Expr; }

  void printImpl(raw_ostream &OS, const MCAsmInfo *MAI) const override;
  bool evaluateAsRelocatableImpl(MCValue &Res, const MCAsmLayout *Layout,
                                 const MCFixup *Fixup) const override;
  void visitUsedExpr(MCStreamer &Streamer) const override;
  MCFragment *findAssociatedFragment() const override {
    return getSubExpr()->findAssociatedFragment();
  }

  void fixELFSymbolsInTLSFixups(MCAssembler &Asm) const override;

  static bool classof(const MCExpr *E) {
    return E->getKind() == MCExpr::Target;
  }

  bool isGpOff(LoongArchExprKind &Kind) const;
  bool isGpOff() const {
      LoongArchExprKind Kind;
    return isGpOff(Kind);
  }
};
} // end namespace llvm

#endif

