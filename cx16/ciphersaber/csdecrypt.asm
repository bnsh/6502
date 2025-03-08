.import key_setup, cipher, cipher_reader_funcaddr, cipher_writer_funcaddr
.importzp cleartext_address, ciphertext_address, key_address, iv_address, rounds

.include "kernal.inc"

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
    jsr CLRCHN

    rts

open_infile:
    lda #infname_end-infname-1
    ldx #<infname
    ldy #>infname
    jsr SETNAM
    lda #5                          ; open 5, 8, 5, 
    ldx #8
    ldy #5
    jsr SETLFS
    jsr OPEN

    stz ineof
    stz inpos
    stz insz

    rts

reader:
; OK, let's do this by buffering 128 bytes at a time.
; So, what's the plan?
; First, see if there's data in the inbuf.
; Let's see how I'd do this in C first.
; let's think of it from the caller's point of view first.
; char byte;
; while (reader(&byte) == 0) {
;   // Go do whatever with byte.
; }
;
; char accumulator;
                                    ; int reader() {
    ldy #$00                        ;     int y = 0x00; // Tho, eventually we'll have to return it as _x_
    ldx inpos
    cpx insz
    
;     if (inpos >= insz) {
;         if (ineof)) x = 0xff; // We've exhausted the inbuf, _and_ we already reached ineof.
;         else {
;             replenish_inbuf();
;             // Because of the nature of how the cx16/c64 handle ineof, if we've replenished the inbuf
;             // we're _guaranteed_ to have at least one byte in the inbuf. (Otherwise, we'd already
;             // have been at ineof).
;             accumulator = inbuf[insz];
;             insz++;
;         }
;     }
;     else {
;         accumulator = inbuf[insz];
;         insz++;
;     }
; 
;     return x
; }

replenish_inbuf:                    ; void replenish_inbuf() {
    stz insz                        ;     insz = 0;
    stz inpos                       ;     inpos = 0;
replenish_inbuf_loop:               ;     while (1) {
    ldx #5
    jsr CHKIN
    jsr CHRIN
    tay                             ;         y = readbyte()
    jsr READST
    and #$40
    cmp #$40
    bne assign_to_buffer            ;         if ateof() { // READST
    lda #$ff
    sta ineof                       ;             ineof = 1
                                    ;         }
assign_to_buffer:
    tya                             ;         inbuf[insz] = y
    ldx insz
    sta inbuf, x
    inx
    stx insz                        ;         insz++;
    cpx #$80
    bne replenish_inbuf_loop        ;         if (insz >= 128) break;
                                    ;     }
    rts                             ; }

done:
    rts

close_infile:
    lda #5
    jsr CLOSE
    rts

ineof:
    .byte $00

insz:
    .byte $00

inpos:
    .byte $00

inbuf:
    .res 129

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

    stz outpos
    rts

writer:
    tay
    ldx #4
    jsr CHKOUT
    tya
    jsr CHROUT
    rts

close_outfile:
; We need to flush the buffer if it's there now.
    lda #4
    jsr CLOSE
    rts

outpos:
    .byte $00

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
