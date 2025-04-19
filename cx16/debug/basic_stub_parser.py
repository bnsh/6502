#! /usr/bin/env python3
# vim: expandtab shiftwidth=4 tabstop=4

"""This will read a "basic" program dump in a hexadecimal format."""

from basic_stub_data import basic_stub_data

def main() -> None:
    data = basic_stub_data()

    # Now, we start at $0801 = 2049
    base = 2049
    cur_addr = 2049
    while cur_addr != 0:
        next_addr = data[(cur_addr - base)] + 256 * data[(cur_addr - base + 1)]
        if next_addr != 0:
            line_num = data[(cur_addr - base + 2)] + 256 * data[(cur_addr - base + 3)]

            vals = ", ".join(f"${data[(idx-base)]:02x}" for idx in range(cur_addr, next_addr))
            print(f"; {line_num:d}")
            print(f".byte {vals:s}")
        cur_addr = next_addr

    print(f"; main = {base + len(data):d} ({base+len(data):04x})")

if __name__ == "__main__":
    main()
