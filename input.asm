;; input.asm

; return ah = scancode
; return al = ascii char
getInput:
	mov ah, 0
	int 0x16
	ret

; input ah as scancode
; input al as ascii char
printInput:
.loop:
	cmp al, 8
	je .backspace
	cmp al, 13
	je .enter

	call printChar
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







