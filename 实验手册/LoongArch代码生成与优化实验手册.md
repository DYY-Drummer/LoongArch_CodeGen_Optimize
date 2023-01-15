# LoongArch代码生成与优化实验手册

最好把虚拟机内存开到8G，磁盘分配200G

因为LLVM-Project编译完有60多G

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



![Mips指令类型](https://pic1.zhimg.com/v2-436dbf8377614721f32f79543308eb48_r.jpg)



### DAG

![set and add](/set and add.PNG)

+ A `set` node is an assignment node, i.e. it’s matching `$ra = ...` in the DAG, and is a special operator known to TableGen. An `add` node is just an ISD::ADD, matching a normal integer add in the DAG. So combined this is matching `$ra = $rb + $imm16` in the DAG (represented probably as something like `t2: i32 = add t0, t1`).





## Target Machine

> LLVMTargetMachine是LLVM代码生成器的基类，包含各种抽象方法，具体实现应由继承它的LoongArchTargetMachine类来完成

+ 类似地，我们应该直接复制现有的TargetMachine类实现和头文件（例如Mips的），再进行更改。命名为`LoongArchTargetMachine.cpp`和`LoongArchTargetMachine.h`。





## 编译



build 命令：

`cmake -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang -DCMAKE_BUILD_TYPE=Debug -G "Ninja" ../llvm`

`ninja -j4`

`-j4`命令为指定最大同时运行指令数为4（内存小的系统建议调小）

`ninja -j4`指令中途报错时，修复后可以再次执行`ninja -j4`，自动从出错的步骤继续开始

If you are having problems with limited memory and build time, please try building with ninja instead of make. Please consider configuring the following options with cmake:

> - **-G Ninja** Setting this option will allow you to build with ninja instead of make. Building with ninja significantly improves your build time, especially with incremental builds, and improves your memory usage.
> - **-DLLVM_USE_LINKER** Setting this option to lld will significantly reduce linking time for LLVM executables on ELF-based platforms, such as Linux. If you are building LLVM for the first time and lld is not available to you as a binary package, then you may want to use the gold linker as a faster alternative to GNU ld.
> - -DCMAKE_BUILD_TYPE Controls optimization level and debug information of the build. This setting can affect RAM and disk usage, see [CMAKE_BUILD_TYPE](https://llvm.org/docs/CMake.html#cmake-build-type) for more information.
> - -DLLVM_ENABLE_ASSERTIONS This option defaults to ON for Debug builds and defaults to OFF for Release builds. As mentioned in the previous option, using the Release build type and enabling assertions may be a good alternative to using the Debug build type.
> - -DLLVM_PARALLEL_LINK_JOBS Set this equal to number of jobs you wish to run simultaneously. This is similar to the -j option used with make, but only for link jobs. This option can only be used with ninja. You may wish to use a very low number of jobs, as this will greatly reduce the amount of memory used during the build process. If you have limited memory, you may wish to set this to 1.
> - **-DLLVM_TARGETS_TO_BUILD** Set this equal to the target you wish to build. You may wish to set this to X86; however, you will find a full list of targets within the llvm-project/llvm/lib/Target directory.
> - -DLLVM_OPTIMIZED_TABLEGEN Set this to ON to generate a fully optimized tablegen during your build. This will significantly improve your build time. This is only useful if you are using the Debug build type.
> - -DLLVM_ENABLE_PROJECTS Set this equal to the projects you wish to compile (e.g. clang, lld, etc.) If compiling more than one project, separate the items with a semicolon. Should you run into issues with the semicolon, try surrounding it with single quotes.
> - -DLLVM_ENABLE_RUNTIMES Set this equal to the runtimes you wish to compile (e.g. libcxx, libcxxabi, etc.) If compiling more than one runtime, separate the items with a semicolon. Should you run into issues with the semicolon, try surrounding it with single quotes.
> - -DCLANG_ENABLE_STATIC_ANALYZER Set this option to OFF if you do not require the clang static analyzer. This should improve your build time slightly.
> - -DLLVM_USE_SPLIT_DWARF Consider setting this to ON if you require a debug build, as this will ease memory pressure on the linker. This will make linking much faster, as the binaries will not contain any of the debug information; however, this will generate the debug information in the form of a DWARF object file (with the extension .dwo). This only applies to host platforms using ELF, such as Linux.

+ 使用lld加快编译 ``-DLLVM_USE_LINKER=lld`.`
+ 如果必须rebuild的话（更改过CMakeLists）可以用CCACHE : `-DLLVM_CCACHE_BUILD=ON`
+ 安装lld和CCache: `apt install lld` ， `apt install ccache`
+ 如果无需rebuild则增量编译就行了

## Tips

+ 语法报错首先参考其它Target的代码格式！！
+ 对不同版本LLVM的源代码更改不理解时（例如变量类型的改变），可以通过查询git 提交记录来查看开发者的解释

```git
	git blame 可以查询该文件的某一行的commit号（如4845531f）
	git log -1 4845531f 可显示该commit的备注说明
```



