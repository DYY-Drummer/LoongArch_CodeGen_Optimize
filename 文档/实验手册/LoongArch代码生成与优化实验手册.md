# 序章



## 写在前面

​		LLVM项目开源历史悠久，但是网上却少有新手友好的开发教程，大多只停留在理论阶段，分析LLVM整体架构和工作原理。一是因为LLVM项目本身十分庞大，又属于底层开发，项目代码错综复杂且时常更改，编写一套完整的免费开发教程所需的精力和时间对于个人来说太过苛刻。二是因为LLVM后端代码的贡献者大多为各指令集架构的公司或LLVM官方人员，就算是为了学习编译器技术，也鲜少有业余程序员会需要从头到尾开发一个新的LLVM后端。

​		虽然LLVM官方也提供了标准的后端开发说明手册，但是其过于晦涩难懂且忽略了太多细节，不适合新手作为自己开发第一个后端的参照，用作开发中关键词查询手册更合适。

​		本文将基于笔者开发LoongArch指令集的LLVM后端项目的经验历程，从代码编写的角度，一步步讲解如何开发一个具有基本功能的LLVM后端。

​		笔者认为，LLVM 后端开发的精髓在于“抄袭与学习”。LLVM官方开发手册中也建议“通过复制其它后端的代码来开发新的后端会是较好的选择”。LLVM项目继承树深度深，分支多，调用关系复杂，在初读LLVM后端代码时很可能会陷入类似于“这个变量类型的父类定义是什么？定义里调用的成员函数来自哪里？成员函数里的依赖约束来源又是哪？”的追踪困境——对于LLVM这样庞大的项目，追根溯源断是不可行的，纠结过深也反而会走一步忘一步，让我们偏离原本的开发重心。更何况LLVM的模块化做得如此出色，就是方便开发者可以不用去管具体的底层实现，直接使用现成的接口。LLVM中大量使用TableGen语言和内置的接口，在开发过程中对于陌生的格式和定义保持“知其然而不知其所以然”的态度即可，将注意力更多地放在新后端的设计上，对于LLVM规范点到即止，将会有助于我们的开发效率。本文将以“能写出代码”为标准，对理解项目所需的必要内容进行讲解，力求范围最小化。

​		一些重要的官方链接：

Loongson官方网站（龙芯中科技术股份有限公司）：

> http://www.loongson.cn/

Loongson与LoongArch的开发者网站（软件与文档资源）：

> http://www.loongnix.cn/
>
> https://github.com/loongson/
>
> https://loongson.github.io/LoongArch-Documentation/

LoongArch指令集架构的文档：

> https://github.com/loongson/LoongArch-Documentation/releases/latest/download/LoongArch-Vol1-v1.02-CN.pdf （中文版）
>
> https://github.com/loongson/LoongArch-Documentation/releases/latest/download/LoongArch-Vol1-v1.02-EN.pdf （英文版）

LoongArch的ELF psABI文档：

> https://github.com/loongson/LoongArch-Documentation/releases/latest/download/LoongArch-ELF-ABI-v2.00-CN.pdf （中文版）
>
> https://github.com/loongson/LoongArch-Documentation/releases/latest/download/LoongArch-ELF-ABI-v2.00-EN.pdf （英文版）

## 开发环境

+ Vmware Workstation 16 PRO - Ubuntu 20.04（虚拟内存12GB，虚拟磁盘200G）
+ ninja 1.10.0
+ gcc 9.4.0
+ clang 10.0.0-4ubuntu1
+ 笔者的虚拟机环境之前已经过系列配置，若您使用的是全新的虚拟机，除上述工具外，可能还需要其它支持软件包，当编译报错时根据报错信息使用`apt install`等方法安装即可。

## Tips

+ 虚拟机的虚拟内存至少需要开到8G，编译时最大并行线程数不要超过4，否则很容易因内存不足而宕机，这时请强制退出然后将最大并行数设为1重试。存储空间至少分配100G，LLVM项目编译后可达到30G。

+ LoongArch与RISCV的相似度极高，可以重点参考RISCV和Mips的代码。在配置环境文件时，可以使用`Ctrl+F`搜索”RISCV“关键词，在相同位置依葫芦画瓢即可。

+ 遇到Bug时，根据报错文件参考其它Target的代码进行修改。无法解决可以上Github的LLVM-project仓库（https://github.com/llvm/llvm-project/issues/）中提交issue，或者上LLVM官方社区论坛（https://discourse.llvm.org/latest）发布问题，一般24h之内就会有人回复。当然，建议在提问之前先通过关键字搜索是否有历史相同问题，大概率存在。

+ 对不同版本LLVM的源代码更改不理解时（例如变量类型的改变），可以通过查询git 提交记录来查看开发者的解释

  	git blame 可以查询该文件的某一行的commit号（如4845531f）
  	git log -1 4845531f 可显示该commit的备注说明

+ 本文存在大量以缩略词命名的代码，为方便理解，请查看附录中的缩略词索引.md



# 第一章 新后端初始化与编译

​	本章的任务分为两大部分：

+ 注册新后端。即告诉LLVM”嘿！这儿有个新后端，请带上它一起“，需要修改的是公共部分的代码，均在`llvm/cmake,llvm/include,llvm/lib`下。几乎所有的后端注册的工作都是一样的，修改文件时只需检索”Mips“关键字所在的位置，紧跟着加上LoongArch的信息即可
+ 搭建目标描述框架。这部分是目标独有信息与其它后端独立，均在`llvm/lib/Target/LoongArch`目录下。为了让我们的新后端能够勉强通过编译，我们给它搭建最最基础的目标描述信息（.td文件）及编写CMakeLists。



## 1.1 LoongArch指令集架构简介

​		本节基于龙芯架构32位精简版参考手册，对LoongArch 指令格式和寄存器进行简短的介绍，以便后续编码工作的进行。

### 1.1.1 LoongArch概述

