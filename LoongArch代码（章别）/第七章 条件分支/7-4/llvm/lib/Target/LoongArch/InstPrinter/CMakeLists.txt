add_llvm_component_library(LLVMLoongArchAsmPrinter
  LoongArchInstPrinter.cpp

  LINK_COMPONENTS
  Support

  ADD_TO_COMPONENT
  LoongArch
  )