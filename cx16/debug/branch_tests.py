#! /usr/bin/env python3
# vim: expandtab shiftwidth=4 tabstop=4

"""Gain intuition about the branches."""

def main():
    test = 0
    print("""
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

""")
    for branch in ("beq", "bne", "bpl", "bmi"):
        for acc in (3, 4, 5):
            print(f"""
test{test:d}:
    lda #${acc:02x}
    cmp #$04
    {branch:s} {branch:s}{acc:d}cmp4_success
    writestr_macro_nl {branch:s}{acc:d}cmp4_f
    jmp test{test+1:d}
{branch:s}{acc:d}cmp4_success:
    writestr_macro_nl {branch:s}{acc:d}cmp4_s
    jmp test{test+1:d}
{branch:s}{acc:d}cmp4_s:
    .asciiz "acc = {acc:d}, cmp 4, {branch:s} succeeds"
{branch:s}{acc:d}cmp4_f:
    .asciiz "acc = {acc:d}, cmp 4, {branch:s} fails"
""")
            test += 1

    print(f"test{test:d}:\n    rts")

if __name__ == "__main__":
    main()
