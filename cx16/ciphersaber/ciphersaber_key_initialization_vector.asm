.export key_initialization_vector, keyiv_array, keyiv_length
.importzp key_address, iv_address

.segment "CODE"

key_initialization_vector:
    ; We have to copy the key + iv to keyiv_array
    ldy #0
    ldx #0 ; This will be the length of keyiv_array
keytop:
    lda (key_address), y
    cmp #$00
    beq copy_iv
    sta keyiv_array, x
    inx
    iny
    jmp keytop
copy_iv:
    ldy #0
ivtop:
    cpy #10
    beq done
    lda (iv_address), y
    sta keyiv_array, x
    inx
    iny
    jmp ivtop

done:
    stx keyiv_length
    rts

keyiv_array:
    .res 256

keyiv_length:
    .byte $00
