import os, re

ROOTS = ["lib/view/auth", "lib/view/settings", "lib/view/preferences"]
USE_ROOTS = ROOTS + ["lib/core/routing"]
CLASS_RE = re.compile(r"^\s*class\s+(\w+)\b([^{]*)", re.M)
CTRL = re.compile(r"(Controller\.to|Controller\.instance|Get\.find|GetBuilder|Obx\(|GetX<|Repository>)")
NAV = re.compile(r"(Get\.(to|off|back|toNamed|offNamed|offAllNamed|offAll|until|dialog|bottomSheet)|Navigator\.)")

def dart_files(roots):
    for root in roots:
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

alltext = "\n".join(
    open(f, encoding="utf-8", errors="ignore").read() for f in dart_files(USE_ROOTS)
)

rows = []
for f in dart_files(ROOTS):
    src = open(f, encoding="utf-8", errors="ignore").read()
    classes = split_classes(src)
    for name, ext, body in classes:
        if not re.match(r"^Bubba\w*(Screen|Page)$", name):
            continue
        blob = body
        for n2, e2, b2 in classes:
            if re.search(r"State<\s*" + re.escape(name) + r"\s*>", e2):
                blob += b2
        if not CTRL.search(blob) and not NAV.search(blob):
            # the handler may be a top-level function or a static helper in the
            # same file, which is how the create-account flow is written
            if not CTRL.search(src) and not NAV.search(src):
                rows.append((f, name, "no controller and no navigation anywhere in the file"))
                continue
            rows.append((f, name, "handlers live outside the class - open the file"))
            continue
        # is it reachable? a route or another screen must construct it
        uses = len(re.findall(r"\b" + re.escape(name) + r"\s*\(", alltext))
        if uses <= 1:
            rows.append((f, name, "wired but nothing constructs it"))

for f, n, why in rows:
    print(f"{f}::{n}  -  {why}")
print(f"\nTOTAL Bubba wrappers needing triage: {len(rows)}")
