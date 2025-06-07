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
#endif
