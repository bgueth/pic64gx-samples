#include "pic64gx_sysreg.h"
#include "gpio.h"
#include "risc_v.h"

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
    sw a0, GPIO_GPOUT(t1)

    // set mtvec to defined interrupt handler
    la t0, _m_int_handler
    csrw mtvec, t0

    // configure timer interrupt
    li t2, MTIME
    ld a4, (t2)
    lui t5, 0x100      // about one second
    add a5, a4, t5
    li t3, MTIMECMP1
    sd a5, (t3)

    // set timer active
    li t5, MIE_MTIE_MASK
    csrs mie, t5

    // enable global interrupts
    li t5, MSTATUS_MIE_MASK
    csrs mstatus, t5
1:
    j 1b

_m_int_handler:
    // clear interrupt
    li t0, MTIMECMP1
    not t1, zero
    sd t1, (t0)

    // toggle light
    li t1, GPIO1_BASE
    lw a0, GPIO_GPOUT(t1)
    xori a0, a0, 4
    sw a0, GPIO_GPOUT(t1)
  
    // set new timer
    li t2, MTIME
    ld a4, (t2)
    lui t5, 0x100
    add a5, a4, t5
    sd a5, (t0)      // MTIMECMP1
    mret
