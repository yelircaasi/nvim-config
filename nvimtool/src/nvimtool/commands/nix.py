from ..config import Config
from ..datamodels import (
    PluginSpecs,
)

from ..nix_helpers import build_flake_source


def audit_nix(cfg: Config) -> None:
    paths = cfg.paths
    print(f"Auditing Nix plugins against {paths.config_source}")
    raise NotImplementedError


def write_flake(cfg: Config) -> None:
    print("Writing flake.nix")
    nix_data = PluginSpecs.read_json_file(cfg.paths.plugins_declaration)

    flake_nix = build_flake_source(nix_data)
    cfg.paths.flake.write_text(flake_nix)
