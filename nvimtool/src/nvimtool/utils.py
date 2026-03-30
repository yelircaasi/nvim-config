import sys
from adiumentum import (
    Colorizer,
    JsonContainer,
    JsonValue,
    run,
    capture,
)
import json
import os
from pathlib import Path
import re
import subprocess
from datetime import date, timedelta

from typing import TypeVar, cast

from typing import Iterable


from .config import Config
from .datamodels import CommandList, LuaTable
from .patterns import Patterns

color = Colorizer()


T = TypeVar("T", bound=JsonValue | Path)


def resolve_path(envvar: str, fallback: str) -> Path:
    from_var: str | None = os.environ.get(envvar)
    path: Path = Path(from_var or (Path.home() / fallback))
    path.mkdir(exist_ok=True)
    return path


def write_json(obj: JsonContainer, path: Path) -> None:
    raw = json.dumps(obj, ensure_ascii=False, indent=4)
    path.write_text(raw)


def get_commit_info(path: Path) -> tuple[str, str]:
    if not (path / ".git").is_dir():
        return "AAAAAAAAAAAAAAAA", "1970-01-01"
    command_list = ["git", "-C", str(path), "log", "-1", "--format='%H %cI'"]
    output = subprocess.check_output(command_list).decode().strip()
    sha, date = output.split()
    return sha[1:], date[:10]


def get_executable_and_version(
    name: str, subcommand: str | None = None
) -> tuple[str, str]:
    executable = capture(["which", name])

    if not executable:
        return "", ""

    output = capture([executable, subcommand or "--version"])
    search = re.search(r"\bv?([\d\.]+)\b", output)
    return executable, (search.group(1) if search else "")


def check_for_updates(repo_path: Path) -> bool:
    if not (repo_path / ".git").exists():
        print(f"Not a git directory: {repo_path}.")
        return False
    fetch_command: CommandList = [
        "git",
        "-C",
        repo_path,
        "fetch",
        "--dry-run",
        "origin",
    ]
    diff_command: CommandList = [
        "git",
        "-C",
        repo_path,
        "log",
        "HEAD..origin/HEAD",
        "--oneline",
    ]
    run(fetch_command)
    output = capture(diff_command)
    if output:
        print(output)
    return bool(output)


def get_last_date(cfg: Config) -> str:
    delta = timedelta(days=cast(int, cfg.g.CONFIG.get("update-window", 30)))
    return str(date.today() - delta)


def write_table(
    d: LuaTable,
    *,
    head: str,
    foot: str,
    indent: int = 1,
    include_empty: bool = False,
    bracket_all: bool = False,
    align: bool = False,
) -> str:
    d = cast(LuaTable, d if include_empty else {k: v for k, v in d.items() if v})

    max_len = (max(map(len, map(str, d.keys()))) + 4) if align else 0

    def _write_string_array(arr: Iterable[str]) -> str:
        return "".join(('{ "', '", "'.join(arr), '" }'))

    def _format_key(k: str | int) -> str:
        if isinstance(k, int | float):
            return f"[{k:>2}]"
        if (not bracket_all) and re.match(r"^[A-Za-z_]+$", k):
            return k
        return f'["{k}"]'

    def _make_line(t: tuple[str | int, str | Iterable[str] | dict]) -> str:
        k, v = t

        if isinstance(v, str | Path):
            v_formatted = f'"{v}"'
        elif isinstance(v, dict):
            v_formatted = write_table(v, indent=indent + 1, head="", foot="")
        else:
            v_formatted = _write_string_array(v)
        return f"{_format_key(k):<{max_len}} = {v_formatted}"

    indenter = "\t" * indent
    joiner = f",\n{indenter}"
    body = joiner.join(
        map(
            _make_line,
            cast(Iterable[tuple[str | int, str | Iterable[str] | dict]], d.items()),
        )
    )
    return head + "{\n" + indenter + body + f",\n{indenter[:-1]}}}" + foot


def arg_or_envvar(argpos: int, envvarname: str, fallback: str | Path) -> str:
    if len(sys.argv) > argpos:
        return sys.argv[argpos]
    return os.getenv(envvarname) or str(fallback)


def export_nvim_info(task: str, cfg: Config) -> Path:
    name_segments = "--".join(
        filter(bool, (task, cfg.g.DEVICE_NAME, cfg.g.CONFIG_NAME))
    )
    destination = cfg.paths.info_dir / f"nvim-{name_segments}.txt"
    print(destination)
    # os.system(f'nvim --headless -c "set columns=1000" -c "redir! > {destination}"   -c "verbose {task}"  -c "redir END" -c "q" > /dev/null')
    main_command = (
        "lua print(vim.inspect(vim.opt.rtp))" if task == "rtp" else f"verbose {task}"
    )
    config = (
        ("-u", str(cfg.paths.nvim_config_init))
        if cfg.paths.nvim_config_init
        else tuple()
    )
    cmd = [
        cfg.g.NVIM_COMMAND,
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


def safe_search_group1(p: re.Pattern[str] | str, s: str, optional: bool = False) -> str:
    p = re.compile(p) if isinstance(p, str) else p
    if not (result := re.search(p, s)):
        if not optional:
            raise ValueError(f"{p} not found in {s}")
        return ""
    return result.group(1)


def split_blocks(s: str) -> list[str]:
    return re.split(Patterns.BLOCK_SPLITTER, s)


def safe_search(p: re.Pattern[str], s: str) -> dict[str, str]:
    result = re.search(p, s)
    if not result:
        return {}
    return result.groupdict()


def change_extension(p: Path, new_extension: str) -> Path:
    name = re.sub(r"\.[^\.]+$", f".{new_extension}", p.name)
    return p.parent / name
