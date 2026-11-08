import os, re

ROOTS = ["lib/view/auth", "lib/view/settings", "lib/view/preferences", "lib/core/design"]
USE_ROOTS = ROOTS + ["lib/core/routing", "lib/view/Dashboard", "test/bubba"]
CB = re.compile(r"(VoidCallback|ValueChanged|Function|Callback)")
CLASS_RE = re.compile(r"^\s*class\s+(\w+)\b", re.M)
FIELD_RE = re.compile(r"^\s*final\s+([A-Za-z0-9_<>,\?\s\.]+?)\s+(\w+)\s*;", re.M)

def dart_files():
    for root in ROOTS:
        for dp, _, fns in os.walk(root):
            for fn in fns:
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
        out.append((m.group(1), src[i:j+1]))
    return out

files = {f: open(f, encoding="utf-8", errors="ignore").read() for f in dart_files()}

def use_files():
    seen = set()
    for root in USE_ROOTS:
        for dp, _, fns in os.walk(root):
            for fn in fns:
                if fn.endswith(".dart"):
                    path = os.path.join(dp, fn)
                    if path not in seen:
                        seen.add(path)
                        yield path

alltext = "\n".join(
    open(f, encoding="utf-8", errors="ignore").read() for f in use_files()
)

decl = {}   # (class, field) -> file
for f, src in files.items():
    for name, body in split_classes(src):
        for fm in FIELD_RE.finditer(body):
            if CB.search(fm.group(1)):
                decl[(name, fm.group(2))] = (f, fm.group(1).strip())

dead = []
for (cls, field), (f, ftype) in sorted(decl.items()):
    passed = False
    for m in re.finditer(r"\b" + re.escape(cls) + r"(?:\.\w+)?\s*\(", alltext):
        i = m.end() - 1
        depth, j = 0, i
        while j < len(alltext):
            c = alltext[j]
            if c == "(": depth += 1
            elif c == ")":
                depth -= 1
                if depth == 0: break
            j += 1
        if re.search(r"\b" + re.escape(field) + r"\s*:", alltext[i:j+1]):
            passed = True
            break
    if not passed:
        used = bool(re.search(r"\b(widget\.)?" + re.escape(field) + r"\b", files[f].replace(f"{field};", "")))
        dead.append((f, cls, field, ftype, used))

for f, cls, field, ftype, used in dead:
    print(f"{f}\n    DEAD {cls}.{field}  ({ftype})  drawn={used}")
print(f"\nTOTAL never-passed callback fields: {len(dead)}")