​		LoongArch是一种小端模式的精简指令集架构（RISC），绝大多数指令只有两个源操作和一个目的操作数，采用load/store结构，即仅有load/store访存指令可以访问内存，其它指令的操作对象均是寄存器或立即数。

​		LoongArch指令长度为32位和64位两个版本，本文使用的是32位版本，但龙芯架构具有“应用级向下二进制兼容”的特性，32位版本的应用软件也能在64位版本的机器上运行。



### 1.1.2 寄存器

​		LoongArch基础整数指令涉及的寄存器包括通用寄存器GR和程序计数器PC，如下图所示。

![通用寄存器和PC](通用寄存器和PC.PNG)

​		32个通用寄存器（GR），记为r0~r31，位宽32-bit。其中0号寄存器r0的值恒为0,1号寄存器r1固定作为存放函数调用返回地址的寄存器。还有一个PC寄存器用于记录当前执行指令的地址，只能被转移指令、例外陷入和例外返回指令简介修改。从架构角度而言，所有基础整数指令中的寄存器操作数可以使用32个GR中的任意一个，但是在实际使用中为了统一规范，通常会指定各类用途的常用寄存器。



### 1.1.3 指令集

​		LoongArch包含3种无立即数的编码格式2R、3R、4R，和6种有立即数的编码格式2RI8、2RI12、2RI14、2RI16、1RI21、I26。下表列举了这9种编码格式的字段分配情况。注意，指令的编码格式与指令的汇编输出不是一回事，例如addi.w的汇编输出为`addi.w $rd, $rj, $imm12`，

而在编码格式中，它的存储域顺序为`addi.w的opcode I12 rj rd`。

![指令编码格式](指令编码格式.PNG)

​		LoongArch学习Mips使用了SLT和BEQ指令处理控制流语句，相比ARM的老式CMP指令性能更佳。应用级基础整数指令一览如下图所示：

![基础整数指令](基础整数指令.PNG)

​		绝大多数指令通过指令名中“.XX”形式的后缀来指示操作对象的类型。对于操作对象是整数类型的，指令名后缀.B、.H、.W、.BU、.HU、.WU分别表示该指令操作的数据类型是有符号字节、有符号半字、有符号字、无符号字节、无符号半字、无符号字。特别地，当操作数是有符号数还是无符号数不影响运算结果时，后缀均不带U，但并不代表操作对象只能是有符号数。其它具体指令格式和命名规则请查阅LoongArch32指令手册。



### 1.1.4 指令执行阶段

​		LoongArch架构与Mips架构相同，为五阶段流水线结构，分别是指令获取、指令解码、执行、内存访问和写回。下面描述了每个阶段处理器负责的工作。

​		1）指令获取（IF）

​			LoongArch从程序计数器PC中获取当前指向的指令，并存入指令寄存器IR中。PC寄存器自增指向下一条指令：PC=PC+4。

​		2）指令解码（ID）

​			控制单元将存储在IR中的指令进行解码，把存储在寄存器中的必要数据发送到算术逻辑单元（ALU）并根据指令中的操作码设置ALU的操作模式。

​		3）执行（EX）

​			ALU使用寄存器中的数据执行控制单元指定的操作。除了store/load指令外，执行结果被保存在目标寄存器中。

​		4）内存访问（MEM）

​			如果是store指令就从寄存器把数据写入内存；如果是load指令就从内存中读取数据到流水线寄存器。

​		5）写回（WB）

​			如果是load指令，就从流水线寄存器将数据写入到寄存器。



## 1.2 LLVM结构

​	为了方便后续内容展开，本节介绍了最基本的LLVM数据结构、算法和机制。

### 1.2.1 前后端分离设计

​		传统的静态编译器是由前端、优化器和后端组成的三段式设计，前端负责生成中间代码，优化器负责进行循环展开等各种运行优化，后端（代码生成器）负责将中间代码映射到目标指令集[5]。由于传统设计的紧密耦合性，当想要更换源语言或目标语言时都必须重新设计全部编译器。而LLVM架构不存在这个问题，LLVM 提供了一套支持多种源语言和目标代码的中间代码LLVM IR。LLVM IR仅由满足静态单赋值（SSA）的指令组成，独立于高级语言和目标指令系统，从而实现了前后端分离（如果您对LLVM IR语言不熟悉，可以查看http://llvm.org/docs/LangRef.html）。程序员可以单独为任何能编译到LLVM IR的源语言编写前端，也可以单独为任何能从LLVM IR编译的目标代码编写后端（如下图所示）。因此，当想要支持新的源语言或目标架构时，只需设计新的前/后端即可。

![LLVM编译器前后端分离图](LLVM编译器前后端分离图.png)

​		这种可复用性的另一个优点是，比起和预算直接挂钩的专用编译器（例如FreePASCAL)，能够拥有更广阔的程序员贡献群体，从而促进开源项目的优化。同时，新加入的指令集架构，也能一起分享上游社区资源，这对于生态相对薄弱的LoongArch架构来说十分重要。

​		LLVM设计中最重要的就是中间表示IR，它的设计兼容多种高级语言和目标架构，十分适合用于重构和优化。下面展示了一段典型的LLVM IR代码。

```LLVM IR
define i32 @func(i32 %a, i32 %b) {
block:
	%c = alloca i32, align 4
	store i32 0, i32* %c
	ret i32 0
}
```

​		LLVM IR类似一个RISC的低级虚拟指令集，支持跳转标签。其与实际机器指令不同的是，IR不使用固定命名寄存器（因为它没有真实的物理寄存器），而是使用以`%`为标志的虚拟字符命名寄存器，可以无限创建。LLVM IR有两种表现形式，一是人能读懂的文本格式.ll文件，正如上面的代码所示，二是密集存储在磁盘上可高效执行的二进制.bc文件。两种文件均能由LLVM前端Clang生成，LLVM也提供了llvm-dis和llvm-as工具来在两种文件之间进行转换。



### 1.2.2 目标描述文件.td

