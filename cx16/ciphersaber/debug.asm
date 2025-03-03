.export debug
.import cs_state_array
.importzp cleartext_address, ciphertext_address, key_address, rounds
.importzp i, j, roundpos, keypos

.segment "ZEROPAGE"
writestr_arg:
    .addr $0000
writehexbyte_arg:
    .byte $00

.segment "CODE"

writestr:
    ldy #$0
writestr_top:
    lda (writestr_arg), y
    cmp #$00
    beq writestr_done
    jsr $ffd2
    iny
    jmp writestr_top
writestr_done:
    rts

.macro writehex_nibble
.scope
; Takes argument from accumulator
    cmp #$0a
    bpl alpha ; bpl is zero or positive.
    ; At this stage, our accumulator is between 0 and 9 inclusive and we want
    ; 0 to map to '0' and 9 to map to '9'. D-uh.
    clc
    adc #48                 ; 48 is '0'
    jmp writehexbyte_done
alpha:
    ; At this stage, our accumulator is between 10 and 15 inclusive and we want
    ; 10 to map to 'A' and 15 to map to 'F'
    clc
    adc #55                 ; 65 is 'a' and we use 55 as (65-10)+10 => 'A', (65-10)+15 => 'F'
writehexbyte_done:
    jsr $ffd2
.endscope
.endmacro

writehexbyte_func:
    tay

    lda #'0'
    jsr $ffd2
    lda #'x'
    jsr $ffd2

    lda writehexbyte_arg
    and #$f0
    lsr
    lsr
    lsr
    lsr
    and #$0f
    writehex_nibble
    tya
    and #$0f
    writehex_nibble
    rts

.macro  writestr_macro   addr
    lda #<addr
    sta writestr_arg
    lda #>addr
    sta writestr_arg+1
    jsr writestr
.endmacro

.macro writechar val
    lda val
    jsr $ffd2
.endmacro

.macro writehexbyte val
    lda val
    sta writehexbyte_arg
    jsr writehexbyte_func
.endmacro

debug:
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
