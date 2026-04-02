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
