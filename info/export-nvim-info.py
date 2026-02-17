import json
import os
import re
import sys
import socket
import subprocess
from pathlib import Path


def arg_or_envvar(argpos: int, envvarname: str, fallback: str | Path) -> str:
    try:
        return sys.argv[argpos]
    except:
        return os.getenv(envvarname) or fallback

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


def parse_colors(raw: str) -> dict[str, dict[str, str]]:
    c = {}
    blocks = split_blocks(raw)
    for block in blocks:
        result = re.search(COLOR_PATTERN, block)
        if result:
            gd = result.groupdict()
            gd |= re.search(COLOR_BODY_PATTERN, gd["body"] or "").groupdict()
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
    # print(raw[:500])

    blocks = split_blocks(raw)[1:]
    # print(raw)

    for block in blocks:
        result = re.search(COMMAND_PATTERN, block)
        if result:
            gd = result.groupdict()
            c.update({gd["name"]: {key: gd[key] for key in COMMAND_KEYS}})
        else:
            print(block)

    return c


def parse_rtp(raw: str) -> dict[str, dict[str, str]]:
    r: dict[str, dict[str, str]] = {}

    default = re.search(r'default = "([^\n]+)",', raw).group(1)
    print(default)
    r["default"] = default.split(",")

    value = re.search(r'_value = "([^\n]+)",', raw).group(1)
    print(default)
    r["value"] = value.split(",")

    r["contents"] = {}
    for path in r["default"] + r["value"]:
        if path not in r["contents"]:
            _path = Path(path)
            contents = list(map(str, _path.iterdir())) if _path.exists() else "NONEXISTENT"
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
