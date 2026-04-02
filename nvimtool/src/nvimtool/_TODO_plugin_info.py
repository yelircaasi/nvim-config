"""

# Information Gleaning

Great task for regex + a bit of structure. Here's a breakdown by **what you're extracting** and **which source** it comes from:

---

## Commands

**Vimdoc / README** — look for backtick or colon-prefixed words:
```python
re.compile(r'(?<![`\w]):([A-Z][a-zA-Z]+\w*)', re.MULTILINE)
# matches :Telescope, :NvimTreeOpen, etc.
```
**Lua/Vimscript source:**
```python
re.compile(r'vim\.api\.nvim_create_user_command\(\s*["\'](\w+)["\']')
re.compile(r'command!?\s+(-\w+\s+)*(\w+)', re.MULTILINE)  # vimscript
```

---

## Lua Functions

**Source code** — exported module functions:
```python
re.compile(r'^(?:M|M\.\w+)\s*[=.]\s*function\s*\(', re.MULTILINE)
re.compile(r'^function\s+M\.(\w+)\s*\(', re.MULTILINE)
```
**README / docs** — usage examples:
```python
re.compile(r"require\(['\"][\w\.\-/]+['\"]\)\.(\w+)\s*\(")
```

---

## Highlight Groups

**Source code:**
```python
re.compile(r'vim\.api\.nvim_set_hl\(\s*\d+,\s*["\'](\w+)["\']')
re.compile(r'highlight\s+(?:default\s+)?(\w+)', re.MULTILINE)  # vimscript
```
**Vimdoc / README** — highlight groups are usually `PascalCase` and mentioned near "highlight":
```python
re.compile(r'\b([A-Z][a-zA-Z]+(?:Highlight|Hl|Color|Group|Normal|Float|Border|Sign|Virtual|Active|Inactive|Selected|Error|Warn|Info|Hint)?\w*)\b')
# This one's noisy — better to anchor it near keywords:
re.compile(r'(?:highlight|hl_group|hl)\s*[=:]\s*["\']?([A-Z]\w+)')
```

---

## Keymaps

**Source code:**
```python
re.compile(r'vim\.keymap\.set\(\s*["\'](\w+)["\'],\s*["\']([^"\']+)["\']')
re.compile(r'vim\.api\.nvim_set_keymap\(\s*["\'](\w+)["\'],\s*["\']([^"\']+)["\']')
re.compile(r'noremap|nnoremap|vnoremap|xnoremap|inoremap')  # vimscript, then capture after
```
**README / vimdoc:**
```python
re.compile(r'`(<[^`]+>|(?:<\w+>)*[a-zA-Z])`')  # backtick-wrapped like `<leader>ff`
re.compile(r'(?:^|\s)(<(?:leader|localleader|C|A|S|M)-\w+>|\w{1,3})', re.MULTILINE)
```

---

## Suggested Script Structure

```python
import re
from dataclasses import dataclass, field
from pathlib import Path

PATTERNS = {
    "commands": [
        re.compile(r'vim\.api\.nvim_create_user_command\(\s*["\'](\w+)["\']'),
        re.compile(r'^command!?\s+(?:-\w+\s+)*(\w+)', re.MULTILINE),
        re.compile(r'(?<![`\w]):([A-Z][a-zA-Z]\w*)', re.MULTILINE),  # docs
    ],
    "lua_functions": [
        re.compile(r'^function\s+M\.(\w+)\s*\(', re.MULTILINE),
        re.compile(r"require\(['\"][\w\.\-/]+['\"]\)\.(\w+)\s*\("),
    ],
    "highlights": [
        re.compile(r'vim\.api\.nvim_set_hl\(\s*\d+,\s*["\'](\w+)["\']'),
        re.compile(r'(?:highlight|hl_group)\s*[=:,\s]\s*["\']?([A-Z]\w+)'),
    ],
    "keymaps": [
        re.compile(r'vim\.keymap\.set\(\s*["\'](\w+)["\'],\s*["\']([^"\']+)["\']'),
        re.compile(r'`(<[^`]+>|[a-zA-Z]{1,3})`'),  # docs
    ],
}

@dataclass
class PluginInfo:
    commands:      set = field(default_factory=set)
    lua_functions: set = field(default_factory=set)
    highlights:    set = field(default_factory=set)
    keymaps:       set = field(default_factory=set)

def scrape_file(path: Path, info: PluginInfo):
    text = path.read_text(errors="ignore")
    for match in PATTERNS["commands"]:     info.commands.update(match.findall(text))
    for match in PATTERNS["lua_functions"]:info.lua_functions.update(match.findall(text))
    for match in PATTERNS["highlights"]:   info.highlights.update(match.findall(text))
    for match in PATTERNS["keymaps"]:      info.keymaps.update(match.findall(text))
```

---

## Practical Tips

- **Highlights are the noisiest** — you'll get false positives from PascalCase words. Post-filter against a known prefix list (plugin name, `Nvim`, `Lsp`, `Diagnostic`, `Tree`, etc.)
- **Vimdoc has consistent structure** — `*plugin-commands*` tags and `>` code blocks are reliable anchors. Parse sections rather than running global regexes.
- **For Lua, AST beats regex** for accuracy — `tree-sitter-python` or `ast` can't parse Lua, but [`luaparser`](https://github.com/boolangery/py-lua-parser) can if you need precision over speed.
- **Deduplicate across sources** — use `set` per category and merge at the end, since the same command often appears in docs, source, and README.

"""

