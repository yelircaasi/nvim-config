from adiumentum.path import glob_extension

from pathlib import Path

import re
import subprocess

from .config import Config, Paths
from .datamodels import (
    PluginInfo,
    RTPDict,
    SinglePluginInfo,
    PluginsLockMeta,
    PluginsLock,
    PluginSpecs,
    ToolSpecs,
)
from .patterns import Patterns, SearchPatterns
from .utils import (
    join_filtered,
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
    name_segments = join_filtered(
        "--", ("startup", cfg.g.DEVICE_NAME, cfg.g.CONFIG_NAME)
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


def search_plugin_directory(
    plugin_directory: Path | str, plugin_require_name: str
) -> SinglePluginInfo:
    plugin_directory = Path(plugin_directory)
    info = SinglePluginInfo()
    lua_files = glob_extension("lua", plugin_directory)
    vim_files = glob_extension("vim", plugin_directory)
    txt_files = glob_extension("txt", plugin_directory)
    md_files = glob_extension("txt", plugin_directory)

    for file in lua_files:
        text = Path(file).read_text(errors="ignore")
        info.commands.update(SearchPatterns.COMMAND_LUA.findall(text))
        info.lua_functions.update(
            SearchPatterns.LUA_FUNCTION_REQUIRED(plugin_require_name).findall(text)
        )
        info.lua_functions.update(SearchPatterns.LUA_FUNCTION.findall(text))
        info.highlights.update(SearchPatterns.HIGHLIGHT_GROUP_LUA.findall(text))
        info.keymaps.update(SearchPatterns.KEYBIND_LUA.findall(text))
        info.keymaps.update(SearchPatterns.KEYBIND_LUA_API.findall(text))
    for file in vim_files:
        info.commands.update(SearchPatterns.COMMAND_VIM.findall(text))
        info.highlights.update(SearchPatterns.HIGHLIGHT_GROUP_VIM.findall(text))
        info.keymaps.update(SearchPatterns.KEYBIND_VIM.findall(text))
    for file in txt_files + md_files:
        info.commands.update(SearchPatterns.COMMAND_DOCS.findall(text))
        info.lua_functions.update(
            SearchPatterns.LUA_FUNCTION_REQUIRED(plugin_require_name).findall(text)
        )
        info.highlights.update(SearchPatterns.HIGHLIGHT_GROUP_DOCS.findall(text))
        info.keymaps.update(SearchPatterns.KEYBIND_DOCS.findall(text))

    return info


def glean_plugin_info(cfg: Config) -> None:
    """TODO: test me!"""
    plugins_lock = PluginsLock.read_json_file(cfg.paths.plugins_lock)
    info = PluginInfo()
    for name, single_lock in plugins_lock.items():
        if not single_lock:
            continue
        single_info = search_plugin_directory(single_lock.location, name)
        info.update({name: single_info})
    info.write_json_file(cfg.paths.plugins_info)
