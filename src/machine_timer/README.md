# Machine Mode Timer
This example uses the timer to gernerate interrupts and toggle the status of a LED as a visible sign when the interrupt handler has been called. 

##  Objectives
* internal timer
* interrupt handling

## Timer
For 64-bit architectures the [RISC-V Privileged ISA](https://github.com/riscv/riscv-isa-manual/releases/download/riscv-isa-release-c626715-2025-05-31/riscv-privileged.html) defines the 64-bit memmory mapped timer register `mtime`. Another memory mapped register `mtimecmp` allows to generate an interrupt, as soon as `mtime` reaches the value of `mtimecmp`.

The PIC64GX connects a seperate 1-MHz clock signal to the timer so it does not depend on the CPU's system clock. All harts share the same `mtime` memory mapping defined in `include/risc_v.h`. Each hart uses its own `mtimecmp` memory mapping, so we use `MTIMECMP0` to `MTIMECMP4` as constants to address each of them. Since `MTIMECMP0` refers to the monitoring hart, we just consider the latter 4.

## Interrupt control
To control interrupts on a RISC-V architecture, some of the registers from Priviledged ISA are relevant. The example handles the timer in machine mode, so mode-specific registers begin with the letter 'm'.
The `mstatus` register definition assigns `SIE` (Supervisor Interrupt Enable) bit 1 and `MIE` (Machine Interrupt Enable) to bit 3. These bits control, if the hart is ready to process interrupts on the respective level (1) or if interrupts are masked (0).

The `mie` register (not to be confused with the `MIE` bit in `mstatus`) select interrupts by their source. Relevant for this example is the `MTIE` (Machine Timer Interrupt Enable) bit.

Finally, the `mtvec` register has already been mentioned in the previous example. When an interrupt occur, which is handled in machine mode, the hart expects to find the address of the handler in this register.

## Setting up for machine mode interrupts
As shown in [machine_timer.S](machine_timer.S), the setup of the interrupt is added to the code from the previous example. 

```
    la t0, _m_int_handler
    csrw mtvec, t0
```    

The trap vector in the beginning is left unchanged, as the interrupt handler relies on a configured GPIO unit. After GPIO initialization has finished, `mtvec` is set to the address of the interrupt handler. Thus, at any time, `mtvec` points to a meaningful location.

```
    li t2, MTIME
    ld a4, (t2)
    lui t5, 0x100
    add a5, a4, t5
    li t3, MTIMECMP1
    sd a5, (t3)
```

The [PIC64GX Specification](https://ww1.microchip.com/downloads/aemDocuments/documents/MPU64/ProductDocuments/DataSheets/PIC64GX1000-64-bit-Microprocessor-Data-Sheet-DS50003724.pdf) indicates the memory mapped addresses of MTIME and MTIMECMP, which are defined in [risc_v.h](../../include/risc_v.h).

First, the `MTIME` register is read into `a4` The load upper immediate instruction shifts the value by 12 bits, so `t5` stores about 1 million decimal. This value is added to the current cycle count and fed into MTIMECMP1, which lets the interrupt handler execute after about one second.


```
    li t5, MIE_MTIE_MASK
    csrs mie, t5
    li t5, MSTATUS_MIE_MASK
    csrs mstatus, t5
```

To enable timer interrupts, set the `MTIE` bit in the `mie` register. When all setup is done, machine-mode interrupts are enabled by setting the `MIE` bit in `mstatus`.

When executing in machine mode, only machine mode traps are taken. Traps occurring on lower priviledge modes are always masked.

## Interrupt and Exception handling

In order to be able to return to normal execution after the handler has finished, the hart takes some precautions.

Right before the trap handler is called, the hart will perform the following actions:

* save the `MIE` bit in `mstatus` to `MPIE` (bit 7)
* mask interrupts by clearing `MIE` in `mstatus`
* saves current `pc` in `mepc` register
* saves the current priviledge mode in the `MPP` bits
* sets the `mepc` (Machine Exception Program Counter) register to the current `pc`
* fill `mcause` and `mtval` registers to identify the interrupt
* set the `pc` to the value stored in `mtvec`

After these tasks, the interrupt handler is executed.

```
    li t0, MTIMECMP1
    not t1, zero
    sd t1, (t0)
```

The interrupt handler needs to clear the interrupt. This is achieved by setting MTIMECMP to the maximum value.

```
    li t1, GPIO1_BASE
    lw a0, GPIO_GPOUT(t1)
    xori a0, a0, 4
    sw a0, GPIO_GPOUT(t1)
```

Now the handler toggles the light by reading the current output value and writing back the current state xor-ed with the bitmask. 

```
    li t2, MTIME
    ld a4, (t2)
    lui t5, 0x100
    add a5, a4, t5
    sd a5, (t0)      // MTIMECMP1
    mret
```

Finally we calculate the cycle of the next timer interrupt, proceeding exacly as shown before. The mret instruction uses the saved state to restore before executing the interrupt handler.

Note: The interrupt handler uses general purpose registers to accomplish its tasks. A program normally expects to find all general purpose registers unchanged (regardless if it is a saved or temporary register), which means, that a handler has to save and restore the registers it uses. For simplification this example spares out these tasks. It works in this situation, because the regular "program" is just a loop not relying on the state of the registers. Though it is not considered as clean programming style.