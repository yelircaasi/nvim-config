from adiumentum import (  # type: ignore
    BaseModelRW,
    Colorizer,
    JsonContainer,
    JsonObject,
    JsonValue,
    Version,
    run,
    capture,
    run_with_result,
    read_json,
    read_jsonc,
    write_json,
)
from dataclasses import dataclass
import json
import os
from pathlib import Path
from enum import StrEnum, auto
import re
import subprocess
from datetime import date, datetime, timedelta
import shutil

from typing import Mapping, Sequence, TypeVar, cast

import argparse
from typing import Any, Callable, Final, Iterable, Literal, NotRequired, Self, TypedDict

from pydantic import BaseModel  # type: ignore



class PluginSpec(BaseModel):
    ...



class PluginData(BaseList[PluginSpec]):
    ...


class NvimtoolConfig(TypedDict): ...


type CommandList = list[str | Path | int | float]

type LuaTable = dict[str, str] | dict[str, list[str]] | dict[int, dict[int, set[str]]]
type PluginSpecData = Sequence[PluginSpecDict]
type PluginLockTable = Mapping[str, PluginLockData | None]
type ExternalToolSpecData = list[ExternalToolSpec]

T = TypeVar("T", bound=JsonValue | Path)


class Utils:
    @staticmethod
    def printv(msg: Any) -> None:
        if Globals.VERBOSE:
            print(str(msg))

    @staticmethod
    def resolve_path(envvar: str, fallback: str) -> Path:
        from_var: str | None = os.environ.get(envvar)
        path: Path = Path(from_var or (Path.home() / fallback))
        path.mkdir(exist_ok=True)
        return path

    @staticmethod
    def write_json(obj: JsonContainer, path: Path) -> None:
        raw = json.dumps(obj, ensure_ascii=False, indent=4)
        path.write_text(raw)

    @staticmethod
    def read_json(path: Path) -> JsonContainer:
        return cast(JsonContainer, json.loads(path.read_text()))

    @staticmethod
    def get_commit_info(path: Path) -> tuple[str, str]:
        if not (path / ".git").is_dir():
            return "AAAAAAAAAAAAAAAA", "1970-01-01"
        command_list = ["git", "-C", str(path), "log", "-1", "--format='%H %cI'"]
        output = subprocess.check_output(command_list).decode().strip()
        sha, date = output.split()
        return sha[1:], date[:10]

    @staticmethod
    def get_executable_and_version(name: str, subcommand: str | None = None) -> tuple[str, str]:
        executable = capture(["which", name])

        if not executable:
            return "", ""

        output = capture([executable, subcommand or "--version"])
        search = re.search(r"\bv?([\d\.]+)\b", output)
        return executable, (search.group(1) if search else "")

    @staticmethod
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

    @staticmethod
    def read_config(path: Path) -> dict[str, str | Path]:
        if not path.exists():
            return {}
        d = cast(dict[str, str | Path], read_jsonc(path))
        for k in ("config-source", "config-target", "plugin-dir"):
            d[k] = Path(d[k]).resolve()
        return d

    @staticmethod
    def get_last_date(globals: type["Globals"]) -> str:
        delta = timedelta(days=cast(int, Globals.CONFIG.get("update-window", 30)))
        return str(date.today() - delta)

    @staticmethod
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
                v_formatted = Utils.write_table(v, indent=indent + 1, head="", foot="")
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


class Globals:
    DEFAULT_CONFIG_SOURCE: Final[Path] = Utils.resolve_path("XDG_CONFIG_HOME", "repos/nvim-config/testing")
    DEFAULT_CONFIG_TARGET: Final[Path] = Utils.resolve_path("XDG_CONFIG_HOME", ".config/nvim")
    DEFAULT_PLUGIN_DIR: Final[Path] = Path.home() / ".local/share/nvim-plugins"
    IS_NIX: Final[bool] = Path("/nix/store").exists()
    TODAY: Final[str] = str(date.today())
    VERBOSE = False
    CONFIG: dict[str, Path | int | str] = {
        "config-source": Path("~/repos/nvim-config/testing").resolve(),
        "config-target": Path("~/.config/nvim").resolve(),
        "plugin-dir": Path("~/local/share/nvim-plugins").resolve(),
        "update-window": 30,
    }


### TYPES ##############################################################################################################


class PluginSpecDict(TypedDict):
    name: str
    id: str
    source: Literal["gh", "gl", "cb"]
    lazy: bool
    layer: int
    sublayer: NotRequired[int]
    deps: NotRequired[list[str]]
    notes: NotRequired[str]
    category: str

    dir_name: NotRequired[str | None]
    custom_url: NotRequired[str | None]
    version: NotRequired[str | None]
    sha: NotRequired[str | None]
    build: str | None


class PluginLockData(TypedDict):
    url: str
    sha: str
    last_update: str
    location: str
    recency: str
    version: str | None


class Category(StrEnum):
    TRYING = auto()
    SELECTED = auto()
    NEXT = auto()
    SOONER = auto()
    LATER_A = "laterA"
    LATER_B = "laterB"
    LATER_C = "laterC"
    LATER = "later"
    LANG = auto()

    def __str__(self) -> str:
        return f"Category.{self.name}"

    @property
    def included(self) -> bool:
        return self in {
            self.TRYING,
            self.SELECTED,
            self.NEXT,
            self.SOONER,
        }


class ExternalToolSpec(TypedDict):
    executable: str
    version_subcommand: NotRequired[str]
    version_constraints: NotRequired[str]
    install_command: NotRequired[str]
    description: NotRequired[str]


class ExternalToolLockData(TypedDict): ...


def _make_backup_dir() -> Path:
    cache = Path.home() / ".cache/nvim_backups"
    timestamp = datetime.now().replace(microsecond=0).isoformat().replace("T", "__")
    _backup_dir = cache / timestamp
    _backup_dir.parent.mkdir(exist_ok=True)
    _backup_dir.mkdir()
    return _backup_dir


class Paths(BaseModelRW):
    config_source: Path
    config_destination: Path = Path.home() / ".config/nvim"
    plugin_dir: Path = Path.home() / ".local/share/nvim-plugins"
    _cache_dir: Path | None = None
    _declarations_dir: Path | None = None
    _tl_dir: Path | None = None
    _plugins_jsonc: Path | None = None
    _plugins_lock: Path | None = None
    _snapshot_dir: Path | None = None
    backup_dir: Path = _make_backup_dir()
    _scripts_dir: Path | None = None
    home: Path = Path.home()

    @classmethod
    def from_json(cls, json_file: Path) -> Self:
        d = cast(dict[str, str], read_jsonc(json_file))
        return cls(
            config_source=Path(d.get("config-source", "~/repos/nvim-config/testing")).resolve(),
            config_destination=Path(d.get("config-target", "~/.config/nvim/trial")).resolve(),
            plugin_dir=Path(d.get("plugin-dir", "~/local/share/nvim-plugins")).resolve(),
        )

    @property
    def scripts_dir(self) -> Path:
        return self._scripts_dir or (self.config_source / "scripts")

    @property
    def declarations_dir(self) -> Path:
        return self._declarations_dir or (self.config_source / "declarations")

    @property
    def tl_dir(self) -> Path:
        return self._tl_dir or (self.config_source / "teal")

    @property
    def tl_src_dir(self) -> Path:
        return self.tl_dir / "src"

    @property
    def tl_build_dir(self) -> Path:
        return self.tl_dir / "build"

    @property
    def tl_meta_dir(self) -> Path:
        return self.tl_dir / "src/meta"

    @property
    def plugins_jsonc(self) -> Path:
        return self._plugins_jsonc or (self.declarations_dir / "plugins.jsonc")

    @property
    def snapshot_dir(self) -> Path:
        return self._snapshot_dir or (self.config_source / "snapshots")

    @property
    def dependencies_tl(self) -> Path:
        return self.tl_meta_dir / "dependencies.tl"

    @property
    def plugin_layers_tl(self) -> Path:
        return self.tl_meta_dir / "plugin_layers.tl"

    @property
    def external_tools_lock(self) -> Path:
        return self.snapshot_dir / "external-tools-lock.json"

    @property
    def available_updates(self) -> Path:
        return self.snapshot_dir / "available-updates.json"

    @property
    def plugins_lock(self) -> Path:
        return self._plugins_lock or (self.snapshot_dir / "plugins-lock.json")

    @property
    def plugin_paths_tl(self) -> Path:
        return self.tl_meta_dir / "plugin_paths.tl"

    @property
    def external_tools_tl(self) -> Path:
        return self.tl_meta_dir / "external_tools.tl"

    @property
    def external_tools_declaration(self) -> Path:
        return self.declarations_dir / "external-tools.jsonc"

    @property
    def plugins_declaration(self) -> Path:
        return self.declarations_dir / "plugins.jsonc"

    @property
    def cleanup_lua(self) -> Path:
        return self.scripts_dir / "cleanup.lua"

    def __post_init__(self) -> None:
        if not self.config_source.exists():
            raise OSError(f"Nonexistent path: {self.config_source}")
        self._ensure_exists(self.plugin_dir)
        self._ensure_exists(self.config_destination)
        self._ensure_exists(self.tl_dir)
        self._ensure_exists(self.tl_meta_dir.parent)
        self._ensure_exists(self.tl_meta_dir)
        self._ensure_exists(self.declarations_dir)
        self._ensure_exists(self.backup_dir)

    @staticmethod
    def _ensure_exists(path: Path) -> None:
        if not path.exists():
            path.mkdir()

    @classmethod
    def from_args(cls, args: argparse.Namespace, cfg: dict | None = {}) -> Self:
        argdict = args.__dict__
        cfg = cfg or {}
        return cls(
            config_source=args.config_source or cfg.get("config-source") or Globals.DEFAULT_CONFIG_SOURCE,
            config_destination=args.config_target or cfg.get("config-target") or Globals.DEFAULT_CONFIG_TARGET,
            plugin_dir=args.plugin_dir or cfg.get("plugin-dir") or Globals.DEFAULT_PLUGIN_DIR,
            _plugins_jsonc=argdict.get("plugins_jsonc"),
            _plugins_lock=argdict.get("lockfile"),
        )

    def __str__(self) -> str:
        return repr(self)

    def __repr__(self) -> str:
        return f"""Paths(
    config_source:              {self.rel(self.config_source)}
    config_destination:         {self.rel(self.config_destination)}
    plugin_dir:                {self.rel(self.plugin_dir)}
    backup_dir:                 {self.rel(self.backup_dir)}

    external_tools_declaration: {self.rel(self.external_tools_declaration)}
    plugins_declaration:        {self.rel(self.plugins_declaration)}
    plugin_layers_tl:           {self.rel(self.plugin_layers_tl)}
    plugin_paths_tl:            {self.rel(self.plugin_paths_tl)}
    dependencies_tl:            {self.rel(self.dependencies_tl)}
    external_tools_tl:          {self.rel(self.external_tools_tl)}

    external_tools_lock:        {self.rel(self.external_tools_lock)}
    plugins_lock:               {self.rel(self.plugins_lock)}
    updates:                    {self.rel(self.available_updates)}

    cleanup_lua:                {self.rel(self.cleanup_lua)}
)"""

    def rel(self, p: str | Path | None) -> str:
        if not isinstance(p, str | Path):
            return ""
        path = Path(p)
        if not path.is_relative_to(self.home):
            return str(p)
        return f"~/{path.relative_to(self.home)}"


