//===-- LoongArchSERegisterInfo.cpp - LOONGARCH Register Information ------== -------===//
//
// This file contains the LOONGARCH implementation of the TargetRegisterInfo
// class.
//
//===----------------------------------------------------------------------===//

#include "LoongArchSERegisterInfo.h"

using namespace llvm;

#define DEBUG_TYPE "loongarch-reg-info"

LoongArchSERegisterInfo::LoongArchSERegisterInfo(const LoongArchSubtarget &ST)
        : LoongArchRegisterInfo(ST) {}

const TargetRegisterClass *
LoongArchSERegisterInfo::intRegClass(unsigned Size) const {
    // LoongArch::GPRRegClass defined in LoongArchGenRegisterInfo.inc,
    // come from GPR in LoongArchRegisterInfo.td
    return &LoongArch::GPRRegClass;
}