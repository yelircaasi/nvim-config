from typing import Callable

from adiumentum.color import color


from .config import Config
from .cli import parse_args
from .commands import default_command, info, nix, plugins, tools, tl


def main() -> None:
    args = parse_args()
    cfg = Config.from_args(args)
    cfg.printv(args)

    subcommand_pair = (
        args.subcommand if "subcommand" in args else None,
        args.subsubcommand if "subsubcommand" in args else None,
    )
    cfg.printv(subcommand_pair)

    def _fallback(_) -> None:
        print(color.red("Not yet implemented!."))

    dispatcher: dict[tuple[str | None, str | None], Callable[[Config], None]] = {
        (None, None): default_command,
        ("all", None): default_command,
        ("tl", None): tl.transpile_tl,
        ("tl", "transpile"): tl.transpile_tl,
        ("plugins", None): plugins.update_and_install_plugins,
        ("plugins", "install-new"): plugins.install_new,
        ("plugins", "install-from-lockfile"): plugins.install_from_lockfile,
        ("plugins", "update"): plugins.update_plugins,
        ("plugins", "check-updates"): plugins.check_updates,
        ("plugins", "apply-updates"): plugins.apply_updates,
        ("tools", None): tools.check_and_snapshot_tools,
        ("tools", "check"): tools.check_tools,
        ("tools", "snapshot"): tools.snapshot_tools,
        ("tools", "write-script"): tools.write_tools_script,
        ("nix", None): nix.audit_nix,
        ("nix", "audit"): nix.audit_nix,
        ("nix", "write-flake"): nix.write_flake,
        ("info", None): info.get_info_all,
        ("info", "nvim"): info.glean_nvim,
        ("info", "plugin-source"): info.glean_plugin_source,
        ("nix", "all"): info.get_info_all,
        ("nix", "startup"): info.get_info_startup,
        ("nix", "colors"): info.get_info_colors,
        ("nix", "commands"): info.get_info_commands,
        ("nix", "rtp"): info.get_info_rtp,
    }
    func = dispatcher.get(subcommand_pair, _fallback)
    func(cfg)


if __name__ == "__main__":
    main()