# paths = Paths(config_source=Path.home() / "repos/nvim-config/testing")


### HELPER FUNCTIONS ###################################################################################################


class ToolGroup(StrEnum):
    REQUIRED = auto()
    OPTIONAL = auto()
    DISABLED = auto()


class InstallStatus(StrEnum):
    SUCCESS = auto()
    ERROR = auto()
    NO_OP = auto()


class Source(StrEnum):
    GH = auto()
    CB = auto()
    GL = auto()
    NONE = ""


class Spec(BaseModelRW):
    name: str
    id: str
    source: Source
    category: Category
    lazy: bool = True
    dir_name: str | None = None
    custom_url: str | None = None
    version: str | None = None
    sha: str | None = None
    deps: tuple[str, ...] = tuple()
    build: str | None = None
    notes: str | None = None

    @property
    def url(self) -> str:
        return self.custom_url or f"{self.url_base}{self.id}"

    @property
    def url_base(self) -> str:
        return {
            Source.GH: "https://github.com/",
            Source.GL: "https://gitlab.com/",
            Source.CB: "https://codeberg.org/",
        }.get(self.source, "")

    @property
    def destination(self) -> str:
        return self.dir_name or self.name

    @classmethod
    def from_dict(cls, spec_dict: PluginSpecDict) -> Self:
        try:
            return cls(
                id=spec_dict["id"],
                name=spec_dict["name"],
                source=Source[spec_dict["source"].upper() or "NONE"],
                lazy=spec_dict["lazy"],
                category=Category(spec_dict["category"]),
                dir_name=spec_dict.get("dir_name"),
                custom_url=spec_dict.get("custom_url"),
                sha=spec_dict.get("sha"),
                version=spec_dict.get("version"),
                deps=tuple(spec_dict.get("deps", tuple())),
                build=spec_dict.get("build"),
                notes=spec_dict.get("notes"),
            )
        except Exception as e:
            print(spec_dict)
            raise e
