-- vim.pack.add({
--     { src = "nvim-treesitter/nvim-treesitter" }
-- })
-- vim.opt.runtimepath:append("/Users/ext_riley/.local/share/nvim/site")
-- local my_parser_dir = "/Users/ext_riley/repos/nvim-config/testing/parsers"
-- vim.fn.mkdir(my_parser_dir, "p")
-- package.path = package.path .. ";/Users/ext_riley/.local/share/nvim/site/pack/core/opt/nvim-treesitter/lua/?.lua"
-- local ts = require("nvim-treesitter")

-- ts.setup({
--     -- EXPLICIT: Tell the plugin to install files here
--     parser_install_dir = my_parser_dir,

--     ensure_installed = { "python", "lua" },
--     highlight = { enable = true },
-- })

----------------

-- -- 2. Find where Neovim actually put it
-- -- This command finds the directory on your disk
-- local ts_path = vim.api.nvim_get_runtime_file("", false)
-- -- Find the one that actually contains nvim-treesitter
-- local plugin_root = ""
-- for _, path in ipairs(ts_path) do
--     if path:match("nvim%-treesitter") then
--         plugin_root = path
--         break
--     end
-- end
-- print(plugin_root)

-- -- 3. If we found it, MANUALLY inject it into Lua's search path
-- if plugin_root ~= "" then
--     local lua_path = plugin_root .. "/lua/?.lua"
--     if not package.path:find(lua_path, 1, true) then
--         package.path = package.path .. ";" .. lua_path
--     end
-- end
-- print(plugin_root)

-- -- 4. Now require should work because the file is explicitly in package.path
-- require("nvim-treesitter").setup({
--     ensure_installed = { "python", "lua" },
--     highlight = { enable = true },
-- })

WEZTERM = true
local PLUGINS = {
	-- --[[
	-- old
	"bamboo",
	-- "vimtex",
	-- "neotest",
	-- "neotest-python",
	"dap", -- debugpy
	"dap-python",
	-- "nvim-treesitter", -- brew install tree-sitter
	-- --]]

	-- LAYER 0: foundation, colors, search, core navigation ===============================================================================
	------ core dependencies
	"plenary",
	"nvim-nio",
	"nvim-web-devicons",
	"nui",
	------ core setup and UI
	"bamboo",
	"zen-mode",
	"lualine",
	"nvim-navic",
	"bufferline",
	"statuscol",
	"nvim-treesitter",
	"treesitter-modules",
	"dropbar",
	"nvim-navbuddy",
	"aerial",
	------ file explorer (as central focus)
	"oil",
	"yazi",
	"neo-tree",
	"nvim-tree",
	------ picker / search
	"pickme",
	"telescope",
	"telescope-fzf-native",
	"fzf-lua",
	"nvim-deck",
	------ suites
	"mini",
	"snacks",
	"blink",
	------ search
	"nvim-hlslens",
	"hlsearch",
	------ find-and-replace
	"grug-far",
	"nvim-spectre",
	------ layout & buffer/tab navigation
	"flybuf",
	"stickybuf",
	"swm",
	------ wezterm integration
	"smart-splits",
}

-- function addRelPath(dir)
-- 	local spath = debug.getinfo(1, "S").source:sub(2):gsub("^([^/])", "./%1"):gsub("[^/]*$", "")
-- 	dir = dir and (dir .. "/") or ""
-- 	spath = spath .. dir
-- 	package.path    = spath .. "?.lua;" .. spath .. "?/init.lua"
-- 	--  ..package.path
-- end

-- addRelPath()

-- vim.pack.add({
--     {
--         src = "nvim-treesitter/nvim-treesitter",
--         opt = true
--     }
-- })
-- vim.cmd('packadd nvim-treesitter')
-- local ok, ts_configs = pcall(require, "nvim-treesitter")
-- if ok then
--     ts_configs.setup({
--         ensure_installed = {
--             "python", "lua", "javascript", "typescript",
--             "nix", "json", "yaml", "toml", "markdown",
--         },
--         highlight = { enable = true },
--         indent = { enable = true },
--     })
-- else
--     print("Treesitter failed to load!")
-- end
-- vim.cmd("TSUpdate")
-- print("before")
-- vim.cmd.packadd("nvim-treesitter")
-- print("after")
-- require("nvim-treesitter").setup({
-- 	ensure_installed = {
-- 		"python",
-- 		"lua",
-- 		"javascript",
-- 		"typescript",
-- 		"nix",
-- 		"json",
-- 		"yaml",
-- 		"toml",
-- 		"markdown",
-- 	},
-- 	highlight = { enable = true },
-- 	indent = { enable = true },
-- })

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

