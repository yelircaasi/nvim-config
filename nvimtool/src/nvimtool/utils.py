from adiumentum import (  # type: ignore
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
