from typing import Callable

from .config import Config
from .cli import parse_args
from .functions import (
    apply_updates,
    check_updates,
    do_all,
    get_info_all,
    get_info_colors,
    get_info_commands,
    get_info_rtp,
    get_info_startup,
    install_from_lockfile,
    install_new,
    transpile_tl,
    update_plugins,
    snapshot_tools,
    check_tools,
    update_and_install_plugins,
    write_flake,
    write_tools_script,
    audit_nix,
    check_and_snapshot_tools,
)

from .utils import color


def main() -> None:
    args = parse_args()
    cfg = Config.from_args(args)

    # TODO: clean up next 4 lines
    cfg.printv(args)
    # if args.config.exists():
    #     cfg.g.CONFIG |= read_config(args.config)

    subcommand_pair = (
        args.subcommand if "subcommand" in args else None,
        args.subsubcommand if "subsubcommand" in args else None,
    )
    cfg.printv(subcommand_pair)

    def _fallback(_) -> None:
        print(color.red("Not yet implemented!."))

    dispatcher: dict[tuple[str | None, str | None], Callable[[Config], None]] = {
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
        ("nix", "write-flake"): write_flake,
        ("info", None): get_info_all,
        ("nix", "all"): get_info_all,
        ("nix", "startup"): get_info_startup,
        ("nix", "colors"): get_info_colors,
        ("nix", "commands"): get_info_commands,
        ("nix", "rtp"): get_info_rtp,
    }
    func = dispatcher.get(subcommand_pair, _fallback)
    func(cfg)


if __name__ == "__main__":
    main()
