.org $0801 ; start at address 2049 (BASIC's start address.)

    .byte $0c, $08                  ; What are these?
    .byte $0a, $00                  ; line number 10
    .byte $9e                       ; SYS
    .byte $32, $30, $36, $31        ; 2061
    .byte $00, $00, $00             ; End of Program

    ldx #$00
loop:
    lda helloworld,x
    beq done
    jsr $ffd2
    inx
    jmp loop

helloworld:   .literal "HELLO WORLD!", 0

done:
    rts
