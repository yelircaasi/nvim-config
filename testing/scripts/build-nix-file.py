from pathlib import Path
import json
from typing import cast

from nvimtool import Source, Utils

nn = Path.home() / ("repos/nvim-config/testing/declarations/nix-info.json")
result = Path.home() / ("repos/nvim-config/testing/snapshots/nvim-plugins.nix")


plugin_expr_template = """{name} = pkgs.vimUtils.buildVimPlugin {lbrace}
        pname = "{nix_name}";
        version = "{version}";
        src = builtins.fetchGit {lbrace}
            url = "{url}/";
            name = "{name}";
            rev = "{rev}";
            hash = "{nix_hash}";
        {rbrace};
        meta.homepage = "{url}/";
    {rbrace};"""


def make_expression(d: dict) -> str:
    source = Source(d["source"])
    base = {
        Source.GH: "https://github.com/",
        Source.GL: "https://gitlab.com/",
        Source.CB: "https://codeberg.org/",
    }.get(source, "")
    ret =  plugin_expr_template.format(
        name=d["name"],
        nix_name=d["nixName"],
        version="PLACEHOLDER",
        url="/".join((base, d["id"])),
        rev="PLACEHOLD_REV",
        nix_hash="PLACEHOLDER_HASH",
        lbrace="{",
        rbrace="}",
    )
    print(ret)
    return ret


nix_data = cast(list[dict], Utils.read_json(nn))
custom_info = [d for d in nix_data if d.get("attrset", "").startswith("custom")]
custom = "\n    ".join(map(make_expression, custom_info))
file_contents = (
    "{pkgs, lib}:\nlet custom = {\n    "
    f'{custom}'
    "\n}; in {\n"
    "    # config to go here\n}"
)

result.write_text(file_contents)



tmp: dict = cast(dict, Utils.read_json(Path("/home/isaac/repos/nvim-config/testing/tmp.json")))

def fix_data(d: dict) -> dict:
    if d["source"] != "gh":
        return d
    if d["hash"]:
        return d
    try:
        if d["id"] in tmp:
            tmp_info = tmp[d["id"]]
            return d | {
                "rev": tmp_info["src"]["rev"],
                "hash": tmp_info["src"]["hash"],
                "last_commit": tmp_info["meta"].get("commitDate", ""),
            }
        command = ["nix-prefetch-github", *d["id"].split("/"), "--json", "--meta"]
        print('"' + d["id"] + '"')
        result = (Utils.capture(command))
        print(result)
        result = json.loads(result)
        return d | {
            "rev": result["src"]["rev"],
            "hash": result["src"]["hash"],
            "last_commit": result["meta"].get("commitDate", ""),
        }
    except Exception as e:
        print(e)
        return d
        
    
nix_data = list(map(fix_data, nix_data))
Utils.write_json(nix_data, nn)

#  nix run nixpkgs#nix-prefetch-github -- Sharonex edit-list.nvim --json --meta --rev '01e5a827684140ccd20ec249e74da91115dc8c39'
#  nix-prefetch-github-directory --directory edit-list.nvim --json --meta
#  nix-prefetch-git https://gitlab.com/gitlab-org/editor-extensions/gitlab.vim
#
# nix run nixpkgs#nix-prefetch-github -- Sharonex edit-list.nvim --nix
# nix run nixpkgs#nix-prefetch-git -- --url https://codeberg.org/hernandez/dotdot.nvim
