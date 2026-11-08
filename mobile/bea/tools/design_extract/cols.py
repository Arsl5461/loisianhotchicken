"""Leftmost/rightmost ink column per horizontal band, render vs design.

rows.py only measures vertical bands, so a whole column can slide sideways
without moving its number. This prints the first and last inked column of each
band so a horizontal shift shows up.

    python3 tools/design_extract/cols.py <render> <design> [band]
"""
import sys
from PIL import Image

W, H = 390, 843


def load(path):
    im = Image.open(path).convert('L').resize((W, H), Image.LANCZOS)
    return im.load()


def edges(px, y0, y1, threshold=160):
    lo, hi = None, None
    for y in range(y0, y1):
        for x in range(W):
            if px[x, y] < threshold:
                if lo is None or x < lo:
                    lo = x
                break
        for x in range(W - 1, -1, -1):
            if px[x, y] < threshold:
                if hi is None or x > hi:
                    hi = x
                break
    return lo, hi


def main():
    render, design = sys.argv[1], sys.argv[2]
    band = int(sys.argv[3]) if len(sys.argv) > 3 else 20
    a, b = load(render), load(design)
    print(f'{"band":>9} {"render":>12} {"design":>12} {"dLeft":>6} {"dRight":>7}')
    worst = 0
    for y in range(0, H, band):
        y1 = min(y + band, H)
        al, ar = edges(a, y, y1)
        bl, br = edges(b, y, y1)
        if al is None and bl is None:
            continue
        fmt = lambda l, r: '-' if l is None else f'{l}..{r}'
        dl = '' if al is None or bl is None else al - bl
        dr = '' if ar is None or br is None else ar - br
        if isinstance(dl, int):
            worst = max(worst, abs(dl))
        print(f'{y:>4}-{y1:<4} {fmt(al, ar):>12} {fmt(bl, br):>12} {dl:>6} {dr:>7}')
    print(f'worst left shift: {worst}pt')


main()
