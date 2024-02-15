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