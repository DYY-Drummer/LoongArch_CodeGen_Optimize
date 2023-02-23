//===-- LoongArch.td - Describe the LoongArch Target Machine ---------*- tablegen -*-===//

// Calling Conv, Instruction Descriptions
//===----------------------------------------------------------------------===//
include "llvm/Target/Target.td"
include "LoongArchRegisterInfo.td"
include "LoongArchSchedule.td"
include "LoongArchInstrInfo.td"
include "LoongArchCallingConv.td"
//===----------------------------------------------------------------------===//
// LoongArch SUbtarget features
//===----------------------------------------------------------------------===//
// LoongArch is divided into two versions, the 32-bit version (LA32) and the
// 64-bit version (LA64), this project only implements 32-bit version
// Single Precision floating point

//the second parameter "HasSlt" indicate the function handling the predicate
def FeatureSlt            : SubtargetFeature<"slt", "HasSlt", "true",
        "Enable 'slt' instructions.">;
def FeatureLoongArch32        : SubtargetFeature<"loongarch32", "LoongArchArchVersion",
"LoongArch32", "LA32 Basic Integer and Privilege Instruction Set",
[FeatureSlt]>;



def FeatureBasicF
: SubtargetFeature<"f", "HasBasicF", "true",
        "'F' (Single-Precision Floating-Point)">;
def HasBasicF
: Predicate<"Subtarget->hasBasicF()">,
AssemblerPredicate<"FeatureBasicF",
"'F' (Single-Precision Floating-Point)">;

// Double Precision floating point
def FeatureBasicD
: SubtargetFeature<"d", "HasBasicD", "true",
"'D' (Double-Precision Floating-Point)",
[FeatureBasicF]>;
def HasBasicD
: Predicate<"Subtarget->hasBasicD()">,
AssemblerPredicate<"FeatureBasicD",
"'D' (Double-Precision Floating-Point)">;

// Loongson SIMD eXtension (LSX)
def FeatureExtLSX
: SubtargetFeature<"lsx", "HasExtLSX", "true",
"'LSX' (Loongson SIMD Extension)", [FeatureBasicD]>;
def HasExtLSX
: Predicate<"Subtarget->hasExtLSX()">,
AssemblerPredicate<"FeatureExtLSX",
"'LSX' (Loongson SIMD Extension)">;

// Loongson Advanced SIMD eXtension (LASX)
def FeatureExtLASX
: SubtargetFeature<"lasx", "HasExtLASX", "true",
"'LASX' (Loongson Advanced SIMD Extension)",
[FeatureExtLSX]>;
def HasExtLASX
: Predicate<"Subtarget->hasExtLASX()">,
AssemblerPredicate<"FeatureExtLASX",
"'LASX' (Loongson Advanced SIMD Extension)">;

// Loongson VirtualiZation (LVZ)
def FeatureExtLVZ
: SubtargetFeature<"lvz", "HasExtLVZ", "true",
        "'LVZ' (Loongson Virtualization Extension)">;
def HasExtLVZ
: Predicate<"Subtarget->hasExtLVZ()">,
AssemblerPredicate<"FeatureExtLVZ",
"'LVZ' (Loongson Virtualization Extension)">;

// Loongson Binary Translation (LBT)
def FeatureExtLBT
: SubtargetFeature<"lbt", "HasExtLBT", "true",
        "'LBT' (Loongson Binary Translation Extension)">;
def HasExtLBT
: Predicate<"Subtarget->hasExtLBT()">,
AssemblerPredicate<"FeatureExtLBT",
"'LBT' (Loongson Binary Translation Extension)">;

// Expand la.global as la.pcrel
def LaGlobalWithPcrel
: SubtargetFeature<"la-global-with-pcrel", "HasLaGlobalWithPcrel", "true",
        "Expand la.global as la.pcrel">;
def HasLaGlobalWithPcrel
: Predicate<"Subtarget->hasLaGlobalWithPcrel()">,
AssemblerPredicate<"LaGlobalWithPcrel",
"Expand la.global as la.pcrel">;

// Expand la.global as la.abs
def LaGlobalWithAbs
: SubtargetFeature<"la-global-with-abs", "HasLaGlobalWithAbs", "true",
        "Expand la.global as la.abs">;
def HasLaGlobalWithAbs
: Predicate<"Subtarget->hasLaGlobalWithAbs()">,
AssemblerPredicate<"LaGlobalWithAbs",
"Expand la.global as la.abs">;

// Expand la.local as la.abs
def LaLocalWithAbs
: SubtargetFeature<"la-local-with-abs", "HasLaLocalWithAbs", "true",
        "Expand la.local as la.abs">;
def HasLaLocalWithAbs
: Predicate<"Subtarget->hasLaLocalWithAbs()">,
AssemblerPredicate<"LaLocalWithAbs",
"Expand la.local as la.abs">;


//===----------------------------------------------------------------------===//
// LoongArch processors supported
//===----------------------------------------------------------------------===//
class Proc<string Name, list<SubtargetFeature> Features>
: Processor<Name, LoongArchGenericItineraries, Features>;

def : Proc<"loongarch32", [FeatureLoongArch32]>;

// Above make LoongArchGenSubtargetInfo.inc set feature bit as the following order:
//enum {
//    FeatureBasicD = 0,
//    FeatureBasicF = 1,
//    FeatureExtLASX = 2,
//    FeatureExtLBT = 3,
//    FeatureExtLSX = 4,
//    FeatureExtLVZ = 5,
//    FeatureLoongArch32 = 6,
//    FeatureSlt = 7,
//    LaGlobalWithAbs = 8,
//    LaGlobalWithPcrel = 9,
//    LaLocalWithAbs = 10,
//    NumSubtargetFeatures = 11
//};

def LoongArchInstrInfo : InstrInfo;

// Will generate LoongArchGenAsmWrite.inc included by LoongArchInstPrinter.cpp, contents
// as follows,
// void LoongArchInstPrinter::printInstruction(const MCInst *MI, raw_ostream &O) {...}
// const char* LoongArchInstPrinter::getRegisterName(unsigned RegNo) {...}
def LoongArch : Target {
// def LoongArchInstrInfo : InstrInfo as before.
let InstructionSet = LoongArchInstrInfo;
}
