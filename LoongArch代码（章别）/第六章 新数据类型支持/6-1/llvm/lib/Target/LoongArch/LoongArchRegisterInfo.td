//===-- LoongArchRegisterInfo.td - LoongArch Register defs -----------*- tablegen -*-===//

//===----------------------------------------------------------------------===//
//  Declarations that describe the LOONGARCH register file
//===----------------------------------------------------------------------===//

// We have banks of 32 integer registers each.
class LoongArchReg<bits<16> Enc, string n, list<string> alt = []> : Register<n> {
  // For tablegen(... -gen-emitter)  in CMakeLists.txt
  let HWEncoding = Enc;
  let AltNames = alt;
  let Namespace = "LoongArch";
}

// We have banks of 32 float point registers each.
class LoongArchFPReg<bits<16> Enc, string n, list<string> alt = []> : Register<n> {
// For tablegen(... -gen-emitter)  in CMakeLists.txt
let HWEncoding = Enc;
let AltNames = alt;
let Namespace = "LoongArch";
}


// LoongArch Integer CPU Registers
class LoongArchGPRReg<bits<16> Enc, string n, list<string> alt = []> : LoongArchReg<Enc, n>;

// LoongArch Floating Point CPU Registers
class LoongArchFPGPRReg<bits<16> Enc, string n, list<string> alt = []> : LoongArchFPReg<Enc, n>;

// Co-processor Registers
class LoongArchCoReg<bits<16> Enc, string n, list<string> alt = []> : LoongArchReg<Enc, n>;

//===----------------------------------------------------------------------===//
//@Integer Registers
//===----------------------------------------------------------------------===//
// The register string, such as "9" or "gp" will show on "llvm-objdump -d"
//@ All registers definition
let Namespace = "LoongArch" in {
  //@ General Purpose Registers
  //DwarfRegNum are used by gcc, gdb, or a debug information writer to identify a register
  def ZERO : LoongArchGPRReg<0, "r0", ["zero"]>, DwarfRegNum<[0]>;
  def RA   : LoongArchGPRReg<1, "r1", ["ra"]>,    DwarfRegNum<[1]>;
  def TP   : LoongArchGPRReg<2, "r2", ["tp"]>,    DwarfRegNum<[2]>;
  def SP   : LoongArchGPRReg<3, "r3", ["sp"]>,    DwarfRegNum<[3]>;
  def A0   : LoongArchGPRReg<4, "r4", ["a0"]>,    DwarfRegNum<[4]>;
  def A1   : LoongArchGPRReg<5, "r5", ["a1"]>,    DwarfRegNum<[5]>;
  def A2   : LoongArchGPRReg<6, "r6", ["a2"]>,   DwarfRegNum<[6]>;
  def A3   : LoongArchGPRReg<7, "r7", ["a3"]>,    DwarfRegNum<[7]>;
  def A4   : LoongArchGPRReg<8, "r8", ["a4"]>,    DwarfRegNum<[8]>;
  def A5   : LoongArchGPRReg<9, "r9", ["a5"]>,    DwarfRegNum<[9]>;
  def A6   : LoongArchGPRReg<10, "r10", ["a6"]>,   DwarfRegNum<[10]>;
  def A7   : LoongArchGPRReg<11, "r11", ["a7"]>,   DwarfRegNum<[11]>;
  def T0   : LoongArchGPRReg<12, "r12", ["t0"]>,   DwarfRegNum<[12]>;
  def T1   : LoongArchGPRReg<13, "r13", ["t1"]>,   DwarfRegNum<[13]>;
  def T2   : LoongArchGPRReg<14, "r14", ["t2"]>,   DwarfRegNum<[14]>;
  def T3   : LoongArchGPRReg<15, "r15", ["t3"]>,   DwarfRegNum<[15]>;
  def T4   : LoongArchGPRReg<16, "r16", ["t4"]>,   DwarfRegNum<[16]>;
  def T5   : LoongArchGPRReg<17, "r17", ["t5"]>,   DwarfRegNum<[17]>;
  def T6   : LoongArchGPRReg<18, "r18", ["t6"]>,   DwarfRegNum<[18]>;
  def T7   : LoongArchGPRReg<19, "r19", ["t7"]>,   DwarfRegNum<[19]>;
  def GP   : LoongArchGPRReg<20, "r20", ["gp","t8"]>,   DwarfRegNum<[20]>;
  def R21  : LoongArchGPRReg<21, "r21", [""]>,   DwarfRegNum<[21]>;
  def FP   : LoongArchGPRReg<22, "r22", ["fp","s9"]>,   DwarfRegNum<[22]>;
  def S0   : LoongArchGPRReg<23, "r23", ["s0"]>,   DwarfRegNum<[23]>;
  def S1   : LoongArchGPRReg<24, "r24", ["s1"]>,   DwarfRegNum<[24]>;
  def S2   : LoongArchGPRReg<25, "r25", ["s2"]>,   DwarfRegNum<[25]>;
  def S3   : LoongArchGPRReg<26, "r26", ["s3"]>,   DwarfRegNum<[26]>;
  def S4   : LoongArchGPRReg<27, "r27", ["s4"]>,   DwarfRegNum<[27]>;
  def S5   : LoongArchGPRReg<28, "r28", ["s5"]>,   DwarfRegNum<[28]>;
  def S6   : LoongArchGPRReg<29, "r29", ["s6"]>,   DwarfRegNum<[29]>;
  def S7   : LoongArchGPRReg<30, "r30", ["s7"]>,   DwarfRegNum<[30]>;
  def S8   : LoongArchGPRReg<31, "r31", ["s8"]>,   DwarfRegNum<[31]>;

  //@Program Counter Register
  def PC   : LoongArchCoReg<0, "pc", [""]>,  DwarfRegNum<[40]>;

}

