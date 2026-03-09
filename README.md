# nvim Configuration

This contains a simple nvim configuration and two simple scripts to
copy it to and from the local configuration.

No nvim framework or distribution is used currently.


## Next Steps

- [ ] re-add links to notes, where applicable (especially consilium project)
- [ ] remove from plugins.json plugins that were moved to plugins.jsonc
- [ ] [read](https://www.reddit.com/r/neovim/comments/115baze/which_vim_plugins_do_not_have_a_lua_equivalent_yet/)
- [ ] annotate in plugins.jsonc which plugins are vimscript
- [ ] https://github.com/aliyss/vim-himalaya-ui
- [ ] https://github.com/aliyss


## Plugins

to glean from:

```json
[
    {
        "link": "https://www.youtube.com/watch?v=VC1DhAoRSpg",
        "decision": "glean",
        "projects": [],
        "notes": "Configure Neovim In Lisp With Fennel"
    },
    {
        "link": "https://github.com/mawkler/nvim | https://github.com/ray-x/nvim",
        "decision": "glean",
        "projects": [""]
    },
    {
        "link": "https://github.com/fdschmidt93/dotfiles",
        "decision": "glean",
        "projects": [""]
    },
    {
        "link": "https://github.com/2kabhishek/nvim2k",
        "decision": "glean",
        "projects": [""]
    },
    {
        "text": "thevaluable.dev/vim-create-text-objects",
        "link": "https://thevaluable.dev/vim-create-text-objects",
        "decision": "glean",
        "projects": [""],
        "reason": "none"
    },
    {
        "link": "https://github.com/noib3/nvim-oxi/tree/main/examples",
        "decision": "glean",
        "projects": [""]
    },
    {
        "link": "https://github.com/Zeioth/NormalNvim",
        "decision": "glean",
        "projects": [""]
    },
    {
        "link": "https://github.com/rezhaTanuharja/minimalistNVIM",
        "decision": "glean",
        "projects": [""],
        "rating": 4.22222,
        "description": "A simple and minimalist NVIM configurations, written in Lua.",
        "reason": "none"
    },
    {
        "text": "typescripttolua.github.io",
        "link": "https://typescripttolua.github.io",
        "decision": "glean",
        "projects": ["async","pluginDev","pluginUtil","proglangSpecific"]
    },
    {
        "link": "https://github.com/nvimdev/nvim-plugin-template",
        "decision": "glean",
        "projects": ["async","pluginDev","pluginUtil","proglangSpecific"]
    },
    {
        "link": "https://github.com/jghauser/kitty-runner.nvim",
        "decision": "glean",
        "projects": ["codeExecution","external","nvimTerminal"],
        "notes": "see what I can replicate in wezterm"
    },
    {
        "text": "[dapExtension] [debug] nvim-dap-kitty-launcher",
        "link": "https://github.com/chunleng/nvim-dap-kitty-launcher",
        "decision": "glean",
        "projects": ["dap"]
    },
    {
        "link": "https://github.com/ten3roberts/qf.nvim",
        "decision": "glean",
        "projects": ["diagnostics"]
    },
    {
        "link": "https://awexplor.github.io/aggregated/neovim",
        "decision": "glean",
        "projects": ["editor"],
        "rating": 4.22222
    },
    {
        "text": "Tightly Integrating Git into Vim :: JakobGM's Homepage",
        "link": "https://jakobgm.com/posts/vim/git-integration",
        "decision": "glean",
        "projects": ["git","grep"]
    },
    {
        "link": "https://github.com/dmmulroy/vim-kitty-navigator|||https://github.com/knubie/vim-kitty-navigator",
        "decision": "glean",
        "projects": ["integration","tmux"]
    },
    {
        "link": "https://github.com/tjdevries/stackmap.nvim",
        "decision": "glean",
        "projects": ["keybind"]
    },
    {
        "text": "nvim-lua/kickstart.nvim: ___ ||| [starter] Read through [kickstart.nvim source code and codumentation",
        "link": "https://github.com/nvim-lua/kickstart.nvim",
        "decision": "glean",
        "projects": ["lsp","nextStep"],
        "rating": 4.22222,
        "description": "A launch point for your personal nvim configuration <#> Kickstart.nvim — это минимальная, хорошо документированная стартовая конфигурация для Neovim, предназначенная для быстрого начала работы и дальнейшей кастомизации."
    },
    {
        "link": "https://github.com/petobens/poet-v",
        "decision": "glean",
        "projects": ["lsp","proglangSpecific","python"]
    },
    {
        "link": "https://github.com/NotAShelf/nvf",
        "decision": "glean",
        "projects": ["nix"]
    },
    {
        "link": "https://ayats.org/blog/neovim-wrapper | https://gvolpe.com/blog/neovim-meets-nix-flakes/",
        "decision": "glean",
        "projects": ["nix"]
    },
    {
        "link": "https://github.com/NixNeovim/NixNeovimPlugins",
        "decision": "glean",
        "projects": ["nix"]
    },
    {
        "link": "https://github.com/ellisonleao/nvim-plugin-template",
        "decision": "glean",
        "projects": ["proglangSpecific","selfReferential"]
    },
    {
        "link": "https://github.com/shortcuts/neovim-plugin-boilerplate",
        "decision": "glean",
        "projects": ["proglangSpecific","selfReferential"]
    },
    {
        "link": "https://github.com/nvim-lua/nvim-lua-plugin-template",
        "decision": "glean",
        "projects": ["proglangSpecific","selfReferential"]
    },
    {
        "link": "https://github.com/m00qek/plugin-template.nvim",
        "decision": "glean",
        "projects": ["proglangSpecific","selfReferential"]
    },
    {
        "link": "https://www.reddit.com/r/neovim/comments/1g4zd75/a_minimalist_setup_for_python_and ||| https://www.reddit.com/r/neovim/comments/1g754tl/a_minimalist_python_debugging_setup_continued",
        "decision": "glean",
        "projects": ["python"],
        "rating": 4.22222
    },
    {
        "link": "https://github.com/mhinz/vim-grepper",
        "decision": "glean",
        "projects": ["search"]
    },
    {
        "link": "https://github.com/vim-ctrlspace/vim-ctrlspace",
        "decision": "glean",
        "projects": ["search"]
    },
    {
        "link": "https://github.com/lolpie244/simple-kitty-runner.nvim",
        "decision": "glean",
        "projects": ["taskRunning"]
    },
    {
        "link": "https://github.com/hkupty/nvimux",
        "decision": "glean",
        "projects": ["tmux"]
    },
    {
        "link": "https://github.com/jglasovic/venv-lsp.nvim",
        "decision": "glean",
        "projects": ["venv"]
    }
]
```

to vendor:

```json
[
    {
        "link": "https://github.com/haolian9/sudo_write.nvim",
        "decision": "vendor",
        "projects": []
    },
    {
        "link": "https://github.com/bartek/epochconverter.nvim",
        "decision": "vendor",
        "projects": []
    },
    {
        "text": "encodings.nvim ",
        "link": "https://github.com/sjjwantfish/encodings.nvim",
        "decision": "vendor",
        "projects": []
    },
    {
        "link": "https://github.com/AbaoFromCUG/intergrater.nvim",
        "decision": "vendor",
        "projects": [],
        "description": "infrastructure of neovim IDE"
    },
    {
        "text": "codeberg.org/Anofio/nvim/src/branch/main/lua/kiradzero/plugins/ui/alpha-nvim.lua",
        "link": "https://codeberg.org/Anofio/nvim/src/branch/main/lua/kiradzero/plugins/ui/alpha-nvim.lua",
        "decision": "vendor",
        "projects": [""],
        "dateCreated": "2024-06-15"
    },
    {
        "link": "https://github.com/yutkat/history-ignore.nvim",
        "decision": "vendor",
        "projects": [""]
    },
    {
        "link": "https://github.com/RRethy/nvim-align",
        "decision": "vendor",
        "projects": ["alignment"]
    },
    {
        "link": "https://github.com/vzze/aligner.nvim",
        "decision": "vendor",
        "projects": ["alignment"]
    },
    {
        "link": "https://github.com/LittleAmara/make.nvim",
        "decision": "vendor",
        "projects": ["build","taskRunning"]
    },
    {
        "text": "refactor.nvim",
        "link": "https://github.com/wakeLanaka/refactor.nvim",
        "decision": "vendor",
        "projects": ["debug","print"]
    },
    {
        "link": "https://github.com/rayzr522/diagnostic-filter.nvim",
        "decision": "vendor",
        "projects": ["diagnostics"]
    },
    {
        "link": "https://github.com/jake-stewart/diagnostic-jump.nvim",
        "decision": "vendor",
        "projects": ["diagnostics"]
    },
    {
        "link": "https://github.com/camilotorresf/icecream.nvim",
        "decision": "vendor",
        "projects": ["diagnostics","proglangSpecific","python"]
    },
    {
        "link": "https://github.com/woosaaahh/debugwin.nvim",
        "decision": "vendor",
        "projects": ["diagnostics","proglangSpecific","python"]
    },
    {
        "text": "vim.api.nvim_create_user_command(“LineDiff1”, function(opts) if opts.range > 0 then print(opts.line1, opts.line2) vim.cmd(opts.line1 .. “,” .. opts.line2 .. “y x”) end end, { force = true, range = true })",
        "link": "",
        "decision": "vendor",
        "projects": ["diff"]
    },
    {
        "link": "https://github.com/l-bowman/timewarp.nvim",
        "decision": "vendor",
        "projects": ["editingEnhancement"],
        "reason": "none"
    },
    {
        "link": "https://github.com/jake-stewart/repeatable.nvim",
        "decision": "vendor",
        "projects": ["editingEnhancement"],
        "reason": "none"
    },
    {
        "link": "https://github.com/ivyl/bling.nvim",
        "decision": "vendor",
        "projects": ["editingEnhancement"],
        "reason": "none"
    },
    {
        "text": "nvim-cursorline appearance",
        "link": "https://github.com/yamatsum/nvim-cursorline",
        "decision": "vendor",
        "projects": ["editingEnhancement"]
    },
    {
        "link": "https://github.com/Sam-programs/expand.nvim",
        "decision": "vendor",
        "projects": ["editingEnhancement"]
    },
    {
        "link": "https://github.com/RutaTang/compter.nvim",
        "decision": "vendor",
        "projects": ["editingEnhancement"]
    },
    {
        "link": "https://github.com/uga-rosa/join.nvim",
        "decision": "vendor",
        "projects": ["editingEnhancement"]
    },
    {
        "link": "https://github.com/adelarsq/showmarks.nvim (fennel)",
        "decision": "vendor",
        "projects": ["editingEnhancement"]
    },
    {
        "text": "vim-highlighturl",
        "link": "https://github.com/itchyny/vim-highlighturl",
        "decision": "vendor",
        "projects": ["editingEnhancement","selection"],
        "reason": "none"
    },
    {
        "link": "https://github.com/c-dilks/notator.nvim",
        "decision": "vendor",
        "projects": ["filetypeSpecific","markdown"]
    },
    {
        "link": "https://github.com/ray-x/telescope-ast-grep.nvim",
        "decision": "vendor",
        "projects": ["grep","search","telescope"]
    },
    {
        "link": "https://github.com/jackMort/so.nvim",
        "decision": "vendor",
        "projects": ["help","specificIntegration"]
    },
    {
        "link": "https://github.com/willothy/wezterm.nvim",
        "decision": "vendor",
        "projects": ["integration"]
    },
    {
        "link": "https://github.com/numToStr/Navigator.nvim",
        "decision": "vendor",
        "projects": ["integration","tmux"]
    },
    {
        "link": "https://github.com/Sam-programs/keymap-tester.nvim",
        "decision": "vendor",
        "projects": ["keybinding","proglangSpecific","testing"]
    },
    {
        "link": "https://github.com/neovim/nvim-lspconfig",
        "decision": "vendor",
        "projects": ["lsp"]
    },
    {
        "link": "TODO: lazy-nix-helper.nvim",
        "decision": "vendor",
        "projects": ["manager","nvimPluginManagement","rtp"]
    },
    {
        "text": "dyninput.nvim",
        "link": "https://github.com/nvimdev/dyninput.nvim",
        "decision": "vendor",
        "projects": ["qol"]
    },
    {
        "text": "chartoggle.nvim",
        "link": "https://github.com/saifulapm/chartoggle.nvim",
        "decision": "vendor",
        "projects": ["qol"]
    },
    {
        "text": "put_at_end.nvim",
        "link": "https://github.com/rareitems/put_at_end.nvim",
        "decision": "vendor",
        "projects": ["qol"]
    },
    {
        "link": "https://github.com/Djancyp/regex.nvim",
        "decision": "vendor",
        "projects": ["regex"]
    },
    {
        "link": "https://github.com/deponian/nvim-scalpelua",
        "decision": "vendor",
        "projects": ["replace"]
    },
    {
        "text": "ReplaceWithRegister search and replace",
        "link": "https://github.com/vim-scripts/ReplaceWithRegister",
        "decision": "vendor",
        "projects": ["replace"],
        "rating": 4.9
    },
    {
        "text": "ReplaceWithSameIndentRegister search and replace",
        "link": "https://github.com/vim-scripts/ReplaceWithSameIndentRegister",
        "decision": "vendor",
        "projects": ["replace"]
    },
    {
        "link": "https://github.com/airblade/vim-rooter",
        "decision": "vendor",
        "projects": ["replace"]
    },
    {
        "link": "https://github.com/desdic/telescope-rooter.nvim",
        "decision": "vendor",
        "projects": ["rootDetector","telescope"]
    },
    {
        "link": "https://github.com/ecthelionvi/NeoView.nvim | https://github.com/Enrique-ZA/nvim-hooklinesinker",
        "decision": "vendor",
        "projects": ["saving"]
    },
    {
        "link": "https://github.com/statiolake/nvim-junkfile | https://github.com/AidanThomas/scratchpad.nvim | https://github.com/adalessa/scratch.nvim",
        "decision": "vendor",
        "projects": ["scratch"]
    }
]
```

to hack on:

```json
[

    {
        "link": "https://github.com/arakkkkk/marktodo.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/Kurama622/profile.nvim",
        "decision": "hack",
        "projects": [""],
        "rating": 4.22222,
        "description": "Your Personal Homepage",
        "reason": "none"
    },
    {
        "link": "https://github.com/freddyJarva/testfile.nvim",
        "decision": "hack",
        "projects": ["coverage","testing"],
        "reason": "none"
    },
    {
        "link": "https://github.com/evdunbar/zathura-md.nvim",
        "decision": "hack",
        "projects": ["filetypeSpecific","markdown"]
    },
    {
        "link": "https://github.com/stevanmilic/nvim-lspimport",
        "decision": "hack",
        "projects": ["lsp"]
    },
    {
        "link": "https://github.com/0x100101/lab.nvim",
        "decision": "hack",
        "projects": ["partialExecution","repl","taskRunning"]
    },
    {
        "link": "https://github.com/jbyuki/dash.nvim",
        "decision": "hack",
        "projects": ["repl"]
    },
    {
        "link": "https://github.com/sourproton/tunnell.nvim",
        "decision": "hack",
        "projects": ["repl"]
    },
    {
        "link": "https://github.com/milanglacier/iron.nvim",
        "decision": "hack",
        "projects": ["repl"]
    },
    {
        "link": "https://github.com/kristijanhusak/line-notes.nvim",
        "decision": "hack",
        "projects": ["scratch"]
    }
]
```

to glean from / hack on later:

```json
[

    {
        "link": "https://github.com/marcushwz/nvim-workbench",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/nagy135/capture-nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/smolck/nvim-todoist.lua",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/arnarg/todotxt.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/NFrid/due.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/defntvdm/todos.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/amiroslaw/taskmaker.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/unamatasanatarai/nvim-md-todo-toggle",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/nocksock/do.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/MaximilianLloyd/todo.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/alex-laycalvert/todo.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/torcor-dev/todoman.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/malramsay64/mind.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/arakkkkk/kanban.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/Cartogy/todo.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/kperath/dailynotes.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/psaikido/lifetrak.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/ca-mantis-shrimp/Todoist.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/jed-richards/todo.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/oncomouse/todo.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/mvolkmann/todo-quickfix.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/rareitems/saved_notes.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/pablopunk/todo.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/mariogarridopt/todo.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/aymenhafeez/scratch.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/yoshigoya/nvim-joplin.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/jungyong0615dot/planner.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/kimpors/plan.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/rrossmiller/tasklist.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/LandonTr0n/taskb0t.nvim",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    },
    {
        "link": "https://github.com/ManasPatil0967/nvim-todo",
        "decision": "rejected",
        "projects": ["productivity","todo"],
        "reason": "none"
    }
]
```
plugins for much later

```json
[

    {
        "link": "https://github.com/numine777/py-bazel.nvim",
        "decision": "laterD",
        "projects": ["build"],
        "reason": "none"
    },
    {
        "link": "https://github.com/David-Kunz/cmp-npm",
        "decision": "laterD",
        "projects": ["completion"]
    },
    {
        "link": "https://github.com/paopaol/cmp-doxygen",
        "decision": "laterD",
        "projects": ["completion"]
    },
    {
        "link": "https://github.com/Jezda1337/cmp_bootstrap",
        "decision": "laterD",
        "projects": ["completion","specificApp"]
    },
    {
        "link": "https://github.com/marioortizmanero/adoc-pdf-live.nvim",
        "decision": "laterD",
        "projects": ["formatSpecific"]
    },
    {
        "link": "https://github.com/tigion/nvim-asciidoc-preview",
        "decision": "laterD",
        "projects": ["formatSpecific"]
    },
    {
        "link": "https://github.com/msr1k/outline-asciidoc-provider.nvim",
        "decision": "laterD",
        "projects": ["formatSpecific"]
    },
    {
        "link": "https://github.com/topaxi/gh-actions.nvim",
        "decision": "laterD",
        "projects": ["github"]
    },
    {
        "link": "https://github.com/liaohui5/vite-server.nvim",
        "decision": "laterD",
        "projects": ["server","webdev"]
    },
    {
        "link": "https://github.com/tomoakley/circleci.nvim",
        "decision": "laterD",
        "projects": ["specificApp"]
    },
    {
        "link": "https://github.com/cvanhoosear/jenkins-linter.nvim",
        "decision": "laterD",
        "projects": ["specificApp"]
    },
    {
        "link": "https://github.com/roobert/tailwindcss-colorizer-cmp.nvim",
        "decision": "laterD",
        "projects": ["specificApp","tailwind"]
    },
    {
        "link": "https://github.com/sigmaSd/nvim-tailwind",
        "decision": "laterD",
        "projects": ["specificApp","tailwind"]
    },
    {
        "link": "https://github.com/laytan/tailwind-sorter.nvim",
        "decision": "laterD",
        "projects": ["specificApp","tailwind"]
    },
    {
        "link": "https://github.com/themaxmarchuk/tailwindcss-colors.nvim",
        "decision": "laterD",
        "projects": ["specificApp","tailwind"]
    },
    {
        "link": "https://github.com/razak17/tailwind-fold.nvim",
        "decision": "laterD",
        "projects": ["specificApp","tailwind"]
    },
    {
        "link": "https://github.com/princejoogie/tailwind-highlight.nvim",
        "decision": "laterD",
        "projects": ["specificApp","tailwind"]
    },
    {
        "link": "https://github.com/ziontee113/deliberate.nvim",
        "decision": "laterD",
        "projects": ["specificApp","tailwind"]
    },
    {
        "link": "https://github.com/MaximilianLloyd/tw-values.nvim",
        "decision": "laterD",
        "projects": ["specificApp","tailwind"]
    },
    {
        "link": "https://github.com/SushyDev/tailwind-linter.nvim",
        "decision": "laterD",
        "projects": ["specificApp","tailwind"]
    },
    {
        "link": "https://github.com/jcha0713/cmp-tw2css",
        "decision": "laterD",
        "projects": ["specificApp","tailwind"]
    },
    {
        "link": "https://github.com/mattn/emmet-vim",
        "decision": "laterD",
        "projects": ["webdev"]
    },
    {
        "link": "https://github.com/cakebaker/scss-syntax.vim",
        "decision": "laterD",
        "projects": ["webdev"]
    },
    {
        "text": "vim-css 3-syntax",
        "link": "https://github.com/hail2u/vim-css",
        "decision": "laterD",
        "projects": ["webdev"]
    },
    {
        "link": "https://github.com/aca/emmet-ls",
        "decision": "laterD",
        "projects": ["webdev"]
    },
    {
        "link": "https://github.com/js-everts/cmp-tailwind-colors",
        "decision": "laterD",
        "projects": ["webdev"]
    },
    {
        "link": "https://github.com/xvzc/chezmoi.nvim",
        "decision": "later",
        "projects": []
    },
    {
        "link": "https://github.com/jasonwoodland/base64.nvim",
        "decision": "later",
        "projects": [""],
        "reason": "none"
    },
    {
        "link": "https://github.com/v1nh1shungry/plantuml-preview.nvim",
        "decision": "later",
        "projects": [""],
        "dateCreated": "2024-06-15",
        "software": ["uml","plantUml"]
    },
    {
        "link": "https://github.com/folke/tokyonight.nvim",
        "decision": "later",
        "projects": [""]
    },
    {
        "link": "https://github.com/miversen33/netman.nvim",
        "decision": "later",
        "projects": [""],
        "rating": 4.9
    },
    {
        "link": "https://github.com/gorbit99/codewindow.nvim",
        "decision": "later",
        "description": "minimap",
        "projects": [""]
    },
    {
        "link": "https://github.com/CamdenClark/flyboy",
        "decision": "later",
        "projects": ["","ai","llm"]
    },
    {
        "link": "https://github.com/pkage/coauthor.nvim",
        "decision": "later",
        "description": "",
        "projects": ["ai"]
    },
    {
        "link": "https://github.com/S1M0N38/dante.nvim",
        "decision": "later",
        "description": "AI for prose",
        "projects": ["ai"]
    },
    {
        "link": "https://github.com/jpmcb/nvim-llama",
        "decision": "later",
        "projects": ["ai","aiAssistant","llama","llm"]
    },
    {
        "link": "https://github.com/jonahgoldwastaken/copilot-status.nvim",
        "decision": "later",
        "projects": ["ai","aiAssistant","llm"]
    },
    {
        "link": "https://github.com/krshrimali/context-pilot.nvim",
        "decision": "later",
        "projects": ["ai","aiAssistant","llm"]
    },
    {
        "text": "copilot.lua suggest, lua rewrite of copilot.vim, still hopping between the .vim and .lua to figure out if this one is just suggesting less but so far I like it a bit better.",
        "link": "https://github.com/zbirenbaum/copilot.lua",
        "decision": "later",
        "projects": ["ai","aiAssistant","llm"]
    },
    {
        "link": "https://github.com/hrsh7th/cmp-copilot",
        "decision": "later",
        "projects": ["ai","aiAssistant","llm"]
    },
    {
        "link": "https://github.com/harjotgill/CodeGPT.nvim",
        "decision": "later",
        "projects": ["ai","aiAssistant","llm","ml"],
        "dateCreated": "2025-05-27"
    },
    {
        "link": "Mintlify Writer",
        "decision": "later",
        "projects": ["ai","docs","llm"]
    },
    {
        "link": "https://github.com/marco-souza/ollero.nvim",
        "decision": "later",
        "projects": ["ai","llama","llm"]
    },
    {
        "link": "https://github.com/nc-glitch/llama_code.nvim",
        "decision": "later",
        "projects": ["ai","llama","llm"]
    },
    {
        "link": "https://github.com/ziontee113/ollama.nvim",
        "decision": "later",
        "projects": ["ai","llama","llm"]
    },
    {
        "link": "https://github.com/dustinblackman/oatmeal.nvim",
        "decision": "later",
        "projects": ["ai","llama","llm"]
    },
    {
        "link": "https://github.com/deifyed/naVi",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/naps62/pair-gpt.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/ribelo/prompter.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/jungyong0615dot/gpt_scratch.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/karintomania/nvim-ai-chat",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/thmsmlr/gpt.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/lvauthrin/chatgpt.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/sigmaSd/chat.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/meinside/openai.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/jay-aye-see-kay/chatbot-buffer.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/Xuyuanp/neochat.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/juliusolson/gpt.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/archibate/nvim-gpt",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/EthanJWright/gpt.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/gsuuon/llm.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/goddoe/nvim-ai-assistant",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/tdfacer/explain-it.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/WhiteBlackGoose/gpt4all.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/rusagaib/oas-preview.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/lu5her-s/neogpt.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/catgoose/chat-gypsy.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/youshyee/gpt.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/CamdenClark/carrier.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/David-Kunz/gen.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/martinra/facileLLM.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/bakks/butterfish.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/conneroisu/documentator.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/joshuavial/aider.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/martineausimon/nvim-bard",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/hesiod-au/mentat.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/mikeslattery/genie.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/Bryley/neoai.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/dpayne/CodeGPT.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/jackMort/ChatGPT.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/jcdickinson/codeium.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/james1236/backseat.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "text": "chatgpt.nvim - 1.4k, chat+refactor, I mean, faster than copy pasting in the browser 😄, allows for some editing of existing code too. (thanks for the suggestion [he_lost](https://www.reddit.com/u/he_lost/) 🙏)",
        "link": "https://github.com/jackmort/chatgpt.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "text": "vim-plugin - 301, suggest, *dead*.",
        "link": "https://github.com/kiteco/vim-plugin",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "text": "ai.vim - 211, generate + refactor, yay! refactor, looks like this one is the closest to what cursor is offering but then also adds trigger based generation, but no fancy diff like [cursor.so](https://cursor.so/). Not sure yet if manual generate is useful if you already have suggest that you can manually trigger after a comment. That would be 95% the same I'm guessing.",
        "link": "https://github.com/aduros/ai.vim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "text": "nvim-magic - 193, generate + refactor, *dead*",
        "link": "https://github.com/jameshiew/nvim-magic",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "text": "tabnine-nvim - 105, suggest, the only decent suggestion by GPT4. GPT4 is getting old already 😅. Not sure how it compares to Codex but doesn't look special. Except of course, on-prem.",
        "link": "https://github.com/codota/tabnine-nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/zbirenbaum/copilot-cmp",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/dense-analysis/neural",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/tzachar/cmp-tabnine",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/gera2ld/ai.nvim",
        "decision": "later",
        "projects": ["ai","llm"]
    },
    {
        "link": "https://github.com/rheinardkorf/nvim-ollama",
        "decision": "later",
        "projects": ["ai","llm","ollama"]
    },
    {
        "link": "https://github.com/nomnivore/ollama.nvim",
        "decision": "later",
        "projects": ["ai","llm","ollama"]
    },
    {
        "link": "https://github.com/huynle/ogpt.nvim",
        "decision": "later",
        "projects": ["ai","llm","ollama"]
    },
    {
        "link": "https://github.com/m-c-frank/mycelium.nvim",
        "decision": "later",
        "projects": ["ai","llm","ollama"]
    },
    {
        "link": "https://github.com/totu/nvim-ollama",
        "decision": "later",
        "projects": ["ai","llm","ollama"]
    },
    {
        "link": "https://github.com/slimslenderslacks/nvim-docker-ai",
        "decision": "later",
        "projects": ["ai","llm","ollama"]
    },
    {
        "link": "https://github.com/krapjost/telescope-gpt.nvim",
        "decision": "later",
        "projects": ["ai","llm","telescope"]
    },
    {
        "link": "https://github.com/diego-rapoport/wt.nvim",
        "decision": "later",
        "projects": ["analytics"]
    },
    {
        "link": "https://github.com/rohanorton/mytime.nvim",
        "decision": "later",
        "projects": ["analytics"]
    },
    {
        "link": "https://github.com/gaborvecsei/usage-tracker.nvim",
        "decision": "later",
        "projects": ["analytics"]
    },
    {
        "link": "https://github.com/mvllow/stand.nvim",
        "decision": "later",
        "projects": ["analytics"]
    },
    {
        "link": "https://github.com/kimpors/progress.nvim",
        "decision": "later",
        "projects": ["analytics"]
    },
    {
        "link": "https://github.com/Lamby777/timewasted.nvim",
        "decision": "later",
        "projects": ["analytics"]
    },
    {
        "link": "https://github.com/OscarCreator/keystats.nvim",
        "decision": "later",
        "projects": ["analytics"]
    },
    {
        "link": "https://github.com/FriedemannG/klog.nvim",
        "decision": "later",
        "projects": ["analytics"]
    },
    {
        "link": "https://github.com/rymdlego/readtime.nvim",
        "decision": "later",
        "projects": ["analytics"]
    },
    {
        "text": "pears.nvim",
        "link": "https://github.com/steelsojka/pears.nvim",
        "decision": "later",
        "projects": ["autoPair"]
    },
    {
        "text": "neoautoTools.nvim",
        "link": "https://github.com/conch2/neoautoTools.nvim",
        "decision": "later",
        "projects": ["autoPair"]
    },
    {
        "text": "nvim-brackets",
        "link": "https://github.com/Sublimeful/nvim-brackets",
        "decision": "later",
        "projects": ["autoPair"]
    },
    {
        "text": "ultimate-autopair.nvim",
        "link": "https://github.com/altermo/ultimate-autopair.nvim",
        "decision": "later",
        "projects": ["autoPair"]
    },
    {
        "text": "enclosing.nvim",
        "link": "https://github.com/wakeLanaka/enclosing.nvim",
        "decision": "later",
        "projects": ["autoPair"]
    },
    {
        "text": "twins.nvim",
        "link": "https://github.com/CozyPenguin/twins.nvim",
        "decision": "later",
        "projects": ["autoPair"]
    },
    {
        "text": "bracketpair.nvim",
        "link": "https://github.com/fedepujol/bracketpair.nvim",
        "decision": "later",
        "projects": ["autoPair"]
    },
    {
        "text": "quote-bracketeer.nvim",
        "link": "https://github.com/Daiki48/quote-bracketeer.nvim",
        "decision": "later",
        "projects": ["autoPair"]
    },
    {
        "text": "tenaille.nvim",
        "link": "https://github.com/doums/tenaille.nvim",
        "decision": "later",
        "projects": ["autoPair"]
    },
    {
        "text": "pairmate.nvim",
        "link": "https://github.com/nvimdev/pairmate.nvim",
        "decision": "later",
        "projects": ["autoPair"]
    },
    {
        "text": "autopairs.nvim",
        "link": "https://github.com/Sam-programs/autopairs.nvim",
        "decision": "later",
        "projects": ["autoPair"]
    },
    {
        "text": "smart-pairs",
        "link": "https://github.com/ZhiyuanLck/smart-pairs",
        "decision": "later",
        "projects": ["autoPair"]
    },
    {
        "text": "nvim-treesitter-pairs",
        "link": "https://github.com/theHamsta/nvim-treesitter-pairs",
        "decision": "later",
        "projects": ["autoPair","treesitter"]
    },
    {
        "link": "https://github.com/zaucy/bazel.nvim",
        "decision": "later",
        "projects": ["build"]
    },
    {
        "link": "https://github.com/alexander-born/bazel.nvim",
        "decision": "later",
        "projects": ["build"]
    },
    {
        "link": "https://github.com/jbyuki/quickmath.nvim",
        "decision": "later",
        "projects": ["calculator","rosetta"]
    },
    {
        "link": "https://github.com/vzze/calculator.nvim",
        "decision": "later",
        "projects": ["calculator","rosetta"]
    },
    {
        "link": "https://github.com/Shatur/neovim-tasks",
        "decision": "later",
        "projects": ["codeRunner"],
        "rating": 4.22222,
        "topics": ["taskRunning"]
    },
    {
        "link": "https://github.com/sainnhe/edge",
        "decision": "later",
        "projects": ["color"],
        "reason": "none"
    },
    {
        "link": "https://github.com/Mofiqul/vscode.nvim",
        "decision": "later",
        "projects": ["color"],
        "rating": 4.22222
    },
    {
        "text": "nvim (catpuccin)",
        "link": "https://github.com/catppuccin/nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/lunarvim/darkplus.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/Mofiqul/dracula.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/Everblush/everblush.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/projekt0n/github-nvim-theme",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/ellisonleao/gruvbox.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/lunarvim/lunar.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/savq/melange-nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/ramojus/mellifluous.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/kvrohit/mellow.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/Yazeed1s/oh-lucy.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/nyoom-engineering/oxocarbon.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/NTBBloodbath/sweetie.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/icymind/NeoSolarized",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/AstroNvim/astrotheme",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/baliestri/aura-theme",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/rafi/awesome-vim-colorschemes",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/ayu-theme/ayu-vim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://neoland.dev/color-schemes",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/lunarvim/colorschemes",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/lourenci/github-colors",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/chama-chomo/grail",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/yuttie/hydrangea-vim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/cocopon/iceberg.vim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/nanotech/jellybeans.vim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/lvim-tech/lvim-colorscheme",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/Gabirel/molokai",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/rafamadriz/neon",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/Shatur/neovim-ayu",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/arcticicestudio/nord-vim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/joshdick/onedark.vim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/drewtempelmeyer/palenight.vim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/junegunn/seoul",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/sainnhe/sonokai",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/srcery-colors/srcery-vim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/AhmedAbdulrahman/vim-aylin",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/SpaceVim/vim-material",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/bluz71/vim-moonfly-colors",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/bluz71/vim-nightfly-colors",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/rakr/vim-one",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "text": "vim-solarized 8.git",
        "link": "https://github.com/lifepillar/vim-solarized",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "text": "vim.git embark-theme",
        "link": "https://github.com/embark-theme/vim.git",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/dracula/vim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/tomasr/molokai",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/rafi/neo-hybrid.vim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/hardhackerlabs/theme-vim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/w0ng/vim-hybrid",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/bluz71/vim-nightfly-guicolors",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/NLKNguyen/papercolor-theme",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/hara/ctrlp-colorscheme",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/lunarvim/horizon.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/marko-cerovac/material.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/loctvl842/monokai-pro.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/tanvirtin/monokai.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/arturgoms/moonbow.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/svrana/neosolarized.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/yorik1984/newpaper.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/nvimdev/nightsky.vim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/aktersnurra/no-clown-fiesta.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/shaunsingh/nord.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/AlexvZyl/nordic.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/andersevenrud/nordic.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/code-biscuits/nvim-biscuits",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/artart222/nvim-enfocado",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/kaiuri/nvim-juliana",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/sam4llis/nvim-tundra",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/navarasu/onedark.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/LunarVim/primer.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "text": "synthwave 84.nvim.git",
        "link": "https://github.com/lunarvim/synthwave",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/tiagovla/tokyodark.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/Zeioth/tokyonight.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/mcchrish/zenbones.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/nvimdev/zephyr-nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/mvllow/naif.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/CreaturePhil/vim-handmade-hero",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "text": "zazen ﻿",
        "link": "https://github.com/zaki/zazen",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/uloco/bluloco.nvim",
        "decision": "later",
        "projects": ["color"]
    },
    {
        "link": "https://github.com/ab-dx/ares.nvim",
        "decision": "later",
        "projects": ["color"],
        "rating": 4.22222,
        "description": "A warm neovim colorscheme",
        "reason": "none"
    },
    {
        "link": "https://github.com/luisiacc/gruvbox-baby",
        "decision": "later",
        "projects": ["color"],
        "reason": "none"
    },
    {
        "link": "https://github.com/propet/colorscheme-persist.nvim",
        "decision": "later",
        "projects": ["color","dynamicTheming"]
    },
    {
        "link": "https://github.com/raddari/last-color.nvim",
        "decision": "later",
        "projects": ["color","dynamicTheming"]
    },
    {
        "link": "https://github.com/ksk0/nvim-fade-color",
        "decision": "later",
        "projects": ["color","dynamicTheming"]
    },
    {
        "link": "https://github.com/eriedaberrie/colorscheme-file.nvim",
        "decision": "later",
        "projects": ["color","dynamicTheming"]
    },
    {
        "link": "https://github.com/AdrianETP/AutoColor.nvim",
        "decision": "later",
        "projects": ["color","dynamicTheming"]
    },
    {
        "link": "https://github.com/lrangell/theme-cycler.nvim",
        "decision": "later",
        "projects": ["color","dynamicTheming"]
    },
    {
        "link": "https://github.com/ZenLian/winddown.nvim",
        "decision": "later",
        "projects": ["color","dynamicTheming"]
    },
    {
        "link": "https://github.com/ollbx/dark-mode-win.nvim",
        "decision": "later",
        "projects": ["color","dynamicTheming"]
    },
    {
        "link": "https://github.com/duboisf/crepuscule.nvim",
        "decision": "later",
        "projects": ["color","dynamicTheming"]
    },
    {
        "link": "https://github.com/dimitriosvalodimos/chameleon.nvim",
        "decision": "later",
        "projects": ["color","dynamicTheming"]
    },
    {
        "link": "https://github.com/runih/colorscheme-picker.nvim",
        "decision": "later",
        "projects": ["color","dynamicTheming"]
    },
    {
        "link": "https://github.com/NTBBloodbath/daylight.nvim",
        "decision": "later",
        "projects": ["color","dynamicTheming","nextStep"]
    },
    {
        "link": "https://github.com/nat-418/cmp-color-names.nvim",
        "decision": "later",
        "projects": ["color","highlight"]
    },
    {
        "link": "https://github.com/nat-418/telescope-color-names.nvim",
        "decision": "later",
        "projects": ["color","highlight","telescope"]
    },
    {
        "link": "https://github.com/theamallalgi/zitchdog",
        "decision": "later",
        "projects": ["color","visual"],
        "rating": 4.22222,
        "description": "A minimal, clean, purple-themed look for Neovim, crafted in Lua. With support for LSP, Treesitter, and essential plugins, it’s all about style and simplicity for a focused coding environment."
    },
    {
        "link": "https://github.com/Lilja/cnotes.nvim",
        "decision": "later",
        "projects": ["consilium","pkm"]
    },
    {
        "link": "https://github.com/hulufei/backlinks.nvim",
        "decision": "later",
        "projects": ["consilium","pkm"]
    },
    {
        "text": "[dapExtension] [debug] npm-dap.nvim",
        "link": "https://github.com/ZyriabDsgn/npm-dap.nvim",
        "decision": "later",
        "projects": ["dap"]
    },
    {
        "text": "[dapExtension] [debug] nvim-dap-dotnet-helper",
        "link": "https://github.com/SteffenBlake/nvim-dap-dotnet-helper",
        "decision": "later",
        "projects": ["dap"]
    },
    {
        "text": "[dapExtension] [debug] nvim-dap-ruby",
        "link": "https://github.com/suketa/nvim-dap-ruby",
        "decision": "later",
        "projects": ["dap"]
    },
    {
        "link": "https://github.com/AlphabetsAlphabets/gdb.nvim",
        "decision": "later",
        "projects": ["dap","debug","linting"]
    },
    {
        "link": "https://github.com/mxsdev/nvim-dap-vscode-js",
        "decision": "later",
        "projects": ["dap","debug","linting"]
    },
    {
        "link": "https://github.com/sakhnik/nvim-gdb",
        "decision": "later",
        "projects": ["dap","debug","linting"]
    },
    {
        "link": "https://github.com/piersolenski/wtf.nvim",
        "decision": "later",
        "projects": ["diagnostics"]
    },
    {
        "link": "https://github.com/gennaro-tedesco/nvim-jqx",
        "decision": "later",
        "projects": ["diagnostics","formatSpecific"],
        "description": "Populate the quickfix with json entries"
    },
    {
        "link": "https://github.com/pfeiferj/nvim-hurl",
        "decision": "later",
        "projects": ["filetypeSpecific"]
    },
    {
        "link": "https://github.com/ethancarlsson/nvim-hurl.nvim",
        "decision": "later",
        "projects": ["filetypeSpecific"]
    },
    {
        "link": "https://github.com/b0o/schemastore.nvim",
        "decision": "later",
        "projects": ["formatSpecific"]
    },
    {
        "link": "https://github.com/Sup3Legacy/json.nvim | https://github.com/rxi/json.lua",
        "decision": "later",
        "projects": ["formatSpecific","pluginDev"]
    },
    {
        "link": "https://github.com/MunifTanjim/prettier.nvim",
        "decision": "later",
        "projects": ["formatting","javascript","typescript"]
    },
    {
        "link": "https://github.com/numToStr/prettierrc.nvim",
        "decision": "later",
        "projects": ["formatting","javascript","typescript"]
    },
    {
        "link": "https://github.com/davidosomething/format-ts-errors.nvim",
        "decision": "later",
        "projects": ["formatting","javascript","typescript"]
    },
    {
        "link": "https://github.com/ldelossa/gh.nvim",
        "decision": "later",
        "projects": ["github"]
    },
    {
        "link": "https://github.com/muryp/nvim-muryp",
        "decision": "later",
        "projects": ["github"]
    },
    {
        "link": "https://github.com/mistweaverco/githubutils.nvim",
        "decision": "later",
        "projects": ["github"]
    },
    {
        "link": "https://github.com/muryp/muryp-gh.nvim",
        "decision": "later",
        "projects": ["github"]
    },
    {
        "link": "https://github.com/pwntester/codeql.nvim",
        "decision": "later",
        "projects": ["github"]
    },
    {
        "link": "https://github.com/rlch/github-notifications.nvim",
        "decision": "later",
        "projects": ["github"]
    },
    {
        "link": "https://github.com/linrongbin16/gitlinker.nvim",
        "decision": "later",
        "projects": ["github"]
    },
    {
        "link": "https://github.com/liouk/gitlinks.nvim",
        "decision": "later",
        "projects": ["github"]
    },
    {
        "link": "https://github.com/RyugaXhypeR/git_link.nvim",
        "decision": "later",
        "projects": ["github"]
    },
    {
        "link": "https://github.com/9seconds/repolink.nvim",
        "decision": "later",
        "projects": ["github"]
    },
    {
        "link": "https://github.com/josephwoodward/github-browse.nvim",
        "decision": "later",
        "projects": ["github"]
    },
    {
        "link": "https://github.com/juacker/git-link.nvim",
        "decision": "later",
        "projects": ["github"]
    },
    {
        "link": "https://github.com/SebastienLeonce/nvim-codeowners",
        "decision": "later",
        "projects": ["github"]
    },
    {
        "link": "https://github.com/rsreimer/codeowners.nvim",
        "decision": "later",
        "projects": ["github"]
    },
    {
        "text": "neovim editor extensions",
        "link": "https://docs.gitlab.com/ee/editor_extensions/neovim",
        "decision": "later",
        "projects": ["gitlab"]
    },
    {
        "link": "https://github.com/thibthib18/glab.nvim",
        "decision": "later",
        "projects": ["gitlab"]
    },
    {
        "link": "https://github.com/EpiCanard/tanu.nvim",
        "decision": "later",
        "projects": ["gitlab"]
    },
    {
        "link": "https://github.com/vaidotasp/gitlab-open.nvim",
        "decision": "later",
        "projects": ["gitlab"]
    },
    {
        "link": "https://github.com/tachyons/gitlab.nvim",
        "decision": "later",
        "projects": ["gitlab"]
    },
    {
        "link": "https://github.com/lrfurtado/telescope-gitlab.nvim",
        "decision": "later",
        "projects": ["gitlab","telescope"]
    },
    {
        "link": "https://github.com/Lilja/zellij.nvim",
        "decision": "later",
        "projects": ["integration"]
    },
    {
        "link": "https://github.com/mfussenegger/nvim-jdtls",
        "decision": "later",
        "notes": "https://tarkalabs.com/blogs/neovim-as-java-ide/",
        "projects": ["java","proglangSpecific"]
    },
    {
        "link": "https://github.com/weskeiser/svelte-hop.nvim",
        "decision": "later",
        "projects": ["javascript","specificApp"]
    },
    {
        "link": "https://github.com/stoleruradu/nodejstools.nvim",
        "decision": "later",
        "projects": ["javascript","specificApp"]
    },
    {
        "link": "https://github.com/sigmaSd/deno-nvim",
        "decision": "later",
        "projects": ["javascript","specificApp"]
    },
    {
        "link": "https://github.com/Fire-The-Fox/bun.nvim",
        "decision": "later",
        "projects": ["javascript","specificApp"]
    },
    {
        "link": "https://github.com/abelfubu/nvim-treesitter-angular",
        "decision": "later",
        "projects": ["javascript","specificApp","treesitter"]
    },
    {
        "link": "https://github.com/gi4c0/lint-node.nvim",
        "decision": "later",
        "projects": ["javascript","typescript"]
    },
    {
        "link": "https://github.com/tamton-aquib/zone.nvim",
        "decision": "later",
        "projects": ["joke"]
    },
    {
        "link": "https://github.com/allaman/kustomize.nvim",
        "decision": "later",
        "projects": ["kubernetes","llm"]
    },
    {
        "link": "https://github.com/cristianoliveira/snipgpt.nvim",
        "decision": "later",
        "projects": ["llm","snippets"]
    },
    {
        "link": "https://github.com/nvim-neorg/neorg-telescope",
        "decision": "later",
        "projects": ["neorg","noteTaking","orgmode","telescope"]
    },
    {
        "link": "https://github.com/nvim-neotest/neotest-vim-test",
        "decision": "later",
        "projects": ["neotestAdapter","next","testing"]
    },
    {
        "link": "https://github.com/olimorris/neotest-phpunit",
        "decision": "later",
        "projects": ["neotestAdapter","next","testing"]
    },
    {
        "link": "https://github.com/haydenmeade/neotest-jest",
        "decision": "later",
        "projects": ["neotestAdapter","next","testing"]
    },
    {
        "link": "https://github.com/nvim-neotest/neotest-go",
        "decision": "later",
        "projects": ["neotestAdapter","next","testing"]
    },
    {
        "link": "https://github.com/GarciaBarreiro/nvim-pandoc",
        "decision": "later",
        "projects": ["pandoc"]
    },
    {
        "link": "https://github.com/kamalsacranie/pandoc-preview.nvim",
        "decision": "later",
        "projects": ["pandoc"]
    },
    {
        "link": "https://github.com/ahollister/wp-utils.nvim",
        "decision": "later",
        "projects": ["specificApp"]
    },
    {
        "link": "https://github.com/markemmons/neotest-deno",
        "decision": "later",
        "projects": ["typescript"]
    },
    {
        "link": "https://github.com/winston0410/range-highlight.nvim",
        "decision": "extra",
        "projects": ["asciiArt","fun"]
    },
    {
        "link": "https://github.com/narutoxy/dim.lua",
        "decision": "extra",
        "projects": ["asciiArt","fun"]
    },
    {
        "link": "https://github.com/superhawk610/ascii-blocks.nvim",
        "decision": "extra",
        "projects": ["asciiArt","fun"]
    },
    {
        "link": "https://github.com/MaximilianLloyd/ascii.nvim",
        "decision": "extra",
        "projects": ["asciiArt","fun"]
    },
    {
        "link": "https://github.com/olidacombe/commentalist.nvim",
        "decision": "extra",
        "projects": ["asciiArt","fun"]
    },
    {
        "link": "https://github.com/ColaMint/pokemon.nvim",
        "decision": "extra",
        "projects": ["asciiArt","fun"]
    },
    {
        "text": "stylish.nvim",
        "link": "https://github.com/sunjon/stylish.nvim",
        "decision": "extra",
        "description": "includes smooth scrolling",
        "projects": ["consilium","fun","scrolling"]
    },
    {
        "link": "https://github.com/aPeoplesCalendar/apc.nvim",
        "decision": "extra",
        "projects": ["fun"],
        "reason": "none"
    },
    {
        "link": "https://github.com/manyids2/htmlgui.nvim",
        "decision": "extra",
        "projects": ["fun"]
    },
    {
        "link": "https://github.com/Hanaasagi/anime.nvim",
        "decision": "extra",
        "projects": ["fun"]
    },
    {
        "link": "https://github.com/njegg/dvd.nvim",
        "decision": "extra",
        "projects": ["fun"]
    },
    {
        "link": "https://github.com/whleucka/reverb.nvim",
        "decision": "extra",
        "projects": ["fun"]
    },
    {
        "link": "https://github.com/neysanfoo/party.nvim",
        "decision": "extra",
        "projects": ["fun"]
    },
    {
        "link": "https://github.com/jbyuki/swan.lua",
        "decision": "extra",
        "projects": ["fun"]
    },
    {
        "link": "https://github.com/jbyuki/venn.nvim",
        "decision": "extra",
        "projects": ["fun"],
        "rating": 4.999
    },
    {
        "link": "https://github.com/paradoxskin/boringBubble.nvim",
        "decision": "extra",
        "projects": ["fun"]
    },
    {
        "text": "browsing the internet from neovim",
        "link": "https://www.reddit.com/r/neovim/comments/1bsow29/browsing_the_internet_from_neovim/",
        "decision": "extra",
        "projects": ["fun"]
    },
    {
        "link": "https://github.com/alanfortlink/blackjack.nvim",
        "decision": "extra",
        "projects": ["fun","game"]
    },
    {
        "link": "https://github.com/jim-fx/sudoku.nvim",
        "decision": "extra",
        "projects": ["fun","game"]
    },
    {
        "link": "https://github.com/tamton-aquib/duck.nvim",
        "decision": "extra",
        "projects": ["fun","game"]
    },
    {
        "link": "https://github.com/letieu/hacker.nvim",
        "decision": "extra",
        "projects": ["fun","game"]
    },
    {
        "link": "https://github.com/nvimdev/3danimation.nvim",
        "decision": "extra",
        "projects": ["fun","game"]
    },
    {
        "link": "https://github.com/rktjmp/shenzhen-solitaire.nvim",
        "decision": "extra",
        "projects": ["fun","game"]
    },
    {
        "link": "https://github.com/efueyo/td.nvim",
        "decision": "extra",
        "projects": ["fun","game"]
    },
    {
        "link": "https://github.com/Febri-i/snake.nvim",
        "decision": "extra",
        "projects": ["fun","game"]
    },
    {
        "link": "https://github.com/kiyoon/nvim-hand-gesture",
        "decision": "extra",
        "projects": ["fun","nextStep"],
        "rating": 4.99
    },
    {
        "link": "https://github.com/0oAstro/silicon.lua",
        "decision": "extra",
        "projects": ["screenRecording"]
    },
    {
        "text": "presence.nvim (Discord Rich Presence)",
        "link": "https://github.com/andweeb/presence.nvim",
        "decision": "extra",
        "projects": ["specificApp"]
    },
    {
        "link": "https://github.com/huynle/bible.nvim",
        "decision": "extra",
        "projects": ["specificApp"]
    }
]
```
