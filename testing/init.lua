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






local PLUGINS = {
	"bamboo",
    -- "vimtex",
	-- "neotest",
	-- "neotest-python",
    "dap", -- debugpy
	"dap-python",
    -- "nvim-treesitter", -- brew install tree-sitter
}

-- function addRelPath(dir)
-- 	local spath = debug.getinfo(1, "S").source:sub(2):gsub("^([^/])", "./%1"):gsub("[^/]*$", "")
-- 	dir = dir and (dir .. "/") or ""
-- 	spath = spath .. dir
-- 	package.path = spath .. "?.lua;" .. spath .. "?/init.lua"
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

local gh = function(id) return "https://github.com/" .. id end
local gl = function(id) return "https://gitlab.com/" .. id end
local cb = function(id) return "https://codeberg.org/" .. id end

local PLUGIN_DECLARATION = {
	["bamboo"] =            { id = "ribru17/bamboo.nvim",          expander = gh, lazy = false },
	["blink.cmp"] =         { id = "Saghen/blink.cmp",             expander = gh, lazy = false },
	["conform"] =           { id = "stevearc/conform.nvim",        expander = gh, lazy = false },
	["dial"] =              { id = "monaqa/dial.nvim",             expander = gh, lazy = false },
	["diffview"] =          { id = "sindrets/diffview.nvim",       expander = gh, lazy = false },
	["friendly-snippets"] = { id = "rafamadriz/friendly-snippets", expander = gh, lazy = false },
	["gitsigns"] =          { id = "lewis6991/gitsigns.nvim",      expander = gh, lazy = false },
	["haskell-tools"] =     { id = "mrcjkb/haskell-tools.nvim",    expander = gh, lazy = false }, -- already lazy
	["lualine"] =           { id = "nvim-lualine/lualine.nvim",    expander = gh, lazy = false },
	["LuaSnip"] =           { id = "L3MON4D3/LuaSnip",             expander = gh, lazy = false },
	["marks"] =             { id = "chentoast/marks.nvim",         expander = gh, lazy = false },
	["mini"] =              { id = "nvim-mini/mini.nvim",          expander = gh, lazy = false },
	["neotest-haskell"] =   { id = "MrcJkb/neotest-haskell",       expander = gh, lazy = false }, -- TODO
	["neotest-python"] =    { id = "nvim-neotest/neotest-python",  expander = gh, lazy = false },
	["neotest"] =           { id = "nvim-neotest/neotest",         expander = gh, lazy = false },
	["nvim-bqf"] =          { id = "kevinhwang91/nvim-bqf",        expander = gh, lazy = false },
	["nvim-nio"] =          { id = "nvim-neotest/nvim-nio",        expander = gh, lazy = false },
	["nvim-treesitter-textobjects"] = {
		id = "nvim-treesitter/nvim-treesitter-textobjects",
		expander = gh,
		lazy = false,
		name = "nvim-treesitter-textobjects",
	},
	["nvim-treesitter"] =      { id = "nvim-treesitter/nvim-treesitter",          expander = gh, lazy = false }, -- brew install tree-sitter; brew install tree-sitter-cli
	["oil"] =                  { id = "stevearc/oil.nvim",                        expander = gh, lazy = false },
	["pickme"] =               { id = "2KAbhishek/pickme.nvim",                   expander = gh, lazy = false },
	["plenary"] =              { id = "nvim-lua/plenary.nvim",                    expander = gh, lazy = false },
	["rustaceanvim"] =         { id = "mrcjkb/rustaceanvim",                      expander = gh, lazy = false }, -- already lazy
	["snacks"] =               { id = "folke/snacks.nvim",                        expander = gh, lazy = false },
	["telescope-fzf-native"] = { id = "nvim-telescope/telescope-fzf-native.nvim", expander = gh, lazy = false },
	["telescope"] =            { id = "nvim-telescope/telescope.nvim",            expander = gh, lazy = false },
	["todo-comments"] =        { id = "folke/todo-comments.nvim",                 expander = gh, lazy = false },
	["toggleterm"] =           { id = "akinsho/toggleterm.nvim",                  expander = gh, lazy = false },
	["vim-floaterm"] =         { id = "voldikss/vim-floaterm",                    expander = gh, lazy = false },
	["vim-visual-multi"] =     { id = "mg979/vim-visual-multi",                   expander = gh, lazy = false },
	["which-key"] =            { id = "folke/which-key.nvim",                     expander = gh, lazy = false },
	["yazi"] =                 { id = "mikavilpas/yazi.nvim",                     expander = gh, lazy = false },
	["zen-mode"] =             { id = "folke/zen-mode.nvim",                      expander = gh, lazy = false },

	-- needs nix below here = { id = "stevearc/overseer.nvim", expander = gh, lazy = false },

	["aerial"] =             { id = "stevearc/aerial.nvim",                         expander = gh, lazy = false },
	["asyncrun"] =           { id = "skywind3000/asyncrun.vim",                     expander = gh, lazy = false },
	["blink.pairs"] =        { id = "saghen/blink.pairs",                           expander = gh, lazy = false },
	["blink"] =              { id = "saghen/blink.nvim",                            expander = gh, lazy = false },
	["bufferline"] =         { id = "akinsho/bufferline.nvim",                      expander = gh, lazy = false },
	["Comment"] =            { id = "numToStr/Comment.nvim",                        expander = gh, lazy = false },
	["dashboard-nvim"] =     { id = "nvimdev/dashboard-nvim",                       expander = gh, lazy = false },
	["dashboard"] =          { id = "MeanderingProgrammer/dashboard.nvim",          expander = gh, lazy = false },
	["fidget"] =             { id = "j-hui/fidget.nvim",                            expander = gh, lazy = false },
	["firenvim"] =           { id = "glacambre/firenvim",                           expander = gh, lazy = false },
	["flash"] =              { id = "folke/flash.nvim",                             expander = gh, lazy = false },
	["flybuf"] =             { id = "nvimdev/flybuf.nvim",                          expander = gh, lazy = false },
	["git-conflict"] =       { id = "akinsho/git-conflict.nvim",                    expander = gh, lazy = false },
	["grug-far"] =           { id = "MagicDuck/grug-far.nvim",                      expander = gh, lazy = false },
	["guard"] =              { id = "nvimdev/guard.nvim",                           expander = gh, lazy = false },
	["harpoon-core"] =       { id = "MeanderingProgrammer/harpoon-core.nvim",       expander = gh, lazy = false },
	["hlsearch"] =           { id = "nvimdev/hlsearch.nvim",                        expander = gh, lazy = false },
	["hop"] =                { id = "smoka7/hop.nvim",                              expander = gh, lazy = false },
	["hydra"] =              { id = "nvimtools/hydra.nvim",                         expander = gh, lazy = false },
	["indent-blankline"] =   { id = "lukas-reineke/indent-blankline.nvim",          expander = gh, lazy = false },
	["indentmini"] =         { id = "nvimdev/indentmini.nvim",                      expander = gh, lazy = false },
	["jiejie"] =             { id = "jceb/jiejie.nvim",                             expander = gh, lazy = false },
	["jj"] =                 { id = "NicolasGB/jj.nvim",                            expander = gh, lazy = false },
	["jujutsu"] =            { id = "yannvanhalewyn/jujutsu.nvim",                  expander = gh, lazy = false },
	["lazydev"] =            { id = "folke/lazydev.nvim",                           expander = gh, lazy = false },
	["lazygit"] =            { id = "kdheepak/lazygit.nvim",                        expander = gh, lazy = false },
	["lsp-format"] =         { id = "lukas-reineke/lsp-format.nvim",                expander = gh, lazy = false },
	["lspsaga"] =            { id = "nvimdev/lspsaga.nvim",                         expander = gh, lazy = false },
	["mini.align"] =         { id = "nvim-mini/mini.align",                         expander = gh, lazy = false },
	["modes"] =              { id = "mvllow/modes.nvim",                            expander = gh, lazy = false },
	["neo-tree"] =           { id = "nvim-neo-tree/neo-tree.nvim",                  expander = gh, lazy = false },
	["neogit"] =             { id = "NeogitOrg/neogit",                             expander = gh, lazy = false },
	["neorepl"] =            { id = "ii14/neorepl.nvim",                            expander = gh, lazy = false },
	["noice"] =              { id = "folke/noice.nvim",                             expander = gh, lazy = false },
	["none-ls"] =            { id = "nvimtools/none-ls.nvim",                       expander = gh, lazy = false },
	["nvim-anydent"] =       { id = "hrsh7th/nvim-anydent",                         expander = gh, lazy = false },
	["nvim-autopairs"] =     { id = "windwp/nvim-autopairs",                        expander = gh, lazy = false },
	["nvim-cmp"] =           { id = "hrsh7th/nvim-cmp",                             expander = gh, lazy = false },
	["dap-python"] =         { id = "mfussenegger/nvim-dap-python",                 expander = cb, lazy = false }, -- pipx install debugpy
	["dap-ui"] =             { id = "rcarriga/nvim-dap-ui",                         expander = gh, lazy = false },
	["dap"] =                { id = "mfussenegger/nvim-dap",                        expander = cb, lazy = false },
	["nvim-deck"] =          { id = "hrsh7th/nvim-deck",                            expander = gh, lazy = false },
	["nvim-hlslens"] =       { id = "kevinhwang91/nvim-hlslens",                    expander = gh, lazy = false },
	["nvim-ix"] =            { id = "hrsh7th/nvim-ix",                              expander = gh, lazy = false },
	["nvim-lint"] =          { id = "mfussenegger/nvim-lint",                       expander = gh, lazy = false },
	["nvim-navic"] =         { id = "SmiteshP/nvim-navic",                          expander = gh, lazy = false },
	["nvim-notify"] =        { id = "rcarriga/nvim-notify",                         expander = gh, lazy = false },
	["nvim-pasta"] =         { id = "hrsh7th/nvim-pasta",                           expander = gh, lazy = false },
	["nvim-tree"] =          { id = "nvim-tree/nvim-tree.lua",                      expander = gh, lazy = false },
	["nvim-ufo"] =           { id = "kevinhwang91/nvim-ufo",                        expander = gh, lazy = false },
	["overseer"] =           { id = "stevearc/overseer.nvim",                       expander = gh, lazy = false },
	["quicker"] =            { id = "stevearc/quicker.nvim",                        expander = gh, lazy = false },
	["render-markdown"] =    { id = "MeanderingProgrammer/render-markdown.nvim",    expander = gh, lazy = false },
	["schemastore"] =        { id = "b0o/SchemaStore.nvim",                         expander = gh, lazy = false },
	["statuscol"] =          { id = "luukvbaal/statuscol.nvim",                     expander = gh, lazy = false },
	["stickybuf"] =          { id = "stevearc/stickybuf.nvim",                      expander = gh, lazy = false },
	["structlog"] =          { id = "Tastyep/structlog.nvim",                       expander = gh, lazy = false },
	["swm"] =                { id = "hrsh7th/nvim-swm",                             expander = gh, lazy = false },
	["tabular"] =            { id = "godlygeek/tabular",                            expander = gh, lazy = false }, -- https://devhints.io/tabular
	["texmagic"] = { id = "jakewvincent/texmagic.nvim", expander = gh, lazy = false },
	["treesitter-modules"] = { id = "MeanderingProgrammer/treesitter-modules.nvim", expander = gh, lazy = false },
	["ultisnips"] =          { id = "SirVer/ultisnips",                             expander = gh, lazy = false }, -- https://ejmastnak.com/tutorials/vim-latex/ultisnips/
	["vim-commentary"] =     { id = "tpope/vim-commentary",                         expander = gh, lazy = false },
	["vim-fugitive"] =       { id = "tpope/vim-fugitive",                           expander = gh, lazy = false },
	["vim-mundo"] =          { id = "simnalamburt/vim-mundo",                       expander = gh, lazy = false },
	["vim-sandwich"] =       { id = "machakann/vim-sandwich",                       expander = gh, lazy = false },
	["vimtex"] =             { id = "lervag/vimtex",                                expander = gh, lazy = false }, -- use vim.cmd.source or vim.fn.runtime
}


