OUTPUT_ARCH("riscv")
ENTRY(_start)

MEMORY
{
    ddr_cached_32 (rwx) : ORIGIN = 0x80000000, LENGTH = 4M
}
STACK_SIZE = 4k;
SECTION_START_ADDRESS = 0x80000000;

SECTIONS
{
    . = SECTION_START_ADDRESS;
    .text : ALIGN(0x10)
    {   
        __text_load = LOADADDR(.text);
        __text_start = .;
        *(.text)
        . = ALIGN(0x10);
        __text_end = .;
    } > ddr_cached_32
        . = SECTION_START_ADDRESS;
    .data : ALIGN(0x10)
    {   
        __data_load = LOADADDR(.data);
        __data_start = .;
        *(.data)
        . = ALIGN(0x10);
        __data_end = .;
    } > ddr_cached_32
    _end = .;

    .stack : ALIGN(0x1000)
    {
        __stack_bottom = .;
        . += STACK_SIZE;
        __stack_top = .;
    } > ddr_cached_32
    
}
OUTPUT_ARCH("riscv")
ENTRY(_start)

MEMORY
{
    ddr_cached_32 (rwx) : ORIGIN = 0x80000000, LENGTH = 4M
}
STACK_SIZE = 4k;
SECTION_START_ADDRESS = 0x80000000;

SECTIONS
{
    . = SECTION_START_ADDRESS;
    .text : ALIGN(0x10)
    {   
        __text_load = LOADADDR(.text);
        __text_start = .;
        *(.text)
        . = ALIGN(0x10);
        __text_end = .;
    } > ddr_cached_32
    _end = .;

    .stack : ALIGN(0x1000)
    {
        __stack_bottom = .;
        . += STACK_SIZE;
        __stack_top = .;
    } > ddr_cached_32
    
}
