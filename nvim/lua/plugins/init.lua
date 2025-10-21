M = {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
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
		end,
	},
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				python = {
					-- To fix auto-fixable lint errors.
					"ruff_fix",
					-- To run the Ruff formatter.
					"ruff_format",
					-- To organize the imports.
					"ruff_organize_imports",
				},
				lua = {
					"stylua",
				},
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)

			-- Optional: format on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
			})
		end,
	},
	-- {
	-- 	"nvim-tree/nvim-tree.lua",
	-- 	dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional icons
	-- 	config = function()
	-- 		require("nvim-tree").setup({})
	-- 	end,
	-- },
	-- {
	{
		"mikavilpas/yazi.nvim",
		version = "*", -- use the latest stable version
		event = "VeryLazy",
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
		},
		keys = {
			{
				"<leader>-",
				mode = { "n", "v" },
				"<cmd>Yazi<cr>",
				desc = "Open yazi at the current file",
			},
			{
				-- Open in the current working directory
				"<leader>cw",
				"<cmd>Yazi cwd<cr>",
				desc = "Open the file manager in nvim's working directory",
			},
			{
				"<c-up>",
				"<cmd>Yazi toggle<cr>",
				desc = "Resume the last yazi session",
			},
		},
		---@type YaziConfig | {}
		opts = {
			-- if you want to open yazi instead of netrw, see below for more info
			open_for_directories = true,
			keymaps = {
				show_help = "<f1>",
			},
		},
		init = function()
			-- mark netrw as loaded so it's not loaded at all.
			-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
			vim.g.loaded_netrwPlugin = 1
		end,
	},
	{
		"willothy/wezterm.nvim",
		config = true,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
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
		},
		config = function()
			require("toggleterm").setup()
		end,
	},
	{
		"voldikss/vim-floaterm",
		config = function()
			-- Optional: Set global configurations for floaterm if needed
			vim.g.floaterm_width = 0.8
			vim.g.floaterm_height = 0.8

			-- This is the crucial part for color integration
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
		},
	},
	-- {
	-- 	"hrsh7th/nvim-cmp",
	-- 	version = false, -- last release is way too old
	-- 	event = "InsertEnter",
	-- 	dependencies = {
	-- 	  "hrsh7th/cmp-nvim-lsp",
	-- 	  "hrsh7th/cmp-buffer",
	-- 	  "hrsh7th/cmp-path",
	-- 	},
	-- 	-- Not all LSP servers add brackets when completing a function.
	-- 	-- To better deal with this, LazyVim adds a custom option to cmp,
	-- 	-- that you can configure. For example:
	-- 	--
	-- 	-- ```lua
	-- 	-- opts = {
	-- 	--   auto_brackets = { "python" }
	-- 	-- }
	-- 	-- ```
	-- 	opts = function()
	-- 	  -- Register nvim-cmp lsp capabilities
	-- 	  vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

	-- 	  vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
	-- 	  local cmp = require("cmp")
	-- 	  local defaults = require("cmp.config.default")()
	-- 	  local auto_select = true
	-- 	  return {
	-- 		auto_brackets = {}, -- configure any filetype to auto add brackets
	-- 		completion = {
	-- 		  completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
	-- 		},
	-- 		preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
	-- 		mapping = cmp.mapping.preset.insert({
	-- 		  ["<C-b>"] = cmp.mapping.scroll_docs(-4),
	-- 		  ["<C-f>"] = cmp.mapping.scroll_docs(4),
	-- 		  ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
	-- 		  ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
	-- 		  ["<C-Space>"] = cmp.mapping.complete(),
	-- 		  ["<CR>"] = LazyVim.cmp.confirm({ select = auto_select }),
	-- 		  ["<C-y>"] = LazyVim.cmp.confirm({ select = true }),
	-- 		  ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	-- 		  ["<C-CR>"] = function(fallback)
	-- 			cmp.abort()
	-- 			fallback()
	-- 		  end,
	-- 		  ["<tab>"] = function(fallback)
	-- 			return LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }, fallback)()
	-- 		  end,
	-- 		}),
	-- 		sources = cmp.config.sources({
	-- 		  { name = "lazydev" },
	-- 		  { name = "nvim_lsp" },
	-- 		  { name = "path" },
	-- 		}, {
	-- 		  { name = "buffer" },
	-- 		}),
	-- 		formatting = {
	-- 		  format = function(entry, item)
	-- 			local icons = LazyVim.config.icons.kinds
	-- 			if icons[item.kind] then
	-- 			  item.kind = icons[item.kind] .. item.kind
	-- 			end

	-- 			local widths = {
	-- 			  abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
	-- 			  menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
	-- 			}

	-- 			for key, width in pairs(widths) do
	-- 			  if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
	-- 				item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
	-- 			  end
	-- 			end

	-- 			return item
	-- 		  end,
	-- 		},
	-- 		experimental = {
	-- 		  -- only show ghost text when we show ai completions
	-- 		  ghost_text = vim.g.ai_cmp and {
	-- 			hl_group = "CmpGhostText",
	-- 		  } or false,
	-- 		},
	-- 		sorting = defaults.sorting,
	-- 	  }
	-- 	end,
	-- 	main = "lazyvim.util.cmp",
	--   },
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" }, -- Optional: for pre-made snippets
		build = "make install_jsregexp", -- For regex snippets
		event = "InsertEnter",
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
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
		end,
	},
	{
		"kevinhwang91/nvim-bqf",
		ft = "qf", -- Lazy load on opening the quickfix window
	},
	{
		"echasnovski/mini.nvim",
		version = "*", -- or pin to a specific release
		event = "VeryLazy",
		config = function()
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
		end,
	},

	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" }, -- Load on file read or new file
		config = function()
			require("gitsigns").setup({
				-- You can add configuration here later
			})
		end,
	},

	{
		"folke/todo-comments.nvim",
		event = { "BufReadPre", "BufNewFile" }, -- Load on file read
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup({
				-- No options needed for basic setup
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope", -- Lazy load on command
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				-- This will build the C extension for faster sorting
				build = "make",
			},
		},
		config = function()
			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					-- We'll keep this simple for now
					file_ignore_patterns = { "%.git/", "node_modules/", "%.venv/" },
				},
			})
			-- This is crucial to load the fzf-native extension
			telescope.load_extension("fzf")
		end,
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("diffview").setup({})
		end,
	},
	--   {
	-- 	"chentoast/marks.nvim",
	-- 	event = "VeryLazy",
	-- 	opts = {},
	--   },
	{
		"2kabhishek/markit.nvim",
		dependencies = { "2kabhishek/pickme.nvim" },
		config = {}, -- load_config('tools.marks'),
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"2KAbhishek/pickme.nvim",
		cmd = "PickMe",
		event = "VeryLazy",
		dependencies = {
			-- Include at least one of these pickers:
			"folke/snacks.nvim", -- For snacks.picker
			-- 'nvim-telescope/telescope.nvim', -- For telescope
			-- 'ibhagwan/fzf-lua', -- For fzf-lua
		},
		opts = {
			picker_provider = "snacks", -- Default provider
		},
	},
	-- {
	-- 	'stevearc/oil.nvim',
	-- 	---@module 'oil'
	-- 	---@type oil.SetupOpts
	-- 	opts = {},
	-- 	-- Optional dependencies
	-- 	dependencies = { { "nvim-mini/mini.icons", opts = {} } },
	-- 	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- 	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	-- 	lazy = false,
	--   },
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		lazy = true,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
	-- TODO: https://tamerlan.dev/setting-up-a-testing-environment-in-neovim/
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/nvim-nio",

			"nvim-neotest/neotest-python",
		},
		config = function()
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
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = true },
				panel = { enabled = true },
			})
		end,
	},
	{
		"mg979/vim-visual-multi",
		branch = "master",
		init = function()
			vim.g.VM_default_mappings = true
		end,
	},
}
return M
