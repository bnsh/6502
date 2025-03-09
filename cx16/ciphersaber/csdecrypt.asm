.import key_setup, cipher, cipher_reader_funcaddr, cipher_writer_funcaddr
.import open_infile, close_infile, infile_reader
.import open_outfile, close_outfile, outfile_writer
.importzp key_address, iv_address, rounds

.include "kernal.inc"
.include "sensible_unsigned_compares.inc"

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

ROUNDS=1
    lda #<ROUNDS
    sta rounds
    lda #>ROUNDS
    sta rounds+1

    lda #infname_end-infname-1
    ldx #<infname
    ldy #>infname
    jsr open_infile

    lda #outfname_end-outfname-1
    ldx #<outfname
    ldy #>outfname
    jsr open_outfile


;; This is initialization for the cipher
    lda #<infile_reader
    sta cipher_reader_funcaddr
    lda #>infile_reader
    sta cipher_reader_funcaddr+1

    lda #<outfile_writer
    sta cipher_writer_funcaddr
    lda #>outfile_writer
    sta cipher_writer_funcaddr+1

    jsr copy_iv
    jsr key_setup
    jsr cipher

    jsr close_infile
    jsr close_outfile
    jsr CLRCHN

    rts

copy_iv:
    lda #<infile_reader
    sta copy_func_addr
    lda #>infile_reader
    sta copy_func_addr+1

    stz copy_iv_idx
copy_iv_while:
    lda copy_iv_idx
    cmp #10
    bge copy_iv_done
    jsr copy_func

    ldx copy_iv_idx
    sta iv, x
    inx
    stx copy_iv_idx
    jmp copy_iv_while
copy_iv_done:
    rts
copy_iv_idx:
    .byte $00

copy_func:
    .byte $20 ; jsr
copy_func_addr:
    .addr $0000
    rts

key:
    .literal "ThomasJefferson"
    .byte $00

iv:
; This should _not_ be hardcoded like this. It should
; be initialized to a random value 
    .byte $02, $00, $05, $07, $0b
    .byte $0d, $11, $13, $17, $1d

infname:
    .asciiz "cknight.cs1,s,r"
infname_end:

outfname:
    .asciiz "cknight.gif,s,w"
outfname_end:
