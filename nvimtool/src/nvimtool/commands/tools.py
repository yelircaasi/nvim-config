from typing import cast

from adiumentum.semver import Version
from adiumentum.color import color


from ..config import Config
from ..utils import (
    write_table,
)

from ..datamodels import (
    SingleToolSpecs,
    ToolsLock,
)
from ..types import LuaTable
from ..shell_helpers import (
    get_executable_and_version,
)


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
