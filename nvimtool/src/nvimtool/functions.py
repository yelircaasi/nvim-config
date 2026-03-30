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

from adiumentum import (
    Version,
    run_with_result,
)
from pathlib import Path
import shutil

from typing import cast
import json
import re
import socket
import subprocess

from .config import Paths
from .datamodels import (
    CommandList,
    RTPDict,
    SingleToolSpecs,
    PluginsLockMeta,
    ToolsLock,
    PluginsLock,
    PluginSpecs,
    PluginSpecsMeta,
    ToolSpecs,
    SinglePluginLock,
    AvailableUpdates,
)
from .nix_helpers import build_flake_source
from .config import Config
from .patterns import Patterns
from .types import LuaTable
from .utils import (
    change_extension,
    check_for_updates,
    color,
    export_nvim_info,
    get_executable_and_version,
    get_last_date,
    safe_search,
    safe_search_group1,
    split_blocks,
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


def profile_startup(cfg: Config):
    """
    Requires vim-startuptime; run:

        `go install github.com/rhysd/vim-startuptime@latest`
    """
    config = (
        ("-u", cfg.paths.nvim_config_init) if cfg.paths.nvim_config_init else tuple()
    )
    name_segments = "--".join(
        filter(bool, ("startup", cfg.g.DEVICE_NAME, cfg.g.CONFIG_NAME))
    )
    destination = cfg.paths.info_dir / f"nvim-{name_segments}.txt"
    config = (
        ("--", "-u", cfg.paths.nvim_config_init)
        if cfg.paths.nvim_config_init
        else tuple()
    )
    _cmd = [
        "vim-startuptime",
        "-vimpath",
        cfg.g.NVIM_COMMAND,
        *config,
    ]
    cmd: list[str] = list(map(str, _cmd))
    print(" ".join(cmd))
    output = bytes.decode(subprocess.run(cmd, capture_output=True).stdout)
    destination.write_text(str(output))
    return destination


def parse_colors(raw: str) -> dict[str, dict[str, str]]:
    c = {}
    blocks = split_blocks(raw)
    for block in blocks:
        result = re.search(Patterns.COLOR_PATTERN, block)
        if result:
            gd = result.groupdict()
            gd |= safe_search(Patterns.COLOR_BODY_PATTERN, gd["body"] or "")
            c.update({gd["name"]: {key: gd[key] for key in Patterns.COLOR_KEYS}})

        else:
            print(block)

    return c


def parse_mappings(raw: str) -> dict[str, dict[str, str]]:
    m = {}

    raw = re.sub(r"\tLast set ", "\t\tLast set ", raw)
    # print(raw[:500])

    blocks = split_blocks(raw)[1:]
    # print(raw)

    for block in blocks:
        result = re.search(Patterns.MAPPING_PATTERN, block)
        if result:
            gd = result.groupdict()
            m.update({gd["keybind"]: {key: gd[key] for key in Patterns.MAPPING_KEYS}})
        else:
            print(block)

    return m


def parse_commands(raw: str) -> dict[str, dict[str, str]]:
    c = {}

    raw = re.sub(r"\n?\tLast set ", "\n\t\tLast set ", raw)
    raw = re.sub("\n?    Name", " Name", raw)
    raw = re.sub("\n            ", "\n\t\t\t", raw)
    raw = re.sub(r"\n    ", "\n_   ", raw)

    blocks = split_blocks(raw)[1:]

    for block in blocks:
        result = re.search(Patterns.COMMAND_PATTERN, block)
        if result:
            gd = result.groupdict()
            c.update({gd["name"]: {key: gd[key] for key in Patterns.COMMAND_KEYS}})
        else:
            print(block)

    return c


def parse_rtp(raw: str) -> RTPDict:
    r: RTPDict = {"default": [], "value": [], "contents": {}}

    default = safe_search_group1(r'default = "([^\n]+)",', raw)
    print(default)
    r["default"] = default.split(",")

    value = safe_search_group1(r'_value = "([^\n]+)",', raw)
    print(default)
    r["value"] = value.split(",")

    r["contents"] = {}
    for path in r["default"] + r["value"]:
        if path not in r["contents"]:
            _path = Path(path)
            contents: list[str] = (
                list(map(str, _path.iterdir())) if _path.exists() else ["NONEXISTENT"]
            )
            r["contents"].update({path: contents})

    return r


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


def write_flake(cfg: Config) -> None:
    print("Writing flake.nix")
    nix_data = PluginSpecs.read_json_file(cfg.paths.plugins_declaration)

    flake_nix = build_flake_source(nix_data)
    cfg.paths.flake.write_text(flake_nix)


def get_info_all(cfg: Config) -> None:
    print("Not yet implemented!")


def get_info_startup(cfg: Config) -> None:
    print("Not yet implemented!")
    startup_txt = profile_startup(cfg)
    print(startup_txt)


def get_info_colors(cfg: Config) -> None:
    print("Not yet implemented!")
    colors_txt = export_nvim_info("highlight", cfg)
    colors_json = change_extension(colors_txt, "json")
    colors_raw = colors_txt.read_text()
    colors = parse_colors(colors_raw)
    colors_json.write_text(json.dumps(colors, indent=4))


def get_info_commands(cfg: Config) -> None:
    print("Not yet implemented!")
    commands_txt = export_nvim_info("command", cfg)
    commands_json = change_extension(commands_txt, "json")
    commands_raw = commands_txt.read_text()
    commands = parse_commands(commands_raw)
    commands_json.write_text(json.dumps(commands, indent=4))


def get_info_rtp(cfg: Config) -> None:
    print("Not yet implemented!")
    rtp_txt = export_nvim_info("rtp", cfg)
    rtp_json = change_extension(rtp_txt, "json")
    rtp_raw = rtp_txt.read_text()
    rtp = parse_rtp(rtp_raw)
    rtp_json.write_text(json.dumps(rtp, indent=4))


def get_info_mappings(cfg: Config) -> None:
    print("Not yet implemented!")
    mappings_txt = export_nvim_info("map", cfg)
    mappings_json = change_extension(mappings_txt, "json")
    mappings_raw = mappings_txt.read_text()
    mappings = parse_mappings(mappings_raw)
    mappings_json.write_text(json.dumps(mappings, indent=4))


def do_all(cfg: Config) -> None:
    print("Not yet implemented!")
    get_info_startup(cfg)
    get_info_colors(cfg)
    get_info_colors(cfg)
    get_info_rtp(cfg)
    get_info_mappings(cfg)

    # old below here
    config = f"""
    {cfg.g.DEVICE_NAME=}
    NVIM_{cfg.g.CONFIG_NAME=}
    NVIM_{cfg.paths.nvim_config_init=}
    NVIM_WRITE_DIR={cfg.paths.info_dir!s}
    NVIM_{cfg.g.NVIM_COMMAND=}

    hostname: {socket.gethostname()}
    """
    config_file = (
        cfg.paths.info_dir / f"config--{cfg.g.DEVICE_NAME}--{cfg.g.CONFIG_NAME}.txt"
    )
    config_file.write_text(config)
