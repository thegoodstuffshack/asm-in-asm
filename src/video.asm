;; video.asm

; return ah = number of char columns
; return al = display mode
; return bh = active page number
getVideoMode:
	mov ah, 0x0F
	int 0x10
	ret

; should call getVideoMode after to verify page exists
; input al as new page number
setPage:
	mov ah, 0x05
	int 0x10
	ret