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
    Version,
    run_with_result,
)
from pathlib import Path
import shutil

from typing import cast


from .config import Paths
from .datamodels import (
    CommandList,
    SingleToolSpecs,
    PluginsLockMeta,
    LuaTable,
    ToolsLock,
    PluginsLock,
    PluginSpecs,
    PluginSpecsMeta,
    ToolSpecs,
    SinglePluginLock,
    AvailableUpdates,
)

from .config import Config
from .utils import (
    check_for_updates,
    color,
    get_executable_and_version,
    get_last_date,
    write_table,
)


def write_plugin_layers_tl(paths: Paths, plugin_data: PluginSpecs) -> None:
    layers: dict[int, dict[int, set]] = {d.layer: {} for d in plugin_data}
    for d in plugin_data:
        layer, sublayer = d.layer, d.sublayer
        if sublayer not in layers[layer]:
            layers[layer].update({sublayer: set()})
        layers[layer][sublayer].add(d.name)
    paths.plugin_layers_tl.write_text(
        write_table(
            layers,
            head=r"local plugins_by_layer: {number: {number: {string}}} = ",
            foot="\nreturn plugins_by_layer",
            align=False,
        )
    )


def write_dependencies_tl(paths: Paths, plugin_data: PluginSpecs) -> None:
    deps = {d.name: d.dependencies for d in plugin_data}
    paths.dependencies_tl.write_text(
        write_table(
            deps,
            head="local M: {string: {string}} = ",
            foot="\nreturn M\n",
            align=True,
        )
    )


def write_external_tools_tl(paths: Paths, external_tool_data: ToolSpecs) -> None:
    tools = {d.executable: d.description for d in external_tool_data}
    paths.external_tools_tl.write_text(
        write_table(
            tools,
            head="local M: {string: string} = ",
            foot="\nreturn M\n",
            bracket_all=True,
            align=True,
        )
    )


def transpile_tl(cfg: Config) -> None:
    paths = cfg.paths
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
    result, _ = run_with_result(
        ["stylua", transpile_target / "init.lua", transpile_target / "lua"],
        print_output=True,
    )
    if result:
        run_with_result(
            ["lua", str(paths.cleanup_lua), transpile_target],
            fail_on_error=True,
            print_output=True,
        )
    shutil.copytree(copy_target, paths.backup_dir / copy_target.name)
    shutil.copytree(transpile_target, copy_target, dirs_exist_ok=True)
    print("Built lua config.")


def write_plugin_paths_tl(
    paths: Paths, plugin_lock: PluginsLockMeta | PluginsLock
) -> None:
    pd = paths.plugin_dir
    path_dict: dict[str, str] = {pn: str(pd / pn) for pn, _ in plugin_lock.items()}
    paths.plugin_paths_tl.write_text(
        write_table(
            path_dict,
            head="local M: {string: string} = ",
            foot="\nreturn M\n",
            align=True,
            bracket_all=True,
        )
    )


### COMMAND FUNCTIONS ##################################################################################################


def install_new(cfg: Config) -> None:
    """ """
    paths = cfg.paths
    print(f"Installing plugins to {paths.plugin_dir}")
    specs = PluginSpecsMeta.from_paths(paths)
    lock: PluginsLock = specs.install_plugins(cfg)
    write_plugin_paths_tl(paths, lock)
    lock.write_json_file(paths.plugins_lock)
    print(f"lockfile written to {paths.plugins_lock}")


def install_from_lockfile(cfg: Config) -> None:
    paths = cfg.paths
    """
    TODO: support installing from a lockfile
        e.g. newly cloned when old lockfile exists, and touching only the
        plugins that are not in the old lockfile or whose hash differs.
    """
    print(f"Installing plugins to {paths.plugin_dir}")
    lock_data = PluginsLockMeta.from_paths(paths)
    lock_data.install_plugins()
    write_plugin_paths_tl(paths, lock_data)


