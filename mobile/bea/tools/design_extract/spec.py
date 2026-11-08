import re, sys, os, glob, math
from parse import parse

FONTMAP = {
    'CanelaTextTrial': 'Canela', 'CanelaTrial': 'Canela',
    'Lato': 'Lato', 'PublicSans': 'PublicSans',
    'SFProDisplay': 'PublicSans*', 'PlayfairDisplay': 'PlayfairDisplay',
    'Urbanist': 'Urbanist', 'DMSerifDisplay': 'DMSerif!', 'Caveat': 'Caveat(note)',
}

def famof(name):
    base = name.split('-')[0]
    return FONTMAP.get(base, base + '!')

def radius_of(it):
    """Estimate corner radius of a rounded rect from its point cloud."""
    pts = it.get('pts')
    if not pts or len(pts) < 8:
        return None
    x0, y0, x1, y1 = it['x0'], it['y0'], it['x1'], it['y1']
    # distance from the bbox top-left corner to the nearest path point
    best = min(math.hypot(px - x0, py - y0) for px, py in pts)
    if best < 0.4:
        return 0.0
    # radius r puts the nearest point at r*(sqrt(2)-1)... use axis-aligned probe instead
    near_top = [px for px, py in pts if abs(py - y0) < 0.35]
    near_left = [py for px, py in pts if abs(px - x0) < 0.35]
    r = None
    if near_top:
        r = min(px - x0 for px in near_top)
    if near_left:
        r2 = min(py - y0 for py in near_left)
        r = r2 if r is None else min(r, r2)
    if r is None:
        return None
    # mutool emits the bezier control point, which sits r*(1-0.5523) in from
    # the corner, so scale back up to the true corner radius
    return r / (1 - 0.5523)

def text_runs(xmlpath):
    txt = open(xmlpath, encoding='utf-8', errors='replace').read()
    runs = []
    for lm in re.finditer(r'<line bbox="([^"]*)"[^>]*>(.*?)</line>', txt, re.S):
        lb = [float(v) for v in lm.group(1).split()]
        body = lm.group(2)
        for fm in re.finditer(r'<font name="([^"]*)" size="([^"]*)"/?>(.*?)(?=<font |\Z)', body, re.S):
            name, size, chunk = fm.group(1), float(fm.group(2)), fm.group(3)
            chars = re.findall(r'<char c="([^"]*)" quad="[^"]*" x="([^"]*)" y="([^"]*)"[^>]*color="(#[0-9a-fA-F]{6})"', chunk)
            if not chars:
                continue
            s = ''.join(c[0] for c in chars)
            if not s.strip():
                continue
            import html
            s = html.unescape(s)
            xs = [float(c[1]) for c in chars]
            cols = [c[3].upper() for c in chars]
            # split into colour-uniform sub-runs
            start = 0
            for i in range(1, len(chars) + 1):
                if i == len(chars) or cols[i] != cols[start]:
                    sub = html.unescape(''.join(c[0] for c in chars[start:i]))
                    if sub.strip():
                        runs.append({
                            'text': sub, 'font': name, 'family': famof(name), 'size': size,
                            'color': cols[start], 'x': xs[start], 'baseline': float(chars[start][2]),
                            'x1': lb[2],
                        })
                    start = i
    return runs

STATUSBAR = lambda it: it['y1'] < 30 and it['x1'] - it['x0'] < 60
HOMEIND = lambda it, h: it['y0'] > h - 10

def dump(page, out):
    tr = 'trace/p%s.txt' % page
    sx = 'stext/p%s.xml' % page
    items, h = parse(tr)
    w = out.write
    w('## Artboard p%s\n\n' % page)
    w('### Shapes\n\n')
    w('| kind | fill/stroke | x | y | w | h | r | lw | a |\n|---|---|---|---|---|---|---|---|---|\n')
    groups = [it for it in items if it['kind'] == 'group']
    for it in items:
        if it['kind'] == 'group':
            continue
        if it['x0'] is None or not it['color']:
            continue
        bw = it['x1'] - it['x0']; bh = it['y1'] - it['y0']
        if max(bw, bh) < 3.5:
            continue
        if STATUSBAR(it) or HOMEIND(it, h):
            continue
        if bw > 385 and bh > h - 6:
            w('| BACKGROUND | %s | | | %.0f | %.0f | | | |\n' % (it['color'], bw, bh))
            continue
        r = radius_of(it)
        a = it.get('alpha')
        w('| %s | %s | %.2f | %.2f | %.2f | %.2f | %s | %s | %s |\n' % (
            'fill' if it['kind'] == 'fill_path' else 'stroke', it['color'],
            it['x0'], it['y0'], bw, bh,
            ('%.2f' % r) if r is not None else '', it.get('linewidth') or '',
            '' if a is None or a > 0.999 else '%.2f' % a))
    if groups:
        w('\n### Translucent groups (everything inside is drawn at this alpha)\n\n')
        w('| alpha | x | y | w | h |\n|---|---|---|---|---|\n')
        for g in groups:
            w('| %.2f | %.2f | %.2f | %.2f | %.2f |\n' % (
                g['alpha'], g['x0'], g['y0'], g['x1'] - g['x0'], g['y1'] - g['y0']))

    imgs = [i for i in items if i['kind'] == 'image']
    if imgs:
        w('\n### Images (design mockups / photos)\n\n')
        for i in imgs:
            w('- %.1f,%.1f  %.1f x %.1f (src %sx%s)\n' % (
                i['x0'], i['y0'], i['x1'] - i['x0'], i['y1'] - i['y0'], i.get('imgw'), i.get('imgh')))
    w('\n### Text\n\n')
    w('| text | family | weight/font | size | color | x | baseline |\n|---|---|---|---|---|---|---|\n')
    for r in text_runs(sx):
        if r['baseline'] < 30 or r['baseline'] > h:
            continue
        w('| %s | %s | %s | %.2f | %s | %.2f | %.2f |\n' % (
            r['text'].replace('|', '\\|'), r['family'], r['font'], r['size'],
            r['color'], r['x'], r['baseline']))
    w('\n')

if __name__ == '__main__':
    pages = sys.argv[1:]
    if not pages:
        pages = [os.path.basename(f)[1:4] for f in sorted(glob.glob('trace/p0*.txt'))]
    for p in pages:
        with open('spec/p%s.md' % p, 'w') as f:
            dump(p, f)
    print('wrote', len(pages), 'spec files')