​		LLVM的模块化设计要求不同的目标架构都能用一种通用的方式来描述各自的特性，如CPU属性、指令格式、寄存器分配约定、模式匹配规则等。LLVM为此提供了一套强类型的，声明式的目标描述语言TableGen语言，用于描述上述信息，其源文件以.td结尾，存放于`llvm/lib/Target/（架构名）`目录下。TableGen语言有类似OOP语言一样的类和继承特性，例如下方的代码定义了一个ADDu指令，继承自3R类型逻辑运算指令，指令操作码为0x11，不检查溢出：

```TableGen
let Predicates = [DisableOverflow] in {
    def ADDu   : ArithLogic3R<0x11, "addu", add, IIAlu, CPURegs, 1>;
}
```

​		TableGen 语法参考教程：https://blog.csdn.net/SiberiaBear/article/details/103539530

​		.td文件的组织方式使得开发人员可以模块化设计他们的目标架构，分别为不同的模块创建一个.td文件，习惯上以`目标架构名+模块名`的方式命名，如Mips中用于描述寄存器类的文件：`MipsRegisterInfo.td`。

​		在理想的情况下，所有目标特定的信息都应该由.td文件描述，但目前的LLVM还无法做到，对于一些复杂的设计，例如地址模式，指令选择等，无法用.td文件描述，需要利用C++来完成。TableGen工具会依据.td文件生成后端描述文件.inc，这些.inc文件与.h/cpp文件加在一起便能提供完整的目标信息，生成模式匹配表，如下图所示。

![后端开发结构图](后端开发结构图.PNG)

### 1.2.3 代码生成器

​		为了理解LLVM后端架构，必须弄清CodeGen代码生成器的工作原理。下图来自于

[Tricore_llvm]: ErhardtC.DesignandimplementationofatricorebackendforthellvmcompilerframeworkD.Friedrich-Alexander-UniversitätErlangen-Nürnberg(FAU),2009.

展示了从LLVM IR转换到机器代码所需经过的各个阶段和用来表示中间代码的各种数据结构，每个阶段包含一至多个Pass，一个Pass代表一次具体的分析或转换动作。

![Code Generation流程](Code Generation流程.PNG)

​		LLVM代码生成器工作流程分为七个阶段，分别是：指令选择、指令调度和格式化、SSA代码优化、寄存器分配、函数头部/尾部插入、后期机器代码优化、代码发射。

​		1）指令选择

​			将LLVM IR转换为一组可选择的有向无环图（DAG），每个DAG节点代表一条指令。将DAG合法化，把操作和数据类型转换为目标机器支持的native instructions格式（如整数32位扩展）。指令选择器根据合法化的目标DAG执行模式匹配，选择对应的目标机器代码模式。此时操作指令替换为了目标机器指令（如`store`替换为`st`）但操作数仍为LLVM虚拟操作数（如寄存器仍为无限的虚拟寄存器）。

​		2）指令调度和格式化

​			解构目标DAG，将所有指令放入一个有序List，组成**MachineInstrs**，**MachineInstrs**序列组成一个没有分支的基本块**MachineBasicBlocks**，多个**MachineBasicBlocks**组成一个**MachineFunction**，所有**MachineFunction**最终组成一个完整的程序。

​			调度程序根据最小指令周期，最小寄存器压力等原则，优化重排指令序列。如下向内存写入两个整数的代码示例，通过重排指令序列，可以减少寄存器的使用数量。此时对内存地址的操作仍是基于虚拟的栈槽而不是真实的地址。

```LLVM IR
//优化前
%a = add i32 1, i32 0
%b = add i32 2, i32 0
st %a, i32* %c, 1
st %b, i32* %c, 2
//优化后
%a = add i32 1, i32 0
st %a, i32* %c, 1
%a = add i32 2, i32 0
st %a, i32* %c, 2
```

​		3）SSA代码优化

​			在将虚拟寄存器分配到真实物理寄存器之前，代码生成器可以执行一至多个针对SSA形式的代码优化Pass。

​		4）寄存器分配

​			通过图着色法等寄存器分配算法为指令中的虚拟寄存器分配物理寄存器。如果所需寄存器数量大于可分配的寄存器数量，则需要将被占用的寄存器的值暂时保存到内存，该过程成为溢出（spill）。

​		5）函数头部/尾部插入

​			函数头部(Prologue)和函数尾部(Epilogue)是函数调用开始和结束时执行的代码，用于分配和销毁栈空间。根据上一步寄存器的分配和溢出情况计算需要为函数栈帧保留的空间，并将虚拟的栈槽索引映射到相对于栈指针(SP)或帧指针(FP)的偏移的真实内存地址。

​		6）后期机器代码优化

​			类似窥孔优化等各种“最后一分钟”执行的优化Pass

​		7）代码发射

​			将完全转化的机器代码发射。如果是静态编译，则将结果保存为汇编代码文件；如果是JIT（Just In Time）编译，则将结果直接写入内存。



​		想要查看上述阶段的具体Pass，可以使用`llc -debug-pass=Structure`命令（注：不同版本LLVM的Pass序列可能不同）



### 1.2.4 DAG（Directed Acyclic Graph）

​		DAG图是LLVM指令选择模式匹配中最重要的表示方法。DAG图是一个向下生长的树状图，末端（没有子节点）的节点是叶子，其它的为分支节点。分支节点代表操作码，叶子节点代表操作数（寄存器、Const变量、立即数、偏移量）。在.td文件中，一个DAG节点的TableGen语言描述为：`(操作码 操作数，操作数)`。DAG可以嵌套，即一个DAG子树又可以作为另一个DAG的子节点（操作数）。例如机器指令：`op $ra, $rb, $imm16` 的DAG描述为：

```
(set GPROut:$ra, (opNode regClass:$rb, immType:$imm16))
```

其等价DAG图如下：

![set and add](/set and add.PNG)

