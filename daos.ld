ENTRY( dazentry )

SECTIONS
{
  . = 0xc200;
  .btext : { *(.btext) }

  .text : { *(.text) }
  .data : { *(.data) }
}
