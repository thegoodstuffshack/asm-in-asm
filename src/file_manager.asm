;; file_manager.asm

checkDrives:
	; current drive
	mov ah, 0x08
	mov dl, [BOOT_DRIVE]
	xor di, di
	mov es, di
	int 0x13
	jc .firsterror


	mov word [.a], cx
	mov word [.b], dx

	mov cl, 0
	push cx
.loop:
	pop cx
	inc cl
	mov al, 14
	call printChar
	push cx
	; host drive?
	mov ah, 0x08
	mov dl, 0
	xor di, di
	mov es, di
	int 0x13
	jc .loop

	pop ax
	; mov al, dl
	call printChar
	mov al, [BOOT_DRIVE]
	call printChar

	mov word [.c], cx
	mov word [.d], dx
	ret

.a dw 0
.b dw 0
.c dw 0
.d dw 0

.firsterror:
	mov al, ah
	call printChar
	mov al, 1
	call printChar
	hlt

.seconderror:
	mov al, ah
	call printChar
	mov al, 2
	call printChar
	hlt