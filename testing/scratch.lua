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

-- local hello = vim.fn.system("echo hello")
-- print(hello)



-- function addRelPath(dir)
-- 	local spath = debug.getinfo(1, "S").source:sub(2):gsub("^([^/])", "./%1"):gsub("[^/]*$", "")
-- 	dir = dir and (dir .. "/") or ""
-- 	spath = spath .. dir
-- 	package.path    = spath .. "?.lua;" .. spath .. "?/init.lua"
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