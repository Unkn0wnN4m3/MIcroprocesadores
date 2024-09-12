; Code for activity 3

;code segment starts here
	.org 0000h

	;program port
	;Port A -->, PortB -->, Port C <--
	; (out)      (out)       (in)
	ld a,89h
	out (CW),a

	;init stack
	ld SP,27ffh

 start:
	ld hl,prompt1
	call disp_text
	call read_password
	call validate_password

	ld hl, attemps
	ld a, (hl)
	cp "3"
	jp nz, start

	ld hl, finish_message
	call disp_text
	halt

;subrutinas

;------------------------------
;display a text on LCD address
;input: text address on hl
;output: character in A to LCD
;------------------------------
disp_text:
next_word:
	ld a,(hl)
	cp "&"
	jp z,end_sub1
	out (LCD),a
	inc hl
	jp next_word
end_sub1:
	ret

;------------------------------
;display a text on LCD address
;input: text address on hl
;output: character in A to LCD
;------------------------------
read_password:
	ld hl,passw
	ld b,4
read_other:
	in a,(KEYB)
	ld (hl),a
	out (LCD),"*"
	djnz read_other

	ret

; password validation
validate_password:
	ld hl, passw
	ld a ,(hl)
	cp (pattern)
	jp z,valid

	ld hl, denied
	call disp_text

	ld hl, attemps
	ld a, (hl)
	add a, 01h
	ret
valid:
	ld hl, granted
	call disp_text
	ret


;data segment
	.org 2000h
prompt1	   .db "NIP: &"
error_text .db "INVALID &"
granted    .db "ACCES GRANTED"
denied     .db "ACCES denied"
finish_message     .db "NEXT TIME"
pattern    .db "1234"
passw	   .db 00h,00h,00h,00h
attemps    .db 00h

;constants
LCD		.equ 00h
KEYB	.equ 01h
CW		.equ 03h

;program ends
	.end