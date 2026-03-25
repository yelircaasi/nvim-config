from pathlib import Path
import json
from typing import cast

from nvimtool import Source, Utils

nn = Path("/Users/ext_riley/repos/nvim-config/testing/nix-names.json")
result = Path("/Users/ext_riley/repos/nvim-config/testing/nvim-plugins.nix")


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


# nix-prefetch --fetchurl --rev master --url 