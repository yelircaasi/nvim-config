import re


class Patterns:
    BLOCK_SPLITTER = re.compile(r"\n(?=[^\s])")
    COLOR_PATTERN = re.compile(
        (
            r"^(?P<name>[^ ]+)\s+xxx\s+"
            r"(?P<body>[^\n]+)"
            r"(\n\s+(?P<note>[^\s][^\n]+))?"
        ),
        re.MULTILINE,
    )
    COLOR_BODY_PATTERN = re.compile(
        (
            r"(cterm=(?P<cterm>[^\s]+)\s*)?"
            r"(ctermfg=(?P<ctermfg>[^\s]+)\s*)?"
            r"(ctermbg=(?P<ctermbg>[^\s]+)\s*)?"
            r"(gui=(?P<gui>[^\s]+)\s*)?"
            r"(guifg=(?P<guifg>[^\s]+)\s*)?"
            r"(guibg=(?P<guibg>[^\s]+)\s*)?"
            r"(guisp=(?P<guisp>[^\s]+)\s*)?"
            r"(font=(?P<font>[^\s]+|'[^']+?'])\s*)?"
            r"(blend=(?P<blend>[^\s]+)\s*)?"
            r"(start=(?P<start>[^\s]+)\s*)?"
            r"(stop=(?P<stop>[^\s]+)\s*)?"
            r"(links to (?P<linksTo>[^\s]+)\s*)?"
        )
    )
    COLOR_KEYS = (
        "linksTo",
        "note",
        "cterm",
        "ctermfg",
        "ctermbg",
        "gui",
        "guifg",
        "guibg",
        "guisp",
        "font",
        "blend",
        "start",
        "stop",
    )
    # COMMAND_PATTERN = re.compile(
    #     (
    #         r"^(?P<annotation>[^ ]+)"
    #         r" +(?P<name>[A-Za-z]+ [A-Za-z]+|[^ ]+)"
    #         r" +(?P<args>[\d+\?\+\*]+)"
    #         r"( +(?P<address>[0\.%clb]+(?: {0,2}\?)?))?"
    #         r"( +(?P<complete><Lua function>|[a-z_]+))?"
    #         r" +(?P<definition>(?:call|:call|<Lua|lua)[^\n]+)"
    #         r"(\n?\t\t+\s*(?P<description>[^\n]+))?"
    #     )
    # )
    COMMAND_PATTERN = re.compile(
        (
            r"^(?P<annotation>[^ ]+)"
            r" +(?P<name>[^ ]+)"
            r" +(?P<args>[\d+\?\+\*]+)"
            r"( +(?P<address>[0\.%clb]+(?: {0,2}\?)?))?"
            r"( +(?P<complete><Lua function>|[a-z_]+))?"
            r" +(?P<definition>(?::?call|<Lua|:?lua|exe|:?exec|<line)[^\n]+)"
            r"(\n?\t\t+\s*(?P<description>[^\n]+))?"
        )
    )
    COMMAND_KEYS = (
        "annotation",
        "name",
        "args",
        "address",
        "complete",
        "definition",
        "description",
    )
    MAPPING_PATTERN = re.compile(
        (
            r"^(?P<mode>[^ ]+)"
            r" +(?P<keybind>[^ ]+)"
            r"( +(?P<annotation>\*))?"
            r"( +(?P<definition>[^\n]+))?"
            r"(\n {5,}(?P<description>[^\n]+))?"
            r"\n\s+(?P<origin>Last set [^\n]+)"
        )
    )
    MAPPING_KEYS = (
        "mode",
        "keybind",
        "annotation",
        "definition",
        "description",
        "origin",
    )


