from typing import Annotated, Callable
from pathlib import Path

import typer
from adiumentum.color import color

from .config import Config, Globals
from .commands import default_command, info, nix, plugins, tools, tl


app = typer.Typer(help='Neovim helper CLI: "Separate installation from configuration."')


def _fallback(_: Config) -> None:
    print(color.red("Not yet implemented!."))


DISPATCHER: dict[tuple[str | None, str | None], Callable[[Config], None]] = {
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
    ("nix", "write-plugins"): nix.write_plugins,
    ("info", None): info.get_info_all,
    ("info", "nvim"): info.glean_nvim,
    ("info", "plugin-source"): info.glean_plugin_source,
    ("info", "all"): info.get_info_all,
    ("info", "startup"): info.get_info_startup,
    ("info", "colors"): info.get_info_colors,
    ("info", "commands"): info.get_info_commands,
    ("info", "rtp"): info.get_info_rtp,
}


@app.callback(invoke_without_command=True)
def main(
    ctx: typer.Context,
    config_file: Path = typer.Option(
        Globals.DEFAULT_CONFIG_SOURCE / "nvimtool.json",
        "--config",
        "-c",
    ),
    config_source: Path = typer.Option(
        Globals.DEFAULT_CONFIG_SOURCE,
        "--config-source",
        "-s",
    ),
    config_target: Path = typer.Option(
        Globals.DEFAULT_CONFIG_TARGET,
        "--config-target",
        "-t",
    ),
    plugin_dir: Path = typer.Option(
        Globals.DEFAULT_PLUGIN_DIR,
        "--plugin-dir",
    ),
    plugins_jsonc: Path | None = typer.Option(
        None,
        "--plugin-declaration",
    ),
    plugins_lockfile: Path | None = typer.Option(
        None,
        "--plugin-lockfile",
    ),
    verbose: bool = typer.Option(False, "--verbose", "-v"),
) -> None:

    cfg = Config.from_args(
        config_file,
        config_source,
        config_target,
        plugin_dir,
        plugins_jsonc,
        plugins_lockfile,
        verbose,
    )

    cfg.printv(locals())

    ctx.obj = cfg

    # No subcommand → default
    if ctx.invoked_subcommand is None:
        _run(ctx, None, None)


def _run(ctx: typer.Context, sub: str | None, subsub: str | None) -> None:
    cfg: Config = ctx.obj

    pair = (sub, subsub)
    cfg.printv(pair)

    func = DISPATCHER.get(pair, _fallback)
    func(cfg)


@app.command()
def all(ctx: typer.Context) -> None:
    _run(ctx, "all", None)


# ---- tl ----
tl_app = typer.Typer()
app.add_typer(tl_app, name="tl")


@tl_app.command()
def transpile(ctx: typer.Context) -> None:
    _run(ctx, "tl", "transpile")


@tl_app.callback(invoke_without_command=True)
def tl_root(ctx: typer.Context) -> None:
    if ctx.invoked_subcommand is None:
        _run(ctx, "tl", None)


# ---- plugins ----
plugins_app = typer.Typer()
app.add_typer(plugins_app, name="plugins")


@plugins_app.command("install-new")
def install_new(ctx: typer.Context) -> None:
    _run(ctx, "plugins", "install-new")


@plugins_app.command("install-from-lockfile")
def install_from_lockfile(ctx: typer.Context) -> None:
    _run(ctx, "plugins", "install-from-lockfile")


@plugins_app.command()
def update(ctx: typer.Context) -> None:
    _run(ctx, "plugins", "update")


@plugins_app.command("check-updates")
def check_updates(ctx: typer.Context) -> None:
    _run(ctx, "plugins", "check-updates")


@plugins_app.command("apply-updates")
def apply_updates(ctx: typer.Context) -> None:
    _run(ctx, "plugins", "apply-updates")


@plugins_app.callback(invoke_without_command=True)
def plugins_root(ctx: typer.Context) -> None:
    if ctx.invoked_subcommand is None:
        _run(ctx, "plugins", None)


# ---- tools ----
tools_app = typer.Typer()
app.add_typer(tools_app, name="tools")


@tools_app.command()
def check(ctx: typer.Context) -> None:
    _run(ctx, "tools", "check")


@tools_app.command()
def snapshot(ctx: typer.Context) -> None:
    _run(ctx, "tools", "snapshot")


@tools_app.command("write-script")
def write_script(ctx: typer.Context) -> None:
    _run(ctx, "tools", "write-script")


@tools_app.callback(invoke_without_command=True)
def tools_root(ctx: typer.Context) -> None:
    if ctx.invoked_subcommand is None:
        _run(ctx, "tools", None)


# ---- nix ----
nix_app = typer.Typer()
app.add_typer(nix_app, name="nix")


@nix_app.command()
def audit(ctx: typer.Context) -> None:
    _run(ctx, "nix", "audit")


@nix_app.command("write-flake")
def write_flake(ctx: typer.Context) -> None:
    _run(ctx, "nix", "write-flake")


@nix_app.command("write-plugins")
def write_plugins(ctx: typer.Context) -> None:
    _run(ctx, "nix", "write-plugins")


@nix_app.callback(invoke_without_command=True)
def nix_root(ctx: typer.Context):
    if ctx.invoked_subcommand is None:
        _run(ctx, "nix", None)


# ---- info ----
info_app = typer.Typer()
app.add_typer(info_app, name="info")


@info_app.command()
def nvim(ctx: typer.Context) -> None:
    _run(ctx, "info", "nvim")


@info_app.command()
def mappings(ctx: typer.Context) -> None:
    _run(ctx, "info", "mappings")


@info_app.command()
def startup(ctx: typer.Context) -> None:
    _run(ctx, "info", "startup")


@info_app.command()
def commands(ctx: typer.Context) -> None:
    _run(ctx, "info", "commands")


@info_app.command()
def colors(ctx: typer.Context) -> None:
    _run(ctx, "info", "colors")


@info_app.command("plugin-source")
def plugin_source(ctx: typer.Context) -> None:
    _run(ctx, "info", "plugin-source")


@info_app.callback(invoke_without_command=True)
def info_root(
    ctx: typer.Context,
    # exec: Annotated[str, typer.Argument(default="nvim")],
) -> None:
    if ctx.invoked_subcommand is None:
        _run(ctx, "info", None)
