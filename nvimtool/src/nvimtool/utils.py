from pathlib import Path
import re
from datetime import date, timedelta

from typing import Callable, TypeVar, cast

from typing import Iterable

from adiumentum.types import JsonValue


from .config import Config
from .patterns import Patterns
from .types import LuaTable


T = TypeVar("T", bound=JsonValue | Path)


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


def get_last_date(cfg: Config) -> str:
    delta = timedelta(days=cast(int, cfg.update_window))
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


def join_filtered(
    sep: str, objects: Iterable[object], filtr: Callable[[object], bool] = bool
) -> str:
    return sep.join(map(str, filter(filtr, objects)))
