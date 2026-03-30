from pathlib import Path
from nvimtool_helpers import PluginSpecs


plugins_jsonc = Path.home() / "repos/nvim-config/testing/declarations/plugins.jsonc"

specs = PluginSpecs.read_json_file(plugins_jsonc)

print(specs[0])
