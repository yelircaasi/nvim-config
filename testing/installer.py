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
from typing import Final, Iterable, Literal, NotRequired, Self, TypedDict


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


class PluginLockData(TypedDict):
    url: str
    sha: str
    cloned_on: str
    recency: str
    version: str | None


class Status(StrEnum):
    TRYING = auto()
    SELECTED = auto()
    NEXT = auto()
    SOONER = auto()
    LATER_A = "laterA"
    LATER_B = "laterB"
    LATER_C = "laterC"
    LATER = "later"
    ALTERNATE = auto()

    def __str__(self) -> str:
        return f"Status.{self.name}"
    
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
        plugins_lua: Path | None = None,
    ) -> None:
        self.config_dir = config_dir
        self.plugin_dir = plugin_dir
        self.plugins_jsonc = plugins_jsonc or config_dir / "plugins.jsonc"
        self.lockfile = lockfile or config_dir / "plugins-lock.json"
        self.plugins_lua = config_dir / "plugin_paths.lua"

        if not self.plugin_dir.exists():
            Path.mkdir(self.plugin_dir)

    @classmethod
    def from_args(cls, args: argparse.Namespace) -> Self:
        argdict = args.__dict__
        return cls(
            config_dir=args.config_dir,
            plugin_dir=args.plugin_dir,
            plugins_jsonc=argdict.get("plugins_jsonc"),
            lockfile=argdict.get("lockfile"),
            plugins_lua=argdict.get("plugins_lua"),
        )


print(Globals.DEFAULT_CONFIG_DIR)
print(Globals.DEFAULT_PLUGIN_DIR)
print(Globals.IS_NIX)


### HELPER FUNCTIONS ###################################################################################################


def run(commands: list[str]) -> subprocess.CompletedProcess[bytes]:
    return subprocess.run(commands, check=True, capture_output=True)


def capture(commands: list[str]) -> str:
    return subprocess.run(commands, capture_output=True).stdout.decode().strip()


def get_executable_and_version(name: str, subcommand: str | None = None) -> str:
    executable = capture(["which", name])

    if not executable:
        return "", ""

    output = capture([executable, subcommand or "--version"])
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
    status: Status
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
            status=Status(spec_dict["status"]),
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


def install_plugin_with_build(
    spec: Spec, directory: Path, update_existing: bool = False
) -> tuple[InstallStatus, Path]:
    return InstallStatus.NO_OP, directory / "NONEXISTENT"


@dataclass
class Specs:
    _specs: dict[str, Spec]
    directory: Path

    @classmethod
    def from_paths(cls, paths: Paths) -> Self:
        return cls(
            _specs=open_plugins_jsonc(paths.plugins_jsonc),
            directory=paths.plugin_dir,
        )

    def lookup(self, name: str) -> Spec:
        return self._specs[name]

    def install_plugins(self) -> dict[str, PluginLockData | None]:
        lock: dict[str, PluginLockData | None] = {}
        for spec in self._specs.values():
            if not spec.status.included:
                continue
            print(f"{spec.name:<20} {spec.url}")
            status, _path = self.install_plugin(spec.name)
            if status is InstallStatus.ERROR:
                print(
                    f"{spec.name} not installed: {spec.url} ========================================================"
                )
                lock_data: PluginLockData | None = None
            else:
                sha, recency = get_commit_info(_path)
                lock_data: PluginLockData = {
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
        if bool(spec.build):
            return install_plugin_with_build(
                spec, self.directory, update_existing=update_existing
            )
        else:
            return install_plugin_simple(
                spec, self.directory, update_existing=update_existing
            )


@dataclass
class LockData:
    _lock: dict[str, PluginLockData]
    directory: Path

    @classmethod
    def from_paths(cls, paths: Paths) -> Self:
        return cls(
            _lock=json.loads(paths.lockfile.read_text()),
            directory=paths.plugin_dir,
        )

    def install_plugins(self) -> None: #dict[str, PluginLockData | None]:
        # new_lock: dict[str, PluginLockData] = dict(self._lock.items())
        for name, lock in self._lock.items():
            destination = self.directory / name
            sha, url = lock["url"], lock["sha"]
            old_sha, recency = get_commit_info(destination)
            if sha != old_sha:
                self.install_plugin(destination, url, sha)
                # lock_data: PluginLockData = {
                #     "location": str(destination.relative_to(self.directory)),
                #     "url": url,
                #     "sha": sha,
                #     "cloned_on": Globals.TODAY,
                #     "recency": recency,
                #     "version": None,
                # }
                # new_lock.update({name: lock_data})
        # return new_lock

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


def write_plugins_lua(paths: Paths, plugin_names: Iterable[str]) -> None:
    plugin_dir = paths.plugin_dir
    lines = "\n\t".join(
        (f'["{name}"] = "{plugin_dir / name}",' for name in plugin_names)
    )
    file = f"""local M = {{
    {lines}\n}}\nreturn M\n"""
    paths.plugins_lua.write_text(file)


def check_for_updates(repo_path: Path) -> bool:
    location = str(repo_path)
    fetch_command = ["git", "-C", location, "fetch", "--dry-run", "origin"]
    diff_command = ["git", "-C", location, "log", "HEAD..origin/HEAD", "--oneline"]
    run(fetch_command)
    output = capture(diff_command)
    print(output)
    return bool(output)


### COMMAND FUNCTIONS ##################################################################################################


def install_fresh(paths: Paths) -> None:
    print(f"Installing plugins to {paths.plugin_dir}")
    specs = Specs.from_paths(paths)
    lock = specs.install_plugins()
    write_plugins_lua(paths, lock)
    paths.lockfile.write_text(json.dumps(lock, indent=4))
    print(f"lockfile written to {paths.lockfile}")


def install_from_lockfile(paths: Paths) -> None:
    print(f"Installing plugins to {paths.plugin_dir}")
    lock_data = LockData.from_paths(paths)
    lock = lock_data.install_plugins()
    write_plugins_lua(paths, lock) 
    # paths.lockfile.write_text(json.dumps(lock, indent=4))
    # print(f"lockfile written to {paths.lockfile}")


def update_plugins(paths: Paths) -> None:
    print("Not yet implemented!")


def check_updates(paths: Paths) -> None:
    print(f"Checking updates, config at {paths.config_dir}")


def apply_updates(args) -> None:
    print("Not yet implemented!")


def check_tools(paths: Paths) -> None:
    print("Not yet implemented!")


def snapshot_tools(paths: Paths) -> None:
    print("Not yet implemented!")


def write_tools_script(paths: Paths) -> None:
    print("Not yet implemented!")


def audit_nix(paths: Paths) -> None:
    print(f"Auditing Nix plugins against {paths.config_dir}")


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
    paths = Paths.from_args(args)

    subcommand_pair = (args.subcommand, args.subsubcommand)
    print(subcommand_pair)
    match subcommand_pair:
        case ("plugins", "install-fresh"):
            install_fresh(paths)
        case ("plugins", "install-from-lockfile"):
            install_from_lockfile(paths)
        case ("plugins", "update"):
            update_plugins(paths)
        case ("plugins", "check-updates"):
            check_updates(paths)
        case ("plugins", "apply-updates"):
            apply_updates(paths)
        case ("tools", "check"):
            check_tools(paths)
        case ("tools", "snapshot"):
            snapshot_tools(paths)
        case ("tools", "write-script"):
            write_tools_script(paths)
        case ("nix", "audit"):
            audit_nix(paths)
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
