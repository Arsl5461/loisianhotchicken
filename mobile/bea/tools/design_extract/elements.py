"""Element-level comparison of a render against its artboard.

`compare.py` gives one percentage, which moved by a fraction of a point on
eighteen real defects in a row. This gives the thing that was actually missing:
**every element, matched between design and render, with its offset in design
points.**

    python3 tools/design_extract/elements.py p004
    python3 tools/design_extract/elements.py p004 ipad_pro_11
    python3 tools/design_extract/elements.py design_page_29 ipad_pro_11 --top 40
    python3 tools/design_extract/elements.py p004 --crop 100,225,150,275 --zoom 10

Both images are normalised into the canonical 390x843 design space first, so an
artboard drawn at 385.478x847.198 lines up with a 390-wide render without any
hand arithmetic.

Verdicts:
    OK        within --tol on every edge
    MOVED     same size, different position
    RESIZED   same position, different size
    OFF       both
    MISSING   in the design, nothing matched in the render
    EXTRA     in the render, nothing matched in the design
"""
import os
import sys
from collections import deque

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
DESIGN_DIRS = [
    'test/bubba/goldens/design_reference_part2',
    'test/bubba/goldens/design_reference',
]
RENDER_DIR = 'test/bubba/goldens/create_account'

# Parts 3, 4 and 5 keep their renders and their design references side by side,
# so --part switches both at once.
PARTS = {
    '3': ('test/bubba/goldens/design_reference_part3',
          'test/bubba/goldens/devices_part3'),
    '4': ('test/bubba/goldens/design_reference_part4',
          'test/bubba/goldens/devices_part4'),
    '5': ('test/bubba/goldens/design_reference_part5',
          'test/bubba/goldens/devices_part5'),
}
DESIGN_W, DESIGN_H = 390.0, 843.0

# The app deliberately does not draw the mock status bar or the home indicator.
MASKS = [(0, 0, 390, 34), (0, 826, 390, 843)]


def _find(artboard, dirs=None):
    for d in (dirs or DESIGN_DIRS):
        p = os.path.join(ROOT, d, artboard + '.png')
        if os.path.exists(p):
            return p
    raise SystemExit('no design reference for ' + artboard)


DEVICES = {
    'iphone_se': (320, 568), 'iphone_14': (390, 843), 'iphone_pro_max': (430, 932),
    'ipad_mini': (744, 1133), 'ipad_pro_11': (834, 1194), 'ipad_air_13': (1032, 1376),
    'iphone_se_2': (375, 667), 'iphone_16': (393, 852),
    'iphone_16_pro_max': (440, 956), 'pixel_8_gesture': (412, 915),
    'android_3button': (360, 800),
}


def _factor(w, h):
    by_w = w / DESIGN_W
    if w < 600:
        return max(0.75, min(by_w, 1.3))
    return max(0.75, min(min(by_w, h / DESIGN_H), 1.75))


def _load(path, device=None):
    """Return the image resampled into the 390x843 design space.

    On a window wider than the canvas the render is cropped to the canvas first,
    so a tablet is compared as "the artboard, scaled" rather than against its own
    background margins.
    """
    im = Image.open(path).convert('RGB')
    if device in DEVICES:
        w, h = DEVICES[device]
        f = _factor(w, h)
        canvas = min(w, DESIGN_W * f)
        if canvas < w - 0.5:
            s = im.size[0] / w
            off = (w - canvas) / 2
            im = im.crop((int(off * s), 0, int((off + canvas) * s), im.size[1]))
    # Scale by width and keep the aspect, then top-anchor into the canvas box.
    # Resizing both to a fixed height instead stretches a 838pt artboard by
    # 0.6% against a 844pt render, which reads as a drift that grows down the
    # screen - it is arithmetic, not a defect.
    tw, th = int(DESIGN_W), int(DESIGN_H)
    scaled = im.resize((tw, max(1, round(im.size[1] * DESIGN_W / im.size[0]))),
                       Image.LANCZOS)
    if scaled.size[1] == th:
        return scaled
    out = Image.new('RGB', (tw, th), scaled.getpixel((2, 2)))
    out.paste(scaled.crop((0, 0, tw, min(th, scaled.size[1]))), (0, 0))
    return out


