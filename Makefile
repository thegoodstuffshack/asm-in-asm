CC = nasm
FLAGS = -f bin
IN = src/boot.asm
OUT = test.bin
QEMU = qemu-system-x86_64 
QBOOT = -drive format=raw,file=$(OUT)
# QFLAGS = -drive if=none,id=usb,format=raw,file=Q:/ -usb

all: $(IN)
	$(CC) $(IN) -o $(OUT) $(FLAGS)

run:
	make && $(QEMU) $(QBOOT) $(QFLAGS)