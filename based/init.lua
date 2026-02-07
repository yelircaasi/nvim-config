-- TODO: see https://www.reddit.com/r/neovim/comments/1afw5tc/rustaceanvim_now_with_neotest_integration/
print("Hello")
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
o.timeout = true
o.timeoutlen = 300

map("n", "<leader>o", ":update<CR> :source<CR>")
map("n", "<leader>ww", ":write<CR>")
map("n", "<leader>qq", ":quit<CR>")
map("n", "<leader>wq", ":wq<CR>")
map("n", "<leader>f", ":Pick files<CR>")
-- map('t', '^[', "^\^N")
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
map("t", "kj", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
-- map('t', '^O', '^\^O')
map("t", "<C-o>", [[<C-\><C-o>]], { desc = "Temporary normal mode" })
map("n", "<leader>lf", vim.lsp.buf.format)
map("n", "<leader>h", ":Pick help")
map("n", "<leader>e", ":Oil<CR>")
map({ "n", "v", "x" }, "<leader>y", '"+y<CR>')
map({ "n", "v", "x" }, "<leader>d", "+d<CR>")

--------------------

local NVIM_DIR = vim.fn.expand("~/.config/nvim")

local gh = function(id)
	return "https://github.com/" .. id
end
local gl = function(id)
	return "https://gitlab.com/" .. id
end
local cb = function(id)
	return "https://codeberg.org/" .. id
end

local plugin_ids_eager = {}
local plugin_ids_lazy = {}

local PLUGIN_DECLARATION = {
	-- id, url expander, lazy


	
	-- "willothy/wezterm.nvim" -> just vendor
	-- { "2KAbhishek/markit.nvim", gh, false },
	{ "2KAbhishek/pickme.nvim", gh, false },
	{ "akinsho/toggleterm.nvim", gh, false },
	{ "chentoast/marks.nvim", gh, false },
	{ "folke/snacks.nvim", gh, false },
	{ "folke/todo-comments.nvim", gh, false },
	{ "folke/which-key.nvim", gh, false },
	{ "folke/zen-mode.nvim", gh, false },
	{ "kevinhwang91/nvim-bqf", gh, false },
	{ "L3MON4D3/LuaSnip", gh, false },
	{ "lewis6991/gitsigns.nvim", gh, false },
	{ "mg979/vim-visual-multi", gh, false },
	{ "mikavilpas/yazi.nvim", gh, false },
	{ "monaqa/dial.nvim", gh, false },
	{ "mrcjkb/haskell-tools.nvim", gh, false }, -- already lazy
	{ "mrcjkb/rustaceanvim", gh, false }, -- already lazy
	{ "nvim-lua/plenary.nvim", gh, false },
	{ "nvim-lualine/lualine.nvim", gh, false },
	{ "nvim-mini/mini.nvim", gh, false },
	{ "nvim-mini/mini.pick", gh, false },
	{ "nvim-neotest/neotest", gh, false },   
	{ "MrcJkb/neotest-haskell", gh, false }, -- TODO
	{ "nvim-neotest/neotest-python", gh, false },
	{ "nvim-neotest/nvim-nio", gh, false },
	{ "nvim-telescope/telescope.nvim", gh, false },
	{ "nvim-treesitter/nvim-treesitter-textobjects", gh, false },
	{ "nvim-treesitter/nvim-treesitter", gh, false },
	{ "rafamadriz/friendly-snippets", gh, false },
	{ "ribru17/bamboo.nvim", gh, false },
	{ "Saghen/blink.cmp", gh, false },
	{ "sindrets/diffview.nvim", gh, false },
	{ "stevearc/conform.nvim", gh, false },
	{ "stevearc/oil.nvim", gh, false },
	{ "voldikss/vim-floaterm", gh, false },
    { "nvim-telescope/telescope-fzf-native.nvim", gh, false },
}

local make_specs = function(plugin_ids)
	local specs = {
		nix = {
			lazy = {},
			eager = {},
		},
		git = {
			lazy = {},
			eager = {},
		},
	}

	local has_nix, plugin_locations = pcall(dofile, NVIM_DIR .. "/nix_plugins.lua")

	local get_nix_path = function(_id)
		if has_nix then
			return plugin_locations[_id]
		end
	end

	for _, info in ipairs(plugin_ids) do
		local id, expander, lazy = unpack(info)
		-- local user, repo = string.match(id, "([^/]+)/([^/]+)")
		local nix_path = get_nix_path(id)
		local group = lazy and "lazy" or "eager"
		if nix_path then
			local path = plugin_locations[id].path
			table.insert(specs.nix[group], { path = path })
			if not lazy then
				vim.opt.rtp:prepend(path)
			end
		else
			table.insert(specs.git[group], { src = expander(id) })
		end
	end
	return specs
end

--------------

-- local has_nix = vim.uv.fs_stat("/nix/store") ~= nil

PLUGIN_SPECS = make_specs(PLUGIN_DECLARATION)
-- print(vim.inspect(PLUGIN_SPECS))
vim.pack.add(PLUGIN_SPECS.git.eager)

if has_nix then
	require("nvim-treesitter.configs").setup({
		ensure_installed = has_nix and {} or { "lua", "python", "rust", "typescript", "haskell" },
		highlight = { enable = true },
		parser_install_dir = not has_nix and vim.fn.stdpath("data") .. "/parsers" or nil,
	})
end

--------------

vim.keymap.set("n", "<leader>lu", function()
	-- Create a new empty floating window or split
	vim.cmd("vsplit | enew")
	vim.bo.filetype = "lua"
	vim.bo.bufhidden = "hide"

	-- Map <CR> to execute the current line or selection
	vim.keymap.set("n", "<CR>", ":.lua<CR>", { buffer = true })
	vim.keymap.set("v", "<CR>", ":lua<CR>", { buffer = true })
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
	"zig",
}
require("nvim-treesitter").setup({
	-- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
	install_dir = vim.fn.stdpath("data") .. "/site",
	ensure_installed = ts_languages,
	highlight = { enable = true },
	indent = { enable = true },
})
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
			workspace = { library = vim.api.nvim_get_runtime_file("", true) },
		},
	},
})
vim.lsp.config("ruff", {}) -- TODO
vim.lsp.config("tinymist", {}) -- TODO
vim.lsp.config("rust-analyzer", {}) -- TODO
vim.lsp.config("haskell-ls", {}) -- TODO

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt+=noselect")

