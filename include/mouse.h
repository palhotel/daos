#define KEYCMD_SENDTO_MOUSE 0xd4
#define MOUSECMD_ENABLE 0xf4

#define MOUSE_FIFO_BUF_SIZE 128

extern struct FIFO8 mousefifo;

void enable_mouse(void);

struct MOUSEBUF
{
    unsigned char data[64];
    int next;
};
