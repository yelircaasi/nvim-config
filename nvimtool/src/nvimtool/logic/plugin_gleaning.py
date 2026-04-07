"""
TODO: ad-hoc suites: blink, snacks, mini
"""

import re
from adiumentum.path import glob_extension

from pathlib import Path


from ..datamodels import SinglePluginInfo
from ..patterns import SearchPatterns


def get_init_file(dir_: Path, plugin_require_name: str) -> str:
    init = dir_ / "lua" / plugin_require_name / "init.lua"
    alt = dir_ / f"lua/{plugin_require_name}.lua"
    if init.exists():
        return init.read_text()
    elif alt.exists():
        return alt.read_text()
    return ""


def get_doc_file_sections(dir_: Path, plugin_require_name: str) -> list[str]:
    candidate = dir_ / f"doc/{plugin_require_name}.txt"
    if candidate.exists():
        sections = re.split("\n(?=[A-Z]{3,})", candidate.read_text())
        return sections
    return []


def get_highlights_from_vimdoc(sections: list[str]) -> list[str]:
    for section in sections:
        if section.startswith(("HIGHLIGHT", "COLOR")):
            return section.strip().splitlines()[1:]
    return []


def get_commands_from_vimdoc(sections: list[str]) -> list[str]:
    for section in sections:
        if section.startswith(("COMMAND")):
            return section.strip().splitlines()[1:]
    return []


def get_functions_from_vimdoc(sections: list[str]) -> list[str]:
    for section in sections:
        if section.startswith(("API ", "LUA ")):
            return section.strip().splitlines()[1:]
    return []


def get_functions_from_init(s: str) -> list[str]:
    result = re.search(r"\s+return\s+([^ \n]+?)\s+$", s)
    if not result:
        return []
    modname = result.group(1)
    pattern = re.compile(f"{modname}\\.([^ \n\\=\\(]+)[ =\\(]")
    return pattern.findall(s)


def search_plugin_directory(
    plugin_directory: Path | str, plugin_require_name: str
) -> SinglePluginInfo:
    """Get init file"""
    plugin_directory = Path(plugin_directory)
    print(plugin_directory)
    info = SinglePluginInfo()
    lua_files = glob_extension("lua", plugin_directory)
    vim_files = glob_extension("vim", plugin_directory)
    txt_files = glob_extension("txt", plugin_directory)
    md_files = glob_extension("txt", plugin_directory)
    print(lua_files)
    print(vim_files)
    print(txt_files)
    print(md_files)
    if not (lua_files or vim_files or txt_files or md_files):
        print(f"Not a Lua or Vimscript plugin: {plugin_directory}.")

    doc_sections = get_doc_file_sections(plugin_directory, plugin_require_name)
    if doc_sections:
        info.has_vimdoc = True
    init_file = get_init_file(plugin_directory, plugin_require_name)
    if init_file:
        info.has_lua = True
    info.lua_functions.update(get_functions_from_init(init_file))
    info.lua_functions.update(get_functions_from_vimdoc(doc_sections))
    info.commands.update(get_commands_from_vimdoc(doc_sections))
    info.highlights.update(get_highlights_from_vimdoc(doc_sections))

    def read_if_file(_p: Path) -> str:
        if _p.is_file():
            return _p.read_text(errors="ignore")
        return ""

    for file in lua_files:
        text = read_if_file(file)
        info.commands.update(SearchPatterns.COMMAND_LUA.findall(text))
        info.lua_functions.update(
            SearchPatterns.LUA_FUNCTION_REQUIRED(plugin_require_name).findall(text)
        )
        info.lua_functions.update(SearchPatterns.LUA_FUNCTION.findall(text))
        info.highlights.update(SearchPatterns.HIGHLIGHT_GROUP_LUA.findall(text))
        info.keymaps.update(SearchPatterns.KEYBIND_LUA.findall(text))
        info.keymaps.update(SearchPatterns.KEYBIND_LUA_API.findall(text))
    for file in vim_files:
        text = read_if_file(file)
        info.commands.update(SearchPatterns.COMMAND_VIM.findall(text))
        info.highlights.update(SearchPatterns.HIGHLIGHT_GROUP_VIM.findall(text))
        info.keymaps.update(SearchPatterns.KEYBIND_VIM.findall(text))
    for file in txt_files + md_files:
        text = read_if_file(file)
        info.commands.update(SearchPatterns.COMMAND_DOCS.findall(text))
        info.lua_functions.update(
            SearchPatterns.LUA_FUNCTION_REQUIRED(plugin_require_name).findall(text)
        )
        info.highlights.update(SearchPatterns.HIGHLIGHT_GROUP_DOCS.findall(text))
        info.keymaps.update(SearchPatterns.KEYBIND_DOCS.findall(text))

    return info


