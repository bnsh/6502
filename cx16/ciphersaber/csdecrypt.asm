.org $0801 ; start at address 2049 (basic's start address.)
.import key_setup, cipher, cipher_reader_funcaddr, cipher_writer_funcaddr
.importzp cleartext_address, ciphertext_address, key_address, iv_address, rounds

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

    lda #<key
    sta key_address
    lda #>key
    sta key_address+1

    lda #<iv
    sta iv_address
    lda #>iv
    sta iv_address+1

    lda #21
    sta rounds

    jsr open_infile
    jsr open_outfile

    jsr key_setup


;; This is initialization for the cipher
    lda #<reader
    sta cipher_reader_funcaddr
    lda #>reader
    sta cipher_reader_funcaddr+1

    lda #<writer
    sta cipher_writer_funcaddr
    lda #>writer
    sta cipher_writer_funcaddr+1

    jsr cipher

    jsr close_infile
    jsr close_outfile
    jsr RESTOR

    rts

open_infile:
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

    rts

reader:
    ldx #$ff
    jsr READST
    and #$40
    beq done
    jsr CHRIN
    ldx #00
done:
    rts

close_infile:
    lda #3
    jsr CLOSE
    rts

infname:
    .asciiz "cknight.cs1,s,r"
infname_end:

open_outfile:
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

writer:
    jsr CHROUT
    rts

close_outfile:
    lda #4
    jsr CLOSE
    rts

outfname:
    .asciiz "cknight.gif,s,w"
outfname_end:

key:
    .literal "ThomasJefferson"
    .byte $00

iv:
; This should _not_ be hardcoded like this. It should
; be initialized to a random value 
    .byte $02, $00, $05, $07, $0b
    .byte $0d, $11, $13, $17, $1d
