"""Score every rendered artboard against its design reference.

Pairs ink bands by proximity rather than by index, so one extra or missing band
does not throw the whole list out of step the way rows.py does. Reports the
vertical offset of each matched band and the horizontal offset of its first ink
column, plus any band present in one image and not the other.

    python3 tools/design_extract/audit.py <device>
"""

import os
import sys

from PIL import Image

W, H = 390, 843
STATUS_BAR = 46
HOME_INDICATOR = 22
RENDERS = 'test/bubba/goldens/create_account'
REFS = {'design_page': 'test/bubba/goldens/design_reference',
        'p': 'test/bubba/goldens/design_reference_part2'}


def bands(path, threshold=228, min_px=2):
    im = Image.open(path).convert('L').resize((W, H), Image.LANCZOS)
    px = im.load()
    rows = []
    for y in range(H):
        xs = [x for x in range(W) if px[x, y] < threshold]
        rows.append(xs)
    out, start = [], None
    for y in range(H):
        ink = len(rows[y]) >= min_px
        if ink and start is None:
            start = y
        elif not ink and start is not None:
            out.append(_band(rows, start, y))
            start = None
    if start is not None:
        out.append(_band(rows, start, H))
    return [b for b in out if b[0] > STATUS_BAR and b[1] < H - HOME_INDICATOR]


def _band(rows, y0, y1):
    xs = [x for y in range(y0, y1) for x in rows[y]]
    return (y0, y1 - 1, min(xs), max(xs))


def audit(name, render, ref):
    r, d = bands(render), bands(ref)
    used, dys, dxs, missing = set(), [], [], 0
    for db in d:
        centre = (db[0] + db[1]) / 2
        best, bi = None, None
        for i, rb in enumerate(r):
            if i in used:
                continue
            gap = abs((rb[0] + rb[1]) / 2 - centre)
            if gap <= 14 and (best is None or gap < best):
                best, bi = gap, i
        if bi is None:
            missing += 1
            continue
        used.add(bi)
        dys.append(r[bi][0] - db[0])
        dxs.append(r[bi][2] - db[2])
    extra = len(r) - len(used)
    worst_y = max(dys, key=abs) if dys else 0
    worst_x = max(dxs, key=abs) if dxs else 0
    return {'name': name, 'bands': len(d), 'matched': len(used),
            'missing': missing, 'extra': extra,
            'dy': worst_y, 'dx': worst_x,
            'off': sum(1 for a in dys if abs(a) > 1) +
                   sum(1 for a in dxs if abs(a) > 1)}


def main():
    device = sys.argv[1] if len(sys.argv) > 1 else 'iphone_14'
    rows = []
    for f in sorted(os.listdir(f'{RENDERS}/{device}')):
        if not f.endswith('.png'):
            continue
        name = f[:-4]
        base = REFS['design_page'] if name.startswith('design_page') else REFS['p']
        ref = f'{base}/{f}'
        if not os.path.exists(ref):
            continue
        rows.append(audit(name, f'{RENDERS}/{device}/{f}', ref))
    rows.sort(key=lambda r: (-(r['missing'] + r['extra']), -r['off'],
                             -abs(r['dy']), -abs(r['dx'])))
    print(f'{"artboard":18}{"bands":>6}{"matched":>8}{"missing":>8}{"extra":>6}'
          f'{"off":>5}{"worst dy":>9}{"worst dx":>9}')
    for r in rows:
        flag = '' if (r['missing'] == 0 and r['extra'] == 0 and r['off'] == 0) else '  <--'
        print(f'{r["name"]:18}{r["bands"]:>6}{r["matched"]:>8}{r["missing"]:>8}'
              f'{r["extra"]:>6}{r["off"]:>5}{r["dy"]:>+9}{r["dx"]:>+9}{flag}')
    clean = sum(1 for r in rows if r['missing'] == 0 and r['extra'] == 0 and r['off'] == 0)
    print(f'\nclean: {clean}/{len(rows)}')


if __name__ == '__main__':
    main()
