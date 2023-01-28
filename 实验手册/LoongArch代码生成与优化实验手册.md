# 序章



## 写在前面

​	笔者认为，LLVM 后端开发的精髓在于“抄袭与学习”。LLVM官方开发手册中也建议“通过复制其它后端的代码来开发新的后端会是较好的选择”。LLVM中大量使用TableGen语言和内置的接口，在开发过程中对于陌生的格式和定义保持“知其然而不知其所以然”的态度即可，将注意力更多地放在新后端的设计上，对于LLVM规范点到即止，将会有助于我们的开发效率。

​	特别地，LoongArch与Mips的相似度极高，可以重点参考Mips的代码。在配置环境文件时，可以使用`Ctrl+F`搜索”Mips“关键词，在相同位置依葫芦画瓢即可。

## 开发环境

+ Vmware Workstation 16 PRO - Ubuntu 20.04（虚拟内存12GB，虚拟磁盘200G）
+ ninja 1.10.0
+ gcc 9.4.0
+ clang 10.0.0-4ubuntu1
+ 笔者的虚拟机环境之前已经过系列配置，若您使用的是全新的虚拟机，除上述工具外，可能还需要其它支持软件包，当编译报错时根据报错信息使用`apt install`等方法安装即可。

## Tips

+ 遇到Bug时，根据报错文件参考其它Target的代码进行修改。无法解决可以上Github的LLVM-project仓库（https://github.com/llvm/llvm-project/issues/）中提交issue，或者上LLVM官方社区论坛（https://discourse.llvm.org/latest）发布问题，一般24h之内就会有人回复。当然，建议在提问之前先通过关键字搜索是否有历史相同问题，大概率存在。

+ 对不同版本LLVM的源代码更改不理解时（例如变量类型的改变），可以通过查询git 提交记录来查看开发者的解释

  	git blame 可以查询该文件的某一行的commit号（如4845531f）
  	git log -1 4845531f 可显示该commit的备注说明

  



# 第一章 新后端初始化与编译

​	本章的任务分为两大部分：

+ 注册新后端。即告诉LLVM”嘿！这儿有个新后端，请带上它一起“，需要修改的是公共部分的代码，均在`llvm/cmake,llvm/include,llvm/lib`下。几乎所有的后端注册的工作都是一样的，修改文件时只需检索”Mips“关键字所在的位置，紧跟着加上LoongArch的信息即可
+ 搭建目标描述框架。这部分是目标独有信息与其它后端独立，均在`llvm/lib/Target/LoongArch`目录下。为了让我们的新后端能够勉强通过编译，我们给它搭建最最基础的目标描述信息（.td文件）及编写CMakeLists。



## 注册新后端



## 搭建目标描述框架



### TableGen语法

TableGen 语法参考教程：https://blog.csdn.net/SiberiaBear/article/details/103539530



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
>
> - **-DLLVM_USE_LINKER** Setting this option to lld will significantly reduce linking time for LLVM executables on ELF-based platforms, such as Linux. If you are building LLVM for the first time and lld is not available to you as a binary package, then you may want to use the gold linker as a faster alternative to GNU ld.
>
> - **-DLLVM_TARGETS_TO_BUILD** Set this equal to the target you wish to build. You may wish to set this to X86; however, you will find a full list of targets within the llvm-project/llvm/lib/Target directory.
>
>   

+ 使用lld加快编译 ``-DLLVM_USE_LINKER=lld`.`

+ 如果必须rebuild的话（更改过CMakeLists）可以用CCACHE : `-DLLVM_CCACHE_BUILD=ON`

+ 安装lld和CCache: `apt install lld` ， `apt install ccache`

+ 如果无需rebuild则增量编译就行了（只改了C++文件直接执行ninja即可，会自动识别需要重新编译的文件)。

+ 编译前半段可以使用`-j4`，后半段[20xx/27xx]涉及的库较大极有可能因为内存不足而宕机（大概率是在`Linking CXX executable bin/llvm-lto`这一步），此时输入Ctrl+C中断执行或者强制关机，使用`ninja -j1`，继续编译即可。最坏情况需要5个小时才能完成全部编译。

+ 在build/bin目录下执行`./llc --version `，即可获取当前llvm支持的所有后端，其中就可以看见我们新添加的loongarch 。注：如果指令llc前没加`./`,则调用的是Ubuntu环境中的llvm（如果你之前安装过Ubuntu提供的软件包的话）。