​		 `set` 是TableGen关键字，是一个赋值操作，相当于“=”，在DAG中它表示匹配形如“`$ra = ...`" 的指令。`(opNode regClass:$rb, immType:$imm16)`是一个DAG树，它嵌套在DAG`(set GPROut:$ra, ...)` 作为一个操作数。指令选择就是将输入的IR DAG转换为特定于目标架构的包含机器代码的合法DAG。综上，若`opNode = add`，则这个DAG图匹配的LLVM IR就是类似于`%3 = add i32 %2, 0`的指令，当遇到符合该形式的IR指令时就按照上面的DAG模式转换成对应的机器指令DAG。

​		为了举例说明，让我们提前看一下指令ADDI.W的定义：

```c++
//LoongArchInstrFormats.td
//<opcode | I12 | rj | rd>
class Fmt2RI12<bits<10> op, dag outs, dag ins, string asmstr, list<dag> pattern, 
               InstrItinClass itin>
    : LAInst<outs, ins, asmstr, pattern, itin> {
  bits<12> imm16;
  bits<5> rj;
  bits<5> rd;

  let Inst{31-22} = op;
  let Inst{21-10} = imm12;
  let Inst{9-5} = rj;
  let Inst{4-0} = rd;
}
```

```c++
//LoongArchInstrInfo.td
//继承LLVM内置Operand类，定义一个12位有符号数类
def simm12 : Operand<i32> {
let DecoderMethod = "DecodeSimm12";
}
//匹配12位有符号数
def immSExt12 : PatLeaf<(imm), [{ return isInt<12>(N->getSExtValue()); }]>;

class ALU_2RI12<bits<10> op, string instrAsm, SDNode opNode,
				Operand od, PatLeaf immType>
    : Fmt2RI12<op, (outs GPR:$rd), (ins GPR:$rj, od:$imm12), 
				!strconcat(instrAsm, "\t$rd, $rj, $imm12"),
				[(set GPR:$rd, (opNode GPR:$rj, immType:$imm12))], IIAlu>{
	let isReMaterializable = 1; //可重构                    
}

// "add" 是IR关键字，定义在 include/llvm/Target/TargetSelectionDAG.td：315。
def ADDI_W : ALU_2RI12<0b0000001010, "addi.w", add, simm12, immSExt12>;
```

​		上面的代码展示了IR节点`add`(定义在llvm/include/llvm/Target/TargetSelectionDAG.td)和机器指令节点`ADDI_W`之间的模式匹配的方法。`(outs GPR:$rd)`和`(ins GPR:$rj, od:$imm12)`两个DAG参数指明，该指令具有三个操作数，其中作为输出的操作数是GPR寄存器集合中的一个寄存器，作为输入的操作数是GPR寄存器集合中的一个寄存器和一个12位立即数。注意，代码中的`$rj $rd`是虚拟寄存器名，最终会映射到**Fmt2RI12**中定义的操作数变量域。

​		以IR节点”`add %2, 0`”为例，在指令选择阶段，它与**ALU_2RI12**中的匹配规则`[(set GPR:$rd, (opNode GPR:$rj, immType:$imm12))]`相匹配，定义中指定了ADDI_W的汇编名称为"addi.w"，指令于是转换为`addi.w %2, 0`。到了寄存器分配阶段，虚拟寄存器`%2`被分配给物理寄存器`$a0`，于是指令又被转换为`addi.w $a0, 0`。定义中还指定了addi.w的指令编码0b0000001010，12位立即数格式的匹配规则immSExt12。上述模式匹配的图解如下：

![ALU_2RI12示例](ALU_2RI12示例.PNG)

![ALU_2RI12参数传递图](ALU_2RI12参数传递图.PNG)

​		有了这些信息，TableGen就可以自动生成汇编文件和二进制形式的目标文件（ELF文件）。关于指令选择的更多解释请查看：

​		官方文档：https://llvm.org/docs/WritingAnLLVMBackend.html#instruction-set

​		知乎：https://zhuanlan.zhihu.com/p/595518574

​		

## 1.3 注册新后端

​		从本节开始，我们将正式进行代码编写工作，为了读者能够更好理解，请配合代码仓库中的完整代码阅读，代码仓库按照章节划分新增/更改的代码内容，本文只会贴出逻辑说明所必要的部分代码。

​		一个新后端的编写首先应该从让LLVM project 知道这个新后端的存在开始，即告诉LLVM“嘿！我也是一个需要被编译的后端，我在。。。”，让LLVM工具在运行时能查找到并使用新后端。需要注册的信息包括新后端机器的ID和重定位记录。该部分所修改的是所有后端共用的公共文件，只需要模仿别的后端的格式，在相同的地方添加上LoongArch的信息即可。至于为什么修改这些文件，请暂时只当做一种LLVM项目架构规范理解。

+ **llvm/CMakeLists.txt**

  将LoongArch加入LLVM需要编译的Target列表

+  **llvm/cmake/config-ix.cmake**

+ **llvm/include/llvm/ADT/Triple.h**

  **llvm/lib/Support/Triple.cpp**

​		Triple意为三元组，由于典型的指令通常由“操作符 目的操作数 源操作数”三个域组成，所以这个命名习惯被保留了下来。该类用于为目标架构定义特殊行为的配置名称，通俗的讲，就是为不同目标架构的不同版本划分命名域，如LoongArch的不同版本：loongarch32和loongarch64

+ **llvm/include/llvm/BinaryFormat/ELF.h**

  **llvm/include/llvm/BinaryFormat/ELFRelocs/LoongArch.def**（新增）

  **llvm/include/llvm/Object/ELFObjectFile.h**

  **llvm/lib/Object/ELF.cpp**

  ELF (Executable and Linkable Format)是可执行程序、目标代码(object file)、共享库的通用文件格式。文件中定义了LoongArch的ELF文件支持信息。

+ **llvm/lib/MC/MCSubtargetInfo.cpp**

  Subtarget是Target基于不同CPU架构的细分（例如32位和64位的），编译时可以使用`-mcpu=` 和 `-mattr=`命令行选项指定某一个Subtarget。



## 1.4 搭建目标描述框架

