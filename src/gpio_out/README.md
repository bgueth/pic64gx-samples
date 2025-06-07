# GPIO operation
This example configures a GPIO port and turns on the LED connected to it. 

## Objectives
* boot loader mechanism and systek initialization
* configuration of a memory mapped device


## Booting the device
These examples use the [HSS Bootloader](https://github.com/pic64gx/pic64gx-hart-software-services.git) as first stage boot loader. When the PIC64GX Curiosity Kit resets, it executes the first stage boot loader placed on the ENVM. The boot loader supports loading the segments of a program from SD card into memory and setting the execution vectors for all harts.

### Payload generation
The HSS Bootloader comes with a tool for producing a payload binary out of a ELF-linked program file. The payload generator uses a YAML formatted configuration file as in [single-hart.yaml](single-hart.yaml).

```
hart-entry-points: {
  u54_1: '0x80000000',
}
```
This sets the entry point for the first application hart to the memory address `0x80000000`. After loading the program into memory, this is the address, the bootloader sets the `pc` of specified hart. This example uses only one of the four application harts. The HSS bootloader places the other harts in a power-save loop.

```
payloads:
  ../build/gpio_out.elf:    {
    owner-hart: u54_1,
    priv-mode: prv_m,
    skip-opensbi: true,
    payload-name: "gpio_out"
}
```

The `payloads` section lists all binaries, the bootloader has to care about.

It defines on which harts to run the binary and in which privilege mode the hart is started. The RISC-V specification describes available privilege modes. The PIC64GX uses machine mode, supervisor mode and user mode.

The configuration skips OpenSBI, since the examples do not make use of OpenSBI calls.

## Linking a program
When compilers produce machine readable binary out of source code, a process called "linking" resolves symbols into addresses. To do this, the linker needs to know, how the program shall be placed in memory.

Compilers make use of standardized memory segments for storing data and code. The linker script tells the linker about the memory structure of the device, the structure of the segments and how they are placed.

This example makes use of a minimal version of a linker script as in [linker.ld](linker.ld). It defines just one text segment, as the code does not store any data.

```
OUTPUT_ARCH("riscv")
ENTRY(_start)
```

The head of the linker script defines the output architecture and where the `pc` points to, when execution starts. `_start` is a symbol defined in the assembler file containing the program.

```
MEMORY
{
    ddr_cached_32 (rwx) : ORIGIN = 0x80000000, LENGTH = 4M
}
```

Then the memory map is defined. This example needs maximum 4MB so we set up one block, which is named `ddr_cached_32` at `0x80000000`. The PIC64GX Specification refers to this address as the begin of DDR Memory region. This memory definition is used later on to refer to the destination, where a section is placed.

The linker script follows with a list of sections:

```
.text : ALIGN(0x10)
{   
    __text_load = LOADADDR(.text);
    __text_start = .;
    *(.text)
    . = ALIGN(0x10);
    __text_end = .;
} > ddr_cached_32
_end = .;
```

This one defines a section for executable code. As a convention, compilers place executable code in a section called `.text`. The alignment keyword tells the linker, that the section starts on a 16-bit boundary in memory. The script defines two symbols, `__text_load` and `__text_start` at the beginning of the section. The wildcard makes the linker include all files. The the `(.text)` refers to the `.text` sections in these files.  To guarantee correct alignment of the `__text_end` symbol, there is an alignment statement just before it. As mentioned before, the text section is to be placed in the `ddr_cached_32` memory area. We provide an `_end` mark at the end of the text section.

```
    .stack : ALIGN(0x1000)
    {
        __stack_bottom = .;
        . += STACK_SIZE;
        __stack_top = .;
    } > ddr_cached_32
```

The `.stack` section allocates memory for the program stack. It is aligned on a 4k page boundary in memory and defines two symbols. Since the stack grows from top to bottom, `__stack_bottom` represents the stack limit and `__stack_top` the start of the stack.

## Initializing system configuration

The most rudimentary system configuration consists of two steps:

* provide a trap address for exceptions
* set the `sp` register to the top of the stack

The file [gpio_out.S](gpio_out.S) contains the assembler code of the program. The uppercase `.S` extension indicate, that the file has to be run through a precompiler, before assembling it. Thus it can include the header files for the system register and the gpio unit and use the constants to make programs more readable.

```
    .section .text
    .globl _start
```

In the beginning of the file, a section for `.text` is delivered. This information is provided for the linker's memory mapping. `.globl _start` defines a global symbol name, which the linker script uses as entrypoint.

The most rudimentary system configuration initializes a machine mode trap vector and a stack pointer. When an exception occurs (f.e. the hart reads an illegal instruction or a device sends an interrupt), the `pc` is set to the address stored in the `mtvec` register.


```
_start:
   // set trap handler to start symbol
    la t0, _start
    csrw mtvec, t0

    // initialize stack pointer
    la sp, __stack_top
```

The example set the trap vector to the start of the program. Thus, whenever an exception occurs, the program begins execution from the beginning.

Next, the program uses the `__stack_top` symbol from the linker script to identify the start of the stack area. Stacks are growing from high memory addresses to low memory addresses and the sp always points to the last entry on the stack. This program does not make use of the stack at all, but setting the stack pointer to a meaningful value shall be considered as absolute configuration minimum.

## Initialization and configuration of the GPIO unit
The PIC64GX provides three GPIO banks with a various number of input/output pins. The PIC64GX Curiosity Kit connects 8 LEDs to `GPIO1`. This example uses the `LED1`, which is connected to GPIO1_2.

```
    li t0, SYSREG_BASE
    li t2, GPIO1_MASK
    sw t2, SYSREG_SUBBLK_CLOCK_CR(t0)
```

To use the `GPIO1` block, it has to be activated first. This is done, by feeding a clock signal to it, which can be achieved by setting the appropriate bit in the system register. The system register is a memory mapped register of the PIC64GX which controls the different peripheral blocks of the device. The `sw` pseudo-instruction uses the form `offset(rs)` to perform a write to the memory address in register `rs` plus the offset `offset` in bytes.

```
    lw t3, SYSREG_SOFT_RESET_CR(t0)
    or t3, t3, t2 
    sw t3, SYSREG_SOFT_RESET_CR(t0)
    not t2, t2
    and t3, t3, t2
    sw t3, SYSREG_SOFT_RESET_CR(t0)
```

Next the program initiates a reset of the GPIO1 block. To do this, it has to set the appopriate bit in the `SOFT_RESET_CR` system register and to clear it afterwards.

This part of the program reuses the bitmask of GPIO1 stored in `t2` by the previous section. Or-ing the current value and the bitmask sets the related bit. After the value is written to the `SOFT_RESET_CR` register, the bit is cleared again by and-ing the inverse bitmask.

```
    li t1, GPIO1_BASE
    li a0, 4
    sw a0, GPIO_CONFIG_2(t1)
    sw a0, GPIO_GPOUT(t1)
```

The last section configures the identified pin as output. The device is memory mapped and configuration is made relatively to the address `GPIO_BASE`. As we configure output 2, the configuration register is at offset `GPIO_CONFIG_2` to the base. The example uses the register a0 to enabled buffered output, which is bit 3 (so value 4) of the configution byte.

As we want to pull the output of bit 3 to high, we can reuse the 4 already stored in a0. The LED turns on, as soon as GPIO_GPOUT value is set.

```
1:
    j 1b
```

The rest of the program just maintains the hart to stay in a eternal loop. Thus, the `pc` never leaves the memory region defined here.