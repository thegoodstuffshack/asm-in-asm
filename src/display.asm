;; display.asm

; function to display the static elements on screen
; mouse coords, line address, current page, time?

displayStatic:
	; call displayAddresses
	call displayTime
	call displayPage
	call displayMouseCoords
	mov dx, [MOUSE_POS] ; restore mouse pos
	call moveMouse
	ret

displayTime:
.where equ 0x183E
.addr equ (0x18*80+0x3E)*2
	mov dx, .where
	call moveMouse

	; get time UTC
	mov ah, 0x02
	clc ; clear carry flag
	int 0x1A
	
	push cx
	mov cl, ch
	push cx
	mov cx, 2
	call printHex
	mov al, ':'
	call printChar
	mov cx, 2
	call printHex
	ret

displayPage:
	mov dx, 0x1844
	call moveMouse

	mov si, displayPage.string
	mov cl, 4
	call printString
	mov al, [PAGE]
	add al, 48
	call printChar
	ret
.string dw "PAGE"

displayMouseCoords:	; convert 0x0000 to x, y
	mov dx, 0x184A ; location of mouse coord display (any higher causes autoscroll of screen)
	call moveMouse

.x_coords:	
	mov ax, [MOUSE_POS]
	cmp al, 10
	jb .x_continue
	
	mov ah, 0
	mov bl, 10
	div bl
	
	mov bl, ah
	add al, 48
	call printChar
	mov al, bl
	jmp .x_next
	
.x_continue:
	mov al, 32
	call printChar
	mov ax, [MOUSE_POS]
.x_next:
	add al, 48
	call printChar
	mov al, ','
	call printChar
	
.y_coords:
	mov ax, [MOUSE_POS]
	cmp ah, 10
	jnb .y_continue
	
	mov al, ah
	add al, 48
	call printChar
	mov al, 32
	call printChar
	jmp .end

.y_continue:
	shr ax, 8
	mov bl, 10
	div bl

	mov bl, ah
	add al, 48
	call printChar
	mov al, bl
	add al, 48
	call printChar

.end:
	ret