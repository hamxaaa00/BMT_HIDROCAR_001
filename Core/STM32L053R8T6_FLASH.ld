/* Linker script for STM32L053R8T6
 * Flash: 64 KB @ 0x08000000
 * RAM:   8 KB  @ 0x20000000
 */

ENTRY(Reset_Handler)

/* Memory regions */
MEMORY
{
  FLASH (rx)      : ORIGIN = 0x08000000, LENGTH = 64K
  RAM (xrw)       : ORIGIN = 0x20000000, LENGTH = 8K
}

/* Sections */
SECTIONS
{
  /* Vector Table */
  .isr_vector :
  {
    . = ALIGN(4);
    KEEP(*(.isr_vector))
    . = ALIGN(4);
  } >FLASH

  /* Program code + read-only data */
  .text :
  {
    . = ALIGN(4);
    *(.text)           
    *(.text*)          
    *(.rodata)         
    *(.rodata*)
    *(.glue_7)
    *(.glue_7t)
    *(.eh_frame)

    KEEP (*(.init))
    KEEP (*(.fini))

    . = ALIGN(4);
    _etext = .;
  } >FLASH

  /* Data section (variables with initial values) */
  _sidata = LOADADDR(.data);

  .data :
  {
    . = ALIGN(4);
    _sdata = .;
    *(.data)
    *(.data*)
    . = ALIGN(4);
    _edata = .;
  } >RAM AT> FLASH

  /* Uninitialized variables (BSS) */
  .bss :
  {
    . = ALIGN(4);
    _sbss = .;
    *(.bss)
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    _ebss = .;
  } >RAM

  /* Heap + Stack */
  ._user_heap_stack :
  {
    . = ALIGN(8);
    PROVIDE ( end = . );
    PROVIDE ( _end = . );
    . = . + 0x400; /* Heap size: 1 KB */
    . = . + 0x400; /* Stack size: 1 KB */
    . = ALIGN(8);
  } >RAM

  /* Stack pointer (top of RAM) */
  _estack = ORIGIN(RAM) + LENGTH(RAM);
}
