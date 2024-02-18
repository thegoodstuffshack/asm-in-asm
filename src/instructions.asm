;; instructions.asm

; add all the other flag controls
instructions:
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
	add ax, [es:si + bx + 4]
	add ax, [es:si + bx + 6]	; m catalogue has at least 4 measurable chars
	cmp al, 5	; o + v + ' '
	je .mov
	cmp al, 85 ; u + l + t
	je .mult
	ret
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

.end:
	ret



.mov:
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
