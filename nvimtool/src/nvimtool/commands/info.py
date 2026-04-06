import json


from ..config import Config
from ..logic import (
    parse_colors,
    parse_commands,
    parse_mappings,
    parse_rtp,
    profile_startup,
)

from ..shell_helpers import (
    export_nvim_info,
)
from ..utils import (
    change_extension,
)


def glean_nvim(cfg: Config) -> None: ...


def glean_plugin_source(cfg: Config) -> None: ...


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
