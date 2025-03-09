.import open_infile, close_infile, infile_reader
.import open_outfile, close_outfile, outfile_writer

.include "kernal.inc"

.segment "CODE"

    .byte $0c, $08                  ; what are these?
    .byte $0a, $00                  ; line number 10 ($000a little endian)
    .byte $9e                       ; sys
    .byte $32, $30, $36, $31        ; 2061
    .byte $00, $00, $00             ; end of program

    lda #infname_end-infname-1
    ldx #<infname
    ldy #>infname
    jsr open_infile

    lda #outfname_end-outfname-1
    ldx #<outfname
    ldy #>outfname
    jsr open_outfile

    jsr straight_copy

    jsr close_infile
    jsr close_outfile
    jsr CLRCHN

    rts

straight_copy:
    jsr infile_reader               ; while (infile_reader(&acc) == 0) {
    cpx #$00
    bne straight_copy_end_while
    jsr outfile_writer              ;     outfile_writer(acc)
    jmp straight_copy
                                    ; }
straight_copy_end_while:
    rts

infname:
    .asciiz "cknight.cs1,s,r"
infname_end:

outfname:
    .asciiz "cknight.cpy,s,w"
outfname_end:
