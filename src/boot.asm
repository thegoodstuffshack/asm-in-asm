[bits 16]
[org 0x7c00]
	jmp short start

BOOT_DRIVE	db 0
MOUSE_POS 	dw 0x0000
PAGE		db 0

start:
	xor ax, ax
	jmp short $+0x02 ; 0x00EB - desired rel jump addr needs to have intstruction size added
	mov es, ax
	mov ds, ax
	mov ss, ax
	mov sp, 0x7c00
	mov bp, sp
	
	mov [BOOT_DRIVE], dl

	; set video mode 3
	dw 0x00B4	;;mov ah, 0
	dw 0x03B0	;;mov al, 0x03
	dw 0x10CD	;;int 0x10

	dw 0x0EB0 	;;mov al, 14
	call printChar

	mov al, 0
	mov [PAGE], al
	call setPage

.loop:
	xor ax, ax
	call getInput
	call printInput
	call updateMouseCoords
	call displayMouseCoords
	jmp .loop

	cli
	hlt

%include "src/print.asm"
%include "src/mouse.asm"
%include "src/input.asm"
; %include "src/file_manager.asm"
%include "src/parse.asm"
%include "src/compile.asm"
%include "src/video.asm"

times 510-($-$$) db 0
dw 0xAA55
