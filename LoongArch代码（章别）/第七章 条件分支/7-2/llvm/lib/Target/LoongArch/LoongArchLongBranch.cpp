//===-- LoongArchLongBranch.cpp - Emit long branches ---------------------------===//
//
// This pass expands a branch or jump instruction into a long branch if its
// offset is too large to fit into its immediate field.
//
// FIXME: Fix pc-region jump instructions which cross 256MB segment boundaries.
//===----------------------------------------------------------------------===//

#include "LoongArch.h"

#include "MCTargetDesc/LoongArchBaseInfo.h"
#include "LoongArchMachineFunctionInfo.h"
#include "LoongArchTargetMachine.h"
#include "llvm/ADT/Statistic.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/CodeGen/TargetRegisterInfo.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Target/TargetMachine.h"

using namespace llvm;

#define DEBUG_TYPE "loongarch-long-branch"

STATISTIC(LongBranches, "Number of long branches.");

static cl::opt<bool> ForceLongBranch(
  "force-loongarch-long-branch",
  cl::init(false),
  cl::desc("LOONGARCH: Expand all branches to long format."),
  cl::Hidden);

namespace {
  typedef MachineBasicBlock::iterator Iter;
  typedef MachineBasicBlock::reverse_iterator ReverseIter;

  struct MBBInfo {
    uint64_t Size, Address;
    bool HasLongBranch;
    MachineInstr *Br;

    MBBInfo() : Size(0), HasLongBranch(false), Br(nullptr) {}
  };

  class LoongArchLongBranch : public MachineFunctionPass {

  public:
    static char ID;
      LoongArchLongBranch(TargetMachine &tm)
        : MachineFunctionPass(ID), TM(tm), IsPIC(TM.isPositionIndependent()),
          ABI(static_cast<const LoongArchTargetMachine &>(TM).getABI()) {}

    StringRef getPassName() const override {
      return "LoongArch Long Branch";
    }

    bool runOnMachineFunction(MachineFunction &F) override;

  private:
    void splitMBB(MachineBasicBlock *MBB);
    void initMBBInfo();
    int64_t computeOffset(const MachineInstr *Br);
    void replaceBranch(MachineBasicBlock &MBB, Iter Br, const DebugLoc &DL,
                       MachineBasicBlock *MBBOpnd);
    void expandToLongBranch(MBBInfo &Info);

    const TargetMachine &TM;
    MachineFunction *MF;
    SmallVector<MBBInfo, 16> MBBInfos;
    bool IsPIC;
    LoongArchABIInfo ABI;
    unsigned LongBranchSeqSize;
  };

  char LoongArchLongBranch::ID = 0;
} // end of anonymous namespace

/// createLoongArchLongBranchPass - Returns a pass that converts branches to long
/// branches.
FunctionPass *llvm::createLoongArchLongBranchPass(LoongArchTargetMachine &tm) {
  return new LoongArchLongBranch(tm);
}

/// Iterate over list of Br's operands and search for a MachineBasicBlock
/// operand.
static MachineBasicBlock *getTargetMBB(const MachineInstr &Br) {
  for (unsigned I = 0, E = Br.getDesc().getNumOperands(); I < E; ++I) {
    const MachineOperand &MO = Br.getOperand(I);

    if (MO.isMBB())
      return MO.getMBB();
  }

  llvm_unreachable("This instruction does not have an MBB operand.");
}

// reverse the list of instructions backwards until a non-debug instruction is
// found or it reaches E.
static ReverseIter getNonDebugInstr(ReverseIter B, const ReverseIter &E) {
  for (; B != E; ++B)
    if (!B->isDebugValue())
      return B;

  return E;
}