​		如1.2节所述，LLVM使用目标描述文件（.td文件）来描述各种特定于目标的信息，这些文件全部存放在`llvm/lib/Target/目标名`下。本节将专注于为LoongArch编写.td文件，实现最基本的寄存器集、指令集和指令模式匹配功能的描述框架，让新后端的编译能够最低限度地通过。编译时，这些.td文件会被TableGen工具转换成C++格式的.inc文件，在.td文件定义的类也会被转换为C++类的形式，从而其它.CPP文件在引用了生成的.inc文件后，便能使用这些类。

+ **LoongArch.td**

  所有.td文件的统领，相当于最顶层的头文件，include了所有Target Machine 相关的描述文件，同时也是Cmake编译的入口。

+ **LoongArchRegisterInfo.td**

  包含了所有LoongArch寄存器的定义。如下代码所示，.td文件主要有两大关键字组成：**class**和**def**。

  + class可以类比为C++的类，`class A<...> : B<...>`代表定义一个类A，并继承类B，A拥有B及B的所有父类的成员变量。**let**为赋值关键字，为父类中已定义的变量再次赋值，若没有let，则说明该变量是此处新定义的。可以使用`let ... in { ... }`为多条记录的同一个变量批量赋值。

  + def 语句生成一条LLVM record（记录），相当于class的一个特定示例，可以同时实现多个class。

    `def ZERO : LoongArchGPRReg<0,  "zero">, DwarfRegNum<[0]>;`

    表示一条名为ZERO的记录，他实现了LoongArchGPRReg和DwarfRegNum类。双尖括号内为类的构造传参，参数类型、顺序和数量与类的定义相匹配。特别地，如果类的构造参数在定义时就赋予了初值，那么在定义def时可以省略该参数，此时def中的参数数量小于类定义的参数数量，但是省略的参数必须是参数序列中尾部的参数（否则编译器无法确定哪个参数被省略）。例如类定义`class A<string id, string name="">`中，name具有初始值（空串），定义时就可以省略name：`def subA : A<"My id">;`。

  + 可以看到，该文件定义了所有寄存器的基类LoongArchReg，并进一步分为通用寄存器、辅助寄存器和输出寄存器。每个寄存器拥有四个身份标识：目标特定的硬件编码Enc，汇编输出名n，寄存器别名AltNames和DwarfRegNum。DwarfRegNum提供从LLVM 寄存器枚举变量到被gcc、gdb等Debug 信息输出器所使用的寄存器编码的映射。
  
    回顾LoongArch指令格式，指令中每个寄存器引用占据5-bit，所以可分配的数值范围为0~31。一旦将0 ~ 31 分配给HWEncoding，TableGen就可以自动获取并设置这个编号。GPROut 包含了所有R21的所有GPR，因此在寄存器分配阶段，R21就不会被分配为输出寄存器。查看编译后生成的LoongArchGenRegisterInfo.inc文件可以看到TableGen打包的寄存器信息。
  
    此处体现了划分命名域的一个优势，由于指定了记录的Namespace，所以不同Target内的寄存器都可以从零开始编号而不会被混淆，例如在C++文件中可以通过`LoongArch::ZERO`来引用LoongArch命名空间中的ZERO寄存器。

```c++

class LoongArchReg<bits<16> Enc, string n, list<string> alt = []> : Register<n> {
  let HWEncoding = Enc;
  let AltNames = alt;
  let Namespace = "LoongArch";
}
// LoongArch CPU Registers
class LoongArchGPRReg<bits<16> Enc, string n， list<string> alt = []> : LoongArchReg<Enc, n>;
// Co-processor Registers
class LoongArchCoReg<bits<16> Enc, string n, list<string> alt = []> : LoongArchReg<Enc, n>;

//===----------------------------------------------------------------------===//
//@Registers
//===----------------------------------------------------------------------===//
let Namespace = "LoongArch" in {
  def ZERO : LoongArchGPRReg<0, "r0", ["zero"]>, DwarfRegNum<[0]>;
  ...
}

//===----------------------------------------------------------------------===//
//@Register Classes
//===----------------------------------------------------------------------===//
def GPR : RegisterClass<"LoongArch", [i32], 32, (add
  A0, A1, A2, ...
  )>;

def CoRegs : RegisterClass<"LoongArch", [i32], 32, (add PC)>;

def GPROut : RegisterClass<"LoongArch", [i32], 32, (add (sub GPR, R21))>;
```

+ **LoongArchInstrFormats.td**

​		按照1.1.3节中的指令格式分类定义了所有指令格式，描述了LoongArch指令集的公共属性，最顶层的LAInst类继承自LLVM内置的Instruction类，以2RI16指令格式为例：

```c++
class Fmt2RI16<bits<6> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<16> imm16;
bits<5> rj;
bits<5> rd;

let Inst{31-26} = op;
let Inst{25-10} = imm16;
let Inst{9-5} = rj;
let Inst{4-0} = rd;
}
```

​		Fmt2RI16的参数中，op为指令的二进制编码，outs，ins为匹配的DAG节点的输出和输入，asmstr为汇编输出字符串，pattern为模式匹配的Dag节点。itin为指令调度模式，是用来优化处理器指令调度的手段，例如读取或写入数据的时机，资源分配等，目前LoongArch还没有开发这部分处理器功能，此处只留下了一个框架，LLVM会选择缺省的调度方案。Inst 为32位指令域，根据2RI16的指令格式将指令域中各位分配给指令编码、两个寄存器和一个立即数。

+ **LoongArchSchedule.td**

  定义了各种指令调度模式

+ **LoongArchInstrInfo.td**

​		具体到某一条机器指令模式的实现，继承自LoongArchInstrFormats.td中的指令类型，还定义了立即数的格式，内存操作数和地址等操作数格式。目前只定义了内存操作指令store和load、一个加法指令和一个返回指令，以支持最简单的C语言程序（main函数中只有一个return 0）。关于这部分代码的指令模式匹配的具体解释请参照1.2.4节，此处不再赘述。

