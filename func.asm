  ; [FORMAT "WCOFF"]
  [BITS 32]

  GLOBAL io_hlt, write_mem8     ; 程序中包含函数名

  [SECTION .text]
io_hlt:              ; void io_hlt(void);
  HLT
  RET

write_mem8:             ; void write_mem8(int addr, int data);
   MOV     ECX, [ESP+4]  ; addr,从右往左依次进栈
   MOV     AL, [ESP+8]   ; data
   MOV     [ECX], AL
   RET
