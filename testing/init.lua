local FOCUS = "bamboo"

local PLUGIN_DECLARATION = {
	["bamboo"] = { id = "ribru17/bamboo.nvim", expander = gh, lazy = false },
	["blink.cmp"] = { id = "Saghen/blink.cmp", expander = gh, lazy = false },
	["conform"] = { id = "stevearc/conform.nvim", expander = gh, lazy = false },
	["dial"] = { id = "monaqa/dial.nvim", expander = gh, lazy = false },
	["diffview"] = { id = "sindrets/diffview.nvim", expander = gh, lazy = false },
	["friendly-snippets"] = { id = "rafamadriz/friendly-snippets", expander = gh, lazy = false },
	["gitsigns"] = { id = "lewis6991/gitsigns.nvim", expander = gh, lazy = false },
	["haskell-tools"] = { id = "mrcjkb/haskell-tools.nvim", expander = gh, lazy = false }, -- already lazy
	["lualine"] = { id = "nvim-lualine/lualine.nvim", expander = gh, lazy = false },
	["LuaSnip"] = { id = "L3MON4D3/LuaSnip", expander = gh, lazy = false },
	["marks"] = { id = "chentoast/marks.nvim", expander = gh, lazy = false },
	["mini"] = { id = "nvim-mini/mini.nvim", expander = gh, lazy = false },
	["neotest-haskell"] = { id = "MrcJkb/neotest-haskell", expander = gh, lazy = false }, -- TODO
	["neotest-python"] = { id = "nvim-neotest/neotest-python", expander = gh, lazy = false },
	["neotest"] = { id = "nvim-neotest/neotest", expander = gh, lazy = false },
	["nvim-bqf"] = { id = "kevinhwang91/nvim-bqf", expander = gh, lazy = false },
	["nvim-nio"] = { id = "nvim-neotest/nvim-nio", expander = gh, lazy = false },
	["nvim-treesitter-textobjects"] = {
		id = "nvim-treesitter/nvim-treesitter-textobjects",
		expander = gh,
		lazy = false,
		name = "nvim-treesitter-textobjects",
	},
	["nvim-treesitter"] = { id = "nvim-treesitter/nvim-treesitter", expander = gh, lazy = false },
	["oil"] = { id = "stevearc/oil.nvim", expander = gh, lazy = false },
	["pickme"] = { id = "2KAbhishek/pickme.nvim", expander = gh, lazy = false },
	["plenary"] = { id = "nvim-lua/plenary.nvim", expander = gh, lazy = false },
	["rustaceanvim"] = { id = "mrcjkb/rustaceanvim", expander = gh, lazy = false }, -- already lazy
	["snacks"] = { id = "folke/snacks.nvim", expander = gh, lazy = false },
	["telescope-fzf-native"] = { id = "nvim-telescope/telescope-fzf-native.nvim", expander = gh, lazy = false },
	["telescope"] = { id = "nvim-telescope/telescope.nvim", expander = gh, lazy = false },
	["todo-comments"] = { id = "folke/todo-comments.nvim", expander = gh, lazy = false },
	["toggleterm"] = { id = "akinsho/toggleterm.nvim", expander = gh, lazy = false },
	["vim-floaterm"] = { id = "voldikss/vim-floaterm", expander = gh, lazy = false },
	["vim-visual-multi"] = { id = "mg979/vim-visual-multi", expander = gh, lazy = false },
	["which-key"] = { id = "folke/which-key.nvim", expander = gh, lazy = false },
	["yazi"] = { id = "mikavilpas/yazi.nvim", expander = gh, lazy = false },
	["zen-mode"] = { id = "folke/zen-mode.nvim", expander = gh, lazy = false },
	-- needs nix below here
	[""] = { id = "", expander = gh, lazy = false },
	["asyncrun"] = { id = "", expander = gh, lazy = false },
	["bufferline"] = { id = "", expander = gh, lazy = false },
	["dashboard"] = { id = "", expander = gh, lazy = false },
	["fidget"] = { id = "", expander = gh, lazy = false },
	["firenvim"] = { id = "", expander = gh, lazy = false },
	["flash"] = { id = "", expander = gh, lazy = false },
	["flybuf"] = { id = "", expander = gh, lazy = false },
	["grug-far"] = { id = "", expander = gh, lazy = false },
	["guard"] = { id = "", expander = gh, lazy = false },
	["hlsearch"] = { id = "", expander = gh, lazy = false },
	["hop"] = { id = "", expander = gh, lazy = false },
	["indent-blanklines"] = { id = "", expander = gh, lazy = false },
	["indentmini"] = { id = "", expander = gh, lazy = false },
	["lazydev"] = { id = "", expander = gh, lazy = false },
	["lazygit"] = { id = "", expander = gh, lazy = false },
	["lspsaga"] = { id = "", expander = gh, lazy = false },
	["modes"] = { id = "", expander = gh, lazy = false },
	["neo-tree"] = { id = "", expander = gh, lazy = false },
	["neogit"] = { id = "", expander = gh, lazy = false },
	["neorepl"] = { id = "", expander = gh, lazy = false },
	["none-ls"] = { id = "", expander = gh, lazy = false },
	["nvim-autopairs"] = { id = "", expander = gh, lazy = false },
	["nvim-cmp"] = { id = "", expander = gh, lazy = false },
	["nvim-dap-python"] = { id = "mfussenegger/nvim-dap-python", expander = cb, lazy = false },
	["nvim-dap-ui"] = { id = "", expander = gh, lazy = false },
	["nvim-dap"] = { id = "", expander = gh, lazy = false },
	["nvim-hlslens"] = { id = "", expander = gh, lazy = false },
	["nvim-navic"] = { id = "", expander = gh, lazy = false },
	["nvim-notify"] = { id = "", expander = gh, lazy = false },
	["nvim-tree"] = { id = "", expander = gh, lazy = false },
	["nvim-ufo"] = { id = "", expander = gh, lazy = false },
	["render-markdown"] = { id = "", expander = gh, lazy = false },
	["schemastore"] = { id = "", expander = gh, lazy = false },
	["statuscol"] = { id = "", expander = gh, lazy = false },
	["structlog"] = { id = "", expander = gh, lazy = false },
	["Ultisnips"] = { id = "", expander = gh, lazy = false },
	["vim-commentary"] = { id = "", expander = gh, lazy = false },
	["vim-fugitive"] = { id = "", expander = gh, lazy = false },
	["vim-mundo"] = { id = "", expander = gh, lazy = false },
	["vim-sandwich"] = { id = "", expander = gh, lazy = false },
	["vimtex"] = { id = "", expander = gh, lazy = false },
}

