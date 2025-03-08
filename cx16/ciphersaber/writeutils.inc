.import writestr, writehexbyte_func
.importzp writestr_arg, writehexbyte_arg

.macro  writestr_macro   addr
    lda #<addr
    sta writestr_arg
    lda #>addr
    sta writestr_arg+1
    jsr writestr
.endmacro

.macro writehexbyte val
    lda val
    sta writehexbyte_arg
    jsr writehexbyte_func
.endmacro

.macro writechar val
    lda val
    jsr $ffd2
.endmacro

