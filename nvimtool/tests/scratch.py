from collections import Counter
from pathlib import Path
import re

from adiumentum.io import write_json
from adiumentum.path import glob_extension
from nvimtool.logic import search_plugin_directory  # type: ignore


oil = Path(
    "/nix/store/i0hj61lgz1qr8rg6762p07h7k3xzdvrq-vimplugin-luajit2.1-oil.nvim-2.15.0-1-unstable-2.15.0-1"
)
oil = Path.home() / ".local/share/nvim-plugins/aerial"
info_dir = Path("/tmp/oil_info.json")
info = search_plugin_directory(oil, "oil")

write_json(info.model_dump_json(), info_dir)
print(info_dir)

# TODO: check doc files for standards
# TODO: manually collect from oil, bamboo, which-key,


exit()
if __name__ == "__main__":
    sections = []
    p = Path.home() / ".local/share/nvim-plugins"
    for plugin in p.iterdir():
        _p = p / plugin
        # print(_p)
        all_txt = glob_extension("txt", _p)
        for docfile in all_txt:
            _docfile = plugin / docfile
            print(_docfile)
            try:
                text = _docfile.read_text()
                _sections = re.findall(r"\n([A-Z]{3,}) ", text)
                sections.extend(_sections)
            except Exception:
                pass
    c = Counter(sections)
    for k, v in c.most_common():
        print(f"{v:>2}  {k}")
