//===-- LoongArchABIInfo.cpp - Information about LoongArch ABI ------------*- C++ -*-===//
//===----------------------------------------------------------------------===//
//
// Design for LoongArch Application Binary Interface.
//
//===----------------------------------------------------------------------===//

#include "LoongArchABIInfo.h"
#include "LoongArchRegisterInfo.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/MC/MCTargetOptions.h"
#include "llvm/Support/CommandLine.h"

using namespace llvm;

static cl::opt<bool>
        EnableLoongArchILP32FCalls("loongarch-stack-calls", cl::Hidden,
                                   cl::desc("LOONGARCH stack call: use stack only to pass arguments(For debug purpose, may be replaced by ILP32F)."),
                                   //cl::desc("LOONGARCH ILP32F call: use 32-bit general register, 32-bit float point register and stack to pass arguments."),
                                   cl::init(false));
static cl::opt<bool>
        EnableLoongArchILP32DCalls("loongarch-ilp32d-calls", cl::Hidden,
                                   cl::desc("LOONGARCH ILP32D call: use 32-bit general register, 64-bit float point register and stack to pass arguments."),
                                   cl::init(false));
namespace {
    //use $a2-$a7 as arguments register ($a0-a1 are return value registers)
    static const MCPhysReg ILP32SIntRegs[8] = {
            LoongArch::A2,
            LoongArch::A3,
            LoongArch::A4,
            LoongArch::A5,
            LoongArch::A6,
            LoongArch::A7};
    //TODO: implement ILP32F and ILP32D
    static const MCPhysReg ILP32FIntRegs = {};
    static const MCPhysReg ILP32DIntRegs = {};
}

const ArrayRef<MCPhysReg> LoongArchABIInfo::GetByValArgRegs() const {
    if (IsILP32S())
        return makeArrayRef(ILP32SIntRegs);
    if (IsILP32F())
        return makeArrayRef(ILP32FIntRegs);
    if (IsILP32D())
        return makeArrayRef(ILP32DIntRegs);
    llvm_unreachable("Unhandled ABI");
}

const ArrayRef<MCPhysReg> LoongArchABIInfo::GetVarArgRegs() const {
    if (IsILP32S())
        return makeArrayRef(ILP32SIntRegs);
    if (IsILP32F())
        return makeArrayRef(ILP32FIntRegs);
    if (IsILP32D())
        return makeArrayRef(ILP32DIntRegs);

    llvm_unreachable("Unhandled ABI");
}

unsigned LoongArchABIInfo::GetCalleeAllocdArgSizeInBytes(CallingConv::ID CC) const {
    if (IsILP32S())
        return CC != 0;
    if (IsILP32F())
        return 0;
    if (IsILP32D())
        return 0;
    llvm_unreachable("Unhandled ABI");
}

LoongArchABIInfo LoongArchABIInfo::computeTargetABI() {
    LoongArchABIInfo abi(ABI::Unknown);

    if (EnableLoongArchILP32FCalls)
        abi = ABI::ILP32F;
    else if(EnableLoongArchILP32DCalls)
        abi = ABI::ILP32D;
    else
        abi = ABI::ILP32S;

    // Assert exactly one ABI was chosen.
    assert(abi.ThisABI != ABI::Unknown);

    return abi;
}

unsigned LoongArchABIInfo::GetStackPtr() const { return LoongArch::SP; }

unsigned LoongArchABIInfo::GetFramePtr() const { return LoongArch::FP; }

unsigned LoongArchABIInfo::GetNullPtr() const { return LoongArch::ZERO; }

unsigned LoongArchABIInfo::GetEhDataReg(unsigned I) const {
    static const unsigned EhDataReg[] = {
            LoongArch::A2,
            LoongArch::A3,
            LoongArch::A4,
            LoongArch::A5,
            LoongArch::A6,
            LoongArch::A7};

    return EhDataReg[I];
}
//number of register used to pass arguments
int LoongArchABIInfo::EhDataRegSize() const {
        return 6;
}