// Split MBB if it has two direct jumps/branches.
void LoongArchLongBranch::splitMBB(MachineBasicBlock *MBB) {
  ReverseIter End = MBB->rend();
  ReverseIter LastBr = getNonDebugInstr(MBB->rbegin(), End);

  // Return if MBB has no branch instructions.
  if ((LastBr == End) ||
      (!LastBr->isConditionalBranch() && !LastBr->isUnconditionalBranch()))
    return;

  ReverseIter FirstBr = getNonDebugInstr(std::next(LastBr), End);

  // MBB has only one branch instruction if FirstBr is not a branch
  // instruction.
  if ((FirstBr == End) ||
      (!FirstBr->isConditionalBranch() && !FirstBr->isUnconditionalBranch()))
    return;

  assert(!FirstBr->isIndirectBranch() && "Unexpected indirect branch found in long branch handler.");

  // Create a new MBB. Move instructions in MBB to the newly created MBB.
  MachineBasicBlock *NewMBB =
    MF->CreateMachineBasicBlock(MBB->getBasicBlock());

  // Insert NewMBB and fix control flow.
  MachineBasicBlock *Tgt = getTargetMBB(*FirstBr);
  NewMBB->transferSuccessors(MBB);
  if (Tgt != getTargetMBB(*LastBr))
    NewMBB->removeSuccessor(Tgt, true);
  MBB->addSuccessor(NewMBB);
  MBB->addSuccessor(Tgt);
  MF->insert(std::next(MachineFunction::iterator(MBB)), NewMBB);

  NewMBB->splice(NewMBB->end(), MBB, LastBr.getReverse(), MBB->end());
}

// Fill MBBInfos.
void LoongArchLongBranch::initMBBInfo() {
  // Split the MBBs if they have two branches. Each basic block should have at
  // most one branch after this loop is executed.
  for (auto &MBB : *MF)
    splitMBB(&MBB);

  MF->RenumberBlocks();
  MBBInfos.clear();
  MBBInfos.resize(MF->size());

  const LoongArchInstrInfo *TII =
      static_cast<const LoongArchInstrInfo *>(MF->getSubtarget().getInstrInfo());
  for (unsigned I = 0, E = MBBInfos.size(); I < E; ++I) {
    MachineBasicBlock *MBB = MF->getBlockNumbered(I);

    // Compute size of MBB.
    for (MachineBasicBlock::instr_iterator MI = MBB->instr_begin();
         MI != MBB->instr_end(); ++MI)
      MBBInfos[I].Size += TII->GetInstSizeInBytes(*MI);

    // Search for MBB's branch instruction.
    ReverseIter End = MBB->rend();
    ReverseIter Br = getNonDebugInstr(MBB->rbegin(), End);

    if ((Br != End) && !Br->isIndirectBranch() &&
        (Br->isConditionalBranch() || (Br->isUnconditionalBranch() && IsPIC)))
      MBBInfos[I].Br = &(*Br.getReverse());
  }
}

// Compute offset of branch in number of bytes.
int64_t LoongArchLongBranch::computeOffset(const MachineInstr *Br) {
  int64_t Offset = 0;
  int ThisMBB = Br->getParent()->getNumber();
  int TargetMBB = getTargetMBB(*Br)->getNumber();

  // Compute offset of a forward branch.
  if (ThisMBB < TargetMBB) {
    for (int N = ThisMBB + 1; N < TargetMBB; ++N)
      Offset += MBBInfos[N].Size;

    return Offset + 4;
  }

  // Compute offset of a backward branch.
  for (int N = ThisMBB; N >= TargetMBB; --N)
    Offset += MBBInfos[N].Size;

  return -Offset + 4;
}

// Replace Br with a branch which has the opposite condition code and a
// MachineBasicBlock operand MBBOpnd.
void LoongArchLongBranch::replaceBranch(MachineBasicBlock &MBB, Iter Br,
                                   const DebugLoc &DL,
                                   MachineBasicBlock *MBBOpnd) {
  const LoongArchInstrInfo *TII = static_cast<const LoongArchInstrInfo *>(
      MBB.getParent()->getSubtarget().getInstrInfo());
  unsigned NewOpc = TII->getOppositeBranchOpc(Br->getOpcode());
  const MCInstrDesc &NewDesc = TII->get(NewOpc);

  MachineInstrBuilder MIB = BuildMI(MBB, Br, DL, NewDesc);

  for (unsigned I = 0, E = Br->getDesc().getNumOperands(); I < E; ++I) {
    MachineOperand &MO = Br->getOperand(I);

    if (!MO.isReg()) {
      assert(MO.isMBB() && "MBB operand expected.");
      break;
    }

    MIB.addReg(MO.getReg());
  }

  MIB.addMBB(MBBOpnd);

  if (Br->hasDelaySlot()) {
    // Bundle the instruction in the delay slot to the newly created branch
    // and erase the original branch.
    assert(Br->isBundledWithSucc());
    MachineBasicBlock::instr_iterator II = Br.getInstrIterator();
    MIBundleBuilder(&*MIB).append((++II)->removeFromBundle());
  }
  Br->eraseFromParent();
}

