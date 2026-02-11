-- TODO: see https://www.reddit.com/r/neovim/comments/1afw5tc/rustaceanvim_now_with_neotest_integration/
print("Hello")

-------------------------------------------------------------------------------------------------------------- VARIABLES
local o = vim.opt
local g = vim.g

local CONFIG_DIR = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h")
local PWD = vim.fn.getcwd()
local NVIM_DIR = vim.fn.expand("~/.config/nvim")

------------------------------------------------------------------------------------------------------------------ UTILS

local function map(spec)
	vim.keymap.set(spec.mode, spec.sequence or spec.lhs, spec.command or spec.rhs, spec.opts)
end

local function cd_config_dir()
	vim.cmd.cd(config_dir)
	print("Beginning of init.lua; cd to " .. CONFIG_DIR)
end

local function cd_back()
	lua.cmd.cd(PWD)
	print("Reached end of init.lua; cd back to " .. PWD)
end

---------------------------------------------------------------------------------------------------------- BASIC OPTIONS
o.number = true
o.relativenumber = true
o.shiftwidth = 4
o.wrap = false
o.signcolumn = "yes"
o.tabstop = 4
o.swapfile = false
g.mapleader = " "
o.winborder = "rounded"
o.termguicolors = true
o.undofile = true
o.incsearch = true
o.timeout = true
o.timeoutlen = 300

--------------------------------------------------------------------------------------------------- FROM PREVIOUS CONFIG

-- cd_config_dir()

vim.opt.runtimepath:prepend(CONFIG_DIR)
package.path = CONFIG_DIR .. "/lua/?.lua;" .. CONFIG_DIR .. "/lua/?/init.lua;" .. package.path

vim.api.nvim_set_hl(0, "Normal", { bg = "#020802" })

vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true } })
vim.cmd("hi link Floaterm Normal")
vim.cmd("hi link FloatermBorder Normal")
vim.api.nvim_set_hl(0, "Normal", { bg = "#020802" })

-------------------------------------------------------------------------------------------------------------------- LSP
local diagnostic_modes = {
	{
		name = "End of Line (Virtual Text)",
		config = {
			virtual_text = {
				prefix = "●", -- Could be '■', '▎', 'x'
				spacing = 4,
				source = "if_many",
			},
			virtual_lines = false,
			signs = true,
			underline = true,
			update_in_insert = false,
		},
	},
	{
		name = "Under Line (Virtual Lines)",
		config = {
			virtual_text = false,
			-- 'virtual_lines' is now a built-in handler in Nvim 0.10/0.11+
			virtual_lines = {
				only_current_line = true, -- Only show for current line to reduce clutter
				highlight_whole_line = false,
			},
			signs = true,
			underline = true,
			update_in_insert = false,
		},
	},
	{
		name = "Gutter Only (Signs)",
		config = {
			virtual_text = false,
			virtual_lines = false,
			signs = {
				-- Custom mapping for signs if you want specific characters
				text = {
					[vim.diagnostic.severity.ERROR] = "E",
					[vim.diagnostic.severity.WARN] = "W",
					[vim.diagnostic.severity.HINT] = "H",
					[vim.diagnostic.severity.INFO] = "I",
				},
			},
			underline = false, -- Often cleaner to disable underline in "minimal" mode
			update_in_insert = false,
		},
	},
}

-- State tracking
local current_mode_index = 1
local diagnostics_active = false

-- 2. Function to set the configuration
local function set_diagnostics_mode()
	if not diagnostics_active then
		vim.diagnostic.enable(false)
		-- print("LSP Diagnostics: OFF")
		return
	end

	vim.diagnostic.enable(true)
	local mode = diagnostic_modes[current_mode_index]
	vim.diagnostic.config(mode.config)
	print("LSP Mode: " .. mode.name)
end

set_diagnostics_mode()

vim.lsp.config["haskell-language-server"] = { ------------------------------------------------------------------ HASKELL
	cmd = { "haskell-language-server" },
	filetypes = { "haskell" },
	root_markers = { { "*.cabal" }, ".git" },
	settings = {},
}

vim.lsp.config["luals"] = { ---------------------------------------------------------------------------------------- LUA
	-- Command and arguments to start the server.
	cmd = { "lua-language-server" },
	-- Filetypes to automatically attach to.
	filetypes = { "lua" },
	-- Sets the "workspace" to the directory where any of these files is found.
	-- Files that share a root directory will reuse the LSP server connection.
	-- Nested lists indicate equal priority, see |vim.lsp.Config|.
	root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
	-- Specific settings to send to the server. The schema is server-defined.
	-- Example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			diagnostics = {
				globals = {
					"vim",
				},
			},
		},
	},
}

vim.lsp.config["ruff"] = { -------------------------------------------------------------------------------------- PYTHON
	-- Command and arguments to start the server.
	cmd = { "ruff", "server" },
	-- Filetypes to automatically attach to.
	filetypes = { "python" },
	-- Sets the "workspace" to the directory where any of these files is found.
	-- Files that share a root directory will reuse the LSP server connection.
	-- Nested lists indicate equal priority, see |vim.lsp.Config|.
	root_markers = { { ".ruff_cache", "pyproject.toml" }, ".git" },
	-- Specific settings to send to the server. The schema is server-defined.
	-- Example: https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
	settings = {},
}

vim.lsp.config["pyright"] = {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		{ "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile" },
		".git",
	},
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				typeCheckingMode = "basic", -- You can change this to "strict"
			},
		},
	},
}

vim.lsp.config["nixd"] = { ----------------------------------------------------------------------------------------- NIX
	cmd = { "nixd" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", ".git" },
	settings = {},
}

vim.lsp.config["rust-analyzer"] = { ------------------------------------------------------------------------------- RUST
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { { "Cargo.toml", "cargo.lock" }, ".git" },
	settings = {},
}

------------------------------------------------------------------------------------------------------------------- LAZY

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- print(lazypath)
if not vim.loop.fs_stat(lazypath) then
	-- vim.fn.system({
	--     "git",
	--     "clone",
	--     "--filter=blob:none",
	--     "https://github.com/folke/lazy.nvim",
	--     lazypath,
	-- })
end
vim.opt.rtp:prepend(lazypath)

------------------------------------------------------------------------------------------------------- COMMANDS (empty)

----------------------------------------------------------------------------------------------------------------- COLORS

--vim.api.nvim_set_hl(0, "Comment", { bg = "Purple" })
--vim.api.nvim_set_hl(0, 'Normal', { fg = "Green", bg = "Red" })
--vim.api.nvim_set_hl(0, 'Error', { fg = "<white>", undercurl = true })
--vim.api.nvim_set_hl(0, 'Cursor', { reverse = true })

--vim.cmd("highlight clear")

-- print(vim.opt.rtp)
vim.cmd("syntax reset")
--vim.g.colors_name = 'melange'

-- local bg = vim.opt.background:get(n)

-- package.loaded['melange/palettes/' .. bg] = nil -- Only needed for development
--local palette = require('melange/palettes/' .. bg)

--local a = palette.a -- Grays
--local b = palette.b -- Bright foreground colors
--local c = palette.c -- Foreground colors
--local d = palette.d -- Background colors

-- See https://github.com/neovim/neovim/pull/7406
--[[
vim.g.terminal_color_0 = "$color.terminalColor00$"
vim.g.terminal_color_1 = "$color.terminalColor01$"
vim.g.terminal_color_2 = "$color.terminalColor02$"
vim.g.terminal_color_3 = "$color.terminalColor03$"
vim.g.terminal_color_4 = "$color.terminalColor04$"
vim.g.terminal_color_5 = "$color.terminalColor05$"
vim.g.terminal_color_6 = "$color.terminalColor06$"
vim.g.terminal_color_7 = "$color.terminalColor07$"
vim.g.terminal_color_8 = "$color.terminalColor08$"
vim.g.terminal_color_9 = "$color.terminalColor09$"
vim.g.terminal_color_10 = "$color.terminalColor0A$"
vim.g.terminal_color_11 = "$color.terminalColor0B$"
vim.g.terminal_color_12 = "$color.terminalColor0C$"
vim.g.terminal_color_13 = "$color.terminalColor0D$"
vim.g.terminal_color_14 = "$color.terminalColor0E$"
vim.g.terminal_color_15 = "$color.terminalColor0F$"
--]]
local enable_font_variants = true
--vim.g.melange_enable_font_variants == nil or vim.g.melange_enable_font_variants

local bold = enable_font_variants
local italic = enable_font_variants
local underline = enable_font_variants
local undercurl = enable_font_variants
local strikethrough = enable_font_variants

-- local aliases = {
--     DARK_PINK = "#913d55",
--
--
-- }

for name, attrs in pairs({
	---- :help highlight-default -------------------------------

	Normal = { bg = "#000800", fg = "#808080" },
	NormalFloat = { bg = "#000800", fg = "#808080" },
	NormalNC = "Normal",

	-- Cursor: TODO...

	WinSeparator = { bg = "#000800", fg = "#111211" },
	-- VertSplit = { bg = "<|color.nvim.VertSplit.bg |>", fg = "<|color.nvim.VertSplit.fg |>" },
	-- Special = { fg = "<|%color.nvim.Special |>" },
	-- CursorLine = { bg = "<|%color.nvim.CursorLine.bg |>" },

	Identifier = { fg = "#426989" }, --$color.nvim.Identifier.fg$" },
	["@variable"] = { fg = "#13446c" },
	Function = { fg = "#246b44" },
	Statement = { fg = "#913d55" },
	Constant = { fg = "#7080a8" },
	Type = { fg = "#8888dd" },
	["@module"] = { fg = "#aaaacc" },
	String = { fg = "#434f6f" }, --"#3e4966" }, -- 808080 55668f 1c2e8b
	Comment = { fg = "#625c3f" }, -- 333933
	PreProc = { fg = "#123622" },
	Operator = { fg = "#246b44" },
	Delimiter = { fg = "#123622" },
	NeotreeFileName = { fg = "#9a9a9a" },

	-- inheriting background from default Nvim* colors
	Search = { fg = "#8AA88A", bg = "#003600" },
	CurSearch = { fg = "#809880", bg = "#002600" },

	StatusLine = { fg = "#455684", bg = "#111211" },
	StatusLineNC = { fg = "#455684", bg = "#111211" },
	Visual = { fg = "#061815", bg = "#0d8f77" },
	Folded = { fg = "#808080", bg = "#001300" },
	DiffAdd = { fg = "#668366", bg = "#002200" },
	DiffChange = { fg = "#7f86f3", bg = "#050a58" },
	DiffDelete = { fg = "#d5776f" },
	DiffText = { fg = "#050a58", bg = "#7f86f3" },
	Pmenu = { fg = "#505ad6", bg = "#000800" },
	PmenuSel = { fg = "#737df1", bg = "#002600" },
	PmenuThumb = { bg = "#777777" },
	CursorColumn = { bg = "#000e00" },
	CursorLine = { bg = "#000e00" },
	ColorColumn = { bg = "#9b73f1" },
	WinBar = { fg = "#dddddd", bg = "#000800" },
	WinBarNC = { fg = "#dddddd", bg = "#000800" },
	FloatShadow = { bg = "#002600" },
	FloatShadowThrough = {
		bg = "#118811",
	},
	MatchParen = { bg = "#51136e" },
	RedrawDebugClear = { bg = "#dddddd" },
	RedrawDebugComposed = {
		bg = "#dddddd",
	},
	RedrawDebugRecompose = {
		bg = "#dddddd",
	},
	Error = { fg = "#bd1dc5", bg = "#000800" },

	-- inheriting foreground from default Nvim* colors
	SpecialKey = { fg = "#491d5e" },
	NonText = { fg = "#111211" },
	Directory = { fg = "#13446c" },
	ErrorMsg = { fg = "#bd1dc5" },
	MoreMsg = { fg = "#1db6c5" },
	ModeMsg = { fg = "#376808" },
	LineNr = { fg = "#333833" },
	Question = { fg = "#402967" },
	WarningMsg = { fg = "#CBC383" },
	SignColumn = { fg = "#1b8984" },
	Conceal = { fg = "#808080", bg = "#000800" },
	QuickFixLine = { fg = "#A30101" },
	Special = { fg = "#741d96" }, --"#49125e" },

	DiagnosticError = { fg = "#bd1dc5" },
	DiagnosticFloatingWarn = { fg = "#CBC383" },
	DiagnosticWarn = { fg = "#CBC383" },
	DiagnosticFloatingInfo = { fg = "#555555" },
	DiagnosticInfo = { fg = "#555555" },
	DiagnosticFloatingHint = { fg = "#9b73f1" },
	DiagnosticHint = { fg = "#9b73f1" },
	DiagnosticFloatingOk = { fg = "#555555" },
	DiagnosticOk = { fg = "#555555" },
	Added = { fg = "#368366" },
	["@diff.minus"] = { fg = "#d5776f" },
	Removed = { fg = "#d5776f" },
	Changed = { fg = "#7f86f3" },
	CmpItemAbbrDeprecatedDefault = { fg = "#ffffff" },
	CmpItemKindDefault = { fg = "#eeeeee" },
	RainbowDelimiter1 = { fg = "#2b1400" },
	RainbowDelimiter2 = { fg = "#4f473b" },
	RainbowDelimiter3 = { fg = "#381900" },
	RainbowDelimiter4 = { fg = "#726c62" },
	RainbowDelimiter5 = { fg = "#51331a" },
	RainbowDelimiter6 = { fg = "#959189" },
	RainbowDelimiter7 = { fg = "#78604d" },
}) do
	if type(attrs) == "table" then
		vim.api.nvim_set_hl(0, name, attrs)
	else
		vim.api.nvim_set_hl(0, name, { link = attrs })
	end
end

--------------------------------------------------------------------------------------------------------------- MAPPINGS
--[[
DESIRED MAPPINGS/ACTIONS

- open quickfix window
- open floating terminal
- copy selection to new file
- jump to reference (next, previous)
- jump to definition
- open search and replace (with preview)
- fold block
- fold/unfold all of given level
- toggle value under cursor
- rename everywhere (optionally with preview)
- search pattern/regex in given files -> save results list & use it to navigate
- show keybinds available
- add/view/edit comment/annotation pointing to given location
- view/navigate TODOs and comments
- insert snippet
- format code (optionally only under selection)
- edit selection in new buffer
- dull colors outside of selection
- edit filesystem as a buffer (oil.nvim?)
- get autocomplete suggestion
- check spelling in file (ONLY on command!)
- view diff (with saved, last commit, etc.)
- file tree view
- navigate between search results
- toggle to light colors (or even lighten/darken colors, increase contrast -> write plugin?)
- jump to next syntactic object
- command to run changed tests (use testmon or analogous)
- get LLM feedback
- unified preview_+accept/reject framework
- multi-line / multi-location edits

AUTOMATIC/TOGGLABLE FUNCTIONALITIES
--> dull colors everywhere except in active block (via treesitter?)
--> custom syntax highlighting for my special formats (from consilium-notes: jn, ...)

--]]

-- Set up a local map function for convenience

function move_selection_to_new_file()
	local bufnr = 0

	local s_line = vim.fn.line("'<")
	local e_line = vim.fn.line("'>")

	if s_line == 0 or e_line == 0 then
		vim.notify("No visual selection found", vim.log.levels.ERROR)
		return
	end

	local lines = vim.api.nvim_buf_get_lines(bufnr, s_line - 1, e_line, false)

	-- Prompt
	local default_path = vim.fn.expand("%:p:h") .. "/"
	local target = vim.fn.input("Move selection to: ", default_path, "file")
	if target == "" then
		return
	end

	-- Delete original text via Ex (simplest & safest)
	vim.cmd(string.format("%d,%dd", s_line, e_line))

	-- Open split
	vim.cmd("vsplit " .. vim.fn.fnameescape(target))

	-- Insert text
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	vim.bo.modified = true
end

---------------------------------------------------------------------------------------------------- END VERBATIM COPIED

local gh = function(id)
	return "https://github.com/" .. id
end
local gl = function(id)
	return "https://gitlab.com/" .. id
end
local cb = function(id)
	return "https://codeberg.org/" .. id
end

local plugin_ids_eager = {}
local plugin_ids_lazy = {}

local PLUGIN_DECLARATION = {
	-- id, url expander, lazy

	------------------- "willothy/wezterm.nvim"> just vendor
	-- { "2KAbhishek/markit.nvim", gh, false },
	{ "2KAbhishek/pickme.nvim", gh, false },
	{ "akinsho/toggleterm.nvim", gh, false },
	{ "chentoast/marks.nvim", gh, false },
	{ "folke/snacks.nvim", gh, false },
	{ "folke/todo-comments.nvim", gh, false },
	{ "folke/which-key.nvim", gh, false },
	{ "folke/zen-mode.nvim", gh, false },
	{ "kevinhwang91/nvim-bqf", gh, false },
	{ "L3MON4D3/LuaSnip", gh, false },
	{ "lewis6991/gitsigns.nvim", gh, false },
	{ "mg979/vim-visual-multi", gh, false },
	{ "mikavilpas/yazi.nvim", gh, false },
	{ "monaqa/dial.nvim", gh, false },
	{ "mrcjkb/haskell-tools.nvim", gh, false }, -- already lazy
	{ "mrcjkb/rustaceanvim", gh, false }, -- already lazy
	{ "nvim-lua/plenary.nvim", gh, false },
	{ "nvim-lualine/lualine.nvim", gh, false },
	{ "nvim-mini/mini.nvim", gh, false },
	{ "nvim-mini/mini.pick", gh, false },
	{ "nvim-neotest/neotest", gh, false },
	{ "MrcJkb/neotest-haskell", gh, false }, -- TODO
	{ "nvim-neotest/neotest-python", gh, false },
	{ "nvim-neotest/nvim-nio", gh, false },
	{ "nvim-telescope/telescope.nvim", gh, false },
	{ "nvim-treesitter/nvim-treesitter-textobjects", gh, false },
	{ "nvim-treesitter/nvim-treesitter", gh, false },
	{ "rafamadriz/friendly-snippets", gh, false },
	{ "ribru17/bamboo.nvim", gh, false },
	{ "Saghen/blink.cmp", gh, false },
	{ "sindrets/diffview.nvim", gh, false },
	{ "stevearc/conform.nvim", gh, false },
	{ "stevearc/oil.nvim", gh, false },
	{ "voldikss/vim-floaterm", gh, false },
	{ "nvim-telescope/telescope-fzf-native.nvim", gh, false },
}

local make_specs = function(plugin_ids)
	local specs = {
		nix = {
			lazy = {},
			eager = {},
		},
		git = {
			lazy = {},
			eager = {},
		},
	}

	local has_nix, plugin_locations = pcall(dofile, NVIM_DIR .. "/nix_plugins.lua")

	local get_nix_path = function(_id)
		if has_nix then
			return plugin_locations[_id]
		end
	end

	for _, info in ipairs(plugin_ids) do
		local id, expander, lazy = unpack(info)
		-- local user, repo = string.match(id, "([^/]+)/([^/]+)")
		local nix_path = get_nix_path(id)
		local group = lazy and "lazy" or "eager"
		if nix_path then
			local path = plugin_locations[id].path
			table.insert(specs.nix[group], { path = path })
			if not lazy then
				vim.opt.rtp:prepend(path)
			end
		else
			table.insert(specs.git[group], { src = expander(id) })
		end
	end
	return specs
end

--------------

-- local has_nix = vim.uv.fs_stat("/nix/store") ~= nil

PLUGIN_SPECS = make_specs(PLUGIN_DECLARATION)
-- print(vim.inspect(PLUGIN_SPECS))
vim.pack.add(PLUGIN_SPECS.git.eager)

if has_nix then
	require("nvim-treesitter.configs").setup({
		ensure_installed = has_nix and {} or { "lua", "python", "rust", "typescript", "haskell" },
		highlight = { enable = true },
		parser_install_dir = not has_nix and vim.fn.stdpath("data") .. "/parsers" or nil,
	})
end

------------------------------------------------------------------------------------------------------------------------

require("bamboo").setup({
	style = "multiplex",
	colors = {
		bg0 = "#020802",
	},
	-- highlights = { Normal = { bg = "#020802" } },
})
require("bamboo").load()
-- require("vague").setup({ transparent = true })
vim.cmd("colorscheme bamboo")
vim.cmd(":hi statusline guibg=#081608")
-- vim.cmd()
-- require("lazydev").setup({})
require("mini.pick").setup()
require("oil").setup()

-- require('nvim-treesitter')
-- require('nvim-treesitter.install').prefer_git = true
local ts_languages = {
	"python",
	"lua",
	"javascript",
	"typescript",
	"nix",
	"json",
	"yaml",
	"toml",
	"markdown",
	"rust",
	"haskell",
	"zig",
}
require("nvim-treesitter").setup({
	-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
	install_dir = vim.fn.stdpath("data") .. "/site",
	ensure_installed = ts_languages,
	highlight = { enable = true },
	indent = { enable = true },
})
-- wait max. 5 minutes
-- require('nvim-treesitter').install({ "typescript", "javascript", "python", "rust", "haskell", "zig" }):wait(300000)
-- require('nvim-treesitter.configs').setup({
--     ensure_installed = { "typescript", "javascript", "python", "rust", "haskell" },
--     highlight = {
--         enable = true,
--         -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--         -- Set to `false` if you want only tree-sitter.
--         additional_vim_regex_highlighting = false,
--     },
-- })

