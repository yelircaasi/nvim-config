"""
Utility script to install plugins on non-nix systems.

On Nix-enabled systems, serves to check that all plugins are correctly installed.
"""

from dataclasses import dataclass
import json
import os
from pathlib import Path
from enum import StrEnum, auto
import subprocess

import argparse
from typing import Literal, NotRequired, Self, TypedDict


class PluginSpecDict(TypedDict):
    name: str
    id: str
    source: Literal["gh", "gl", "cb"]
    lazy: bool
    deps: NotRequired[list[str]]
    notes: NotRequired[str]

    dir_name: NotRequired[str | None]
    custom_url: NotRequired[str | None]
    version: NotRequired[str | None]
    sha: NotRequired[str | None]
    build: str | None


class PluginLock(TypedDict):
    url: str
    sha: str
    recency: str
    version: str | None


class Globals:
    DEFAULT_CONFIG_DIR = (
        Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")) / "nvim"
    )
    DEFAULT_PLUGIN_DIR = (
        Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share"))
        / "nvim-plugins"
    )
    IS_NIX: bool = Path("/nix/store").exists()


print(Globals.DEFAULT_CONFIG_DIR)
print(Globals.DEFAULT_PLUGIN_DIR)
print(Globals.IS_NIX)


class InstallStatus(StrEnum):
    SUCCESS = auto()
    ERROR = auto()
    NO_OP = auto()


class Source(StrEnum):
    GH = auto()
    CB = auto()
    GL = auto()


@dataclass
class Spec:
    name: str
    id: str
    source: Source
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
        return self.custom_url or f"{self.url_base}/{self.id}"

    @property
    def url_base(self) -> str:
        return {
            Source.GH: "https://github.com/",
            Source.GL: "https://gitlab.com/",
            Source.CB: "https://codeberg.org/",
        }[self.source]

    @property
    def destination(self) -> str:
        return self.dir_name or self.name

    @classmethod
    def from_dict(cls, spec_dict: PluginSpecDict) -> Self:
        return cls(
            id=spec_dict["id"],
            name=spec_dict["name"],
            source=Source[spec_dict["source"].upper()],
            lazy=spec_dict["lazy"],
            dir_name=spec_dict.get("dir_name"),
            custom_url=spec_dict.get("custom_url"),
            sha=spec_dict.get("sha"),
            version=spec_dict.get("version"),
            deps=tuple(spec_dict.get("deps", tuple())),
            build=spec_dict.get("build"),
            notes=spec_dict.get("notes"),
        )


def parse_jsonc(raw: str) -> list[PluginSpecDict]:
    decommented = "".join(
        line for line in map(str.strip, raw.splitlines()) if not line.startswith("//")
    )
    print(decommented[:500])
    return json.loads((decommented))


def open_plugins_jsonc(p: Path) -> dict[str, Spec]:
    return dict((s.name, s) for s in map(Spec.from_dict, parse_jsonc(p.read_text())))


def get_commit_info(dest: Path) -> tuple[str, str]:
    if not (dest / ".git").is_dir():
        return "AAAAAAAAAAAAAAAA", "1970-01-01"
    command_list = ["git", "-C", str(dest), "log", "-1", "--format='%H %cI'"]
    sha, date = subprocess.check_output(command_list).decode().strip().split()
    return sha, date[:10]


def install_plugin_simple(
    spec: Spec, directory: Path, update_existing: bool = False
) -> tuple[InstallStatus, Path]:
    url, version, sha = spec.url, spec.version, spec.sha
    _destination = directory / spec.destination
    if (not update_existing) and _destination.is_dir():
        return InstallStatus.NO_OP, _destination
    destination = str(_destination)
    post_command: list[str] | None = None

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
            subprocess.run(post_command, check=True)

        return InstallStatus.SUCCESS, _destination

    except subprocess.CalledProcessError:
        return InstallStatus.ERROR, _destination


def install_plugin_with_deps(
    spec: Spec, directory: Path, update_existing: bool = False
) -> tuple[InstallStatus, Path]:
    return InstallStatus.NO_OP, directory / "NONEXISTENT"

def install_plugin_with_build(
    spec: Spec, directory: Path, update_existing: bool = False
) -> tuple[InstallStatus, Path]:
    return InstallStatus.NO_OP, directory / "NONEXISTENT"

