local plugins_by_layer = {
	[-1] = {
		-- old
		"bamboo",
		"dap", -- debugpy
		"dap-python",
		"dapui",
	},
	-- LAYER 0: foundation, colors, search, core navigation
	[0] = {
		-- core dependencies
		"plenary",
		"nio",
		"nvim-web-devicons",
		"nui",
		-- core setup and UI
		"bamboo",
		"zen-mode",
		"illuminate",
		"lualine",
		"nvim-navic",
		"bufferline",
		"statuscol",
		"nvim-treesitter",
		"treesitter-modules",
		"dropbar",
		"nvim-navbuddy",
		"aerial",
		-- file explorer (as central focus)
		"oil",
		"yazi",
		"neo-tree",
		"nvim-tree",
		-- picker / search
		"pickme",
		"telescope",
		"telescope-fzf-native",
		"fzf-lua",
		"deck",
		-- suites
		"mini",
		"snacks",
		"blink",
		-- search
		"hlslens",
		"hlsearch",
		-- find-and-replace
		"grug-far",
		"spectre",
		-- layout & buffer/tab navigation
		"nvim_winpick",
		"flybuf",
		"stickybuf",
		"swm",
		-- wezterm integration
		"smart-splits",
	},
	[1] = { -- LAYER 1: editing enhancements 
		"ufo",
		-- macros
		"NeoComposer",
		"nvim-macros",
		"recorder",
		-- multi-cursor
		"vim-visual-multi",
		-- motion
		"leap",
		"flash",
		"hop",
		-- pairs
		"rainbow-delimiters",
		"nvim-autopairs",
		"blink.pairs",
		"vim-sandwich",
		"nvim-surround",
		-- undo
		"vim-mundo",
		-- keymapping-related
		"mini.keymap",
		"hydra",
		"insx",
		"which-key",
		-- alignment / indentation
		"indentmini",
		"indent-blankline",
		"nvim-anydent",
		"mini.align",
		"tabular",
		-- textobjects
		"nvim-treesitter-textobjects",
		"nvim-various-textobjs", -- needs nix
		-- comments
		"Comment",
		"todo-comments",
		"vim-commentary",
		-- split / join
		"treesj",
		-- value manipulation
		"dial",
		-- marks
		"harpoon-core",
		"marks",
		"markit",
		-- yank/paste & clipboard
		"nvim-pasta",
		-- miscellaneous
		"beam",
	},
	[2] = { -- LAYER 2: LSP, autocompletion, snippets
		-- snippets, autocomplete
		"blink.cmp",
		"nvim-cmp",
		-- snippets (as main focus)
		"friendly-snippets",
		"ultisnips",
		"LuaSnip",
		-- completion sources
		"cmp-nvim-lsp",
		"cmp-buffer",
		"cmp-path",
		"cmp-cmdline",
		-- LSP general
		-- (configure ruff, pyright, lua-language-server, haskell-language-server, rust-analyzer with built-in client)
		"lsp-format",
		"lspkind",
		"efm",
		-- LSP UI (see also fidget.nvim)
		"lspsaga",
		-- language-specific
		"lazydev",
		"rustaceanvim",
		"crates",
		"haskell-tools",
		-- LSP-adjacent
		"none-ls",
	},
	[3]  = { -- LAYER 3: formatting & linting
		"guard",
		"conform",
	},
	[4]  = { -- LAYER 4: testing, debugging/quickfix, execution
		-- Code execution / task running / build
		"overseer",
		"asyncrun",
		"compiler",
		"code_runner",
		"sniprun",
		"yabs",
		-- Testing
		"neotest-haskell",
		"neotest-python",
		"neotest",
		"dap-python",
		"dapui",
		"nvim-dap-virtual-text",
		"dap",
		"mypy",
		"nvim-lint",
		-- DAP/quickix UI
		"trouble.nvim",
		"quicker",
		"nvim-bqf",
		-- terminal
		"vim-floaterm",
	},
	[5]  = { -- LAYER 5: refactoring & code intelligence
		"refactoring",
		-- project management
		"project",
		"telescope-project",
	},
	[6]  = { -- LAYER 6: version control & collaboration
		"jj",
		"jujutsu",
		"lazygit",
		"git-conflict",
		"neogit",
		"jiejie",
		"diffview",
		"gitsigns",
		"vim-fugitive",
		-- Git forges
		"octo",
		"gitlab-nvim",
		"gitlab",
	},
	[7]  = { -- LAYER 7: UI polish & productivity

		"dashboard-nvim",
		"dashboard",
		"noice",
		"modes",
		-- UI (important for LSP)
		"fidget",
		"nvim-notify",
		"headlines",
		-- session management
		"auto-session",
		"persistence",
	},
	[8]  = { -- LAYER 8: miscellaneous/advanced
		"vimtex",
		"texmagic",
		"schemastore",
		"firenvim",
		"render-markdown",
		"jupytext",
		"quarto",
		"markdown-preview",
		-- Lua / self-referential
		"structlog",
		"neorepl",
	},
}
return plugins_by_layer