-- on macos:
-- brew install ruff
-- brew install lua-language-server
-- brew install rust-analyzer
-- brew install haskell-language-server

vim.lsp.enable("lua_ls")
vim.lsp.enable("ruff")
vim.lsp.enable("tinymist")
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
		},
	},
})
vim.lsp.config("ruff", {}) -- TODO
vim.lsp.config("tinymist", {}) -- TODO
vim.lsp.config("rust-analyzer", {}) -- TODO
vim.lsp.config("haskell-ls", {}) -- TODO

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")

-- vim.pack.add({ { src = "https://github.com/ii14/neorepl.nvim" } })

----------------------------------------------------------------------------------------------------------- conform.nvim

require("conform").setup({
	formatters_by_ft = {
		python = {
			-- To fix auto-fixable lint errors.
			"ruff_fix",
			-- To run the Ruff formatter.
			"ruff_format",
			-- To organize the imports.
			"ruff_organize_imports",
		},
		nix = {
			"alejandra",
		},
		lua = {
			"stylua",
		},
		haskell = {
			"fourmolu",
		},
		rust = {
			"rustfmt",
		},
		go = {
			"gofmt",
		},
	},
})

-- Optional: format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

-------------------------------------------------------------------------------------------------------------- blink.cmp

require("blink.cmp").setup({
	-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
	-- 'super-tab' for mappings similar to vscode (tab to accept)
	-- 'enter' for enter to accept
	-- 'none' for no mappings
	--
	-- All presets have the following mappings:
	-- C-space: Open menu or open docs if already open
	-- C-n/C-p or Up/Down: Select next/previous item
	-- C-e: Hide menu
	-- C-k: Toggle signature help (if signature.enabled = true)
	--
	-- See :h blink-cmp-config-keymap for defining your own keymap
	keymap = { preset = "default" },

	appearance = {
		-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- Adjusts spacing to ensure icons are aligned
		nerd_font_variant = "mono",
	},

	-- (Default) Only show the documentation popup when manually triggered
	completion = { documentation = { auto_show = false } },

	-- Default list of enabled providers defined so that you can extend it
	-- elsewhere in your config, without redefining it, due to `opts_extend`
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},

	-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
	-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
	-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
	--
	-- See the fuzzy documentation for more information
	fuzzy = { implementation = "prefer_rust_with_warning" },
})

---------------------------------------------------------------------------------------------------------- zen-mode.nvim

require("zen-mode").setup({
	wezterm = {
		enabled = false,
		-- can be either an absolute font size or the number of incremental steps
		font = "+4", -- (10% increase per step)
	},
})

---------------------------------------------------------------------------------------------------------------- lualine

require("lualine").setup()

-------------------------------------------------------------------------------------------------------------- dial.nvim

local augend = require("dial.augend")
require("dial.config").augends:register_group({
	default = {
		augend.integer.alias.decimal,
		augend.integer.alias.hex,
		augend.date.alias["%Y/%m/%d"],
		augend.constant.alias.bool,
	},
})

-------------------------------------------------------------------------------------------------------- nvim-treesitter

if has_nix then
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"python",
			"lua",
			"javascript",
			"typescript",
			"nix",
			"json",
			"yaml",
			"toml",
			"markdown",
		},
		highlight = { enable = true },
		indent = { enable = true },
	})
end

-------------------------------------------------------------------------------------------------------------- nvim-tree

-- require("nvim-tree").setup({})

-------------------------------------------------------------------------------------------------------- yazi.nvim: TODO

function load_yazi()
	require("yazi").setup({
		-- if you want to open yazi instead of netrw, see below for more info
		open_for_directories = true,
		keymaps = { show_help = "<f1>" },
	})
end

-- mark netrw as loaded so it's not loaded at all.
-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
vim.g.loaded_netrwPlugin = 1

map({
	mode = { "n", "v" },
	sequence = "<leader>-",
	commnd = function()
		load_yazi()
		vim.cmd("Yazi")
	end,
	opts = { desc = "Open yazi at the current file." },
})
map({
	mode = { "n", "v" },
	sequence = "<leader>cw",
	command = function()
		load_yazi()
		vim.cmd("Yazi cwd")
	end,
	opts = { desc = "Open the file manager in nvim's working directory." },
})
map({
	mode = { "n", "v" },
	sequence = "<c-up>",
	command = function()
		load_yazi()
		vim.cmd("Yazi toggle")
	end,
	opts = { desc = "Resume the last yazi session." },
})

-------------------------------------------------------------------------------------------------------- toggleterm.nvim

require("toggleterm").setup({
	-- Your other toggleterm options here...
	open_mapping = [[<c-\>]],
	direction = "float",
	-- This is the key to inheriting your colorscheme's background
	highlights = {
		Normal = {
			link = "Normal",
		},
		NormalFloat = {
			link = "NormalFloat",
		},
	},
})

----------------------------------------------------------------------------------------------------------- vim-floaterm

vim.g.floaterm_width = 0.8
vim.g.floaterm_height = 0.8

-- wezterm: TODO: vendor ------------------------------------------------------

