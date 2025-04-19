.include "kernal.inc"
.include "cx16_registers.inc"
.include "sensible_unsigned_compares.inc"
.include "common.inc"

.segment "CODE"

; BASIC STUB. Laboriously simply copied,
; after having manually typed in the basic
; code I wanted.
; 10 S=TI
.byte $0a, $08, $0a, $00, $53, $b2, $54, $49, $00
; 20 SYS 2186
.byte $15, $08, $14, $00, $9e, $20, $32, $31, $38, $36, $00
; 30 E=TI
.byte $1e, $08, $1e, $00, $45, $b2, $54, $49, $00
; 40 I=PEEK(6)+256*PEEK(7) ; REM r14 (2*(r+1)) = 30, 31
.byte $32, $08, $28, $00, $49, $b2, $c2, $28, $33, $30, $29, $aa, $32, $35, $36, $ac, $c2, $28, $33, $31, $29, $00
; 50 P=PEEK(8)+256*peek(9); REM r15 (2*(r+1)) = 32, 33
.byte $46, $08, $32, $00, $50, $b2, $c2, $28, $33, $32, $29, $aa, $32, $35, $36, $ac, $c2, $28, $33, $33, $29, $00
; 60 PRINT STR$(E-S)+" JIFFIES "+STR$(I)+" PRIMES LAST PRIME WAS " + STR$(P)
.byte $84, $08, $3c, $00, $99, $20, $c4, $28, $45, $ab, $53, $29, $aa, $22, $a0, $4a, $49, $46, $46, $49, $45, $53, $a0, $22, $aa, $c4, $28, $49, $29, $aa, $22, $20, $50, $52, $49, $4d, $45, $53, $a0, $4c, $41, $53, $54, $20, $50, $52, $49, $4d, $45, $20, $57, $41, $53, $20, $22, $20, $aa, $c4, $28, $50, $29, $00

.byte $00, $00

sieve = $6000
sieve_end = sieve+$2000 ; finds 6542 primes (65521) in 46 jiffies https://www.wolframalpha.com/input?i=What+is+the+6542nd+prime+number%3F
; sieve_end = sieve+$1000 ; finds 3512 primes (32749) in 41 jiffies https://www.wolframalpha.com/input?i=What+is+the+3512nd+prime+number%3F
; sieve_end = sieve+$0980 ; finds 2205 primes (19447) in 41 jiffies https://www.wolframalpha.com/input?i=What+is+the+2205th+prime+number%3F
; sieve_end = sieve+$0960 ; finds 2176 primes (19813) in 39 jiffies https://www.wolframalpha.com/input?i=What+is+the+2176th+prime+number%3F
; sieve_end = sieve+$0950 ; finds 2165 primes (19069) in 39 jiffies https://www.wolframalpha.com/input?i=What+is+the+2165th+prime+number%3F
; sieve_end = sieve+$0948 ; finds 2159 primes (19001) in 39 jiffies https://www.wolframalpha.com/input?i=What+is+the+2159th+prime+number%3F
;           @MarkTheStrange finds 2158 primes (18979) in 20 jiffies https://www.wolframalpha.com/input?i=What+is+the+18979th+prime+number%3F
; sieve_end = sieve+$0946 ; finds 2158 primes (18979) in 39 jiffies https://www.wolframalpha.com/input?i=What+is+the+2158th+prime+number%3F
; sieve_end = sieve+$0944 ; finds 2157 primes (18973) in 39 jiffies https://www.wolframalpha.com/input?i=What+is+the+2157th+prime+number%3F
; sieve_end = sieve+$0940 ; finds 2154 primes (18919) in 39 jiffies https://www.wolframalpha.com/input?i=What+is+the+2205th+prime+number%3F
; sieve_end = sieve+$0900 ; finds 2110 primes (18427) in 41 jiffies https://www.wolframalpha.com/input?i=What+is+the+3512nd+prime+number%3F
; sieve_end = sieve+$0800 ; finds 1900 primes (16381) in 38 jiffies https://www.wolframalpha.com/input?i=What+is+the+1900th+prime+number%3F
square_root_of_target=251
; square_root_of_target=138 ; Even if I reduce the square_root_of_target I still only get upto 36 jiffies.

main:
    jsr init_memory
    rts

