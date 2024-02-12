;; input.asm

getInput:
	xor ax, ax

.loop:
	mov ah, 0
	int 0x16 ; ah = scancode, al = ascii char
	; pauses exec. until keystroke

	cmp al, 48
	jnb .ascii

	cmp al, 44
	je .comma
	cmp al, 8
	je .backspace
	cmp al, 13
	je .enter

.other:
	jmp .loop

.comma:
	call printChar
	jmp .end

.backspace:
	call printChar
	mov al, 32
	call printChar
	mov al, 8
	call printChar
	jmp .end

.enter:
	call printChar
	mov al, 10
	call printChar
	jmp .end ; on new line do other stuff

.ascii:
	cmp al, 57
	ja .letter
	call printChar
	jmp .loop

.letter:
	cmp al, 

.end:
	ret






