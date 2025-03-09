.export key_mix
.exportzp roundpos, keypos
.import cs_state_array, keyiv_array, keyiv_length
.importzp rounds

.include "sensible_unsigned_compares.inc"

.segment "ZEROPAGE"
; Most of these names are to conform to the ciphersaber docs.
i: .byte $00
j: .byte $00
roundpos: .word $0000
keypos: .byte $00
swap: .byte $00
first: .byte $00

.segment "CODE"

key_mix:
    ; Initialize the variables.
    stz j
    stz roundpos
    stz roundpos+1

    ; for (int roundpos=0; roundpos < rounds; ++roundpos) {
round_loop:
    stz i
    stz keypos              ; keypos is i % keylen
    lda roundpos+1
    cmp rounds+1
    bgt end_rounds
    lda roundpos
    cmp rounds
    bge end_rounds

round_body:
    ;   for (int i=0; i < 256; ++i) {
    ; 256 is a problem for 8 bit computers. So. We'll just skip the
    ; check when i = 0
    jmp i_loop_body

i_loop:
    lda i
    cmp #0
    beq end_i
i_loop_body:

    ; jsr debug_ciphersaber

    ;       j += state[i]
    ldx i
    lda j
    clc
    adc cs_state_array, x

    ;       j += keyiv_array[keypos]
    clc
    ldy keypos
    adc keyiv_array, y
    sta j

    ; swap cs_state_array[i] and cs_state_array[j]
    ; 1. swap = cs_state_array[i]
    ldx i
    lda cs_state_array, x
    sta swap

    ; 2. cs_state_array[i] = cs_state_array[j]
    ldx j
    lda cs_state_array, x
    ldx i
    sta cs_state_array, x

    ; 3. cs_state_array[j] = swap
    lda swap
    ldx j
    sta cs_state_array, x

    ldy keypos
    iny
    cpy keyiv_length
    bne sty_keypos
    ldy #0
sty_keypos:
    lda keyiv_array, y
    sty keypos

increment_i:
    lda i
    inc
    sta i
    jmp i_loop
    ;   }
end_i:

    lda roundpos
    inc
    sta roundpos
    cmp #$00
    bne round_pos_not_rolled_over
    inc roundpos+1
round_pos_not_rolled_over:
    jmp round_loop
    ; }
end_rounds:

    rts
