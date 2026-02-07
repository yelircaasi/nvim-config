local o = vim.opt
local g = vim.g
local map = vim.keymap.set

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

map('n', '<leader>o', ':update<CR> :source<CR>')
map('n', '<leader>ww', ':write<CR>')
map('n', '<leader>qq', ':quit<CR>')
map('n', '<leader>wq', ':wq<CR>')
map('n', '<leader>f', ":Pick files<CR>")
-- map('t', '^[', "^\^N")
map('t', '<Esc>', [[<C-\><C-n>]], { desc = "Exit terminal mode" })
map('t', 'kj', [[<C-\><C-n>]], { desc = "Exit terminal mode" })
-- map('t', '^O', '^\^O')
map('t', '<C-o>', [[<C-\><C-o>]], { desc = "Temporary normal mode" })
map('n', '<leader>lf', vim.lsp.buf.format)
map('n', '<leader>h', ":Pick help")
map('n', '<leader>e', ":Oil<CR>")
map({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
map({ 'n', 'v', 'x' }, '<leader>d', '+d<CR>')



--------------------

local NVIM_DIR = vim.fn.expand("~/.config/nvim")

local gh = function(id) return "https://github.com/" .. id end
local gl = function(id) return "https://gitlab.com/" .. id end
local cb = function(id) return "https://codeberg.org/" .. id end

local plugin_ids_eager = {}
local plugin_ids_lazy = {}

local plugin_ids_eager = {
	{ "stevearc/oil.nvim", gh },
    { "Saghen/blink.cmp", gh },
    { "nvim-mini/mini.pick", gh },
    { "L3MON4D3/LuaSnip", gh },
    { "mrcjkb/rustaceanvim", gh },
    { "nvim-treesitter/nvim-treesitter", gh },
    { "mrcjkb/haskell-tools.nvim", gh },
    { "ribru17/bamboo.nvim", gh },

	-- "folke/zen-mode.nvim",
	-- "nvim-lualine/lualine.nvim",
	-- "monaqa/dial.nvim",
	-- "mikavilpas/yazi.nvim",
    -- "stevearc/conform.nvim",
	-- "akinsho/toggleterm.nvim",
	-- "voldikss/vim-floaterm",
	-- "folke/which-key.nvim",
	-- "kevinhwang91/nvim-bqf",
	-- "echasnovski/mini.nvim",
	-- "lewis6991/gitsigns.nvim",
	-- "folke/todo-comments.nvim",
	-- "nvim-telescope/telescope.nvim",
	-- "nvim-lua/plenary.nvim", -- dependency of telescope
	-- "sindrets/diffview.nvim",
	-- "2kabhishek/markit.nvim",
	-- "2KAbhishek/pickme.nvim",
	-- "nvim-treesitter/nvim-treesitter-textobjects",
	-- "nvim-neotest/neotest",
	-- "mg979/vim-visual-multi",
	-- "willothy/wezterm.nvim" -> just vendor
}

-- local DEFAULT_SPECS = vim.iter(plugin_ids):map(function(id) return id, { src = gh(id) } end):totable()
local make_default_specs = function(plugin_ids)
	local default_specs = {}
	for _, info in ipairs(plugin_ids) do
		local id, expander = unpack(info)
		default_specs[id] = { src = expander(id) }
	end
	return default_specs
end

DEFAULT_SPECS = make_default_specs(plugin_ids_eager)
print(DEFAULT_SPECS)

local nix_specs_eager = {}
local nix_specs_lazy = {}
local native_specs_eager = {}
local native_specs_lazy = {}

local create_spec_list = function(has_nix)
    local specs = {}
    if has_nix then
        local plugin_locations = dofile(NVIM_DIR .. "/nix_plugins.lua")
        for id, info in pairs(DEFAULT_SPECS) do
            if plugin_locations[id] then
				-- local user, repo = string.match(id, "([^/]+)/([^/]+)")
				vim.opt.rtp:prepend(plugin_locations[id].path)
            else
                print("Plugin " .. id .. " not installed via Nix!")
                table.insert(specs, { src = DEFAULT_SPECS[id].src })
            end
        end
    else
        for id, info in pairs(DEFAULT_SPECS) do
            table.insert(specs, { src = info.src })
        end
    end
    return specs
end

--------------

local has_nix = vim.uv.fs_stat("/nix/store") ~= nil
local specs = create_spec_list(has_nix)
vim.pack.add(specs)

require('nvim-treesitter.configs').setup({
    ensure_installed = has_nix and {} or { "lua", "python", "rust", "typescript", "haskell" },
    highlight = { enable = true },
    parser_install_dir = not has_nix and vim.fn.stdpath("data") .. "/parsers" or nil,
})

--------------



vim.keymap.set('n', '<leader>lu', function()
    -- Create a new empty floating window or split
    vim.cmd('vsplit | enew')
    vim.bo.filetype = 'lua'
    vim.bo.bufhidden = 'hide'
    
    -- Map <CR> to execute the current line or selection
    vim.keymap.set('n', '<CR>', ':.lua<CR>', { buffer = true })
    vim.keymap.set('v', '<CR>', ':lua<CR>', { buffer = true })
end, { desc = "Open Lua Scratchpad" })


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
    "zig"
}
require('nvim-treesitter').setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/site',
  ensure_installed = ts_languages,
  highlight = { enable = true },
  indent = { enable = true },
}
-- require('nvim-treesitter').install({ "typescript", "javascript", "python", "rust", "haskell", "zig" }):wait(300000) -- wait max. 5 minutes
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
				workspace = { library = vim.api.nvim_get_runtime_file("", true), }
			}
		}
	}
)
vim.lsp.config("ruff", {}) -- TODO
vim.lsp.config("tinymist", {}) -- TODO
vim.lsp.config("rust-analyzer", {}) -- TODO
vim.lsp.config("haskell-ls", {}) -- TODO

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd('set completeopt+=noselect')

-- vim.pack.add({ { src = "https://github.com/ii14/neorepl.nvim" } })

