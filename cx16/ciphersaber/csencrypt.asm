.import key_setup, cipher, cipher_reader_funcaddr, cipher_writer_funcaddr, randomstream
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

    jsr delete_first                ; This is _super annoying_. I wish it could just overwrite.

    lda #<key
    sta key_address
    lda #>key
    sta key_address+1

    lda #<iv
    sta iv_address
    lda #>iv
    sta iv_address+1

ROUNDS=256
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

    jsr seed_iv
; We need to copy the seed to the output.
    jsr copy_iv_to_output
    jsr key_setup
    jsr cipher

    jsr close_infile
    jsr close_outfile
    jsr CLRCHN

    rts

seed_iv:
    ldx #0
seed_loop:
    jsr randomstream
    sta iv, x

    inx
    cpx #10
    blt seed_loop
    rts

copy_iv_to_output:
    lda #<outfile_writer
    sta copy_func_addr
    lda #>outfile_writer
    sta copy_func_addr+1

    stz copy_iv_idx
copy_iv_while:
    ldx copy_iv_idx
    cpx #10
    bge copy_iv_done

    lda iv, x
    jsr copy_func

    ldx copy_iv_idx
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

delete_first:
    lda #deletefn_end-deletefn-1
    ldx #<deletefn
    ldy #>deletefn
    jsr SETNAM
    lda #1
    ldx #8
    ldy #15
    jsr SETLFS
    jsr OPEN
    jsr CLOSE
    rts

key:
    .literal "CommanderX16!"
    .byte $00

iv:
; This should _not_ be hardcoded like this. It should
; be initialized to a random value 
    .byte $02, $03, $05, $07, $0b
    .byte $0d, $11, $13, $17, $1d

infname:
    .asciiz "cknightcx16.gif,s,r"
infname_end:

outfname:
    .asciiz "cknightcx16.cs256,s,w"
outfname_end:

deletefn:
    .asciiz "s:cknightcx16.cs256"
deletefn_end:
