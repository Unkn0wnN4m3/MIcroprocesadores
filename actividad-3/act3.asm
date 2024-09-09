: Code for activity 2

; - cruz San Juan Aaron
; - Lopez Rodriguez Julio Cesar
; - Rodriguez Meneses Jvierr
; - Eslava Colin Cesar Barush

;code segment starts here
	.org 0000h
	;program port
	;Port A -->, PortB -->, Port C <--
	ld a,89h
	out (CW),a
	;init stack
	ld SP,27ffh
	;-----------
	ld hl,text1
	call disp_text
	call read_password
	halt

;subrutinas

;------------------------------
;display a text on LCD address
;input: text address on hl
;output: character in A to LCD
;------------------------------
disp_text:
repeat1:
	ld a,(hl)
	cp "&"
	jp z,end_sub1
	out (LCD),a
	inc hl
	jp repeat1
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
    cp 40h
    jp c,valid_text
    ld hl, error_text
    call disp_text

    ret

valid_text:
	ld (hl),a
	djnz read_other

	ret

;data segment
	.org 2000h
text1:	   .db "NIP: &"
error_text .db "INVALID &"
pattern    .db "1234"
passw	   .db 00h,00h,00h,00h

;constants
LCD:	.equ 00h
KEYB:	.equ 01h
CW	.equ 03h

;program ends
	.end