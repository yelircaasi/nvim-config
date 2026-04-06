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

from ..config import Config
from . import info, nix, plugins, tl, tools


def default_command(cfg: Config) -> None:
    print("Not yet implemented!")
    info.get_info_startup(cfg)
    info.get_info_colors(cfg)
    info.get_info_colors(cfg)
    info.get_info_rtp(cfg)
    info.get_info_mappings(cfg)
    plugins.check_updates(cfg)
    tl.transpile_tl(cfg)
    tools.check_and_snapshot_tools(cfg)
    nix.audit_nix(cfg)
    nix.write_flake(cfg)

    # old below here

    '''
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
    '''