local add_plugin = function(name)
	print(name)
	-- print(vim.inspect(PLUGIN_DECLARATION[name]))
	local expander = PLUGIN_DECLARATION[name].expander
	-- print(expander)
	local url = expander(PLUGIN_DECLARATION[name].id)
	print(url)
	vim.pack.add({ { src = url }, })
end

for _, name in ipairs(PLUGINS) do
	add_plugin(name)
end
print(PLUGINS["bamboo"])

function contains(table, element)
	for _, value in pairs(table) do
	  if value == element then
		return true
	  end
	end
	return false
  end



if contains(PLUGINS, "bamboo") then
	print("Setting up bamboo")
	require("bamboo").setup({
		style = "multiplex",
		colors = {
			bg0 = "#020802",
		},
		-- highlights = { Normal = { bg = "#020802" } },
	})
	require("bamboo").load()
	-- require("vague").setup({ transparent = true })
	-- vim.cmd("colorscheme bamboo")
	-- vim.cmd(":hi statusline guibg=#081608")
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
    for k, v in pairs(treesitter) do print(k)
		print(v) end
	print("Treesitter exists -------------------")
	local treesitter_config = require("nvim-treesitter.configs")
	for k, v in pairs(treesitter_config) do print(k)
		print(v) end
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
if contains(PLUGINS, "dap-python") then
	
	print("dap-python")
	local dap_python = require("dap-python")
	dap_python.setup("debugpy-adapter")
	dap_python.test_runner = 'pytest'
	vim.keymap.set("n", "<leader>tt", function() print("Leader is working!") end)
	vim.keymap.set("n", "<leader>pp", function() print("This works") end)
	vim.keymap.set("n", "<leader>dn", function() require('dap-python').test_method() end)
	vim.keymap.set("n", "<leader>df", function() require('dap-python').test_class() end)
	vim.keymap.set("v", "<leader>ds", function() require('dap-python').debug_selection() end)
