vim.g.loaded_matchparen = 1
vim.g.loaded_matchit = 1
vim.g.loaded_netrw = 1


--======================================================================================================================
local plugin_base_dir = vim.fn.expand("~/.local/share/nvim-plugins")

-- Get a list of all directories inside your custom folder
local handle = vim.uv.fs_scandir(plugin_base_dir)

if handle then
    while true do
        local name, type = vim.uv.fs_scandir_next(handle)
        if not name then break end
        
        -- Only process directories (skip READMEs, .DS_Store, etc.)
        if type == "directory" and name == "yazi" or name == "plenary" then
            local plugin_path = plugin_base_dir .. "/" .. name
            
            -- Prepend to RTP so your manual plugins take priority over defaults
            vim.opt.runtimepath:prepend(plugin_path)
        end
    end
else
    print("Warning: Plugin directory not found: " .. plugin_base_dir)
end
-- require("yazi")
--======================================================================================================================

local plugins_file = vim.fn.expand("~/repos/nvim-config/testing/plugin_paths.lua") --"~/.config/nvim/plugin_paths.lua")
plugins_table = dofile(plugins_file)

local function safe_prepend(path)
    local expanded_path = vim.fn.expand(path)
    -- Use vim.tbl_contains for a much shorter check
    if not vim.tbl_contains(vim.opt.runtimepath:get(), expanded_path) then
        vim.opt.runtimepath:prepend(expanded_path)
    end
end

dependencies = {
	["yazi"] = "plenary",
}

function get_plugin(name)
	local path = plugins_table[name]
	print(path)
	local deps = dependencies[name]
    safe_prepend(path)
	if dependencies then
		for _, dep_path in ipairs(dependencies) do
			safe_prepend(dep_path)
		end
	end
	local required = require(name)
	return required
end

function configure_plugin(name, config)
	return get_plugin(name).setup(config)
end

function custom_setup(name, setup_func)
	return setup_func(get_plugin(name))
end

-- get_plugin("lualine").setup({})
configure_plugin("lualine", {})
configure_plugin("yazi", {})
-- custom_setup("lualine", function(plugin) plugin.setup({}) end)
--======================================================================================================================