local PLUGIN_DECLARATION = {
	-- LAYER 0: foundation, colors, search, core navigation ===============================================================================
	------ core dependencies
	["plenary"]         = { id = "nvim-lua/plenary.nvim",     expander = gh, lazy = false },
	["nvim-nio"]        = { id = "nvim-neotest/nvim-nio",     expander = gh, lazy = false },
	["nvim-web-devicons"] = { id = "nvim-tree/nvim-web-devicons", expander = gh, lazy = false }, -- needs nix
	["nui"]             = { id = "MunifTanjim/nui.nvim",      expander = gh, lazy = false }, -- needs nix
	------ core setup and UI
	["bamboo"]          = { id = "ribru17/bamboo.nvim",       expander = gh, lazy = false },
	["zen-mode"]        = { id = "folke/zen-mode.nvim",       expander = gh, lazy = false },
	["lualine"]         = { id = "nvim-lualine/lualine.nvim", expander = gh, lazy = false },
	["nvim-navic"]      = { id = "SmiteshP/nvim-navic",       expander = gh, lazy = false }, -- needs nix
	["bufferline"]      = { id = "akinsho/bufferline.nvim",   expander = gh, lazy = false }, -- needs nix
    ["statuscol"]   = { id = "luukvbaal/statuscol.nvim",      expander = gh, lazy = false }, -- needs nix
	["nvim-treesitter"] = { id = "nvim-treesitter/nvim-treesitter", expander = gh, lazy = false }, -- brew install tree-sitter; brew install tree-sitter-cli
	["treesitter-modules"] = { id = "MeanderingProgrammer/treesitter-modules.nvim", expander = gh, lazy = false }, -- needs nix
	["dropbar"]         = { id = "Bekaboo/dropbar.nvim",      expander = gh, lazy = false }, -- needs nix
	["nvim-navbuddy"]   = { id = "SmiteshP/nvim-navbuddy",    expander = gh, lazy = false, deps = { "nui" } }, -- needs nix
	["aerial"]          = { id = "stevearc/aerial.nvim",      expander = gh, lazy = false }, -- needs nix
	------ file explorer (as central focus)
	["oil"]             = { id = "stevearc/oil.nvim",         expander = gh, lazy = false },
	["yazi"]            = { id = "mikavilpas/yazi.nvim",      expander = gh, lazy = false },
	["neo-tree"]        = { id = "nvim-neo-tree/neo-tree.nvim", expander = gh, lazy = false }, -- needs nix
	["nvim-tree"]       = { id = "nvim-tree/nvim-tree.lua",   expander = gh, lazy = false }, -- needs nix
	------ picker / search
	["pickme"]          = { id = "2KAbhishek/pickme.nvim",    expander = gh, lazy = false },
	["telescope"]       = { id = "nvim-telescope/telescope.nvim", expander = gh, lazy = false },
	["telescope-fzf-native"] = { id = "nvim-telescope/telescope-fzf-native.nvim", expander = gh, lazy = false },
	["fzf-lua"]         = { id = "ibhagwan/fzf-lua",          expander = gh, lazy = false }, -- needs nix
	["nvim-deck"]       = { id = "hrsh7th/nvim-deck",         expander = gh, lazy = false }, -- needs nix
	------ suites
	["mini"]            = { id = "nvim-mini/mini.nvim",       expander = gh, lazy = false },
	["snacks"]          = { id = "folke/snacks.nvim",         expander = gh, lazy = false },
	["blink"]           = { id = "saghen/blink.nvim",         expander = gh, lazy = false }, -- needs nix
	------ search
	["nvim-hlslens"]    = { id = "kevinhwang91/nvim-hlslens", expander = gh, lazy = false }, -- needs nix
	["hlsearch"]        = { id = "nvimdev/hlsearch.nvim",     expander = gh, lazy = false }, -- needs nix
	------ find-and-replace
	["grug-far"]        = { id = "MagicDuck/grug-far.nvim",   expander = gh, lazy = false }, -- needs nix
	["nvim-spectre"]    = { id = "nvim-pack/nvim-spectre",    expander = gh, lazy = false }, -- needs nix
	------ layout & buffer/tab navigation
	["flybuf"]          = { id = "nvimdev/flybuf.nvim",       expander = gh, lazy = false }, -- needs nix
	["stickybuf"]       = { id = "stevearc/stickybuf.nvim",   expander = gh, lazy = false }, -- needs nix
	["swm"]             = { id = "hrsh7th/nvim-swm",          expander = gh, lazy = false }, -- needs nix
	------ wezterm integration
	["smart-splits"]    = { id = "mrjones2014/smart-splits.nvim", expander = gh, lazy = false }, -- needs nix

	-- LAYER 1: editing enhancements ==================================================================================================== 1
	------ folds
	["nvim-ufo"]        = { id = "kevinhwang91/nvim-ufo",     expander = gh, lazy = false }, -- needs nix
	------ multi-cursor
	["vim-visual-multi"] = { id = "mg979/vim-visual-multi",   expander = gh, lazy = false },
	------ motion
	["leap"]            = { id = "andyg/leap.nvim",           expander = cb, lazy = false }, -- needs nix
	["flash"]           = { id = "folke/flash.nvim",          expander = gh, lazy = false }, -- needs nix
	["hop"]             = { id = "smoka7/hop.nvim",           expander = gh, lazy = false }, -- needs nix
	------ pairs
	["rainbow-delimiters"] = { id = "HiPhish/rainbow-delimiters.nvim", expander = gh, lazy = false }, -- needs nix
	["nvim-autopairs"]  = { id = "windwp/nvim-autopairs",     expander = gh, lazy = false }, -- needs nix
	["blink.pairs"]     = { id = "saghen/blink.pairs",        expander = gh, lazy = false }, -- needs nix
	["vim-sandwich"]    = { id = "machakann/vim-sandwich",    expander = gh, lazy = false }, -- needs nix
	["nvim-surround"]   = { id = "kylechui/nvim-surround",    expander = gh, lazy = false }, -- needs nix
	------ undo
	["vim-mundo"]       = { id = "simnalamburt/vim-mundo",    expander = gh, lazy = false }, -- needs nix
	------ keymapping-related
-- ADD mini.keymap
	["hydra"]           = { id = "nvimtools/hydra.nvim",      expander = gh, lazy = false }, -- needs nix
	["nvim-insx"]       = { id = "hrsh7th/nvim-insx",         expander = gh, lazy = false }, -- needs nix
	["which-key"]       = { id = "folke/which-key.nvim",      expander = gh, lazy = false },
	------ alignment / indentation
	["indentmini"]      = { id = "nvimdev/indentmini.nvim",   expander = gh, lazy = false }, -- needs nix
	["indent-blankline"] = { id = "lukas-reineke/indent-blankline.nvim", expander = gh, lazy = false }, -- needs nix
	["nvim-anydent"]    = { id = "hrsh7th/nvim-anydent",      expander = gh, lazy = false }, -- needs nix
	["mini.align"]      = { id = "nvim-mini/mini.align",      expander = gh, lazy = false }, -- needs nix
	["tabular"]         = { id = "godlygeek/tabular",         expander = gh, lazy = false }, --  -- needs nix; https://devhints.io/tabular
	------ textobjects
	["nvim-treesitter-textobjects"] = {
		id = "nvim-treesitter/nvim-treesitter-textobjects",
		expander = gh,
		lazy = false,
		name = "nvim-treesitter-textobjects",
	},
	["nvim-various-textobjs"] = { id = "chrisgrieser/nvim-various-textobjs", expander = gh, lazy = false }, -- needs nix
	------ comments
	["Comment"]         = { id = "numToStr/Comment.nvim",     expander = gh, lazy = false }, -- needs nix
	["todo-comments"]   = { id = "folke/todo-comments.nvim",  expander = gh, lazy = false },
	["vim-commentary"]  = { id = "tpope/vim-commentary",      expander = gh, lazy = false }, -- needs nix
	------ split / join
	["treesj"]          = { id = "Wansmer/treesj",            expander = gh, lazy = false }, -- needs nix
	------ value manipulation
	["dial"]            = { id = "monaqa/dial.nvim",          expander = gh, lazy = false },
	------ marks
	["harpoon-core"]    = { id = "MeanderingProgrammer/harpoon-core.nvim", expander = gh, lazy = false }, -- needs nix
	["marks"]           = { id = "chentoast/marks.nvim",      expander = gh, lazy = false },
	["markit"]          = { id = "2KAbhishek/markit.nvim",    expander = gh, lazy = false }, -- needs nix
	------ yank/paste & clipboard
	["nvim-pasta"]      = { id = "hrsh7th/nvim-pasta",        expander = gh, lazy = false }, -- needs nix
	------ miscellaneous
	["beam"]            = { id = "Piotr1215/beam.nvim",       expander = gh, lazy = false }, -- needs nix
	------ sort

	-- LAYER 2: LSP, autocompletion, snippets =========================================================================================== 2
	------ snippets, autocomplete
	["blink.cmp"]       = { id = "Saghen/blink.cmp",          expander = gh, lazy = false },
	["nvim-cmp"]        = { id = "hrsh7th/nvim-cmp",          expander = gh, lazy = false }, -- needs nix
	------ snippets (as main focus)
	["friendly-snippets"] = { id = "rafamadriz/friendly-snippets", expander = gh, lazy = false },
	["ultisnips"]       = { id = "SirVer/ultisnips",          expander = gh, lazy = false }, -- needs nix; https://ejmastnak.com/tutorials/vim-latex/ultisnips/
	["LuaSnip"]         = { id = "L3MON4D3/LuaSnip",          expander = gh, lazy = false },
	------ completion sources
	["cmp-nvim-lsp"]    = { id = "hrsh7th/cmp-nvim-lsp",      expander = gh, lazy = false }, -- needs nix
	["cmp-buffer"]      = { id = "hrsh7th/cmp-buffer",        expander = gh, lazy = false }, -- needs nix
	["cmp-path"]        = { id = "hrsh7th/cmp-path",          expander = gh, lazy = false }, -- needs nix
	["cmp-cmdline"]     = { id = "hrsh7th/cmp-cmdline",       expander = gh, lazy = false }, -- needs nix
	------ LSP general (configure ruff, pyright, lua-language-server, haskell-language-server, rust-analyzer with built-in client)
	["lsp-format"]      = { id = "lukas-reineke/lsp-format.nvim", expander = gh, lazy = false }, -- needs nix
	["lspkind"]         = { id = "onsails/lspkind.nvim",      expander = gh, lazy = false }, -- needs nix
	------ LSP UI
	-- see also fidget.nvim
	["lspsaga"]         = { id = "nvimdev/lspsaga.nvim",      expander = gh, lazy = false }, -- needs nix
	------ language-specific
	["lazydev"]         = { id = "folke/lazydev.nvim",        expander = gh, lazy = false }, -- needs nix
	["rustaceanvim"]    = { id = "mrcjkb/rustaceanvim",       expander = gh, lazy = false }, -- already lazy
	["crates"]          = { id = "saecki/crates.nvim",        expander = gh, lazy = false }, -- needs nix
	["haskell-tools"]   = { id = "mrcjkb/haskell-tools.nvim", expander = gh, lazy = false }, -- already lazy
	------ LSP-adjacent
	["none-ls"]         = { id = "nvimtools/none-ls.nvim",    expander = gh, lazy = false }, -- needs nix

	-- LAYER 3: formatting & linting ==================================================================================================== 3
	["guard"]           = { id = "nvimdev/guard.nvim",        expander = gh, lazy = false }, -- needs nix
	["conform"]         = { id = "stevearc/conform.nvim",     expander = gh, lazy = false }, -- ruff, rustfmt, stylua, fourmolu

	-- LAYER 4: testing, debugging/quickfix, execution ================================================================================== 4
	["asyncrun"]        = { id = "skywind3000/asyncrun.vim",  expander = gh, lazy = false }, -- needs nix
	["neotest-haskell"] = { id = "MrcJkb/neotest-haskell",    expander = gh, lazy = false }, -- TODO
	["neotest-python"]  = { id = "nvim-neotest/neotest-python", expander = gh, lazy = false },
	["neotest"]         = { id = "nvim-neotest/neotest",      expander = gh, lazy = false },
	["dap-python"]      = { id = "mfussenegger/nvim-dap-python", expander = cb, lazy = false }, -- needs nix; pipx install debugpy
	["dap-ui"]          = { id = "rcarriga/nvim-dap-ui",      expander = gh, lazy = false }, -- needs nix
	["nvim-dap-virtual-text"] = { id = "theHamsta/nvim-dap-virtual-text", expander = cb, lazy = false }, -- needs nix
	["dap"]             = { id = "mfussenegger/nvim-dap",     expander = cb, lazy = false }, -- needs nix
	["mypy"]            = { id = "feakuru/mypy.nvim",         expander = gh, lazy = false }, -- needs nix
	["nvim-lint"]       = { id = "mfussenegger/nvim-lint",    expander = gh, lazy = false }, -- needs nix
	------ DAP/quickix UI
	["trouble.nvim"]    = { id = "folke/trouble.nvim",        expander = gh, lazy = false }, -- needs nix
	["quicker"]         = { id = "stevearc/quicker.nvim",     expander = gh, lazy = false }, -- needs nix
	["nvim-bqf"]        = { id = "kevinhwang91/nvim-bqf",     expander = gh, lazy = false },
	------ terminal
	["vim-floaterm"]    = { id = "voldikss/vim-floaterm",     expander = gh, lazy = false },
	["toggleterm"]      = { id = "akinsho/toggleterm.nvim",   expander = gh, lazy = false },
	------ code/task runners
	["overseer"]        = { id = "stevearc/overseer.nvim",    expander = gh, lazy = false }, -- needs nix

	-- LAYER 5: refactoring & code intelligence ========================================================================================= 5
	["refactoring"]     = { id = "ThePrimeagen/refactoring.nvim", expander = gh, lazy = false }, -- needs nix
	------ project management
	["project"]         = { id = "ahmedkhalf/project.nvim",   expander = gh, lazy = false }, -- needs nix
	["telescope-project"] = { id = "nvim-telescope/telescope-project.nvim", expander = gh, lazy = false }, -- needs nix

	-- LAYER 6: version control & collaboration ========================================================================================= 6
	["jj"]              = { id = "NicolasGB/jj.nvim",         expander = gh, lazy = false }, -- needs nix
	["jujutsu"]         = { id = "yannvanhalewyn/jujutsu.nvim", expander = gh, lazy = false }, -- needs nix
	["lazygit"]         = { id = "kdheepak/lazygit.nvim",     expander = gh, lazy = false }, -- needs nix
	["git-conflict"]    = { id = "akinsho/git-conflict.nvim", expander = gh, lazy = false }, -- needs nix
	["neogit"]          = { id = "NeogitOrg/neogit",          expander = gh, lazy = false }, -- needs nix
	["jiejie"]          = { id = "jceb/jiejie.nvim",          expander = gh, lazy = false }, -- needs nix
	["diffview"]        = { id = "sindrets/diffview.nvim",    expander = gh, lazy = false },
	["gitsigns"]        = { id = "lewis6991/gitsigns.nvim",   expander = gh, lazy = false },
	["vim-fugitive"]    = { id = "tpope/vim-fugitive",        expander = gh, lazy = false }, -- needs nix
	-- git forges
	["octo"]            = { id = "pwntester/octo.nvim",       expander = gh, lazy = false }, -- needs nix
	["gitlab-nvim"]     = { id = "harrisoncramer/gitlab.nvim", expander = gh, lazy = false }, -- needs nix
	["gitlab"]          = { id = "gitlab-org/editor-extensions/gitlab.vim", expander = gh, lazy = false }, -- needs nix

	-- LAYER 7: UI polish & productivity ================================================================================================ 7
	["dashboard-nvim"]  = { id = "nvimdev/dashboard-nvim",    expander = gh, lazy = false }, -- needs nix
	["dashboard"]       = { id = "MeanderingProgrammer/dashboard.nvim", expander = gh, lazy = false }, -- needs nix
	["noice"]           = { id = "folke/noice.nvim",          expander = gh, lazy = false }, -- needs nix
	["modes"]           = { id = "mvllow/modes.nvim",         expander = gh, lazy = false }, -- needs nix
	------ UI (important for LSP)
	["fidget"]          = { id = "j-hui/fidget.nvim",         expander = gh, lazy = false }, -- needs nix
	["nvim-notify"]     = { id = "rcarriga/nvim-notify",      expander = gh, lazy = false }, -- needs nix; see also mini.notify
	["headlines"]       = { id = "lukas-reineke/headlines.nvim", expander = gh, lazy = false }, -- needs nix
	------ session management
	["auto-session"]    = { id = "rmagatti/auto-session",     expander = gh, lazy = false }, -- needs nix
	["persistence"]     = { id = "folke/persistence.nvim",    expander = gh, lazy = false }, -- needs nix

	-- LAYER 8: miscellaneous/advanced =========================================================================================================== 8
	["vimtex"]          = { id = "lervag/vimtex",             expander = gh, lazy = false }, -- needs nix; use vim.cmd.source or vim.fn.runtime
	["texmagic"]        = { id = "jakewvincent/texmagic.nvim", expander = gh, lazy = false }, -- needs nix
	["schemastore"]     = { id = "b0o/SchemaStore.nvim",      expander = gh, lazy = false }, -- needs nix
	["firenvim"]        = { id = "glacambre/firenvim",        expander = gh, lazy = false }, -- needs nix
	["render-markdown"] = { id = "MeanderingProgrammer/render-markdown.nvim", expander = gh, lazy = false }, -- needs nix
	["jupytext"]        = { id = "GCBallesteros/jupytext.nvim", expander = gh, lazy = false }, -- needs nix
	["quarto"]          = { id = "quarto-dev/quarto-nvim",    expander = gh, lazy = false }, -- needs nix
	["markdown-preview"] = { id = "iamcco/markdown-preview.nvim", expander = gh, lazy = false }, -- needs nix
	------ Lua / self-referential
	["structlog"]       = { id = "Tastyep/structlog.nvim",    expander = gh, lazy = false }, -- needs nix
	["neorepl"]         = { id = "ii14/neorepl.nvim",         expander = gh, lazy = false }, -- needs nix
}

