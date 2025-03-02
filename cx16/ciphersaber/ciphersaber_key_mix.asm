.export key_mix
.import cs_state_array
.importzp rounds, key_address

.SEGMENT "ZEROPAGE"
; Most of these names are to conform to the ciphersaber docs.
i: .byte $00
j: .byte $00
roundpos: .byte $00
keypos: .byte $00
swap: .byte $00
first: .byte $00

.SEGMENT "CODE"

key_mix:
    ; Initialize the variables.
    stz i
    stz j
    stz roundpos
    stz keypos

    ; for (int roundpos=0; roundpos < rounds; ++roundpos) {
round_loop:
    lda roundpos
    cmp rounds
    beq end_rounds

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

    ;       j += state[i]
    ldx i
    lda j
    clc
    adc cs_state_array, x

    ;       j += (*key_address)[keypos]
    clc
    ldy keypos
    adc (key_address), y

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
    lda (key_address), y
    cmp #$00
    bne increment_keypos
    stz keypos ; reset keypos
    jmp increment_i
increment_keypos:
    lda keypos
    inc
    sta keypos

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
    jmp round_loop
    ; }
end_rounds:

    rts
