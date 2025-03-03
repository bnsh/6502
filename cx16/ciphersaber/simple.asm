.org $0801 ; start at address 2049 (basic's start address.)

; https://github.com/X16Community/x16-docs/blob/master/X16%20Reference%20-%2005%20-%20KERNAL.md
CHKIN = $FFC6
CHKOUT = $FFC9
CHRIN  = $FFCF
CHROUT = $FFD2
CLOSE = $FFC3
OPEN = $FFC0
READST = $FFB7
RESTOR = $FF8A
SETLFS = $FFBA
SETNAM = $FFBD

.segment "CODE"
    .byte $0c, $08                  ; what are these?
    .byte $0a, $00                  ; line number 10 ($000a little endian)
    .byte $9e                       ; sys
    .byte $32, $30, $36, $31        ; 2061
    .byte $00, $00, $00             ; end of program

; Copy cknight.cs1 to cknight.cpy
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
    jsr READST
    and #$40
    cmp #$40
    beq done
    jsr CHRIN
    jsr CHROUT
    jmp loop

done:
    jsr closeinfile
    jsr closeoutfile
    rts

openinfile:
;; I _think_ this is doing the equivalent in BASIC of `open 3, 8, 3, "cknight.cs1,s,r"`
    lda #infname_end-infname-1
    ldx #<infname
    ldy #>infname
    jsr SETNAM
    lda #3                          ; open 3, 8, 3, 
    ldx #8
    ldy #3
    jsr SETLFS
    jsr OPEN
    ldx #3
    jsr CHKIN

closeinfile:
;; I _think_ this is doing the equivalent in BASIC of `close 3`
    lda #3
    jsr CLOSE
    rts

infname:
    .asciiz "simple.cs1,s,r"
infname_end:

openoutfile:
;; I _think_ this is doing the equivalent in BASIC of `open 4, 8, 4, "cknight.cpy,s,w"`
    lda #outfname_end-outfname-1
    ldx #<outfname
    ldy #>outfname
    jsr SETNAM
    lda #4                          ; open 4, 8, 4, 
    ldx #8
    ldy #4
    jsr SETLFS
    jsr OPEN
    ldx #4
    jsr CHKOUT
    rts

closeoutfile:
;; I _think_ this is doing the equivalent in BASIC of `close 4`
    lda #4
    jsr CLOSE
    rts

outfname:
    .asciiz "simple.cpy,s,w"
outfname_end:
