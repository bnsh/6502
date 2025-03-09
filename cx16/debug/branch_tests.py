#! /usr/bin/env python3
# vim: expandtab shiftwidth=4 tabstop=4

"""Gain intuition about the branches."""

import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--outputfn", "-o", type=str, required=True)
    args = parser.parse_args()

    test = 0

    branch_lessons = [
#         ("beq", "`beq` is Branch on Equal. (No surprises here.)"),
#         ("bne", "`bne` is Branch on Not Equal. (No surprises here.)"),
#         ("bmi", "`bmi` is Branch on Less Than. The Minus, is somewhat non intuitive to _me_."),
#         ("bpl", "`bpl` is Branch on Greater Than or Equal. The Plus, is also somewhat non intuitive to _me_."),
#         ("bcc", "`bcc` is Branch on Carry Clear. This is somewhat non intuitive to _me_."),
#         ("bcs", "`bcs` is Branch on Carry Set. This is somewhat non intuitive to _me_."),
#         ("bvc", "`bvc` is Branch on oVerflow Clear. This is somewhat non intuitive to _me_."),
#         ("bvs", "`bvs` is Branch on oVerflow Set. This is somewhat non intuitive to _me_."),
#         ("bgt", "`bgt` is Branch greater than")
    ]

    with open(args.outputfn, "wt", encoding="utf-8") as ofp:
        ofp.write("""
.import debug_registers

.include "kernal.inc"
.include "sensible_unsigned_compares.inc"
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
            ofp.write(f"; Tests for {branch:s}\n")
            for acc in (0x00, 0x01, 0x7f, 0x80, 0x81, 0xfe, 0xff):
                for cmp_ in (0x00, 0x01, 0x7f, 0x80, 0x81, 0xfe, 0xff):
                    ofp(f"""test{test:d}:
    lda #${acc:02x}
    cmp #${cmp_:02x}
    {branch:s} {branch:s}{acc:02x}cmp{cmp_:02x}_success
    writestr_macro_nl {branch:s}{acc:02x}cmp{cmp_:02x}_f
    jmp test{test:d}_complete
{branch:s}{acc:02x}cmp{cmp_:02x}_success:
    writestr_macro_nl {branch:s}{acc:02x}cmp{cmp_:02x}_s
    jmp test{test:d}_complete
{branch:s}{acc:02x}cmp{cmp_:02x}_s:
    .asciiz "acc = #${acc:02x}, cmp #${cmp_:02x}, {branch:s} succeeds"
{branch:s}{acc:02x}cmp{cmp_:02x}_f:
    .asciiz "acc = #${acc:02x}, cmp #${cmp_:02x}, {branch:s} fails"
test{test:d}_complete:

""")
                test += 1

            ofp.write(f"""{branch:s}_lesson:
    writestr_macro_nl {branch:s}_lesson_s
    lda #$0d
    jsr CHROUT
    jmp {branch:s}_lesson_complete
{branch:s}_lesson_s:
    .asciiz "{lesson:s}"
{branch:s}_lesson_complete:

""")

        ofp.write("    rts\n")

if __name__ == "__main__":
    main()
