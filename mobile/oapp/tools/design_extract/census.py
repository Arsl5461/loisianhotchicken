import glob, os, sys
from collections import defaultdict
from parse import parse

area = defaultdict(float)
count = defaultdict(int)
pages = defaultdict(set)
samples = defaultdict(list)

for f in sorted(glob.glob('trace/p0*.txt')):
    pg = os.path.basename(f)[1:4]
    try:
        items, h = parse(f)
    except Exception as e:
        print('ERR', f, e); continue
    for it in items:
        c = it['color']
        if not c or it['x0'] is None: continue
        w = it['x1']-it['x0']; ht = it['y1']-it['y0']
        if w > 385 and ht > 838: key = c + ' (bg)'
        else: key = c
        area[key] += w*ht
        count[key] += 1
        pages[key].add(pg)
        if len(samples[key]) < 4 and w*ht > 100:
            samples[key].append('p%s %s %.0fx%.0f@%.0f,%.0f' % (pg, it['kind'][:6], w, ht, it['x0'], it['y0']))

print('%-16s %8s %6s %6s  %s' % ('COLOR','AREA','N','PAGES','SAMPLES'))
for c in sorted(area, key=lambda k: -area[k]):
    if count[c] < 2 and area[c] < 400: continue
    print('%-16s %8.0f %6d %6d  %s' % (c, area[c], count[c], len(pages[c]), '; '.join(samples[c][:3])))