+ 依次执行下面两行指令，利用mips后端生成.bc文件，用loongarch后端生成.s文件

  `clang -target mips-unknown-linux-gnu -c test.cpp -emit-llvm -o test.bc`

  `./llc -march=cpu0 -relocation-model=pic -filetype=asm test.bc -o test.cpu0.s`

​		报错：`Assertion ‘Target && "Could not allocate target machine!"’ failed`

​		说明LLVM成功调用到了我们新添加的后端，只是我们还没编写target machine。

​		本章的任务到此结束。



# 第二章后端结构



## 2_1

报错：` Assertion TmpAsmInfo && "MCAsmInfo not initialized. " "Make sure you include the correct TargetSelect.h" "and that InitializeAllTargetMCs() is being invoked!"'`



## 2_2

feature 乱码的问题还没弄清，按照https://discourse.llvm.org/t/assertion-subtargetfeatures-hasflag-feature-feature-flags-should-start-with-or-failed/67939的方法用lldb调试一下看

先安装：`sudo apt install lldb`

调成功了就把llvm/lib/MC/MCSubtargetInfo.cpp:210的

`FeatureBits = getFeatures(CPU, StringRef("+cpu032II"), ProcDesc, ProcFeatures);`

里的死代码`StringRef("+cpu032II")`改回  `FS`



报错：`./llc: warning: target does not support generation of this file type!`



## 2_3

2_3重编译必须要手动执行ninja clean，否则会漏识别新更改。（好像是更改过.td文件，ninja识别不出来，就不会生成新的.inc文件。而我们的.cpp文件需要引用.inc文件里生成的变量。）



报错：`LLVM ERROR: Cannot select: t6: ch = Cpu0ISD::Ret t4, Register:i32 $lr
  t5: i32 = Register $lr`
`In function: main`



## 2_4

使用O2级别的优化指令，可以生成只留下一个`ret`的简单lllvm IR程序用于检验我们的成果。

+ 生成可查看的ll文件：

​	`clang -O2 -target mips-unknown-linux-gnu -S ch2.c -emit-llvm -o ch2.ll`

​	生成.bc文件：

​	`clang -O2 -target mips-unknown-linux-gnu -c ch2.c -emit-llvm -o ch2.bc`



+ 使用llc指令，不指定输出路径可以直接输出到终端显示

​	`build/bin/llc -march=cpu0 -relocation-model=pic -filetype=asm ch2.bc -o -`

​	能看到，已经正常生成了 `ret $lr` 指令。也能看到返回值 0 通过 `addiu $2, $zero, 0` 这条指令	放到了寄存器 `$2` 中，`$2` 就是 `%V0`，我们在 Cpu0RegisterInfo.td 中做过定义。 

​	通过指定 `-print-before-all` 和 `-print-after-all` 参数到 llc，可以打印出 DAG 指令选择前后	的状态：

​	`build/bin/llc -march=cpu0 -relocation-model=pic -filetype=asm -print-before-all `

​	`-print-after-all ch2.bc -o -`



信息如:

```llvm
bb.0 (%ir-block.0):
  $v0 = ADDiu $zero, 0
  RET $lr
```



## 2_5

+ prologue 和 epilogue 是函数调用开始时和结束时所作的准备工作，主要和创建和清理堆栈有关。

+ spill

  当寄存器数目不足以分配某些变量时，就必须将这些变量溢出（临时存入）到内存中，该过程成为spill。

+ 由于指令定长（32bit），所以留给立即数imm的位域最多为16-bit，超过16-bit的立即数需要发射多余一条的指令来处理计算，转换成`寄存器＋寄存器`的形式以容纳32-bit数。如结合lui（*load upper immediate*，加载高16位）和ori（*or immediate*，加载低16位）来组合成32-bit的立即数。

+ 用ch3_largeframe.cpp测试大栈

+ 输出：

	# %bb.0:
	        lui	$1, 36864
	        addiu	$1, $1, 32760
	        addu	$sp, $sp, $1
	        addiu	$2, $zero, 0
	        st	$2, 1879015428($sp)
	        lui	$1, 28672
	        addiu	$1, $1, -32760
	        addu	$sp, $sp, $1
	        ret	$lr
