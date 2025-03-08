#! /usr/bin/env python3
# vim: expandtab shiftwidth=4 tabstop=4

"""Gain intuition about the branches."""

def main():
    test = 0

    branch_lessons = [
        ("beq", "`beq` is Branch on Equal. (No surprises here.)"),
        ("bne", "`bne` is Branch on Not Equal. (No surprises here.)"),
        ("bmi", "`bmi` is Branch on Less Than. The Minus, is somewhat non intuitive to _me_."),
        ("bpl", "`bpl` is Branch on Greater Than or Equal. The Plus, is also somewhat non intuitive to _me_."),
    ]

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
    for branch, lesson in branch_lessons:
        print(f"; Tests for {branch:s}")
        for acc in (3, 4, 5):
            print(f"""test{test:d}:
    lda #${acc:02x}
    cmp #$04
    {branch:s} {branch:s}{acc:d}cmp4_success
    writestr_macro_nl {branch:s}{acc:d}cmp4_f
    jmp test{test:d}_complete
{branch:s}{acc:d}cmp4_success:
    writestr_macro_nl {branch:s}{acc:d}cmp4_s
    jmp test{test:d}_complete
{branch:s}{acc:d}cmp4_s:
    .asciiz "acc = {acc:d}, cmp 4, {branch:s} succeeds"
{branch:s}{acc:d}cmp4_f:
    .asciiz "acc = {acc:d}, cmp 4, {branch:s} fails"
test{test:d}_complete:
""")
            test += 1

        print(f"{branch:s}_lesson:")
        print(f"    writestr_macro_nl {branch:s}_lesson_s")
        print( "    lda #$0d")
        print( "    jsr CHROUT")
        print(f"    jmp {branch:s}_lesson_complete")
        print(f"{branch:s}_lesson_s:")
        print(f"    .asciiz \"{lesson:s}\"")
        print(f"{branch:s}_lesson_complete:")

        print()

    print("    rts")

if __name__ == "__main__":
    main()
