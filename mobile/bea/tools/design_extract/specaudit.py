"""Walk every row of an artboard's spec tables and look for it in the render.

Band matching only sees rows of ink. This reads `docs/bubba_part{1,2}/specs`
and asks, per shape and per text run, whether that thing exists in the render at
all - which is how a missing hairline, an undrawn rule or a dropped control is
found.

    python3 tools/design_extract/specaudit.py [device] [artboard ...]
"""

import os
import re
import sys

from PIL import Image

W, H = 390, 843
RENDERS = 'test/bubba/goldens/create_account'
SPECS = {'design_page': 'docs/bubba_part1/specs',
         'p': 'docs/bubba_part2/specs'}


def spec_path(name):
    if name.startswith('design_page'):
        return '%s/p%03d.md' % (SPECS['design_page'], int(name.split('_')[-1]))
    return '%s/%s.md' % (SPECS['p'], name)


def num(cell):
    cell = cell.strip()
    if not cell:
        return None
    try:
        return float(cell)
    except ValueError:
        return None


def parse(path):
    shapes, texts = [], []
    section = None
    for line in open(path):
        line = line.rstrip('\n')
        if line.startswith('### '):
            section = line[4:].split(' ')[0].lower()
            continue
        if not line.startswith('|') or set(line) <= set('| -'):
            continue
        cells = [c.strip() for c in line.strip('|').split('|')]
        if section == 'shapes' and len(cells) >= 8:
            kind, colour = cells[0], cells[1]
            if kind in ('kind', 'BACKGROUND') or not colour.startswith('#'):
                continue
            x, y, w, h, r, lw = (num(c) for c in cells[2:8])
            if x is None or y is None:
                continue
            shapes.append((kind, colour, x, y, w or 0, h or 0, r, lw))
        elif section == 'text' and len(cells) >= 7:
            if cells[0] in ('text', '---'):
                continue
            x, base = num(cells[5]), num(cells[6])
            if x is None or base is None:
                continue
            texts.append((cells[0], cells[2], num(cells[3]), x, base))
    return shapes, texts


def hex_rgb(s):
    s = s.lstrip('#')
    return tuple(int(s[i:i + 2], 16) for i in (0, 2, 4))


def load(path):
    im = Image.open(path).convert('RGB').resize((W, H), Image.LANCZOS)
    return im.load()


def has_colour(px, rect, want, tol=40):
    x0, y0, x1, y1 = rect
    x0 = max(0, int(x0)); y0 = max(0, int(y0))
    x1 = min(W - 1, int(x1)); y1 = min(H - 1, int(y1))
    best = 10 ** 9
    for y in range(y0, y1 + 1):
        for x in range(x0, x1 + 1):
            r, g, b = px[x, y]
            d = abs(r - want[0]) + abs(g - want[1]) + abs(b - want[2])
            if d < best:
                best = d
            if d <= tol:
                return True, best
    return False, best


def has_ink(px, rect, thr=205):
    x0, y0, x1, y1 = rect
    x0 = max(0, int(x0)); y0 = max(0, int(y0))
    x1 = min(W - 1, int(x1)); y1 = min(H - 1, int(y1))
    for y in range(y0, y1 + 1):
        for x in range(x0, x1 + 1):
            r, g, b = px[x, y]
            if (r + g + b) / 3 < thr:
                return True
    return False


def audit(name, device):
    render = '%s/%s/%s.png' % (RENDERS, device, name)
    sp = spec_path(name)
    if not os.path.exists(render) or not os.path.exists(sp):
        return None
    px = load(render)
    shapes, texts = parse(sp)
    miss_shapes, miss_texts = [], []
    for kind, colour, x, y, w, h, r, lw in shapes:
        if y + h < 40:
            continue
        want = hex_rgb(colour)
        if h <= 1:
            rect = (x, y - 2, x + max(w, 1), y + 2)
        else:
            rect = (x, y, x + w, y + h)
        ok, best = has_colour(px, rect, want)
        if not ok:
            miss_shapes.append((kind, colour, x, y, w, h, best))
    for label, _weight, size, x, base in texts:
        if base < 40:
            continue
        sz = size or 12
        if not has_ink(px, (x - 3, base - sz - 3, x + 40, base + 4)):
            miss_texts.append((label, x, base))
    return miss_shapes, miss_texts


def main():
    args = sys.argv[1:]
    device = args[0] if args and not args[0].startswith('p') and \
        not args[0].startswith('design') else 'iphone_14'
    names = [a for a in args if a != device]
    if not names:
        names = sorted(f[:-4] for f in os.listdir('%s/%s' % (RENDERS, device))
                       if f.endswith('.png'))
    rows = []
    for n in names:
        res = audit(n, device)
        if res is None:
            continue
        ms, mt = res
        rows.append((len(ms) + len(mt), n, ms, mt))
    rows.sort(reverse=True)
    for score, n, ms, mt in rows:
        if score == 0:
            continue
        print('=== %s   %d shape(s), %d text run(s) not found' %
              (n, len(ms), len(mt)))
        for kind, colour, x, y, w, h, best in ms[:8]:
            print('    %-6s %s at %.1f,%.1f %.1fx%.1f   nearest delta %d' %
                  (kind, colour, x, y, w, h, best))
        for label, x, base in mt[:8]:
            print('    text   "%s" at x %.1f baseline %.1f' %
                  (label[:44], x, base))
    print('\nartboards with nothing missing: %d / %d' %
          (sum(1 for r in rows if r[0] == 0), len(rows)))


if __name__ == '__main__':
    main()
