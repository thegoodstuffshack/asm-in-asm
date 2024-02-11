# Bios Video Mode 3
- text 80x25 colour
- 2 bytes for each char, colour-char
- video memory address: 0xB8000
- default memory is 0x0720 for light grey space
- colours: https://en.wikipedia.org/wiki/BIOS_color_attributes

# How ASM is converted to MC
- for instructions that use relative addresses (e.g. calls, jumps), the address is the amount of bytes after the instruction



## Instructions and their opcode, size, example, explanation
| instruction    	    | opcode    | size | example         | explanation           |
| --------------------- | --------- | ---- | --------------- | --------------------- |
| jmp short   	        | EB        | 2    | EB 02           | jmp 2 bytes ahead     |
| call word          	| E8        | 3    | E8 2100         | call 21 bytes ahead   |
| push word imm         | 68        | 3    | 68 00A0         | push 0xA000           |
| push word [imm]       | FF 36  	| 4    | FF 36 0001      | push word [0x0100]    |
| push word [es:imm]    | 26 FF 36  | 5    | --------------- | -------------------   |
| pop es	  	        | 07        | 1	   | 07              | pop word into es      |
| --------------------- | --------- | ---- | --------------- | --------------------- |