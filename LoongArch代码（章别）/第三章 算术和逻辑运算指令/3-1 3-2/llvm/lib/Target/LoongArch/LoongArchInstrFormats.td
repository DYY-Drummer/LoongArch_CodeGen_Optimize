//===-- LoongArchInstrFormats.td - LoongArch Instruction Formats -----*- tablegen -*-===//

//===----------------------------------------------------------------------===//
//  Describe LOONGARCH instructions format
//
//  CPU INSTRUCTION FORMATS
//
//  opcode     - operation code.
//  rd         - destination register operand.
//  r{j/k}     - source register operand.
//  immN       - immediate data operand.
//
//===----------------------------------------------------------------------===//


// Generic LoongArch Format
class LAInst<dag outs, dag ins, string asmstr, list<dag> pattern,
        InstrItinClass itin>
: Instruction {

// Inst and Size: for tablegen(... -gen-emitter) and
// tablegen(... -gen-disassembler) in CMakeLists.txt
field bits<32> Inst;
let Namespace = "LoongArch";
let Size = 4;


let OutOperandList = outs;
let InOperandList = ins;

let AsmString = asmstr;

let Pattern = pattern;

let Itinerary   = itin;

let DecoderNamespace = "LoongArch";
// SoftFail is a field the disassembler can use to provide a way for
// instructions to not match without killing the whole decode process. It is
// mainly used for ARM, but Tablegen expects this field to exist or it fails
// to build the decode table.
field bits<32> SoftFail = 0;
}


//===----------------------------------------------------------------------===//
// Pseudo Instructions Format
//===----------------------------------------------------------------------===//
class LoongArchPseudo<dag outs, dag ins, string asmstr, list<dag> pattern>
: LAInst<outs, ins, asmstr, pattern, IIPseudo> {
let isCodeGenOnly = 1;
let isPseudo = 1;
}

//===----------------------------------------------------------------------===//
// Format 2R instruction class in LoongArch : <opcode | rj | rd>
//===----------------------------------------------------------------------===//
class Fmt2R<bits<22> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<5> rj;
bits<5> rd;

// Top 22 bits are the 'opcode' field
let Inst{31-10} = op;
let Inst{9-5} = rj;
let Inst{4-0} = rd;
}

//===----------------------------------------------------------------------===//
// Format 3R instruction class in LoongArch : <opcode | rk | rj | rd>
//===----------------------------------------------------------------------===//
class Fmt3R<bits<17> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<5> rk;
bits<5> rj;
bits<5> rd;

let Inst{31-15} = op;
let Inst{14-10} = rk;
let Inst{9-5} = rj;
let Inst{4-0} = rd;
}

//===----------------------------------------------------------------------===//
// Format 3RI2 instruction class in LoongArch : <opcode | I2 | rk | rj | rd>
//===----------------------------------------------------------------------===//
class Fmt3RI2<bits<15> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<2> imm2;
bits<5> rk;
bits<5> rj;
bits<5> rd;

let Inst{31-17} = op;
let Inst{16-15} = imm2;
let Inst{14-10} = rk;
let Inst{9-5} = rj;
let Inst{4-0} = rd;
}

//===----------------------------------------------------------------------===//
// Format 3RI3 instruction class in LoongArch : <opcode | I3 | rk | rj | rd>
//===----------------------------------------------------------------------===//
class Fmt3RI3<bits<14> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<3> imm3;
bits<5> rk;
bits<5> rj;
bits<5> rd;

let Inst{31-18} = op;
let Inst{17-15} = imm3;
let Inst{14-10} = rk;
let Inst{9-5} = rj;
let Inst{4-0} = rd;
}

//===----------------------------------------------------------------------===//
// Format 2RI5 instruction class in LoongArch : <opcode | I5 | rj | rd>
//===----------------------------------------------------------------------===//
class Fmt2RI5<bits<17> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<5> imm5;
bits<5> rj;
bits<5> rd;

let Inst{31-15} = op;
let Inst{14-10} = imm5;
let Inst{9-5} = rj;
let Inst{4-0} = rd;
}

