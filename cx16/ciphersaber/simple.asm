.import debug_registers
; https://github.com/X16Community/x16-docs/blob/master/X16%20Reference%20-%2005%20-%20KERNAL.md
CHKIN = $FFC6
CHKOUT = $FFC9
CHRIN  = $FFCF
CHROUT = $FFD2
CLOSE = $FFC3
CLRCHN = $FFCC
OPEN = $FFC0
READST = $FFB7
RESTOR = $FF8A
SETLFS = $FFBA
SETNAM = $FFBD

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
    jsr debug_registers
    jsr openinfile
    jsr openoutfile
loop:
;; I _think_ this is doing the equivalent in BASIC of
;; ```
;; top:
;;     r$ = get# 3
;;     if r$ = "" then goto done
;; goto top
;; done:
;; close 3
;; close 4
;; ```
    ldx #3
    jsr CHKIN
    jsr CHRIN
    sta inchar
    jsr READST
    sta status
    ldx #4
    jsr CHKOUT
    lda inchar
    jsr CHROUT
    lda status
    and #$40
    cmp #$40
    bne loop

    jsr closeinfile
    jsr closeoutfile
    jsr CLRCHN
    jsr debug_registers
    rts

openinfile:
;; I _think_ this is doing the equivalent in BASIC of `open 3, 8, 3, "simple.cs1,s,r"`
    lda #infname_end-infname
    ldx #<infname
    ldy #>infname
    jsr SETNAM
    lda #3                          ; open 3, 8, 3, 
    ldx #8
    ldy #3
    jsr SETLFS
    jsr OPEN
    rts

closeinfile:
;; I _think_ this is doing the equivalent in BASIC of `close 3`
    lda #3
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