-- https://github.com/willothy/wezterm.nvim
-- https://github.com/ianhomer/wezterm.nvim
-- https://github.com/aca/wezterm.nvim
-- https://github.com/letieu/wezterm-move.nvim
------------------- https://github.com/jonboh/wezterm-mux.nvim> https://github.com/mrjones2014/smart-splits.nvim

---------------------------------------------------------------------------------------------------------- zen-mode.nvim

map({
	mode = "n",
	sequence = "<leader>zm",
	command = function()
		require("zen-mode").toggle({
			window = {
				width = 0.85, -- width will be 85% of the editor width
			},
		})
	end,
	opts = { desc = "Toggle zen mode." },
})

-------------------------------------------------------------------------------------------------------------- which-key

require("which-key").setup()

---------------------------------------------------------------------------------------------------------------- LuaSnip

require("luasnip").setup()
-- "L3MON4D3/LuaSnip",
-- dependencies = { "rafamadriz/friendly-snippets" }, -- Optional: for pre-made snippets
-- build = "make install_jsregexp", -- For regex snippets
-- event = "InsertEnter",

--------------------------------------------------------------------------------------------------------- nvim-cmp (old)

-- dependencies = {
--     "hrsh7th/cmp-nvim-lsp",
--     "hrsh7th/cmp-buffer",
--     "hrsh7th/cmp-path",
--     "saadparwaiz1/cmp_luasnip",
-- }
local old_setup_nvim_cmp = function()
	vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
	vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
	local cmp = require("cmp")
	local defaults = require("cmp.config.default")()
	local auto_select = true
	return {
		snippet = {
			-- REQUIRED for luasnip
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		auto_brackets = {},
		completion = {
			completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
		},
		preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept selected suggestion
			--   ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
			--   ["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
			--   ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace })
			-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			["<C-CR>"] = function(fallback)
				cmp.abort()
				fallback()
			end,

			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" }),

			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
			--   ["<tab>"] = function(fallback)
			--     return LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }, fallback)()
			--   end,
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
		}, {
			{ name = "buffer" },
			{ name = "path" },
		}),
		formatting = {
			format = function(entry, item)
				-- local icons = LazyVim.config.icons.kinds
				-- if icons[item.kind] then
				--   item.kind = icons[item.kind] .. item.kind
				-- end

				local widths = {
					abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
					menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
				}

				for key, width in pairs(widths) do
					if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
						item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
					end
				end

				return item
			end,
		},
		experimental = {
			-- only show ghost text when we show ai completions
			ghost_text = vim.g.ai_cmp and {
				hl_group = "CmpGhostText",
			} or false,
		},
		sorting = defaults.sorting,
	}
end

-------------------------------------------------------------------------------------------------------------- mini.nvim

-- We just setup the modules we want to use
require("mini.pairs").setup()
require("mini.icons").setup()
require("mini.surround").setup()
require("mini.comment").setup({
	-- No options needed for basic setup
})
require("mini.hipatterns").setup()
require("mini.indentscope").setup()
-- require("mini.marks").setup()
-- require("mini.fold").setup()
-- require("mini.terminal").setup()

-- nvim-bqf: TODO should lazy load on opening the quickfix window -> ft = "qf"

---------------------------------------------------------------------------------------------------------- gitsigns.nvim

-- event = { "BufReadPre", "BufNewFile" }
require("gitsigns").setup({})

----------------------------------------------------------------------------------------------------- t*d*-comments.nvim

require("todo-comments").setup({})

--------------------------------------------------------------------------------------------------- telescope.nvim: TODO

-- cmd = "Telescope" -- lazy load on command Telescope
-- dependencies = {
--     "nvim-lua/plenary.nvim",
--     {
--         "nvim-telescope/telescope-fzf-native.nvim",
--         build = "make",
--     },
-- }
local telescope = require("telescope")
telescope.setup({
	defaults = {
		file_ignore_patterns = { "%.git/", "node_modules/", "%.venv/" },
	},
})
telescope.load_extension("fzf")

---------------------------------------------------------------------------------------------------------- diffview.nvim

-- cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" }
require("diffview").setup({})

------------------------------------------------------------------------------------------------------------ markit.nvim

-- require("markit").setup({})

--------------------------- marks.nvim

require("marks").setup({})

---------------------------------------------------------------------------------------------------------------- neotest

-- dependencies = {
--     "nvim-lua/plenary.nvim",
--     "nvim-treesitter/nvim-treesitter",
--     "antoinemadec/FixCursorHold.nvim",
--     "nvim-neotest/nvim-nio",
--     "nvim-neotest/neotest-python",
-- }
require("neotest").setup({
	adapters = {
		require("neotest-python")({
			-- Extra arguments for nvim-dap configuration
			-- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
			dap = { justMyCode = false },
			-- Command line arguments for runner
			-- Can also be a function to return dynamic values
			args = { "--log-level", "DEBUG" },
			-- Runner to use. Will use pytest if available by default.
			-- Can be a function to return dynamic value.
			runner = "pytest",
			-- Custom python path for the runner.
			-- Can be a string or a list of strings.
			-- Can also be a function to return dynamic value.
			-- If not provided, the path will be inferred by checking for
			-- virtual envs in the local directory and for Pipenev/Poetry configs
			python = ".venv/bin/python",
			-- Returns if a given file path is a test file.
			-- NB: This function is called a lot so don't perform any heavy tasks within it.
			-- is_test_file = function(file_path)
			-- end,
			-- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
			-- instances for files containing a parametrize mark (default: false)
			pytest_discover_instances = true,
		}),
	},
})

