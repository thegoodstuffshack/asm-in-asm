;; input.asm

; return ah = scancode
; return al = ascii char
getInput:
	mov al, 0
	int 0x16
	ret

; input ah as scancode
; input al as ascii char
printInput:
.loop:
	cmp al, 0
	je .arrows

	cmp al, 8
	je .backspace
	cmp al, 13
	je .enter

	call printChar
	ret

.arrows:
	cmp ah, 'H'
	je .up
	cmp ah, 'P'
	je .down
	cmp ah, 'K'
	je .left
	cmp ah, 'M'
	je .right
	ret ; if not arrows, do nothing

.up:
	mov dx, [MOUSE_POS]
	or dh, dh
	jz .skipup
	dec dh
	mov [MOUSE_POS], dx
	call moveMouse
.skipup:
	ret

.down:
	mov dx, [MOUSE_POS]
	cmp dh, 24
	je .skipdown
	inc dh
	mov [MOUSE_POS], dx
	call moveMouse
.skipdown:
	ret

.left:
	mov dx, [MOUSE_POS]
	or dl, dl
	jz .skipleft
	dec dl
	mov [MOUSE_POS], dx
	call moveMouse
.skipleft:
	ret

.right:
	mov dx, [MOUSE_POS]
	cmp dl, 79
	je .skipright
	inc dl
	mov [MOUSE_POS], dx
	call moveMouse
.skipright:
	ret

.backspace:
	call printChar
	mov al, 32
	call printChar
	mov al, 8
	call printChar

	push word [MOUSE_POS]
	call printHex
	ret

.enter:
	call printChar
	mov al, 10
	call printChar
	ret
