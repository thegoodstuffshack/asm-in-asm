[bits 16]
[org 0x7c00]
jmp start

start:
	; set video mode 3
	mov ah, 0
	mov al, 0x03
	int 0x10

	mov al, 14
	call printChar

	push 0xB800
	pop es
	push word [es:0x0002]
	push word [es:0x0000]
	call printHex
	call printHex

	mov word [es:0x00F0], 0x0780
	mov word [es:0x00F2], 0x0F0E
	
	jmp $

%include "print.asm"

times 510-($-$$) db 0
dw 0xAA55
