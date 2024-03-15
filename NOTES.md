# Bios Video Mode 3

- text 80x25 colour
- 2 bytes for each char, colour-char
- video memory address: 0xB8000
- default memory is 0x0720 for light grey space
- colours: <https://en.wikipedia.org/wiki/BIOS_color_attributes>
- pages are 0x1000 bytes apart, max pages 8 (0-7), 0xB8000 - 0xBF000
- current page offset from 0xb8000 found at word 40:4E, number at byte 40:62
- screen scrolling when char's reach bottom of screen will erase the upper lines (need to change pages to preserve)

## How ASM is converted to MC

- for instructions that use relative addresses (e.g. calls, jumps), the address is the amount of bytes after the instruction

## some qemu stuff

- qemu-system-x86_64 -drive if=none,id=usb,file=C:/TEMP/image.img -drive format=raw,file=test.bin
- Dump 80 16 bit values at the start of the video memory: xp/80hx 0xb8000
- pmemsave addr size file

## Instructions and their opcode, size, example, explanation

| instruction           | opcode    | size | example         | explanation           |
| --------------------- | --------- | ---- | --------------- | --------------------- |
| jmp short             | EB        | 2    | EB 02           | jmp 2 bytes ahead     |
| call word             | E8        | 3    | E8 2100         | call 21 bytes ahead   |
| push word imm         | 68        | 3    | 68 00A0         | push 0xA000           |
| push word [imm]       | FF 36     | 4    | FF 36 0001      | push word [0x0100]    |
| push word [es:imm]    | 26 FF 36  | 5    | --------------- | -------------------   |
| pop es                | 07        | 1    | 07              | pop word into es      |
| ret                   | C3        | 1    | C3              | return from call      |
| --------------------- | --------- | ---- | --------------- | --------------------- |

## assembler

### what it does

- ignore comments, empty lines and lines that have bad formatting (give error?)
- convert labels into addresses
- read the 'file' line by line and send data to compiler as per below
- run the compiler after detecting end of 'file'

### how it works

1. scan line
2. if comment, goto next line
3. if end of file, send to compiler
4. if there's a colon, handle as label
5. read next word and compare to keywords
6. if next word is keyword, send

### Potential Bugs

- when checking 2nd+ char/s of instruction, certain incorrect chars can sum to give a 'correct' instruction
- if instructions given in a line are valid and there's a space between the valid set and some random gibberish, will still assemble and will ignore chars after