def update_plugin(path: Path | str) -> SinglePluginLock:
    print("Not yet implemented!")
    return SinglePluginLock.model_validate(
        {
            "url": "",
            "sha": "",
            "last_update": "",
            "location": "",
            "recency": "",
            "version": "",
        }
    )


def update_plugins(cfg: Config) -> None:
    print("Not yet implemented!")


def check_updates(cfg: Config) -> None:
    update_info: dict[str, dict[str, str | None]] = {}
    print(f"Checking updates, config at {cfg.paths.config_source}")
    specs = PluginSpecsMeta.from_paths(cfg.paths)
    lock = PluginsLockMeta.from_paths(cfg.paths)
    update_before = get_last_date(cfg)
    name: str
    repo: Path
    for name, repo in specs.names_and_paths:
        if lock.get_last_check(name) < update_before:
            updates_available: bool = check_for_updates(repo)
            if updates_available:
                update_info.update({name: {"path": cfg.paths.rel(repo)}})
                print(f"Updates available for {repo}")
    AvailableUpdates.model_validate(update_info).write_json_file(
        cfg.paths.available_updates
    )


def apply_updates(cfg: Config) -> None:
    paths = cfg.paths
    update_info = AvailableUpdates.read_json_file(paths.available_updates)
    lock = PluginsLockMeta.from_paths(paths)
    for name, info in update_info.items():
        lock_data = update_plugin(info.path)
        lock.update(name, lock_data)
    lock.lock.write_json_file(paths.plugins_lock)


def update_and_install_plugins(cfg: Config) -> None:
    check_updates(cfg)
    apply_updates(cfg)


def check_tools(cfg: Config) -> None:
    paths = cfg.paths
    tools = SingleToolSpecs.from_paths(paths)
    all_good: bool = True
    for tool in tools:
        executable, version_str = get_executable_and_version(tool.executable)
        actual_version = Version.from_string(version_str)
        if isinstance(actual_version, str):
            print(f"Version '{actual_version} could not be parsed.")
            all_good = False
        elif vc := tool.version_constraints:
            if not actual_version.meets_constraint(vc):
                all_good = False
                print(
                    f"Version {color.blue(str(actual_version))} of '{color.green(executable)}' does not meet constraint '{color.blue(vc)}'."
                )
    if all_good:
        print(color.green("External tool check: all versions meet constraints."))


def snapshot_tools(cfg: Config) -> None:
    paths = cfg.paths
    tools_lock_raw: dict[str, dict[str, str | None]] = {}
    tools = SingleToolSpecs.from_paths(paths)
    for tool in tools:
        executable = tool.executable
        executable_path, version_str = get_executable_and_version(executable)
        tools_lock_raw.update(
            {
                executable: {
                    "path": paths.rel(executable_path or None),
                    "version": version_str or None,
                }
            }
        )
    ToolsLock.model_validate(tools_lock_raw).write_json_file(paths.external_tools_lock)
    paths.external_tools_tl.write_text(
        write_table(
            cast(LuaTable, tools_lock_raw),
            head=r"local M: {string: {string: string}} = ",
            foot="\nreturn M",
        )
    )


def check_and_snapshot_tools(cfg: Config) -> None:
    check_tools(cfg)
    snapshot_tools(cfg)


def write_tools_script(cfg: Config) -> None:
    print("Not yet implemented!")


def audit_nix(cfg: Config) -> None:
    paths = cfg.paths
    print(f"Auditing Nix plugins against {paths.config_source}")


def get_info_all(cfg: Config) -> None:
    print("Not yet implemented!")


def get_info_startup(cfg: Config) -> None:
    print("Not yet implemented!")


def get_info_colors(cfg: Config) -> None:
    print("Not yet implemented!")


def get_info_commands(cfg: Config) -> None:
    print("Not yet implemented!")


def get_info_rtp(cfg: Config) -> None:
    print("Not yet implemented!")


def do_all(cfg: Config) -> None:
    print("Not yet implemented!")