"""
80  CONFIGURATION
77  CONTENTS
71  INTRODUCTION
64  THE
57  USAGE
54  MIT
53  INSTALLATION
50  COMMANDS
46  MAPPINGS
42  API
36  LSP
35  REQUIREMENTS
34  FEATURES
31  CUSTOM
26  SETUP
21  GNU
20  COMPLETION
20  DEFAULT
17  OTHER
16  HIGHLIGHT
15  OPTIONS
15  FITNESS
14  FAQ
14  LUA
14  COMMAND
14  EXAMPLES
13  QUICK
13  CHANGING
12  ADVANCED
12  ALL
12  HOW
12  SECTION
12  PUT
11  USE
11  HIGHLIGHTS
11  STATUS
11  USING
10  EXTENDING
10  VERSION
10  EXAMPLE
 9  DATA
 9  TELESCOPE
 9  STATUSLINE
 9  DIAGNOSTICS
 9  HOLDERS
 9  WILL
 9  SUCH
 9  AUTHORS
 9  OUT
 9  LICENSE
 9  EVENTS
 9  ARISING
 9  BASIC
 9  OPTION
 9  HELP
 8  FUNCTIONS
 8  SETTINGS
 8  ADDING
 8  APPLICABLE
 8  PARTIES
 8  EVEN
 8  DISABLE
 8  INSPIRATION
 8  DROPBAR
 7  TABLE
 7  LIST
 7  PREVIEW
 7  TROUBLESHOOTING
 7  ANY
 7  EXPRESS
 7  BUFFER
 7  REGION
 7  TREESITTER
 7  ABOUT
 7  TEXT
 7  ACTIONS
 7  AVAILABLE
 7  KEYBINDINGS
 7  COMPLETE
 7  LLM
 7  KEYMAPS
 7  SYNTAX
 6  CREDITS
 6  EXTENSIONS
 6  SNIPPET
 6  COMMONS
 6  COPYRIGHT
 6  AUTHORIZED
 6  CONTAINED
 6  UNLESS
 6  BEEN
 6  LIMITED
 6  KIND
 6  WHETHER
 6  PERFORMANCE
 6  MORE
 6  TOC
 6  SPAN
 6  KEY
 6  FZF
 6  TERMINAL
 6  CREATING
 6  USER
 6  CHAT
 6  SLASH
 6  INLINE
 6  MCP
 6  DAP
 5  DYNAMIC
 5  GENERAL
 5  WITHOUT
 5  HTML
 5  SIGNS
 5  THIS
 5  OFFERS
 5  LATENT
 5  WHAT
 5  TOOLING
 5  MODE
 5  INSTALL
 5  MARKDOWN
 5  SOURCES
 5  CONFIG
 5  CONFIGURE
 5  SEARCH
 5  ISSUES
 5  SUB
 5  EDITOR
 5  ACTION
 5  PROMPT
 5  NAVIGATION
 5  GIT
 5  SMART
 4  TERMS
 4  END
 4  RECIPES
 4  STRUCTURE
 4  PROCUREMENT
 4  NEGLIGENCE
 4  CONTRIBUTORS
 4  BEHIND
 4  REFERENCE
 4  SPLIT
 4  INTEGRATION
 4  CODE
 4  BUILTIN
 4  MAPS
 4  ADAPTERS
 4  LAZY
 4  PACKER
 4  LAYOUT
 4  SOURCE
 4  GLOBAL
 4  TAGS
 4  CLOCK
 4  RECOMMENDED
 4  PICKERS
 4  VISUAL
 4  SPECIFYING
 4  SUPPORTED
 4  PHP
 4  FILE
 4  TOOL
 4  FUZZY
 4  BUFFERS
 3  LIMITATIONS
 3  INDENT
 3  CONDITIONS
 3  ENVIRONMENT
 3  FILTERS
 3  COLORS
 3  FURTHER
 3  GETTING
 3  TORT
 3  SOFTWARE
 3  AUTOCOMMANDS
 3  LOG
 3  MERCHANTABILITY
 3  WITH
 3  PATTERN
 3  CLI
 3  WHY
 3  SIMILAR
 3  CURRENT
 3  IMPLEMENTATION
 3  SIGNATURE
 3  FOLDING
 3  RUNNING
 3  ICONS
 3  PLUGINS
 3  FUNCTION
 3  TIPS
 3  MENU
 3  HIGHLIGHTING
 3  ARCHITECTURE
 3  OVERVIEW
 3  COMMON
 3  SNACKS
 3  CONTRIBUTING
 3  SIDEBAR
 3  SET
 3  DEPENDENCIES
 3  NOTES
 3  SPECIAL
 3  FILETYPE
 3  GENERATING
 3  ALTERNATIVES
 3  FULL
 3  COMMUNITY
 3  DOCUMENTATION
 3  OVERRIDE
 3  RULE
 3  PLUGIN
 3  SPONSORS
 3  GITHUB
 3  GREP
 3  SETTING
 3  TOOLS
 3  CLIENT
 3  ACP
 3  ADAPTER
 3  HIDING
 3  DIFF
 3  AUTO
 3  CONTEXT
 3  WHEN
 3  LANGUAGE
 3  CUSTOMIZATION
 3  DEMO
 3  NOTIFICATIONS
 3  DISABLING
 3  MINIMAL
 3  FILES
 3  SCRATCH
 3  SELECT
 3  ACCEPT
 3  SHOW
 3  APPEARANCE
 3  KEYMAP
 2  DYNAMICALLY
 2  INTEGRATIONS
 2  REPOSITORY
 2  SNIPMATE
 2  JUMPING
 2  MAKE
 2  AUTOMATICALLY
 2  OPEN
 2  MAP
 2  ENV
 2  COMMIT
 2  AND
 2  COVERED
 2  YOU
 2  WORK
 2  DAMAGES
 2  REGARD
 2  LOSS
 2  EXCEPT
 2  HIGH
 2  HANDLERS
 2  HOVER
 2  VIMSCRIPT
 2  MULTI
 2  POSITION
 2  NESTED
 2  COMPOSED
 2  PARTS
 2  ROW
 2  COLUMN
 2  STEP
 2  JUSTIFY
 2  MERGE
 2  SAMPLE
 2  DOCUMENT
 2  SYMBOL
 2  TODO
 2  ATTACHING
 2  VARIABLES
 2  VERTICAL
 2  PRESETS
 2  MARKS
 2  REGISTERS
 2  SPELLING
 2  UTILS
 2  HISTORY
 2  LATEST
 2  INCLUDE
 2  TYPINGS
 2  VARIABLE
 2  TREESJ
 2  DOOM
 2  PATH
 2  MULTIPLEXER
 2  TMUX
 2  WEZTERM
 2  NUMBERS
 2  REGULAR
 2  FILTERING
 2  COLORSCHEME
 2  AUTOMATIC
 2  INDENTATION
 2  LINKS
 2  RUN
 2  KNOWN
 2  MODULES
 2  TYPE
 2  LUALINE
 2  HEAD
 2  FEATURE
 2  BACKGROUND
 2  EXTERNAL
 2  BUILTINS
 2  PARSING
 2  CUE
 2  RUST
 2  INTERNALS
 2  METHOD
 2  AIDING
 2  SHORTHAND
 2  FASTWRAP
 2  AUTOTAG
 2  ENDWISE
 2  FROM
 2  REGEX
 2  PROTOCOL
 2  SEE
 2  CONTROLLING
 2  REGISTERING
 2  ENABLING
 2  RULES
 2  APPLYING
 2  REFRESHING
 2  SYSTEM
 2  IMAGES
 2  AGENTS
 2  YOLO
 2  REQUEST
 2  SUBWORD
 2  REPLACE
 2  VIEW
 2  COMPONENT
 2  COMPONENTS
 2  CLIPBOARD
 2  SUPPORT
 2  INSERT
 2  AUTOCMDS
 2  HOOKS
 2  BEAMSCOPE
 2  NOTE
 2  CONFIGURING
 2  MERGING
 2  VIM
 2  FLOAT
 2  EXPLORER
 2  LINES
 2  RESUME
 2  ZOXIDE
 2  INPUT
 2  DASHBOARD
 2  LAZYGIT
 2  NOTIFICATION
 2  ZEN
 2  DEBUGEE
 2  PROVIDERS
 2  COMPARED
 2  HIDE
 2  KEYWORD
 2  TRIGGER
 2  GHOST
 2  SNIPPETS
 2  OPTIONAL
 1  INTERFACE
 1  DEPRECATED
 1  SMARTER
 1  DELETE
 1  YANK
 1  SESSIONS
 1  LAMBDA
 1  MATCH
 1  REPEAT
 1  PARTIAL
 1  NONEMPTY
 1  FMT
 1  CONDITION
 1  TRANSFORMATIONS
 1  STANDALONE
 1  RELOADING
 1  LOADERS
 1  SUMMARY
 1  STRATEGIES
 1  QUERIES
 1  LOGGING
 1  ACKNOWLEDGMENTS
 1  PREREQUISITES
 1  METALS
 1  SUBJECTS
 1  FLASHCARDS
 1  DESCRIPTION
 1  ENABLE
 1  SILENT
 1  WRITE
 1  DEVELOPMENT
 1  CONTRIBUTION
 1  FULLEST
 1  WARRANTY
 1  UNDER
 1  COMMERCIAL
 1  NOT
 1  PARTYS
 1  SOME
 1  MAY
 1  STATED
 1  PROGRAM
 1  CONSTITUTES
 1  IMPLIED
 1  LOST
 1  EXERCISE
 1  POSSIBILITY
 1  REQUESTS
 1  PREPARE
 1  SUPERTYPES
 1  SUBTYPES
 1  EXTENSION
 1  OWNER
 1  THEORY
 1  ENDLESSLY
 1  SIDEBARS
 1  UNIQUE
 1  CLICKABLE
 1  CLOSE
 1  GET
 1  FETCH
 1  LIMITATION
 1  MATCHED
 1  TABSTOP
 1  LINKED
 1  EXPAND
 1  NAVIGATOR
 1  GOLANG
 1  ADD
 1  TRY
 1  DEPENDENCY
 1  INTEGRAT
 1  SCREENSHOTS
 1  DEFINITION
 1  GUI
 1  WORKSPACE
 1  DIAGNOSTIC
 1  EDIT
 1  FZY
 1  FILL
 1  CALL
 1  LIGHT
 1  CODELENS
 1  PREDEFINED
 1  DEBUG
 1  BREAK
 1  ERRORS
 1  TARGETS
 1  REPLACEMENTS
 1  CUSTOMIZING
 1  PHILOSOPHY
 1  PREVIEWING
 1  TUTORIAL
 1  LAUNCHING
 1  INCLUDED
 1  DJANGO
 1  DEBUGPY
 1  EXTEND
 1  TRIGGERS
 1  HYDRA
 1  THEMES
 1  RESOLVE
 1  PREVIEWERS
 1  LANGUAGES
 1  METHODS
 1  THEME
 1  HYPER
 1  CHANGED
 1  BAR
 1  NORMALIZE
 1  DEVELOPERS
 1  MAKING
 1  DEMOS
 1  PRESET
 1  MODECONFIG
 1  STATICCONFIG
 1  SHORTCUTS
 1  LOADING
 1  SHARED
 1  EXACT
 1  SPECIFICITY
 1  GUIDES
 1  MARK
 1  BOOKMARK
 1  BOOKMARKS
 1  SCREENSHOT
 1  ZELLIJ
 1  KITTY
 1  NVIM
 1  PERSISTENT
 1  STYLING
 1  STYLE
 1  TABPAGES
 1  GROUPS
 1  ORDERING
 1  GROUP
 1  PINNING
 1  BUFFERLINE
 1  MOUSE
 1  WORKING
 1  MAIN
 1  UTILITY
 1  AGENDA
 1  CALENDAR
 1  RECALCULATING
 1  DATES
 1  CHINESE
 1  GLOB
 1  DURING
 1  RANGES
 1  MAGIC
 1  ACTIVATE
 1  FREQUENTLY
 1  MODES
 1  REGIONS
 1  SINGLE
 1  COLEMAK
 1  HJKL
 1  VIEWS
 1  NUI
 1  NOTIFY
 1  VIRTUAL
 1  FORMATTING
 1  ROUTES
 1  ALTERNATIVE
 1  INSTANCE
 1  IMPLEMENTING
 1  DECIMAL
 1  DOT
 1  ADDITIVE
 1  LISTING
 1  PLUGS
 1  RATIONALE
 1  CODEBLOCKS
 1  LINKING
 1  VIMDOC
 1  DETAILS
 1  KEYBOARD
 1  REMOVE
 1  INTRO
 1  ATTACH
 1  FLOATING
 1  SHOULD
 1  TEST
 1  UPGRADE
 1  AUTH
 1  RPC
 1  MIGRATION
 1  MOTIVATION
 1  SOMETHING
 1  DOES
 1  TESTS
 1  CLOJURE
 1  COFFEESCRIPT
 1  CSS
 1  ELIXIR
 1  ELM
 1  ERUBY
 1  FASTA
 1  HAML
 1  HANDLEBARS
 1  HARE
 1  JAVA
 1  JAVASCRIPT
 1  JSX
 1  PERL
 1  PYTHON
 1  RUBY
 1  SCSS
 1  LESS
 1  SHELL
 1  TEX
 1  YAML
 1  INDEX
 1  ENTRY
 1  LINK
 1  RSSHUB
 1  REDDIT
 1  DATE
 1  LIMIT
 1  DEPRECATIONS
 1  INTERACTIONS
 1  SUGGESTED
 1  CONTENT
 1  STATE
 1  MODEL
 1  CLEANUP
 1  CLAUDE
 1  HTTP
 1  AZURE
 1  OLLAMA
 1  OPENAI
 1  CALLBACKS
 1  PREVENTING
 1  TRUNCATING
 1  OVERRIDING
 1  PARSERS
 1  OTHERS
 1  INSTALLING
 1  SENDING
 1  COPYING
 1  NAVIGATING
 1  QUICKLY
 1  MESSAGES
 1  TURNING
 1  SECURITY
 1  COMPATIBILITY
 1  TARGET
 1  MULTIPLE
 1  CLEARING
 1  EVENT
 1  CONSUMING
 1  CLASSIFICATION
 1  WORKFLOWS
 1  HANDLER
 1  LIFECYCLE
 1  RESPONSE
 1  SCHEMA
 1  MIGRATING
 1  LOCAL
 1  BEST
 1  PROCESSING
 1  BUILDING
 1  SUPPORTING
 1  PROGRESS
 1  BOXES
 1  COERCION
 1  LEGACY
 1  NEOVIDE
 1  JSON
 1  CONSTANTS
 1  DEV
 1  ASYNC
 1  SYMBOLS
 1  SKIPPING
 1  EXTRAS
 1  CONSISTENT
 1  MOTIONS
 1  MACRO
 1  MACOS
 1  WARNINGS
 1  PICKER
 1  FINDERS
 1  VERSIONING
 1  ACKNOWLEDGEMENTS
 1  FILTER
 1  FILTERED
 1  NETRW
 1  EXPANDERS
 1  CONTAINER
 1  POPUPS
 1  COMMENT
 1  PACKAGE
 1  AUTOCOMPLETE
 1  DENITE
 1  COMPILER
 1  LATEXMK
 1  LATEXRUN
 1  TECTONIC
 1  ARARA
 1  GENERIC
 1  GRAMMAR
 1  TEXTIDOTE
 1  VLTY
 1  VIEWER
 1  SYNCTEX
 1  LATEX
 1  ONLINE
 1  CTAN
 1  OFFLINE
 1  CITATION
 1  CHANGELOG
 1  PLUG
 1  MODIFYING
 1  CLIENTS
 1  CIDER
 1  URL
 1  EXPERIMENTAL
 1  PRACTICAL
 1  OPERATIONS
 1  OPERATORS
 1  LINE
 1  INTELLIGENT
 1  ACTIVATION
 1  COMBINE
 1  OPERATION
 1  CURSOR
 1  CONFLICTS
 1  WORKSPACES
 1  CONCEALING
 1  CONNECTING
 1  REVIEWING
 1  DRAFT
 1  TEMPORARY
 1  DISCUSSIONS
 1  LABELS
 1  EMOJIS
 1  UPLOADING
 1  PIPELINES
 1  REVIEWERS
 1  RESTARTING
 1  WINDOW
 1  JUMP
 1  STARTING
 1  SEPARATORS
 1  TABLINE
 1  WINBAR
 1  WIKI
 1  TOML
 1  TLDR
 1  SIGNATURES
 1  TAKE
 1  BIG
 1  EDGY
 1  FLASH
 1  TROUBLE
 1  CLIPHIST
 1  COLORSCHEMES
 1  JUMPS
 1  LOCLIST
 1  MAN
 1  PROJECTS
 1  QFLIST
 1  RECENT
 1  UNDO
 1  BOTTOM
 1  DROPDOWN
 1  IVY
 1  LEFT
 1  RIGHT
 1  TOP
 1  VSCODE
 1  MOVING
 1  ITEM
 1  CHAFA
 1  POKEMON
 1  STARTIFY
 1  CAVEATS
 1  PROFILING
 1  TRACES
 1  RENDERING
 1  STANDARD
 1  DELETING
 1  SHOWCASE
 1  SWAPPING
 1  PICK
 1  POPULATE
 1  REGEXES
 1  RECURSIVE
 1  ETYMOLOGY
 1  WALKTHROUGH
 1  README
 1  REPL
 1  WIDGET
 1  LISTENERS
 1  CREDIT
 1  EMACS
 1  BORDER
 1  AVOID
 1  ALWAYS
 1  DEPRIORITIZE
 1  EXCLUDE
 1  FOR
 1  KEEP
 1  PRESELECT
 1  MANUAL
 1  ADVANTAGES
 1  PREBUILT
 1  BUILD
 1  SORTING
 1  SORT
 1  CMDLINE
 1  FRIENDLY
 1  LUASNIP
 1  PROVIDER
 1  CHECKING
 1  ENTER
 1  SERVER
 1  WIP
 1  PARAMETERS
 1  FORMATTERS
 1  REQUIRED
 1  REGISTER
 1  STARTPRESET
 1  DECORATOR
 1  PREVIEWER
 1  DIRS
 1  HELPGREP
 1  ITEMS
 1  AUTOCMD
 1  HINT
 1  AMARANTH
 1  BLUE
 1  PINK
 1  META
 1  HEADINGS
 1  PARAGRAPHS
 1  DASHED
 1  CHECKBOXES
 1  BLOCK
 1  TABLES
 1  CALLOUTS
 1  VIMWIKI
 1  ADDITIONAL
 1  COLUMNS
 1  TRASH
 1  QUICKSTART
 1  WINDOWS
 1  COMBINING
 1  MISC
 1  NEOVIM
 1  PROFILES
 1  COMING
 1  EXTENSIBILITY
"""
