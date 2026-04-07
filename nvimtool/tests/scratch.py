from pathlib import Path

from adiumentum.io import write_json

from nvimtool.logic import search_plugin_directory


oil = Path("/nix/store/i0hj61lgz1qr8rg6762p07h7k3xzdvrq-vimplugin-luajit2.1-oil.nvim-2.15.0-1-unstable-2.15.0-1")
oil = Path("/home/isaac/.local/share/nvim-plugins/oil")
info_dir = Path("/tmp/oil_info.json")
info = search_plugin_directory(oil, "oil")

write_json(info.model_dump_json(), info_dir)
print(info_dir)

# TODO: check doc files for standards
# TODO: manually collect from oil, bamboo, which-key, 