# /// script
# dependencies = [
#   "adiumentum>=0.7.1",
#   "pydantic>=2.11",
# ]
# ///

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

from adiumentum import (  # type: ignore
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

from nvimtool_helpers import *


def install_plugin_simple(spec: Spec, directory: Path, update_existing: bool = False) -> tuple[InstallStatus, Path]:
    url, version, sha = spec.url, spec.version, spec.sha
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


def install_plugin_with_build(spec: Spec, directory: Path, update_existing: bool = False) -> tuple[InstallStatus, Path]:
    return InstallStatus.NO_OP, directory / "NONEXISTENT"


@dataclass
class Specs:
    _specs: dict[str, Spec]
    directory: Path

    @classmethod
    def from_paths(cls, paths: Paths) -> Self:
        dicts = cast(list[PluginSpecDict], read_jsonc(paths.plugins_jsonc))
        return cls(
            _specs=dict((s.name, s) for s in map(Spec.from_dict, dicts)),
            directory=paths.plugin_dir,
        )

    def lookup(self, name: str) -> Spec:
        return self._specs[name]

    def install_plugins(self) -> dict[str, PluginLockData | None]:
        lock: dict[str, PluginLockData | None] = {}
        for spec in self._specs.values():
            status, _path = self.install_plugin(spec.name)
            lock_data: PluginLockData | None = None
            if status is InstallStatus.ERROR:
                print(f"{spec.name} not installed: {spec.url} ========================================================")
            else:
                sha, recency = Utils.get_commit_info(_path)
                lock_data = {
                    "url": spec.url,
                    "sha": sha,
                    "last_update": Globals.TODAY,
                    "location": str(_path.relative_to(self.directory)),
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
            return install_plugin_with_build(spec, self.directory, update_existing=update_existing)
        else:
            return install_plugin_simple(spec, self.directory, update_existing=update_existing)

    @property
    def names_and_paths(self) -> tuple[tuple[str, Path], ...]:
        return tuple((name, self.directory / name) for name in self._specs)


@dataclass
class LockData:
    _lock: dict[str, PluginLockData | None]
    directory: Path

    @classmethod
    def from_paths(cls, paths: Paths) -> Self:
        return cls(
            _lock=cast(dict[str, PluginLockData | None], read_json(paths.plugins_lock)),
            directory=paths.plugin_dir,
        )

    def install_plugins(self) -> None:
        for name, lock in self._lock.items():
            if lock:
                destination = self.directory / name
                sha, url = lock["url"], lock["sha"]
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
        if lock := self._lock[name]:
            return lock["last_update"]
        return "1970-01-01"

    def items(self) -> Iterable[tuple[str, PluginLockData | None]]:
        return self._lock.items()

    def update(self, k: str, v: PluginLockData) -> None:
        self._lock.update({k: v})


class ExternalToolSpecs(list[ExternalToolSpec]):
    @classmethod
    def from_paths(cls, paths: Paths) -> Self:
        return cls(cast(list[ExternalToolSpec], read_jsonc(paths.external_tools_declaration)))


def write_plugin_paths_tl(paths: Paths, plugin_lock: LockData | PluginLockTable) -> None:
    pd = paths.plugin_dir
    path_dict: dict[str, str] = {pn: str(pd / pn) for pn, _ in plugin_lock.items()}
    paths.plugin_paths_tl.write_text(
        Utils.write_table(
            path_dict,
            head="local M: {string: string} = ",
            foot="\nreturn M\n",
            align=True,
            bracket_all=True,
        )
    )


def write_plugin_layers_tl(paths: Paths, plugin_data: PluginSpecData) -> None:
    layers: dict[int, dict[int, set]] = {d["layer"]: {} for d in plugin_data}
    for d in plugin_data:
        layer, sublayer = d["layer"], d["sublayer"]
        if sublayer not in layers[layer]:
            layers[layer].update({sublayer: set()})
        layers[layer][sublayer].add(d["name"])
    paths.plugin_layers_tl.write_text(
        Utils.write_table(
            layers,
            head=r"local plugins_by_layer: {number: {number: {string}}} = ",
            foot="\nreturn plugins_by_layer",
            align=False,
        )
    )


def write_dependencies_tl(paths: Paths, plugin_data: PluginSpecData) -> None:
    deps = {d["name"]: d.get("deps", []) for d in plugin_data}
    paths.dependencies_tl.write_text(
        Utils.write_table(
            deps,
            head="local M: {string: {string}} = ",
            foot="\nreturn M\n",
            align=True,
        )
    )


def write_external_tools_tl(paths: Paths, external_tool_data: ExternalToolSpecData) -> None:
    tools = {d["executable"]: d.get("description", "") for d in external_tool_data}
    paths.external_tools_tl.write_text(
        Utils.write_table(
            tools,
            head="local M: {string: string} = ",
            foot="\nreturn M\n",
            bracket_all=True,
            align=True,
        )
    )


def transpile_tl(paths: Paths) -> None:
    tl_root = paths.tl_dir
    transpile_target = paths.tl_build_dir
    copy_target = paths.config_destination
    cyan_command: CommandList = [
        "cyan",
        "--gen-target",
        "5.1",
        "--global-env-def",
        "vim",
        "--global-env-def",
        "cfg",
        "-s",
        paths.tl_src_dir.relative_to(tl_root).name,
        "-b",
        transpile_target.relative_to(tl_root).name,
        "build",
        "--prune",
    ]
    run_with_result(cyan_command, cwd=tl_root, fail_on_error=True, print_output=True)
    result, _ = run_with_result(["stylua", transpile_target / "init.lua", transpile_target / "lua"], print_output=True)
    if result:
        run_with_result(["lua", str(paths.cleanup_lua), transpile_target], fail_on_error=True, print_output=True)
    shutil.copytree(copy_target, paths.backup_dir / copy_target.name)
    shutil.copytree(transpile_target, copy_target, dirs_exist_ok=True)
    print("Built lua config.")


### COMMAND FUNCTIONS ##################################################################################################


def install_new(paths: Paths) -> None:
    """ """
    print(f"Installing plugins to {paths.plugin_dir}")
    specs = Specs.from_paths(paths)
    lock: dict[str, PluginLockData | None] = specs.install_plugins()
    write_plugin_paths_tl(paths, lock)
    write_json(cast(JsonObject, lock), paths.plugins_lock)
    print(f"lockfile written to {paths.plugins_lock}")


def install_from_lockfile(paths: Paths) -> None:
    """
    TODO: support installing from a lockfile
        e.g. newly cloned when old lockfile exists, and touching only the
        plugins that are not in the old lockfile or whose hash differs.
    """
    print(f"Installing plugins to {paths.plugin_dir}")
    lock_data = LockData.from_paths(paths)
    lock_data.install_plugins()
    write_plugin_paths_tl(paths, lock_data)


def update_plugin(path: Path | str) -> PluginLockData:
    print("Not yet implemented!")
    return {
        "url": "",
        "sha": "",
        "last_update": "",
        "location": "",
        "recency": "",
        "version": "",
    }


def update_plugins(paths: Paths) -> None:
    print("Not yet implemented!")


def check_updates(paths: Paths) -> None:
    update_info: dict[str, dict[str, str | None]] = {}
    print(f"Checking updates, config at {paths.config_source}")
    specs = Specs.from_paths(paths)
    lock = LockData.from_paths(paths)
    update_before = Utils.get_last_date(Globals)
    name: str
    repo: Path
    for name, repo in specs.names_and_paths:
        if lock.get_last_check(name) < update_before:
            updates_available: bool = Utils.check_for_updates(repo)
            if updates_available:
                update_info.update({name: {"path": paths.rel(repo)}})
                print(f"Updates available for {repo}")
    write_json(update_info, paths.available_updates)


def apply_updates(paths: Paths) -> None:
    update_info = cast(dict[str, dict[str, str]], read_json(paths.available_updates))
    lock = LockData.from_paths(paths)
    for name, info in update_info.items():
        lock_data = update_plugin(info["path"])
        lock.update(name, lock_data)
    write_json(cast(JsonObject, lock), paths.plugins_lock)


def update_and_install_plugins(paths: Paths) -> None:
    check_updates(paths)
    apply_updates(paths)


def check_tools(paths: Paths) -> None:
    tools = ExternalToolSpecs.from_paths(paths)
    all_good: bool = True
    for tool in tools:
        executable, version_str = Utils.get_executable_and_version(tool["executable"])
        actual_version = Version.from_string(version_str)
        if isinstance(actual_version, str):
            print(f"Version '{actual_version} could not be parsed.")
            all_good = False
        elif vc := tool.get("version_constraints"):
            if not actual_version.meets_constraint(vc):
                all_good = False
                print(
                    f"Version {color.blue(str(actual_version))} of '{color.green(executable)}' does not meet constraint '{color.blue(vc)}'."
                )
    if all_good:
        print(color.green("External tool check: all versions meet constraints."))


def snapshot_tools(paths: Paths) -> None:
    tools_lock: dict[str, dict[str, str | None]] = {}
    tools = ExternalToolSpecs.from_paths(paths)
    for tool in tools:
        executable = tool["executable"]
        executable_path, version_str = Utils.get_executable_and_version(executable)
        tools_lock.update({executable: {"path": paths.rel(executable_path or None), "version": version_str or None}})
    write_json(cast(JsonObject, tools_lock), paths.external_tools_lock)
    paths.external_tools_tl.write_text(
        Utils.write_table(cast(LuaTable, tools_lock), head=r"local M: {string: {string: string}} = ", foot="\nreturn M")
    )


def check_and_snapshot_tools(paths: Paths) -> None:
    check_tools(paths)
    snapshot_tools(paths)


def write_tools_script(paths: Paths) -> None:
    print("Not yet implemented!")


def audit_nix(paths: Paths) -> None:
    print(f"Auditing Nix plugins against {paths.config_source}")


def do_all(paths: Paths) -> None:
    print("Not yet implemented!")


### CLI ################################################################################################################


def parse_args() -> argparse.Namespace:
    parent_parser = argparse.ArgumentParser(add_help=False)
    parent_parser.add_argument(
        "--config",
        "-c",
        type=Path,
        default=Globals.DEFAULT_CONFIG_SOURCE / "nvimtools.json",
        help="Path to nvimtools.json, containing all relative paths.",
    )
    parent_parser.add_argument(
        "--config-source",
        "-s",
        type=Path,
        default=Globals.DEFAULT_CONFIG_SOURCE,
        help="Neovim config source directory",
    )
    parent_parser.add_argument(
        "--config-target",
        "-t",
        type=Path,
        default=Globals.DEFAULT_CONFIG_TARGET,
        help="Neovim config target directory",
    )
    parent_parser.add_argument(
        "--plugin-dir",
        type=Path,
        default=Globals.DEFAULT_PLUGIN_DIR,
        help="Plugin install directory",
    )
    parent_parser.add_argument(
        "--verbose",
        "-v",
        action="store_true",
        default=False,
        help="Enable verbose output",
    )
    parser = argparse.ArgumentParser(description="Neovim plugin manager", parents=[parent_parser])

    subparsers = parser.add_subparsers(dest="subcommand")
    subparsers.add_parser("all", parents=[parent_parser]).add_subparsers(dest="subsubcommand")
    tl = subparsers.add_parser("tl", parents=[parent_parser]).add_subparsers(dest="subsubcommand")
    plugins = subparsers.add_parser("plugins", parents=[parent_parser]).add_subparsers(dest="subsubcommand")
    tools = subparsers.add_parser("tools").add_subparsers(dest="subsubcommand")
    nix = subparsers.add_parser("nix").add_subparsers(dest="subsubcommand")

    # 'tl' subcommand
    tl.add_parser("transpile", help="Transpile .tl source code into Lua.", parents=[parent_parser])

    # 'plugins' subcommand
    plugins.add_parser(
        "install-new",
        help="Install plugins from plugins.jsonc",
        parents=[parent_parser],
    )
    plugins.add_parser("install-from-lockfile", help="", parents=[parent_parser])
    plugins.add_parser("update", help="", parents=[parent_parser])
    plugins.add_parser("check-updates", help="", parents=[parent_parser])
    plugins.add_parser("apply-updates", help="", parents=[parent_parser])

    # 'tools' subcommand
    tools.add_parser("check", help="", parents=[parent_parser])
    tools.add_parser("snapshot", help="", parents=[parent_parser])
    tools.add_parser("write-script", help="", parents=[parent_parser])

    # 'nix' subcommand
    nix.add_parser("audit", help="", parents=[parent_parser])

    return parser.parse_args()


def main() -> None:
    args = parse_args()
    Globals.VERBOSE = args.verbose
    Utils.printv(args)
    if args.config.exists():
        Globals.CONFIG |= Utils.read_config(args.config)
    paths = Paths.from_args(args, Globals.CONFIG)

    subcommand_pair = (
        args.subcommand if "subcommand" in args else None,
        args.subsubcommand if "subsubcommand" in args else None,
    )
    Utils.printv(subcommand_pair)

    def _fallback(_) -> None:
        print(color.red("Not yet implemented!."))

    dispatcher: dict[tuple[str | None, str | None], Callable[[Paths], None]] = {
        (None, None): do_all,
        ("all", None): do_all,
        ("tl", None): transpile_tl,
        ("tl", "transpile"): transpile_tl,
        ("plugins", None): update_and_install_plugins,
        ("plugins", "install-new"): install_new,
        ("plugins", "install-from-lockfile"): install_from_lockfile,
        ("plugins", "update"): update_plugins,
        ("plugins", "check-updates"): check_updates,
        ("plugins", "apply-updates"): apply_updates,
        ("tools", None): check_and_snapshot_tools,
        ("tools", "check"): check_tools,
        ("tools", "snapshot"): snapshot_tools,
        ("tools", "write-script"): write_tools_script,
        ("nix", None): audit_nix,
        ("nix", "audit"): audit_nix,
    }
    func = dispatcher.get(subcommand_pair, _fallback)
    func(paths)


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
