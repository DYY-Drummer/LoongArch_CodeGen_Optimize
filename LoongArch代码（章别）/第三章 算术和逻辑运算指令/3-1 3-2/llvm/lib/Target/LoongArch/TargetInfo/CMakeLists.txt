# llvm 10.0.0 change from add_llvm_library to add_llvm_component_library
add_llvm_component_library(LLVMLoongArchInfo
  LoongArchTargetInfo.cpp

  LINK_COMPONENTS
  Support

  ADD_TO_COMPONENT
  LoongArch
  )

