.export key_setup
.export cleartext_address, ciphertext_address, key_address

key_setup:
    jsr key_initialize
    jsr replicate_key
    jsr key_mix
    rts

key_initialize:
    ; initialize the entire state array so that the first state element
    ; is zero, the second is one, the third is two, and so on.
    ldx #$00
key_initialize_loop:
    txa
    sta cs_state_array, x
    inx
    cpx #$00
    bne key_initialize_loop
    rts

key_mix:
    ldx #$0                     ; use x as "i" in the ciphersaber parlance.
    ldy #$0                     ; use y as "j" in the ciphersaber parlance.

key_mix_loop:
    tya                         ; add to the variable "j" (y) the ith (xth) element of cs_state_array
    clc                         ; and the nth element of the key where n is equal to i % length(key)
    adc cs_state_array, x       ; but, we've already copied the key to replicated key. The mod
    adc replicated_key, x       ; is unnecessary.
    tay

    lda cs_state_array, x       ; Swap the ith and jth elements of the state array.
    sta key_mix_temporary
    lda cs_state_array, y
    sta cs_state_array, x
    lda key_mix_temporary
    sta cs_state_array, y

    inx

    cpx #$00
    bne key_mix_loop

    rts

key_mix_temporary:
    .byte $00

replicate_key:
    ldx #$0
    ldy #$0

replicate_key_loop:
; Copy the key replicated as many times as possible to fill the 256 byte block.
    lda (key_address), y
    cmp #$0
    bne noreset
    ldy #$0
    lda (key_address), y
noreset:
    sta replicated_key, x
    inx
    iny
replicate_key_loop_bottom:
    cpx #$0
    bne replicate_key_loop
    rts

replicated_key:
    .res 256, $ff

cs_state_array: 
    .res 256, $00

.zeropage
key_address:
    .addr $0000

cleartext_address:
    .addr $0000

ciphertext_address:
    .addr $0000
