
local function unpack_keys(tbl, keys)
    local res = {}
    for i, key in ipairs(keys) do
        res[i] = tbl[key]
    end
    return unpack(res)
end

-- t = {a = 1, b = 2, c = 3}
-- a,b,c = unpack_keys(t, {"a", "b", "c"})
-- print(a)
-- print(b)
-- print(c)


local PLUGIN_DECLARATION = {
	------------------- "willothy/wezterm.nvim"> just vendor
	-- ["markit"] =  { "2KAbhishek/markit.nvim", expander = gh, lazy = false },
	["pickme"] = { id = "2KAbhishek/pickme.nvim", expander = gh, lazy = false },
	["toggleterm"] = { id = "akinsho/toggleterm.nvim", expander = gh, lazy = false },
	["marks"] = { id = "chentoast/marks.nvim", expander = gh, lazy = false },
	["snacks"] = { id = "folke/snacks.nvim", expander = gh, lazy = false },
	["todo-comments"] = { id = "folke/todo-comments.nvim", expander = gh, lazy = false },
	["which-key"] = { id = "folke/which-key.nvim", expander = gh, lazy = false },
	["zen-mode"] = { id = "folke/zen-mode.nvim", expander = gh, lazy = false },
	["nvim-bqf"] = { id = "kevinhwang91/nvim-bqf", expander = gh, lazy = false },
	["LuaSnip"] = { id = "L3MON4D3/LuaSnip", expander = gh, lazy = false },
	["gitsigns"] = { id = "lewis6991/gitsigns.nvim", expander = gh, lazy = false },
	["vim-visual-multi"] = { id = "mg979/vim-visual-multi", expander = gh, lazy = false },
	["yazi"] = { id = "mikavilpas/yazi.nvim", expander = gh, lazy = false },
	["dial"] = { id = "monaqa/dial.nvim", expander = gh, lazy = false },
	["haskell-tools"] = { id = "mrcjkb/haskell-tools.nvim", expander = gh, lazy = false }, -- already lazy
	["rustaceanvim"] = { id = "mrcjkb/rustaceanvim", expander = gh, lazy = false }, -- already lazy
	["plenary"] = { id = "nvim-lua/plenary.nvim", expander = gh, lazy = false },
	["lualine"] = { id = "nvim-lualine/lualine.nvim", expander = gh, lazy = false },
	["mini"] = { id = "nvim-mini/mini.nvim", expander = gh, lazy = false },
	["neotest"] = { id = "nvim-neotest/neotest", expander = gh, lazy = false },
	["neotest-haskell"] = { id = "MrcJkb/neotest-haskell", expander = gh, lazy = false }, -- TODO
	["neotest-python"] = { id = "nvim-neotest/neotest-python", expander = gh, lazy = false },
	["nvim-nio"] = { id = "nvim-neotest/nvim-nio", expander = gh, lazy = false },
	["telescope"] = { id = "nvim-telescope/telescope.nvim", expander = gh, lazy = false },
	["nvim-treesitter-textobjects"] = { id = "nvim-treesitter/nvim-treesitter-textobjects", expander = gh, lazy = false, name = "nvim-treesitter-textobjects" },
	["nvim-treesitter"] = { id = "nvim-treesitter/nvim-treesitter", expander = gh, lazy = false },
	["friendly-snippets"] = { id = "rafamadriz/friendly-snippets", expander = gh, lazy = false },
	["bamboo"] = { id = "ribru17/bamboo.nvim", expander = gh, lazy = false },
	["blink.cmp"] = { id = "Saghen/blink.cmp", expander = gh, lazy = false },
	["diffview"] = { id = "sindrets/diffview.nvim", expander = gh, lazy = false },
	["conform"] = { id = "stevearc/conform.nvim", expander = gh, lazy = false },
	["oil"] = { id = "stevearc/oil.nvim", expander = gh, lazy = false },
	["vim-floaterm"] = { id = "voldikss/vim-floaterm", expander = gh, lazy = false },
	["telescope-fzf-native"] = { id = "nvim-telescope/telescope-fzf-native.nvim", expander = gh, lazy = false },
}

print(PLUGIN_DECLARATION["blink.cmp"].lazy)