#!/bin/sh
nasm -f bin ipl.asm -o ipl.bin
nasm -f bin small.asm -o small.bin
dd if=/dev/zero of=daos.img bs=512 count=2880
dd if=ipl.bin of=daos.img bs=512 count=1 conv=notrunc
dd if=small.bin of=daos.img bs=512 seek=33 conv=notrunc