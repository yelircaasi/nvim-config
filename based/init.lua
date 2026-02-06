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

vim.pack.add({
	{ src = "https://github.com/vague2k/vague.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-mini/mini.pick" },
	-- { src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	-- { src = "https://github.com/folke/lazydev.nvim" },
})

require("vague").setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=#081608")
-- vim.cmd()
-- require("lazydev").setup({})
require("mini.pick").setup()
require("oil").setup()

-- require('nvim-treesitter')
-- require('nvim-treesitter.install').prefer_git = true
local ts_languages = { "typescript", "javascript", "python", "rust", "haskell", "zig" }
require('nvim-treesitter').setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/site',
  ensure_installed = ts_languages,
  highlight = { enable = true },
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

vim.pack.add({ { src = "https://github.com/ii14/neorepl.nvim" } })

