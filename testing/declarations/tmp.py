import json
from pathlib import Path

p = Path("/home/isaac/repos/nvim-config/testing/declarations/nix-info.json")
dp = Path("/home/isaac/repos/nvim-config/testing/declarations/dates.json")

info = json.loads(p.read_text())
dates = json.loads(dp.read_text())

for plugin in info:
    if (id_ := plugin["id"]) in dates:
        plugin["last_commit"] = dates[id_]


p.write_text(json.dumps(info, indent=4, ensure_ascii=False))