local add_plugin = function(name)
	-- print(name)
	-- print(vim.inspect(PLUGIN_DECLARATION[name]))
	local expander  = PLUGIN_DECLARATION[name].expander
	-- print(expander)
	local url = expander(PLUGIN_DECLARATION[name].id)
	-- print(url)
	vim.pack.add({ { src = url } })
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

-- ============================================================================================================================================================
-- LAYER 0: foundation, colors, search, core navigation ===============================================================================
------ core dependencies
if contains(PLUGINS, "plenary") then
	print("TODO")
end
if contains(PLUGINS, "nvim-nio") then
	print("TODO")
end
if contains(PLUGINS, "nvim-web-devicons") then
	print("TODO")
	require("nvim-web-devicons").setup()
end
------ core setup and UI
if contains(PLUGINS, "bamboo") then
	print("Setting up bamboo")
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
if contains(PLUGINS, "zen-mode") then
	print("TODO")
	require("zen-mode").setup()
end
if contains(PLUGINS, "lualine") then
	print("TODO")
	require("lualine").setup()
end
if contains(PLUGINS, "nvim-navic") then
	print("TODO")
	require("nvim-navic").setup()
end
if contains(PLUGINS, "bufferline") then
	print("TODO")
	require("bufferline").setup()
end
if contains(PLUGINS, "statuscol") then
	print("TODO")
	require("statuscol").setup()
