.import debug_registers

.include "kernal.inc"

.segment "ZEROPAGE"
inchar: .byte $00
status: .byte $00

.segment "CODE"
    .byte $0c, $08                  ; what are these?
    .byte $0a, $00                  ; line number 10 ($000a little endian)
    .byte $9e                       ; sys
    .byte $32, $30, $36, $31        ; 2061
    .byte $00, $00, $00             ; end of program

; Copy simple.cs1 to simple.cpy
    jsr openinfile
    jsr openoutfile

    ldx #5
    jsr CHKIN
    jsr CHRIN
    tay

    ldx #4
    jsr CHKOUT
    tya
    jsr CHROUT

    jsr closeoutfile
    jsr closeinfile
    jsr CLRCHN
    rts

openinfile:
;; I _think_ this is doing the equivalent in BASIC of `open 5, 8, 5, "simple.cs1,s,r"`
    lda #infname_end-infname
    ldx #<infname
    ldy #>infname
    jsr SETNAM
    lda #5                          ; open 5, 8, 5, 
    ldx #8
    ldy #5
    jsr SETLFS
    jsr OPEN
    rts

closeinfile:
;; I _think_ this is doing the equivalent in BASIC of `close 5`
    lda #5
    jsr CLOSE
    rts

infname:
    .byte "simple.cs1,s,r"
infname_end:

openoutfile:
;; I _think_ this is doing the equivalent in BASIC of `open 4, 8, 4, "simple.cpy,s,w"`
    lda #outfname_end-outfname
    ldx #<outfname
    ldy #>outfname
    jsr SETNAM
    lda #4                          ; open 4, 8, 4, 
    ldx #8
    ldy #4
    jsr SETLFS
    jsr OPEN
    rts

closeoutfile:
;; I _think_ this is doing the equivalent in BASIC of `close 4`
    lda #4
    jsr CLOSE
    rts

outfname:
    .byte "simple.cpy,s,w"
outfname_end:
