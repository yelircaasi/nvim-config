from pathlib import Path


from ..config import Config
from ..datamodels import (
    PluginsLockMeta,
    PluginsLock,
)
from ..logic import (
    write_plugin_paths_tl,
)

from ..datamodels import (
    PluginSpecsMeta,
    SinglePluginLock,
    AvailableUpdates,
)
from ..shell_helpers import (
    check_for_updates,
)
from ..utils import (
    get_last_date,
)


def install_new(cfg: Config) -> None:
    """ """
    paths = cfg.paths
    print(f"Installing plugins to {paths.plugin_dir}")
    specs = PluginSpecsMeta.from_paths(paths)
    lock: PluginsLock = specs.install_plugins(cfg)
    write_plugin_paths_tl(paths, lock)
    lock.write_json_file(paths.plugins_lock)
    print(f"lockfile written to {paths.plugins_lock}")


def install_from_lockfile(cfg: Config) -> None:
    paths = cfg.paths
    """
    TODO: support installing from a lockfile
        e.g. newly cloned when old lockfile exists, and touching only the
        plugins that are not in the old lockfile or whose hash differs.
    """
    print(f"Installing plugins to {paths.plugin_dir}")
    lock_data = PluginsLockMeta.from_paths(paths)
    lock_data.install_plugins()
    write_plugin_paths_tl(paths, lock_data)


def update_plugin(path: Path | str) -> SinglePluginLock:
    print("Not yet implemented!")
    return SinglePluginLock.model_validate(
        {
            "url": "",
            "sha": "",
            "last_update": "",
            "location": "",
            "recency": "",
            "version": "",
        }
    )


def update_plugins(cfg: Config) -> None:
    print("Not yet implemented!")


def check_updates(cfg: Config) -> None:
    update_info: dict[str, dict[str, str | None]] = {}
    print(f"Checking updates, config at {cfg.paths.config_source}")
    specs = PluginSpecsMeta.from_paths(cfg.paths)
    lock = PluginsLockMeta.from_paths(cfg.paths)
    update_before = get_last_date(cfg)
    name: str
    repo: Path
    for name, repo in specs.names_and_paths:
        if lock.get_last_check(name) < update_before:
            updates_available: bool = check_for_updates(repo)
            if updates_available:
                update_info.update({name: {"path": cfg.paths.rel(repo)}})
                print(f"Updates available for {repo}")
    AvailableUpdates.model_validate(update_info).write_json_file(
        cfg.paths.available_updates
    )


def apply_updates(cfg: Config) -> None:
    paths = cfg.paths
    update_info = AvailableUpdates.read_json_file(paths.available_updates)
    lock = PluginsLockMeta.from_paths(paths)
    for name, info in update_info.items():
        lock_data = update_plugin(info.path)
        lock.update(name, lock_data)
    lock.lock.write_json_file(paths.plugins_lock)


def update_and_install_plugins(cfg: Config) -> None:
    check_updates(cfg)
    apply_updates(cfg)
