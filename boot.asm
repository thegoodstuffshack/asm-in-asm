[bits 16]
[org 0x7c00]
	dw 0x03EB	;;jmp short 0x05 (start)

MOUSE_POS 	dw 0x0000
PAGE		db 0

start:
	; set video mode 3
	dw 0x00B4	;;mov ah, 0
	dw 0x03B0	;;mov al, 0x03
	dw 0x10CD	;;int 0x10

	dw 0x0EB0 	;;mov al, 14
	call printChar
	

	push 0xB800
	pop es
	push word [ds:0x0002]
	push word [es:0x0000]
	call printHex
	call printHex

	mov word [es:0x00F0], 0x0780
	mov word [es:0x00F2], 0x0F0E

	call displayMouseCoords
	
	cli
	hlt

%include "print.asm"
%include "mouse.asm"

times 510-($-$$) db 0
dw 0xAA55