end
if contains(PLUGINS, "nvim-treesitter") then
	print("Setting up treesitter.")
	local my_install_dir = (not HAS_NIX) and vim.fn.stdpath("data") .. "/site" or nil
	local my_parser_install_dir = (not HAS_NIX) and vim.fn.stdpath("data") .. "/parsers" or nil
	local my_ensure_installed = HAS_NIX and {} or TS_LANGUAGES
	-- vim.fn.mkdir(my_parser_install_dir, "p")
	-- IMPORTANT: Neovim expects parsers to be in a 'parser' subfolder of an RTP entry
	-- vim.opt.runtimepath:append(my_parser_install_dir)
	print(my_install_dir)
	print(my_parser_install_dir)
	print(vim.inspect(my_ensure_installed))
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
		install_dir    = my_install_dir,
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
if contains(PLUGINS, "treesitter-modules") then
	print("TODO")
	require("treesitter-modules").setup()
end
if contains(PLUGINS, "dropbar") then
	print("TODO")
	require("dropbar").setup()
end
if contains(PLUGINS, "nvim-navbuddy") then
	print("TODO")
	-- require("nui").setup()
	require("nvim-navbuddy").setup()
end
if contains(PLUGINS, "aerial") then
	print("aerial")
end
------ file explorer (as central focus)
if contains(PLUGINS, "oil") then
	print("TODO")
	require("oil").setup()
