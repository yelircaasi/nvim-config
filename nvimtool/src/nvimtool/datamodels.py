from adiumentum.pydantic import (
    BaseModelRW,
    BaseDict,
    BaseList,
)
from adiumentum.io import read_json
from adiumentum.shell import run
from pathlib import Path
from enum import StrEnum, auto
import re
import subprocess

from typing import Annotated

from typing import Iterable, Self, TypedDict

from pydantic import BaseModel, Field

from .config import Config, Paths
from .types import CommandList, DictList, GitSource, InstallStatus
from .shell_helpers import get_commit_info


class SinglePluginSpec(BaseModel):
    layer: int
    sublayer: int
    sublayerName: str
    name: str
    description: str
    id: str
    source: GitSource
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
            GitSource.GH: "https://github.com/",
            GitSource.GL: "https://gitlab.com/",
            GitSource.CB: "https://codeberg.org/",
        }.get(self.source, "")

    @property
    def destination(self) -> str:
        return self.dir_name or self.name


class PluginSpecs(BaseList[SinglePluginSpec]): ...


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
                old_sha, recency = get_commit_info(destination)
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

    def install_plugins(self, cfg: Config) -> PluginsLock:
        lock: dict[str, SinglePluginLock | None] = {}
        for spec in self.specs.values():
            status, _path = self.install_plugin(spec.name)
            lock_data: SinglePluginLock | None = None
            if status is InstallStatus.ERROR:
                print(
                    f"{spec.name} not installed: {spec.url} ========================================================"
                )
            else:
                sha, recency = get_commit_info(_path)
                lock_data = SinglePluginLock.model_validate(
                    {
                        "url": spec.url,
                        "sha": sha,
                        "last_update": cfg.g.TODAY,
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
            return self.install_plugin_with_build(
                spec, self.directory, update_existing=update_existing
            )
        else:
            return self.install_plugin_simple(
                spec, self.directory, update_existing=update_existing
            )

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

            subprocess.run(
                ["git", "clone", *command_specifics, url, destination], check=True
            )
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


class RTPDict(TypedDict):
    default: list[str]
    value: list[str]
    contents: dict[str, list[str]]


class SinglePluginInfo(BaseModel):
    commands: set[str] = Field(default_factory=set)
    lua_functions: set[str] = Field(default_factory=set, alias="luaFunctions")
    highlights: set[str] = Field(default_factory=set)
    keymaps: set[tuple[str, str, str] | str] = Field(default_factory=set)
    has_vimdoc: bool = Field(default=False, alias="hasVimdoc")
    has_lua: bool = Field(default=False, alias="hasLua")


class PluginInfo(BaseDict[str, SinglePluginInfo]): ...
