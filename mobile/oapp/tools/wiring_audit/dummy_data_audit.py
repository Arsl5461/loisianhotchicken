import os, re

ROOTS = ["lib/view/auth", "lib/view/settings", "lib/view/preferences", "lib/core/design"]

PATTERNS = [
    ("lorem",        re.compile(r"Lorem ipsum", re.I)),
    ("placeholder-name", re.compile(r"Ron Sasonov|John Doe|Jane Doe|Comapny", re.I)),
    ("fake-link",    re.compile(r"joinbubba\.com|example\.com|unsplash|picsum|placeholder\.com")),
    ("fake-card",    re.compile(r"\b(4242|2424)[\s\-]?\d{4}")),
    ("hardcoded-price", re.compile(r"\$\s?\d+(\.\d\d)?\s*/\s*(month|week|year)")),
    ("hardcoded-date", re.compile(r"\b(January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2},\s+20\d\d")),
    ("hardcoded-phone", re.compile(r"\b1?[\s\-(]*\d{3}[\s\-)]*\d{3}\s*-?\s*\d{4}\b")),
    ("hardcoded-email", re.compile(r"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.(com|net|org|io)")),
]

def dart_files():
    for root in ROOTS:
        for dp, _, fns in os.walk(root):
            for fn in sorted(fns):
                if fn.endswith(".dart"):
                    yield os.path.join(dp, fn)

hits = 0
for f in dart_files():
    for n, line in enumerate(open(f, encoding="utf-8", errors="ignore"), 1):
        if line.lstrip().startswith("//") or line.lstrip().startswith("///"):
            continue
        for label, rx in PATTERNS:
            if rx.search(line):
                print(f"{f}:{n}  [{label}]  {line.strip()[:110]}")
                hits += 1
                break
print(f"\nTOTAL suspect literals: {hits}")
