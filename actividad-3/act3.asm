; Code for activity 3

; ------------- code segment starts here ------------
	.org 0000h

	;program port
	;Port A -->, PortB -->, Port C <--
	; (out)      (out)       (in)
	ld a,89h
	out (CW),a

	;init stack
	ld SP,27ffh

 ; ---------- start point. -----------------
start:
  call dis_wellcome ; impime la palabra "NIP: "
  call get_passw ; obtiene la contrasena e imprime "*" en lugar de numeros
  call validate
  ; por ultimo, verificar intentos
finish:
  halt

; ---------- start subroutines -------------

dis_wellcome:
  ld hl, prompt1 ; hl -> es una direccion

loop1:
  ld a, (hl) ; a -> lo que vale esa direccion
  ; cp compara con a
  cp '&' ; 26 en hex
  jp nz, another_word
  ret

another_word:
  out (LCD), a
  inc hl
  jp loop1

get_passw:
  ld hl, passw ; hl -> es la direccion de passw
  ld b, 4 ; b -> max de caracteres permitidos

loop2:
  ld a, '*'
  out (LCD), a
  in a, (KEYB) ; -> lo que VALE keyb se guarda en a
  ld (hl), a ; a -> lo que VALE hl
  ; djnz compara con b
  djnz loop2
  ret

validate:
  ld de, passw
  ld hl, pattern
  ld b, 4

loop3:
  ld a, (de) ; -> lo que vale passw
  ; cp siempre compara con el registro a
  cp (hl)
  jp nz, incorrect
  inc hl
  inc de
  djnz loop3
  jp correct

done:
  jp finish

correct:
  ld hl, granted ; hl -> es una direccion

loop4:
  ld a, (hl) ; a -> lo que vale esa direccion
  ; cp compara con a
  cp '&' ; 26 en hex
  jp nz, another_word1
  jp done

another_word1:
  out (LCD), a
  inc hl
  jp loop4

incorrect:
  ld hl, denied ; hl -> es una direccion

loop5:
  ld a, (hl) ; a -> lo que vale esa direccion
  ; cp compara con a
  cp '&' ; 26 en hex
  jp nz, another_word2
  jp done

another_word2:
  out (LCD), a
  inc hl
  jp loop5


; ---------------- data segment ------------------
	.org 2000h
prompt1    .db "NIP: &"
passw      .db 00h,00h,00h,00h
pattern    .db 31h, 32h, 33h, 34h
granted    .db "ACCES GRANTED &"
denied     .db "ACCES DENIED &"
;blocked    .db "U HAVE BEEN BLOCKED &"
;attemps    .db "3"

;constants
LCD   .equ 00h
KEYB  .equ 01h
CW    .equ 03h

;program ends
	.end
