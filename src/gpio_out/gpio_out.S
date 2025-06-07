#include "pic64gx_sysreg.h"
#include "gpio.h"
    .section .text
    .globl _start

_start:
    // set trap handler to start symbol
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
    or t3, t3, t2 
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

1:
    j 1b

