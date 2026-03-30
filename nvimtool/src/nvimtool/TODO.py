import json
import os
import re
import sys
import socket
import subprocess
from pathlib import Path
from typing import TypedDict


def arg_or_envvar(argpos: int, envvarname: str, fallback: str | Path) -> str:
    if len(sys.argv) > argpos:
        return sys.argv[argpos]
    return os.getenv(envvarname) or str(fallback)


DEVICE_NAME = arg_or_envvar(1, "DEVICE_NAME", socket.gethostname())
CONFIG_NAME = arg_or_envvar(2, "NVIM_CONFIG_NAME", "DEFAULT")
CONFIG_PATH = arg_or_envvar(3, "NVIM_CONFIG_PATH", "")
WRITE_DIR = Path(arg_or_envvar(4, "NVIM_INFO_PATH", Path.home() / "repos/nvim-config/info"))
NVIM_COMMAND = arg_or_envvar(5, "NVIM_COMMAND", "nvim")


def export_info(task: str) -> Path:
    name_segments = "--".join(filter(bool, (task, DEVICE_NAME, CONFIG_NAME)))
    destination = WRITE_DIR / f"nvim-{name_segments}.txt"
    print(destination)
    # os.system(f'nvim --headless -c "set columns=1000" -c "redir! > {destination}"   -c "verbose {task}"  -c "redir END" -c "q" > /dev/null')
    main_command = "lua print(vim.inspect(vim.opt.rtp))" if task == "rtp" else f"verbose {task}"
    config = ("-u", CONFIG_PATH) if CONFIG_PATH else tuple()
    cmd = [
        NVIM_COMMAND,
        *config,
        "--headless",
        "-c",
        "set columns=1000",
        "-c",
        f"redir! > {destination}",
        "-c",
        main_command,
        "-c",
        "redir END",
        "-c",
        "q",
    ]
    cmd = list(map(str, cmd))
    print(" ".join(cmd))
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return destination


def profile_startup():
    """
    Requires vim-startuptime; run:

        `go install github.com/rhysd/vim-startuptime@latest`
    """
    config = ("-u", CONFIG_PATH) if CONFIG_PATH else tuple()
    name_segments = "--".join(filter(bool, ("startup", DEVICE_NAME, CONFIG_NAME)))
    destination = WRITE_DIR / f"nvim-{name_segments}.txt"
    config = ("--", "-u", CONFIG_PATH) if CONFIG_PATH else tuple()
    cmd = [
        "vim-startuptime",
        "-vimpath",
        NVIM_COMMAND,
        *config,
    ]
    cmd = list(map(str, cmd))
    print(" ".join(cmd))
    output = bytes.decode(subprocess.run(cmd, capture_output=True).stdout)
    destination.write_text(str(output))
    return destination


colors_txt = export_info("highlight")
mappings_txt = export_info("map")
commands_txt = export_info("command")
rtp_txt = export_info("rtp")
startup_txt = profile_startup()

colors_json, mappings_json, commands_json, rtp_json = map(
    lambda s: s.parent / re.sub(r"\.txt|\.lua", ".json", s.name),
    (colors_txt, mappings_txt, commands_txt, rtp_txt),
)