init_memory:
    staword r0, sieve
    staword r1, 8192
    lda #$aa  ; even numbers are not primes.
    jsr MEMORY_FILL

    jsr factor3
    jsr factor5
    jsr factor7

    ; 7654 3210
    ; 1010 1100
    ; ac
    lda #$ac  ; This says 2, 3, 5, 7 are primes.
    sta sieve

    jsr factor_rest

    jsr countem


    rts


factor3:
    ; Now, some optimizations.
    ; every even number is not a prime, This is already handled by $aa above.
    ; every third number is not a prime,
    ; 1101 1011 $db (sieve + x) % 3 == 2
    ; 0110 1101 $6d (sieve + x) % 3 == 1
    ; 1011 0110 $b6 (sieve + x) % 3 == 0

    staword r0, sieve

keepgoing3:
    ldy #$00
    lda (r0), y
    and #$b6 ; 1011 0110 $b6 (sieve + x) % 3 == 0
    sta (r0), y

    iny
    lda (r0), y
    and #$6d ; 0110 1101 $6d (sieve + x) % 3 == 1
    sta (r0), y

    iny
    lda (r0), y
    and #$db ; 1101 1011 $db (sieve + x) % 3 == 2
    sta (r0), y

    lda r0L
    clc
    adc #3
    sta r0L

    lda r0H
    adc #0
    sta r0H

    clc
    lda r0H
    cmp #>(sieve_end+1)
    blt keepgoing3
    bne done3
    lda r0L
    cmp #<(sieve_end)
    blt keepgoing3
    bge done3
done3:
    rts


factor5:
    ; every fifth number is not a prime,
    ; 1111 0111 $f7 (sieve + x) % 5 == 4
    ; 1011 1101 $bd (sieve + x) % 5 == 3
    ; 1110 1111 $ef (sieve + x) % 5 == 2
    ; 0111 1011 $7b (sieve + x) % 5 == 1
    ; 1101 1110 $de (sieve + x) % 5 == 0

    staword r0, sieve

keepgoing5:
    ldy #$00

    lda (r0), y
    and #$de ; 1101 1110 $de (sieve + x) % 5 == 0
    sta (r0), y

    iny
    lda (r0), y
    and #$7b ; 0111 1011 $7b (sieve + x) % 5 == 1
    sta (r0), y

    iny
    lda (r0), y
    and #$ef ; 1110 1111 $ef (sieve + x) % 5 == 2
    sta (r0), y

    iny
    lda (r0), y
    and #$bd ; 1011 1101 $bd (sieve + x) % 5 == 3
    sta (r0), y

    iny
    lda (r0), y
    and #$f7 ; 1111 0111 $f7 (sieve + x) % 5 == 4
    sta (r0), y



    lda r0L
    clc
    adc #5
    sta r0L

    lda r0H
    adc #0
    sta r0H

    clc
    lda r0H
    cmp #>(sieve_end+1)
    blt keepgoing5
    bne done5
    lda r0L
    cmp #<(sieve_end)
    blt keepgoing5
    bge done5
done5:
    rts

factor7:
    ; every 7th number is not a prime.
    ; 1111 1101 $fd (sieve+x) % 7 == 6
    ; 1111 1011 $fb (sieve+x) % 7 == 5
    ; 1111 0111 $f7 (sieve+x) % 7 == 4
    ; 1110 1111 $ef (sieve+x) % 7 == 3
    ; 1101 1111 $df (sieve+x) % 7 == 2
    ; 1011 1111 $bf (sieve+x) % 7 == 1
    ; 0111 1110 $7e (sieve+x) % 7 == 0
    staword r0, sieve

