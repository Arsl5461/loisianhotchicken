"""Run compare.py over every artboard and print the table for PROGRESS.md.

One row per artboard, in artboard order, measured off the goldens for one
device. Only a 390:843 golden is directly comparable to a reference, so the
default device is iphone_14; the sheets land in test/bubba/comparison_diff/.

    python3 tools/design_extract/compare_all.py [device]

Paths resolve against the repo, not the shell's directory, so it runs from
anywhere. The numbers are unmasked, which is how the coverage-pass table in
docs/bubba_part2/PROGRESS.md was taken. Screens whose artboard carries a stock
photo the app has no equivalent for read high on purpose - mask them per screen
with compare.py's trailing x0,y0,x1,y1 arguments when that is the question.
"""

import os
import sys

from compare import compare

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RENDERS = os.path.join(ROOT, 'test/bubba/goldens/create_account')
OUT = os.path.join(ROOT, 'test/bubba/comparison_diff')
PART1 = os.path.join(ROOT, 'test/bubba/goldens/design_reference')
PART2 = os.path.join(ROOT, 'test/bubba/goldens/design_reference_part2')


def artboards():
    for n in range(1, 30):
        yield f'design_page_{n}', os.path.join(PART1, f'design_page_{n}.png')
    for n in range(1, 55):
        yield f'p{n:03d}', os.path.join(PART2, f'p{n:03d}.png')


def main(device='iphone_14'):
    os.makedirs(os.path.join(OUT, device), exist_ok=True)
    rows = []
    for name, ref in artboards():
        render = os.path.join(RENDERS, device, f'{name}.png')
        if not os.path.exists(render) or not os.path.exists(ref):
            rows.append((name, None))
            continue
        rows.append(
            (name, compare(render, ref, os.path.join(OUT, device, f'{name}.png')))
        )
    print(f'| artboard | diff vs artboard ({device}) |')
    print('|---|---|')
    for name, pct in rows:
        print(f'| {name} | {"-" if pct is None else f"{pct:.2f}%"} |')
    have = sorted(p for _, p in rows if p is not None)
    if not have:
        print(f'\nno goldens found under {os.path.join(RENDERS, device)}')
        return
    print(f'\n{len(have)} artboards, median {have[len(have) // 2]:.2f}%, '
          f'{sum(1 for p in have if p < 5)} under 5%')


if __name__ == '__main__':
    main(*sys.argv[1:])
