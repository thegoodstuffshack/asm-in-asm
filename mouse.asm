;; mouse.asm

getMouseCoords:
	mov ah, 0x03
	mov bh, [PAGE]
	int 0x10
	ret

; input dx as dh, dl (row, col)
moveMouse:
	mov ah, 0x02
	xor bx, bx
	int 0x10
	ret

displayMouseCoords:	; convert 0x0000 to x, y
	mov dx, 0x1848 ; set mouse to part of screen set for coords
	call moveMouse

.x_coords:	
	mov ax, dx
	cmp al, 10
	jb .x_continue		; 62, 3E, 0011 1110
	
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
	mov ax, dx
	cmp ah, 10
	jb .y_continue
	
	shr ax, 8	;FF 0000 0000 0000 0000
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