// Expand branch instructions to long branches.
// TODO: This function has to be fixed for BEQZ21 and BNEZ21, because it
// currently assumes that all branches have 16-bit offsets, and will produce
// wrong code if branches whose allowed offsets are [-128, -126, ..., 126]
// are present.
void LoongArchLongBranch::expandToLongBranch(MBBInfo &I) {
  MachineBasicBlock::iterator Pos;
  MachineBasicBlock *MBB = I.Br->getParent(), *TgtMBB = getTargetMBB(*I.Br);
  DebugLoc DL = I.Br->getDebugLoc();
  const BasicBlock *BB = MBB->getBasicBlock();
  MachineFunction::iterator FallThroughMBB = ++MachineFunction::iterator(MBB);
  MachineBasicBlock *LongBrMBB = MF->CreateMachineBasicBlock(BB);
  const LoongArchSubtarget &Subtarget =
      static_cast<const LoongArchSubtarget &>(MF->getSubtarget());
  const LoongArchInstrInfo *TII =
      static_cast<const LoongArchInstrInfo *>(Subtarget.getInstrInfo());

  MF->insert(FallThroughMBB, LongBrMBB);
  MBB->replaceSuccessor(TgtMBB, LongBrMBB);

  if (IsPIC) {
    MachineBasicBlock *BlTgtMBB = MF->CreateMachineBasicBlock(BB);
    MF->insert(FallThroughMBB, BlTgtMBB);
    LongBrMBB->addSuccessor(BlTgtMBB);
    BlTgtMBB->addSuccessor(TgtMBB);

    unsigned BlOp = LoongArch::BL;

    // $longbr:
    //  addi.w $sp, $sp, -8
    //  st.w $ra, $sp, 0
    //  lu12i.w $r21, %hi($tgt - $bltgt)
    //  addi.w $ra, $ra, %lo($tgt - $bltgt)
    //  bl $bltgt
    //  nop
    // $bltgt:
    //  addi.w $r21, $ra, $r21
    //  addi.w $sp, $sp, 8
    //  ld $ra, $sp, 0
    //  jr $r21
    //  nop
    // $fallthrough:
    //

    Pos = LongBrMBB->begin();

    BuildMI(*LongBrMBB, Pos, DL, TII->get(LoongArch::ADDI_W), LoongArch::SP)
      .addReg(LoongArch::SP).addImm(-8);
    BuildMI(*LongBrMBB, Pos, DL, TII->get(LoongArch::ST_W)).addReg(LoongArch::RA)
      .addReg(LoongArch::SP).addImm(0);

    // LU12I_W and ADDI_W instructions create 32-bit offset of the target basic
    // block from the target of BL instruction.  We cannot use immediate
    // value for this offset because it cannot be determined accurately when
    // the program has inline assembly statements.  We therefore use the
    // relocation expressions %hi($tgt-$bltgt) and %lo($tgt-$bltgt) which
    // are resolved during the fixup, so the values will always be correct.
    //
    // Since we cannot create %hi($tgt-$bltgt) and %lo($tgt-$bltgt)
    // expressions at this point (it is possible only at the MC layer),
    // we replace LU12I_W and ADDI_W with pseudo instructions
    // LONG_BRANCH_LU12I_W and LONG_BRANCH_ADDI_W, and add both basic
    // blocks as operands to these instructions.  When lowering these pseudo
    // instructions to LU12I_W and ADDI_W in the MC layer, we will create
    // %hi($tgt-$bltgt) and %lo($tgt-$bltgt) expressions and add them as
    // operands to lowered instructions.

    BuildMI(*LongBrMBB, Pos, DL, TII->get(LoongArch::LONG_BRANCH_LU12I_W), LoongArch::R21)
      .addMBB(TgtMBB).addMBB(BlTgtMBB);
    BuildMI(*LongBrMBB, Pos, DL, TII->get(LoongArch::LONG_BRANCH_ADDI_W), LoongArch::R21)
      .addReg(LoongArch::R21).addMBB(TgtMBB).addMBB(BlTgtMBB);
    MIBundleBuilder(*LongBrMBB, Pos)
        .append(BuildMI(*MF, DL, TII->get(BlOp)).addMBB(BlTgtMBB));

    Pos = BlTgtMBB->begin();

    BuildMI(*BlTgtMBB, Pos, DL, TII->get(LoongArch::ADDI_W), LoongArch::R21)
      .addReg(LoongArch::RA).addReg(LoongArch::R21);
    BuildMI(*BlTgtMBB, Pos, DL, TII->get(LoongArch::LD_W), LoongArch::RA)
      .addReg(LoongArch::SP).addImm(0);
    BuildMI(*BlTgtMBB, Pos, DL, TII->get(LoongArch::ADDI_W), LoongArch::SP)
      .addReg(LoongArch::SP).addImm(8);

    MIBundleBuilder(*BlTgtMBB, Pos)
      .append(BuildMI(*MF, DL, TII->get(LoongArch::JIRL)).addReg(LoongArch::ZERO).addReg(LoongArch::R21).addImm(0))
      .append(BuildMI(*MF, DL, TII->get(LoongArch::NOP)));

    assert(LongBrMBB->size() + BlTgtMBB->size() == LongBranchSeqSize);
  } else {
    // $longbr:
    //  b $tgt
    //  nop
    // $fallthrough:
    //
    Pos = LongBrMBB->begin();
    LongBrMBB->addSuccessor(TgtMBB);
    MIBundleBuilder(*LongBrMBB, Pos)
      .append(BuildMI(*MF, DL, TII->get(LoongArch::B)).addMBB(TgtMBB))
      .append(BuildMI(*MF, DL, TII->get(LoongArch::NOP)));

    assert(LongBrMBB->size() == LongBranchSeqSize);
  }

  if (I.Br->isUnconditionalBranch()) {
    // Change branch destination.
    assert(I.Br->getDesc().getNumOperands() == 1);
    I.Br->RemoveOperand(0);
    I.Br->addOperand(MachineOperand::CreateMBB(LongBrMBB));
  } else
    // Change branch destination and reverse condition.
    replaceBranch(*MBB, I.Br, DL, &*FallThroughMBB);
}

