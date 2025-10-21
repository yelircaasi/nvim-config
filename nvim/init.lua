-- vim.opt.rtp:prepend("/nix/store/9af9rww8nnrpfpjhz1sk8yg27q049rby-vimplugin-nvim-treesitter-2025-05-24")
-- require('nvim-treesitter')
-- require'nvim-treesitter.configs'.setup {
--    ensure_installed = { "python", "lua", "javascript" },  -- Ensure installed parsers
--    highlight = { enable = true },
--    fold = { enable = false }  -- Disable folding if necessary
--}

function addRelPath(dir)
	local spath = debug.getinfo(1, "S").source:sub(2):gsub("^([^/])", "./%1"):gsub("[^/]*$", "")
	dir = dir and (dir .. "/") or ""
	spath = spath .. dir
	package.path = spath .. "?.lua;" .. spath .. "?/init.lua"
	--  ..package.path
end

addRelPath()

require("options")
require("colors")
require("config.lazy")
require("commands")
require("mappings")

require("python")
require("lua")

vim.lsp.enable("luals")
vim.lsp.enable("ruff")
vim.lsp.enable("pyright")

vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true } })

-- ADDED: Initialize which-key
require("which-key").setup()

vim.cmd("hi link Floaterm Normal")
vim.cmd("hi link FloatermBorder Normal")
