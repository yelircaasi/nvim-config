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
    id: str
    lua_name: str
    source: Source
    dir_name: str | None = None
    custom_url: str | None = None
    version: str | None = None
    sha: str | None = None
    lazy: bool = True
    deps: tuple[str, ...] = tuple()

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
        return self.dir_name or self.lua_name


_specs = (
    Spec(lua_name="plenary", id="nvim-lua/plenary.nvim", source=Source.GH),
    Spec(lua_name="nio", id="nvim-neotest/nvim-nio", source=Source.GH),
)
PLUGINS: dict[str, Spec] = dict((s.lua_name, s) for s in _specs)


for name, spec in PLUGINS.items():
    print(f"{spec.lua_name:<20} {spec.url}")


def get_commit_info(dest: str | Path) -> tuple[str, str]:
    command_list = ["git", "-C", str(dest), "log", "-1", "--format='%H %cI'"]
    sha, date = subprocess.check_output(command_list).decode().strip().split()
    return sha, date[:10]


def install_plugin(
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


def install(args) -> None:
    lock: dict[str, dict[str, str | None]] = {}
    lockfile_path = args.config_dir / "lock.json"
    plugin_dir: Path = args.plugin_dir
    if not plugin_dir.exists():
        Path.mkdir(plugin_dir)
    print(f"Installing plugins to {plugin_dir}")

    for _, spec in PLUGINS.items():
        print(f"{spec.lua_name:<20} {spec.url}")
        status, _path = install_plugin(spec, plugin_dir)
        sha, recency = get_commit_info(_path)
        lock.update(
            {
                spec.lua_name: {
                    "url": spec.url,
                    "sha": sha,
                    "recency": recency,
                    "version": spec.version,
                }
            }
        )
    lockfile_path.write_text(json.dumps(lock, indent=4))
    print(f"lockfile written to {lockfile_path}")


def check_updates(args) -> None:
    print(f"Checking updates, config at {args.config_dir}")


def audit_nix(args) -> None:
    print(f"Auditing Nix plugins against {args.config_dir}")


def dry_run(args) -> None:
    print("Not yet implemented!")


def main() -> None:
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
