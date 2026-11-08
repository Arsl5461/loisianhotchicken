"""Lift outlined text out of `mutool draw -F svg -O text=path` output.

    mutool draw -F svg -O text=path -o page.svg file.ai N
    python3 svg_glyph.py page.svg NAME x y w h

mutool writes each glyph once into <defs> in font units and places it with a
`<use transform="matrix(a,b,c,d,e,f)">`. This resolves the matrix, keeps the
glyphs whose placed origin falls inside the rect, and prints a `BubbaGlyph`.
"""

import re
import sys

NUM = r'[-+0-9.eE]+'


def parse_defs(svg):
    defs = {}
    for m in re.finditer(r'<path id="([^"]+)"[^>]*d="([^"]*)"', svg):
        defs[m.group(1)] = m.group(2)
    return defs


def parse_uses(svg):
    out = []
    for m in re.finditer(
        r'<use[^>]*xlink:href="#([^"]+)"[^>]*transform="matrix\(([^)]*)\)"[^>]*/>',
        svg,
    ):
        mat = [float(v) for v in m.group(2).split(',')]
        out.append((m.group(1), mat))
    return out


def tokens(d):
    return re.findall(r'([MLCHVZmlchvz])|(%s)' % NUM, d)


def path_points(d, mat):
    """Absolute points of one glyph outline, with the use matrix applied."""
    a, b, c, dd, e, f = mat
    def ap(x, y):
        return (a * x + c * y + e, b * x + dd * y + f)

    segs = []
    cur = (0.0, 0.0)
    start = (0.0, 0.0)
    i = 0
    toks = re.findall(r'[MLCHVZmlchvz]|-?\.?\d+(?:\.\d+)?(?:[eE][-+]?\d+)?', d)
    op = None
    while i < len(toks):
        t = toks[i]
        if re.match(r'[A-Za-z]', t):
            op = t
            i += 1
            continue
        if op in ('M', 'L'):
            x, y = float(toks[i]), float(toks[i + 1])
            i += 2
            cur = (x, y)
            if op == 'M':
                start = cur
            segs.append((op, [ap(x, y)]))
        elif op == 'H':
            x = float(toks[i]); i += 1
            cur = (x, cur[1]); segs.append(('L', [ap(*cur)]))
        elif op == 'V':
            y = float(toks[i]); i += 1
            cur = (cur[0], y); segs.append(('L', [ap(*cur)]))
        elif op == 'C':
            pts = [float(v) for v in toks[i:i + 6]]
            i += 6
            cur = (pts[4], pts[5])
            segs.append(('C', [ap(pts[0], pts[1]), ap(pts[2], pts[3]), ap(pts[4], pts[5])]))
        else:
            i += 1
        if op == 'Z' or op == 'z':
            segs.append(('Z', []))
            cur = start
    return segs


def main():
    svg = open(sys.argv[1]).read()
    name = sys.argv[2]
    x, y, w, h = (float(v) for v in sys.argv[3:7])
    defs = parse_defs(svg)
    kept = []
    for gid, mat in parse_uses(svg):
        if gid not in defs:
            continue
        ox, oy = mat[4], mat[5]
        if not (x - 2 <= ox <= x + w + 2 and y - 2 <= oy <= y + h + 40):
            continue
        kept.append(path_points(defs[gid], mat))
    if not kept:
        print('no glyphs in rect')
        return
    pts = [p for segs in kept for _, ps in segs for p in ps]
    x0 = min(p[0] for p in pts); y0 = min(p[1] for p in pts)
    x1 = max(p[0] for p in pts); y1 = max(p[1] for p in pts)
    parts = []
    for segs in kept:
        for opname, ps in segs:
            parts.append(opname)
            for px, py in ps:
                parts.append('%.2f' % (px - x0))
                parts.append('%.2f' % (py - y0))
    data = ' '.join(parts)
    print('// %s  %d glyphs  at %.2f,%.2f  %.2fx%.2f'
          % (name, len(kept), x0, y0, x1 - x0, y1 - y0))
    lines = []
    line = ''
    for tok in data.split(' '):
        if len(line) + len(tok) + 1 > 72:
            lines.append(line); line = tok
        else:
            line = tok if not line else line + ' ' + tok
    if line:
        lines.append(line)
    body = "\n      ".join("'%s '" % l for l in lines)
    print("  static const %s = BubbaGlyph(%.2f, %.2f,\n      %s);"
          % (name, x1 - x0, y1 - y0, body))


if __name__ == '__main__':
    main()
