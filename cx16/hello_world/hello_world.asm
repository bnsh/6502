start_of_basic = $0801
basic_sys      = $9e
;    .word start_of_basic ; load address
    .word last_line
    .word 10 ; line number
    .byte basic_sys
    .byte $30 + <(main/10000)
    .byte $30 + <((main .mod 10000)/1000)
    .byte $30 + <((main .mod 1000)/100)
    .byte $30 + <((main .mod 100)/10)
    .byte $30 + <(main .mod 10)
    .byte 0
last_line:
    .word 0

main:
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
