import re, sys, os, math, json
from xml.etree import ElementTree as ET

def mat_mul(a, b):
    a0,a1,a2,a3,a4,a5 = a
    b0,b1,b2,b3,b4,b5 = b
    return (a0*b0+a1*b2, a0*b1+a1*b3,
            a2*b0+a3*b2, a2*b1+a3*b3,
            a4*b0+a5*b2+b4, a4*b1+a5*b3+b5)

def apply(m, x, y):
    return (m[0]*x + m[2]*y + m[4], m[1]*x + m[3]*y + m[5])

def parse_mat(s):
    return tuple(float(v) for v in s.split())

IDENT = (1,0,0,1,0,0)

def hexcol(cs, col):
    parts = col.split()
    if len(parts) == 3:
        r,g,b = (float(p) for p in parts)
    elif len(parts) == 1:
        r=g=b=float(parts[0])
    elif len(parts) == 4:
        c,m,y,k = (float(p) for p in parts)
        r,g,b = (1-c)*(1-k), (1-m)*(1-k), (1-y)*(1-k)
    else:
        return None
    return '#%02X%02X%02X' % (round(r*255), round(g*255), round(b*255))

def _alpha_of(node):
    a = node.get('alpha')
    try:
        return float(a) if a is not None else 1.0
    except ValueError:
        return 1.0

def walk(node, m, out, depth=0, galpha=1.0):
    tag = node.tag
    if tag == 'group':
        ga = node.get('alpha')
        try:
            ga = float(ga) if ga is not None else 1.0
        except ValueError:
            ga = 1.0
        galpha = galpha * ga
        if ga < 0.999:
            bb = node.get('bbox')
            if bb:
                x0, y0, x1, y1 = (float(v) for v in bb.split())
                out.append({'kind': 'group', 'color': None, 'alpha': galpha,
                            'groupalpha': ga, 'x0': x0, 'y0': y0,
                            'x1': x1, 'y1': y1})
    t = node.get('transform')
    if t and tag in ('fill_path','stroke_path','fill_text','stroke_text','fill_shade','fill_image','fill_image_mask','clip_path','clip_stroke_path','clip_text'):
        local = parse_mat(t)
    else:
        local = None

    if tag in ('fill_path','stroke_path'):
        cm = mat_mul(local, m) if local else m
        pts = []
        cx = cy = 0.0
        start = None
        for seg in node:
            s = seg.tag
            if s == 'moveto':
                cx, cy = float(seg.get('x')), float(seg.get('y')); pts.append((cx,cy)); start=(cx,cy)
            elif s == 'lineto':
                cx, cy = float(seg.get('x')), float(seg.get('y')); pts.append((cx,cy))
            elif s == 'curveto':
                for i in (1,2,3):
                    pts.append((float(seg.get('x%d'%i)), float(seg.get('y%d'%i))))
                cx, cy = float(seg.get('x3')), float(seg.get('y3'))
            elif s == 'closepath':
                if start: cx,cy = start
        if pts:
            dev = [apply(cm, x, y) for x,y in pts]
            xs = [p[0] for p in dev]; ys = [p[1] for p in dev]
            out.append({
                'kind': tag,
                'color': hexcol(node.get('colorspace',''), node.get('color','')),
                'raw': node.get('color'),
                'alpha': _alpha_of(node) * galpha,
                'linewidth': node.get('linewidth'),
                'x0': min(xs), 'y0': min(ys), 'x1': max(xs), 'y1': max(ys),
                'npts': len(pts),
                'pts': dev if len(dev) <= 64 else None,
            })
        return

    if tag in ('fill_image','fill_image_mask'):
        cm = mat_mul(local, m) if local else m
        corners = [apply(cm,0,0), apply(cm,1,0), apply(cm,0,1), apply(cm,1,1)]
        xs=[c[0] for c in corners]; ys=[c[1] for c in corners]
        out.append({'kind':'image','color':None,'alpha':_alpha_of(node)*galpha,
                    'x0':min(xs),'y0':min(ys),'x1':max(xs),'y1':max(ys),
                    'imgw':node.get('width'),'imgh':node.get('height')})
        return

    if tag == 'fill_shade':
        cm = mat_mul(local, m) if local else m
        out.append({'kind':'shade','color':None,'x0':None,'y0':None,'x1':None,'y1':None})
        return

    if tag in ('clip_path','clip_stroke_path','clip_text'):
        for ch in node:
            if ch.tag in ('moveto','lineto','curveto','closepath'): continue
            walk(ch, m, out, depth+1, galpha)
        return

    for ch in node:
        walk(ch, m, out, depth+1, galpha)

def parse(path):
    tree = ET.parse(path)
    root = tree.getroot()
    page = root.find('page')
    h = 843.0
    mb = page.get('mediabox')
    if mb:
        h = float(mb.split()[3])
    out = []
    walk(page, IDENT, out)
    # device space is y-down already in mutool trace output
    return out, h

if __name__ == '__main__':
    items, h = parse(sys.argv[1])
    minarea = float(sys.argv[2]) if len(sys.argv) > 2 else 0
    for it in items:
        if it['x0'] is None: continue
        w = it['x1']-it['x0']; ht = it['y1']-it['y0']
        if w*ht < minarea: continue
        print('%-12s %-8s x %7.2f..%7.2f  y %7.2f..%7.2f   w %6.2f h %6.2f  lw=%s a=%s' % (
            it['kind'], it['color'] or '-', it['x0'], it['x1'], it['y0'], it['y1'], w, ht,
            it.get('linewidth'), it.get('alpha')))
