//===-- LoongArchFloatInstrFormats.td - LoongArch Floating Point Instruction Formats -----*- tablegen -*-===//

//===----------------------------------------------------------------------===//
//  Describe LoongArch floating-point instructions format
//
//  opcode       - operation code.
//  fd           - destination register operand.
//  {c/f}{j/k/a} - source register operand.
//  immN         - immediate data operand.
//
//===----------------------------------------------------------------------===//


//===----------------------------------------------------------------------===//
// Format 2R instruction class in LoongArch : <opcode | fj | fd>
//===----------------------------------------------------------------------===//
class FPFmt2R<bits<22> op, dag outs, dag ins, string asmstr,
list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<5> fj;
bits<5> fd;

// Top 22 bits are the 'opcode' field
let Inst{31-10} = op;
let Inst{9-5} = fj;
let Inst{4-0} = fd;
}

//===----------------------------------------------------------------------===//
// Format 3R instruction class in LoongArch : <opcode | fk | fj | fd>
//===----------------------------------------------------------------------===//
class FPFmt3R<bits<17> op, dag outs, dag ins, string asmstr,
list<dag> pattern, InstrItinClass itin>
: LAInst<outs, ins, asmstr, pattern, itin> {
bits<5> fk;
bits<5> fj;
bits<5> fd;

let Inst{31-15} = op;
let Inst{14-10} = fk;
let Inst{9-5} = fj;
let Inst{4-0} = fd;
}

