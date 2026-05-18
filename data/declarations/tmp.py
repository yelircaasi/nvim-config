import json
from pathlib import Path
import re

p = Path("/home/isaac/repos/nvim-config/testing/declarations/nix-info.json")
dp = Path("/home/isaac/repos/nvim-config/testing/declarations/dates.json")
np = Path("/home/isaac/repos/nvim-config/testing/declarations/tmp.json")


def grab_custom_dates(nix_info_path: Path, dates_path: Path) -> None:
    info = json.loads(nix_info_path.read_text())
    dates = json.loads(dates_path.read_text())

    for plugin in info:
        if (id_ := plugin["id"]) in dates:
            plugin["last_commit"] = dates[id_]

    nix_info_path.write_text(json.dumps(info, indent=4, ensure_ascii=False))


def grab_nixpkgs_dates(nix_info_path: Path, nix_gen_json_path: Path) -> None:
    info = json.loads(nix_info_path.read_text())
    nix_data = json.loads(nix_gen_json_path.read_text())

    def search_date(s: str) -> str:
        if srch := re.search(r"\d{4}-\d\d?-\d\d?", s):
            return srch.group()
        return s

    dates = {k: search_date(v["version"]) for k, v in nix_data.items() if v["version"]}
    # print(dates)

    for plugin in info:
        if ((name := plugin["name"]) in dates) and not plugin["last_commit"]:
            plugin["last_commit"] = dates[name]
        elif not re.search(r"\d{4}-\d\d?-\d\d?", plugin["last_commit"]):
            print(plugin["last_commit"])

    nix_info_path.write_text(json.dumps(info, indent=4, ensure_ascii=False))


grab_nixpkgs_dates(p, np)
