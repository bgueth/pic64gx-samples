#include "pic64gx_sysreg.h"
#include "gpio.h"
#include "risc_v.h"

    .section .data
thread_store: .dword 16
    .section .text
    .globl _start

_start:
    // set trap handler to interrupt handler
    la t0, _start
    csrw mtvec, t0

    // initialize stack pointer
    la sp, __stack_top

    // enable clock on GPIO1 in sysreg
    li t0, SYSREG_BASE
    li t2, GPIO1_MASK
    sw t2, SYSREG_SUBBLK_CLOCK_CR(t0)

    // reset GPIO1
    lw t3, SYSREG_SOFT_RESET_CR(t0)
    or t3, t3, t2  // GPIO1_MASK && RTC_MASK
    sw t3, SYSREG_SOFT_RESET_CR(t0)
    not t2, t2
    and t3, t3, t2
    sw t3, SYSREG_SOFT_RESET_CR(t0)

    // configure output GPIO_1_2 
    li t1, GPIO1_BASE
    li a0, 4
    sw a0, GPIO_CONFIG_2(t1)

    // output high on GPIO_1_2
    sw zero, GPIO_GPOUT(t1)

    // set mscratch register
    la t0, thread_store
    csrw mscratch, t0

    // set mtvec to defined interrupt handler
    la t0, _m_int_handler
    csrw mtvec, t0

    // enable interrupts
    csrsi mstatus, MSTATUS_MIE_MASK

    // switch to user mode
    ecall

    csrsi mstatus, MSTATUS_MIE_MASK  

loop:
    j loop

_m_int_handler:
    
    // store used registers to scratch
    csrr a6, mscratch
    sd t0, (a6)
    sd t1, 8(a6)

    csrr a6, mcause
0:                          // ecall
    li t0, MCAUSE_ECALL_M
    bne a6, t0, 1f

    // clear both mstatus mpp bits
    csrr a6, mstatus
    li t0, MSTATUS_MPP0_MASK
    li t1, MSTATUS_MPP1_MASK
    or t0, t0, t1
    not t0, t0
    and t0, t0, a6
    csrw mstatus, t0

    // increment mepc
    csrr t0, mepc
    addi t0, t0, 4
    csrw mepc, t0
    j 255f
1:                          // illegal instruction
    li t0, MCAUSE_INST_ILLEGAL
    bne a6, t0, 255f
    li a6, GPIO1_BASE
    li t0, 4                // turn on LED1
    sw t0, GPIO_GPOUT(a6)
    
255:
    csrr a6, mscratch
    ld t1, 8(a6)
    ld t0, (a6)
    
    mret
