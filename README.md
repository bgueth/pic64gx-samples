# Examples for PIC64GX usage
This repository shows examples for the [PIC64GX curiosity kit](https://www.microchip.com/en-us/development-tool/curiosity-pic64gx1000-kit). 

The PIC64GX Curiosity Kit uses a [Microchip PIC64GX Microprocessor](https://www.microchip.com/en-us/product/pic64gx1000) with four RISC-V application harts and one monitoring hart with a reduced instruction set. The monitoring hart runs the HSS boatloader and is discarded after starting the application harts. 

## Audience
To understand as much as possible, the examples do start from scratch and do not use any OpenSBI layer. You should have general notion of C language and RISC-V assembler programming. The [list below](#how-to-use) brings them into a didactical order and describe, which topics are discussed on each example.

## How to use
Examples can be compiled using the `Makefile` in the `src` directory. For compilation the [RISC-V GNU toolchain](https://github.com/riscv/riscv-gnu-toolchain) is required as well as the [HSS Bootloader](https://github.com/pic64gx/pic64gx-hart-software-services.git).
Each example comes with its own documentation. 
Compile a target from the list below, then copy the HSS payload located in `build/output.bin` to the device, the bootloader uses to fetch the image. The `Makefile` target `disc` shows, how this can be accomplished using a SD card with an existing GPT partition table having a BIOS boot parition. 

|Chapter|Target|Description|
|---|---|---|
|[1](src/gpio_out/README.md)|gpio_out|Booting, Memory mapped devices, Privilege Modes|
