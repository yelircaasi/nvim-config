import json
import re
import subprocess
from pathlib import Path

NOTES_DIR = Path.home() / ".config/nvim/notes"


def export_info(task: str) -> Path:
    destination = NOTES_DIR / f"nvim-{task}.txt"
    # os.system(f'nvim --headless -c "set columns=1000" -c "redir! > {destination}"   -c "verbose {task}"  -c "redir END" -c "q" > /dev/null')
    cmd = [
        "nvim",
        "--headless",
        "-c",
        "set columns=1000",
        "-c",
        f"redir! > {destination}",
        "-c",
        f"verbose {task}",
        "-c",
        "redir END",
        "-c",
        "q",
    ]
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    return destination


colors_txt = export_info("highlight")
mappings_txt = export_info("map")
commands_txt = export_info("command")

colors_json, mappings_json, commands_json = map(
    lambda s: s.parent / s.name.replace(".txt", ".json"),
    (colors_txt, mappings_txt, commands_txt),
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


colors_raw = colors_txt.read_text()
mappings_raw = mappings_txt.read_text()
commands_raw = commands_txt.read_text()

subprocess.run(["clear"])

colors = parse_colors(colors_raw)
mappings = parse_mappings(mappings_raw)
commands = parse_commands(commands_raw)

# print(json.dumps(commands, indent=4))

colors_json.write_text(json.dumps(colors, indent=4))
mappings_json.write_text(json.dumps(mappings, indent=4))
commands_json.write_text(json.dumps(commands, indent=4))

# print(commands_json)
