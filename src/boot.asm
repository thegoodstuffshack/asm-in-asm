[bits 16]
[org 0x7c00]
	jmp short start

BOOT_DRIVE	db 0
MOUSE_POS 	dw 0x0000
PAGE		db 0

start:
	xor ax, ax
	mov es, ax
	mov ds, ax
	mov ss, ax
	mov sp, 0x7c00
	
	mov [BOOT_DRIVE], dl
	
	mov al, 14
	call printChar

	call checkDrives
	push word [checkDrives.a]
	call printHex
	
	push word [checkDrives.b]
	call printHex

	push word [checkDrives.c]
	call printHex

	push word [checkDrives.d]
	call printHex
	mov al, [BOOT_DRIVE]
	call printChar
	jmp $

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
	call printHex ; print first char on screen's hex makeup
	call printHex ; print second's

	mov word [es:0x00F0], 0x0780
	mov word [es:0x00F2], 0x0F0E

	call displayMouseCoords
	
.loop:
	xor ax, ax
	call getInput
	call printInput
	jmp .loop

	cli
	hlt

%include "src/print.asm"
%include "src/mouse.asm"
%include "src/input.asm"
%include "src/file_manager.asm"

times 510-($-$$) db 0
dw 0xAA55
