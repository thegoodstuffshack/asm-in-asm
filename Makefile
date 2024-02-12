CC = nasm
FLAGS = -f bin
IN = src/boot.asm
OUT = test.bin

all: $(IN)
	$(CC) $(IN) -o $(OUT) $(FLAGS)

run:
	make && qemu-system-x86_64 $(OUT)