end
if contains(PLUGINS, "yazi") then
	print("yazi")
	require("yazi").setup()
end
if contains(PLUGINS, "neo-tree") then
	print("TODO")
	require("neo-tree").setup({})
end
if contains(PLUGINS, "nvim-tree") then
	print("TODO")
	require("nvim-tree").setup()
end
------ picker / search
if contains(PLUGINS, "pickme") then
	print("TODO")
end
if contains(PLUGINS, "telescope") then
	print("TODO")
end
if contains(PLUGINS, "telescope-fzf-native") then
	print("TODO")
end
if contains(PLUGINS, "fzf-lua") then
	print("TODO")
end
if contains(PLUGINS, "nvim-deck") then
	print("TODO")
end
------ suites
if contains(PLUGINS, "mini") then
	print("TODO")
end
if contains(PLUGINS, "snacks") then
	print("TODO")
end
if contains(PLUGINS, "blink") then
	print("TODO")
end
------ search
if contains(PLUGINS, "nvim-hlslens") then
	print("TODO")
end
if contains(PLUGINS, "hlsearch") then
	print("TODO")
end
------ find-and-replace
if contains(PLUGINS, "grug-far") then
	print("TODO")
end
if contains(PLUGINS, "nvim-spectre") then
	print("TODO")
end
------ layout & buffer/tab navigation
if contains(PLUGINS, "flybuf") then
	print("TODO")
