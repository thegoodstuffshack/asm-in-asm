;; mouse.asm

; returns dh = row
; returns dl = column
getMouseCoords:
	mov ah, 0x03
	mov bh, [PAGE]
	int 0x10
	ret

; input dh as row
; input dl as column
moveMouse:
	mov ah, 0x02
	xor bx, bx
	int 0x10
	ret

relMoveMouse:
	push bp
	mov bp, sp
	call getMouseCoords
	mov ax, [bp+4]
	add dh, ah
	add dl, al
	call moveMouse
	pop bp
	ret 2 ; pop word

displayMouseCoords:	; convert 0x0000 to x, y
	mov dx, 0x1848 ; set mouse to part of screen set for coords
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
	
.x_continue:
	add al, 48
	call printChar
	mov al, ','
	call printChar
	
.y_coords:
	mov ax, [MOUSE_POS]
	cmp ah, 10
	jb .y_continue
	
	shr ax, 8
	mov bl, 10
	div bl
	
	mov bl, ah
	add al, 48
	call printChar
	mov ah, bl
	
.y_continue:
	mov al, ah
	add al, 48
	call printChar
	
.end:
	mov dx, [MOUSE_POS]
	call moveMouse
	ret