# asm-in-asm

## AIM
- create a bios mode app for bare-metal that can edit memory and then execute it, thereby writing asm in asm

### REQUIREMENTS
- nasm for compiler
- an x86 vm (eg. qemu) or legacy boot capable computer 

### HOW TO RUN
- using Make with qemu: ```make && make run```
- or: ```nasm -f bin boot.asm -o test.bin && qemu-system-x86_64 test.bin```
- or compile and then boot from usb on computer
