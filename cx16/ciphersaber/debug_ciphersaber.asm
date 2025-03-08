.export debug_ciphersaber
.import cs_state_array
.importzp cleartext_address, ciphertext_address, key_address, rounds
.importzp roundpos, keypos

.include "writeutils.inc"

.segment "ZEROPAGE"
i: .byte $00
j: .byte $00

.segment "CODE"
debug_ciphersaber:
; We want to write 
; printf("roundpos=%02x i=%02x j=%02x keypos=%02x -> ", roundpos, i, _j);
; printf("(%02x + %02x + %02x) -> ", _j, _state[_i], _rc4keyarray[keypos]);
; printf("%02x\n", (_j + _state[_i] + _rc4keyarray[keypos]) % 256);
    writestr_macro roundpos_s
    writehexbyte roundpos

    writestr_macro i_s
    writehexbyte i

    writestr_macro j_s
    writehexbyte j

    writestr_macro keypos_s
    writehexbyte keypos

    writestr_macro arrow

    writechar #'('
    writehexbyte j

    writestr_macro plus_s
    ldx i
    lda cs_state_array, x
    sta writehexbyte_arg
    jsr writehexbyte_func

    writestr_macro plus_s
    ldy keypos
    lda (key_address), y
    sta writehexbyte_arg
    jsr writehexbyte_func

    writechar #')'
    writestr_macro arrow

    lda j
    ldx i
    clc
    adc cs_state_array, x
    ldy keypos
    clc
    adc (key_address), y
    sta writehexbyte_arg
    jsr writehexbyte_func

    writechar #13

    rts

roundpos_s:
    .asciiz "roundpos="

i_s:
    .asciiz " i="

j_s:
    .asciiz " j="

keypos_s:
    .asciiz " keypos="

arrow:
    .asciiz " -> "

plus_s:
    .asciiz " + "