​		需要特别提出的是，指令中的isPseudo参数用来指明该指令是否是一个伪指令。伪指令代表目标机器架构中并不存在这么一个指令，只是为了统一格式，提高代码可读性的一种手段，通常会结合伪指令扩展（PseudoInstExpansion）来实现指令替换。例如，对于LLVM IR中的无条件跳转指令br和函数返回指令ret，Mips使用寄存器寻址指令`"jr $ra"`来匹配，其指令的输入操作数数量和类型均与IR相同，可以很自然地匹配。但是LoongArch中没有这种格式的跳转指令，只有`"jirl $rd, $rj, offs16"`，如何匹配？JIRL的跳转地址为寄存器rj中的值加上16位立即数offs16逻辑左移2位再符号扩展所得的偏移值，同时将PC+4写入寄存器rd。那么，我们只需令0ffs16恒为零，令寄存器rj为寄存器ra（返回地址寄存器），令寄存器rd为寄存器ZERO（因为我们不关心跳转指令的输出），即可用JIRL指令“假装”成JR指令，实现跳转到函数返回地址的效果。也就是定义伪指令ret，然后把ret通过PseudoInstExpansion扩展成特殊格式的JIRL，实现指令替换。如下代码定义了伪指令PseudoRet，并将其扩展成了JIRL的实现:

```c++
let isReturn=1, isTerminator=1, hasDelaySlot=1, isBarrier=1, hasCtrlDep=1 in
  def PseudoRet  : LoongArchPseudo<(outs), (ins), "", [(LoongArchRet)]>
                  ,PseudoInstExpansion<(JIRL ZERO, RA, 0)>;
```

​		其中，参数isReturn、isTerminator等，皆是跳转指令特定的flag，需要置为1。查看编译后生成的LoongArchGenMCPseudoLowering.inc文件，可以看到扩展的伪指令被替换成JIRL指令的格式然后发射到指令流中。

```c++
switch (MI->getOpcode()) {
    default: return false;
    case LoongArch::PseudoRet: {
      MCInst TmpInst;
      MCOperand MCOp;
      TmpInst.setOpcode(LoongArch::JIRL);
      // Operand: rd
      TmpInst.addOperand(MCOperand::createReg(LoongArch::ZERO));
      // Operand: rj
      TmpInst.addOperand(MCOperand::createReg(LoongArch::RA));
      // Operand: imm16
      TmpInst.addOperand(MCOperand::createImm(0));
      EmitToStreamer(OutStreamer, TmpInst);
      break;
    }
  }
```



+ **LoongArchTargetMachine(.cpp/.h)**

​		LLVMTargetMachine是LLVM代码生成器的基类，包含各种抽象方法，具体实现应由继承它的LoongArchTargetMachine类来完成。目前只需定义一个空的初始化函数。

+ **MCTargetDesc/...**

​		MC层的目标描述文件，描述MC层的寄存器信息、指令信息和指令输出方式等。MC层（Machine Code）是LLVM 中非常低的一层，用于处理汇编、反汇编、目标文件格式以及指令打印等原始机器代码级别的问题，在MC层中不存在常量池、跳转表等高级的表示形式，只存在汇编级的数据结构，例如标签和机器指令。MC层包括指令输出器（MCInstPrinter，给定一个 MCInst，格式化指令的文本表示并将其发送到原生的输出流）、指令编码器（将 MCInst 转换为一系列字节和重定位列表）、指令解析器（TargetAsmParser，输出操作码+操作数列表）、指令译码器(例如将立即数域转换为简单的整数操作数）、汇编解析器（实现了非常重要的MCStreamer API）和汇编程序后端（输出ELF或.o等目标文件）6个组成部分。

​		关于LLVM MC 层的详细介绍请看https://blog.llvm.org/2010/04/intro-to-llvm-mc-project.html

​		至于为什么要创建MCTargetDesc和TargetInfo这两个子目录，只是因为几乎所有后端都采用了这种代码组织结构。在编译之后这两个子目录会在编译路径的lib/目录下生成 : libLLVMLoongArchDesc.a和libLLVMLoongArchInfo.a两个库。

+ **TargetInfo/...**

​		使用TargetRegistry模板为LoongArch目标声明一个全局Target对象，使LLVM目标注册表可以通过目标名或目标三元组来查找该目标：

```c++
Target llvm::TheLoongArchTarget;

extern "C" void LLVMInitializeLoongArchTargetInfo() {
  RegisterTarget<Triple::loongarch, /*HasJIT=*/false>
    X(TheLoongArchTarget, "loongarch", "LoongArch");
}
```

+ **编译脚本**

​		在每个目录下都应该编写相应的CMakeLists.txt和LLVMBuild.txt文件，前者用于cmake执行，后者用于LLVM编译时的辅助指引，主要就是添加该目录下应该编译和应该输出的文件，可以直接移植其它后端的编译文件进行修改。（注：LLVMBuild.txt从LLVM 12开始不再使用）

## 1.5 编译

​		首先，在llvm同级目录下创建一个build文件夹（路径示例如下）

```
~llvm-project-llvmorg-10.0.0
	|- build
	|- llvm
        |- lib
    |- clang
	...
```

​		初始化编译配置，输入命令：

`cmake -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang -DCMAKE_BUILD_TYPE=Debug -G "Ninja" ../llvm`

​		此处指定了Ninja为编译工具，因为笔者感觉ninja的编译信息更易读，读者也可使用Linux自带的make，只需将`-G`后的选项改为“Unix Makefiles”即可。当终端显示如下信息时，则说明配置文件生成成功。

```
-- Targeting LoongArch
...
-- Targeting XCore
-- Configuring done
-- Generating done
-- Build files have been written to: ...
```

然后使用ninja命令开始编译：`ninja -j4`

`-j4`选项为指定最大同时运行指令数为4（内存小的系统建议调小），第一次编译大概率会遇到语法报错，修复后再次执行`ninja -j4`，即可自动从出错的步骤开始继续编译。

如果你的机器性能不够理想，请考虑使用下列选项优化编译效率

- **-DLLVM_USE_LINKER=lld** 在基于ELF的平台（例如Linux）上使用lld动态链接器能够显著减少LLVM可执行文件的链接时间。
- **-DLLVM_TARGETS_TO_BUILD=LoongArch** 指定你想要编译的后端
- **-DCMAKE_BUILD_TYPE=Release** 在不需要调试编译器的情况下可以将编译模式从Debug模式换成Release模式。

+ **-DLLVM_CCACHE_BUILD=ON** 在需要rebuild的情况下（例如修改过CMakeLists），可以使用CCACHE加快编译。如果无需rebuild则增量编译就行了（只改了C++文件直接执行ninja即可，会自动识别需要重新编译的文件)。

