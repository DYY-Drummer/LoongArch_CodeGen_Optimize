# MCTargetDesc/CMakeLists.txt
add_llvm_component_library(LLVMLoongArchDesc
  LoongArchMCTargetDesc.cpp
  LoongArchABIInfo.cpp
  LoongArchMCAsmInfo.cpp
  
  LINK_COMPONENTS
  MC
  LoongArchInfo
  Support

  ADD_TO_COMPONENT
  LoongArch
  )

