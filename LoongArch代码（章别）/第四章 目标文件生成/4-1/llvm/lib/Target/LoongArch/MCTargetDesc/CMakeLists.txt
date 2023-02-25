# MCTargetDesc/CMakeLists.txt
add_llvm_component_library(LLVMLoongArchDesc
  LoongArchMCTargetDesc.cpp
  LoongArchABIInfo.cpp
  LoongArchMCAsmInfo.cpp
  LoongArchAsmBackend.cpp
  LoongArchMCCodeEmitter.cpp
  LoongArchMCExpr.cpp
  LoongArchELFObjectWriter.cpp
  LoongArchTargetStreamer.cpp
  
  LINK_COMPONENTS
  MC
  LoongArchInfo
  LoongArchAsmPrinter
  Support

  ADD_TO_COMPONENT
  LoongArch
  )

