"""Compare a Flutter render against its design artboard.

Masks the chrome the app deliberately does not draw: the mock iOS status bar
and the home indicator. Prints the differing-pixel percentage over the
app-owned area and writes a side-by-side sheet.
"""
import sys, os
from PIL import Image, ImageChops, ImageDraw

STATUS_BAR = (0, 0, 390, 34)
HOME_INDICATOR = (0, 826, 390, 843)

def compare(flutter_png, design_png, out_png, extra_masks=(), threshold=40):
    a = Image.open(flutter_png).convert('RGB').resize((390, 843), Image.LANCZOS)
    b = Image.open(design_png).convert('RGB').resize((390, 843), Image.LANCZOS)
    diff = ImageChops.difference(a, b).convert('L').point(
        lambda v: 255 if v > threshold else 0)
    mask = Image.new('L', (390, 843), 255)
    md = ImageDraw.Draw(mask)
    for box in (STATUS_BAR, HOME_INDICATOR, *extra_masks):
        md.rectangle(box, fill=0)
    diff = ImageChops.multiply(diff, mask)
    counted = sum(1 for p in mask.getdata() if p)
    differing = sum(1 for p in diff.getdata() if p)
    pct = 100.0 * differing / counted

    sheet = Image.new('RGB', (390 * 3 + 20, 843), 'white')
    sheet.paste(b, (0, 0))
    sheet.paste(a, (400, 0))
    overlay = Image.new('RGB', (390, 843), 'white')
    overlay.paste(Image.new('RGB', (390, 843), 'red'), mask=diff)
    sheet.paste(overlay, (800, 0))
    sheet.save(out_png)
    return pct

if __name__ == '__main__':
    flutter, design, out = sys.argv[1], sys.argv[2], sys.argv[3]
    # Trailing "x0,y0,x1,y1" arguments mask regions the design fills with a
    # stock photo that the app has no equivalent for.
    extra = tuple(
        tuple(int(v) for v in arg.split(',')) for arg in sys.argv[4:]
    )
    print('%.2f%% differing  ->  %s' % (
        compare(flutter, design, out, extra_masks=extra), out))