if FOCUS == "bamboo" then
	print("TODO")
end
if FOCUS == "blink.cmp" then
	print("TODO")
end
if FOCUS == "conform" then
	print("TODO")
end
if FOCUS == "dial" then
	print("TODO")
end
if FOCUS == "diffview" then
	print("TODO")
end
if FOCUS == "friendly-snippets" then
	print("TODO")
end
if FOCUS == "gitsigns" then
	print("TODO")
end
if FOCUS == "haskell-tools" then
	print("TODO")
end
if FOCUS == "lualine" then
	print("TODO")
end
if FOCUS == "LuaSnip" then
	print("TODO")
end
if FOCUS == "marks" then
	print("TODO")
end
if FOCUS == "mini" then
	print("TODO")
end
if FOCUS == "neotest-haskell" then
	print("TODO")
end
if FOCUS == "neotest-python" then
	print("TODO")
end
if FOCUS == "neotest" then
	print("TODO")
end
if FOCUS == "nvim-bqf" then
	print("TODO")
end
if FOCUS == "nvim-nio" then
	print("TODO")
end
if FOCUS == "nvim-treesitter-textobjects" then
	print("TODO")
end
if FOCUS == "nvim-treesitter" then
	print("TODO")
end
if FOCUS == "oil" then
	print("TODO")
