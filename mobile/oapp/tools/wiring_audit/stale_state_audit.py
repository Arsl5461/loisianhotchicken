import os, re
ROOTS = ["lib/view/settings", "lib/view/preferences"]
CLASS_RE = re.compile(r"^\s*class\s+(\w+)\b([^{]*)", re.M)

def dart_files():
    for root in ROOTS:
        for dp, _, fns in os.walk(root):
            for fn in sorted(fns):
                if fn.endswith(".dart"):
                    yield os.path.join(dp, fn)

def split_classes(src):
    out = []
    for m in CLASS_RE.finditer(src):
        i = src.find("{", m.end())
        if i < 0: continue
        depth, j = 0, i
        while j < len(src):
            c = src[j]
            if c == "{": depth += 1
            elif c == "}":
                depth -= 1
                if depth == 0: break
            j += 1
        out.append((m.group(1), m.group(2), src[i:j+1]))
    return out

READS = re.compile(r"(controller|_controller|BubbaSettingsController\.to|BubbaSecurityController\.to|BubbaPrefsController\.to)\.(cards|purchases|subscription|plans|blocked|privacy|preferences|account|notifications|model)\b")
LOADS = re.compile(r"\.load\w*\(")

for f in dart_files():
    src = open(f, encoding="utf-8", errors="ignore").read()
    for name, ext, body in split_classes(src):
        if not re.match(r"^Bubba\w*Screen$", name): continue
        blob = body
        for n2, e2, b2 in split_classes(src):
            if re.search(r"State<\s*" + re.escape(name) + r"\s*>", e2):
                blob += b2
        if READS.search(blob) and not LOADS.search(blob):
            hit = READS.search(blob).group(0)
            # BubbaSecurityController and BubbaPrefsController load everything in
            # onInit, so their screens are covered by first `.to`.
            covered = "privacy" in hit or "model" in hit or "notifications" in hit
            note = "  (controller self-loads in onInit)" if covered else "  <-- STALE"
            print(f"{f}::{name}  reads {hit} and never calls load*(){note}")
