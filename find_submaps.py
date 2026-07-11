import json
import sys
from pathlib import Path

p = Path(__file__).parent / "data/snapshots/info/nvim-map--info--DEFAULT.json"

prefix, mode = (sys.argv + [""])[1:3]
maps = json.loads(p.read_text())

for mapping in maps.values():
    mapmode = mapping["mode"]
    if mapping["mode"].startswith(mode):
        keybind = mapping["keybind"]
        if keybind.startswith(prefix):
            desc = mapping["description"] or "<DESC MISSING>"
            print(f"{keybind:<8} {desc}  ({mapmode})")