end
if FOCUS == "pickme" then
	print("TODO")
end
if FOCUS == "plenary" then
	print("TODO")
end
if FOCUS == "rustaceanvim" then
	print("TODO")
end
if FOCUS == "snacks" then
	print("TODO")
end
if FOCUS == "telescope-fzf-native" then
	print("TODO")
end
if FOCUS == "telescope" then
	print("TODO")
end
if FOCUS == "todo-comments" then
	print("TODO")
end
if FOCUS == "toggleterm" then
	print("TODO")
end
if FOCUS == "vim-floaterm" then
	print("TODO")
end
if FOCUS == "vim-visual-multi" then
	print("TODO")
end
if FOCUS == "which-key" then
	print("TODO")
end
if FOCUS == "yazi" then
	print("TODO")
end
if FOCUS == "zen-mode" then
	print("TODO")
end
-- needs nix below here
if FOCUS == "asyncrun" then
	print("TODO")
end
if FOCUS == "bufferline" then
	print("TODO")
end
if FOCUS == "dashboard" then
	print("TODO")
end
if FOCUS == "fidget" then
	print("TODO")
end
if FOCUS == "firenvim" then
	print("TODO")
end
if FOCUS == "flash" then
	print("TODO")
end
if FOCUS == "flybuf" then
	print("TODO")
end
if FOCUS == "grug-far" then
	print("TODO")
end
if FOCUS == "guard" then
	print("TODO")
end
if FOCUS == "hlsearch" then
	print("TODO")
end
if FOCUS == "hop" then
	print("TODO")
end
if FOCUS == "indent-blanklines" then
	print("TODO")
end
if FOCUS == "indentmini" then
	print("TODO")
end
if FOCUS == "lazydev" then
	print("TODO")
end
if FOCUS == "lazygit" then
	print("TODO")
end
if FOCUS == "lspsaga" then
	print("TODO")
end
if FOCUS == "modes" then
	print("TODO")
end
if FOCUS == "neo-tree" then
	print("TODO")
end
if FOCUS == "neogit" then
	print("TODO")
end
if FOCUS == "neorepl" then
	print("TODO")
end
if FOCUS == "none-ls" then
	print("TODO")
end
if FOCUS == "nvim-autopairs" then
	print("TODO")
end
if FOCUS == "nvim-cmp" then
	print("TODO")
end
if FOCUS == "nvim-dap-python" then
	print("TODO")
end
if FOCUS == "nvim-dap-ui" then
	print("TODO")
end
if FOCUS == "nvim-dap" then
	print("TODO")
end
if FOCUS == "nvim-hlslens" then
	print("TODO")
end
if FOCUS == "nvim-navic" then
	print("TODO")
end
if FOCUS == "nvim-notify" then
	print("TODO")
end
if FOCUS == "nvim-tree" then
	print("TODO")
end
if FOCUS == "nvim-ufo" then
	print("TODO")
end
if FOCUS == "render-markdown" then
	print("TODO")
end
if FOCUS == "schemastore" then
	print("TODO")
end
if FOCUS == "statuscol" then
	print("TODO")
end
if FOCUS == "structlog" then
	print("TODO")
end
if FOCUS == "Ultisnips" then
	print("TODO")
end
if FOCUS == "vim-commentary" then
	print("TODO")
end
if FOCUS == "vim-fugitive" then
	print("TODO")
end
if FOCUS == "vim-mundo" then
	print("TODO")
end
if FOCUS == "vim-sandwich" then
	print("TODO")
end
if FOCUS == "vimtex" then
	print("TODO")
end

-- for k, v in pairs(PLUGIN_DECLARATION) do
--     print(k)
-- end
