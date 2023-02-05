set(LLVM_TARGET_DEFINITIONS LoongArch.td)

# Generate LoongArchGenRegisterInfo.inc and LoongArchGenInstrInfo.inc which included by
#  your hand code C++ files. 
# LoongArchGenRegisterInfo.inc came from LoongArchRegisterInfo.td, LoongArchGenInstrInfo.inc
#  came from LoongArchInstrInfo.td.
tablegen(LLVM LoongArchGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM LoongArchGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM LoongArchGenSubtargetInfo.inc -gen-subtarget)
tablegen(LLVM LoongArchGenMCPseudoLowering.inc -gen-pseudo-lowering)

# LoongArchCommonTableGen must be defined
add_public_tablegen_target(LoongArchCommonTableGen)

# LoongArchCodeGen should match with LLVMBuild.txt LoongArchCodeGen
add_llvm_target(LoongArchCodeGen
  LoongArchTargetMachine.cpp

  LINK_COMPONENTS
  Analysis
  AsmPrinter
  CodeGen
  Core
  MC
  LoongArchDesc
  LoongArchInfo
  SelectionDAG
  Support
  Target
  GlobalISel

  ADD_TO_COMPONENT
  LoongArch
  )

# Should match with "subdirectories =  MCTargetDesc TargetInfo" in LLVMBuild.txt
add_subdirectory(TargetInfo)
add_subdirectory(MCTargetDesc)

