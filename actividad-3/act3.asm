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

 ; start point.
start:
	ld hl, prompt1
	call disp_text
	call read_password
	call validate_password

	ld hl, attemps

	; if everything goes good, jump directly to the finish point
	ld a, (hl)
	cp "0"
	jp z, finish

	; jump to start if while the maximum number of of attemps hasn't been
	; reached
	ld a, (hl)
	cp "3"
	jp nz, start

	; reached maximun number of attemps
	ld hl blocked
	call disp_text
	jp finish

finish:
	halt

;subrutines

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
; Read from keyboard
;input: ascii from keyboard
;output: None
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
; compares "passw" and "pattern"
; input: contents in passw and pattern
; output: attemps
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
prompt1    .db "NIP: &"
error_text .db "INVALID &"
granted    .db "ACCES GRANTED &"
denied     .db "ACCES denied &"
blocked    .db "U HAVE BEEN BLOCKED &"
pattern    .db "1234"
passw      .db 00h,00h,00h,00h
attemps    .db "3"

;constants
LCD   .equ 00h
KEYB  .equ 01h
CW    .equ 03h

;program ends
	.end
