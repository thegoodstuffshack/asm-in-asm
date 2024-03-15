;; assembler.asm

; read through code
; 'remove' comments (dont send to compile)
; remove commas
; LATER - turn labels to addresses
; disregard addresses at start of line

assembler:	; read from video memory
	push bp
	push sp
	mov bp, sp
	
	xor bx, bx		; line number
	xor di, di

.loop:
	jmp get_line ; jmp to not mess up stack
	.get_line_return:

	cmp al, ' '
	je .ignore_empty_line
	cmp al, COMMENT_CHAR
	je .ignore_comment
	cmp al, END_FILE_CHAR
	je .end_file
	cmp al, 97
	jb .ignore_invalid_char
	cmp al, 122
	ja .ignore_invalid_char

	mov di, [bp]
	and di, 0x00FF
	shl di, 1 ; x2
	call word [di + instruction_alphabet_jump_table - 97*2]
	
	jmp .end		; FOR NOW

.ignore_invalid_char:
.ignore_empty_line:	; change these labels to 'ignore' only?
.ignore_comment:
	add bx, 80	; screen width
	mov si, LINE_WRITE_OFFSET
	; jmp .loop

.end_file:
.end:
	push word 0x0000
	pop es
	pop sp ; reset stack (doesn't clear data)
	pop bp
	ret

; copy mem of line onto the stack
; lower byte of word is data byte so only copy this
get_line:
	push word VIDEO_MEMORY_ADDR
	pop es
	mov si, LINE_WRITE_OFFSET	; start column number

.loop:
	cmp si, 160
	je .end

	mov al, byte [es:si + bx + 1]	; push data byte of each letter in line
	push al
	add si, 2
	jmp .loop

.end:
	jmp assembler.get_line_return