//===----------------------------------------------------------------------===//
// Format 2RI6 instruction class in LoongArch : <opcode | I6 | rj | rd>
//===----------------------------------------------------------------------===//
class Fmt2RI6<bits<16> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<6> imm6;
bits<5> rj;
bits<5> rd;

let Inst{31-16} = op;
let Inst{15-10} = imm6;
let Inst{9-5} = rj;
let Inst{4-0} = rd;
}

//===----------------------------------------------------------------------===//
// Format 2RI8 instruction class in LoongArch : <opcode | I8 | rj | rd>
//===----------------------------------------------------------------------===//
class Fmt2RI8<bits<14> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<8> imm8;
bits<5> rj;
bits<5> rd;

let Inst{31-18} = op;
let Inst{17-10} = imm8;
let Inst{9-5} = rj;
let Inst{4-0} = rd;
}

//===----------------------------------------------------------------------===//
// Format 2RI12 instruction class in LoongArch : <opcode | I12 | rj | rd>
//===----------------------------------------------------------------------===//
class Fmt2RI12<bits<10> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<12> imm12;
bits<5> rj;
bits<5> rd;

let Inst{31-22} = op;
let Inst{21-10} = imm12;
let Inst{9-5} = rj;
let Inst{4-0} = rd;
}

//===----------------------------------------------------------------------===//
// Format 2RI14 instruction class in LoongArch : <opcode | I14 | rj | rd>
//===----------------------------------------------------------------------===//
class Fmt2RI14<bits<8> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<14> imm14;
bits<5> rj;
bits<5> rd;

let Inst{31-24} = op;
let Inst{23-10} = imm14;
let Inst{9-5} = rj;
let Inst{4-0} = rd;
}

//===----------------------------------------------------------------------===//
// Format 2RI16 instruction class in LoongArch : <opcode | I16 | rj | rd>
//===----------------------------------------------------------------------===//
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

//===----------------------------------------------------------------------===//
// Format 1RI20 instruction class in LoongArch : <opcode | I20 | rd>
//===----------------------------------------------------------------------===//
class Fmt1RI20<bits<7> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<20> imm20;
bits<5> rd;

let Inst{31-25} = op;
let Inst{24-5} = imm20;
let Inst{4-0} = rd;
}

//===----------------------------------------------------------------------===//
// Format 1RI21 instruction class in LoongArch : <opcode | I21[15:0] | rj | I21[20:16]>
//===----------------------------------------------------------------------===//
class Fmt1RI21<bits<6> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<21> imm21;
bits<5> rj;

let Inst{31-26} = op;
let Inst{25-10} = imm21{15-0};
let Inst{9-5} = rj;
let Inst{4-0} = imm21{20-16};
}

//===----------------------------------------------------------------------===//
// Format I15 instruction class in LoongArch : <opcode | I15>
//===----------------------------------------------------------------------===//
class FmtI15<bits<17> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<15> imm15;

let Inst{31-15} = op;
let Inst{14-0} = imm15;
}

//===----------------------------------------------------------------------===//
// Format I26 instruction class in LoongArch : <opcode | I26[15:0] | I26[25:16]>
//===----------------------------------------------------------------------===//
class FmtI26<bits<6> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<26> imm26;

let Inst{31-26} = op;
let Inst{25-10} = imm26{15-0};
let Inst{9-0} = imm26{25-16};
}

//===----------------------------------------------------------------------===//
// Format BSTR_W instruction class in LoongArch : <opcode[11:1] | msbw | opcode[0] | lsbw | rj | rd>
//===----------------------------------------------------------------------===//
class FmtBSTR_W<bits<12> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<5> msbw;
bits<5> lsbw;
bits<5> rj;
bits<5> rd;

let Inst{31-21} = op{11-1};
let Inst{20-16} = msbw;
let Inst{15} = op{0};
let Inst{14-10} = lsbw;
let Inst{9-5} = rj;
let Inst{4-0} = rd;
}

//===----------------------------------------------------------------------===//
// Format BSTR_D instruction class in LoongArch : <opcode | msbd | lsbd | rj | rd>
//===----------------------------------------------------------------------===//
class FmtBSTR_D<bits<10> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<6> msbd;
bits<6> lsbd;
bits<5> rj;
bits<5> rd;

