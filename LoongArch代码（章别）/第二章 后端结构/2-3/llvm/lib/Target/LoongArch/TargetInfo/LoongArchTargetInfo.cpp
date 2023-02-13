//===-- LoongArchTargetInfo.cpp - LoongArch Target Implementation -------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "LoongArch.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/TargetRegistry.h"
using namespace llvm;

Target llvm::TheLoongArchTarget;

extern "C" void LLVMInitializeLoongArchTargetInfo() {
  RegisterTarget<Triple::loongarch,
        /*HasJIT=*/true> X(TheLoongArchTarget, "loongarch", "LOONGARCH (32-bit little endian)", "LoongArch");

}