BLOCK_SPLITTER = re.compile(r"\n(?=[^\s])")
COLOR_PATTERN = re.compile(
    (
        r"^(?P<name>[^ ]+)\s+xxx\s+"
        r"(?P<body>[^\n]+)"
        r"(\n\s+(?P<note>[^\s][^\n]+))?"
    ),
    re.MULTILINE,
)
COLOR_BODY_PATTERN = re.compile(
    (
        r"(cterm=(?P<cterm>[^\s]+)\s*)?"
        r"(ctermfg=(?P<ctermfg>[^\s]+)\s*)?"
        r"(ctermbg=(?P<ctermbg>[^\s]+)\s*)?"
        r"(gui=(?P<gui>[^\s]+)\s*)?"
        r"(guifg=(?P<guifg>[^\s]+)\s*)?"
        r"(guibg=(?P<guibg>[^\s]+)\s*)?"
        r"(guisp=(?P<guisp>[^\s]+)\s*)?"
        r"(font=(?P<font>[^\s]+|'[^']+?'])\s*)?"
        r"(blend=(?P<blend>[^\s]+)\s*)?"
        r"(start=(?P<start>[^\s]+)\s*)?"
        r"(stop=(?P<stop>[^\s]+)\s*)?"
        r"(links to (?P<linksTo>[^\s]+)\s*)?"
    )
)
COLOR_KEYS = (
    "linksTo",
    "note",
    "cterm",
    "ctermfg",
    "ctermbg",
    "gui",
    "guifg",
    "guibg",
    "guisp",
    "font",
    "blend",
    "start",
    "stop",
)
COMMAND_PATTERN = re.compile(
    (
        r"^(?P<annotation>[^ ]+)"
        r" +(?P<name>[A-Za-z]+ [A-Za-z]+|[^ ]+)"
        r" +(?P<args>[\d+\?\+\*]+)"
        r"( +(?P<address>[0\.%clb]+(?: {0,2}\?)?))?"
        r"( +(?P<complete><Lua function>|[a-z_]+))?"
        r" +(?P<definition>(?:call|:call|<Lua|lua)[^\n]+)"
        r"(\n?\t\t+\s*(?P<description>[^\n]+))?"
    )
)
COMMAND_KEYS = (
    "annotation",
    "name",
    "args",
    "address",
    "complete",
    "definition",
    "description",
)
MAPPING_PATTERN = re.compile(
    (
        r"^(?P<mode>[^ ]+)"
        r" +(?P<keybind>[^ ]+)"
        r"( +(?P<annotation>\*))?"
        r"( +(?P<definition>[^\n]+))?"
        r"(\n {5,}(?P<description>[^\n]+))?"
        r"\n\s+(?P<origin>Last set [^\n]+)"
    )
)
MAPPING_KEYS = (
    "mode",
    "keybind",
    "annotation",
    "definition",
    "description",
    "origin",
)


def split_blocks(s: str) -> list[str]:
    return re.split(BLOCK_SPLITTER, s)


def safe_search(p: re.Pattern[str], s: str) -> dict[str, str]:
    result = re.search(p, s)
    if not result:
        return {}
    return result.groupdict()


def parse_colors(raw: str) -> dict[str, dict[str, str]]:
    c = {}
    blocks = split_blocks(raw)
    for block in blocks:
        result = re.search(COLOR_PATTERN, block)
        if result:
            gd = result.groupdict()
            gd |= safe_search(COLOR_BODY_PATTERN, gd["body"] or "")
            c.update({gd["name"]: {key: gd[key] for key in COLOR_KEYS}})

        else:
            print(block)

    return c


def parse_mappings(raw: str) -> dict[str, dict[str, str]]:
    m = {}

    raw = re.sub(r"\tLast set ", "\t\tLast set ", raw)
    # print(raw[:500])

    blocks = split_blocks(raw)[1:]
    # print(raw)

    for block in blocks:
        result = re.search(MAPPING_PATTERN, block)
        if result:
            gd = result.groupdict()
            m.update({gd["keybind"]: {key: gd[key] for key in MAPPING_KEYS}})
        else:
            print(block)

    return m


def parse_commands(raw: str) -> dict[str, dict[str, str]]:
    c = {}

    raw = re.sub(r"\n?\tLast set ", "\n\t\tLast set ", raw)
    raw = re.sub("\n?    Name", " Name", raw)
    raw = re.sub("\n            ", "\n\t\t\t", raw)
    raw = re.sub(r"\n    ", "\n_   ", raw)

    blocks = split_blocks(raw)[1:]

    for block in blocks:
        result = re.search(COMMAND_PATTERN, block)
        if result:
            gd = result.groupdict()
            c.update({gd["name"]: {key: gd[key] for key in COMMAND_KEYS}})
        else:
            print(block)

    return c


def safe_search_group1(p: re.Pattern[str] | str, s: str, optional: bool = False) -> str:
    p = re.compile(p) if isinstance(p, str) else p
    if not (result := re.search(p, s)):
        if not optional:
            raise ValueError(f"{p} not found in {s}")
        return ""
    return result.group(1)


class RTPDict(TypedDict):
    default: list[str]
    value: list[str]
    contents: dict[str, list[str]]


def parse_rtp(raw: str) -> RTPDict:
    r: RTPDict = {"default": [], "value": [], "contents": {}}

    default = safe_search_group1(r'default = "([^\n]+)",', raw)
    print(default)
    r["default"] = default.split(",")

    value = safe_search_group1(r'_value = "([^\n]+)",', raw)
    print(default)
    r["value"] = value.split(",")

    r["contents"] = {}
    for path in r["default"] + r["value"]:
        if path not in r["contents"]:
            _path = Path(path)
            contents: list[str] = list(map(str, _path.iterdir())) if _path.exists() else ["NONEXISTENT"]
            r["contents"].update({path: contents})

    return r


