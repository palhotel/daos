ifndef GCCPREFIX
GCCPREFIX :=
endif

AS		:= nasm
CC		:= $(GCCPREFIX)gcc
LD		:= $(GCCPREFIX)ld
OBJCOPY	:= $(GCCPREFIX)objcopy
AR		:= $(GCCPREFIX)ar
CFLAGS	:= -Wall -static -m32
CFLAGS += -I ./libc/include
CFLAGS += -I ./include
CFLAGS += -ffunction-sections -nostdlib -nostdinc -fno-builtin -ffreestanding
CFLAGS += -fno-pie
QEMU	:= qemu-system-i386

LIBC_OBJS  := libc/stdio/stdio.bin
#LIBC_OBJS  :=
OBJS	:= ipl.bin asmhead.bin bootpack.bin func.bin
SYS		:= daos.sys
IMG		:= daos.img

QEMU_FLAGS :=
QEMU_FLAGS 	+= -no-reboot -d in_asm
ifdef DEBUG
QEMU_FLAGS += -gdb tcp::1234 -S
CFLAGS += -g
endif

ipl.bin:
	$(AS) -f bin ipl.asm -o ipl.bin -l ipl.lst

asmhead.bin:
	$(AS) -f bin asmhead.asm -o asmhead.bin -l asmhead.lst

bootpack.bin:
	$(CC) $(CFLAGS) -c bootpack.c -o bootpack.bin

func.bin:
	$(AS) -f elf func.asm -o func.bin -l func.lst

%.bin: %.asm
	$(AS) -f elf $< -o $@ -l $(subst .asm,.lst,$<)

%.bin: %.c
	$(CC) $(CFLAGS) -c $< -o $@

kernel.sys: bootpack.bin func.bin ${LIBC_OBJS}
	$(LD) -m elf_i386 --oformat binary -o kernel.sys -T daos.ld $^

daos.sys: asmhead.bin kernel.sys
	cat asmhead.bin > daos.sys
	cat kernel.sys >> daos.sys

daos.elf: bootpack.bin func.bin ${LIBC_OBJS}
	$(LD) -m elf_i386 bootpack.bin func.bin ${LIBC_OBJS} -o daos.elf -T daos.ld

image: ipl.bin daos.sys daos.elf
	dd if=/dev/zero of=$(IMG) bs=512 count=2880
	dd if=ipl.bin of=$(IMG) bs=512 count=1 conv=notrunc
	dd if=daos.sys of=$(IMG) seek=33 bs=512 conv=notrunc

all: ${OBJS} daos.sys image

clean:
	rm -rf *.bin
	rm -rf *.sys
	rm -rf *.obj
	rm -rf *.lst
	rm -rf libc/**/*.bin
	rm -rf $(IMG)
	rm -rf *.a
	rm -rf *.elf

qemu: clean all
	$(QEMU) -fda $(IMG) $(QEMU_FLAGS)

.PHONY:
	all