end
if contains(PLUGINS, "stickybuf") then
	print("TODO")
end
if contains(PLUGINS, "swm") then
	print("TODO")
end
------ wezterm integration
if contains(PLUGINS, "smart-splits") then
	print("TODO")
end

-- LAYER 1: editing enhancements ==================================================================================================== 1
------ folds
if contains(PLUGINS, "nvim-ufo") then
	print("TODO")
end
------ multi-cursor
if contains(PLUGINS, "vim-visual-multi") then
	print("TODO")
end
------ motion
if contains(PLUGINS, "leap") then
	print("TODO")
end
if contains(PLUGINS, "flash") then
	print("TODO")
end
if contains(PLUGINS, "hop") then
	print("TODO")
end
------ pairs
if contains(PLUGINS, "rainbow-delimiters") then
	print("TODO")
end
if contains(PLUGINS, "nvim-autopairs") then
	print("TODO")
end
if contains(PLUGINS, "blink.pairs") then
	print("TODO")
end
if contains(PLUGINS, "vim-sandwich") then
	print("TODO")
end
if contains(PLUGINS, "nvim-surround") then
	print("TODO")
end
------ undo
if contains(PLUGINS, "vim-mundo") then
	print("TODO")
end
------ keymapping-related
if contains(PLUGINS, "hydra") then
	print("TODO")
