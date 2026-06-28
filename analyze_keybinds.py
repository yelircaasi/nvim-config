import sys
import re
from pathlib import Path
import json
from collections import Counter


info_path = Path(sys.argv[1])
info = json.loads(info_path.read_text())
plugin_name = re.compile(r"Last set from [^/]+/(?P<name>.+?)/")
plugins = []
plugins_plugs = []

for k, v in info.items():
    keybind = v["keybind"]
    is_plug = keybind.startswith("<Plug>")
    origin = v["origin"]
    plugin = plugin_name.search(origin)
    if plugin:
        if is_plug:
            plugins_plugs.append(plugin.groupdict()["name"])
        else:
            plugins.append(plugin.groupdict()["name"])
    else:
        print(origin)
    
counts = Counter(plugins)
counts_plug = Counter(plugins_plugs)

print("ACTIVE MAPS ======================================")
for k, c in counts.most_common():
    print(f"{k:<20} {c}")
print("PLUG MAPS ========================================")
for k, c in counts_plug.most_common():
    print(f"{k:<20} {c}")
print("=================== DUPLICATES ===================")
print("Duplicates:", len([k for k in info if "__" in k]))
print("Total:", len(info))
print("Active:", sum(counts.values()))
print("Plug:", sum(counts_plug.values()))
print("Defaults:", len([1 for v in info.values() if "vim/_core/defaults" in v["origin"]]))
print()
print("Leader:", len([1 for v in info.values() if v["keybind"].startswith("<Space>")]))
print("Localleader:", len([1 for v in info.values() if v["keybind"].startswith("\\")]))
print("g:", len([1 for v in info.values() if v["keybind"].startswith("g")]))
print("m:", len([1 for v in info.values() if v["keybind"].startswith("m")]))
print("z:", len([1 for v in info.values() if v["keybind"].startswith("z")]))
print("Ctrl:", len([1 for v in info.values() if v["keybind"].startswith("<C")]))
print("Meta:", len([1 for v in info.values() if v["keybind"].startswith("<M")]))
print("Tab:", len([1 for v in info.values() if v["keybind"].startswith("<Tab>")]))
print("Shift:", len([1 for v in info.values() if v["keybind"].startswith("<S-")]))
print("Comma:", len([1 for v in info.values() if v["keybind"].startswith(",")]))
print("[:", len([1 for v in info.values() if v["keybind"].startswith("[")]))
print("]:", len([1 for v in info.values() if v["keybind"].startswith("]")]))
others = [v["keybind"] for v in info.values() if re.match(r"^[^\<gzm,\\\[\]]", v["keybind"])]
print("Other:", len(others))
print(others)
