.import key_setup
.importzp key_address, iv_address, rounds

.segment "CODE"

    .byte $0c, $08                  ; what are these?
    .byte $0a, $00                  ; line number 10 ($000a little endian)
    .byte $9e                       ; sys
    .byte $32, $30, $36, $31        ; 2061
    .byte $00, $00, $00             ; end of program

    lda #<key
    sta key_address
    lda #>key
    sta key_address+1

    jsr seed_iv

    lda #<iv
    sta iv_address
    lda #>iv
    sta iv_address+1

ROUNDS=21
    lda #<ROUNDS
    sta rounds
    lda #>ROUNDS
    sta rounds+1

    jsr key_setup
    rts

seed_iv:
    rts

key:
    .byte $62, $69, $6e, $65, $73, $68
    .byte $00

iv:
; This should _not_ be hardcoded like this. It should
; be initialized to a random value 
    .byte $02, $00, $05, $07, $0b
    .byte $0d, $11, $13, $17, $1d

infname:
    .asciiz "cknight.gif,s,r"
infname_end:

outfname:
    .asciiz "cknight.cs1,s,w"
outfname_end:
