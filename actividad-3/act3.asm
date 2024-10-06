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
    call dis_wellcome      ; imprime la palabra "NIP: "
    call get_passw         ; imprime "*" en lugar de números
    call validate          ; validar la contraseña

    ld a, (attempt)
    cp 00h                 ; verifica si attempt es 0
    jp z, finish           ; si es 0, finalizar

    ld a, (attempt)
    cp 03h                 ; verifica si attempt es 3 (máximo de intentos)
    jp z, finish           ; si es 3, finalizar

    jp start               ; si no ha alcanzado los 3 intentos, repetir

finish:
    halt

; ---------- start subroutines -------------

print:
    ld a, (hl)             ; carga el carácter desde la dirección
    cp '&'                 ; verifica si es el final de la cadena
    jp nz, another_word0   ; si no es el final, imprimir siguiente carácter
    ret

another_word0:
    out (LCD), a           ; imprime el carácter en el LCD
    inc hl                 ; mueve al siguiente carácter
    jp print               ; repetir

dis_wellcome:
    ld hl, prompt1         ; hl -> dirección de la cadena "NIP: "
    call print             ; imprime la cadena
    ret

get_passw:
    ld hl, passw           ; hl -> dirección de passw
    ld b, 4                ; número máximo de caracteres permitidos

loop2:
    ld a, '*'              ; imprime '*' por cada dígito ingresado
    out (LCD), a

    in a, (KEYB)           ; lee el valor del teclado en 'a'
    add a, 30h             ; convierte el número ingresado a ASCII
    ld (hl), a             ; almacena el valor en passw
    inc hl                 ; mueve a la siguiente posición en passw
    djnz loop2             ; repetir hasta obtener 4 dígitos
    ret

validate:
    ld de, passw           ; de -> dirección de la contraseña ingresada
    ld hl, pattern         ; hl -> dirección de la contraseña correcta
    ld b, 4                ; comparar 4 dígitos

loop3:
    ld a, (de)             ; obtiene el valor ingresado
    cp (hl)                ; lo compara con el valor correcto
    jp nz, incorrect       ; si no coinciden, saltar a "incorrect"
    inc hl                 ; siguiente byte en pattern
    inc de                 ; siguiente byte en passw
    djnz loop3             ; repetir hasta comparar los 4 dígitos
    jp correct             ; si todos los dígitos coinciden, saltar a "correct"

correct:
    ld hl, granted         ; hl -> dirección de la cadena "ACCES GRANTED"
    call print             ; imprime la cadena
    jp done

incorrect:
    ld hl, denied          ; hl -> dirección de la cadena "ACCES DENIED"
    call print             ; imprime la cadena

    ld a, (attempt)        ; carga el valor de attempt
    add a, 01h             ; incrementa el valor de intentos
    ld (attempt), a        ; almacena el nuevo valor en attempt
    jp done

done:
    ret

; ---------------- data segment ------------------

    .org 2000h
prompt1    .db "NIP: &"
passw      .db 00h,00h,00h,00h
pattern    .db "1234"           ; la clave correcta en ASCII
granted    .db "ACCES GRANTED &"
denied     .db "ACCES DENIED &"
attempt    .db 00h              ; número de intentos
;blocked    .db "U HAVE BEEN BLOCKED &"

;constants
LCD   .equ 00h
KEYB  .equ 01h
CW    .equ 03h

;program ends
  .end