end
if contains(PLUGINS, "nvim-insx") then
	print("TODO")
end
if contains(PLUGINS, "which-key") then
	print("TODO")
end
------ alignment / indentation
if contains(PLUGINS, "indentmini") then
	print("TODO")
end
if contains(PLUGINS, "indent-blankline") then
	print("TODO")
end
if contains(PLUGINS, "nvim-anydent") then
	print("TODO")
end
if contains(PLUGINS, "mini.align") then
	print("TODO")
end
if contains(PLUGINS, "tabular") then
	print("TODO")
end
------ textobjects
if contains(PLUGINS, "nvim-treesitter-textobjects") then
	print("TODO")
end
if contains(PLUGINS, "nvim-various-textobjs") then
	print("TODO")
end
------ comments
if contains(PLUGINS, "Comment") then
	print("TODO")
end
if contains(PLUGINS, "todo-comments") then
	print("TODO")
end
if contains(PLUGINS, "vim-commentary") then
	print("TODO")
end
------ split / join
if contains(PLUGINS, "treesj") then
	print("TODO")
end
------ value manipulation
if contains(PLUGINS, "dial") then
	print("TODO")
end
------ marks
if contains(PLUGINS, "harpoon-core") then
	print("TODO")
end
if contains(PLUGINS, "marks") then
	print("TODO")
end
if contains(PLUGINS, "markit") then
	print("TODO")
end
------ yank/paste & clipboard
if contains(PLUGINS, "nvim-pasta") then
	print("TODO")
end
------ miscellaneous
if contains(PLUGINS, "beam") then
	print("TODO")
end
------ sort

-- LAYER 2: LSP, autocompletion, snippets =========================================================================================== 2
------ snippets, autocomplete
if contains(PLUGINS, "blink.cmp") then
	print("TODO")
end
if contains(PLUGINS, "nvim-cmp") then
	print("TODO")
end
------ snippets (as main focus)
if contains(PLUGINS, "friendly-snippets") then
	print("TODO")
end
if contains(PLUGINS, "ultisnips") then
	print("TODO")
end
if contains(PLUGINS, "LuaSnip") then
	print("TODO")
end
------ completion sources
if contains(PLUGINS, "cmp-nvim-lsp") then
	print("TODO")
end
if contains(PLUGINS, "cmp-buffer") then
	print("TODO")
end
if contains(PLUGINS, "cmp-path") then
	print("TODO")
end
if contains(PLUGINS, "cmp-cmdline") then
	print("TODO")
end
------ LSP general (configure ruff, pyright, lua-language-server, haskell-language-server, rust-analyzer with built-in client)
if contains(PLUGINS, "lsp-format") then
	print("TODO")
end
if contains(PLUGINS, "lspkind") then
	print("TODO")
end
------ LSP UI
-- see also fidget.nvim
if contains(PLUGINS, "lspsaga") then
	print("TODO")
end
------ language-specific
if contains(PLUGINS, "lazydev") then
	print("TODO")
end
if contains(PLUGINS, "rustaceanvim") then
	print("TODO")
end
if contains(PLUGINS, "crates") then
	print("TODO")
end
if contains(PLUGINS, "haskell-tools") then
	print("TODO")
end
------ LSP-adjacent
if contains(PLUGINS, "none-ls") then
	print("TODO")
end

-- LAYER 3: formatting & linting ==================================================================================================== 3
if contains(PLUGINS, "guard") then
	print("TODO")
end
if contains(PLUGINS, "conform") then
	print("TODO")
end

