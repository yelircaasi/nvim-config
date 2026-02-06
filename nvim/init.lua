-- im.opt.rtp:prepend("/nix/store/9af9rww8nnrpfpjhz1sk8yg27q049rby-vimplugin-nvim-treesitter-2025-05-24")
-- require('nvim-treesitter')
-- require'nvim-treesitter.configs'.setup {
--    ensure_installed = { "python", "lua", "javascript" },  -- Ensure installed parsers
--    highlight = { enable = true },
--    fold = { enable = false }  -- Disable folding if necessary
-- }

-- function addRelPath(dir)
-- 	local spath = debug.getinfo(1, "S").source:sub(2):gsub("^([^/])", "./%1"):gsub("[^/]*$", "")
-- 	print(spath)
-- 	dir = dir and (dir .. "/") or ""
-- 	spath = spath .. dir
-- 	package.path = spath .. "?.lua;" .. spath .. "?/init.lua"
-- 	--  ..package.path
-- end
--
-- addRelPath()
-- local current_dir = vim.fn.getcwd()
-- vim.cmd.cd(config_dir)

local config_dir = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":p:h")
vim.opt.runtimepath:prepend(config_dir)
-- print(config_dir)

package.path = config_dir .. "/lua/?.lua;" .. config_dir .. "/lua/?/init.lua;" .. package.path

vim.api.nvim_set_hl(0, "Normal", { bg = "#020802" })

require("options")
-- require("colors")
require("config.lazy")
require("commands")
require("mappings")

require("lsp")
require("lsp.python")
require("lsp.rust")
require("lsp.lua")
require("lsp.haskell")
require("lsp.nix")

vim.lsp.enable("luals")
vim.lsp.enable("ruff")
vim.lsp.enable("pyright")
vim.lsp.enable("nixd")

vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true } })

-- ADDED: Initialize which-key
require("which-key").setup()

vim.cmd("hi link Floaterm Normal")
vim.cmd("hi link FloatermBorder Normal")
vim.api.nvim_set_hl(0, "Normal", { bg = "#020802" })
-- lua.cmd.cd(current_dir)
-- print("reached end of init.lua")
