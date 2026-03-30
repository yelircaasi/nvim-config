from adiumentum import (  # type: ignore
    BaseModelRW,
    BaseDict,
    BaseList,
    Colorizer,
    JsonContainer,
    JsonValue,
    run,
    capture,
    read_jsonc,
    read_json,
)
import json
import os
from pathlib import Path
from enum import StrEnum, auto
import re
import subprocess
from datetime import date, datetime, timedelta

from typing import Annotated, TypeVar, cast

import argparse
from typing import Any, Final, Iterable, Self, TypedDict

from pydantic import BaseModel, Field  # type: ignore


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


color = Colorizer()


type DictList = list[dict[str, str]]


class SinglePluginSpec(BaseModel):
    layer: int
    sublayer: int
    sublayerName: str
    name: str
    description: str
    id: str
    source: Source
    lazy: bool
    category: str
    notes: str = Field(default="")
    nixName: str
    attrset: str
    rev: str
    hash: str
    lastCommit: Annotated[str, re.compile(r"\d{4}-\d\d?-\d\d?")]
    dir_name: str = Field(default="")
    custom_url: str = Field(default="")
    version: str = Field(default="")
    build: str = Field(default="")
    dependencies: list[str] = Field(default_factory=list)
    integrations: list[str] = Field(default_factory=list)
    commands: DictList
    functions: DictList
    keybinds: DictList
    highlightGroups: DictList

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


class PluginSpecs(BaseList[SinglePluginSpec]): ...


class NvimtoolConfig(TypedDict): ...


type CommandList = list[str | Path | int | float]

type LuaTable = dict[str, str] | dict[str, list[str]] | dict[int, dict[int, set[str]]]


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


# class PluginSpecDict(TypedDict):
#     name: str
#     id: str
#     source: Literal["gh", "gl", "cb"]
#     lazy: bool
#     layer: int
#     sublayer: NotRequired[int]
#     deps: NotRequired[list[str]]
#     notes: NotRequired[str]
#     category: str

#     dir_name: NotRequired[str | None]
#     custom_url: NotRequired[str | None]
#     version: NotRequired[str | None]
#     sha: NotRequired[str | None]
#     build: str | None


class SinglePluginLock(BaseModel):
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


class SingleToolSpec(BaseModel):
    executable: str
    version_subcommand: str = Field(default="")
    version_constraints: str = Field(default="")
    install_command: str = Field(default="")
    description: str = Field(default="")


class SingleToolLock(BaseModel):
    path: Path
    version: str


class ToolsLock(BaseDict[str, SingleToolLock]): ...


def _make_backup_dir() -> Path:
    cache = Path.home() / ".cache/nvim_backups"
    timestamp = datetime.now().replace(microsecond=0).isoformat().replace("T", "__")
    _backup_dir = cache / timestamp
    _backup_dir.parent.mkdir(exist_ok=True)
    _backup_dir.mkdir()
    return _backup_dir


_HOME = Path.home()
_BACKUP = _make_backup_dir()


class Paths(BaseModelRW):
    home: Path = Field(default=_HOME)
    config_source: Path
    config_destination: Path = Field(default=_HOME / ".config/nvim")
    plugin_dir: Path = Field(default=_HOME / ".local/share/nvim-plugins")
    explicit_declarations_dir: Path | None = Field(default=None)
    explicit_tl_dir: Path | None = Field(default=None)
    explicit_plugins_jsonc: Path | None = Field(default=None)
    explicit_plugins_lock: Path | None = Field(default=None)
    explicit_snapshot_dir: Path | None = Field(default=None)
    backup_dir: Path = Field(default=_BACKUP)
    explicit_scripts_dir: Path | None = Field(default=None)

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
        return self.explicit_scripts_dir or (self.config_source / "scripts")

    @property
    def declarations_dir(self) -> Path:
        return self.explicit_declarations_dir or (self.config_source / "declarations")

    @property
    def tl_dir(self) -> Path:
        return self.explicit_tl_dir or (self.config_source / "teal")

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
        return self.explicit_plugins_jsonc or (self.declarations_dir / "plugins.jsonc")

    @property
    def snapshot_dir(self) -> Path:
        return self.explicit_snapshot_dir or (self.config_source / "snapshots")

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
        return self.explicit_plugins_lock or (self.snapshot_dir / "plugins-lock.json")

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
            explicit_plugins_jsonc=argdict.get("plugins_jsonc"),
            explicit_plugins_lock=argdict.get("lockfile"),
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


class PluginsLock(BaseDict[str, SinglePluginLock | None]): ...