end
-- -----------------------------------------
if contains(PLUGINS, "blink.cmp") then
	print("TODO")
end
if contains(PLUGINS, "conform") then
	print("TODO")
end
if contains(PLUGINS, "dial") then
	print("TODO")
end
if contains(PLUGINS, "diffview") then
	print("TODO")
end
if contains(PLUGINS, "friendly-snippets") then
	print("TODO")
end
if contains(PLUGINS, "gitsigns") then
	print("TODO")
end
if contains(PLUGINS, "haskell-tools") then
	print("TODO")
end
if contains(PLUGINS, "lualine") then
	print("TODO")
end
if contains(PLUGINS, "LuaSnip") then
	print("TODO")
end
if contains(PLUGINS, "marks") then
	print("TODO")
end
if contains(PLUGINS, "mini") then
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
if contains(PLUGINS, "nvim-bqf") then
	print("TODO")
end
if contains(PLUGINS, "nvim-nio") then
	print("TODO")
end
if contains(PLUGINS, "nvim-treesitter-textobjects") then
	print("TODO")
end
if contains(PLUGINS, "oil") then
	print("TODO")
end
if contains(PLUGINS, "pickme") then
	print("TODO")
end
if contains(PLUGINS, "plenary") then
	print("TODO")
end
if contains(PLUGINS, "rustaceanvim") then
	print("TODO")