​		编译前半段可以使用`-j4`，后半段[20xx/27xx]涉及的库较大极有可能因为内存不足而宕机（大概率是在`Linking CXX executable bin/llvm-lto`这一步），此时输入Ctrl+C中断执行或者强制关机，使用`ninja -j1`，继续编译即可。最坏情况需要5个小时才能完成全部编译。

​		编译完成后，在build/bin目录下执行`./llc --version `，即可获取当前llvm支持的所有后端，其中就可以看见我们新添加的loongarch（如下图所示） 。注：如果指令llc前没加`./`,则调用的是Ubuntu环境中的llvm（如果你之前安装过Ubuntu提供的软件包的话）。

![llc --version执行结果](llc --version执行结果.PNG)

​		现在，编写一个最简单的测试文件test.c，并放到build/bin目录下：

```c
//test.c
int main() {
  return 0;
}
```



​		由于我们的LoongArch后端尚未支持ABI，所以先借助Mips的后端生成.bc文件：

​		`clang -target mips-unknown-linux-gnu -c test.c -emit-llvm -o test.bc`

​		`-emit-llvm`表示生成LLVM IR，生成的test.bc就是LLVM IR的二进制文件。可以使用LLVM自带的反汇编工具llvm-dis将其翻译成可读的文本形式：`build/bin/llvm-dis ch1.bc -o -`不指定输出路径就会将结果直接输出到终端。

​		最后，我们尝试用loongarch后端生成.s文件：

​		`./llc -march=loongarch -relocation-model=pic -filetype=asm test.bc -o test.loongarch.s`

​		这时会收到报错：`Assertion ‘Target && "Could not allocate target machine!"’ failed`

​		报错提示我们并没有定义目标机器，但是这说明LLVM成功调用到了我们新添加的LoongArch后端，只是我们还没编写target machine。本章搭架构的任务到此结束。



# 第二章 后端结构

​		在上一章中我们完成了一个新后端所必需的“表面功夫”，深入到目标机器级别的内容还一无所有。本章将根据LLVM后端继承树的结构逐步实现目标机器架构、汇编输出器、IR DAG到目标机器DAG指令选择、函数首/尾端处理，最终支持main函数只包含一个return语句的C程序 ，能够输出LoongArch汇编代码。本章可能是最为晦涩难懂的一章，因为我们需要打穿IR到机器代码中间的所有流程，逻辑纵穿整个LLVM后端结构，代码量约5000行。话虽如此，这部分的代码在所有的后端中都几乎一样，在实际编程中可大批挪用Mips/RISCV的代码，再进行修改（笔者希望未来的LLVM可以把这些共通的代码移植到公共代码区，不再需要开发人员手动编写）。读者在阅读本章时应将重点放在各成员类的调用关系和DAG模式匹配上，一旦熟悉了LLVM后端结构，就可以十分快速地从零开始构建一个新的后端。



## 2.1 目标机器架构

​		本节新建了大部分LoongArch后端类，关系类图如下所示。

![2-1类图-白底](2-1类图-白底.PNG)

​		LoongArchSubtarget类在构造函数中创建了LoongArchFrameLowering、LoongArchTargetLowering等类的对象，将它们的引用（std::unique_ptr）作为成员变量保存了起来，并提供了这些对象的get()接口。大多数类（如LoongArchInstrInfo、LoongArchRegisterInfo）中都会保留一个LoongArchSubtarget的引用对象作为成员变量，从而使用LoongArchSubtarget的接口访问其它类。即使没有保存LoongArchSubtarget的引用，也能通过LoongArchTargetMachine 获取LoongArchSubtarget的引用： `static_cast<const LoongArchTargetMachine &>(TM).getSubtargetImpl()`。一旦获取了LoongArchSubtarget的引用，就可以通过它访问其它类。



+ **LoongArchTargetObjectFile(.h/.cpp)**

​		定义了目标文件（ELF文件）的相关规范和初始化函数。不同的编译器对于程序的存储分配策略不尽相同，但是大都符合三段式结构：Text段、Data段和BSS(Block Started by Symbol)段。Text段用于存放代码，Data段用于存放有初始值的数据，BSS段用于存放未初始化的数据。.sdata和.sbss的s前缀代表“small”，该形式能节省ELF文件占用的内存。

+ **LoongArchTargetMachine(.h/.cpp)**

​		定义了目标机器相关特性。实现了龙芯机器基类LoongArchTargetMachine和32位目标机器子类LoongArch32TargetMachine（后续会拓展64位目标机器），提供了ABI接口、Subtarget接口和TargetLoweringObjectFile接口，指定机器为小端模式，指定重定位模式，组装DataLayout字符串。DataLayout是目标机器数据格式的描述，包括指针大小、对齐方式等，LoongArch的DataLayout定义如下。

```c++
"e-m:e-p:32:32-i8:8:32-i16:16:32-i64:64-n32-s128"
```

​		"-"为选项间的分隔符，从左往右，开头的"e"代表小端；"m:e"代表符号压缩格式（mangle）为Linux（Mac为“m:o”)；"p:32:32"代表指针的大小和对齐方式均为32位；"i8:8:32-i16:16:32-i64:64"代表8-bit整数和16bit整数分别向8位和16位对齐，但是尝试向32位对齐，64位整数向64位对齐；"n32"代表机器支持的整数位数为32位，对于X86-64，它支持8、16、32和64位的整数，那么该选项就是"n8:16:32:64"；"S128"代表栈的对齐方式为128位。

