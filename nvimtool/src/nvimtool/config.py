from adiumentum.pydantic import BaseModelRW
from pathlib import Path
from datetime import date, datetime
import socket
import sys
import os

from typing import Annotated, Any

import argparse
from typing import Self

from adiumentum.io import read_json
from adiumentum.types import JsonObject
from pydantic import BaseModel, BeforeValidator, Field, NonNegativeInt, model_validator


def resolve_var(argpos: int, envvarname: str, fallback: str | Path) -> str:
    """TODO: move to adiumentum"""
    if len(sys.argv) > argpos:
        return sys.argv[argpos]
    return os.getenv(envvarname) or str(fallback)


def resolve_path(envvar: str, fallback: str) -> Path:
    from_var: str | None = os.environ.get(envvar)
    path: Path = Path(from_var or (Path.home() / fallback))
    path.mkdir(exist_ok=True)
    return path


def _make_backup_dir() -> Path:
    cache = Path.home() / ".cache/nvim_backups"
    timestamp = datetime.now().replace(microsecond=0).isoformat().replace("T", "__")
    _backup_dir = cache / timestamp
    _backup_dir.parent.mkdir(exist_ok=True)
    _backup_dir.mkdir()
    return _backup_dir


class _Globals(BaseModel):
    DEFAULT_CONFIG_SOURCE: Path = Field(
        default=resolve_path("XDG_CONFIG_HOME", "repos/nvim-config/testing")
    )
    DEFAULT_CONFIG_TARGET: Path = Field(
        default=resolve_path("XDG_CONFIG_HOME", ".config/nvim")
    )
    DEFAULT_PLUGIN_DIR: Path = Field(default=Path.home() / ".local/share/nvim-plugins")
    IS_NIX: bool = Field(default=Path("/nix/store").exists())
    TODAY: str = Field(default=str(date.today()))
    VERBOSE: bool = False
    # CONFIG: dict[str, Path | int | str] = {
    #     "config-source": Path("~/repos/nvim-config/testing").resolve(),
    #     "config-target": Path("~/.config/nvim").resolve(),
    #     "plugin-dir": Path("~/local/share/nvim-plugins").resolve(),
    #     "update-window": 30,
    # }
    DEVICE_NAME: str = Field(
        default=resolve_var(1, "DEVICE_NAME", socket.gethostname())
    )
    CONFIG_NAME: str = Field(default=resolve_var(2, "NVIM_CONFIG_NAME", "DEFAULT"))
    NVIM_COMMAND: str = Field(default=resolve_var(5, "NVIM_COMMAND", "nvim"))


_HOME = Path.home()
_BACKUP = _make_backup_dir()
_NVIM_CONFIG_PATH = Path(resolve_var(3, "NVIM_CONFIG_PATH", ""))


