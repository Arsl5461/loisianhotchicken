import sys, math
from xml.etree import ElementTree as ET
from parse import mat_mul, apply, parse_mat, hexcol, IDENT

SHAPE = ('fill_path', 'stroke_path')
XFORM = ('fill_path','stroke_path','fill_text','stroke_text','fill_shade',
         'fill_image','fill_image_mask','clip_path','clip_stroke_path','clip_text')

def collect(node, m, out):
    t = node.get('transform')
    local = parse_mat(t) if (t and node.tag in XFORM) else None
    if node.tag in SHAPE:
        cm = mat_mul(local, m) if local else m
        segs = []
        pts = []
        cx = cy = 0.0
        for seg in node:
            s = seg.tag
            if s == 'moveto':
                p = apply(cm, float(seg.get('x')), float(seg.get('y')))
                segs.append(('M', [p])); pts.append(p)
            elif s == 'lineto':
                p = apply(cm, float(seg.get('x')), float(seg.get('y')))
                segs.append(('L', [p])); pts.append(p)
            elif s == 'curveto':
                ps = [apply(cm, float(seg.get('x%d' % i)), float(seg.get('y%d' % i)))
                      for i in (1, 2, 3)]
                segs.append(('C', ps)); pts.extend(ps)
            elif s == 'closepath':
                segs.append(('Z', []))
        if pts:
            xs = [p[0] for p in pts]; ys = [p[1] for p in pts]
            out.append({
                'kind': node.tag,
                'color': hexcol(node.get('colorspace',''), node.get('color','')),
                'linewidth': node.get('linewidth'),
                'segs': segs,
                'x0': min(xs), 'y0': min(ys), 'x1': max(xs), 'y1': max(ys),
            })
        return
    if node.tag in ('clip_path','clip_stroke_path','clip_text'):
        for ch in node:
            if ch.tag in ('moveto','lineto','curveto','closepath'): continue
            collect(ch, m, out)
        return
    for ch in node:
        collect(ch, m, out)

def load(path):
    page = ET.parse(path).getroot().find('page')
    out = []
    collect(page, IDENT, out)
    return out

def emit(items, x, y, w, h, pad=1.0, color=None, kind=None):
    """Every path fully inside the rect, normalised so the rect's own bbox starts at 0,0."""
    sel = [it for it in items
           if it['x0'] >= x - pad and it['y0'] >= y - pad
           and it['x1'] <= x + w + pad and it['y1'] <= y + h + pad
           and (color is None or (it['color'] or '').upper() == color.upper())
           and (kind is None or it['kind'] == kind)]
    if not sel:
        return None
    ox = min(it['x0'] for it in sel); oy = min(it['y0'] for it in sel)
    ex = max(it['x1'] for it in sel); ey = max(it['y1'] for it in sel)
    parts = []
    for it in sel:
        for op, ps in it['segs']:
            parts.append(op)
            for px, py in ps:
                parts.append('%.2f' % (px - ox))
                parts.append('%.2f' % (py - oy))
    return {
        'w': ex - ox, 'h': ey - oy, 'x': ox, 'y': oy,
        'colors': sorted({it['color'] for it in sel if it['color']}),
        'kinds': sorted({it['kind'] for it in sel}),
        'n': len(sel),
        'data': ' '.join(parts),
    }

def dart(name, g, wrap=72):
    body = g['data']
    lines = []
    line = ''
    for tok in body.split(' '):
        if len(line) + len(tok) + 1 > wrap:
            lines.append(line); line = tok
        else:
            line = tok if not line else line + ' ' + tok
    if line: lines.append(line)
    quoted = "\n      ".join("'%s '" % l for l in lines[:-1] + [lines[-1]])
    return ("  static const %s = BubbaGlyph(%.2f, %.2f,\n      %s);"
            % (name, g['w'], g['h'], quoted))

if __name__ == '__main__':
    # glyph.py trace/p014.txt NAME x y w h
    items = load(sys.argv[1])
    if len(sys.argv) == 2:
        for it in items:
            print('%-11s %-8s x %7.2f..%7.2f y %7.2f..%7.2f  w %6.2f h %6.2f lw=%s' % (
                it['kind'], it['color'] or '-', it['x0'], it['x1'], it['y0'], it['y1'],
                it['x1']-it['x0'], it['y1']-it['y0'], it['linewidth']))
        sys.exit()
    name = sys.argv[2]
    x, y, w, h = (float(v) for v in sys.argv[3:7])
    rest = sys.argv[7:]
    color = kind = None
    while rest:
        a = rest.pop(0)
        if a == '--color': color = rest.pop(0)
        elif a == '--kind': kind = rest.pop(0)
    g = emit(items, x, y, w, h, color=color, kind=kind)
    if not g:
        print('no paths in rect'); sys.exit(1)
    print('// %s  %d paths  %s  %s  at %.2f,%.2f  %.2fx%.2f'
          % (name, g['n'], ','.join(g['colors']), ','.join(g['kinds']), g['x'], g['y'], g['w'], g['h']))
    print(dart(name, g))
