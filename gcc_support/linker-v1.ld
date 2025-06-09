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

    .sdata : ALIGN(0x10)
    {   
        __sdata_load = LOADADDR(.sdata);
        __sdata_start = .;
        *(.sdata)
        . = ALIGN(0x10);
        __sdata_end = .;
    } > ddr_cached_32
    

    .data : ALIGN(0x10)
    {   
        __data_load = LOADADDR(.data);
        __data_start = .;
        *(.data)
        . = ALIGN(0x10);
        __data_end = .;
    } > ddr_cached_32

    .sbss : ALIGN(0x10)
    {   
        __sbss_load = LOADADDR(.sbss);
        __sbss_start = .;
        *(.sbss)
        . = ALIGN(0x10);
        __sbss_end = .;
    } > ddr_cached_32

    .bss : ALIGN(0x10)
    {   
        __bss_load = LOADADDR(.bss);
        __bss_start = .;
        *(.bss)
        . = ALIGN(0x10);
        __bss_end = .;
    } > ddr_cached_32
    _end = .;

    .stack : ALIGN(0x1000)
    {
        __stack_bottom = .;
        . += STACK_SIZE;
        __stack_top = .;
    } > ddr_cached_32
    
}