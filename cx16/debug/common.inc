;; Macros that are likely useful often.
;; Odds are we'll often need to increment, decrement or add two 16 bit words.

.macro incword arg
.scope
    clc
    inc arg
    bzc skip
    inc arg+1
skip:
.endscope
.endmacro

.macro decword arg
.scope
    dec arg
    bnc skip
    dec arg+1
skip:
.endscope
.endmacro

.macro adcword arg1, arg2
.scope
    lda arg1
    adc arg2
    bcc skip
    lda arg1+1
    adc arg2+1
skip:
.endscope
.endmacro

.macro staword addr, immediate
.scope
    lda #<immediate
    sta addr
    lda #>immediate
    sta addr+1
.endscope
.endmacro

.macro copyword dest, src
    lda src
    sta dest
    lda src+1
    sta dest+1
.endmacro
