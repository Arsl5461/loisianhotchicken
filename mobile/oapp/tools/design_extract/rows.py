"""List the ink bands of a render and a design page side by side.

Both images are resized to 390x843 design points, then every row is scored by
how many non-background pixels it has. Consecutive scoring rows are grouped
into bands, which is enough to see at a glance which element sits where and how
far the two disagree.

    python3 tools/design_extract/rows.py render.png design.png
"""

import sys

from PIL import Image

DESIGN = (390, 843)
STATUS_BAR = 44
HOME_INDICATOR = 20


def bands(path, threshold=24, min_px=2):
    im = Image.open(path).convert("L").resize(DESIGN, Image.LANCZOS)
    px = im.load()
    w, h = im.size
    rows = []
    for y in range(h):
        n = 0
        for x in range(w):
            if px[x, y] < 255 - threshold:
                n += 1
        rows.append(n)
    out = []
    start = None
    for y in range(h):
        ink = rows[y] >= min_px
        if ink and start is None:
            start = y
        elif not ink and start is not None:
            out.append((start, y - 1, max(rows[start:y])))
            start = None
    if start is not None:
        out.append((start, h - 1, max(rows[start:h])))
    return [b for b in out if b[0] > STATUS_BAR and b[1] < h - HOME_INDICATOR]


def main():
    a, b = sys.argv[1], sys.argv[2]
    left, right = bands(a), bands(b)
    print(f"{'render ' + a.split('/')[-1]:>34} | design {b.split('/')[-1]}")
    for i in range(max(len(left), len(right))):
        la = f"{left[i][0]:>4}-{left[i][1]:<4} ({left[i][2]:>3}px)" if i < len(left) else ""
        lb = f"{right[i][0]:>4}-{right[i][1]:<4} ({right[i][2]:>3}px)" if i < len(right) else ""
        delta = ""
        if i < len(left) and i < len(right):
            delta = f"  d={left[i][0] - right[i][0]:+d}"
        print(f"{la:>34} | {lb}{delta}")


if __name__ == "__main__":
    main()
