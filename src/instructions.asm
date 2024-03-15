;; instructions.asm

; add all the other flag controls
; sort between possible instructions, return if no match
instructions_sort:
.a:
	;add
	;and
.b:
.c:
	;call
	;clc
	;cmp
.d:
	;db,dw,dd,dq
	;dec
	;div
.e:
.f:
.g:
.h:
.i:
	;int
	;inc
.j:
	;jmp
	;conditional jumps
.k:
.l:
	;lea
	mov al, 2
	call printChar
	ret

.m:	; mov, mult
	mov ax, [es:si + bx + 2]
	cmp al, 'o'
	je instruction.mov
	cmp al, 'u'
	je instruction.mult
	jmp .no_match

.n:
.o:
	;or
.p:
	;push
	;pop
.q:
.r:
	;ret
.s:
	;sub
	;shr,shl
.t:
.u:
.v:
.w:
.x:
	;xor
.y:
.z:
	mov al, 3
	call printChar

.no_match:
	xor ax, ax
	ret


instruction:
.mov:
	mov ax, [es:si + bx + 4]
	cmp al, 'v'
	jne instructions_sort.no_match
	mov ax, [es:si + bx + 6]
	cmp al, ' '
	jne instructions_sort.no_match




	mov al, 'a'
	call printChar
	ret

.mult:
	mov ax, [es:si + bx + 8]
	cmp al, ' '
	jne .end
	mov al, 'm'
	call printChar
	ret

.end: