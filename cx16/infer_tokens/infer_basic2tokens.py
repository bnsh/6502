#! /usr/bin/env python3
# vim: expandtab shiftwidth=4 tabstop=4

"""Figure out what tokens get mapped to what binary values."""

import os
import re
import json
from typing import List, Dict
from subprocess import run

from jinja2 import Environment, FileSystemLoader

def localfile(fname: str) -> str:
    return os.path.realpath(os.path.join(os.path.dirname(os.path.realpath(__file__)), fname))

def grab_basic_keywords() -> List[str]:
    with open(localfile("basic_commands.json"), "rt", encoding="utf-8-sig") as jsfp:
        return json.load(jsfp)

def runit(fname: str) -> Dict[str, List[int]]:
    res = run(["/usr/bin/env", "x16emu", "-bas", fname, "-run", "-debug"], check=True, capture_output=True)
    jsobj = json.loads(re.sub(r'\nSMC Power Off.\n', '', res.stdout.decode("utf-8")))
    return jsobj

def construct_data(line_start: int, val: str, intsperline: int) -> str:
    data = [int(vvv) for vvv in val.encode("utf-8")] + [-1]
    # Now, let's break it up into chunks of intsperline
    lines = [[data[idx] for idx in range(start, min(len(data), (start+intsperline)))] for start in range(0, len(data), intsperline)]
    res = []
    for idx, chunk in enumerate(lines):
        line_no = line_start + idx * 10
        chunk_s = ", ".join(f"{val:d}" for val in chunk)
        res.append(f"{line_no:d} DATA {chunk_s:s}")
    return "\n".join(res)

def process(basic_keyword: str) -> Dict[str, List[int]]:
    env = Environment(loader=FileSystemLoader(localfile(".")), keep_trailing_newline=True)
    tmpl = env.get_template("infer_basic2tokens.bas.jinja2")
    data_s = f"{{\"{basic_keyword.lower():s}\": ["
    res = tmpl.render({"basic_keyword": basic_keyword.upper(), "data": construct_data(2000, data_s, 8)})
    with open(localfile("infer_basic2tokens.bas"), "wt", encoding="utf-8") as ofp:
        ofp.write(res)

    return runit(localfile("infer_basic2tokens.bas"))

def main() -> None:
    basic_keywords = grab_basic_keywords()
    tokens = {"data": [131]} # Data is problematic, because it interferes with .. reading data.
    for basic_keyword in basic_keywords:
        if basic_keyword != "DATA":
            if basic_keyword == "π":
                basic_keyword = "~"
            if basic_keyword in ("TAB", "SPC"):
                basic_keyword = f"{basic_keyword:s}("
            res = process(basic_keyword)
            res = {key if key != "~" else "pi": value for key, value in res.items()}
            print(res)
            tokens.update(res)

            with open(localfile("infer_basic2tokens.json"), "wt", encoding="utf-8") as jsfp:
                json.dump(tokens, jsfp, indent=4, sort_keys=False, ensure_ascii=False)

if __name__ == "__main__":
    main()
