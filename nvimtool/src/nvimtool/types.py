from pathlib import Path

type CommandList = list[str | Path | int | float]  # type: ignore
type DictList = list[dict[str, str]]  # type: ignore
type LuaTable = dict[str, str] | dict[str, list[str]] | dict[int, dict[int, set[str]]]  # type: ignore
