.include "kernal.inc"
.include "sensible_unsigned_compares.inc"
.include "cx16_registers.inc"
.include "common.inc"

.segment "CODE"

    .byte $0c, $08                  ; what are these?
    .byte $0a, $00                  ; line number 10 ($000a little endian)
    .byte $9e                       ; sys
    .byte $32, $30, $36, $31        ; 2061
    .byte $00, $00, $00             ; end of program

main:
    lda #$80
    sta r0
    lsr r0
    lsr r0
    lsr r0
    rts
