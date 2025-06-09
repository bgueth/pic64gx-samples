#ifndef RISC_V_H
#define RISC_V_H
#define MSTATUS_SIE_MASK         (1 << 1)
#define MSTATUS_MIE_MASK         (1 << 3)
#define MSTATUS_SPIE_MASK        (1 << 5)
#define MSTATUS_UBE_MASK         (1 << 6)
#define MSTATUS_MPIE_MASK        (1 << 7)
#define MSTATUS_SPP_MASK         (1 << 8)
#define MSTATUS_VS0_MASK         (1 << 9)
#define MSTATUS_VS1_MASK        (1 << 10)
#define MSTATUS_MPP0_MASK       (1 << 11)
#define MSTATUS_MPP1_MASK       (1 << 12)
#define MSTATUS_FS0_MASK        (1 << 13)
#define MSTATUS_FS1_MASK        (1 << 14)
#define MSTATUS_XS0_MASK        (1 << 15)
#define MSTATUS_XS1_MASK        (1 << 16)
#define MSTATUS_MPRV_MASK       (1 << 17)
#define MSTATUS_SUM_MASK        (1 << 18)
#define MSTATUS_MAX_MASK        (1 << 19)
#define MSTATUS_TVM_MASK        (1 << 20)
#define MSTATUS_TW_MASK         (1 << 21)
#define MSTATUS_TSR_MASK        (1 << 22)
#define MSTATUS_SPELP_MASK      (1 << 23)
#define MSTATUS_SDT_MASK        (1 << 23)
#define MSTATUS_UXL0_MASK       (1 << 32)
#define MSTATUS_UXL1_MASK       (1 << 33)
#define MSTATUS_SXL0_MASK       (1 << 34)
#define MSTATUS_SXL1_MASK       (1 << 35)
#define MSTATUS_SBE_MASK        (1 << 36)
#define MSTATUS_MBE_MASK        (1 << 37)
#define MSTATUS_GVA_MASK        (1 << 38)
#define MSTATUS_MPV_MASK        (1 << 39)
#define MSTATUS_MPELP_MASK      (1 << 40)
#define MSTATUS_MDT_MASK        (1 << 41)
#define MIP_SSIP_MASK            (1 << 1)
#define MIP_MSIP_MASK            (1 << 3)
#define MIP_STIP_MASK            (1 << 5)
#define MIP_MTIP_MASK            (1 << 7)
#define MIP_SEIP_MASK            (1 << 9)
#define MIP_MEIP_MASK           (1 << 11)
#define MIP_LCOFIP_MASK         (1 << 13)
#define MIE_SSIE_MASK            (1 << 1)
#define MIE_MSIE_MASK            (1 << 3)
#define MIE_STIE_MASK            (1 << 5)
#define MIE_MTIE_MASK            (1 << 7)
#define MIE_SEIE_MASK            (1 << 9)
#define MIE_MEIE_MASK           (1 << 11)
#define MIE_LCOFIE_MASK         (1 << 13)
#define MSIP0                   0x2000000
#define MSIP1                   0x2000004
#define MSIP2                   0x2000008
#define MSIP3                   0x200000c
#define MSIP4                   0x2000010
#define MTIMECMP0               0x2004000
#define MTIMECMP1               0x2004008
#define MTIMECMP2               0x2004010
#define MTIMECMP3               0x2004018
#define MTIMECMP4               0x2004020
#define MTIME                   0x200bff8
#define MCAUSE_SSI                      1 // supervisor software interrupt
#define MCAUSE_MSI                      3 // machine software interrupt
#define MCAUSE_STI                      5 // supervisor timer interrupt
#define MCAUSE_MTI                      7 // machine timer interrupt
#define MCAUSE_SEI                      9 // supervisor external interrupt
#define MCAUSE_MEI                     11 // machine external interrupt
#define MCAUSE_COUNTER_OVERFLOW        13 // counter overflow interrupt
#define MCAUSE_INST_ADDR_MISALIGN       0 // instruction address misaligned
#define MCAUSE_INST_ACCESS_FAULT        1 // instruction access fault
#define MCAUSE_INST_ILLEGAL             2 // illegal instruction
#define MCAUSE_BREAK                    3 // breakpoint
#define MCAUSE_LOAD_ADDR_MISALIGN       4 // load address misaligned
#define MCAUSE_LOAD_ACCESS_FAULT        5 // load access fault
#define MCAUSE_STORE_ADDR_MISALIGN      6 // store/amo address misaligned
#define MCAUSE_STORE_ACCESS_FAULT       7 // store/amo access fault
#define MCAUSE_ECALL_U                  8 // environment call from u mode
#define MCAUSE_ECALL_S                  9 // environment call from s mode
#define MCAUSE_ECALL_M                 11 // environment call from m mode
#define MCAUSE_INST_PAGE_FAULT         12 // instruction page fault
#define MCAUSE_LOAD_PAGE_FAULT         13 // load page fault
#define MCAUSE_STORE_PAGE_FAULT        15 // store/amo page fault
#define MCAUSE_DOUBLE_TRAP             16 // double trap
#define MCAUSE_SW_CHECK                18 // software check
#define MCAUSE_HW_ERROR                19 // hardware error
#endif
