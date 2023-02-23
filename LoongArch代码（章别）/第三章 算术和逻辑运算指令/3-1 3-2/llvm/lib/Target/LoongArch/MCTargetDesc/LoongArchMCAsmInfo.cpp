//===-- LoongArchMCAsmInfo.cpp - LoongArch Asm Info -----------------------*- C++ -*-===//
//
// This file contains the definitions of the LoongArchMCAsmInfo class.
//
//===----------------------------------------------------------------------===//

#include "LoongArchMCAsmInfo.h"

#include "llvm/ADT/Triple.h"

using namespace llvm;

void LoongArchMCAsmInfo::anchor() { }

LoongArchMCAsmInfo::LoongArchMCAsmInfo(const Triple &TheTriple) {
    if ((TheTriple.getArch() == Triple::loongarch))
        IsLittleEndian = false;  // the default is true

    AlignmentIsInBytes  = false;
    Data8bitsDirective = "\t.byte\t";
    Data16bitsDirective = "\t.half\t";
    Data32bitsDirective = "\t.word\t";
    Data64bitsDirective = "\t.dword\t";
    PrivateGlobalPrefix = "$";
    PrivateLabelPrefix  = "$";
    CommentString       = "#";
    ZeroDirective       = "\t.space\t";
    GPRel32Directive    = "\t.gpword\t";
    GPRel64Directive    = "\t.gpdword\t";
    WeakRefDirective    = "\t.weak\t";
    UseAssignmentForEHBegin  = true;

    SupportsDebugInformation = true;
    ExceptionsType           = ExceptionHandling::DwarfCFI;
    DwarfRegNumForCFI        = true;
}