end
if contains(PLUGINS, "snacks") then
	print("TODO")
end
if contains(PLUGINS, "telescope-fzf-native") then
	print("TODO")
end
if contains(PLUGINS, "telescope") then
	print("TODO")
end
if contains(PLUGINS, "todo-comments") then
	print("TODO")
end
if contains(PLUGINS, "toggleterm") then
	print("TODO")
end
if contains(PLUGINS, "vim-floaterm") then
	print("TODO")
end
if contains(PLUGINS, "vim-visual-multi") then
	print("TODO")
end
if contains(PLUGINS, "which-key") then
	print("TODO")
end
if contains(PLUGINS, "yazi") then
	print("TODO")
end
if contains(PLUGINS, "zen-mode") then
	print("TODO")
end

-- needs nix below here

if contains(PLUGINS, "aerial") then
	print("TODO")
end
if contains(PLUGINS, "asyncrun") then
	print("TODO")
end
if contains(PLUGINS, "blink.pairs") then
	print("TODO")
end
if contains(PLUGINS, "blink") then
	print("TODO")
end
if contains(PLUGINS, "bufferline") then
	print("TODO")
end
if contains(PLUGINS, "Comment") then
	print("TODO")
end
if contains(PLUGINS, "dashboard-nvim") then
	print("TODO")
end
if contains(PLUGINS, "dashboard") then
	print("TODO")
end
if contains(PLUGINS, "fidget") then
	print("TODO")
