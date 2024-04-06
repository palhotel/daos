void io_hlt(void);
void io_cli(void);
void io_out8(int port, int data);
int io_load_eflags(void);
void io_store_eflags(int eflags);
void write_mem8(int addr, int data);
void init_palette(void);
void set_palette(int start, int end, unsigned char *rgb);


void _DAOS_Main(void) {
  int i;
  char *p;
  init_palette();
  //0xa0000是左上角的像素点
  for(i = 0xa0000; i <=0xaffff; i++){
    p = (char *)i;
    *p = i & 0x0f; //选择调色板上的一个颜色，这里确保在0~15之间
    // or use the library:
    // write_mem8(i, i & 0x0f);
  }
  for(;;){
    io_hlt();
  }
}

void init_palette(void){
  static unsigned char table_rgb[16*3] = {
    0x00, 0x00, 0x00,
    0x66, 0x00, 0x00,
    0xcc, 0x00, 0x00,
    0xff, 0x00, 0x00,
    0x00, 0x66, 0x00,
    0x00, 0xcc, 0x00,
    0x00, 0xff, 0x00,
    0x00, 0x00, 0x66,
    0x00, 0x00, 0xcc,
    0x00, 0x00, 0xff,
    0xcc, 0xcc, 0x00,
    0xff, 0xff, 0x00,
    0xcc, 0x00, 0xcc,
    0xff, 0x00, 0xff,
    0x00, 0xff, 0xff,
    0xff, 0xff, 0xff,
  };
  set_palette(0, 15, table_rgb);
}

void set_palette(int start, int end, unsigned char *rgb){
  int i, eflags;
  eflags = io_load_eflags(); //记录中断许可标志的值
  io_cli();//中断许可标志设置为0
  io_out8(0x3c8, start); //将想要设定的调色板号码写入0x3c8，然后将rgb写入0x3c9
  for(i = start; i <= end; i++){
    io_out8(0x3c9, rgb[0]/4);
    io_out8(0x3c9, rgb[1]/4);
    io_out8(0x3c9, rgb[2]/4);
    rgb += 3;
  }
  io_store_eflags(eflags);
}

