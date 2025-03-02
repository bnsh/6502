.org $0801 ; start at address 2049 (basic's start address.)
.import key_setup
.importzp cleartext_address, ciphertext_address, key_address

    .byte $0c, $08                  ; what are these?
    .byte $0a, $00                  ; line number 10
    .byte $9e                       ; sys
    .byte $32, $30, $36, $31        ; 2061
    .byte $00, $00, $00             ; end of program

    lda #<key
    sta key_address
    lda #>key
    sta key_address+1

    jsr key_setup
    rts

key:
    .asciiz "binesh"
