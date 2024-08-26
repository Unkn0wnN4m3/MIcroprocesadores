; Activity 1 - code
; Participants:
; - Aaron Cruz San Juan
; - Julio Cesar Lopez Rodriguez
; - Martagón Carrillo Uriel Isaí

; INICIO PARTE 1

    .org 00 ; 'cause we need to start at the beginning of the memory

    ; charging the number we want to add
    ld b, 14h
    ld c, 63h

    ld d, c

; FIN PARTE 1

; ----------------------------------------------------------------------

; INICIO PARTE 2

    ; ------ conversion del el registro B a BCD ----------------

    ; Creando una copia en el registro a
    ld a, b

    ; convertir la copia (a) a bcd para guardar los bits mas significativos
    ; en el registro b
    ld h, a
    dda
    and f0h
    ld b, h

    ld l, a
    dda
    and 0fh
    ld c, l


    ; ------ conversion del el registro C a BCD ----------------

    ; Creando una copia en el registro a
    ld a, d

    ; convertir la copia (c) a bcd para guardar los bits mas significativos
    ; en el registro b
    ld h, a
    dda
    and f0h
    ld d, h

    ld l, a
    dda
    and 0fh
    ld e, l

; FIN PARTE 2

;-----------------------------------------------------------------------------------