colors_raw = colors_txt.read_text()
mappings_raw = mappings_txt.read_text()
commands_raw = commands_txt.read_text()
rtp_raw = rtp_txt.read_text()

colors = parse_colors(colors_raw)
mappings = parse_mappings(mappings_raw)
commands = parse_commands(commands_raw)
rtp = parse_rtp(rtp_raw)

colors_json.write_text(json.dumps(colors, indent=4))
mappings_json.write_text(json.dumps(mappings, indent=4))
commands_json.write_text(json.dumps(commands, indent=4))
rtp_json.write_text(json.dumps(rtp, indent=4))

config = f"""
{DEVICE_NAME=}
NVIM_{CONFIG_NAME=}
NVIM_{CONFIG_PATH=}
NVIM_WRITE_DIR={WRITE_DIR!s}
NVIM_{NVIM_COMMAND=}

hostname: {socket.gethostname()}
"""
config_file = WRITE_DIR / f"config--{DEVICE_NAME}--{CONFIG_NAME}.txt"
config_file.write_text(config)




# ======================================================================================================================

from pathlib import Path
from typing import cast

from adiumentum import read_json

from .datamodels import Source

lbrace = "{"
rbrace = "}"
indent_size = 2
level0 = ""
level1 = " " * 1 * indent_size
level2 = " " * 2 * indent_size
level3 = " " * 3 * indent_size
level4 = " " * 4 * indent_size

nn = Path.home() / ("repos/nvim-config/testing/declarations/nix-info.json")
result = Path.home() / ("repos/nvim-config/testing/snapshots/nvim-plugins.nix")
flake = Path.home() / ("repos/nvim-config/testing/snapshots/flake.nix")

plugin_expr_template = """{name} = pkgs.vimUtils.buildVimPlugin {lbrace}
        pname = "{nix_name}";
        version = "{version}";
        src = pkgs.fetchgit {lbrace}
          url = "{url}";
          rev = "{rev}";
          hash = "{nix_hash}";
        {rbrace};
        doCheck = false;
        meta = {lbrace}
          homepage = "{url}";
          description = "";
        {rbrace};
      {rbrace};"""


plugin_expr_template_gh = """{name} = pkgs.vimUtils.buildVimPlugin {lbrace}
        pname = "{nix_name}";
        version = "{version}";
        src = pkgs.fetchFromGitHub {lbrace}
          owner = "{owner}";
          repo = "{repo}";
          rev = "{rev}";
          hash = "{nix_hash}";
        {rbrace};
        doCheck = false;
        meta = {lbrace}
          homepage = "{url}";
          description = "";
        {rbrace};
      {rbrace};"""


def make_expression(d: dict) -> str:
    try:
        source = Source(d["source"])
        base = {
            Source.GH: "https://github.com",
            Source.GL: "https://gitlab.com",
            Source.CB: "https://codeberg.org",
        }.get(source, "")
        if d["source"] == "gh":
            template = plugin_expr_template_gh
            owner, repo = d["id"].split("/")
        else:
            template = plugin_expr_template
            owner, repo = "", ""

        ret = template.format(
            name=d["name"],
            nix_name=d["nixName"],
            version=d.get("last_commit", "1970-01-01"),
            url="/".join((base, d["id"])).strip("/"),
            rev=d["rev"],
            nix_hash=d["hash"],
            lbrace="{",
            rbrace="}",
            owner=owner,
            repo=repo,
        )
        # print(ret)
        return ret
    except Exception as e:
        print(e)
        print(d)
        raise e


def make_name(d: dict) -> str:
    attrset = d["attrset"]
    nix_name = d["nixName"]
    return f"{attrset}.{nix_name}"


def make_nixpkgs_set(d: dict) -> str:
    nix_name = d["nixName"] if d["attrset"] == "pkgs.vimPlugins" else f"{d['attrset']}.{d['nixName']}"
    return f'{lbrace}\n{level4}name = "{d["name"]}";\n{level4}path = {nix_name};\n{level3}{rbrace}'


