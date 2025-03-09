#! /usr/bin/env python3
# vim: expandtab shiftwidth=4 tabstop=4

"""Gain intuition about the branches."""

import csv
import argparse
from collections import defaultdict

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--outputfn", "-o", type=str, required=True)
    args = parser.parse_args()

    with open("kernal.csv", "rt", encoding="utf-8") as csvfp:
        csvdr = csv.DictReader(csvfp)
        labels_by_class = defaultdict(list)
        raw = sorted(
            [
                {
                    "label": row["label"].split(" ", 2)[0].upper(),
                    "tbv": row["address"],
                    "address": int(row["address"][1:], 16),
                    "class": row["class"],
                    "description": row["description"],
                    "inputs": row["inputs"],
                    "affects": row["affects"],
                    "origin": row["origin"],
                } for row in csvdr
            ],
            key=lambda x: (x["class"], x["label"])
        )
        for datum in raw:
            labels_by_class[datum["class"]].append(datum)

    with open(args.outputfn, "wt", encoding="utf-8") as ofp:
        ofp.write("; https://github.com/X16Community/x16-docs/blob/master/X16%20Reference%20-%2005%20-%20KERNAL.md\n")

        for class_, labels in labels_by_class.items():
            ofp.write(f"; Class: {class_:s}\n")
            for label in labels:
                assert f"${label['address']:02X}" == label["tbv"], (label['address'], label['tbv'])
                ofp.write(f"    {label['label']:s} = ${label['address']:04X}\n")
                ofp.write(f"    ; {label['description']:s}\n")
                ofp.write(f"    ; Inputs: {label['inputs']:s}\n")
                ofp.write(f"    ; Affects: {label['affects']:s}\n")
                ofp.write(f"    ; Origin: {label['origin']:s}\n\n")

if __name__ == "__main__":
    main()