class Paths(BaseModelRW):
    home: Path = Field(default=_HOME)
    config_source: Path
    config_destination: Path = Field(default=_HOME / ".config/nvim")
    plugin_dir: Path = Field(default=_HOME / ".local/share/nvim-plugins")
    explicit_declarations_dir: Path | None = Field(default=None)
    explicit_info_dir: Path | None = Field(default=None)
    explicit_tl_dir: Path | None = Field(default=None)
    explicit_plugins_jsonc: Path | None = Field(default=None)
    explicit_plugins_lock: Path | None = Field(default=None)
    explicit_snapshot_dir: Path | None = Field(default=None)
    explicit_flake: Path | None = Field(default=None)
    nvim_config_init: Path = Field(default=_NVIM_CONFIG_PATH)
    backup_dir: Path = Field(default=_BACKUP)
    explicit_scripts_dir: Path | None = Field(default=None)

    @classmethod
    def from_dict(cls, d: Paths | dict[str, str]) -> Paths:
        if isinstance(d, Paths):
            return d
        return cls(
            config_source=Path(
                d.get("config-source", "~/repos/nvim-config/testing")
            ).resolve(),
            config_destination=Path(
                d.get("config-target", "~/.config/nvim/trial")
            ).resolve(),
            plugin_dir=Path(
                d.get("plugin-dir", "~/local/share/nvim-plugins")
            ).resolve(),
        )

    # @classmethod
    # def from_json(cls, json_file: Path) -> Self:
    #     d = cast(dict[str, str], read_jsonc(json_file))
    #     return cls.from_dict(d)

    @property
    def info_dir(self) -> Path:
        return self.explicit_info_dir or (self.snapshot_dir / "info")

    @property
    def plugins_info(self) -> Path:
        return self.info_dir / "plugins-info.json"

    @property
    def flake(self) -> Path:
        return self.explicit_flake or (self.snapshot_dir / "flake.nix")

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
    def plugin_paths_json(self) -> Path:
        return self.explicit_plugins_lock or (self.snapshot_dir / "plugins-lock.json")

    @property
    def plugin_paths_tl(self) -> Path:
        return self.tl_meta_dir / "plugin_cfg.paths.tl"

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

    @model_validator(mode="after")
    def ensure_paths(self) -> Self:
        if not self.config_source.exists():
            raise OSError(f"Nonexistent path: {self.config_source}")
        self._ensure_exists(self.plugin_dir)
        self._ensure_exists(self.config_destination)
        self._ensure_exists(self.tl_dir)
        self._ensure_exists(self.tl_meta_dir.parent)
        self._ensure_exists(self.tl_meta_dir)
        self._ensure_exists(self.declarations_dir)
        self._ensure_exists(self.backup_dir)
        self._ensure_exists(self.info_dir)
        return self

    @staticmethod
    def _ensure_exists(path: Path) -> None:
        if not path.exists():
            path.mkdir()

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


def ensure_globals(value: _Globals | dict[str, str] | None = None) -> _Globals:
    if isinstance(value, _Globals):
        return value
    if isinstance(value, dict):
        return _Globals.model_validate(value)
    return _Globals()


Globals = ensure_globals()


class Config(BaseModelRW):
    paths: Annotated[Paths, BeforeValidator(Paths.from_dict)]
    g: Annotated[_Globals, BeforeValidator(ensure_globals)]
    update_window: NonNegativeInt = Field(default=30)

    @classmethod
    def auto(cls) -> Self:
        paths = Paths(
            config_source=Globals.DEFAULT_CONFIG_SOURCE,
            config_destination=Globals.DEFAULT_CONFIG_TARGET,
            plugin_dir=Globals.DEFAULT_PLUGIN_DIR,
            explicit_plugins_jsonc=None,
            explicit_plugins_lock=None,
        )
        return cls.model_validate(dict(paths=paths, g=ensure_globals()))

    @classmethod
    def from_args(cls, args: argparse.Namespace) -> Self:
        argdict = args.__dict__
        _cfg = read_json(args.config_file) if "config_file" in args else {}
        if not isinstance(_cfg, dict):
            raise TypeError
        paths = Paths(
            config_source=args.config_source
            or cls._resolve_path(_cfg, "config-source")
            or Globals.DEFAULT_CONFIG_SOURCE,
            config_destination=args.config_target
            or cls._resolve_path(_cfg, "config-target")
            or Globals.DEFAULT_CONFIG_TARGET,
            plugin_dir=args.plugin_dir
            or cls._resolve_path(_cfg, "plugin-dir")
            or Globals.DEFAULT_PLUGIN_DIR,
            explicit_plugins_jsonc=argdict.get("plugins_jsonc"),
            explicit_plugins_lock=argdict.get("lockfile"),
        )
        cfg = cls.model_validate(dict(paths=paths, g=ensure_globals()))
        cfg.g.VERBOSE = args.verbose
        return cfg

    def printv(self, msg: Any) -> None:
        if self.g.VERBOSE:
            print(str(msg))

    @staticmethod
    def _resolve_path(d: JsonObject, key: str) -> Path | None:
        value = d.get(key)
        if value is None:
            return None
        if not isinstance(value, str):
            return None
        return Path("value").resolve()

    # @classmethod
    # def from_path(path: Path) -> dict[str, str | Path]:
    #     if not path.exists():
    #         return cls.from_args(argparse.Namespace())
    #     d = cast(dict[str, str | Path], read_jsonc(path))
    #     for k in ("config-source", "config-target", "plugin-dir"):
    #         d[k] = Path(d[k]).resolve()
    #     return d
