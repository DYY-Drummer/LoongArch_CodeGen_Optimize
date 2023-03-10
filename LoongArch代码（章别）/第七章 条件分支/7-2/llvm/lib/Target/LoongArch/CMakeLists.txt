set(LLVM_TARGET_DEFINITIONS LoongArch.td)

# Generate LoongArchGenRegisterInfo.inc and LoongArchGenInstrInfo.inc which included by
#  your hand code C++ files. 
# LoongArchGenRegisterInfo.inc came from LoongArchRegisterInfo.td, LoongArchGenInstrInfo.inc
#  came from LoongArchInstrInfo.td.
tablegen(LLVM LoongArchGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM LoongArchGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM LoongArchGenSubtargetInfo.inc -gen-subtarget)
tablegen(LLVM LoongArchGenMCPseudoLowering.inc -gen-pseudo-lowering)
tablegen(LLVM LoongArchGenDAGISel.inc -gen-dag-isel)
tablegen(LLVM LoongArchGenCallingConv.inc -gen-callingconv)
tablegen(LLVM LoongArchGenCodeEmitter.inc -gen-emitter)
tablegen(LLVM LoongArchGenMCCodeEmitter.inc -gen-emitter)
tablegen(LLVM LoongArchGenAsmWriter.inc -gen-asm-writer)

# LoongArchCommonTableGen must be defined
add_public_tablegen_target(LoongArchCommonTableGen)

# LoongArchCodeGen should match with LLVMBuild.txt LoongArchCodeGen
add_llvm_target(LoongArchCodeGen
  LoongArchTargetMachine.cpp
  LoongArchInstrInfo.cpp
  LoongArchSEInstrInfo.cpp
  LoongArchISelLowering.cpp
  LoongArchMachineFunctionInfo.cpp
  LoongArchRegisterInfo.cpp
  LoongArchFrameLowering.cpp
  LoongArchSEFrameLowering.cpp
  LoongArchSEISelLowering.cpp
  LoongArchSERegisterInfo.cpp
  LoongArchSubtarget.cpp
  LoongArchTargetObjectFile.cpp
  LoongArchAsmPrinter.cpp
  LoongArchMCInstLower.cpp
  LoongArchISelDAGToDAG.cpp
  LoongArchSEISelDAGToDAG.cpp
  LoongArchAnalyzeImmediate.cpp
  LoongArchLongBranch.cpp  

  LINK_COMPONENTS
  Analysis
  AsmPrinter
  CodeGen
  Core
  MC
  LoongArchDesc
  LoongArchInfo
  LoongArchAsmPrinter
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
add_subdirectory(InstPrinter)