-- LAYER 4: testing, debugging/quickfix, execution ================================================================================== 4
if contains(PLUGINS, "asyncrun") then
	print("TODO")
end
if contains(PLUGINS, "neotest-haskell") then
	print("TODO")
end
if contains(PLUGINS, "neotest-python") then
	print("TODO")
end
if contains(PLUGINS, "neotest") then
	print("TODO")
end
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
if contains(PLUGINS, "dap-ui") then
	print("TODO")
end
if contains(PLUGINS, "nvim-dap-virtual-text") then
	print("TODO")
end
if contains(PLUGINS, "dap") then
	print("TODO")
end
if contains(PLUGINS, "mypy") then
	print("TODO")
end
if contains(PLUGINS, "nvim-lint") then
	print("TODO")
end
------ DAP/quickix UI
if contains(PLUGINS, "trouble.nvim") then
	print("TODO")
end
if contains(PLUGINS, "quicker") then
	print("TODO")
end
if contains(PLUGINS, "nvim-bqf") then
	print("TODO")
end
------ terminal
if contains(PLUGINS, "vim-floaterm") then
	print("TODO")
end
if contains(PLUGINS, "toggleterm") then
	print("TODO")
end
------ code/task runners
if contains(PLUGINS, "overseer") then
	print("TODO")
end

-- LAYER 5: refactoring & code intelligence ========================================================================================= 5
if contains(PLUGINS, "refactoring") then
	print("TODO")
end
------ project management
if contains(PLUGINS, "project") then
	print("TODO")
end
if contains(PLUGINS, "telescope-project") then
	print("TODO")
end

-- LAYER 6: version control & collaboration ========================================================================================= 6
if contains(PLUGINS, "jj") then
	print("TODO")
end
if contains(PLUGINS, "jujutsu") then
	print("TODO")
end
if contains(PLUGINS, "lazygit") then
	print("TODO")
end
if contains(PLUGINS, "git-conflict") then
	print("TODO")
end
if contains(PLUGINS, "neogit") then
	print("TODO")
end
if contains(PLUGINS, "jiejie") then
	print("TODO")
end
if contains(PLUGINS, "diffview") then
	print("TODO")
end
if contains(PLUGINS, "gitsigns") then
	print("TODO")
end
if contains(PLUGINS, "vim-fugitive") then
	print("TODO")
end
-- git forges
if contains(PLUGINS, "octo") then
	print("TODO")
end
if contains(PLUGINS, "gitlab-nvim") then
	print("TODO")
end
if contains(PLUGINS, "gitlab") then
	print("TODO")
end

-- LAYER 7: UI polish & productivity ================================================================================================ 7
if contains(PLUGINS, "dashboard-nvim") then
	print("TODO")
end
if contains(PLUGINS, "dashboard") then
	print("TODO")
end
if contains(PLUGINS, "noice") then
	print("TODO")
end
if contains(PLUGINS, "modes") then
	print("TODO")
end
------ UI (important for LSP)
if contains(PLUGINS, "fidget") then
	print("TODO")
end
if contains(PLUGINS, "nvim-notify") then
	print("TODO")
end
if contains(PLUGINS, "headlines") then
	print("TODO")
end
------ session management
if contains(PLUGINS, "auto-session") then
	print("TODO")
end
if contains(PLUGINS, "persistence") then
	print("TODO")
end

-- LAYER 8: miscellaneous/advanced =========================================================================================================== 8
if contains(PLUGINS, "vimtex") then
	vim.g.vimtex_view_method = "zathura"
end
if contains(PLUGINS, "texmagic") then
	print("TODO")
end
if contains(PLUGINS, "schemastore") then
	print("TODO")
end
if contains(PLUGINS, "firenvim") then
	print("TODO")
end
if contains(PLUGINS, "render-markdown") then
	print("TODO")
end
if contains(PLUGINS, "jupytext") then
	print("TODO")
end
if contains(PLUGINS, "quarto") then
	print("TODO")
end
if contains(PLUGINS, "markdown-preview") then
	print("TODO")
end
------ Lua / self-referential
if contains(PLUGINS, "structlog") then
	print("TODO")
end
if contains(PLUGINS, "neorepl") then
	print("TODO")
end
-- ============================================================================================================================================================

if WEZTERM then
	-- https://github.com/ianhomer/wezterm.nvim/blob/main/lua/wezterm.lua --------------------------------------------------
	local wez = {}

	local directions = {
		h = "Left",
		l = "Right",
		j = "Down",
		k = "Up",
	}

	local arrows    = {
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
		local at_edge   = current_window == vim.fn.win_getid()
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
		local command   = vim.deepcopy(cmd)
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