​		getSubtargetImpl()方法通过提供的目标机器CPU类型（例如是32位龙芯芯片还是64位的）和特征(features)选项来查找符合条件的Subtarget，如果不存在则创建一个。



+ **LoongArch.td**

​		定义了LoongArch机器特征(Features)，如是否具有Slt指令，是否支持单/双精度浮点数，是否支持二进制翻译扩展等。

​		所有Feature都是LLVM SubtargetFeature的子类，在实际运行中，Features被编码成形如"+attr1,+attr2,-attr3,...,+attrN"的字符串形式，特征前的加号或减号指示（根据CPU配置）应用或者禁用该特征，以逗号分隔。SubtargetFeature类会将该字符串拆分成一个个特征后进行匹配，具体请查看llvm/MC/SubtargetFeature.h。可以通过终端选项  `-mattr=+feature1,-feature2`来指定特征。如下为单精度浮点数特征的定义：

```c++
def FeatureBasicF
: SubtargetFeature<"f", "HasBasicF", "true",
        "'F' (Single-Precision Floating-Point)">;
def HasBasicF
: Predicate<"Subtarget->hasBasicF()">,
AssemblerPredicate<"FeatureBasicF",
"'F' (Single-Precision Floating-Point)">;
```

​		SubtargetFeature的四个参数中，“f"为特征名称，必须小写；"HasBasicF"指定了用于判断是否具有该特征的Predicate；"true"代表默认应用该特征；最后一个参数为特征注释。HasBasicF继承了Predicate类并指定了判断函数hasBasicF()（在LoongArchSubtarget.h中实现）。

​		下面的代码定义了一个loongarch32的处理器，调度模式为LoongArchGenericItineraries，具有FeatureLoongArch32的特征。

```c++
class Proc<string Name, list<SubtargetFeature> Features>
: Processor<Name, LoongArchGenericItineraries, Features>;

def : Proc<"loongarch32", [FeatureLoongArch32]>;
```

​		可以通过终端选项`-mcpu=loongarch32`来指定CPU为loongarch32，也可以输入`-mcpu=help`来查看所有可用的CPU和特征，如下图所示。

![-mcpu=help](-mcpu=help.PNG)

​		查看生成的LoongArchGenSubtargetInfo.inc文件以看到TableGen按照顺序依次设置了各个特征的

flag位，这样，所有特征的应用情况就可以用一个长度为12的Bits表示，若相应位为1则表示该特征处于激活状态。

```c++
//LoongArchGenSubtargetInfo.inc
enum {
  FeatureBasicD = 0,
  FeatureBasicF = 1,
  FeatureExtLASX = 2,
  FeatureExtLBT = 3,
  FeatureExtLSX = 4,
  FeatureExtLVZ = 5,
  FeatureLoongArch32 = 6,
  FeatureSlt = 7,
  LaGlobalWithAbs = 8,
  LaGlobalWithPcrel = 9,
  LaLocalWithAbs = 10,
  NumSubtargetFeatures = 11
};
```

+ **LoongArchCallingConv.td**

​		定义了



+ LoongArchInstrInfo.h通过定义以下代码来从LoongArchGenInstrInfo.inc中提取它需要的数据

```c++
#define GET_INSTRINFO_HEADER
#include "LoongArchGenInstrInfo.inc"
```



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

  %bb.0:

          lui	$1, 36864
          addiu	$1, $1, 32760
          addu	$sp, $sp, $1
          addiu	$2, $zero, 0
          st	$2, 1879015428($sp)
          lui	$1, 28672
          addiu	$1, $1, -32760
          addu	$sp, $sp, $1
          ret	$lr

+ 查看pass的执行流程`./llc -march=cpu0 -relocation-model=pic -filetype=asm ch2.bc -debug-pass=Structure -o -`，更多信息在CodeGen/Passes.h中

```llvm
Target Library Information
Target Pass Configuration
Machine Module Information
Target Transform Information
Type-Based Alias Analysis
Scoped NoAlias Alias Analysis
Assumption Cache Tracker
Profile summary info
Create Garbage Collector Module Metadata
Machine Branch Probability Analysis
  ModulePass Manager
    Pre-ISel Intrinsic Lowering
    FunctionPass Manager
    ...
    Rewrite Symbols
    FunctionPass Manager
      ...
      CPU0 DAG to DAG Pattern Instruction Selection
      ...
      Optimize machine instruction PHIs
      ...
      Local Stack Slot Allocation
      Remove dead machine instructions
      ...
      Peephole Optimizations
      Remove dead machine instructions
      ...
      Machine Instruction Scheduler
      ...
      Greedy Register Allocator
      ...
      Prologue/Epilogue Insertion & Frame Finalization
      ...
      Cpu0 Assmebly Printer
      ...

```

+ 可用如下指令分别统计所有.cpp,.td,.h,.txt文件的行数

  ```
  wc -l `find path -name "*.cpp"`|tail -n1
  ```

  LLVM10.0.0中Mips 代码总数 82,182；  X86 代码总数 186,831（包括注释）



​		上文提及过，.td文件会被TableGen工具用来生成.inc文件，从而被其它.cpp文件引用，.inc文件中的类可以被后端类使用和继承，甚至重写其中的函数。这些.inc文件都在Build目录中相应的.td文件的同级目录下。TableGen工具通过模式匹配技术和.td文件配合，使需要编写的后端代码大大减少了。下图展示了这些TableGen生成的类（蓝色）的继承树。

![2-1 TableGen生成的.inc文件的继承树](2-1 TableGen生成的.inc文件的继承树.PNG)

​		LLVM继承树要远深于此，不过暂时浮于表面也能够理解代码逻辑，此处不再深挖。也多亏了LLVM的继承树结构，我们在指令、栈帧和DAG选择中不用实现海量的代码，因为大部分已经被其父类实现。