from pathlib import Path
import glob
from adiumentum import safe_search_group1
from dataclasses import dataclass, field
import re

HERE = Path(".").resolve()

# to patterns.py
class SearchPatterns:
    COMMAND_LUA = re.compile(r'vim\.api\.nvim_create_user_command\(\s*["\'](\w+)["\']')
    COMMAND_VIM = re.compile(r'^\s*command!?\s+(?:-\w+\s+)*(\w+)', re.MULTILINE)
    COMMAND_DOCS = re.compile(r'(?<![`\w]):([A-Z][a-zA-Z]\w*)', re.MULTILINE)
    LUA_FUNCTION = re.compile(r'^function\s+M\.(\w+)\s*\(', re.MULTILINE)
    @staticmethod
    def LUA_FUNCTION_REQUIRED(module_name: str) -> re.Pattern:
        """Match calls like require('module').func("""
        return re.compile(r"require\(['\"]" + re.escape(module_name) + r"['\"]\)\.(\w+)\s*\(")
    HIGHLIGHT_GROUP_LUA = re.compile(r'vim\.api\.nvim_set_hl\(\s*\d+,\s*["\'](\w+)["\']')
    HIGHLIGHT_GROUP_VIM = re.compile(r'^\s*hi(?:ghlight)?\s+(?:default\s+)?([A-Z]\w+)', re.MULTILINE)
    KEYBIND_LUA = re.compile(
        r'vim\.keymap\.set\(\s*'
        r'["\']([^"\']+)["\'],\s*'               # group 1: mode
        r'["\']([^"\']+)["\'],\s*'               # group 2: lhs key sequence
        r'(function\b'                           # group 3: inline function literal
        r'|require\(["\'][\w./-]+["\']\)[\w.]*'  #          require('mod').fn
        r'|["\'][^"\']*["\']'                    #          string command e.g. ":w<CR>"
        r'|\w[\w.]*)'                            #          variable or fn reference
    )
    KEYBIND_LUA_API = re.compile(
        r'vim\.api\.nvim_set_keymap\(\s*'
        r'["\']([^"\']+)["\'],\s*'          # group 1: mode
        r'["\']([^"\']+)["\'],\s*'          # group 2: lhs key sequence
        r'["\']([^"\']*)["\']'              # group 3: rhs (always a string here)
    )
    KEYBIND_VIM = re.compile(
        r'^\s*([nvxitsco](?:nore)?map|(?:nore)?map)[!]?\s+'    # group 1: map command (encodes mode)
        r'(?:<(?:silent|buffer|expr|nowait|unique)>\s*)*'      # flags (non-capturing)
        r'(\S+)\s+'                                            # group 2: lhs key sequence
        r'(.+?)$',                                             # group 3: rhs command/action
        re.MULTILINE
    )
    KEYBIND_DOCS = re.compile(
        r'`(<(?:[A-Za-z0-9-]+|[A-Z]-\w)>(?:<[A-Za-z0-9-]+>)*'
        r'|(?:<\w+>)+\w*)`'
    )


# to datamodels.py
@dataclass
class PluginInfo:
    commands:      set[str] = field(default_factory=set)
    lua_functions: set[str] = field(default_factory=set)
    highlights:    set[str] = field(default_factory=set)
    keymaps:       set[tuple[str, str, str]] = field(default_factory=set)


# to utils.py (or adiumentum)
def ext_glob(extension: str = "*", path: Path | None = None, ignore: re.Pattern[str] | None = None) -> list[Path]:
    if not path:
        path = Path.cwd()
    expression = f"**/*.{extension}"
    result: list[str] = glob.glob(expression, recursive=True)
    if ignore:
        result = [p for p in result if not re.search(ignore)]
    return result





# to functions.py
def search_plugin_directory(dir: Path, plugin_name: str) -> PluginInfo:
    info = PluginInfo()
    lua_files = ext_glob("lua", dir)
    vim_files = ext_glob("vim", dir)
    txt_files = ext_glob("txt", dir)
    md_files = ext_glob("txt", dir)

    for file in lua_files:
        text = Path(file).read_text(errors="ignore")
        info.commands.update(SearchPatterns.COMMAND_LUA.findall(text))
        info.lua_functions.update(SearchPatterns.LUA_FUNCTION_REQUIRED(module_name).findall(text))
        info.highlights.update(SearchPatterns.HIGHLIGHT_GROUP_LUA.findall(text))
        info.keymaps.update(SearchPatterns.KEYBIND_LUA.findall(text))
        info.keymaps.update(SearchPatterns.KEYBIND_LUA_API.findall(text))
    for file in vim_files:
        ...
    for file in txt_files:
        ...
    for file in md_files:
        ...

    return info
