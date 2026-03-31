from enum import StrEnum, auto
from pathlib import Path

type CommandList = list[str | Path | int | float]  # type: ignore
type DictList = list[dict[str, str]]  # type: ignore
type LuaTable = dict[str, str] | dict[str, list[str]] | dict[int, dict[int, set[str]]]  # type: ignore


class ToolGroup(StrEnum):
    REQUIRED = auto()
    OPTIONAL = auto()
    DISABLED = auto()


class InstallStatus(StrEnum):
    SUCCESS = auto()
    ERROR = auto()
    NO_OP = auto()


class GitSource(StrEnum):
    GH = auto()
    CB = auto()
    GL = auto()
    NONE = ""
