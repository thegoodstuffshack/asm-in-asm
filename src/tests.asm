;; test.asm

testPages:
	mov al, [PAGE]
	add al, 48
	call printChar

	push word 0x0007
	mov ax, [bp-2]
	add al, 48
	call printChar											;===
	mov ax, [bp-2]
	call setPage
	call getVideoMode ; update PAGE in memory
	mov [PAGE], bh
	mov al, [PAGE]
	add al, 48
	call printChar											;===
	
	xor ah, ah
	mov al, [PAGE]
	cmp ax, [bp-2]
	je .skip

	mov al, 63
	call printChar

.skip:

	push word [0x044E]
	call printHex
	pop ax
	ret

testVideoMemory:
	push 0xB800
	pop es
	push word [es:0x0002]
	push word [es:0x0000]
	call printHex ; print first char on screen's hex makeup
	call printHex ; print second's

	mov word [es:0x00F0], 0x0780
	mov word [es:0x00F2], 0x0F0E
	ret