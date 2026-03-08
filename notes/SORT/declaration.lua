local PLUGIN_DECLARATION = {
	--===================================================================================================================================
	--==== LAYER 0: foundation, colors, search, core navigation =========================================================================
	--===================================================================================================================================
	------------------------------
	------ core dependencies -----
	------------------------------
	["plenary"]                                  = { id = "nvim-lua/plenary.nvim",         expander = gh, lazy = false },
	["nio"]                                      = { id = "nvim-neotest/nvim-nio",         expander = gh, lazy = false },
	["nvim-web-devicons"]                        = { id = "nvim-tree/nvim-web-devicons",   expander = gh, lazy = false }, -- needs nix
	["nui"]                                      = { id = "MunifTanjim/nui.nvim",          expander = gh, lazy = false }, -- needs nix
	-----------------------------─
	------ core setup and UI -----
	------------------------------
	["bamboo"]                                   = { id = "ribru17/bamboo.nvim",           expander = gh, lazy = false },
	["zen-mode"]                                 = { id = "folke/zen-mode.nvim",           expander = gh, lazy = false },
	["illuminate"]                               = { id = "RRethy/vim-illuminate",         expander = gh, lazy = false },
	["lualine"]                                  = { id = "nvim-lualine/lualine.nvim",     expander = gh, lazy = false },
	["nvim-navic"]                               = { id = "SmiteshP/nvim-navic",           expander = gh, lazy = false }, -- needs nix
	["bufferline"]                               = { id = "akinsho/bufferline.nvim",       expander = gh, lazy = false }, -- needs nix
	["statuscol"]                                = { id = "luukvbaal/statuscol.nvim",      expander = gh, lazy = false }, -- needs nix
	["nvim-treesitter"]                          = { id = "nvim-treesitter/nvim-treesitter", expander = gh, lazy = false }, -- brew install tree-sitter; brew install tree-sitter-cli
	["treesitter-modules"]                       = { id = "MeanderingProgrammer/treesitter-modules.nvim", expander = gh, lazy = false }, -- needs nix
	["dropbar"]                                  = { id = "Bekaboo/dropbar.nvim",          expander = gh, lazy = false }, -- needs nix
	["nvim-navbuddy"]                            = { id = "SmiteshP/nvim-navbuddy",        expander = gh, lazy = false, deps = { "nui" } }, -- needs nix
	["aerial"]                                   = { id = "stevearc/aerial.nvim",          expander = gh, lazy = false }, -- needs nix
	---------------------------------------------
	------ file explorer (as central focus) -----
	---------------------------------------------
	["oil"]                                      = { id = "stevearc/oil.nvim",             expander = gh, lazy = false },
	["yazi"]                                     = { id = "mikavilpas/yazi.nvim",          expander = gh, lazy = false },
	["neo-tree"]                                 = { id = "nvim-neo-tree/neo-tree.nvim",   expander = gh, lazy = false }, -- needs nix
	["nvim-tree"]                                = { id = "nvim-tree/nvim-tree.lua",       expander = gh, lazy = false }, -- needs nix
	----------------------------
	------ picker / search -----
	----------------------------
	["pickme"]                                   = { id = "2KAbhishek/pickme.nvim",        expander = gh, lazy = false },
	["telescope"]                                = { id = "nvim-telescope/telescope.nvim", expander = gh, lazy = false },
	["telescope-fzf-native"]                     = { id = "nvim-telescope/telescope-fzf-native.nvim", expander = gh, lazy = false },
	["fzf-lua"]                                  = { id = "ibhagwan/fzf-lua",              expander = gh, lazy = false }, -- needs nix
	["deck"]                                     = { id = "hrsh7th/nvim-deck",             expander = gh, lazy = false }, -- needs nix
	-------------------
	------ suites -----
	-------------------
	["mini"]                                     = { id = "nvim-mini/mini.nvim",           expander = gh, lazy = false },
	["snacks"]                                   = { id = "folke/snacks.nvim",             expander = gh, lazy = false },
	["blink"]                                    = { id = "saghen/blink.nvim",             expander = gh, lazy = false }, -- needs nix
	-------------------
	------ search -----
	-------------------
	["hlslens"]                                  = { id = "kevinhwang91/nvim-hlslens",     expander = gh, lazy = false }, -- needs nix
	["hlsearch"]                                 = { id = "nvimdev/hlsearch.nvim",         expander = gh, lazy = false }, -- needs nix
	-----------------------------
	------ find-and-replace -----
	-----------------------------
	["grug-far"]                                 = { id = "MagicDuck/grug-far.nvim",       expander = gh, lazy = false }, -- needs nix
	["spectre"]                                  = { id = "nvim-pack/nvim-spectre",        expander = gh, lazy = false }, -- needs nix
	--------------------------------------------------
	------ layout & window/buffer/tab navigation -----
	--------------------------------------------------
	["nvim_winpick"]                             = { id = "MarcusGrass/nvim_winpick",      expander = gh, lazy = false },
	["flybuf"]                                   = { id = "nvimdev/flybuf.nvim",           expander = gh, lazy = false }, -- needs nix
	["stickybuf"]                                = { id = "stevearc/stickybuf.nvim",       expander = gh, lazy = false }, -- needs nix
	["swm"]                                      = { id = "hrsh7th/nvim-swm",              expander = gh, lazy = false }, -- needs nix
	--------------------------------
	------ wezterm integration -----
	--------------------------------
	["smart-splits"]                             = { id = "mrjones2014/smart-splits.nvim", expander = gh, lazy = false }, -- needs nix

	--===================================================================================================================================
	--==== LAYER 1: editing enhancements ================================================================================================ 1
	--===================================================================================================================================
	------------------
	------ folds -----
	------------------
	["ufo"]                                 = { id = "kevinhwang91/nvim-ufo",         expander = gh, lazy = false }, -- needs nix
	-------------------
	------ macros -----
	-------------------
	["NeoComposer"]                              = { id = "lvim-tech/NeoComposer.nvim",    expander = gh, lazy = false },
	["nvim-macros"]                              = { id = "kr40/nvim-macros",              expander = gh, lazy = false },
	["recorder"]                            = { id = "chrisgrieser/nvim-recorder",    expander = gh, lazy = false },
	-------------------------
	------ multi-cursor -----
	-------------------------
	["vim-visual-multi"]                         = { id = "mg979/vim-visual-multi",        expander = gh, lazy = false },
	-------------------
	------ motion -----
	-------------------
	["leap"]                                     = { id = "andyg/leap.nvim",               expander = cb, lazy = false }, -- needs nix
	["flash"]                                    = { id = "folke/flash.nvim",              expander = gh, lazy = false }, -- needs nix
	["hop"]                                      = { id = "smoka7/hop.nvim",               expander = gh, lazy = false }, -- needs nix
	------------------
	------ pairs -----
	------------------
	["rainbow-delimiters"]                       = { id = "HiPhish/rainbow-delimiters.nvim", expander = gh, lazy = false }, -- needs nix
	["nvim-autopairs"]                           = { id = "windwp/nvim-autopairs",         expander = gh, lazy = false }, -- needs nix
	["blink.pairs"]                              = { id = "saghen/blink.pairs",            expander = gh, lazy = false }, -- needs nix
	["vim-sandwich"]                             = { id = "machakann/vim-sandwich",        expander = gh, lazy = false }, -- needs nix
	["surround"]                            = { id = "kylechui/nvim-surround",        expander = gh, lazy = false }, -- needs nix
	-----------------
	------ undo -----
	-----------------
	["vim-mundo"]                                = { id = "simnalamburt/vim-mundo",        expander = gh, lazy = false }, -- needs nix
	-------------------------------
	------ keymapping-related -----
	-------------------------------
	["mini.keymap"]                              = { id = "nvim-mini/mini.keymap",         expander = gh, lazy = false }, -- needs nix
	["hydra"]                                    = { id = "nvimtools/hydra.nvim",          expander = gh, lazy = false }, -- needs nix
	["nvim-insx"]                                = { id = "hrsh7th/nvim-insx",             expander = gh, lazy = false }, -- needs nix
	["which-key"]                                = { id = "folke/which-key.nvim",          expander = gh, lazy = false },
	------------------------------------
	------ alignment / indentation -----
	------------------------------------
	["indentmini"]                               = { id = "nvimdev/indentmini.nvim",       expander = gh, lazy = false }, -- needs nix
	["indent-blankline"]                         = { id = "lukas-reineke/indent-blankline.nvim", expander = gh, lazy = false }, -- needs nix
	["nvim-anydent"]                             = { id = "hrsh7th/nvim-anydent",          expander = gh, lazy = false }, -- needs nix
	["mini.align"]                               = { id = "nvim-mini/mini.align",          expander = gh, lazy = false }, -- needs nix
	["tabular"]                                  = { id = "godlygeek/tabular",             expander = gh, lazy = false }, --  -- needs nix; https://devhints.io/tabular
	------------------------
	------ textobjects -----
	------------------------
	["nvim-treesitter-textobjects"] = {
		id = "nvim-treesitter/nvim-treesitter-textobjects",
		expander = gh,
		lazy = false,
		name = "nvim-treesitter-textobjects",
	},
	["nvim-various-textobjs"]  = { id = "chrisgrieser/nvim-various-textobjs", expander = gh, lazy = false }, -- needs nix
	---------------------
	------ comments -----
	---------------------
	["Comment"]                                  = { id = "numToStr/Comment.nvim",         expander = gh, lazy = false }, -- needs nix
	["todo-comments"]                            = { id = "folke/todo-comments.nvim",      expander = gh, lazy = false },
	["vim-commentary"]                           = { id = "tpope/vim-commentary",          expander = gh, lazy = false }, -- needs nix
	-------------------------
	------ split / join -----
	-------------------------
	["treesj"]                                   = { id = "Wansmer/treesj",                expander = gh, lazy = false }, -- needs nix
	-------------------------------
	------ value manipulation -----
	-------------------------------
	["dial"]                                     = { id = "monaqa/dial.nvim",              expander = gh, lazy = false },
	------------------
	------ marks -----
	------------------
	["harpoon-core"]                             = { id = "MeanderingProgrammer/harpoon-core.nvim", expander = gh, lazy = false }, -- needs nix
	["marks"]                                    = { id = "chentoast/marks.nvim",          expander = gh, lazy = false },
	["markit"]                                   = { id = "2KAbhishek/markit.nvim",        expander = gh, lazy = false }, -- needs nix
	-----------------------------------
	------ yank/paste & clipboard -----
	-----------------------------------
	["nvim-pasta"]                               = { id = "hrsh7th/nvim-pasta",            expander = gh, lazy = false }, -- needs nix
	--------------------------
	------ miscellaneous -----
	--------------------------
	["beam"]                                     = { id = "Piotr1215/beam.nvim",           expander = gh, lazy = false }, -- needs nix

	--===================================================================================================================================
	--==== LAYER 2: LSP, autocompletion, snippets ======================================================================================= 2
	--===================================================================================================================================
	-----------------------------------
	------ snippets, autocomplete -----
	-----------------------------------
	["blink.cmp"]                                = { id = "Saghen/blink.cmp",              expander = gh, lazy = false },
	["nvim-cmp"]                                 = { id = "hrsh7th/nvim-cmp",              expander = gh, lazy = false }, -- needs nix
	-------------------------------------
	------ snippets (as main focus) -----
	-------------------------------------
	["friendly-snippets"]                        = { id = "rafamadriz/friendly-snippets",  expander = gh, lazy = false },
	["ultisnips"]                                = { id = "SirVer/ultisnips",              expander = gh, lazy = false }, -- needs nix; https://ejmastnak.com/tutorials/vim-latex/ultisnips/
	["LuaSnip"]                                  = { id = "L3MON4D3/LuaSnip",              expander = gh, lazy = false },
	------ completion sources -----
	["cmp-nvim-lsp"]                             = { id = "hrsh7th/cmp-nvim-lsp",          expander = gh, lazy = false }, -- needs nix
	["cmp-buffer"]                               = { id = "hrsh7th/cmp-buffer",            expander = gh, lazy = false }, -- needs nix
	["cmp-path"]                                 = { id = "hrsh7th/cmp-path",              expander = gh, lazy = false }, -- needs nix
	["cmp-cmdline"]                              = { id = "hrsh7th/cmp-cmdline",           expander = gh, lazy = false }, -- needs nix
	------------------------
	------ LSP general -----
	------------------------
	-- (configure ruff, pyright, lua-language-server, haskell-language-server, rust-analyzer with built-in client)
	["lsp-format"]                               = { id = "lukas-reineke/lsp-format.nvim", expander = gh, lazy = false }, -- needs nix
	["lspkind"]                                  = { id = "onsails/lspkind.nvim",          expander = gh, lazy = false }, -- needs nix
	["efm"]                                      = { id = "mattn/efm-langserver",          expander = gh, lazy = false },
	------------------------------------------
	------ LSP UI (see also fidget.nvim) -----
	------------------------------------------
	["lspsaga"]                                  = { id = "nvimdev/lspsaga.nvim",          expander = gh, lazy = false }, -- needs nix
	------ language-specific -----
	["lazydev"]                                  = { id = "folke/lazydev.nvim",            expander = gh, lazy = false }, -- needs nix
	["rustaceanvim"]                             = { id = "mrcjkb/rustaceanvim",           expander = gh, lazy = false }, -- already lazy
	["crates"]                                   = { id = "saecki/crates.nvim",            expander = gh, lazy = false }, -- needs nix
	["haskell-tools"]                            = { id = "mrcjkb/haskell-tools.nvim",     expander = gh, lazy = false }, -- already lazy
	------ LSP-adjacent -----
	["none-ls"]                                  = { id = "nvimtools/none-ls.nvim",        expander = gh, lazy = false }, -- needs nix

	--===================================================================================================================================
	-- LAYER 3: formatting & linting ==================================================================================================== 3
	--===================================================================================================================================
	["guard"]                                    = { id = "nvimdev/guard.nvim",            expander = gh, lazy = false }, -- needs nix
	["conform"]                                  = { id = "stevearc/conform.nvim",         expander = gh, lazy = false }, -- ruff, rustfmt, stylua, fourmolu

	--===================================================================================================================================
	-- LAYER 4: testing, debugging/quickfix, execution ================================================================================== 4
	--===================================================================================================================================
	-------------------------------------------------
	----- Code execution / task running / build -----
	-------------------------------------------------
	["overseer"]                                 = { id = "stevearc/overseer.nvim",        expander = gh, lazy = false }, -- needs nix
	["asyncrun"]                                 = { id = "skywind3000/asyncrun.vim",      expander = gh, lazy = false }, -- needs nix
	["compiler"]                                 = { id = "Zeioth/compiler.nvim",          expander = gh, lazy = false },
	["code_runner"]                              = { id = "CRAG666/code_runner.nvim",      expander = gh, lazy = false },
	["sniprun"]                                  = { id = "michaelb/sniprun",              expander = gh, lazy = false },
	["yabs"]                                     = { id = "pianocomposer321/officer.nvim", expander = gh, lazy = false },
	-------------------
	----- Testing -----
	-------------------
	["neotest-haskell"]                          = { id = "MrcJkb/neotest-haskell",        expander = gh, lazy = false }, -- TODO
	["neotest-python"]                           = { id = "nvim-neotest/neotest-python",   expander = gh, lazy = false },
	["neotest"]                                  = { id = "nvim-neotest/neotest",          expander = gh, lazy = false },
	["dap-python"]                               = { id = "mfussenegger/nvim-dap-python",  expander = cb, lazy = false }, -- needs nix; pipx install debugpy
	["dapui"]                                    = { id = "rcarriga/nvim-dap-ui",          expander = gh, lazy = false }, -- needs nix
	["nvim-dap-virtual-text"]                    = { id = "theHamsta/nvim-dap-virtual-text", expander = gh, lazy = false }, -- needs nix
	["dap"]                                      = { id = "mfussenegger/nvim-dap",         expander = cb, lazy = false }, -- needs nix
	["mypy"]                                     = { id = "feakuru/mypy.nvim",             expander = gh, lazy = false }, -- needs nix
	["nvim-lint"]                                = { id = "mfussenegger/nvim-lint",        expander = gh, lazy = false }, -- needs nix
	---------------------------
	------ DAP/quickix UI -----
	---------------------------
	["trouble.nvim"]                             = { id = "folke/trouble.nvim",            expander = gh, lazy = false }, -- needs nix
	["quicker"]                                  = { id = "stevearc/quicker.nvim",         expander = gh, lazy = false }, -- needs nix
	["nvim-bqf"]                                 = { id = "kevinhwang91/nvim-bqf",         expander = gh, lazy = false },
	---------------------
	------ terminal -----
	---------------------
	["vim-floaterm"]                             = { id = "voldikss/vim-floaterm",         expander = gh, lazy = false },
	--===================================================================================================================================
	--==== LAYER 5: refactoring & code intelligence ===================================================================================== 5
	--===================================================================================================================================
	["refactoring"]                              = { id = "ThePrimeagen/refactoring.nvim", expander = gh, lazy = false }, -- needs nix
	-------------------------------
	------ project management -----
	-------------------------------
	["project"]                                  = { id = "ahmedkhalf/project.nvim",       expander = gh, lazy = false }, -- needs nix
	["telescope-project"]                        = { id = "nvim-telescope/telescope-project.nvim", expander = gh, lazy = false }, -- needs nix

	--===================================================================================================================================
	--==== LAYER 6: version control & collaboration ===================================================================================== 6
	--===================================================================================================================================
	["jj"]                                       = { id = "NicolasGB/jj.nvim",             expander = gh, lazy = false }, -- needs nix
	["jujutsu"]                                  = { id = "yannvanhalewyn/jujutsu.nvim",   expander = gh, lazy = false }, -- needs nix
	["lazygit"]                                  = { id = "kdheepak/lazygit.nvim",         expander = gh, lazy = false }, -- needs nix
	["git-conflict"]                             = { id = "akinsho/git-conflict.nvim",     expander = gh, lazy = false }, -- needs nix
	["neogit"]                                   = { id = "NeogitOrg/neogit",              expander = gh, lazy = false }, -- needs nix
	["jiejie"]                                   = { id = "jceb/jiejie.nvim",              expander = gh, lazy = false }, -- needs nix
	["diffview"]                                 = { id = "sindrets/diffview.nvim",        expander = gh, lazy = false },
	["gitsigns"]                                 = { id = "lewis6991/gitsigns.nvim",       expander = gh, lazy = false },
	["vim-fugitive"]                             = { id = "tpope/vim-fugitive",            expander = gh, lazy = false }, -- needs nix
	----------------------
	----- Git forges -----
	----------------------
	["octo"]                                     = { id = "pwntester/octo.nvim",           expander = gh, lazy = false }, -- needs nix
	["gitlab-nvim"]                              = { id = "harrisoncramer/gitlab.nvim",    expander = gh, lazy = false }, -- needs nix
	["gitlab"]                                   = { id = "gitlab-org/editor-extensions/gitlab.vim", expander = gl, lazy = false }, -- needs nix

	--===================================================================================================================================
	--==== LAYER 7: UI polish & productivity ============================================================================================ 7
	--===================================================================================================================================
	["dashboard-nvim"]                           = { id = "nvimdev/dashboard-nvim",        expander = gh, lazy = false }, -- needs nix
	["dashboard"]                                = { id = "MeanderingProgrammer/dashboard.nvim", expander = gh, lazy = false }, -- needs nix
	["noice"]                                    = { id = "folke/noice.nvim",              expander = gh, lazy = false }, -- needs nix
	["modes"]                                    = { id = "mvllow/modes.nvim",             expander = gh, lazy = false }, -- needs nix
	-----------------------------------
	------ UI (important for LSP) -----
	-----------------------------------
	["fidget"]                                   = { id = "j-hui/fidget.nvim",             expander = gh, lazy = false }, -- needs nix
	["nvim-notify"]                              = { id = "rcarriga/nvim-notify",          expander = gh, lazy = false }, -- needs nix; see also mini.notify
	["headlines"]                                = { id = "lukas-reineke/headlines.nvim",  expander = gh, lazy = false }, -- needs nix
	-------------------------------
	------ session management -----
	-------------------------------
	["auto-session"]                             = { id = "rmagatti/auto-session",         expander = gh, lazy = false }, -- needs nix
	["persistence"]                              = { id = "folke/persistence.nvim",        expander = gh, lazy = false }, -- needs nix

	--===================================================================================================================================
	--==== LAYER 8: miscellaneous/advanced ============================================================================================== 8
	--===================================================================================================================================
	["vimtex"]                                   = { id = "lervag/vimtex",                 expander = gh, lazy = false }, -- needs nix; use vim.cmd.source or vim.fn.runtime
	["texmagic"]                                 = { id = "jakewvincent/texmagic.nvim",    expander = gh, lazy = false }, -- needs nix
	["schemastore"]                              = { id = "b0o/SchemaStore.nvim",          expander = gh, lazy = false }, -- needs nix
	["firenvim"]                                 = { id = "glacambre/firenvim",            expander = gh, lazy = false }, -- needs nix
	["render-markdown"]                          = { id = "MeanderingProgrammer/render-markdown.nvim", expander = gh, lazy = false }, -- needs nix
	["jupytext"]                                 = { id = "GCBallesteros/jupytext.nvim",   expander = gh, lazy = false }, -- needs nix
	["quarto"]                                   = { id = "quarto-dev/quarto-nvim",        expander = gh, lazy = false }, -- needs nix
	["markdown-preview"]                         = { id = "iamcco/markdown-preview.nvim",  expander = gh, lazy = false }, -- needs nix
	-----------------------------------
	------ Lua / self-referential -----
	-----------------------------------
	["structlog"]                                = { id = "Tastyep/structlog.nvim",        expander = gh, lazy = false }, -- needs nix
	["neorepl"]                                  = { id = "ii14/neorepl.nvim",             expander = gh, lazy = false }, -- needs nix
}

local add_plugin = function(name)
	local cfg = PLUGIN_DECLARATION[name]
	vim.pack.add({ { src = cfg.expander(cfg.id) } })
end

for _, name in ipairs(PLUGINS) do
	add_plugin(name)
end