nix_data = cast(list[dict], read_json(nn))
custom_data = [d for d in nix_data if d.get("attrset", "").startswith("custom")]
nixpkgs_data = [d for d in nix_data if d.get("attrset", "").startswith("pkgs")]
other_data = [d for d in nix_data if (d not in custom_data) and (d not in nixpkgs_data)]
print(other_data)
custom = "\n      ".join(map(make_expression, custom_data))
nixpkgs_list = "\n      ".join(map(make_nixpkgs_set, nixpkgs_data))
# file_contents = (
#     "{pkgs, lib}:\nlet custom = {\n    "
#     f'{custom}'
#     "\n}; in {\n"
#     "    # config to go here\n}"
# )

# result.write_text(file_contents)

flake_nix = (
    """{
  description = "nvim plugins bundled in a single directory using linkFarm";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    customPlugins = {
      """
    + custom
    + r"""
    };

    customList =
      pkgs.lib.attrsets.mapAttrsToList (_name: package: {
        name = _name;
        path = package;
      })
      customPlugins;

    nixpkgsList = with pkgs.vimPlugins; [
      """
    + nixpkgs_list
    + r"""
    ];

    fullList = customList ++ nixpkgsList;

    pluginMeta =
      map (p: {
        name = p.name;
        path = "${p.path}";
        rev = p.path.src.rev or "unknown";
        version = p.path.version or "unknown";
      })
      fullList;

    jsonFile = builtins.toJSON (
      builtins.listToAttrs (map (m: {
          name = m.name;
          value = {
            inherit (m) name path rev version;
          };
        })
        pluginMeta)
    );

    luaFile =
      ''
        -- Auto-generated by Nix, do not edit.
        return {
      ''
      + pkgs.lib.concatMapStrings (m: ''
        ["${m.name}"] = {
          path    = "${m.path}",
          rev     = "${m.rev}",
          version = "${m.version}",
        },
      '')
      pluginMeta
      + ''
        }
      '';

    nvimPlugins = pkgs.runCommand "nvim-plugins" {} ''
      cp -r ${pkgs.linkFarm "nvim-plugins" fullList} $out
      chmod -R u+w $out

      # Add meta files
      mkdir -p $out/meta

      cat > $out/meta/plugin_paths.lua << 'EOF'
      ${luaFile}
      EOF

      ${pkgs.stylua}/bin/stylua $out/meta/plugin_paths.lua

      cat > $out/meta/plugin_paths.json << 'EOF'
      ${jsonFile}
      EOF

      ${pkgs.python3}/bin/python3 -m json.tool --indent 4 $out/meta/plugin_paths.json > $out/meta/tmp.json
      mv $out/meta/tmp.json $out/meta/plugin_paths.json
    '';
  in {
    packages.${system} = {
      inherit nvimPlugins;
      default = nvimPlugins;
      json = jsonFile;
      lua = luaFile;
    };
  };
}
"""
)

flake.write_text(
    flake_nix,
)

# tmp: dict = cast(dict, Utils.read_json(Path("/home/isaac/repos/nvim-config/testing/tmp.json")))

# def fetch_hashes(d: dict) -> dict:
#     if d["source"] != "gh":
#         return d
#     if d["hash"]:
#         return d
#     try:
#         if d["id"] in tmp:
#             tmp_info = tmp[d["id"]]
#             return d | {
#                 "rev": tmp_info["src"]["rev"],
#                 "hash": tmp_info["src"]["hash"],
#                 "last_commit": tmp_info["meta"].get("commitDate", ""),
#             }
#         command = ["nix-prefetch-github", *d["id"].split("/"), "--json", "--meta"]
#         print('"' + d["id"] + '"')
#         result = (Utils.capture(command))
#         print(result)
#         result = json.loads(result)
#         return d | {
#             "rev": result["src"]["rev"],
#             "hash": result["src"]["hash"],
#             "last_commit": result["meta"].get("commitDate", ""),
#         }
#     except Exception as e:
#         print(e)
#         return d


# nix_data = list(map(fetch_hashes, nix_data))
# Utils.write_json(nix_data, nn)

#  nix run nixpkgs#nix-prefetch-github -- Sharonex edit-list.nvim --json --meta --rev '01e5a827684140ccd20ec249e74da91115dc8c39'
#  nix-prefetch-github-directory --directory edit-list.nvim --json --meta
#  nix-prefetch-git https://gitlab.com/gitlab-org/editor-extensions/gitlab.vim
#
# nix run nixpkgs#nix-prefetch-github -- Sharonex edit-list.nvim --nix
# nix run nixpkgs#nix-prefetch-git -- --url https://codeberg.org/hernandez/dotdot.nvim