class SearchPatterns:
    COMMAND_LUA = re.compile(r'vim\.api\.nvim_create_user_command\(\s*["\'](\w+)["\']')
    COMMAND_VIM = re.compile(r"^\s*command!?\s+(?:-\w+\s+)*(\w+)", re.MULTILINE)
    COMMAND_DOCS = re.compile(r"(?<![`\w]):([A-Z][a-zA-Z]\w*)", re.MULTILINE)
    LUA_FUNCTION = re.compile(r"function +M\.([a-zA-Z0-9_]+)\s*\(")
    LUA_FUNCTION_ALT = re.compile(r"M\.([a-zA-Z0-9_]+) += +function\(")
    DOC_COMMAND = re.compile(r" \*:([a-zA-Z_]+)\*")
    DOC_FUNCTION = re.compile(r" \*[a-z0-9_-]+\.([a-zA-Z_]+)[\*\(]")
    DOC_HIGHLIGHT = re.compile(r"[A-Z][a-z]+(?:[A-Z][a-z]*)+")
    AUTOCOMMAND_LUA = re.compile(r"nvim_create_autocmd\(['\"]([^'\"]+)['\"]")

    @staticmethod
    def LUA_FUNCTION_REQUIRED(module_name: str) -> re.Pattern:
        """Match calls like require('module').func("""
        return re.compile(
            r"require\(['\"]" + re.escape(module_name) + r"['\"]\)\.([a-zA-Z0-9_]+)\("
        )

    HIGHLIGHT_GROUP_LUA = re.compile(
        r'vim\.api\.nvim_set_hl\(\s*\d+,\s*["\'](\w+)["\']'
    )
    HIGHLIGHT_GROUP_VIM = re.compile(
        r"^\s*hi(?:ghlight)?\s+(?:default\s+)?([A-Z]\w+)", re.MULTILINE
    )
    HIGHLIGHT_GROUP_DOCS = re.compile(r"^(?!)$")  # TODO
    # KEYBIND_LUA = re.compile(
    #     r"(?:vim\.keymap\.set\|map)(\s*"
    #     r'["\']([^"\']+)["\'],\s*'  #   group 1: mode
    #     r'["\']([^"\']+)["\'],\s*'  #   group 2: lhs key sequence
    #     r"(function\b"  #               group 3: inline function literal
    #     r'|require\(["\'][\w./-]+["\']\)[\w.]*'  # require('mod').fn
    #     r'|["\'][^"\']*["\']'  #        string command e.g. ":w<CR>"
    #     r"|\w[\w.]*)"  #                variable or fn reference
    # )
    KEYBIND_LUA = re.compile(
        r"(?:vim\.keymap\.set|map)\s*\(\s*"
        r"("  # group 1: mode — string or table
        r'["\'][^"\']+["\']'  # "n"
        r"|"
        r'\{\s*["\'][^"\']+["\']'  # { "n"
        r'(?:\s*,\s*["\'][^"\']+["\'])*'  #   , "v"  (repeated)
        r"\s*\}"  # }
        r"),\s*"
        r'["\']([^"\']+)["\'],\s*'  # group 2: lhs key sequence
        r"("  # group 3: rhs
        r"function\b"
        r'|require\(["\'][\w./-]+["\']\)[\w.]*'
        r'|["\'][^"\']*["\']'
        r"|\w[\w.]*"
        r")"
    )
    KEYBIND_LUA_API = re.compile(
        r"vim\.api\.nvim_set_keymap\(\s*"
        r'["\']([^"\']+)["\'],\s*'  # group 1: mode
        r'["\']([^"\']+)["\'],\s*'  # group 2: lhs key sequence
        r'["\']([^"\']*)["\']'  # group 3: rhs (always a string here)
    )
    KEYBIND_VIM = re.compile(
        r"^\s*([nvxitsco](?:nore)?map|(?:nore)?map)[!]?\s+"  # group 1: map command (encodes mode)
        r"(?:<(?:silent|buffer|expr|nowait|unique)>\s*)*"  # flags (non-capturing)
        r"(\S+)\s+"  # group 2: lhs key sequence
        r"(.+?)$",  # group 3: rhs command/action
        re.MULTILINE,
    )
    KEYBIND_DOCS = re.compile(
        r"`(<(?:[A-Za-z0-9-]+|[A-Z]-\w)>(?:<[A-Za-z0-9-]+>)*"
        r"|(?:<\w+>)+\w*)`"
    )
