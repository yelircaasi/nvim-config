from pathlib import Path
import json
from collections import Counter

maps_path = Path.home() / "repos/nvim-config/builtins-PRE.json"
maps = json.loads(maps_path.read_text())
modes = [d.get("mode") or k for k, d in maps.items()]
c = Counter(modes)
for k, v in c.most_common():
    print(f"{k:<3} {v:>3}")
