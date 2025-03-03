; How will we do this?
; Maybe we'll make the interface
; require two routines.
; 1. which will return in a the byte if it's valid, and x will be 0 if the byte is
;    valid, and non-zero otherwise.
; 2. another which will just accept a value in the accumulator.

.import cs_state_array
.export cipher, cipher_reader_funcaddr, cipher_writer_funcaddr

.segment "ZEROPAGE"
i:
    .byte $00
j: 
    .byte $00

.segment "CODE"
cipher:
    lda cipher_reader_funcaddr
    sta reader_routine+1
    lda cipher_reader_funcaddr+1
    sta reader_routine+2
    lda cipher_writer_funcaddr
    sta writer_routine+1
    lda cipher_writer_funcaddr+1
    sta writer_routine+2
    stz i
    stz j

cipher_top:
    inc i
    lda j
    ldx i
    clc
    adc cs_state_array, x
    sta j

    ; swap state[i] and state[j]
    ; 1. swap = state[i]
    ldx i
    lda cs_state_array, x
    sta swap

    ; 2. state[i] = state[j]
    ldx j
    lda cs_state_array, x
    ldx i
    sta cs_state_array, x

    ; 3. state[j] = swap
    lda swap
    ldx j
    sta cs_state_array, x

    jsr reader_routine
    cpx #$00
    bne done

    sta data
    ldx i
    lda cs_state_array, x
    ldx j
    clc
    adc cs_state_array, x
    tax
    lda data
    adc cs_state_array, x
    jsr writer_routine
    jmp cipher_top

done:
    rts

cipher_reader_funcaddr:
    .addr $0000
reader_routine:
    jmp $0000
    rts

cipher_writer_funcaddr:
    .addr $0000
writer_routine:
    jmp $0000
    rts

swap:
    .byte $00

data:
    .byte $00