-- TODO: process old lazy.nvim config and keybinds

----------------------------------------------------------------------------------------------------------------- pickme

require("pickme").setup({
	picker_provider = "snacks",
})

-------------------------------------------------------------------------------------------- nvim-treesitter-textobjects

require("nvim-treesitter-textobjects").setup({
	select = {
		-- Automatically jump forward to textobj, similar to targets.vim
		lookahead = true,
		-- You can choose the select mode (default is charwise 'v')
		--
		-- Can also be a function which gets passed a table with the keys
		-- * query_string: eg '@function.inner'
		-- * method: eg 'v' or 'o'
		-- and should return the mode ('v', 'V', or '<c-v>') or a table
		-- mapping query_strings to modes.
		selection_modes = {
			["@parameter.outer"] = "v", -- charwise
			["@function.outer"] = "V", -- linewise
			-- ['@class.outer'] = '<c-v>', -- blockwise
		},
		-- If you set this to `true` (default is `false`) then any textobject is
		-- extended to include preceding or succeeding whitespace. Succeeding
		-- whitespace has priority in order to act similarly to eg the built-in
		-- `ap`.
		--
		-- Can also be a function which gets passed a table with the keys
		-- * query_string: eg '@function.inner'
		-- * selection_mode: eg 'v'
		-- and should return true of false
		include_surrounding_whitespace = false,
	},
})

-- vim-visual-multi

vim.g.VM_default_mappings = true

---------------------------------------------------------------------------------------------------------------- KEYMAPS

local nvx = { "n", "v", "x" }
map({
	mode = "n",
	sequence = "<leader>o",
	command = ":update<CR> :source<CR>",
	opts = {},
})
map({
	mode = "n",
	sequence = "<leader>ww",
	command = ":write<CR>",
	opts = {},
})
map({
	mode = "n",
	sequence = "<leader>qq",
	command = ":quit<CR>",
	opts = {},
})
map({
	mode = "n",
	sequence = "<leader>wq",
	command = ":wq<CR>",
	opts = {},
})
map({
	mode = "n",
	sequence = "<leader>f",
	command = ":Pick files<CR>",
	opts = {},
})
map({
	mode = "t",
	sequence = "<Esc>",
	command = [[<C-\><C-n>]],
	opts = { desc = "Exit terminal mode" },
})
map({
	mode = "t",
	sequence = "kj",
	command = [[<C-\><C-n>]],
	opts = { desc = "Exit terminal mode" },
})
map({
	mode = "t",
	sequence = "<C-o>",
	command = [[<C-\><C-o>]],
	opts = { desc = "Temporary normal mode" },
})
map({
	mode = "n",
	sequence = "<leader>lf",
	command = vim.lsp.buf.format,
	opts = { desc = "" },
})
map({
	mode = "n",
	sequence = "<leader>h",
	command = ":Pick help",
})
map({
	mode = "n",
	sequence = "<leader>e",
	command = ":Oil<CR>",
})
map({
	mode = nvx,
	sequence = "<leader>y",
	command = "+y<CR>",
	opts = { desc = "Yank to system clipboard" },
})
map({
	mode = nvx,
	sequence = "<leader>d",
	command = "+d<CR>",
	opts = { desc = "Paste from system clipboard" },
})
-- map({
--     mode = "",
--     sequence = "",\
--     command = [[]],
--     opts = { desc = "" }
-- })
-- map({
--     mode = "",
--     sequence = "",
--     command = [[]],
--     opts = { desc = "" }
-- })
-- map('t', '^[', "^\^N")
-- map('t', '^O', '^\^O')
map({
	mode = "x",
	sequence = "<leader>mf",
	command = ":'<,'>lua move_selection_to_new_file()<CR>",
	opts = { desc = "Move selection to new file (split)" },
})
map({
	mode = "n",
	sequence = "<leader>lu",
	command = function()
		-- Create a new empty floating window or split
		vim.cmd("vsplit | enew")
		vim.bo.filetype = "lua"
		vim.bo.bufhidden = "hide"

		-- Map <CR> to execute the current line or selection
		vim.keymap.set("n", "<CR>", ":.lua<CR>", { buffer = true })
		vim.keymap.set("v", "<CR>", ":lua<CR>", { buffer = true })
	end,
	opts = { desc = "Open Lua Scratchpad" },
})
map({ ------------------------------------------------------------------------------------------------------ diagnostics
	mode = "n",
	sequence = "<leader>dt",
	command = function()
		diagnostics_active = not diagnostics_active
		set_diagnostics_mode()
	end,
	opts = { desc = "Toggle LSP Diagnostics" },
})
map({
	mode = "n",
	sequence = "<leader>dm",
	command = function()
		-- only cycle if active; otherwise turn on and reset to 1
		if not diagnostics_active then
			diagnostics_active = true
			current_mode_index = 1
		else
			current_mode_index = current_mode_index + 1
			if current_mode_index > #diagnostic_modes then
				current_mode_index = 1
			end
		end
		set_diagnostics_mode()
	end,
	opts = { desc = "Cycle LSP Diagnostic Modes" },
})
map({ -------------------------------------------------------------------------------------------------------- telescope
	mode = "n",
	sequence = "<leader>ff",
	command = function()
		require("telescope.builtin").find_files()
	end,
	opts = { desc = "Find Files" },
})
map({
	mode = "n",
	sequence = "<leader>gf",
	command = function()
		require("telescope.builtin").git_files()
	end,
	opts = { desc = "Find Git Files" },
})
map({
	mode = "n",
	sequence = "<leader>fg",
	command = function()
		require("telescope.builtin").live_grep()
	end,
	opts = { desc = "Live Grep" },
})
map({
	mode = "n",
	sequence = "<leader>fb",
	command = function()
		require("telescope.builtin").buffers()
	end,
	opts = { desc = "Find Buffers" },
})
map({
	mode = "n",
	sequence = "<leader>fh",
	command = function()
		require("telescope.builtin").help_tags()
	end,
	opts = { desc = "Find Help Tags" },
})

