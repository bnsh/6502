#! /usr/bin/env python3
# vim: expandtab shiftwidth=4 tabstop=4

"""Generate cx16_registers.asm"""

import argparse
from typing import IO

def header(fptr: IO[str]) -> None:
    fptr.write("""; # New API for the Commander X16
; There are lots of new APIs. Please note that their addresses and their behavior is still preliminary and can change between revisions.
; 
; Some new APIs use the "16 bit" ABI, which uses virtual 16 bit registers r0 through r15, which are located in zero page locations $02 through $21: r0 = r0L = $02, r0H = $03, r1 = r1L = $04 etc.
; 
; The 16 bit ABI generally follows the following conventions:
; 
; arguments
; word-sized arguments: passed in r0-r5
; byte-sized arguments: if three or less, passed in .A, .X, .Y; otherwise in 16 bit registers
; boolean arguments: c, n
; return values
; basic rules as above
; function takes no arguments: r0-r5, else indirect through passed-in pointer
; arguments in r0-r5 can be "inout", i.e. they can be updated
; saved/scratch registers
; r0-r5: arguments (saved)
; r6-r10: saved
; r11-r15: scratch
; .A, .X, .Y, c, n: scratch (unless used otherwise)

""")

def guts(fptr: IO[str]) -> None:
    for regnum in range(0, 16):
        zpaddr = 2 + regnum * 2
        fptr.write(f"; register {regnum:d} -> zero page address ${zpaddr:02x}\n")
        fptr.write(f"r{regnum:d} = ${zpaddr:02x}\n")
        fptr.write(f"r{regnum:d}L = ${zpaddr:02x}\n")
        fptr.write(f"r{regnum:d}H = ${(1+zpaddr):02x}\n\n")

#pylint: disable=unused-argument
def footer(fptr: IO[str]) -> None:
    pass
#pylint: enable=unused-argument

def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--outputfn", "-o", type=str, required=True)
    args = parser.parse_args()

    with open(args.outputfn, "wt", encoding="utf-8") as cfp:
        header(cfp)
        guts(cfp)
        footer(cfp)

if __name__ == "__main__":
    main()
