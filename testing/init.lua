vim.g.loaded_matchparen = 1
vim.g.loaded_matchit = 1
vim.g.loaded_netrw = 1

WEZTERM = true
local LAYERS = {
	-- -1,
	0,
	1,
	-- 2,
	-- 3,
	-- 4,
	-- 5,
	-- 6,
	-- 7,
	-- 8,
}
local PLUGINS_BY_LAYER = {
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

local PLUGINS_INCLUDED = {}
for _, layer in ipairs(LAYERS) do
		local layer_table = PLUGINS_BY_LAYER[layer]
		print("--- layer " .. layer .. ": " .. #layer_table .. " plugins")
	
		for __, name in ipairs(layer_table) do
			table.insert(PLUGINS_INCLUDED, name)
		end
	end
-- print(vim.inspect(PLUGINS_INCLUDED))

function is_included(plugin_name)
	return vim.tbl_contains(PLUGINS_INCLUDED, plugin_name)
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

-- printb(vim.inspect(PLUGINS_INCLUDED))
printb(#PLUGINS_INCLUDED .. " plugins included")

--======================================================================================================================

PLUGINS_TABLE = dofile(vim.fn.expand("~/repos/nvim-config/testing/plugin_paths.lua"))

local function safe_prepend(path)
    local expanded_path = vim.fn.expand(path)
    if not vim.tbl_contains(vim.opt.runtimepath:get(), expanded_path) then
        vim.opt.runtimepath:prepend(expanded_path)
    end
end

dependencies = {
	["yazi"] = {"plenary",},
	["nvim-navbuddy"] = {"nui",},
}

function packadd(plugin_name) -- TODO
	local path = PLUGINS_TABLE[name]
	safe_prepend(path)
	vim.cmd("packadd " .. plugin_name)
end

function get_plugin(name)
	local path = PLUGINS_TABLE[name]
	-- print(path)
	local deps = dependencies[name]
    safe_prepend(path)
	if deps then
		for _, dep_name in ipairs(deps) do
			local dep_path = PLUGINS_TABLE[dep_name]
			-- print(dep_path)
			safe_prepend(dep_path)
		end
	end
	local required = require(name)
	return required
end

-- function configure_plugin(name, config)
-- 	return get_plugin(name).setup(config)
-- end

-- function custom_setup(name, setup_func)
-- 	return setup_func(get_plugin(name))
-- end

-- get_plugin("lualine").setup({})
-- configure_plugin("lualine", {})
-- configure_plugin("yazi", {})

local function safe_call(func, arg, err_msg)
	local result, return_value = pcall(func, arg)
	if not result then
		printb(err_msg)
		return false, nil
	else
		return true, return_value
	end
end


local function setup_plugin_(plugin_name, config_or_function)
	if not is_included(plugin_name) then
		-- print(plugin_name .. " not contained.")
		return
	end
	plugin = get_plugin(plugin_name)
    if not config_or_function then return end
    if type(config_or_function) == "table" then
		local config = config_or_function
		plugin.setup(config)
		return
	end	
	if type(config_or_function) == "function" then
		custom_setup_function = config_or_function
		custom_setup_function(plugin)
		return
	end
	error("'config_or_function' must be nil, table, or function; found " .. type(config_or_function)) 
end


local function setup_plugin_safe(plugin_name, config_or_function)
	if not is_included(plugin_name) then
		-- print(plugin_name .. " not contained.")
		return
	end
	local result, plugin = pcall(get_plugin, plugin_name)
	if not result then
		print("ERROR: plugin require unsuccessful: " .. plugin_name)
		return
	end
    if not config_or_function then return end
    if type(config_or_function) == "table" then
		local config = config_or_function
		safe_call(plugin.setup, config, "ERROR: configuring" .. plugin_name)
		return
	end	
	if type(config_or_function) == "function" then
		custom_setup_function = config_or_function
		safe_call(custom_setup_function, plugin, "ERROR: custom setup function failed for " .. plugin_name)
		return
	end
	printb("ERROR: 'config_or_function' must be nil, table, or function; found " .. type(config_or_function)) 
end

local setup_plugin = setup_plugin_safe

setup_plugin("lualine", {})
setup_plugin("yazi", {})


local function print_status(length, prefix, name, suffix)
	local pad = string.rep(" ", length - string.len(name))
	print(prefix .. " " .. name .. pad .. " " .. suffix)
end


function OLD_attempt(plugin_name, opts)
	if not is_included(plugin_name) then
		print(plugin_name .. " not contained.")
		return
	end
	local result, plugin = pcall(get_plugin, plugin_name)
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
setup_plugin("plenary")
setup_plugin("nio")

setup_plugin("nvim-web-devicons")
------ core setup and UI
setup_plugin("bamboo", function(bamboo)
	printb("Setting up bamboo")
	bamboo.setup({
		style = "multiplex",
		colors = {
			bg0 = "#020802",
		},
		-- highlights   = { Normal = { bg = "#020802" } },
	})
	bamboo.load()
	-- require("vague").setup({ transparent = true })
	-- vim.cmd("colorscheme bamboo")
	-- vim.cmd(":hi statusline guibg=#081608")
end)
setup_plugin("zen-mode")
setup_plugin("lualine")
setup_plugin("nvim-navic")
setup_plugin("bufferline")
setup_plugin("statuscol")
setup_plugin("nvim-treesitter", function(treesitter)
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
	print("Treesitter exists -------------------")
	treesitter.setup({
		-- directory to install parsers and queries to (prepended to `runtimepath` to have priority)
		install_dir = my_install_dir,
		parser_install_dir = my_parser_install_dir,
		ensure_installed = my_ensure_installed,
		highlight = { enable = true },
		indent = { enable = true },
	})
end)
setup_plugin("treesitter-modules")
setup_plugin("dropbar")
setup_plugin("nvim-navbuddy")
setup_plugin("aerial")
------ file explorer (as central focus)
setup_plugin("oil")
setup_plugin("yazi")
setup_plugin("neo-tree")
setup_plugin("nvim-tree")
------ picker / search
setup_plugin("pickme")
setup_plugin("telescope")
setup_plugin("telescope-fzf-native")
setup_plugin("fzf-lua")
setup_plugin("deck")
------ suites
setup_plugin("mini")
setup_plugin("snacks")
setup_plugin("blink")
------ search
setup_plugin("hlslens")
setup_plugin("hlsearch")
------ find-and-replace
setup_plugin("grug-far")
setup_plugin("spectre")
------ layout & buffer/tab navigation
setup_plugin("flybuf")
setup_plugin("stickybuf")
setup_plugin("swm", function(swm)
	vim.keymap.set("n", "<C-w>h", swm.h)
	vim.keymap.set("n", "<C-w>j", swm.j)
	vim.keymap.set("n", "<C-w>k", swm.k)
	vim.keymap.set("n", "<C-w>l", swm.l)
end)
------ wezterm integration
setup_plugin("smart-splits")

-- LAYER 1: editing enhancements ======================================================================================= 1
------ folds
setup_plugin("ufo")
------ macros
setup_plugin("NeoComposer")
setup_plugin("nvim-macros", {
	json_file_path = "./macros.json",
	default_macro_register = "a",
	json_formatter = "jq",
})
setup_plugin("recorder")

------ multi-cursor
setup_plugin("vim-visual-multi")
------ motion
setup_plugin("leap")
setup_plugin("flash")
setup_plugin("hop")
------ pairs

setup_plugin("rainbow-delimiters")
setup_plugin("nvim-autopairs")
--TODO setup_plugin("blink.pairs")
packadd("vim-sandwich")
-- setup_plugin("vim-sandwich")
setup_plugin("nvim-surround")
------ undo
packadd("vim-mundo")
------ keymapping-related
setup_plugin("mini.keymap")
setup_plugin("hydra")
setup_plugin("insx")
setup_plugin("which-key")
------ alignment / indentation
setup_plugin("indentmini")
setup_plugin("indent-blankline")
setup_plugin("nvim-anydent")
setup_plugin("mini.align")
setup_plugin("tabular")
------ textobjects
setup_plugin("nvim-treesitter-textobjects")
setup_plugin("nvim-various-textobjs")
------ comments
setup_plugin("Comment")
setup_plugin("todo-comments")
setup_plugin("vim-commentary")
------ split / join
setup_plugin("treesj")
------ value manipulation
setup_plugin("dial")
------ marks
setup_plugin("harpoon-core")
setup_plugin("marks")
setup_plugin("markit")
------ yank/paste & clipboard
setup_plugin("nvim-pasta")
------ miscellaneous
setup_plugin("beam")
------ sort

-- LAYER 2: LSP, autocompletion, snippets =========================================================================================== 2
------ snippets, autocomplete
setup_plugin("blink.cmp")
setup_plugin("nvim-cmp")
------ snippets (as main focus)
setup_plugin("friendly-snippets")
setup_plugin("ultisnips")
setup_plugin("LuaSnip")
------ completion sources
setup_plugin("cmp-nvim-lsp")
setup_plugin("cmp-buffer")
setup_plugin("cmp-path")
setup_plugin("cmp-cmdline")
------ LSP general (configure ruff, pyright, lua-language-server, haskell-language-server, rust-analyzer with built-in client)
setup_plugin("lsp-format")
setup_plugin("lspkind")
------ LSP UI
-- see also fidget.nvim
setup_plugin("lspsaga")
------ language-specific
setup_plugin("lazydev")
setup_plugin("rustaceanvim")
setup_plugin("crates")
setup_plugin("haskell-tools")
------ LSP-adjacent
setup_plugin("none-ls")

-- LAYER 3: formatting & linting ==================================================================================================== 3
setup_plugin("guard")
setup_plugin("conform")

-- LAYER 4: testing, debugging/quickfix, execution ================================================================================== 4
setup_plugin("asyncrun")
setup_plugin("neotest-haskell")
setup_plugin("neotest-python")
setup_plugin("neotest")
setup_plugin("dap-python", function()
	local dap_python = get_plugin("dap-python")
	dap_python.setup("debugpy-adapter")
	dap_python.test_runner = "pytest"
	vim.keymap.set("n", "<leader>tt", function()
		print("Leader is working!")
	end)
	vim.keymap.set("n", "<leader>pp", function()
		print("This works")
	end)
	vim.keymap.set("n", "<leader>dn", function()
		get_plugin("dap-python").test_method()
	end)
	vim.keymap.set("n", "<leader>df", function()
		get_plugin("dap-python").test_class()
	end)
	vim.keymap.set("v", "<leader>ds", function()
		get_plugin("dap-python").debug_selection()
	end)
end)
setup_plugin("dapui")
setup_plugin("nvim-dap-virtual-text")
setup_plugin("dap")
setup_plugin("mypy")
setup_plugin("nvim-lint")
------ DAP/quickix UI
setup_plugin("trouble.nvim")
setup_plugin("quicker")
setup_plugin("nvim-bqf")
------ terminal
setup_plugin("vim-floaterm")
setup_plugin("toggleterm")
------ code/task runners
setup_plugin("overseer")

-- LAYER 5: refactoring & code intelligence ========================================================================================= 5
setup_plugin("refactoring")
------ project management
setup_plugin("project")
setup_plugin("telescope-project")

-- LAYER 6: version control & collaboration ========================================================================================= 6
setup_plugin("jj")
setup_plugin("jujutsu")
setup_plugin("lazygit")
setup_plugin("git-conflict")
setup_plugin("neogit")
setup_plugin("jiejie")
setup_plugin("diffview")
setup_plugin("gitsigns")
setup_plugin("vim-fugitive")
-- git forges
setup_plugin("octo")
setup_plugin("gitlab-nvim")
setup_plugin("gitlab")

-- LAYER 7: UI polish & productivity ================================================================================================ 7
setup_plugin("dashboard-nvim")
setup_plugin("dashboard")
setup_plugin("noice")
setup_plugin("modes")
------ UI (important for LSP)
setup_plugin("fidget")
setup_plugin("nvim-notify")
setup_plugin("headlines")
------ session management
setup_plugin("auto-session")
setup_plugin("persistence")

-- LAYER 8: miscellaneous/advanced =========================================================================================================== 8
if is_included("vimtex") then
	vim.g.vimtex_view_method = "zathura"
end
setup_plugin("texmagic")
setup_plugin("schemastore")
setup_plugin("firenvim")
setup_plugin("render-markdown")
setup_plugin("jupytext")
setup_plugin("quarto")
setup_plugin("markdown-preview")
------ Lua / self-referential
setup_plugin("structlog")
setup_plugin("neorepl")
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

