import os, re

TAB_ROOT = "DashboardScreen"
pages = open("lib/core/routing/app_pages.dart", encoding="utf-8").read()

# every GetPage(name: X, page: () => Y)
rows = []
for m in re.finditer(r"GetPage\(", pages):
    i = m.end() - 1
    depth, j = 0, i
    while j < len(pages):
        c = pages[j]
        if c == "(": depth += 1
        elif c == ")":
            depth -= 1
            if depth == 0: break
        j += 1
    body = pages[i:j+1]
    name = re.search(r"name:\s*([A-Za-z_.]+)", body)
    page = re.search(r"page:\s*\(\)\s*=>\s*(?:const\s+)?(\w+)", body)
    rows.append((name.group(1) if name else "?", page.group(1) if page else "?"))

tabbed = [r for r in rows if r[1] == TAB_ROOT]
print(f"routes that render the tab shell ({TAB_ROOT}): {len(tabbed)}")
for n, p in tabbed:
    print(f"  {n}")

print()
print("routes that render a tab-root screen WITHOUT the shell:")
TAB_SCREENS = {"HomeScreen", "YourLikesScreen", "Chatlist", "ThemedProfileScreen",
               "NewTravelScreen", "ChooseLocationScreen"}
bad = [r for r in rows if r[1] in TAB_SCREENS]
for n, p in bad:
    print(f"  {n} -> {p}")
print(f"  total: {len(bad)}")