end
if contains(PLUGINS, "firenvim") then
	print("TODO")
end
if contains(PLUGINS, "flash") then
	print("TODO")
end
if contains(PLUGINS, "flybuf") then
	print("TODO")
end
if contains(PLUGINS, "git-conflict") then
	print("TODO")
end
if contains(PLUGINS, "grug-far") then
	print("TODO")
end
if contains(PLUGINS, "guard") then
	print("TODO")
end
if contains(PLUGINS, "harpoon-core") then
	print("TODO")
end
if contains(PLUGINS, "hlsearch") then
	print("TODO")
end
if contains(PLUGINS, "hop") then
	print("TODO")
end
if contains(PLUGINS, "hydra") then
	print("TODO")
end
if contains(PLUGINS, "indent-blankline") then
	print("TODO")
end
if contains(PLUGINS, "indentmini") then
	print("TODO")
end
if contains(PLUGINS, "jiejie") then
	print("TODO")
end
if contains(PLUGINS, "jj") then
	print("TODO")
end
if contains(PLUGINS, "jujutsu") then
	print("TODO")
end
if contains(PLUGINS, "lazydev") then
	print("TODO")
end
if contains(PLUGINS, "lazygit") then
	print("TODO")
end
if contains(PLUGINS, "lsp-format") then
	print("TODO")
end
if contains(PLUGINS, "lspsaga") then
	print("TODO")
end
if contains(PLUGINS, "mini.align") then
	print("TODO")
end
if contains(PLUGINS, "modes") then
	print("TODO")
end
if contains(PLUGINS, "neo-tree") then
	print("TODO")
end
if contains(PLUGINS, "neogit") then
	print("TODO")
end
if contains(PLUGINS, "neorepl") then
	print("TODO")
end
if contains(PLUGINS, "noice") then
	print("TODO")
end
if contains(PLUGINS, "none-ls") then
	print("TODO")
end
if contains(PLUGINS, "nvim-anydent") then
	print("TODO")
end
if contains(PLUGINS, "nvim-autopairs") then
	print("TODO")
end
if contains(PLUGINS, "nvim-cmp") then
	print("TODO")
end
if contains(PLUGINS, "dap-ui") then
	print("TODO")
end
if contains(PLUGINS, "dap") then
	print("TODO")
end
if contains(PLUGINS, "nvim-deck") then
	print("TODO")
end
if contains(PLUGINS, "nvim-hlslens") then
	print("TODO")
end
if contains(PLUGINS, "nvim-ix") then
	print("TODO")
end
if contains(PLUGINS, "nvim-lint") then
	print("TODO")
end
if contains(PLUGINS, "nvim-navic") then
	print("TODO")
end
if contains(PLUGINS, "nvim-notify") then
	print("TODO")
end
if contains(PLUGINS, "nvim-pasta") then
	print("TODO")
end
if contains(PLUGINS, "nvim-tree") then
	print("TODO")
end
if contains(PLUGINS, "nvim-ufo") then
	print("TODO")
end
if contains(PLUGINS, "overseer") then
	print("TODO")
end
if contains(PLUGINS, "quicker") then
	print("TODO")
end
if contains(PLUGINS, "render-markdown") then
	print("TODO")
end
if contains(PLUGINS, "schemastore") then
	print("TODO")
end
if contains(PLUGINS, "statuscol") then
	print("TODO")
end
if contains(PLUGINS, "stickybuf") then
	print("TODO")
end
if contains(PLUGINS, "structlog") then
	print("TODO")
end
if contains(PLUGINS, "swm") then
	print("TODO")
end
if contains(PLUGINS, "tabular") then
	print("TODO")
end
if contains(PLUGINS, "treesitter-modules") then
	print("TODO")
end
if contains(PLUGINS, "ultisnips") then
	print("TODO")
end
if contains(PLUGINS, "vim-commentary") then
	print("TODO")
end
if contains(PLUGINS, "vim-fugitive") then
	print("TODO")
end
if contains(PLUGINS, "vim-mundo") then
	print("TODO")
end
if contains(PLUGINS, "vim-sandwich") then
	print("TODO")
end
if contains(PLUGINS, "vimtex") then
	vim.g.vimtex_view_method = "zathura"
end


-- for k, v in pairs(PLUGIN_DECLARATION) do
--     print(k)
-- end
