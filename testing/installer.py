"""
Utility script to install plugins on non-nix systems.

On Nix-enabled systems, serves to check that all plugins are correctly installed.

Subcommands:

- plugins
    - install-fresh
    - install-from-lockfile
    - update
    - check-updates
    - apply-updates

- tools
    - check
    - snapshot
    - write-script
"""

from dataclasses import dataclass
import json
import os
from pathlib import Path
from enum import StrEnum, auto
import re
import subprocess
from datetime import date

import argparse
from typing import Final, Literal, NotRequired, Self, TypedDict


### TYPES ##############################################################################################################


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
    cloned_on: str
    recency: str
    version: str | None


class ExternalToolSpec(TypedDict):
    executable: str
    version_subcommand: NotRequired[str]
    version_constraints: NotRequired[str]
    install_command: NotRequired[str]


class Globals:
    DEFAULT_CONFIG_DIR: Final[Path] = (
        Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config")) / "nvim"
    )
    DEFAULT_PLUGIN_DIR: Final[Path] = (
        Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share"))
        / "nvim-plugins"
    )
    IS_NIX: Final[bool] = Path("/nix/store").exists()
    TODAY: Final[str] = str(date.today())


class Paths:
    def __init__(
        self,
        *,
        config_dir: Path,
        plugin_dir: Path,
        plugins_jsonc: Path | None = None,
        lockfile: Path | None = None,
    ) -> None:
        self.config_dir = config_dir
        self.plugin_dir = plugin_dir
        self.plugins_jsonc = plugins_jsonc or config_dir / "plugins.jsonc"
        self.lockfile = lockfile or config_dir / "plugins-lock.json"


print(Globals.DEFAULT_CONFIG_DIR)
print(Globals.DEFAULT_PLUGIN_DIR)
print(Globals.IS_NIX)


### HELPER FUNCTIONS ###################################################################################################


def get_executable_and_version(name: str, subcommand: str | None = None) -> str:
    executable = (
        subprocess.run(["which", name], capture_output=True).stdout.decode().strip()
    )
    if not executable:
        return "", ""
    output = (
        subprocess.run([executable, subcommand or "--version"], capture_output=True)
        .stdout.decode()
        .strip()
    )
    search = re.search(r"\bv?([\d\.]+)\b", output)
    return executable, (search.group(1) if search else "")


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
            Source.GH: "https://github.com",
            Source.GL: "https://gitlab.com",
            Source.CB: "https://codeberg.org",
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
    output = subprocess.check_output(command_list).decode().strip()
    print(output)
    sha, date = output.split()
    return sha[1:], date[:10]


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
                print(
                    f"{spec.name} not installed: {spec.url} ========================================================"
                )
                lock_data: PluginLock | None = None
            else:
                sha, recency = get_commit_info(_path)
                lock_data = {
                    "location": str(_path.relative_to(self.directory)),
                    "url": spec.url,
                    "sha": sha,
                    "cloned_on": Globals.TODAY,
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
                return install_plugin_simple(
                    spec, self.directory, update_existing=update_existing
                )
            case (True, False):
                return install_plugin_with_deps(
                    spec, self.directory, update_existing=update_existing
                )
            case (False, True):
                return install_plugin_with_build(
                    spec, self.directory, update_existing=update_existing
                )
            case (True, True):
                return install_plugin_with_deps_and_build(
                    spec, self.directory, update_existing=update_existing
                )
        raise ValueError("Invalid")


### COMMAND FUNCTIONS ##################################################################################################


def install_fresh(args) -> None:
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


def install_from_lockfile(args) -> None:
    raise NotImplementedError


def check_for_updates(repo_path: Path) -> bool:
    location = str(repo_path)
    fetch_command = ["git", "-C", location, "fetch", "--dry-run", "origin"]
    diff_command = ["git", "-C", location, "log", "HEAD..origin/HEAD", "--oneline"]
    subprocess.run(fetch_command, capture_output=True)
    output = subprocess.run(diff_command, capture_output=True).stdout.decode().strip()
    print(output)
    return bool(output)


def update_plugins(args) -> None:
    print("Not yet implemented!")


def check_updates(args) -> None:
    print(f"Checking updates, config at {args.config_dir}")


def apply_updates(args) -> None:
    print("Not yet implemented!")


def check_tools(args) -> None:
    print("Not yet implemented!")


def snapshot_tools(args) -> None:
    print("Not yet implemented!")


def write_tools_script(args) -> None:
    print("Not yet implemented!")


def audit_nix(args) -> None:
    print(f"Auditing Nix plugins against {args.config_dir}")


### CLI ################################################################################################################


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
    plugins = subparsers.add_parser("plugins").add_subparsers(dest="subsubcommand")
    tools = subparsers.add_parser("tools").add_subparsers(dest="subsubcommand")
    nix = subparsers.add_parser("nix").add_subparsers(dest="subsubcommand")

    # 'plugins' subcommand
    plugins.add_parser("install-fresh", help="Install plugins from plugins.jsonc")
    plugins.add_parser("install-from-lockfile", help="")
    plugins.add_parser("update", help="")
    plugins.add_parser("check-updates", help="")
    plugins.add_parser("apply-updates", help="")

    # 'tools' subcommand
    tools.add_parser("check", help="")
    tools.add_parser("snapshot", help="")
    tools.add_parser("write-script", help="")

    # 'nix' subcommand
    nix.add_parser("audit", help="")

    return parser.parse_args()


def main() -> None:
    args = parse_args()
    print(args)
    paths = Paths(config_dir=args.config_dir, plugin_dir=args.plugin_dir)

    subcommand_pair = (args.subcommand, args.subsubcommand)
    print(subcommand_pair)
    match subcommand_pair:
        case ("plugins", "install-fresh"):
            install_fresh(args)
        case ("plugins", "install-from-lockfile"):
            install_from_lockfile(args)
        case ("plugins", "update"):
            update_plugins(args)
        case ("plugins", "check-updates"):
            check_updates(args)
        case ("plugins", "apply-updates"):
            apply_updates(args)
        case ("tools", "check"):
            check_tools(args)
        case ("tools", "snapshot"):
            snapshot_tools(args)
        case ("tools", "write-script"):
            write_tools_script(args)
        case ("nix", "audit"):
            audit_nix(args)
        case _:
            raise ValueError


if __name__ == "__main__":
    main()

"""
- plugins
    - install-fresh
    - install-from-lockfile
    - update
    - check-updates
    - apply-updates

- tools
    - check
    - snapshot
    - write-script
    """
