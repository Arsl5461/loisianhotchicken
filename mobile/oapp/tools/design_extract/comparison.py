"""Write design-vs-render comparison sheets into test/bubba/comparison/.

One folder per device, one sheet per artboard, each sheet a pair: the design
reference on the left and that device's render on the right. Where an artboard
has no reference the phone render stands in on the left, so every screen still
gets a sheet.

    python3 tools/design_extract/comparison.py [artboard ...]
    python3 tools/design_extract/comparison.py --part 3 [artboard ...]
"""

import os
import sys

from PIL import Image, ImageDraw

RENDERS = 'test/bubba/goldens/create_account'
OUT = 'test/bubba/comparison'
REFS = {'design_page': 'test/bubba/goldens/design_reference',
        'p': 'test/bubba/goldens/design_reference_part2'}

PARTS = {
    '3': {
        'renders': 'test/bubba/goldens/devices_part3',
        'out': 'test/bubba/comparison_part3',
        'ref': 'test/bubba/goldens/design_reference_part3',
    },
    '4': {
        'renders': 'test/bubba/goldens/devices_part4',
        'out': 'test/bubba/comparison_part4',
        'ref': 'test/bubba/goldens/design_reference_part4',
    },
    '5': {
        'renders': 'test/bubba/goldens/devices_part5',
        'out': 'test/bubba/comparison_part5',
        'ref': 'test/bubba/goldens/design_reference_part5',
    },
}
DEVICES = ['iphone_se', 'iphone_se_2', 'iphone_14', 'iphone_16',
           'iphone_16_pro_max', 'pixel_8_gesture', 'android_3button',
           'ipad_mini', 'ipad_pro_11', 'ipad_air_13']

# Goldens and references are all rendered at 2x, so halving puts every panel at
# its true logical size. Panels are deliberately NOT normalised to one height -
# an iPhone SE has to look smaller than an iPad here, or the sheet is not a
# comparison.
SCALE = 0.5
GAP = 14
LABEL_H = 24
BG = (24, 24, 26)
FG = (236, 236, 238)


def _panel(path):
    im = Image.open(path).convert('RGB')
    return im.resize(
        (max(1, round(im.width * SCALE)), max(1, round(im.height * SCALE))),
        Image.LANCZOS,
    )


def sheet(artboard, device, part=None):
    renders = PARTS[part]['renders'] if part else RENDERS
    render = f'{renders}/{device}/{artboard}.png'
    if not os.path.exists(render):
        return None
    if part:
        base = PARTS[part]['ref']
    else:
        base = REFS['design_page'] if artboard.startswith('design_page') else REFS['p']
    ref = f'{base}/{artboard}.png'
    right = _panel(render)
    if os.path.exists(ref):
        left, left_label = _panel(ref), 'DESIGN'
    else:
        left, left_label = right, 'no reference'

    width = left.width + right.width + GAP * 3
    height = max(left.height, right.height) + LABEL_H + GAP * 2
    out = Image.new('RGB', (width, height), BG)
    draw = ImageDraw.Draw(out)
    out.paste(left, (GAP, LABEL_H))
    draw.text(
        (GAP, 6),
        f'{left_label}  |  {artboard}  {left.width}x{left.height}',
        fill=FG,
    )
    out.paste(right, (GAP * 2 + left.width, LABEL_H))
    draw.text(
        (GAP * 2 + left.width, 6),
        f'{device}  {right.width}x{right.height}',
        fill=FG,
    )
    return out


def main():
    args = sys.argv[1:]
    part = None
    if len(args) >= 2 and args[0] == '--part':
        part = args[1]
        args = args[2:]
        if part not in PARTS:
            raise SystemExit(f'unknown part {part}; known: {", ".join(PARTS)}')
    renders = PARTS[part]['renders'] if part else RENDERS
    out = PARTS[part]['out'] if part else OUT
    names = args
    if not names:
        names = sorted(
            f[:-4] for f in os.listdir(f'{renders}/{DEVICES[1]}')
            if f.endswith('.png')
        )
    written = 0
    for device in DEVICES:
        os.makedirs(f'{out}/{device}', exist_ok=True)
        for artboard in names:
            s = sheet(artboard, device, part)
            if s is None:
                continue
            s.save(f'{out}/{device}/{artboard}.png')
            written += 1
    print(f'wrote {written} sheets to {out}/<device>/')


if __name__ == '__main__':
    main()
