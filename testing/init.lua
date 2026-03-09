vim.g.loaded_matchparen = 1
vim.g.loaded_matchit = 1
vim.g.loaded_netrw = 1

local prepend_safe = function(path)
    local expanded_path = vim.fn.expand(path)
    if not vim.tbl_contains(vim.opt.runtimepath:get(), expanded_path) then
        vim.opt.runtimepath:prepend(expanded_path)
    end
end

local HAS_NIX = vim.fn.isdirectory("/nix/store") ~= 0
print("HAS_NIX: " .. tostring(HAS_NIX))
local NVIM_DIR = vim.fn.expand("~/repos/nvim-config/testing") -- "~/.config/nvim")
prepend_safe(vim.fn.expand(NVIM_DIR))

local utils = require("utils").setup({
	debug = true,
	prepend_safe = prepend_safe,
	layers = {0, 1,},
	plugin_paths = dofile(NVIM_DIR .. "/meta/plugin_paths.lua"),
	dependencies = dofile(NVIM_DIR .. "/meta/dependencies.lua"),
	plugins_by_layer = dofile(NVIM_DIR .. "/meta/plugin_layers.lua"),
})
print("PLUGINS INCLUDED: " .. vim.inspect(utils.PLUGINS_INCLUDED))
utils.printb(#utils.PLUGINS_INCLUDED .. " plugins included")

vim.g.mapleader = " "
vim.g.maplocalleader = " "
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


--======================================================================================================================


local get_plugin = utils.get_plugin
local packadd = utils.packadd
local setup_plugin = utils.setup_plugin


setup_plugin("lualine", {})
setup_plugin("yazi", {})

--======================================================================================================================
-- LAYER 0: foundation, colors, search, core navigation ================================================================
--======================================================================================================================

------ core dependencies
setup_plugin("plenary")
setup_plugin("nio")

setup_plugin("nvim-web-devicons")
------ core setup and UI
setup_plugin("bamboo", function(bamboo)
	utils.printb("Setting up bamboo")
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
	utils.printb("Setting up treesitter.")
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
packadd("vimtex", function()
	vim.g.vimtex_view_method = "zathura"
end)
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