def _ink(im, thresh, bg=None):
    """Boolean ink map: pixels that differ from the page background.

    `bg` is derived once from the **design** and reused for the render, so the
    two never disagree about what counts as background - a screen whose hero
    differs between the two would otherwise invert one of the maps and report
    every element missing.
    """
    px = im.load()
    w, h = im.size
    if bg is None:
        corners = [px[2, 2], px[w - 3, 2], px[2, h - 3], px[w - 3, h - 3]]
        bg = max(set(corners), key=corners.count)
    mask = bytearray(w * h)
    for y in range(h):
        row = y * w
        for x in range(w):
            c = px[x, y]
            d = abs(c[0] - bg[0]) + abs(c[1] - bg[1]) + abs(c[2] - bg[2])
            mask[row + x] = 1 if d > thresh else 0
    for mx0, my0, mx1, my1 in MASKS:
        for y in range(int(my0), min(h, int(my1))):
            row = y * w
            for x in range(int(mx0), min(w, int(mx1))):
                mask[row + x] = 0
    return mask, w, h, bg


def _components(mask, w, h, min_area, gapx, gapy):
    """Connected ink regions.

    Dilation is asymmetric on purpose: wide horizontally so the letters of a
    line join into one run, narrow vertically so two stacked lines stay two
    elements. That is the granularity a reviewer reads a screen at.
    """
    seen = bytearray(w * h)
    out = []
    for start in range(w * h):
        if not mask[start] or seen[start]:
            continue
        q = deque([start])
        seen[start] = 1
        x0 = x1 = start % w
        y0 = y1 = start // w
        area = 0
        while q:
            i = q.popleft()
            area += 1
            cx, cy = i % w, i // w
            if cx < x0: x0 = cx
            if cx > x1: x1 = cx
            if cy < y0: y0 = cy
            if cy > y1: y1 = cy
            for dy in range(-gapy, gapy + 1):
                ny = cy + dy
                if ny < 0 or ny >= h:
                    continue
                base = ny * w
                for dx in range(-gapx, gapx + 1):
                    nx = cx + dx
                    if nx < 0 or nx >= w:
                        continue
                    j = base + nx
                    if mask[j] and not seen[j]:
                        seen[j] = 1
                        q.append(j)
        if area >= min_area:
            out.append((x0, y0, x1 + 1, y1 + 1, area))
    return out


def _match(a, b, tol):
    """Greedy nearest-centre matching, size-aware so two stacked rows don't swap."""
    used = set()
    pairs = []
    for i, ea in enumerate(a):
        acx, acy = (ea[0] + ea[2]) / 2, (ea[1] + ea[3]) / 2
        aw, ah = ea[2] - ea[0], ea[3] - ea[1]
        best = None
        for j, eb in enumerate(b):
            if j in used:
                continue
            bcx, bcy = (eb[0] + eb[2]) / 2, (eb[1] + eb[3]) / 2
            bw, bh = eb[2] - eb[0], eb[3] - eb[1]
            dist = abs(acx - bcx) + abs(acy - bcy)
            size = abs(aw - bw) + abs(ah - bh)
            if dist > 60 or size > max(aw, ah, 24):
                continue
            score = dist + size * 0.6
            if best is None or score < best[0]:
                best = (score, j)
        if best is None:
            pairs.append((ea, None))
        else:
            used.add(best[1])
            pairs.append((ea, b[best[1]]))
    for j, eb in enumerate(b):
        if j not in used:
            pairs.append((None, eb))
    return pairs


def _verdict(d, r, tol):
    if r is None:
        return 'MISSING', None
    if d is None:
        return 'EXTRA', None
    dx = ((r[0] + r[2]) - (d[0] + d[2])) / 2
    dy = ((r[1] + r[3]) - (d[1] + d[3])) / 2
    dw = (r[2] - r[0]) - (d[2] - d[0])
    dh = (r[3] - r[1]) - (d[3] - d[1])
    moved = abs(dx) > tol or abs(dy) > tol
    sized = abs(dw) > tol or abs(dh) > tol
    if moved and sized:
        v = 'OFF'
    elif moved:
        v = 'MOVED'
    elif sized:
        v = 'RESIZED'
    else:
        v = 'OK'
    return v, (dx, dy, dw, dh)


