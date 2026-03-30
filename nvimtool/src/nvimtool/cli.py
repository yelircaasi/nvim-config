from pathlib import Path


import argparse

from .config import Globals


def parse_args() -> argparse.Namespace:
    parent_parser = argparse.ArgumentParser(add_help=False)
    parent_parser.add_argument(
        "--config",
        "-c",
        type=Path,
        default=Globals.DEFAULT_CONFIG_SOURCE / "nvimtools.json",
        help="Path to nvimtools.json, containing all relative cfg.paths.",
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
    parser = argparse.ArgumentParser(
        description="Neovim plugin manager", parents=[parent_parser]
    )

    subparsers = parser.add_subparsers(dest="subcommand")
    subparsers.add_parser("all", parents=[parent_parser]).add_subparsers(
        dest="subsubcommand"
    )
    tl = subparsers.add_parser("tl", parents=[parent_parser]).add_subparsers(
        dest="subsubcommand"
    )
    plugins = subparsers.add_parser("plugins", parents=[parent_parser]).add_subparsers(
        dest="subsubcommand"
    )
    info = subparsers.add_parser("info").add_subparsers(dest="subsubcommand")
    tools = subparsers.add_parser("tools").add_subparsers(dest="subsubcommand")
    nix = subparsers.add_parser("nix").add_subparsers(dest="subsubcommand")

    # 'tl' subcommand
    tl.add_parser(
        "transpile", help="Transpile .tl source code into Lua.", parents=[parent_parser]
    )

    # 'info' subcommand
    info.add_parser("all", help="", parents=[parent_parser])
    info.add_parser("startup", help="", parents=[parent_parser])
    info.add_parser("colors", help="", parents=[parent_parser])
    info.add_parser("commands", help="", parents=[parent_parser])
    info.add_parser("rtp", help="", parents=[parent_parser])
    info.add_parser("mappings", help="", parents=[parent_parser])

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
    nix.add_parser("write-flake", help="", parents=[parent_parser])

    return parser.parse_args()
