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
    eor cs_state_array, x

    jsr writer_routine
    jmp cipher_top

done:
    rts

reader_routine:
    .byte $20           ; this is the opcode for jsr
cipher_reader_funcaddr:
;; Effectively we are _constructing_ a jsr {{reader_routine}} that the user will change the address to when
;; they call it.
    .addr $0000
    rts

writer_routine:
    .byte $20           ; this is the opcode for jsr
cipher_writer_funcaddr:
;; Effectively we are _constructing_ a jsr {{writer_routine}} that the user will change the address to when
;; they call it.
    .addr $0000
    rts

swap:
    .byte $00

data:
    .byte $00
