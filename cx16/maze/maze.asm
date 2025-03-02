.org $0801 ; start at address 2049 (basic's start address.)

    .byte $0c, $08                  ; what are these?
    .byte $0a, $00                  ; line number 10
    .byte $9e                       ; sys
    .byte $32, $30, $36, $31        ; 2061
    .byte $00, $00, $00             ; end of program

loop:
    jsr bitstream
    clc
    adc #$cd
    jsr $ffd2
    lda $c5
    cmp #'q'
    beq done
    jmp loop

done:
    rts

bitstream:
    lda bitsleft
    cmp #$00
    bne havedata
refill:
    jsr $fecf ; https://github.com/x16community/x16-docs/blob/master/x16%20reference%20-%2005%20-%20kernal.md#function-name-entropy_get
    sta x_n
    jsr lcg
    lsr
    lsr
    lsr
    lsr ; We really only get ~4 bits with this method. (Not rigorously shown!)
    sta current_byte
    lda #$03
    sta bitsleft
havedata:
    dec
    sta bitsleft
    lda current_byte
    tax
    lsr
    sta current_byte
    txa
    and #$01
    rts


bitsleft:
    .byte $00
current_byte:
    .byte $00

; LCG https://en.wikipedia.org/wiki/Linear_congruential_generator
; X_{n+1} = (a X_{n} + c) mod m
; Well, let's make m be 256 since that comes for free
; for all intents and purposes.
; So, we should make a and c be relatively prime to 256.
; Which, I suppose, is every prime other than 2.
; Prime 52, 53 and 54 are 239, 241 and 251 (55 is 257 > 256
; Maybe choose 241 and 251? OTOH, primes of the form 2^n+1
; (3, 5, 17) are more convenient for `a`? Because then we can
; a * 17 = (a << 4) + a
; But. 
; (a * 17 + 251) % 2 = what?
; (a * 17) % 2 + 1
; (a % 2) + 1
; So, perhaps what we have to take is the _high_ bit, not the low bit.

lcg:
; computes (17 x_n + 251) % 256 (the % 256 is implicit by way of
; this being 8 bits.)
; returns x_{n+1} in the accumulator.
    lda x_n
    jsr mul17   ; accumulator should now have x_n * 17
    clc
    adc #251
    sta x_n

    rts

x_n:
    .byte $00

mul17:
; expects the value to multiply by 17 in a
; results go back into a.
; a <= a * 16 + a
    sta mul17_scratch
    clc
    asl     ; mul 2
    asl     ; mul 2 -> mul 4
    asl     ; mul 2 -> mul 8
    asl     ; mul 2 -> mul 16
    clc
    adc mul17_scratch

    rts

mul17_scratch:
    .byte $00


