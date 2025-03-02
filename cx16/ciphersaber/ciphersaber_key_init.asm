.export key_initialize, cs_state_array

.SEGMENT "CODE"

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

marker:
    .byte $ca, $fe, $ba, $be, $ca, $fe, $ba, $be
cs_state_array: 
    .res 256, $00
