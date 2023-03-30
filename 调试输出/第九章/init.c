/***************************************************************************************
* Copyright (c) 2021-2022 Weitong Wang, University of Chinese Academy of Sciences
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

#include <isa.h>
#include <memory/paddr.h>
#include "local-include/csr.h"
#include "local-include/mmu.h"
#include "local-include/intr.h"

//load some inst for test
static const uint32_t img [] = {
        //Contents of section .text:
        // 0x02804063 = addi.w sp, sp, 16 ,added for NEMU test,
        // because NEMU sp's initial value is 0, while the stack grows down.
        0x02804063 , 0x02bfc063 , 0x02800004 , 0x29803064 , 0x02801804,
        0x29802064 , 0x02800804 , 0x29801064 , 0x28802064,
        0x28801065 , 0x00101484 , 0x02804063 , 0x4c000020,

        //Contents of section .strtab:
 0x002e7465 , 0x7874002e , 0x636f6d6d , 0x656e7400,
 0x6d61696e , 0x002e6e6f , 0x74652e47 , 0x4e552d73,
 0x7461636b , 0x00746573 , 0x742e6300 , 0x2e737472,
 0x74616200 , 0x2e73796d , 0x74616200,
        //Contents of section .comment:
 0x00636c61 , 0x6e672076 , 0x65727369 , 0x6f6e2031,
 0x302e302e , 0x302d3475 , 0x62756e74 , 0x75312000, 
        //Contents of section .symtab:
 0x00000000 , 0x00000000 , 0x00000000 , 0x00000000,
 0x25000000 , 0x00000000 , 0x00000000 , 0x0400f1ff,
 0x10000000 , 0x00000000 , 0x30000000 , 0x12000200


};

static void restart() {
  /* Set the initial program counter. */
  cpu.pc = 0x1c000000;

  /* The zero register is always 0. */
  cpu.gpr[0]._32 = 0;
}


void init_isa() {
  cosim_end = 0;
  printf("####### INIT HERE ########\n");
  printf("TLB_ENTRY = %d\n",CONFIG_TLB_ENTRIES);
  init_csr();

  CRMD->plv  = 0;
  CRMD->ie   = 0;
  CRMD->da   = 1;
  CRMD->pg   = 0;
  CRMD->datf = 0;
  CRMD->datm = 0;
  EUEN->fpe = 0;
  ECFG->lie  = 0;
  ESTAT->is_01 = 0;
  TCFG->en   = 0;
  LLBCTL->klo = 0;
  DMW0->plv0 = 0;
  DMW0->plv3 = 0;
  DMW1->plv0 = 0;
  DMW1->plv3 = 0;

  CPUID->coreid = 0;
  TID->val = 0;

  cpu.ll_bit = 0;
  cpu.inst_idle = 0;
  ASID->asidbits = 10;

  /* Load built-in image. */
  memcpy(guest_to_host(0x1c000000), img, sizeof(img));

  /* Initialize this virtual computer system. */
  restart();

  init_mmu();

}