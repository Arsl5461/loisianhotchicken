import os, re, sys, json

ROOTS = ["lib/view/auth", "lib/view/settings", "lib/view/preferences", "lib/core/design"]
CB = re.compile(r"(VoidCallback|ValueChanged|Function|Callback)")

def dart_files():
    for root in ROOTS:
        for dp, _, fns in os.walk(root):
            for fn in fns:
                if fn.endswith(".dart"):
                    yield os.path.join(dp, fn)

CLASS_RE = re.compile(r"^\s*class\s+(\w+)\b", re.M)

def split_classes(src):
    out = []
    for m in CLASS_RE.finditer(src):
        name = m.group(1)
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
        out.append((name, src[i:j+1], m.start()))
    return out

FIELD_RE = re.compile(r"^\s*final\s+([A-Za-z0-9_<>,\?\s\.]+?)\s+(\w+)\s*;", re.M)

def main():
    views = {}     # ViewClassName -> (file, [callback field names])
    files = {}
    for f in dart_files():
        src = open(f, encoding="utf-8", errors="ignore").read()
        files[f] = src
        for name, body, _ in split_classes(src):
            fields = []
            for fm in FIELD_RE.finditer(body):
                ftype, fname = fm.group(1), fm.group(2)
                if CB.search(ftype):
                    fields.append((fname, ftype.strip()))
            if fields:
                views[name] = (f, fields)

    problems = []
    for f, src in files.items():
        for cname, body, _ in split_classes(src):
            for vname, (vfile, vfields) in views.items():
                if vname == cname: continue
                # find constructor invocations of vname inside this class body
                for cm in re.finditer(r"\b" + re.escape(vname) + r"(?:\.\w+)?\s*\(", body):
                    i = cm.end() - 1
                    depth, j = 0, i
                    while j < len(body):
                        c = body[j]
                        if c == "(": depth += 1
                        elif c == ")":
                            depth -= 1
                            if depth == 0: break
                        j += 1
                    args = body[i:j+1]
                    missing = [fn for fn, ft in vfields
                               if not re.search(r"\b" + re.escape(fn) + r"\s*:", args)]
                    if missing:
                        problems.append({
                            "wrapper_file": f, "wrapper_class": cname,
                            "view": vname, "view_file": vfile,
                            "missing": missing,
                        })
    problems.sort(key=lambda p: (p["wrapper_file"], p["view"]))
    for p in problems:
        print(f"{p['wrapper_file']}::{p['wrapper_class']} -> {p['view']}")
        for m in p["missing"]:
            print(f"    MISSING {m}")
    print(f"\nTOTAL construction sites with unpassed callbacks: {len(problems)}")
    print(f"TOTAL unpassed callback fields: {sum(len(p['missing']) for p in problems)}")

main()
