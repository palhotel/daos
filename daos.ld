ENTRY( bootpack )

SECTIONS
{
  . = 0xc200;
  .btext : { }
  .text : {
      *(.text.main)
      *(.text)  /* 包含所有.text段的内容 */
      *(.text.*)  /* 包含所有以.text开头的段 */
  }

  .rodata : {
      *(.rodata)  /* 包含所有.rodata段的内容 */
  }

  .data : {
      *(.data)  /* 包含所有.data段的内容 */
  }

  .bss : {
      *(.bss)  /* 包含所有.bss段的内容 */
      *(COMMON)  /* 包含所有未明确分配到其他段的未初始化数据 */
  }
}
