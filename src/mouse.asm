;; mouse.asm

; returns dh = row
; returns dl = column
updateMouseCoords:
	mov ah, 0x03
	mov bh, [PAGE]
	int 0x10
	mov [MOUSE_POS], dx
	ret

; input dh as row
; input dl as column
moveMouse:
	mov ah, 0x02
	xor bx, bx
	int 0x10
	ret

displayMouseCoords:	; convert 0x0000 to x, y
	mov dx, 0x184A ; location of mouse coord display
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
	mov dx, [MOUSE_POS] ; restore mouse pos
	call moveMouse
	ret