static void emitGPDisp(MachineFunction &F, const LoongArchInstrInfo *TII) {
  MachineBasicBlock &MBB = F.front();
  MachineBasicBlock::iterator I = MBB.begin();
  DebugLoc DL = MBB.findDebugLoc(MBB.begin());
  BuildMI(MBB, I, DL, TII->get(LoongArch::LU12I_W), LoongArch::A0)
    .addExternalSymbol("_gp_disp", LoongArch::MO_ABS_HI);
  BuildMI(MBB, I, DL, TII->get(LoongArch::ADDI_W), LoongArch::A0)
    .addReg(LoongArch::A0).addExternalSymbol("_gp_disp", LoongArch::MO_ABS_LO);
  MBB.removeLiveIn(LoongArch::A0);
}

bool LoongArchLongBranch::runOnMachineFunction(MachineFunction &F) {
  const LoongArchSubtarget &STI =
      static_cast<const LoongArchSubtarget &>(F.getSubtarget());
  const LoongArchInstrInfo *TII =
      static_cast<const LoongArchInstrInfo *>(STI.getInstrInfo());
  LongBranchSeqSize =
      !IsPIC ? 2 : 10;

  if (!STI.enableLongBranchPass())
    return false;
  if (IsPIC && static_cast<const LoongArchTargetMachine &>(TM).getABI().IsILP32S() &&
      F.getInfo<LoongArchMachineFunctionInfo>()->globalBaseRegSet())
    emitGPDisp(F, TII);

  MF = &F;
  initMBBInfo();

  SmallVectorImpl<MBBInfo>::iterator I, E = MBBInfos.end();
  bool EverMadeChange = false, MadeChange = true;

  while (MadeChange) {
    MadeChange = false;

    for (I = MBBInfos.begin(); I != E; ++I) {
      // Skip if this MBB doesn't have a branch or the branch has already been
      // converted to a long branch.
      if (!I->Br || I->HasLongBranch)
        continue;

      int ShVal = 4;
      int64_t Offset = computeOffset(I->Br) / ShVal;

      // Check if offset fits into 16-bit immediate field of branches.
      if (!ForceLongBranch && isInt<16>(Offset))
        continue;

      I->HasLongBranch = true;
      I->Size += LongBranchSeqSize * 4;
      ++LongBranches;
      EverMadeChange = MadeChange = true;
    }
  }

  if (!EverMadeChange)
    return true;

  // Compute basic block addresses.
  if (IsPIC) {
    uint64_t Address = 0;

    for (I = MBBInfos.begin(); I != E; Address += I->Size, ++I)
      I->Address = Address;
  }

  // Do the expansion.
  for (I = MBBInfos.begin(); I != E; ++I)
    if (I->HasLongBranch)
      expandToLongBranch(*I);

  MF->RenumberBlocks();

  return true;
}