let Inst{31-22} = op;
let Inst{21-16} = msbd;
let Inst{15-10} = lsbd;
let Inst{9-5} = rj;
let Inst{4-0} = rd;
}

//===----------------------------------------------------------------------===//
// Format ASRT instruction class in LoongArch : <opcode | rk | rj | 0x0>
//===----------------------------------------------------------------------===//
class FmtASRT<bits<17> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<5> rk;
bits<5> rj;

let Inst{31-15} = op;
let Inst{14-10} = rk;
let Inst{9-5} = rj;
let Inst{4-0} = 0x0;
}

//===----------------------------------------------------------------------===//
// Format PRELD instruction class in LoongArch : < 0b0010101011 | I12 | rj | I5>
//===----------------------------------------------------------------------===//
class FmtPRELD<dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<12> imm12;
bits<5> rj;
bits<5> imm5;

let Inst{31-22} = 0b0010101011;
let Inst{21-10} = imm12;
let Inst{9-5} = rj;
let Inst{4-0} = imm5;
}

//===----------------------------------------------------------------------===//
// Format PRELDX instruction class in LoongArch : < 0b00111000001011000 | rk | rj | I5>
//===----------------------------------------------------------------------===//
class FmtPRELDX<dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<5> rk;
bits<5> rj;
bits<5> imm5;

let Inst{31-15} = 0b00111000001011000;
let Inst{14-10} = rk;
let Inst{9-5} = rj;
let Inst{4-0} = imm5;
}

//===----------------------------------------------------------------------===//
// Format CSR instruction class in LoongArch : <opcode[12:5] | csr_num | opcode[4:0] | rd>
//===----------------------------------------------------------------------===//
class FmtCSR<bits<13> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<14> csr_num;
bits<5> rd;

let Inst{31-24} = op{12-5};
let Inst{23-10} = csr_num;
let Inst{9-5} = op{4-0};
let Inst{4-0} = rd;
}

//===----------------------------------------------------------------------===//
// Format CSRXCHG instruction class in LoongArch : <opcode | csr_num | rj | rd>
//===----------------------------------------------------------------------===//
class FmtCSRXCHG<bits<8> op, dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<14> csr_num;
bits<5> rj;
bits<5> rd;

let Inst{31-24} = op;
let Inst{23-10} = csr_num;
let Inst{9-5} = rj;
let Inst{4-0} = rd;
}

//===----------------------------------------------------------------------===//
// Format CACOP instruction class in LoongArch : <0b0000011000 | I12 | rj | I5>
//===----------------------------------------------------------------------===//
class FmtCACOP<dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<12> imm12;
bits<5> rj;
bits<5> op;

let Inst{31-22} = 0b0000011000;
let Inst{21-10} = imm12;
let Inst{9-5} = rj;
let Inst{4-0} = op;
}

//===----------------------------------------------------------------------===//
// Format IMM32 instruction class in LoongArch : <opcode | csr_num | rj | rd>
//===----------------------------------------------------------------------===//
class FmtIMM32<bits<32> op, string asmstr, list<dag> pattern, InstrItinClass itin>
: LAInst<(outs), (ins), asmstr, pattern, itin> {
let Inst{31-0} = op;
}

//===----------------------------------------------------------------------===//
// Format INVTLB instruction class in LoongArch : <0b00000110010010011 | rk | rj | I5>
//===----------------------------------------------------------------------===//
class FmtINVTLB<dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<5> rk;
bits<5> rj;
bits<5> op;

let Inst{31-15} = 0b00000110010010011;
let Inst{14-10} = rk;
let Inst{9-5} = rj;
let Inst{4-0} = op;
}

//===----------------------------------------------------------------------===//
// Format LDPTE instruction class in LoongArch : <0b00000110010001 | seq | rj | 00000>
//===----------------------------------------------------------------------===//
class FmtLDPTE<dag outs, dag ins, string asmstr,
        list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<8> seq;
bits<5> rj;

let Inst{31-18} = 0b00000110010001;
let Inst{17-10} = seq;
let Inst{9-5} = rj;
let Inst{4-0} = 0b00000;
}