-- vim.pack.add({ { src = "https://github.com/ii14/neorepl.nvim" } })

-- conform.nvim ---------------------------------------------------------------

require("conform").setup({
			formatters_by_ft = {
				python = {
					-- To fix auto-fixable lint errors.
					"ruff_fix",
					-- To run the Ruff formatter.
					"ruff_format",
					-- To organize the imports.
					"ruff_organize_imports",
				},
				nix = {
					"alejandra",
				},
				lua = {
					"stylua",
				},
				haskell = {
					"fourmolu",
				},
				rust = {
					"rustfmt",
				},
				go = {
					"gofmt",
				},
			},
		})

			-- Optional: format on save
vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
			})

-- blink.cmp ------------------------------------------------------------------

require("blink.cmp").setup(
	{
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = "default" },

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = { documentation = { auto_show = false } },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		}
)

-- zen-mode.nvim

require("zen-mode").setup({
			wezterm = {
				enabled = false,
				-- can be either an absolute font size or the number of incremental steps
				font = "+4", -- (10% increase per step)
			},
		})

-- lualine --------------------------------------------------------------------

require("lualine").setup()

-- dial.nvim ------------------------------------------------------------------

local augend = require("dial.augend")
require("dial.config").augends:register_group({
				default = {
					augend.integer.alias.decimal,
					augend.integer.alias.hex,
					augend.date.alias["%Y/%m/%d"],
					augend.constant.alias.bool,
				},
			})

-- nvim-treesitter ------------------------------------------------------------

if has_nix then
 require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"python",
					"lua",
					"javascript",
					"typescript",
					"nix",
					"json",
					"yaml",
					"toml",
					"markdown",
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
end