//===----------------------------------------------------------------------===//
//@Float Point Registers
//===----------------------------------------------------------------------===//
//@ All registers definition
let Namespace = "LoongArch" in {
//@ General Purpose Registers
def F0    : LoongArchFPGPRReg<0, "f0", ["fa0"]>,    DwarfRegNum<[32]>;
def F1    : LoongArchFPGPRReg<1, "f1", ["fa1"]>,    DwarfRegNum<[33]>;
def F2    : LoongArchFPGPRReg<2, "f2", ["fa2"]>,    DwarfRegNum<[34]>;
def F3    : LoongArchFPGPRReg<3, "f3", ["fa3"]>,    DwarfRegNum<[35]>;
def F4    : LoongArchFPGPRReg<4, "f4", ["fa4"]>,    DwarfRegNum<[36]>;
def F5    : LoongArchFPGPRReg<5, "f5", ["fa5"]>,    DwarfRegNum<[37]>;
def F6    : LoongArchFPGPRReg<6, "f6", ["fa6"]>,    DwarfRegNum<[38]>;
def F7    : LoongArchFPGPRReg<7, "f7", ["fa7"]>,    DwarfRegNum<[39]>;
def F8    : LoongArchFPGPRReg<8, "f8", ["ft0"]>,    DwarfRegNum<[40]>;
def F9    : LoongArchFPGPRReg<9, "f9", ["ft1"]>,    DwarfRegNum<[41]>;
def F10   : LoongArchFPGPRReg<10, "f10", ["ft2"]>,   DwarfRegNum<[42]>;
def F11   : LoongArchFPGPRReg<11, "f11", ["ft3"]>,   DwarfRegNum<[43]>;
def F12   : LoongArchFPGPRReg<12, "f12", ["ft4"]>,   DwarfRegNum<[44]>;
def F13   : LoongArchFPGPRReg<13, "f13", ["ft5"]>,   DwarfRegNum<[45]>;
def F14   : LoongArchFPGPRReg<14, "f14", ["ft6"]>,   DwarfRegNum<[46]>;
def F15   : LoongArchFPGPRReg<15, "f15", ["ft7"]>,   DwarfRegNum<[47]>;
def F16   : LoongArchFPGPRReg<16, "f16", ["ft8"]>,   DwarfRegNum<[48]>;
def F17   : LoongArchFPGPRReg<17, "f17", ["ft9"]>,   DwarfRegNum<[49]>;
def F18   : LoongArchFPGPRReg<18, "f18", ["ft10"]>,   DwarfRegNum<[50]>;
def F19   : LoongArchFPGPRReg<19, "f19", ["ft11"]>,   DwarfRegNum<[51]>;
def F20   : LoongArchFPGPRReg<20, "f20", ["ft12"]>,   DwarfRegNum<[52]>;
def F21   : LoongArchFPGPRReg<21, "f21", ["ft13"]>,   DwarfRegNum<[53]>;
def F22   : LoongArchFPGPRReg<22, "f22", ["ft14"]>,   DwarfRegNum<[54]>;
def F23   : LoongArchFPGPRReg<23, "f23", ["ft15"]>,   DwarfRegNum<[55]>;
def F24   : LoongArchFPGPRReg<24, "f24", ["fs0"]>,   DwarfRegNum<[56]>;
def F25   : LoongArchFPGPRReg<25, "f25", ["fs1"]>,   DwarfRegNum<[57]>;
def F26   : LoongArchFPGPRReg<26, "f26", ["fs2"]>,   DwarfRegNum<[58]>;
def F27   : LoongArchFPGPRReg<27, "f27", ["fs3"]>,   DwarfRegNum<[59]>;
def F28   : LoongArchFPGPRReg<28, "f28", ["fs4"]>,   DwarfRegNum<[60]>;
def F29   : LoongArchFPGPRReg<29, "f29", ["fs5"]>,   DwarfRegNum<[61]>;
def F30   : LoongArchFPGPRReg<30, "f30", ["fs6"]>,   DwarfRegNum<[62]>;
def F31   : LoongArchFPGPRReg<31, "f31", ["fs7"]>,   DwarfRegNum<[63]>;

}

//===----------------------------------------------------------------------===//
//@Register Classes
//===----------------------------------------------------------------------===//
// The order of registers represents the preferred allocation sequence.
// Registers are listed in the order caller-save, callee-save, specials.
def GPR : RegisterClass<"LoongArch", [i32], 32, (add
  // Argument registers (a0...a7)
  A0, A1, A2, A3, A4, A5, A6, A7,
  // Temporary registers (t0...t7)
  T0, T1, T2, T3, T4, T5, T6, T7,
  // Static Registers (fp, s0...s8)
  FP, S0, S1, S2, S3, S4, S5, S6, S7, S8,
  // Specials (zero, ra, tp, sp, gp)
  ZERO, RA, TP, SP, GP,
  // Reserved(Non-allocatable)
  R21
  )>;

def FPGPR : RegisterClass<"LoongArch", [f32], 32, (sequence "F%u", 0, 31)>;

//@Status Registers class
//def CSR

//@Co-processor 0 Registers class
def CoRegs : RegisterClass<"LoongArch", [i32], 32, (add PC)>;

//add all register to GPROut register except R21
def GPROut : RegisterClass<"LoongArch", [i32], 32, (add (sub GPR, R21))>;

// Above will generate RegClass as follows in LoongArchGenRegisterInfo.inc
// namespace LoongArch { // Register classes
//     extern const TargetRegisterClass GPRRegClass;
//     extern const TargetRegisterClass GPROutRegClass;
//     extern const TargetRegisterClass CoRegsRegClass;
//     extern const TargetRegisterClass FPGPRRegClass;
// } // end namespace LoongArch