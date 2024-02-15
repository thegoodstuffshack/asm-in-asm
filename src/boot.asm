[bits 16]
[org 0x7c00]
	jmp short start	; 2 bytes

;; "GLOBAL VARIABLES" - as in they have an assigned address
START_ADDRESS	dw start	; 0x7c02
BOOT_DRIVE		db 0		; 0x7c04
MAX_SECTORS		db 63
MAX_HEADS		db 16
MAX_CYLINDERS	db 1

;; "PROGRAM VARIABLES" - for use in this program only (memory can used in other programs, but why?)
SECTOR_COUNT	db 1	; starts as 1
HEAD_COUNT		db 0
CYLINDER_COUNT	db 0
MOUSE_POS 		dw 0x0000
PAGE			db 0
UTC_TIME_OFFSET equ 11	; set to desired UTC+ (can be negative)

;; "CONSTANTS" - shouldn't modify in other programs
BOOT_BOOL		db 0	; set to 'true' on startup

start:
	xor ax, ax
	jmp short $+0x02 ; 0x00EB - desired rel jump addr needs to have instruction size added
	mov es, ax
	mov ds, ax
	mov ss, ax
	mov sp, 0x7c00
	mov bp, sp

	;	protect BOOT_DRIVE from being overwritten when returning to program
	cmp byte [BOOT_BOOL], 1
	ja boot_bool_corrupted
	je .notboot
	mov byte [BOOT_BOOL], 1
	mov [BOOT_DRIVE], dl

.notboot:
	; set video mode 3
	dw 0x00B4	;;mov ah, 0
	dw 0x03B0	;;mov al, 0x03
	dw 0x10CD	;;int 0x10

	call disk_handler	; sector_count -> 2
	mov al, 1
	call load_sectors

	mov al, 0
	mov [PAGE], al
	call setPage
	xor dx, dx
	call moveMouse
	call updateMouseCoords
	call displayStatic
	
	mov al, 14
	call printChar

.loop:
	xor ax, ax
	call getInput
	call printInput
	call updateMouseCoords
	call displayStatic
	jmp .loop

boot_bool_corrupted:	; could set true, give error then return to program
other_errors:			; currently undefined
	cli
	hlt

%include "src/disk.asm"
%include "src/print.asm"

times 510-($-$$) db 0
dw 0xAA55

function_def_start:
%include "src/parse.asm"
%include "src/compile.asm"
%include "src/video.asm"
%include "src/display.asm"
%include "src/mouse.asm"
%include "src/input.asm"

times 512-($-function_def_start) db 0