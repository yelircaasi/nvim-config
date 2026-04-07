from ..config import Paths
from ..datamodels import (
    PluginsLockMeta,
    PluginsLock,
    PluginSpecs,
    ToolSpecs,
)
from ..utils import write_table
from .plugin_gleaning import search_plugin_directory
from .nvim_gleaning import (
    profile_startup,
    parse_colors,
    parse_commands,
    parse_mappings,
    parse_rtp,
)


__all__ = (
    "parse_colors",
    "parse_commands",
    "parse_mappings",
    "parse_rtp",
    "search_plugin_directory",
    "write_plugin_layers_tl",
    "write_dependencies_tl",
    "write_external_tools_tl",
    "write_plugin_paths_tl",
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