def crop(artboard, device, region, zoom, out, part=None):
    x0, y0, x1, y1 = region
    design_dirs, render_dir = (
        ([PARTS[part][0]], PARTS[part][1]) if part else (None, RENDER_DIR))
    d = _load(_find(artboard, design_dirs))
    r = _load(os.path.join(ROOT, render_dir, device, artboard + '.png'), device)
    w, h = int((x1 - x0) * zoom), int((y1 - y0) * zoom)
    tiles = [im.crop((int(x0), int(y0), int(x1), int(y1))).resize((w, h), Image.LANCZOS)
             for im in (d, r)]
    sheet = Image.new('RGB', (w * 2 + 24, h), 'white')
    sheet.paste(tiles[0], (0, 0))
    sheet.paste(tiles[1], (w + 24, 0))
    sheet.save(out)
    print('design | render  ->  %s  (%dx%d)' % (out, *sheet.size))


def main():
    args = [a for a in sys.argv[1:]]
    if not args:
        raise SystemExit(__doc__)
    artboard = args.pop(0)
    device = 'iphone_14'
    tol, top, thresh, min_area = 1.5, 25, 26, 12
    gapx, gapy = 5, 1
    region = zoom = out = None
    part = None
    while args:
        a = args.pop(0)
        if a == '--tol': tol = float(args.pop(0))
        elif a == '--top': top = int(args.pop(0))
        elif a == '--thresh': thresh = int(args.pop(0))
        elif a == '--min-area': min_area = int(args.pop(0))
        elif a == '--gapx': gapx = int(args.pop(0))
        elif a == '--gapy': gapy = int(args.pop(0))
        elif a == '--zoom': zoom = float(args.pop(0))
        elif a == '--out': out = args.pop(0)
        elif a == '--crop': region = [float(v) for v in args.pop(0).split(',')]
        elif a == '--mask': MASKS.append(tuple(float(v) for v in args.pop(0).split(',')))
        elif a == '--part':
            part = args.pop(0)
            if part in ('3', '4', '5'):
                globals()['DESIGN_H'] = 838.0
        else: device = a

    if region:
        crop(artboard, device, region, zoom or 8, out or '/tmp/inspect.png',
             part)
        return

    design_dirs, render_dir = (
        ([PARTS[part][0]], PARTS[part][1]) if part else (None, RENDER_DIR))
    dpath = _find(artboard, design_dirs)
    rpath = os.path.join(ROOT, render_dir, device, artboard + '.png')
    if not os.path.exists(rpath):
        raise SystemExit('no render at ' + rpath)

    dm, w, h, bg = _ink(_load(dpath), thresh)
    rm, _, _, _ = _ink(_load(rpath, device), thresh, bg)
    de = _components(dm, w, h, min_area, gapx, gapy)
    re_ = _components(rm, w, h, min_area, gapx, gapy)

    rows = []
    for d, r in _match(de, re_, tol):
        v, delta = _verdict(d, r, tol)
        box = d if d is not None else r
        rows.append((v, box, delta))

    order = {'OFF': 0, 'MISSING': 1, 'EXTRA': 2, 'MOVED': 3, 'RESIZED': 4, 'OK': 5}
    rows.sort(key=lambda t: (order[t[0]], -(abs(t[2][0]) + abs(t[2][1])) if t[2] else 0))

    counts = {}
    for v, _, _ in rows:
        counts[v] = counts.get(v, 0) + 1
    print('%s @ %s   %d elements   %s' % (
        artboard, device, len(rows),
        '  '.join('%s %d' % (k, counts[k]) for k in
                  ['OFF', 'MISSING', 'EXTRA', 'MOVED', 'RESIZED', 'OK'] if k in counts)))
    print('tolerance %.1f design-pt\n' % tol)
    print('%-8s %-28s %8s %8s %8s %8s' % ('verdict', 'design box (x0 y0 x1 y1)', 'dx', 'dy', 'dw', 'dh'))
    print('-' * 74)
    shown = 0
    for v, box, delta in rows:
        if v == 'OK':
            continue
        if shown >= top:
            break
        b = '%6.1f %6.1f %6.1f %6.1f' % (box[0], box[1], box[2], box[3])
        if delta:
            print('%-8s %-28s %8.2f %8.2f %8.2f %8.2f' % (v, b, *delta))
        else:
            print('%-8s %-28s %8s %8s %8s %8s' % (v, b, '-', '-', '-', '-'))
        shown += 1
    if not shown:
        print('every element within tolerance')


if __name__ == '__main__':
    main()