keepgoing7:
    ldy #$00

    lda (r0), y
    and #$7e ; 0111 1110 $7e (sieve+x) % 7 == 0
    sta (r0), y

    iny
    lda (r0), y
    and #$bf ; 1011 1111 $bf (sieve+x) % 7 == 1
    sta (r0), y

    iny
    lda (r0), y
    and #$df ; 1101 1111 $df (sieve+x) % 7 == 2
    sta (r0), y

    iny
    lda (r0), y
    and #$ef ; 1110 1111 $ef (sieve+x) % 7 == 3
    sta (r0), y

    iny
    lda (r0), y
    and #$f7 ; 1111 0111 $f7 (sieve+x) % 7 == 4
    sta (r0), y

    iny
    lda (r0), y
    and #$fb ; 1111 1011 $fb (sieve+x) % 7 == 5
    sta (r0), y

    iny
    lda (r0), y
    and #$fd ; 1111 1101 $fd (sieve+x) % 7 == 6
    sta (r0), y



    lda r0L
    clc
    adc #7
    sta r0L

    lda r0H
    adc #0
    sta r0H

    clc
    lda r0H
    cmp #>(sieve_end+1)
    blt keepgoing7
    bne done7
    lda r0L
    cmp #<(sieve_end)
    blt keepgoing7
    bge done7
done7:
    rts

