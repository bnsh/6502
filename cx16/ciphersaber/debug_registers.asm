.export debug_registers

.include "writeutils.inc"

.segment "ZEROPAGE"
i: .byte $00
j: .byte $00

.segment "CODE"
debug_registers:
; This should do something like printf("A=0x%08x X=0x%08x Y=0x%08x PS=0x%08x");
; and _preserve the A, X, Y registers
    php
    pha
    phx
    phy

    php                                 ; These pushes are so that we can have them freely pulled for debugging.
    phy
    phx
    pha

    writestr_macro a_s
    pla                                 ; Pull the accumulator
    sta writehexbyte_arg
    jsr writehexbyte_func

    writestr_macro x_s
    pla                                 ; Pull the x register
    sta writehexbyte_arg
    jsr writehexbyte_func

    writestr_macro y_s
    pla                                 ; Pull the y register
    sta writehexbyte_arg
    jsr writehexbyte_func

    writestr_macro ps_s
    pla                                 ; Pull the ps register
    jsr debug_processor_status

    lda #13
    jsr $ffd2

    ply
    plx
    pla
    plp
    rts

debug_processor_status:
; NV-BDIZC
; We expect this to be on the accumulator.
    tay                                 ; Stash the accumulator in the y register
debug_processor_status_n:
    tya
    and #$80
    ldx #'n'
    jsr debug_single_flag

    tya
    and #$40
    ldx #'v'
    jsr debug_single_flag

    tya
    and #$20
    ldx #'x'
    jsr debug_single_flag

    tya
    and #$10
    ldx #'b'
    jsr debug_single_flag

    tya
    and #$08
    ldx #'d'
    jsr debug_single_flag

    tya
    and #$04
    ldx #'i'
    jsr debug_single_flag

    tya
    and #$02
    ldx #'z'
    jsr debug_single_flag

    tya
    and #$01
    ldx #'c'
    jsr debug_single_flag
    rts

debug_single_flag:
    cmp #$00
    bne dsf_isset
    lda #'-'
    jsr $ffd2
    bra done
dsf_isset:
    txa
    jsr $ffd2
done:
    rts


a_s:
    .asciiz "a="

x_s: 
    .asciiz " x="

y_s: 
    .asciiz " y="

ps_s:
    .asciiz " ps="