class PluginsLockMeta(BaseModelRW):
    lock: PluginsLock
    directory: Path

    @classmethod
    def from_paths(cls, paths: Paths) -> Self:
        return cls(
            lock=PluginsLock.model_validate(read_json(paths.plugins_lock)),
            directory=paths.plugin_dir,
        )

    def install_plugins(self) -> None:
        for name, lock in self.lock.items():
            if lock:
                destination = self.directory / name
                sha, url = lock.url, lock.sha
                old_sha, recency = Utils.get_commit_info(destination)
                if sha != old_sha:
                    self.install_plugin(destination, url, sha)

    def install_plugin(
        self,
        destination: Path,
        url: str,
        sha: str,
    ) -> tuple[InstallStatus, Path]:
        try:
            run(["git", "clone", "--filter=blob:none", url, destination])
            run(["git", "-C", str(destination), "checkout", sha])

            return InstallStatus.SUCCESS, destination

        except subprocess.CalledProcessError:
            return InstallStatus.ERROR, destination

    def get_last_check(self, name: str) -> str:
        if lock := self.lock[name]:
            return lock.last_update
        return "1970-01-01"

    def items(self) -> Iterable[tuple[str, SinglePluginLock | None]]:
        return self.lock.items()

    def update(self, k: str, v: SinglePluginLock) -> None:
        self.lock.update({k: v})


class ToolSpecs(BaseList[SingleToolSpec]): ...


class SingleToolSpecs(BaseList[SingleToolSpec]):
    @classmethod
    def from_paths(cls, paths: Paths) -> Self:
        return cls.read_json_file(paths.external_tools_declaration)


class PluginSpecsMeta(BaseModel):
    specs: dict[str, SinglePluginSpec]
    directory: Path

    @classmethod
    def from_paths(cls, paths: Paths) -> Self:
        dicts = PluginSpecs.read_json_file(paths.plugins_jsonc)
        return cls(
            specs=dict((s.name, s) for s in dicts),
            directory=paths.plugin_dir,
        )

    def lookup(self, name: str) -> SinglePluginSpec:
        return self.specs[name]

    def install_plugins(self) -> PluginsLock:
        lock: dict[str, SinglePluginLock | None] = {}
        for spec in self.specs.values():
            status, _path = self.install_plugin(spec.name)
            lock_data: SinglePluginLock | None = None
            if status is InstallStatus.ERROR:
                print(f"{spec.name} not installed: {spec.url} ========================================================")
            else:
                sha, recency = Utils.get_commit_info(_path)
                lock_data = SinglePluginLock.model_validate(
                    {
                        "url": spec.url,
                        "sha": sha,
                        "last_update": Globals.TODAY,
                        "location": str(_path.relative_to(self.directory)),
                        "recency": recency,
                        "version": spec.version,
                    }
                )
            lock.update({spec.name: lock_data})
        return PluginsLock.model_validate(lock)

    def install_plugin(
        self,
        name: str,
        update_existing: bool = False,
    ) -> tuple[InstallStatus, Path]:
        spec = self.lookup(name)
        if bool(spec.build):
            return self.install_plugin_with_build(spec, self.directory, update_existing=update_existing)
        else:
            return self.install_plugin_simple(spec, self.directory, update_existing=update_existing)

    @property
    def names_and_paths(self) -> tuple[tuple[str, Path], ...]:
        return tuple((name, self.directory / name) for name in self.specs)

    @staticmethod
    def install_plugin_simple(
        spec: SinglePluginSpec, directory: Path, update_existing: bool = False
    ) -> tuple[InstallStatus, Path]:
        url, version, sha = spec.url, spec.version, spec.hash
        destination = directory / spec.destination
        if (not update_existing) and destination.is_dir():
            return InstallStatus.NO_OP, destination
        post_command: CommandList = []

        try:
            command_specifics = ["--depth=1"]
            if version:
                command_specifics.extend(["--depth=1", "--branch", version])
            elif sha:
                command_specifics = ["--filter=blob:none"]
                post_command = ["git", "-C", destination, "checkout", sha]

            subprocess.run(["git", "clone", *command_specifics, url, destination], check=True)
            if post_command:
                run(post_command)

            return InstallStatus.SUCCESS, destination

        except subprocess.CalledProcessError:
            return InstallStatus.ERROR, destination

    @staticmethod
    def install_plugin_with_build(
        spec: SinglePluginSpec, directory: Path, update_existing: bool = False
    ) -> tuple[InstallStatus, Path]:
        return InstallStatus.NO_OP, directory / "NONEXISTENT"


class SingleAvailableUpdate(BaseModel):
    path: Path


class AvailableUpdates(BaseDict[str, SingleAvailableUpdate]): ...