-- nvim-tree ------------------------------------------------------------------

-- require("nvim-tree").setup({})

-- yazi.nvim: TODO ------------------------------------------------------------

function load_yazi()
    require("yazi").setup({
			-- if you want to open yazi instead of netrw, see below for more info
			open_for_directories = true,
			keymaps = {show_help = "<f1>"},
	})
end

-- mark netrw as loaded so it's not loaded at all.
-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
vim.g.loaded_netrwPlugin = 1

vim.keymap.set(
	{ "n", "v" },
	"<leader>-",
	function()
		load_yazi()
		vim.cmd("Yazi")
	end,
	{ desc = "Open yazi at the current file." }
)
vim.keymap.set(
	{ "n", "v" },
	"<leader>cw",
	function()
		load_yazi()
		vim.cmd("Yazi cwd")
	end,
	{ desc = "Open the file manager in nvim's working directory." }
)
vim.keymap.set(
	{ "n", "v" },
	"<c-up>",
	function()
		load_yazi()
		vim.cmd("Yazi toggle")
	end,
	{ desc = "Resume the last yazi session." }
)

-- toggleterm.nvim ------------------------------------------------------------

require("toggleterm").setup({
			-- Your other toggleterm options here...
			open_mapping = [[<c-\>]],
			direction = "float",
			-- This is the key to inheriting your colorscheme's background
			highlights = {
				Normal = {
					link = "Normal",
				},
				NormalFloat = {
					link = "NormalFloat",
				},
			},
})


-- vim-floaterm ---------------------------------------------------------------

vim.g.floaterm_width = 0.8
vim.g.floaterm_height = 0.8

-- wezterm: TODO: vendor ------------------------------------------------------

    -- https://github.com/willothy/wezterm.nvim
	-- https://github.com/ianhomer/wezterm.nvim
	-- https://github.com/aca/wezterm.nvim
	-- https://github.com/letieu/wezterm-move.nvim
	-- https://github.com/jonboh/wezterm-mux.nvim -> https://github.com/mrjones2014/smart-splits.nvim


-- zen-mode.nvim --------------------------------------------------------------

vim.keymap.set(
	"n",
	"<leader>zm",
	function()
		require("zen-mode").toggle({
			window = {
				width = .85 -- width will be 85% of the editor width
			}
		})
	end,
	{ desc = "Toggle zen mode."}
)

-- which-key ------------------------------------------------------------------

require("which-key").setup()

-- LuaSnip --------------------------------------------------------------------

require("luasnip").setup()
        -- "L3MON4D3/LuaSnip",
		-- dependencies = { "rafamadriz/friendly-snippets" }, -- Optional: for pre-made snippets
		-- build = "make install_jsregexp", -- For regex snippets
		-- event = "InsertEnter",

-- nvim-cmp (old) -------------------------------------------------------------

-- dependencies = {
-- 	"hrsh7th/cmp-nvim-lsp",
-- 	"hrsh7th/cmp-buffer",
-- 	"hrsh7th/cmp-path",
-- 	"saadparwaiz1/cmp_luasnip",
-- }
local old_setup_nvim_cmp = function()
			vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
			vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
			local cmp = require("cmp")
			local defaults = require("cmp.config.default")()
			local auto_select = true
			return {
				snippet = {
					-- REQUIRED for luasnip
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				auto_brackets = {},
				completion = {
					completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
				},
				preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept selected suggestion
					--   ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
					--   ["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
					--   ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<C-CR>"] = function(fallback)
						cmp.abort()
						fallback()
					end,

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					--   ["<tab>"] = function(fallback)
					-- 	return LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }, fallback)()
					--   end,
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "path" },
				}),
				formatting = {
					format = function(entry, item)
						-- local icons = LazyVim.config.icons.kinds
						-- if icons[item.kind] then
						--   item.kind = icons[item.kind] .. item.kind
						-- end

						local widths = {
							abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
							menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
						}

						for key, width in pairs(widths) do
							if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
								item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
							end
						end

						return item
					end,
				},
				experimental = {
					-- only show ghost text when we show ai completions
					ghost_text = vim.g.ai_cmp and {
						hl_group = "CmpGhostText",
					} or false,
				},
				sorting = defaults.sorting,
			}
		end




		-- 



