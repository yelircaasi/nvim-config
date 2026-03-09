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
print(vim.inspect(PLUGINS_INCLUDED))

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


printb(vim.inspect(PLUGINS_INCLUDED))
printb(#PLUGINS_INCLUDED)



-- function contains(table, element)
-- 	for _, value in pairs(table) do
-- 		if value == element then
-- 			return true
-- 		end
-- 	end
-- 	return false
-- end
--======================================================================================================================

local plugins_file = vim.fn.expand("~/repos/nvim-config/testing/plugin_paths.lua") --"~/.config/nvim/plugin_paths.lua")
PLUGINS_TABLE = dofile(plugins_file)
-- print(vim.inspect(PLUGINS_TABLE))

local function safe_prepend(path)
    local expanded_path = vim.fn.expand(path)
    -- Use vim.tbl_contains for a much shorter check
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
			print(dep_path)
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
-- configure_plugin("lualine", {})
-- configure_plugin("yazi", {})


function setup_plugin(plugin_name, config_or_function)
	if not is_included(plugin_name) then
		print(plugin_name .. " not contained.")
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


setup_plugin("lualine", {})
setup_plugin("yazi", {})


local function print_status(length, prefix, name, suffix)
	local pad = string.rep(" ", length - string.len(name))
	print(prefix .. " " .. name .. pad .. " " .. suffix)
end


function _attempt(plugin_name, opts)
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
		-- print_status(30, "CONFIGURING:", plugin_name, "[SUCCESS]")
	else
		print_status(30, "CONFIGURING:", plugin_name, "[ERROR] ===================================")
	end
end


attempt = setup_plugin
-- custom_setup("lualine", function(plugin) plugin.setup({}) end)
--======================================================================================================================


--======================================================================================================================
-- LAYER 0: foundation, colors, search, core navigation ================================================================
--======================================================================================================================

------ core dependencies
attempt("plenary")
attempt("nio")

attempt("nvim-web-devicons")
------ core setup and UI
if is_included("bamboo") then
	printb("Setting up bamboo")
	local bamboo = get_plugin("bamboo")
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
end
attempt("zen-mode")
attempt("lualine")
attempt("nvim-navic")
attempt("bufferline")
attempt("statuscol")
if is_included("nvim-treesitter") then
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
	-- local treesitter = get_plugin("nvim-treesitter")
	local treesitter = get_plugin("nvim-treesitter")
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
	-- local treesitter = get_plugin("nvim-treesitter")
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
if is_included("aerial") then
	plugin_name = "aerial"
	get_plugin("aerial")
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
if is_included("telescope-fzf-native") then
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
if is_included("swm") then
	plugin_name = "swm"
	local swm = get_plugin(plugin_name)
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
-- if is_included("ufo") then
-- 	plugin_name = "ufo"
-- 	-- require(plugin_name).setup()
-- 	print_error(plugin_name)
-- end

------ macros
attempt("NeoComposer")
if is_included("nvim-macros") then
	plugin_name = "nvim-macros"
	get_plugin(plugin_name).setup({
		-- json_file_path = "./macros.json",
		-- default_macro_register = "a",
		-- json_formatter = "jq",
	})
	print_status(30, "CONFIGURING:", plugin_name, "[SUCCESS]")
end
attempt("recorder")

------ multi-cursor
if is_included("vim-visual-multi") then
	plugin_name = "vim-visual-multi"
	-- require(plugin_name).setup()
	print_status(30, "IMPORTING:  ", plugin_name, "[ERROR]")
end
------ motion
attempt("leap")
attempt("flash")
attempt("hop")
------ pairs
if is_included("rainbow-delimiters") then
	-- plugin_name = "rainbow-delimiters"
	-- require(plugin_name).setup()
	-- print_todo(plugin_name)
	attempt("rainbow-delimiters")
end
attempt("nvim-autopairs")
--TODO attempt("blink.pairs")
packadd("vim-sandwich")
-- attempt("vim-sandwich")
attempt("nvim-surround")
------ undo
packadd("vim-mundo")
------ keymapping-related
attempt("mini.keymap")
attempt("hydra")
attempt("insx")
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
if is_included("dap-python") then
	print("dap-python")
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
if is_included("vimtex") then
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

