
.import debug_registers

.include "kernal.inc"
.include "writeutils.inc"

.macro writestr_macro_nl addr
    writestr_macro addr
    lda #$0d
    jsr CHROUT
.endmacro


.segment "CODE"
    .byte $0c, $08                  ; what are these?
    .byte $0a, $00                  ; line number 10 ($000a little endian)
    .byte $9e                       ; sys
    .byte $32, $30, $36, $31        ; 2061
    .byte $00, $00, $00             ; end of program



test0:
    lda #$03
    cmp #$04
    beq beq3cmp4_success
    writestr_macro_nl beq3cmp4_f
    jmp test1
beq3cmp4_success:
    writestr_macro_nl beq3cmp4_s
    jmp test1
beq3cmp4_s:
    .asciiz "acc = 3, cmp 4, beq succeeds"
beq3cmp4_f:
    .asciiz "acc = 3, cmp 4, beq fails"


test1:
    lda #$04
    cmp #$04
    beq beq4cmp4_success
    writestr_macro_nl beq4cmp4_f
    jmp test2
beq4cmp4_success:
    writestr_macro_nl beq4cmp4_s
    jmp test2
beq4cmp4_s:
    .asciiz "acc = 4, cmp 4, beq succeeds"
beq4cmp4_f:
    .asciiz "acc = 4, cmp 4, beq fails"


test2:
    lda #$05
    cmp #$04
    beq beq5cmp4_success
    writestr_macro_nl beq5cmp4_f
    jmp test3
beq5cmp4_success:
    writestr_macro_nl beq5cmp4_s
    jmp test3
beq5cmp4_s:
    .asciiz "acc = 5, cmp 4, beq succeeds"
beq5cmp4_f:
    .asciiz "acc = 5, cmp 4, beq fails"


test3:
    lda #$03
    cmp #$04
    bne bne3cmp4_success
    writestr_macro_nl bne3cmp4_f
    jmp test4
bne3cmp4_success:
    writestr_macro_nl bne3cmp4_s
    jmp test4
bne3cmp4_s:
    .asciiz "acc = 3, cmp 4, bne succeeds"
bne3cmp4_f:
    .asciiz "acc = 3, cmp 4, bne fails"


test4:
    lda #$04
    cmp #$04
    bne bne4cmp4_success
    writestr_macro_nl bne4cmp4_f
    jmp test5
bne4cmp4_success:
    writestr_macro_nl bne4cmp4_s
    jmp test5
bne4cmp4_s:
    .asciiz "acc = 4, cmp 4, bne succeeds"
bne4cmp4_f:
    .asciiz "acc = 4, cmp 4, bne fails"


test5:
    lda #$05
    cmp #$04
    bne bne5cmp4_success
    writestr_macro_nl bne5cmp4_f
    jmp test6
bne5cmp4_success:
    writestr_macro_nl bne5cmp4_s
    jmp test6
bne5cmp4_s:
    .asciiz "acc = 5, cmp 4, bne succeeds"
bne5cmp4_f:
    .asciiz "acc = 5, cmp 4, bne fails"


test6:
    lda #$03
    cmp #$04
    bpl bpl3cmp4_success
    writestr_macro_nl bpl3cmp4_f
    jmp test7
bpl3cmp4_success:
    writestr_macro_nl bpl3cmp4_s
    jmp test7
bpl3cmp4_s:
    .asciiz "acc = 3, cmp 4, bpl succeeds"
bpl3cmp4_f:
    .asciiz "acc = 3, cmp 4, bpl fails"


test7:
    lda #$04
    cmp #$04
    bpl bpl4cmp4_success
    writestr_macro_nl bpl4cmp4_f
    jmp test8
bpl4cmp4_success:
    writestr_macro_nl bpl4cmp4_s
    jmp test8
bpl4cmp4_s:
    .asciiz "acc = 4, cmp 4, bpl succeeds"
bpl4cmp4_f:
    .asciiz "acc = 4, cmp 4, bpl fails"


test8:
    lda #$05
    cmp #$04
    bpl bpl5cmp4_success
    writestr_macro_nl bpl5cmp4_f
    jmp test9
bpl5cmp4_success:
    writestr_macro_nl bpl5cmp4_s
    jmp test9
bpl5cmp4_s:
    .asciiz "acc = 5, cmp 4, bpl succeeds"
bpl5cmp4_f:
    .asciiz "acc = 5, cmp 4, bpl fails"


test9:
    lda #$03
    cmp #$04
    bmi bmi3cmp4_success
    writestr_macro_nl bmi3cmp4_f
    jmp test10
bmi3cmp4_success:
    writestr_macro_nl bmi3cmp4_s
    jmp test10
bmi3cmp4_s:
    .asciiz "acc = 3, cmp 4, bmi succeeds"
bmi3cmp4_f:
    .asciiz "acc = 3, cmp 4, bmi fails"


test10:
    lda #$04
    cmp #$04
    bmi bmi4cmp4_success
    writestr_macro_nl bmi4cmp4_f
    jmp test11
bmi4cmp4_success:
    writestr_macro_nl bmi4cmp4_s
    jmp test11
bmi4cmp4_s:
    .asciiz "acc = 4, cmp 4, bmi succeeds"
bmi4cmp4_f:
    .asciiz "acc = 4, cmp 4, bmi fails"


test11:
    lda #$05
    cmp #$04
    bmi bmi5cmp4_success
    writestr_macro_nl bmi5cmp4_f
    jmp test12
bmi5cmp4_success:
    writestr_macro_nl bmi5cmp4_s
    jmp test12
bmi5cmp4_s:
    .asciiz "acc = 5, cmp 4, bmi succeeds"
bmi5cmp4_f:
    .asciiz "acc = 5, cmp 4, bmi fails"

test12:
    rts