--[[

WEZTERM = true
local LAYERS = {
	-- -1,
	-- 0,
	-- 1,
	-- 2,
	-- 3,
	-- 4,
	-- 5,
	-- 6,
	-- 7,
	-- 8,
}
local PLUGINS = {}
PLUGINS_BY_LAYER = {
	[-1] = {
		-- old
		"bamboo",
		-- "vimtex",
		-- "neotest",
		-- "neotest-python",
		"dap", -- debugpy
		"dap-python",
		"dapui",
		-- "nvim-treesitter", -- brew install tree-sitter
		--
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
		"surround",
		-- undo
		"vim-mundo",
		-- keymapping-related
		"mini.keymap",
		"hydra",
		"nvim-insx",
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
for _, layer in ipairs(LAYERS) do
	local layer_table = PLUGINS_BY_LAYER[layer]
	print("--- layer " .. layer .. ": " .. #layer_table .. " plugins")

	for __, name in ipairs(layer_table) do
		table.insert(PLUGINS, name)
	end
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local NVIM_DIR = vim.fn.expand("~/.config/nvim")
HAS_NIX, PLUGIN_LOCATIONS = pcall(dofile, NVIM_DIR .. "/nix_plugins.lua")
BE_VERBOSE = false

local current_mode_index = 1
local diagnostics_active = false

TS_LANGUAGES = {
	"haskell",
	"javascript",
	"json",
	"lua",
	"markdown",
	"nix",
	"python",
	"rust",
	"toml",
	"typescript",
	"yaml",
	"zig",
}

local gh = function(id)
	return "https://github.com/" .. id
end
local gl = function(id)
	return "https://gitlab.com/" .. id
end
local cb = function(id)
	return "https://codeberg.org/" .. id
end

local function build_telescope_fzf_native()
	print("TODO")
end
local function build_blink_cmp()
	print("TODO")
end

local printv = function(msg)
	if BE_VERBOSE then
		print(msg)
	end
end

local function printb(msg)
	local bar = string.rep("=", 120)
	local end_bar = string.rep("=", 115 - string.len(msg))
	print(bar)
	print("=== " .. msg .. " " .. end_bar)
	print(bar)
end


printb(vim.inspect(PLUGINS))
printb(#PLUGINS)

local PLUGIN_DECLARATION = {
	--===================================================================================================================================
	--==== LAYER 0: foundation, colors, search, core navigation =========================================================================
	--===================================================================================================================================
	------------------------------
	------ core dependencies -----
	------------------------------
	["plenary"]                                  = { id = "nvim-lua/plenary.nvim",         expander = gh, lazy = false },
	["nio"]                                      = { id = "nvim-neotest/nvim-nio",         expander = gh, lazy = false },
	["nvim-web-devicons"]                        = { id = "nvim-tree/nvim-web-devicons",   expander = gh, lazy = false }, -- needs nix
	["nui"]                                      = { id = "MunifTanjim/nui.nvim",          expander = gh, lazy = false }, -- needs nix
	-----------------------------─
	------ core setup and UI -----
	------------------------------
	["bamboo"]                                   = { id = "ribru17/bamboo.nvim",           expander = gh, lazy = false },
	["zen-mode"]                                 = { id = "folke/zen-mode.nvim",           expander = gh, lazy = false },
	["illuminate"]                               = { id = "RRethy/vim-illuminate",         expander = gh, lazy = false },
	["lualine"]                                  = { id = "nvim-lualine/lualine.nvim",     expander = gh, lazy = false },
	["nvim-navic"]                               = { id = "SmiteshP/nvim-navic",           expander = gh, lazy = false }, -- needs nix
	["bufferline"]                               = { id = "akinsho/bufferline.nvim",       expander = gh, lazy = false }, -- needs nix
	["statuscol"]                                = { id = "luukvbaal/statuscol.nvim",      expander = gh, lazy = false }, -- needs nix
	["nvim-treesitter"]                          = { id = "nvim-treesitter/nvim-treesitter", expander = gh, lazy = false }, -- brew install tree-sitter; brew install tree-sitter-cli
	["treesitter-modules"]                       = { id = "MeanderingProgrammer/treesitter-modules.nvim", expander = gh, lazy = false }, -- needs nix
	["dropbar"]                                  = { id = "Bekaboo/dropbar.nvim",          expander = gh, lazy = false }, -- needs nix
	["nvim-navbuddy"]                            = { id = "SmiteshP/nvim-navbuddy",        expander = gh, lazy = false, deps = { "nui" } }, -- needs nix
	["aerial"]                                   = { id = "stevearc/aerial.nvim",          expander = gh, lazy = false }, -- needs nix
	---------------------------------------------
	------ file explorer (as central focus) -----
	---------------------------------------------
	["oil"]                                      = { id = "stevearc/oil.nvim",             expander = gh, lazy = false },
	["yazi"]                                     = { id = "mikavilpas/yazi.nvim",          expander = gh, lazy = false },
	["neo-tree"]                                 = { id = "nvim-neo-tree/neo-tree.nvim",   expander = gh, lazy = false }, -- needs nix
	["nvim-tree"]                                = { id = "nvim-tree/nvim-tree.lua",       expander = gh, lazy = false }, -- needs nix
	----------------------------
	------ picker / search -----
	----------------------------
	["pickme"]                                   = { id = "2KAbhishek/pickme.nvim",        expander = gh, lazy = false },
	["telescope"]                                = { id = "nvim-telescope/telescope.nvim", expander = gh, lazy = false },
	["telescope-fzf-native"]                     = { id = "nvim-telescope/telescope-fzf-native.nvim", expander = gh, lazy = false },
	["fzf-lua"]                                  = { id = "ibhagwan/fzf-lua",              expander = gh, lazy = false }, -- needs nix
	["deck"]                                     = { id = "hrsh7th/nvim-deck",             expander = gh, lazy = false }, -- needs nix
	-------------------
	------ suites -----
	-------------------
	["mini"]                                     = { id = "nvim-mini/mini.nvim",           expander = gh, lazy = false },
	["snacks"]                                   = { id = "folke/snacks.nvim",             expander = gh, lazy = false },
	["blink"]                                    = { id = "saghen/blink.nvim",             expander = gh, lazy = false }, -- needs nix
	-------------------
	------ search -----
	-------------------
	["hlslens"]                                  = { id = "kevinhwang91/nvim-hlslens",     expander = gh, lazy = false }, -- needs nix
	["hlsearch"]                                 = { id = "nvimdev/hlsearch.nvim",         expander = gh, lazy = false }, -- needs nix
	-----------------------------
	------ find-and-replace -----
	-----------------------------
	["grug-far"]                                 = { id = "MagicDuck/grug-far.nvim",       expander = gh, lazy = false }, -- needs nix
	["spectre"]                                  = { id = "nvim-pack/nvim-spectre",        expander = gh, lazy = false }, -- needs nix
	--------------------------------------------------
	------ layout & window/buffer/tab navigation -----
	--------------------------------------------------
	["nvim_winpick"]                             = { id = "MarcusGrass/nvim_winpick",      expander = gh, lazy = false },
	["flybuf"]                                   = { id = "nvimdev/flybuf.nvim",           expander = gh, lazy = false }, -- needs nix
	["stickybuf"]                                = { id = "stevearc/stickybuf.nvim",       expander = gh, lazy = false }, -- needs nix
	["swm"]                                      = { id = "hrsh7th/nvim-swm",              expander = gh, lazy = false }, -- needs nix
	--------------------------------
	------ wezterm integration -----
	--------------------------------
	["smart-splits"]                             = { id = "mrjones2014/smart-splits.nvim", expander = gh, lazy = false }, -- needs nix

	--===================================================================================================================================
	--==== LAYER 1: editing enhancements ================================================================================================ 1
	--===================================================================================================================================
	------------------
	------ folds -----
	------------------
	["ufo"]                                 = { id = "kevinhwang91/nvim-ufo",         expander = gh, lazy = false }, -- needs nix
	-------------------
	------ macros -----
	-------------------
	["NeoComposer"]                              = { id = "lvim-tech/NeoComposer.nvim",    expander = gh, lazy = false },
	["nvim-macros"]                              = { id = "kr40/nvim-macros",              expander = gh, lazy = false },
	["recorder"]                            = { id = "chrisgrieser/nvim-recorder",    expander = gh, lazy = false },
	-------------------------
	------ multi-cursor -----
	-------------------------
	["vim-visual-multi"]                         = { id = "mg979/vim-visual-multi",        expander = gh, lazy = false },
	-------------------
	------ motion -----
	-------------------
	["leap"]                                     = { id = "andyg/leap.nvim",               expander = cb, lazy = false }, -- needs nix
	["flash"]                                    = { id = "folke/flash.nvim",              expander = gh, lazy = false }, -- needs nix
	["hop"]                                      = { id = "smoka7/hop.nvim",               expander = gh, lazy = false }, -- needs nix
	------------------
	------ pairs -----
	------------------
	["rainbow-delimiters"]                       = { id = "HiPhish/rainbow-delimiters.nvim", expander = gh, lazy = false }, -- needs nix
	["nvim-autopairs"]                           = { id = "windwp/nvim-autopairs",         expander = gh, lazy = false }, -- needs nix
	["blink.pairs"]                              = { id = "saghen/blink.pairs",            expander = gh, lazy = false }, -- needs nix
	["vim-sandwich"]                             = { id = "machakann/vim-sandwich",        expander = gh, lazy = false }, -- needs nix
	["surround"]                            = { id = "kylechui/nvim-surround",        expander = gh, lazy = false }, -- needs nix
	-----------------
	------ undo -----
	-----------------
	["vim-mundo"]                                = { id = "simnalamburt/vim-mundo",        expander = gh, lazy = false }, -- needs nix
	-------------------------------
	------ keymapping-related -----
	-------------------------------
	["mini.keymap"]                              = { id = "nvim-mini/mini.keymap",         expander = gh, lazy = false }, -- needs nix
	["hydra"]                                    = { id = "nvimtools/hydra.nvim",          expander = gh, lazy = false }, -- needs nix
	["nvim-insx"]                                = { id = "hrsh7th/nvim-insx",             expander = gh, lazy = false }, -- needs nix
	["which-key"]                                = { id = "folke/which-key.nvim",          expander = gh, lazy = false },
	------------------------------------
	------ alignment / indentation -----
	------------------------------------
	["indentmini"]                               = { id = "nvimdev/indentmini.nvim",       expander = gh, lazy = false }, -- needs nix
	["indent-blankline"]                         = { id = "lukas-reineke/indent-blankline.nvim", expander = gh, lazy = false }, -- needs nix
	["nvim-anydent"]                             = { id = "hrsh7th/nvim-anydent",          expander = gh, lazy = false }, -- needs nix
	["mini.align"]                               = { id = "nvim-mini/mini.align",          expander = gh, lazy = false }, -- needs nix
	["tabular"]                                  = { id = "godlygeek/tabular",             expander = gh, lazy = false }, --  -- needs nix; https://devhints.io/tabular
	------------------------
	------ textobjects -----
	------------------------
	["nvim-treesitter-textobjects"] = {
		id = "nvim-treesitter/nvim-treesitter-textobjects",
		expander = gh,
		lazy = false,
		name = "nvim-treesitter-textobjects",
	},
	["nvim-various-textobjs"]  = { id = "chrisgrieser/nvim-various-textobjs", expander = gh, lazy = false }, -- needs nix
	---------------------
	------ comments -----
	---------------------
	["Comment"]                                  = { id = "numToStr/Comment.nvim",         expander = gh, lazy = false }, -- needs nix
	["todo-comments"]                            = { id = "folke/todo-comments.nvim",      expander = gh, lazy = false },
	["vim-commentary"]                           = { id = "tpope/vim-commentary",          expander = gh, lazy = false }, -- needs nix
	-------------------------
	------ split / join -----
	-------------------------
	["treesj"]                                   = { id = "Wansmer/treesj",                expander = gh, lazy = false }, -- needs nix
	-------------------------------
	------ value manipulation -----
	-------------------------------
	["dial"]                                     = { id = "monaqa/dial.nvim",              expander = gh, lazy = false },
	------------------
	------ marks -----
	------------------
	["harpoon-core"]                             = { id = "MeanderingProgrammer/harpoon-core.nvim", expander = gh, lazy = false }, -- needs nix
	["marks"]                                    = { id = "chentoast/marks.nvim",          expander = gh, lazy = false },
	["markit"]                                   = { id = "2KAbhishek/markit.nvim",        expander = gh, lazy = false }, -- needs nix
	-----------------------------------
	------ yank/paste & clipboard -----
	-----------------------------------
	["nvim-pasta"]                               = { id = "hrsh7th/nvim-pasta",            expander = gh, lazy = false }, -- needs nix
	--------------------------
	------ miscellaneous -----
	--------------------------
	["beam"]                                     = { id = "Piotr1215/beam.nvim",           expander = gh, lazy = false }, -- needs nix

	--===================================================================================================================================
	--==== LAYER 2: LSP, autocompletion, snippets ======================================================================================= 2
	--===================================================================================================================================
	-----------------------------------
	------ snippets, autocomplete -----
	-----------------------------------
	["blink.cmp"]                                = { id = "Saghen/blink.cmp",              expander = gh, lazy = false },
	["nvim-cmp"]                                 = { id = "hrsh7th/nvim-cmp",              expander = gh, lazy = false }, -- needs nix
	-------------------------------------
	------ snippets (as main focus) -----
	-------------------------------------
	["friendly-snippets"]                        = { id = "rafamadriz/friendly-snippets",  expander = gh, lazy = false },
	["ultisnips"]                                = { id = "SirVer/ultisnips",              expander = gh, lazy = false }, -- needs nix; https://ejmastnak.com/tutorials/vim-latex/ultisnips/
	["LuaSnip"]                                  = { id = "L3MON4D3/LuaSnip",              expander = gh, lazy = false },
	------ completion sources -----
	["cmp-nvim-lsp"]                             = { id = "hrsh7th/cmp-nvim-lsp",          expander = gh, lazy = false }, -- needs nix
	["cmp-buffer"]                               = { id = "hrsh7th/cmp-buffer",            expander = gh, lazy = false }, -- needs nix
	["cmp-path"]                                 = { id = "hrsh7th/cmp-path",              expander = gh, lazy = false }, -- needs nix
	["cmp-cmdline"]                              = { id = "hrsh7th/cmp-cmdline",           expander = gh, lazy = false }, -- needs nix
	------------------------
	------ LSP general -----
	------------------------
	-- (configure ruff, pyright, lua-language-server, haskell-language-server, rust-analyzer with built-in client)
	["lsp-format"]                               = { id = "lukas-reineke/lsp-format.nvim", expander = gh, lazy = false }, -- needs nix
	["lspkind"]                                  = { id = "onsails/lspkind.nvim",          expander = gh, lazy = false }, -- needs nix
	["efm"]                                      = { id = "mattn/efm-langserver",          expander = gh, lazy = false },
	------------------------------------------
	------ LSP UI (see also fidget.nvim) -----
	------------------------------------------
	["lspsaga"]                                  = { id = "nvimdev/lspsaga.nvim",          expander = gh, lazy = false }, -- needs nix
	------ language-specific -----
	["lazydev"]                                  = { id = "folke/lazydev.nvim",            expander = gh, lazy = false }, -- needs nix
	["rustaceanvim"]                             = { id = "mrcjkb/rustaceanvim",           expander = gh, lazy = false }, -- already lazy
	["crates"]                                   = { id = "saecki/crates.nvim",            expander = gh, lazy = false }, -- needs nix
	["haskell-tools"]                            = { id = "mrcjkb/haskell-tools.nvim",     expander = gh, lazy = false }, -- already lazy
	------ LSP-adjacent -----
	["none-ls"]                                  = { id = "nvimtools/none-ls.nvim",        expander = gh, lazy = false }, -- needs nix

	--===================================================================================================================================
	-- LAYER 3: formatting & linting ==================================================================================================== 3
	--===================================================================================================================================
	["guard"]                                    = { id = "nvimdev/guard.nvim",            expander = gh, lazy = false }, -- needs nix
	["conform"]                                  = { id = "stevearc/conform.nvim",         expander = gh, lazy = false }, -- ruff, rustfmt, stylua, fourmolu

	--===================================================================================================================================
	-- LAYER 4: testing, debugging/quickfix, execution ================================================================================== 4
	--===================================================================================================================================
	-------------------------------------------------
	----- Code execution / task running / build -----
	-------------------------------------------------
	["overseer"]                                 = { id = "stevearc/overseer.nvim",        expander = gh, lazy = false }, -- needs nix
	["asyncrun"]                                 = { id = "skywind3000/asyncrun.vim",      expander = gh, lazy = false }, -- needs nix
	["compiler"]                                 = { id = "Zeioth/compiler.nvim",          expander = gh, lazy = false },
	["code_runner"]                              = { id = "CRAG666/code_runner.nvim",      expander = gh, lazy = false },
	["sniprun"]                                  = { id = "michaelb/sniprun",              expander = gh, lazy = false },
	["yabs"]                                     = { id = "pianocomposer321/officer.nvim", expander = gh, lazy = false },
	-------------------
	----- Testing -----
	-------------------
	["neotest-haskell"]                          = { id = "MrcJkb/neotest-haskell",        expander = gh, lazy = false }, -- TODO
	["neotest-python"]                           = { id = "nvim-neotest/neotest-python",   expander = gh, lazy = false },
	["neotest"]                                  = { id = "nvim-neotest/neotest",          expander = gh, lazy = false },
	["dap-python"]                               = { id = "mfussenegger/nvim-dap-python",  expander = cb, lazy = false }, -- needs nix; pipx install debugpy
	["dapui"]                                    = { id = "rcarriga/nvim-dap-ui",          expander = gh, lazy = false }, -- needs nix
	["nvim-dap-virtual-text"]                    = { id = "theHamsta/nvim-dap-virtual-text", expander = gh, lazy = false }, -- needs nix
	["dap"]                                      = { id = "mfussenegger/nvim-dap",         expander = cb, lazy = false }, -- needs nix
	["mypy"]                                     = { id = "feakuru/mypy.nvim",             expander = gh, lazy = false }, -- needs nix
	["nvim-lint"]                                = { id = "mfussenegger/nvim-lint",        expander = gh, lazy = false }, -- needs nix
	---------------------------
	------ DAP/quickix UI -----
	---------------------------
	["trouble.nvim"]                             = { id = "folke/trouble.nvim",            expander = gh, lazy = false }, -- needs nix
	["quicker"]                                  = { id = "stevearc/quicker.nvim",         expander = gh, lazy = false }, -- needs nix
	["nvim-bqf"]                                 = { id = "kevinhwang91/nvim-bqf",         expander = gh, lazy = false },
	---------------------
	------ terminal -----
	---------------------
	["vim-floaterm"]                             = { id = "voldikss/vim-floaterm",         expander = gh, lazy = false },
	--===================================================================================================================================
	--==== LAYER 5: refactoring & code intelligence ===================================================================================== 5
	--===================================================================================================================================
	["refactoring"]                              = { id = "ThePrimeagen/refactoring.nvim", expander = gh, lazy = false }, -- needs nix
	-------------------------------
	------ project management -----
	-------------------------------
	["project"]                                  = { id = "ahmedkhalf/project.nvim",       expander = gh, lazy = false }, -- needs nix
	["telescope-project"]                        = { id = "nvim-telescope/telescope-project.nvim", expander = gh, lazy = false }, -- needs nix

	--===================================================================================================================================
	--==== LAYER 6: version control & collaboration ===================================================================================== 6
	--===================================================================================================================================
	["jj"]                                       = { id = "NicolasGB/jj.nvim",             expander = gh, lazy = false }, -- needs nix
	["jujutsu"]                                  = { id = "yannvanhalewyn/jujutsu.nvim",   expander = gh, lazy = false }, -- needs nix
	["lazygit"]                                  = { id = "kdheepak/lazygit.nvim",         expander = gh, lazy = false }, -- needs nix
	["git-conflict"]                             = { id = "akinsho/git-conflict.nvim",     expander = gh, lazy = false }, -- needs nix
	["neogit"]                                   = { id = "NeogitOrg/neogit",              expander = gh, lazy = false }, -- needs nix
	["jiejie"]                                   = { id = "jceb/jiejie.nvim",              expander = gh, lazy = false }, -- needs nix
	["diffview"]                                 = { id = "sindrets/diffview.nvim",        expander = gh, lazy = false },
	["gitsigns"]                                 = { id = "lewis6991/gitsigns.nvim",       expander = gh, lazy = false },
	["vim-fugitive"]                             = { id = "tpope/vim-fugitive",            expander = gh, lazy = false }, -- needs nix
	----------------------
	----- Git forges -----
	----------------------
	["octo"]                                     = { id = "pwntester/octo.nvim",           expander = gh, lazy = false }, -- needs nix
	["gitlab-nvim"]                              = { id = "harrisoncramer/gitlab.nvim",    expander = gh, lazy = false }, -- needs nix
	["gitlab"]                                   = { id = "gitlab-org/editor-extensions/gitlab.vim", expander = gl, lazy = false }, -- needs nix

	--===================================================================================================================================
	--==== LAYER 7: UI polish & productivity ============================================================================================ 7
	--===================================================================================================================================
	["dashboard-nvim"]                           = { id = "nvimdev/dashboard-nvim",        expander = gh, lazy = false }, -- needs nix
	["dashboard"]                                = { id = "MeanderingProgrammer/dashboard.nvim", expander = gh, lazy = false }, -- needs nix
	["noice"]                                    = { id = "folke/noice.nvim",              expander = gh, lazy = false }, -- needs nix
	["modes"]                                    = { id = "mvllow/modes.nvim",             expander = gh, lazy = false }, -- needs nix
	-----------------------------------
	------ UI (important for LSP) -----
	-----------------------------------
	["fidget"]                                   = { id = "j-hui/fidget.nvim",             expander = gh, lazy = false }, -- needs nix
	["nvim-notify"]                              = { id = "rcarriga/nvim-notify",          expander = gh, lazy = false }, -- needs nix; see also mini.notify
	["headlines"]                                = { id = "lukas-reineke/headlines.nvim",  expander = gh, lazy = false }, -- needs nix
	-------------------------------
	------ session management -----
	-------------------------------
	["auto-session"]                             = { id = "rmagatti/auto-session",         expander = gh, lazy = false }, -- needs nix
	["persistence"]                              = { id = "folke/persistence.nvim",        expander = gh, lazy = false }, -- needs nix

	--===================================================================================================================================
	--==== LAYER 8: miscellaneous/advanced ============================================================================================== 8
	--===================================================================================================================================
	["vimtex"]                                   = { id = "lervag/vimtex",                 expander = gh, lazy = false }, -- needs nix; use vim.cmd.source or vim.fn.runtime
	["texmagic"]                                 = { id = "jakewvincent/texmagic.nvim",    expander = gh, lazy = false }, -- needs nix
	["schemastore"]                              = { id = "b0o/SchemaStore.nvim",          expander = gh, lazy = false }, -- needs nix
	["firenvim"]                                 = { id = "glacambre/firenvim",            expander = gh, lazy = false }, -- needs nix
	["render-markdown"]                          = { id = "MeanderingProgrammer/render-markdown.nvim", expander = gh, lazy = false }, -- needs nix
	["jupytext"]                                 = { id = "GCBallesteros/jupytext.nvim",   expander = gh, lazy = false }, -- needs nix
	["quarto"]                                   = { id = "quarto-dev/quarto-nvim",        expander = gh, lazy = false }, -- needs nix
	["markdown-preview"]                         = { id = "iamcco/markdown-preview.nvim",  expander = gh, lazy = false }, -- needs nix
	-----------------------------------
	------ Lua / self-referential -----
	-----------------------------------
	["structlog"]                                = { id = "Tastyep/structlog.nvim",        expander = gh, lazy = false }, -- needs nix
	["neorepl"]                                  = { id = "ii14/neorepl.nvim",             expander = gh, lazy = false }, -- needs nix
}

local add_plugin = function(name)
	local cfg = PLUGIN_DECLARATION[name]
	vim.pack.add({ { src = cfg.expander(cfg.id) } })
end

for _, name in ipairs(PLUGINS) do
	add_plugin(name)
end

function contains(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

local function print_status(length, prefix, name, suffix)
	local pad = string.rep(" ", length - string.len(name))
	print(prefix .. " " .. name .. pad .. " " .. suffix)
end


function attempt(plugin_name, opts)
	if not contains(PLUGINS, plugin_name) then
		return
	end
	local result, plugin = pcall(require, plugin_name)
	if not result then
		print_status(30, "IMPORTING:  ", plugin_name, "[ERROR]")
		return
	end
	local result, setup = pcall(plugin.setup, opts or {})
	if result then
		print_status(30, "CONFIGURING:", plugin_name, "[SUCCESS]")
	else
		print_status(30, "CONFIGURING:", plugin_name, "[ERROR] ===================================")
	end
end

--======================================================================================================================
-- LAYER 0: foundation, colors, search, core navigation ================================================================
--======================================================================================================================

------ core dependencies
attempt("plenary")
attempt("nio")

attempt("nvim-web-devicons")
------ core setup and UI
if contains(PLUGINS, "bamboo") then
	printb("Setting up bamboo")
	require("bamboo").setup({
		style = "multiplex",
		colors = {
			bg0 = "#020802",
		},
		-- highlights   = { Normal = { bg = "#020802" } },
	})
	require("bamboo").load()
	-- require("vague").setup({ transparent = true })
	-- vim.cmd("colorscheme bamboo")
	-- vim.cmd(":hi statusline guibg=#081608")
end
attempt("zen-mode")
attempt("lualine")
attempt("nvim-navic")
attempt("bufferline")
attempt("statuscol")
if contains(PLUGINS, "nvim-treesitter") then
	printb("Setting up treesitter.")
	local my_install_dir = (not HAS_NIX) and vim.fn.stdpath("data") .. "/site" or nil
	local my_parser_install_dir = (not HAS_NIX) and vim.fn.stdpath("data") .. "/parsers" or nil
	local my_ensure_installed = HAS_NIX and {} or TS_LANGUAGES
	-- vim.fn.mkdir(my_parser_install_dir, "p")
	-- IMPORTANT: Neovim expects parsers to be in a 'parser' subfolder of an RTP entry
	-- vim.opt.runtimepath:append(my_parser_install_dir)
	printv(my_install_dir)
	printv(my_parser_install_dir)
	printv(vim.inspect(my_ensure_installed))
	local treesitter = require("nvim-treesitter")
	-- for k, v in pairs(treesitter) do
	-- 	print(k)
	-- 	print(v)
	-- end
	print("Treesitter exists -------------------")
	-- local treesitter_config = require("nvim-treesitter.config")
	-- for k, v in pairs(treesitter_config) do
	-- 	print(k)
	-- 	print(v)
	-- end
	local treesitter = require("nvim-treesitter")
	treesitter.setup({
		-- directory to install parsers and queries to (prepended to `runtimepath` to have priority)
		install_dir = my_install_dir,
		parser_install_dir = my_parser_install_dir,
		ensure_installed = my_ensure_installed,
		highlight = { enable = true },
		indent = { enable = true },
	})
	-- require("nvim-treesitter.config").setup({
	-- 	ensure_installed = my_ensure_installed,
	-- })
	-- -- if not HAS_NIX then
	-- treesitter.install({ "python" })
	-- -- end
	-- print(vim.inspect(require("nvim-treesitter").get_installed()))
end
attempt("treesitter-modules")
attempt("dropbar")
attempt("nvim-navbuddy")
if contains(PLUGINS, "aerial") then
	plugin_name = "aerial"
	require("aerial")
	print_status(30, "IMPORTING:  ", plugin_name, "[SUCCESS]")
end
------ file explorer (as central focus)
attempt("oil")
attempt("yazi")
attempt("neo-tree")
attempt("nvim-tree")
------ picker / search
attempt("pickme")
attempt("telescope")
if contains(PLUGINS, "telescope-fzf-native") then
	plugin_name = "telescope-fzf-native"
	-- require(plugin_name).setup()
	print_status(30, "IMPORTING:  ", plugin_name, "[ERROR]")
end
attempt("fzf-lua")
attempt("deck")
------ suites
attempt("mini")
attempt("snacks")
attempt("blink")
------ search
attempt("hlslens")
attempt("hlsearch")
------ find-and-replace
attempt("grug-far")
attempt("spectre")
------ layout & buffer/tab navigation
attempt("flybuf")
attempt("stickybuf")
if contains(PLUGINS, "swm") then
	plugin_name = "swm"
	local swm = require(plugin_name)
	vim.keymap.set("n", "<C-w>h", swm.h)
	vim.keymap.set("n", "<C-w>j", swm.j)
	vim.keymap.set("n", "<C-w>k", swm.k)
	vim.keymap.set("n", "<C-w>l", swm.l)
	print_status(30, "CONFIGURING:", plugin_name, "[SUCCESS]")
end
------ wezterm integration
attempt("smart-splits")

-- LAYER 1: editing enhancements ======================================================================================= 1
------ folds
attempt("ufo")
-- if contains(PLUGINS, "ufo") then
-- 	plugin_name = "ufo"
-- 	-- require(plugin_name).setup()
-- 	print_error(plugin_name)
-- end

------ macros
attempt("NeoComposer")
if contains(PLUGINS, "nvim-macros") then
	plugin_name = "nvim-macros"
	require(plugin_name).setup({
		-- json_file_path = "./macros.json",
		-- default_macro_register = "a",
		-- json_formatter = "jq",
	})
	print_status(30, "CONFIGURING:", plugin_name, "[SUCCESS]")
end
attempt("recorder")

------ multi-cursor
if contains(PLUGINS, "vim-visual-multi") then
	plugin_name = "vim-visual-multi"
	-- require(plugin_name).setup()
	print_status(30, "IMPORTING:  ", plugin_name, "[ERROR]")
end
------ motion
attempt("leap")
attempt("flash")
attempt("hop")
------ pairs
if contains(PLUGINS, "rainbow-delimiters") then
	-- plugin_name = "rainbow-delimiters"
	-- require(plugin_name).setup()
	-- print_todo(plugin_name)
	attempt("rainbow-delimiters")
end
attempt("nvim-autopairs")
--TODO attempt("blink.pairs")
attempt("vim-sandwich")
attempt("surround")
------ undo
attempt("vim-mundo")
------ keymapping-related
attempt("mini.keymap")
attempt("hydra")
attempt("nvim-insx")
attempt("which-key")
------ alignment / indentation
attempt("indentmini")
attempt("indent-blankline")
attempt("nvim-anydent")
attempt("mini.align")
attempt("tabular")
------ textobjects
attempt("nvim-treesitter-textobjects")
attempt("nvim-various-textobjs")
------ comments
attempt("Comment")
attempt("todo-comments")
attempt("vim-commentary")
------ split / join
attempt("treesj")
------ value manipulation
attempt("dial")
------ marks
attempt("harpoon-core")
attempt("marks")
attempt("markit")
------ yank/paste & clipboard
attempt("nvim-pasta")
------ miscellaneous
attempt("beam")
------ sort

-- LAYER 2: LSP, autocompletion, snippets =========================================================================================== 2
------ snippets, autocomplete
attempt("blink.cmp")
attempt("nvim-cmp")
------ snippets (as main focus)
attempt("friendly-snippets")
attempt("ultisnips")
attempt("LuaSnip")
------ completion sources
attempt("cmp-nvim-lsp")
attempt("cmp-buffer")
attempt("cmp-path")
attempt("cmp-cmdline")
------ LSP general (configure ruff, pyright, lua-language-server, haskell-language-server, rust-analyzer with built-in client)
attempt("lsp-format")
attempt("lspkind")
------ LSP UI
-- see also fidget.nvim
attempt("lspsaga")
------ language-specific
attempt("lazydev")
attempt("rustaceanvim")
attempt("crates")
attempt("haskell-tools")
------ LSP-adjacent
attempt("none-ls")

-- LAYER 3: formatting & linting ==================================================================================================== 3
attempt("guard")
attempt("conform")

-- LAYER 4: testing, debugging/quickfix, execution ================================================================================== 4
attempt("asyncrun")
attempt("neotest-haskell")
attempt("neotest-python")
attempt("neotest")
if contains(PLUGINS, "dap-python") then
	print("dap-python")
	local dap_python = require("dap-python")
	dap_python.setup("debugpy-adapter")
	dap_python.test_runner = "pytest"
	vim.keymap.set("n", "<leader>tt", function()
		print("Leader is working!")
	end)
	vim.keymap.set("n", "<leader>pp", function()
		print("This works")
	end)
	vim.keymap.set("n", "<leader>dn", function()
		require("dap-python").test_method()
	end)
	vim.keymap.set("n", "<leader>df", function()
		require("dap-python").test_class()
	end)
	vim.keymap.set("v", "<leader>ds", function()
		require("dap-python").debug_selection()
	end)
end
attempt("dapui")
attempt("nvim-dap-virtual-text")
attempt("dap")
attempt("mypy")
attempt("nvim-lint")
------ DAP/quickix UI
attempt("trouble.nvim")
attempt("quicker")
attempt("nvim-bqf")
------ terminal
attempt("vim-floaterm")
attempt("toggleterm")
------ code/task runners
attempt("overseer")

-- LAYER 5: refactoring & code intelligence ========================================================================================= 5
attempt("refactoring")
------ project management
attempt("project")
attempt("telescope-project")

-- LAYER 6: version control & collaboration ========================================================================================= 6
attempt("jj")
attempt("jujutsu")
attempt("lazygit")
attempt("git-conflict")
attempt("neogit")
attempt("jiejie")
attempt("diffview")
attempt("gitsigns")
attempt("vim-fugitive")
-- git forges
attempt("octo")
attempt("gitlab-nvim")
attempt("gitlab")

-- LAYER 7: UI polish & productivity ================================================================================================ 7
attempt("dashboard-nvim")
attempt("dashboard")
attempt("noice")
attempt("modes")
------ UI (important for LSP)
attempt("fidget")
attempt("nvim-notify")
attempt("headlines")
------ session management
attempt("auto-session")
attempt("persistence")

-- LAYER 8: miscellaneous/advanced =========================================================================================================== 8
if contains(PLUGINS, "vimtex") then
	vim.g.vimtex_view_method = "zathura"
end
attempt("texmagic")
attempt("schemastore")
attempt("firenvim")
attempt("render-markdown")
attempt("jupytext")
attempt("quarto")
attempt("markdown-preview")
------ Lua / self-referential
attempt("structlog")
attempt("neorepl")
--=============================================================================================================================================================

if WEZTERM then
	-- https://github.com/ianhomer/wezterm.nvim/blob/main/lua/wezterm.lua --------------------------------------------------
	local wez = {}

	local directions = {
		h = "Left",
		l = "Right",
		j = "Down",
		k = "Up",
	}

	local arrows = {
		h = "left",
		l = "right",
		j = "down",
		k = "up",
	}

	local function command(args)
		os.execute("wezterm cli " .. args)
	end

	function wez.navigate(direction)
		command("activate-pane-direction " .. directions[direction])
	end

	function wez.go_direction(direction)
		local current_window = vim.fn.win_getid()
		vim.api.nvim_command("wincmd " .. direction)
		local at_edge = current_window == vim.fn.win_getid()
		if at_edge then
			wez.navigate(direction)
		end
	end

	function wez.keys()
		local keys = {}
		for key, _ in pairs(directions) do
			table.insert(keys, {
				"<c-" .. key .. ">",
				function()
					wez.go_direction(key)
				end,
				mode = { "n" },
				desc = "Navigate " .. arrows[key],
			})
		end

		return keys
	end

	function wez.setup(opts)
		for key, _ in pairs(directions) do
			vim.keymap.set("", "<c-" .. key .. ">", function()
				wez.go_direction(key)
			end)
			-- support ctrl arrow keys in normal an insert mode
			vim.keymap.set({ "i", "n", "v", "x", "c" }, "<c-" .. arrows[key] .. ">", function()
				print("D" .. key)
				M.go_direction(key)
			end)
		end
	end

	-- return wez
	--
	-- https://github.com/letieu/wezterm-move.nvim/blob/master/lua/wezterm-move/init.lua ----------------------------------
	local WM = {}

	local wezterm_directions = { h = "Left", j = "Down", k = "Up", l = "Right" }

	-- @param direction: string (h, j, k, l)
	local function at_edge(direction)
		return vim.fn.winnr() == vim.fn.winnr(direction)
	end

	local function wezterm_exec(cmd)
		local command = vim.deepcopy(cmd)
		if vim.fn.executable("wezterm.exe") == 1 then
			table.insert(command, 1, "wezterm.exe")
		else
			table.insert(command, 1, "wezterm")
		end
		table.insert(command, 2, "cli")
		return vim.fn.system(command)
	end

	-- @param direction: string (h, j, k, l)
	local function send_key_to_wezterm(direction)
		wezterm_exec({ "activate-pane-direction", wezterm_directions[direction] })
	end

	-- @param direction: string (h, j, k, l)
	WM.move = function(direction)
		if at_edge(direction) then
			send_key_to_wezterm(direction)
		else
			vim.cmd("wincmd " .. direction)
		end
	end
end


--]]