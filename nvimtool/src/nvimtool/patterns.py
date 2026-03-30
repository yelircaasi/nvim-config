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
    COMMAND_PATTERN = re.compile(
        (
            r"^(?P<annotation>[^ ]+)"
            r" +(?P<name>[A-Za-z]+ [A-Za-z]+|[^ ]+)"
            r" +(?P<args>[\d+\?\+\*]+)"
            r"( +(?P<address>[0\.%clb]+(?: {0,2}\?)?))?"
            r"( +(?P<complete><Lua function>|[a-z_]+))?"
            r" +(?P<definition>(?:call|:call|<Lua|lua)[^\n]+)"
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
