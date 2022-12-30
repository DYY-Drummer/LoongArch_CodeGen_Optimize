# LoongArch代码生成与优化实验手册

## 环境目录准备

+ 要创建编译器后端，首先需要在`llvm/lib/Target/`下创建一个子目录来保存与目标相关的所有文件，例如`lib/Target/LoongArch`
+ 在这个新目录中创建一个CMakeList.txt，它包含了你所需要的编译的所有cpp文件信息以及需要的组件等，其格式有特定的规范，最简单的方式是直接复制其它Target（例如Mips）下的CMakeList.txt并修改。

```cmake
add_llvm_component_group(LoongArch)

set(LLVM_TARGET_DEFINITIONS LoongArch.td)

//标准的文件命名，只需将“MIPS”改为“LoongArch”
tablegen(LLVM LoongArchGenAsmMatcher.inc -gen-asm-matcher)
tablegen(LLVM LoongArchGenAsmWriter.inc -gen-asm-writer)
tablegen(LLVM LoongArchGenDAGISel.inc -gen-dag-isel)
tablegen(LLVM LoongArchGenDisassemblerTables.inc -gen-disassembler)
tablegen(LLVM LoongArchGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM LoongArchGenMCPseudoLowering.inc -gen-pseudo-lowering)
tablegen(LLVM LoongArchGenMCCodeEmitter.inc -gen-emitter)
tablegen(LLVM LoongArchGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM LoongArchGenSubtargetInfo.inc -gen-subtarget)

add_public_tablegen_target(LoongArchCommonTableGen)

add_llvm_target(LoongArchCodeGen
  LoongArchAsmPrinter.cpp
 ...//所有需要编译的cpp文件

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
  
//添加其它文件路径，是LLVM后端标准结构，所有Target都一样
add_subdirectory(AsmParser)
add_subdirectory(Disassembler)
add_subdirectory(MCTargetDesc)
add_subdirectory(TargetInfo)

```

+ 为了让你的Target实际运行起来，你需要实现一个TargetMachine的子类，例如`lib/Target/LoongArchTargetMachine.cpp`，（创建后如上一步所述，将cpp文件名添加到CMakeList的add_llvm_target中。
+ 要让 LLVM 实际构建和链接新Target，需要使用 `cmake -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=Dummy`命令，这样就不需要将新添加的Target添加到所有Target的列表中。



## TableGen语法

参考教程：https://blog.csdn.net/SiberiaBear/article/details/103539530

## Target Machine

> LLVMTargetMachine是LLVM代码生成器的基类，包含各种抽象方法，具体实现应由继承它的LoongArchTargetMachine类来完成

+ 类似地，我们应该直接复制现有的TargetMachine类实现和头文件（例如Mips的），再进行更改。命名为`LoongArchTargetMachine.cpp`和`LoongArchTargetMachine.h`。
+ 
