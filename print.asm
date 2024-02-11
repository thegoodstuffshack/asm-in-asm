;; print.asm

; al as input
printChar:
	mov ah, 0x0e
	int 0x10
	ret

; input si as string address
; input cl as string length
printString:
	mov ch, 0
	mov ah, 0x0e
.loop:
	lodsb
	int 0x10
	loop .loop
	ret

; push ax as input
printHex:
	push bp
	mov bp, sp

	mov cx, 4
.loop:
	push cx
	mov ax, 4
	mov bx, 3
	dec cx
	sub bx, cx
	mul bx
	mov cx, ax
	mov ax, word [bp+4]
	shl ax, cl
	shr ax, 12
	
	cmp al, 10
	jb .number
	mov ah, 55
	jmp .character
.number:
	mov ah, 48
.character:
	add al, ah
	mov ah, 0x0e
	int 0x10
	pop cx
	loop .loop
.end:
	pop bp
	ret 2	; pop 2 bytes off stack