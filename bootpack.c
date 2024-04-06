void io_hlt(void);
void write_mem8(int addr, int data);

void _DAOS_Main(void) {
  int i;
  char *p;
  for(i = 0xa0000; i <=0xaffff; i++){
    p = (char *)i;
    *p = i & 0x0f;
    // or use the library:
    // write_mem8(i, i & 0x0f);
  }
  for(;;){
    io_hlt();
  }
}