factor_rest:
    ; Now we need to start at bit 8 and work till 256. We don't have to go beyond 255, because we only have to check upto
    ; the sqrt(65536). In reality, we only have to go up to 251 inclusive.
    ; r1 is the index of which integer we're checking for primality.
    ; r2 is the index into the sieve based on the index above. (effectively r1 // 8)
    ; r3 is the bit within the byte of sieve that we're checking (effectively r1 % 8)

    staword r0, sieve
    staword r1, 7

keepgoing_rest:
    lda r1
    inc
    cmp #square_root_of_target
    bgt done_rest
    sta r1

    ; extract x >> 3 for the index from sieve.
    lsr
    lsr
    lsr
    and #$1f
    sta r2
    ;; This is the index into the sieve

    lda r1
    and #$07 ; last 3 bits
    ;; This is the bit we're testing.
    sta r3

    ldx r2
    lda sieve, x
    ldx r3
    and bits, x
    cmp #0
    beq keepgoing_rest ; not a prime.
; we found a prime
    jsr castout
    jmp keepgoing_rest

done_rest:
    rts

castout:
    ; This routine _expects_ r1 to be the index of the prime we just found.
    ; r4 is _multiple_ of r1 that we are invalidating. 

    lda r1

    ; We want r4 to start at r1 _squared_. Why? Because every prime before
    ; r1 would already have been invalidated.
    jsr square

keepgoing_castout:
    ; r4 now contains the current known composite number.
    copyword r5, r4

    ; now r5 has a copy of r4.
    ; we need to shift it 3 bits over.
    lsr r5H
    ror r5L
    lsr r5H
    ror r5L
    lsr r5H
    ror r5L
    ; now let's add the high byte of sieve to r5 to make it an actual address.
    clc
    lda r5H
    adc #>sieve
    sta r5H

    lda r4L
    and #$07
    tax

    lda (r5)
    and negative_bits, x
    sta (r5)

    clc
    lda r4L
    adc r1L
    sta r4L
    lda r4H
    adc #0
    sta r4H
    ; if carry is set that means we rolled over?
    bcc keepgoing_castout

    rts

square:
    ; This routine expects r1 to be the (8bit) value that we want to square.
    ; It puts it's result in r4.

    ; 131 => $83 = 1000 0011
    ; 0000 0000 1000 0011 +
    ; 0000 0001 0000 0110 +
    ; 0100 0001 1000 0000 =
    ; 0100 0011 0000 1001
    ; 4309

    ; 0000 0000 1111 1111 +
    ; 0000 0001 1111 1110 +
    ; 0000 0011 1111 1100 +
    ; 0000 0111 1111 1000 +
    ; 0000 1111 1111 0000 +
    ; 0001 1111 1110 0000 +
    ; 0011 1111 1100 0000 +
    ; 0111 1111 1000 0000 +
    ; 1111 1111 0000 0000 =
    ; 1111 1110 0000 0001
    ; fe01 = 65025 = 255 * 255

    lda r1
    sta r5L
    lda #0
    sta r5H
    sta r4L
    sta r4H

    ldx #0
continue_square:
    cpx #8
    beq done_square

    lda r1
    and bits, x
    cmp #0
    beq skip_square
    ; add r5 to r4.
    clc
    lda r5L
    adc r4L
    sta r4L
    lda r5H
    adc r4H
    sta r4H

skip_square:
    ; shift r5 to the left
    clc
    rol r5L
    rol r5H
    clc
    inx
    jmp continue_square

done_square:
    rts

countem:
    ; At this stage, we expect we have _all_ the primes. 
    staword r13, sieve ; r13 will be the sieve
    staword r14, 0
    staword r15, 0

loop_countem:
    lda r13H
    cmp #>sieve_end
    bgt done_countem
    blt continue_countem
    ; #>sieve_end == r13H
    lda r13L
    cmp #<sieve_end
    bge done_countem

continue_countem:
    lda (r13)
    tax
    lda r14L
    clc
    adc bitcounts, x
    sta r14L
    lda r14H
    adc #0
    sta r14H

    lda bitcounts, x
    cmp #0
    beq next_countem

    ; (r13-sieve) << 8 + topbitpos[(*r13)]
    copyword r15, r13
    lda r15H
    sbc #>sieve
    sta r15H

    asl r15L
    rol r15H
    asl r15L
    rol r15H
    asl r15L
    rol r15H

    lda (r13) ; This is the bitfield at the sieve location we want.
    tax

    lda r15L
    clc
    adc topbitpos, x
    sta r15L
    lda r15H
    adc #0
    sta r15H

next_countem:
    incword r13
    jmp loop_countem
done_countem:
    rts

bits:
    .byte $01, $02, $04, $08, $10, $20, $40, $80
negative_bits:
    .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
bitcounts:
;; bitcounts[27] = number of on bits in the number 27 = 16+8+2+1 = 11011 = 4
    .byte $00, $01, $01, $02, $01, $02, $02, $03, $01, $02, $02, $03, $02, $03, $03, $04
    .byte $01, $02, $02, $03, $02, $03, $03, $04, $02, $03, $03, $04, $03, $04, $04, $05
    .byte $01, $02, $02, $03, $02, $03, $03, $04, $02, $03, $03, $04, $03, $04, $04, $05
    .byte $02, $03, $03, $04, $03, $04, $04, $05, $03, $04, $04, $05, $04, $05, $05, $06
    .byte $01, $02, $02, $03, $02, $03, $03, $04, $02, $03, $03, $04, $03, $04, $04, $05
    .byte $02, $03, $03, $04, $03, $04, $04, $05, $03, $04, $04, $05, $04, $05, $05, $06
    .byte $02, $03, $03, $04, $03, $04, $04, $05, $03, $04, $04, $05, $04, $05, $05, $06
    .byte $03, $04, $04, $05, $04, $05, $05, $06, $04, $05, $05, $06, $05, $06, $06, $07
    .byte $01, $02, $02, $03, $02, $03, $03, $04, $02, $03, $03, $04, $03, $04, $04, $05
    .byte $02, $03, $03, $04, $03, $04, $04, $05, $03, $04, $04, $05, $04, $05, $05, $06
    .byte $02, $03, $03, $04, $03, $04, $04, $05, $03, $04, $04, $05, $04, $05, $05, $06
    .byte $03, $04, $04, $05, $04, $05, $05, $06, $04, $05, $05, $06, $05, $06, $06, $07
    .byte $02, $03, $03, $04, $03, $04, $04, $05, $03, $04, $04, $05, $04, $05, $05, $06
    .byte $03, $04, $04, $05, $04, $05, $05, $06, $04, $05, $05, $06, $05, $06, $06, $07
    .byte $03, $04, $04, $05, $04, $05, $05, $06, $04, $05, $05, $06, $05, $06, $06, $07
    .byte $04, $05, $05, $06, $05, $06, $06, $07, $05, $06, $06, $07, $06, $07, $07, $08


topbitpos:
;; topbitpos[27] = The highest bit (with bitnumber basically being whatever 2^bit would be in binary.
;;               : 27 = 16+8+2+1 = 2^4+2^3+2^1+2^0 and so this would be _4_.
;; we'll just declare topbitpos[0] = 0. But, bitpos is meaningless when the number is 0.

    .byte $00, $00, $01, $01, $02, $02, $02, $02, $03, $03, $03, $03, $03, $03, $03, $03
    .byte $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
    .byte $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
    .byte $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05
    .byte $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
    .byte $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
    .byte $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
    .byte $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
    .byte $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07
    .byte $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07
    .byte $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07
    .byte $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07
    .byte $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07
    .byte $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07
    .byte $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07
    .byte $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07, $07