-- mini.nvim ------------------------------------------------------------------

-- We just setup the modules we want to use
			require("mini.pairs").setup()
			require("mini.icons").setup()
			require("mini.surround").setup()
			require("mini.comment").setup({
				-- No options needed for basic setup
			})
			require("mini.hipatterns").setup()
			require("mini.indentscope").setup()
			-- require("mini.marks").setup()
			-- require("mini.fold").setup()
			-- require("mini.terminal").setup()

-- nvim-bqf: TODO should lazy load on opening the quickfix window -> ft = "qf"

-- gitsigns.nvim --------------------------------------------------------------

-- event = { "BufReadPre", "BufNewFile" }
require("gitsigns").setup({})

-- todo-comments.nvim ---------------------------------------------------------

require("todo-comments").setup({})

-- telescope.nvim: TODO -------------------------------------------------------

-- cmd = "Telescope" -- lazy load on command Telescope
-- dependencies = {
-- 	"nvim-lua/plenary.nvim",
-- 	{
-- 		"nvim-telescope/telescope-fzf-native.nvim",
-- 		build = "make",
-- 	},
-- }
local telescope = require("telescope")
telescope.setup({
				defaults = {
					file_ignore_patterns = { "%.git/", "node_modules/", "%.venv/" },
				},
			})
telescope.load_extension("fzf")

-- diffview.nvim --------------------------------------------------------------

-- cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" }
require("diffview").setup({})

-- markit.nvim ----------------------------------------------------------------

-- require("markit").setup({})

-- marks.nvim ---------

require("marks").setup({})

-- neotest --------------------------------------------------------------------

-- dependencies = {
-- 	"nvim-lua/plenary.nvim",
-- 	"nvim-treesitter/nvim-treesitter",
-- 	"antoinemadec/FixCursorHold.nvim",
-- 	"nvim-neotest/nvim-nio",
-- 	"nvim-neotest/neotest-python",
-- }
require("neotest").setup({
				adapters = {
					require("neotest-python")({
						-- Extra arguments for nvim-dap configuration
						-- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
						dap = { justMyCode = false },
						-- Command line arguments for runner
						-- Can also be a function to return dynamic values
						args = { "--log-level", "DEBUG" },
						-- Runner to use. Will use pytest if available by default.
						-- Can be a function to return dynamic value.
						runner = "pytest",
						-- Custom python path for the runner.
						-- Can be a string or a list of strings.
						-- Can also be a function to return dynamic value.
						-- If not provided, the path will be inferred by checking for
						-- virtual envs in the local directory and for Pipenev/Poetry configs
						python = ".venv/bin/python",
						-- Returns if a given file path is a test file.
						-- NB: This function is called a lot so don't perform any heavy tasks within it.
						-- is_test_file = function(file_path)
						-- end,
						-- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
						-- instances for files containing a parametrize mark (default: false)
						pytest_discover_instances = true,
					}),
				},
			})



-- TODO: process old lazy.nvim config and keybinds

-- pickme 

require("pickme").setup({
	picker_provider = "snacks",
})

-- nvim-treesitter-textobjects ------------------------------------------------

require("nvim-treesitter-textobjects").setup({
  select = {
    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = true,
    -- You can choose the select mode (default is charwise 'v')
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * method: eg 'v' or 'o'
    -- and should return the mode ('v', 'V', or '<c-v>') or a table
    -- mapping query_strings to modes.
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer'] = 'V', -- linewise
      -- ['@class.outer'] = '<c-v>', -- blockwise
    },
    -- If you set this to `true` (default is `false`) then any textobject is
    -- extended to include preceding or succeeding whitespace. Succeeding
    -- whitespace has priority in order to act similarly to eg the built-in
    -- `ap`.
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * selection_mode: eg 'v'
    -- and should return true of false
    include_surrounding_whitespace = false,
  },
})

-- vim-visual-multi

vim.g.VM_default_mappings = true
