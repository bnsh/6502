
.import debug_registers

.include "kernal.inc"
.include "sensible_unsigned_compares.inc"
.include "writeutils.inc"

.macro writestr_macro_nl addr
    writestr_macro addr
    lda #$0d
    jsr CHROUT
.endmacro


.segment "CODE"
    .byte $0c, $08                  ; what are these?
    .byte $0a, $00                  ; line number 10 ($000a little endian)
    .byte $9e                       ; sys
    .byte $32, $30, $36, $31        ; 2061
    .byte $00, $00, $00             ; end of program

    rts
