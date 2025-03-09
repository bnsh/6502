.export open_infile, close_infile, infile_reader
.export open_outfile, close_outfile, outfile_writer

.include "kernal.inc"

.segment "CODE"
open_infile:
; This function _expects_
; accumulator to contain the _length_ of the filename we're loading (and it should be something like "fname,s,r")
; x to contain the _low_ (#<) byte of the filename and
; y to contain the _high_ (#>) byte of the filename
    jsr SETNAM
    lda #5                          ; open 5, 8, 5, 
    ldx #8
    ldy #5
    jsr SETLFS
    jsr OPEN

    stz infile_reader_eof

    rts

infile_reader:
    lda infile_reader_eof               ;     if (infile_reader_eof == 0) {
    cmp #$00
    bne infile_reader_eof_ne0
    ldx #$05                            ;         read_chrin(&accumulator)
    jsr CHKIN
    jsr CHRIN
    tay                                 ;         y = accumulator
    stz infile_reader_eof               ;         infile_reader_eof = 0
    jsr READST                          ;         if (readst() & 0x40) {
    and #$40
    cmp #$40
    bne infile_readst_ne0x40
    ldx #$ff                            ;             infile_reader_eof = 0xff
    stx infile_reader_eof
                                        ;         }
infile_readst_ne0x40:
    tya                                 ;         accumulator = y
    ldx #$00                            ;         return 0;
    jmp infile_done
                                        ;     }
infile_reader_eof_ne0:                  ;     else {
    lda #$00                            ;         // There's no reason to zero the accumulator. But, why not.
    ldx #$ff                            ;         return 0xff;
                                        ;     }
                                        ; }
infile_done:
    rts

infile_reader_eof:
    .byte $00

close_infile:
    lda #5
    jsr CLOSE
    rts

open_outfile:
; This function _expects_
; accumulator to contain the _length_ of the filename we're loading (and it should be something like "fname,s,w")
; x to contain the _low_ (#<) byte of the filename and
; y to contain the _high_ (#>) byte of the filename
    jsr SETNAM
    lda #4                          ; open 4, 8, 4, 
    ldx #8
    ldy #4
    jsr SETLFS
    jsr OPEN

    stz outpos
    rts

outfile_writer:
    tay
    ldx #4
    jsr CHKOUT
    tya
    jsr CHROUT
    rts

close_outfile:
    lda #4
    jsr CLOSE
    rts

outpos:
    .byte $00