def install_plugin_with_deps_and_build(
    spec: Spec, directory: Path, update_existing: bool = False
) -> tuple[InstallStatus, Path]:
    return InstallStatus.NO_OP, directory / "NONEXISTENT"


@dataclass
class Specs:
    _specs: dict[str, Spec]
    directory: Path

    def lookup(self, name: str) -> Spec:
        return self._specs[name]

    def install_plugins(self) -> dict[str, PluginLock | None]:
        lock: dict[str, PluginLock | None] = {}
        for spec in self._specs.values():
            print(f"{spec.name:<20} {spec.url}")
            status, _path = self.install_plugin(spec.name)
            if status is InstallStatus.ERROR:
                print(f"{spec.name} not installed: {spec.url}")
                lock_data: PluginLock | None = None
            else:
                sha, recency = get_commit_info(_path)
                lock_data = {
                    "url": spec.url,
                    "sha": sha,
                    "recency": recency,
                    "version": spec.version,
                }
            lock.update({spec.name: lock_data})
        return lock

    def install_plugin(
        self,
        name: str,
        update_existing: bool = False,
    ) -> tuple[InstallStatus, Path]:
        spec = self.lookup(name)
        directive = (bool(spec.deps), bool(spec.build))
        match directive:
            case (False, False):
                return install_plugin_simple(spec, self.directory, update_existing=update_existing)
            case (True, False):
                return install_plugin_with_deps(spec, self.directory, update_existing=update_existing)
            case (False, True):
                return install_plugin_with_build(spec, self.directory, update_existing=update_existing)
            case (True, True):
                return install_plugin_with_deps_and_build(spec, self.directory, update_existing=update_existing)


def install(args) -> None:
    
    plugin_dir: Path = args.plugin_dir
    config_dir: Path = args.config_dir
    plugins_file = config_dir / "plugins.jsonc"
    plugins_lockfile = config_dir / "plugins-lock.json"
    if not plugin_dir.exists():
        Path.mkdir(plugin_dir)
    print(f"Installing plugins to {plugin_dir}")
    specs = Specs(
        _specs=open_plugins_jsonc(plugins_file),
        directory=plugin_dir,
    )
    lock = specs.install_plugins()

    plugins_lockfile.write_text(json.dumps(lock, indent=4))
    print(f"lockfile written to {plugins_lockfile}")



def check_updates(args) -> None:
    print(f"Checking updates, config at {args.config_dir}")


def audit_nix(args) -> None:
    print(f"Auditing Nix plugins against {args.config_dir}")


def dry_run(args) -> None:
    print("Not yet implemented!")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Neovim plugin manager")
    parser.add_argument(
        "--config-dir",
        type=Path,
        default=Globals.DEFAULT_CONFIG_DIR,
        help="Neovim config directory",
    )
    parser.add_argument(
        "--plugin-dir",
        type=Path,
        default=Globals.DEFAULT_PLUGIN_DIR,
        help="Plugin install directory",
    )
    parser.add_argument(
        "--verbose",
        "-v",
        action="store_true",
        default=False,
        help="Enable verbose output",
    )
    parser.add_argument(  # TODO
        "--from-lockfile",
        action="store_true",
        default=False,
        help="Install from lockfile (pinned versions)",
    )

    subparsers = parser.add_subparsers(dest="subcommand")

    subparsers.add_parser(
        "dry-run", help="Display what would be done if 'install' were run."
    )
    subparsers.add_parser("install", help="Install plugins from plugins.lua")
    subparsers.add_parser(
        "check-updates", help="Check for upstream updates against lockfile"
    )
    subparsers.add_parser(
        "audit-nix", help="Audit Nix plugin derivations against plugins.lua"
    )

    args = parser.parse_args()
    return args


def main() -> None:
    args = parse_args()

    match args.subcommand:
        case "install":
            install(args)
        case "check-updates":
            check_updates(args)
        case "audit-nix":
            audit_nix(args)
        case "dry-run":
            dry_run(args)
        case _:
            dry_run(args)


if __name__ == "__main__":
    main()

    # ------------------------------------------------------
    _specs = (
        Spec(name="plenary", id="nvim-lua/plenary.nvim", source=Source.GH),
        Spec(name="nio", id="nvim-neotest/nvim-nio", source=Source.GH),
    )
    PLUGINS: dict[str, Spec] = dict((s.name, s) for s in _specs)

    for name, spec in PLUGINS.items():
        print(f"{spec.name:<20} {spec.url}")

    # ------------------------------------------------------
