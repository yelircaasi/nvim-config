from pathlib import Path

from random import randint
import re
import subprocess

from ..config import Config
from ..datamodels import (
    RTPDict,
)
from ..patterns import Patterns
from ..utils import (
    join_filtered,
    safe_search,
    safe_search_group1,
    split_blocks,
)


def profile_startup(cfg: Config):
    """
    Requires vim-startuptime; run:

        `go install github.com/rhysd/vim-startuptime@latest`
    """
    config = (
        ("-u", cfg.paths.nvim_config_init) if cfg.paths.nvim_config_init else tuple()
    )
    name_segments = join_filtered(
        "--", ("startup", cfg.g.DEVICE_NAME, cfg.g.CONFIG_NAME)
    )
    destination = cfg.paths.info_dir / f"nvim-{name_segments}.txt"
    config = (
        ("--", "-u", cfg.paths.nvim_config_init)
        if cfg.paths.nvim_config_init
        else tuple()
    )
    _cmd = [
        "vim-startuptime",
        "-vimpath",
        cfg.g.NVIM_COMMAND,
        *config,
    ]
    cmd: list[str] = list(map(str, _cmd))
    print(" ".join(cmd))
    output = bytes.decode(subprocess.run(cmd, capture_output=True).stdout)
    destination.write_text(str(output))
    return destination


def parse_colors(raw: str) -> dict[str, dict[str, str]]:
    c = {}
    blocks = split_blocks(raw)
    for block in blocks:
        result = re.search(Patterns.COLOR_PATTERN, block)
        if result:
            gd = result.groupdict()
            gd |= safe_search(Patterns.COLOR_BODY_PATTERN, gd["body"] or "")
            c.update({gd["name"]: {key: gd[key] for key in Patterns.COLOR_KEYS}})

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
        result = re.search(Patterns.MAPPING_PATTERN, block)
        if result:
            gd = result.groupdict()
            mode = gd["mode"]
            keybind_modified = mode + "::" + gd["keybind"]
            
            if keybind_modified in m:
                if m[keybind_modified]:
                    suffix = gd["description"] or randint(0, 1000)
                    keybind_modified = f"{keybind_modified}__{suffix}"
            m.update({keybind_modified: {key: gd[key] for key in Patterns.MAPPING_KEYS}})
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
        result = re.search(Patterns.COMMAND_PATTERN, block)
        if result:
            gd = result.groupdict()
            c.update({gd["name"]: {key: gd[key] for key in Patterns.COMMAND_KEYS}})
        else:
            print(block)

    return c


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
            contents: list[str] = (
                list(map(str, _path.iterdir())) if _path.exists() else ["NONEXISTENT"]
            )
            r["contents"].update({path: contents})

    return r
