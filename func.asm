  ; [FORMAT "WCOFF"]
  ; just like C library
  [BITS 32]

  GLOBAL io_hlt, write_mem8     ; 程序中包含函数名
  GLOBAL io_cli, io_sti
  GLOBAL io_in8, io_in16, io_in32
  GLOBAL io_out8, io_out16, io_out32
  GLOBAL io_load_eflags, io_store_eflags
  GLOBAL load_gdtr, load_idtr
  GLOBAL asm_int_handler21, asm_int_handler27, asm_int_handler2c
  EXTERN int_handler21, int_handler27, int_handler2c

  [SECTION .text]
io_hlt:              ; void io_hlt(void);
  HLT
  RET

write_mem8:             ; void write_mem8(int addr, int data);
   MOV     ECX, [ESP+4]  ; addr,从右往左依次进栈
   MOV     AL, [ESP+8]   ; data
   MOV     [ECX], AL
   RET

io_cli:
  CLI
  RET
io_sti:
  STI
  RET
io_in8: ;int io_in8(int port)
  MOV EDX, [ESP + 4]
  MOV EAX, 0
  IN AL, DX
  RET
io_in16: ;int io_in16(int port)
  MOV EDX, [ESP + 4]
  MOV EAX, 0
  IN AX, DX
  RET
io_in32: ;int io_in32(int port)
  MOV EDX, [ESP + 4]
  MOV EAX, 0
  IN EAX, DX
  RET
io_out8: ; void io_out8(int port, int data)
  MOV EDX, [ESP + 4]
  MOV AL, [ESP + 8]
  OUT DX, AL
  RET
io_out16: ; void io_out16(int port, int data)
  MOV EDX, [ESP + 4]
  MOV EAX, [ESP + 8]
  OUT DX, AX
  RET
io_out32: ; void io_out32(int port, int data)
  MOV EDX, [ESP + 4]
  MOV EAX, [ESP + 8]
  OUT DX, EAX
  RET
io_load_eflags:
  PUSHFD ; Push Flags Double-word
  POP EAX
  RET
io_store_eflags:
  MOV EAX, [ESP + 4]
  PUSH EAX
  POPFD
  RET

load_gdtr:               ; void load_gdt(int limit, int addr);
  MOV   AX, [ESP+4]     ; limit
  MOV   [ESP+6], AX
  LGDT  [ESP+6]
  RET

load_idtr:               ; void load_idt(int limit, int addr);
  MOV   AX, [ESP+4]     ; limit
  MOV   [ESP+6], AX
  LIDT  [ESP+6]
  RET

asm_int_handler21:
  PUSH    ES
  PUSH    DS
  PUSHAD
  MOV     EAX, ESP
  PUSH    EAX
  MOV     AX, SS
  MOV     DS, AX
  MOV     ES, AX
  CALL    int_handler21
  POP     EAX
  POPAD
  POP     DS
  POP     ES
  IRETD

asm_int_handler27:
  PUSH    ES
  PUSH    DS
  PUSHAD
  MOV     EAX, ESP
  PUSH    EAX
  MOV     AX, SS
  MOV     DS, AX
  MOV     ES, AX
  CALL    int_handler27
  POP     EAX
  POPAD
  POP     DS
  POP     ES
  IRETD

asm_int_handler2c:
  PUSH    ES
  PUSH    DS
  PUSHAD
  MOV     EAX, ESP
  PUSH    EAX
  MOV     AX, SS
  MOV     DS, AX
  MOV     ES, AX
  CALL    int_handler2c
  POP     EAX
  POPAD
  POP     DS
  POP     ES
  IRETD

