;; display.asm

; function to display the static elements on screen
; mouse coords, line address, current page, time?

displayStatic:
	; call displayAddresses
	call displayTime
	call displayPage
	call displayMouseCoords
	mov dx, [MOUSE_POS] ; restore mouse pos
	call moveMouse
	ret

displayTime:
	mov dx, 0x183C
	call moveMouse

	; get time UTC
	mov ah, 0x02
	clc ; clear carry flag
	int 0x1A

	push cx
	call .adjustTime
	push cx
	mov cx, 2
	call printHex
	mov al, ':'
	call printChar
	mov cx, 2
	call printHex
	ret

.adjustTime:
	; adjust ch and mov to cl
	mov al, ch
	cmp al, 0b00100000
	jae .two
	cmp al, 0b00010000
	jae .one
.zero:
	mov al, 0
	jmp .tensdone
.one:
	mov al, 10
	jmp .tensdone
.two:
	mov al, 20

.tensdone:
	and ch, 0b00001111
	add ch, al
	add ch, UTC_TIME_OFFSET
	cmp ch, 0
	jl .lowerthanzero
	cmp ch, 24
	jl .adjust_end

.higherthan24:
	sub ch, 24
	jmp .adjust_end

.lowerthanzero:
	add ch, 24

.adjust_end:
	; turn ascii to BCD
	mov cl, ch
	cmp cl, 10
	jb .done
	cmp cl, 20
	jae .above

	sub ch, 10
	mov cl, 0x10
	add cl, ch
	jmp .done

.above:
	sub ch, 20
	mov cl, 0x20
	add cl, ch

.done:
	ret

displayPage:
	mov dx, 0x1843
	call moveMouse

	mov si, displayPage.string
	mov cl, 4
	call printString
	mov al, [PAGE]
	add al, 48
	call printChar
	ret
.string dw "PAGE"

displayMouseCoords:	; convert 0x0000 to x, y
	mov dx, 0x184A ; location of mouse coord display (any higher causes autoscroll of screen)
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
	ret