map({ --------------------------------------------------------------------------------------------------------- floaterm
	mode = "n",
	sequence = "<leader>ft",
	command = "<Cmd>FloatermToggle<CR>",
	opts = { desc = "Toggle floaterm" },
})
map({
	mode = "t",
	sequence = "<leader>ft",
	command = "<C-\\><C-n><Cmd>FloatermToggle<CR>",
	opts = { desc = "Toggle floaterm" },
})

-------------------------------------------------------------------------------------------------------------------- LSP
-- We will create an autocommand group to attach keymaps only to buffers with an active LSP client.
local lsp_keymaps_group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
	group = lsp_keymaps_group,
	callback = function(ev)
		local lsp_map = function(keys, func, desc)
			map({
				mode = "n",
				sequence = keys,
				command = func,
				opts = { buffer = ev.buf, desc = "LSP: " .. desc },
			})
		end

		-- Navigation and Information
		lsp_map("gd", vim.lsp.buf.definition, "Go to Definition")
		lsp_map("gD", vim.lsp.buf.declaration, "Go to Declaration")
		lsp_map("gr", vim.lsp.buf.references, "Go to References")
		lsp_map("gI", vim.lsp.buf.implementation, "Go to Implementation")
		lsp_map("K", vim.lsp.buf.hover, "Hover Documentation")
		lsp_map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")

		-- Actions
		lsp_map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
		lsp_map("<leader>rn", vim.lsp.buf.rename, "Rename")

		-- Diagnostics
		lsp_map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
		lsp_map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
		lsp_map("<leader>dl", vim.diagnostic.open_float, "Show Line Diagnostics")

		-- format on save (to use LSP formatter instead of conform)
		-- vim.api.nvim_buf_create_autocmd("BufWritePre", {
		--   buffer = ev.buf,
		--   callback = function() vim.lsp.buf.format { async = false } end
		-- })
		--
		local bufopts = { noremap = true, silent = true, buffer = bufnr }
	end,
})

--------------------------------------------------------------------------------------------------------------- quickfix
map({
	mode = "i",
	sequence = "kj",
	command = "<escape>",
})
map({
	mode = "n",
	sequence = "<leader>wq",
	command = function()
		vim.cmd("wq")
	end,
})
map({
	mode = "n",
	sequence = "<leader>ww",
	command = function()
		vim.cmd("w")
	end,
})
map({
	mode = "n",
	sequence = "<leader>q",
	command = function()
		-- Populates the Quickfix list with all diagnostics from the current buffer
		vim.diagnostic.setqflist({ bufnr = 0 })
		vim.cmd("copen")
	end,
	opts = { desc = "Open Quickfix with diagnostics" },
})

map({ ------------------------------------------------------------------------------------------------------------- dial
	mode = "n",
	sequence = "<C-a>",
	command = function()
		require("dial.map").manipulate("increment", "normal")
	end,
	opts = { desc = "" },
})
map({
	mode = "n",
	sequence = "<C-x>",
	command = function()
		require("dial.map").manipulate("decrement", "normal")
	end,
	opts = { desc = "" },
})
map({
	mode = "n",
	sequence = "g<C-a>",
	command = function()
		require("dial.map").manipulate("increment", "gnormal")
	end,
	opts = { desc = "" },
})
map({
	mode = "n",
	sequence = "g<C-x>",
	command = function()
		require("dial.map").manipulate("decrement", "gnormal")
	end,
	opts = { desc = "" },
})
map({
	mode = "x",
	sequence = "<C-a>",
	command = function()
		require("dial.map").manipulate("increment", "visual")
	end,
	opts = { desc = "" },
})
map({
	mode = "x",
	sequence = "<C-x>",
	command = function()
		require("dial.map").manipulate("decrement", "visual")
	end,
	opts = { desc = "" },
})
map({
	mode = "x",
	sequence = "g<C-a>",
	command = function()
		require("dial.map").manipulate("increment", "gvisual")
	end,
	opts = { desc = "" },
})
map({
	mode = "x",
	sequence = "g<C-x>",
	command = function()
		require("dial.map").manipulate("decrement", "gvisual")
	end,
	opts = { desc = "" },
})
map({ --------------------------------------------------------------------------------------------------------- zen-mode
	mode = "n",
	sequence = "<leader>zm",
	command = function()
		-- width will be 85% of the editor width
		require("zen-mode").toggle({ window = { width = 0.85 } })
	end,
	opts = { desc = "" },
})

require("blink.cmp").setup({ ------------------------------------------------------------------------------------- blink
	keymap = {
		-- 'default' for vim-like (C-y to accept)
		-- 'super-tab' for vscode-like (Tab to accept/jump)
		-- 'enter' for enter to accept
		preset = "super-tab",

		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },

		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide", "fallback" },
		["<CR>"] = { "accept", "fallback" },

		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },

		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },
	},
})
