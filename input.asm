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
	push word 0xFF00
	call relMoveMouse
	ret

.down:
	push word 0x0100
	call relMoveMouse
	ret

.left:
	push word 0x00FF
	call relMoveMouse
	ret

.right:
	push word 0x0001
	call relMoveMouse
	ret

.backspace:
	call printChar
	mov al, 32
	call printChar
	mov al, 8
	call printChar
	ret

.enter:
	call printChar
	mov al, 10
	call printChar
	ret
