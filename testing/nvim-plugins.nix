{pkgs, lib}:
let custom = {
    cosmic-ui = pkgs.vimUtils.buildVimPlugin {
        pname = "cosmic-ui";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//CosmicNvim/cosmic-ui/";
            name = "cosmic-ui";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//CosmicNvim/cosmic-ui/";
    };
    nvim-api-wrappers = pkgs.vimUtils.buildVimPlugin {
        pname = "nvim-api-wrappers";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//anuvyklack/nvim-api-wrappers/";
            name = "nvim-api-wrappers";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//anuvyklack/nvim-api-wrappers/";
    };
    cmdTree = pkgs.vimUtils.buildVimPlugin {
        pname = "cmdTree";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//CWood-sdf/cmdTree.nvim/";
            name = "cmdTree";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//CWood-sdf/cmdTree.nvim/";
    };
    nvim-treesitter = pkgs.vimUtils.buildVimPlugin {
        pname = "nvim-treesitter";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//nvim-treesitter/nvim-treesitter/";
            name = "nvim-treesitter";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//nvim-treesitter/nvim-treesitter/";
    };
    symbols = pkgs.vimUtils.buildVimPlugin {
        pname = "symbols";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//oskarrrrrrr/symbols.nvim/";
            name = "symbols";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//oskarrrrrrr/symbols.nvim/";
    };
    TreePin = pkgs.vimUtils.buildVimPlugin {
        pname = "TreePin";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//KaitlynEthylia/TreePin/";
            name = "TreePin";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//KaitlynEthylia/TreePin/";
    };
    virtcolumn = pkgs.vimUtils.buildVimPlugin {
        pname = "virtcolumn";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//xiyaowong/virtcolumn.nvim/";
            name = "virtcolumn";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//xiyaowong/virtcolumn.nvim/";
    };
    heirline-components = pkgs.vimUtils.buildVimPlugin {
        pname = "heirline-components";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Zeioth/heirline-components.nvim/";
            name = "heirline-components";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Zeioth/heirline-components.nvim/";
    };
    nougat = pkgs.vimUtils.buildVimPlugin {
        pname = "nougat";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//MunifTanjim/nougat.nvim/";
            name = "nougat";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//MunifTanjim/nougat.nvim/";
    };
    winbar = pkgs.vimUtils.buildVimPlugin {
        pname = "winbar";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Alighorab/winbar.nvim/";
            name = "winbar";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Alighorab/winbar.nvim/";
    };
    minibar = pkgs.vimUtils.buildVimPlugin {
        pname = "minibar";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//aktersnurra/minibar.nvim/";
            name = "minibar";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//aktersnurra/minibar.nvim/";
    };
    bafa = pkgs.vimUtils.buildVimPlugin {
        pname = "bafa";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//mistweaverco/bafa.nvim/";
            name = "bafa";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//mistweaverco/bafa.nvim/";
    };
    windline = pkgs.vimUtils.buildVimPlugin {
        pname = "windline";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//windwp/windline.nvim/";
            name = "windline";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//windwp/windline.nvim/";
    };
    pickme = pkgs.vimUtils.buildVimPlugin {
        pname = "pickme";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//2KAbhishek/pickme.nvim/";
            name = "pickme";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//2KAbhishek/pickme.nvim/";
    };
    deck = pkgs.vimUtils.buildVimPlugin {
        pname = "deck";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//hrsh7th/nvim-deck/";
            name = "deck";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//hrsh7th/nvim-deck/";
    };
    ido = pkgs.vimUtils.buildVimPlugin {
        pname = "ido";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//shoumodip/ido.nvim/";
            name = "ido";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//shoumodip/ido.nvim/";
    };
    telescope-repo = pkgs.vimUtils.buildVimPlugin {
        pname = "telescope-repo";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//cljoly/telescope-repo.nvim/";
            name = "telescope-repo";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//cljoly/telescope-repo.nvim/";
    };
    telescope-json-history = pkgs.vimUtils.buildVimPlugin {
        pname = "telescope-json-history";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//cosminadrianpopescu/telescope-json-history.nvim/";
            name = "telescope-json-history";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//cosminadrianpopescu/telescope-json-history.nvim/";
    };
    blink = pkgs.vimUtils.buildVimPlugin {
        pname = "TODO: separate packages";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//saghen/blink.nvim/";
            name = "blink";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//saghen/blink.nvim/";
    };
    hlsearch = pkgs.vimUtils.buildVimPlugin {
        pname = "hlsearch";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//nvimdev/hlsearch.nvim/";
            name = "hlsearch";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//nvimdev/hlsearch.nvim/";
    };
    search-replace = pkgs.vimUtils.buildVimPlugin {
        pname = "search-replace";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//mosheavni/search-replace.nvim/";
            name = "search-replace";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//mosheavni/search-replace.nvim/";
    };
    sad = pkgs.vimUtils.buildVimPlugin {
        pname = "sad";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//ray-x/sad.nvim/";
            name = "sad";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//ray-x/sad.nvim/";
    };
    nvim_winpick = pkgs.vimUtils.buildVimPlugin {
        pname = "nvim_winpick";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//MarcusGrass/nvim_winpick/";
            name = "nvim_winpick";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//MarcusGrass/nvim_winpick/";
    };
    flybuf = pkgs.vimUtils.buildVimPlugin {
        pname = "flybuf";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//nvimdev/flybuf.nvim/";
            name = "flybuf";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//nvimdev/flybuf.nvim/";
    };
    stickybuf = pkgs.vimUtils.buildVimPlugin {
        pname = "stickybuf";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//stevearc/stickybuf.nvim/";
            name = "stickybuf";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//stevearc/stickybuf.nvim/";
    };
    swm = pkgs.vimUtils.buildVimPlugin {
        pname = "swm";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//hrsh7th/nvim-swm/";
            name = "swm";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//hrsh7th/nvim-swm/";
    };
    retrospect = pkgs.vimUtils.buildVimPlugin {
        pname = "retrospect";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//mrquantumcodes/retrospect.nvim/";
            name = "retrospect";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//mrquantumcodes/retrospect.nvim/";
    };
    vuffers.nvim = pkgs.vimUtils.buildVimPlugin {
        pname = "vuffers.nvim";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Hajime-Suzuki/vuffers.nvim/";
            name = "vuffers.nvim";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Hajime-Suzuki/vuffers.nvim/";
    };
    pragma.nvim = pkgs.vimUtils.buildVimPlugin {
        pname = "pragma.nvim";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//DrKGD/pragma.nvim/";
            name = "pragma.nvim";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//DrKGD/pragma.nvim/";
    };
    wrapping-paper = pkgs.vimUtils.buildVimPlugin {
        pname = "wrapping-paper";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//benlubas/wrapping-paper.nvim/";
            name = "wrapping-paper";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//benlubas/wrapping-paper.nvim/";
    };
    savior = pkgs.vimUtils.buildVimPlugin {
        pname = "savior";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//willothy/savior.nvim/";
            name = "savior";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//willothy/savior.nvim/";
    };
    zpragmatic = pkgs.vimUtils.buildVimPlugin {
        pname = "zpragmatic";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//muhammadzkralla/zpragmatic.nvim/";
            name = "zpragmatic";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//muhammadzkralla/zpragmatic.nvim/";
    };
    neowords = pkgs.vimUtils.buildVimPlugin {
        pname = "neowords";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//backdround/neowords.nvim/";
            name = "neowords";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//backdround/neowords.nvim/";
    };
    vim-edgemotion = pkgs.vimUtils.buildVimPlugin {
        pname = "vim-edgemotion";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//haya14busa/vim-edgemotion/";
            name = "vim-edgemotion";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//haya14busa/vim-edgemotion/";
    };
    treemonkey = pkgs.vimUtils.buildVimPlugin {
        pname = "treemonkey";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//atusy/treemonkey.nvim/";
            name = "treemonkey";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//atusy/treemonkey.nvim/";
    };
    hierarchy = pkgs.vimUtils.buildVimPlugin {
        pname = "hierarchy";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Slyces/hierarchy.nvim/";
            name = "hierarchy";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Slyces/hierarchy.nvim/";
    };
    navigator.lua = pkgs.vimUtils.buildVimPlugin {
        pname = "navigator.lua";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//ray-x/navigator.lua/";
            name = "navigator.lua";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//ray-x/navigator.lua/";
    };
    insx = pkgs.vimUtils.buildVimPlugin {
        pname = "insx";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//hrsh7th/nvim-insx/";
            name = "insx";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//hrsh7th/nvim-insx/";
    };
    apm = pkgs.vimUtils.buildVimPlugin {
        pname = "apm";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//pseudocc/nvim-apm/";
            name = "apm";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//pseudocc/nvim-apm/";
    };
    keymapper = pkgs.vimUtils.buildVimPlugin {
        pname = "keymapper";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//bgrohman/nvim-keymapper/";
            name = "keymapper";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//bgrohman/nvim-keymapper/";
    };
    keyseer = pkgs.vimUtils.buildVimPlugin {
        pname = "keyseer";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//jokajak/keyseer.nvim/";
            name = "keyseer";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//jokajak/keyseer.nvim/";
    };
    keytex = pkgs.vimUtils.buildVimPlugin {
        pname = "keytex";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//cronJohn/keytex.nvim/";
            name = "keytex";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//cronJohn/keytex.nvim/";
    };
    keylab = pkgs.vimUtils.buildVimPlugin {
        pname = "keylab";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//BooleanCube/keylab.nvim/";
            name = "keylab";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//BooleanCube/keylab.nvim/";
    };
    xkbswitch = pkgs.vimUtils.buildVimPlugin {
        pname = "xkbswitch";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//ivanesmantovich/xkbswitch.nvim/";
            name = "xkbswitch";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//ivanesmantovich/xkbswitch.nvim/";
    };
    cyrillic = pkgs.vimUtils.buildVimPlugin {
        pname = "cyrillic";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//nativerv/cyrillic.nvim/";
            name = "cyrillic";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//nativerv/cyrillic.nvim/";
    };
    homerows = pkgs.vimUtils.buildVimPlugin {
        pname = "homerows";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//kbario/homerows.nvim/";
            name = "homerows";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//kbario/homerows.nvim/";
    };
    wf = pkgs.vimUtils.buildVimPlugin {
        pname = "wf";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Cassin01/wf.nvim/";
            name = "wf";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Cassin01/wf.nvim/";
    };
    NeoComposer = pkgs.vimUtils.buildVimPlugin {
        pname = "NeoComposer";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//lvim-tech/NeoComposer.nvim/";
            name = "NeoComposer";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//lvim-tech/NeoComposer.nvim/";
    };
    nvim-macros = pkgs.vimUtils.buildVimPlugin {
        pname = "nvim-macros";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//kr40/nvim-macros/";
            name = "nvim-macros";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//kr40/nvim-macros/";
    };
    recorder = pkgs.vimUtils.buildVimPlugin {
        pname = "recorder";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//chrisgrieser/nvim-recorder/";
            name = "recorder";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//chrisgrieser/nvim-recorder/";
    };
    indentmini = pkgs.vimUtils.buildVimPlugin {
        pname = "indentmini";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//nvimdev/indentmini.nvim/";
            name = "indentmini";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//nvimdev/indentmini.nvim/";
    };
    anydent = pkgs.vimUtils.buildVimPlugin {
        pname = "anydent";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//hrsh7th/nvim-anydent/";
            name = "anydent";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//hrsh7th/nvim-anydent/";
    };
    todo-comments = pkgs.vimUtils.buildVimPlugin {
        pname = "TODO-comments-nvim";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//folke/todo-comments.nvim/";
            name = "todo-comments";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//folke/todo-comments.nvim/";
    };
    splitjoin = pkgs.vimUtils.buildVimPlugin {
        pname = "splitjoin";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//bennypowers/splitjoin.nvim/";
            name = "splitjoin";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//bennypowers/splitjoin.nvim/";
    };
    spread = pkgs.vimUtils.buildVimPlugin {
        pname = "spread";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//aarondiel/spread.nvim/";
            name = "spread";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//aarondiel/spread.nvim/";
    };
    harpoon-core = pkgs.vimUtils.buildVimPlugin {
        pname = "harpoon-core";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//MeanderingProgrammer/harpoon-core.nvim/";
            name = "harpoon-core";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//MeanderingProgrammer/harpoon-core.nvim/";
    };
    markit = pkgs.vimUtils.buildVimPlugin {
        pname = "markit";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//2KAbhishek/markit.nvim/";
            name = "markit";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//2KAbhishek/markit.nvim/";
    };
    spear = pkgs.vimUtils.buildVimPlugin {
        pname = "spear";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//kbario/spear.nvim/";
            name = "spear";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//kbario/spear.nvim/";
    };
    whaler = pkgs.vimUtils.buildVimPlugin {
        pname = "whaler";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//SalOrak/whaler.nvim/";
            name = "whaler";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//SalOrak/whaler.nvim/";
    };
    pasta = pkgs.vimUtils.buildVimPlugin {
        pname = "pasta";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//hrsh7th/nvim-pasta/";
            name = "pasta";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//hrsh7th/nvim-pasta/";
    };
    wastebin = pkgs.vimUtils.buildVimPlugin {
        pname = "wastebin";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//matze/wastebin.nvim/";
            name = "wastebin";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//matze/wastebin.nvim/";
    };
    lazyclip = pkgs.vimUtils.buildVimPlugin {
        pname = "lazyclip";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//atiladefreitas/lazyclip/";
            name = "lazyclip";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//atiladefreitas/lazyclip/";
    };
    beam = pkgs.vimUtils.buildVimPlugin {
        pname = "beam";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Piotr1215/beam.nvim/";
            name = "beam";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Piotr1215/beam.nvim/";
    };
    ax = pkgs.vimUtils.buildVimPlugin {
        pname = "ax";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//mikeslattery/ax.nvim/";
            name = "ax";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//mikeslattery/ax.nvim/";
    };
    AdvancedNewFile = pkgs.vimUtils.buildVimPlugin {
        pname = "AdvancedNewFile";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Mohammed-Taher/AdvancedNewFile.nvim/";
            name = "AdvancedNewFile";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Mohammed-Taher/AdvancedNewFile.nvim/";
    };
    dotdot = pkgs.vimUtils.buildVimPlugin {
        pname = "dotdot";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://codeberg.org//hernandez/dotdot.nvim/";
            name = "dotdot";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://codeberg.org//hernandez/dotdot.nvim/";
    };
    minimal-narrow-region = pkgs.vimUtils.buildVimPlugin {
        pname = "minimal-narrow-region";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//bagohart/minimal-narrow-region.nvim/";
            name = "minimal-narrow-region";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//bagohart/minimal-narrow-region.nvim/";
    };
    date-time-inserter = pkgs.vimUtils.buildVimPlugin {
        pname = "date-time-inserter";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//AntonVanAssche/date-time-inserter.nvim/";
            name = "date-time-inserter";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//AntonVanAssche/date-time-inserter.nvim/";
    };
    bullets = pkgs.vimUtils.buildVimPlugin {
        pname = "bullets";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//kaymmm/bullets.nvim/";
            name = "bullets";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//kaymmm/bullets.nvim/";
    };
    vim-caser = pkgs.vimUtils.buildVimPlugin {
        pname = "vim-caser";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//arthurxavierx/vim-caser/";
            name = "vim-caser";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//arthurxavierx/vim-caser/";
    };
    inlayhint-filler = pkgs.vimUtils.buildVimPlugin {
        pname = "inlayhint-filler";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//davidyz/inlayhint-filler.nvim/";
            name = "inlayhint-filler";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//davidyz/inlayhint-filler.nvim/";
    };
    ivy = pkgs.vimUtils.buildVimPlugin {
        pname = "ivy";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//AdeAttwood/ivy.nvim/";
            name = "ivy";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//AdeAttwood/ivy.nvim/";
    };
    nvim-cmp-fonts = pkgs.vimUtils.buildVimPlugin {
        pname = "nvim-cmp-fonts";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//amarakon/nvim-cmp-fonts/";
            name = "nvim-cmp-fonts";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//amarakon/nvim-cmp-fonts/";
    };
    nvim-cmp-lua-latex-symbols = pkgs.vimUtils.buildVimPlugin {
        pname = "nvim-cmp-lua-latex-symbols";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//amarakon/nvim-cmp-lua-latex-symbols/";
            name = "nvim-cmp-lua-latex-symbols";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//amarakon/nvim-cmp-lua-latex-symbols/";
    };
    cmp-nvim-telekasten-tags = pkgs.vimUtils.buildVimPlugin {
        pname = "cmp-nvim-telekasten-tags";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Cybolic/cmp-nvim-telekasten-tags/";
            name = "cmp-nvim-telekasten-tags";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Cybolic/cmp-nvim-telekasten-tags/";
    };
    cmp_bulma = pkgs.vimUtils.buildVimPlugin {
        pname = "cmp_bulma";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//garyhurtz/cmp_bulma.nvim/";
            name = "cmp_bulma";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//garyhurtz/cmp_bulma.nvim/";
    };
    efm = pkgs.vimUtils.buildVimPlugin {
        pname = "efm";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//mattn/efm-langserver/";
            name = "efm";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//mattn/efm-langserver/";
    };
    output-panel = pkgs.vimUtils.buildVimPlugin {
        pname = "output-panel";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//mhanberg/output-panel.nvim/";
            name = "output-panel";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//mhanberg/output-panel.nvim/";
    };
    control-panel = pkgs.vimUtils.buildVimPlugin {
        pname = "control-panel";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//mhanberg/control-panel.nvim/";
            name = "control-panel";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//mhanberg/control-panel.nvim/";
    };
    corn = pkgs.vimUtils.buildVimPlugin {
        pname = "corn";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//RaafatTurki/corn.nvim/";
            name = "corn";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//RaafatTurki/corn.nvim/";
    };
    error-jump = pkgs.vimUtils.buildVimPlugin {
        pname = "error-jump";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Dr-42/error-jump.nvim/";
            name = "error-jump";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Dr-42/error-jump.nvim/";
    };
    doc-window = pkgs.vimUtils.buildVimPlugin {
        pname = "doc-window";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//resonyze/doc-window.nvim/";
            name = "doc-window";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//resonyze/doc-window.nvim/";
    };
    telescope-code-actions = pkgs.vimUtils.buildVimPlugin {
        pname = "telescope-code-actions";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//nyarthan/telescope-code-actions.nvim/";
            name = "telescope-code-actions";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//nyarthan/telescope-code-actions.nvim/";
    };
    dmap = pkgs.vimUtils.buildVimPlugin {
        pname = "dmap";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//doums/dmap.nvim/";
            name = "dmap";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//doums/dmap.nvim/";
    };
    debugpy = pkgs.vimUtils.buildVimPlugin {
        pname = "debugpy";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//HiPhish/debugpy.nvim/";
            name = "debugpy";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//HiPhish/debugpy.nvim/";
    };
    pylsp-rope = pkgs.vimUtils.buildVimPlugin {
        pname = "TODO: move to external tools";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//python-rope/pylsp-rope/";
            name = "pylsp-rope";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//python-rope/pylsp-rope/";
    };
    jvim = pkgs.vimUtils.buildVimPlugin {
        pname = "jvim";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//ThePrimeagen/jvim.nvim/";
            name = "jvim";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//ThePrimeagen/jvim.nvim/";
    };
    jsonpath = pkgs.vimUtils.buildVimPlugin {
        pname = "jsonpath";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//phelipetls/jsonpath.nvim/";
            name = "jsonpath";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//phelipetls/jsonpath.nvim/";
    };
    sortjson = pkgs.vimUtils.buildVimPlugin {
        pname = "sortjson";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//2nthony/sortjson.nvim/";
            name = "sortjson";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//2nthony/sortjson.nvim/";
    };
    quicktype = pkgs.vimUtils.buildVimPlugin {
        pname = "quicktype";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//midoBB/nvim-quicktype/";
            name = "quicktype";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//midoBB/nvim-quicktype/";
    };
    yaml = pkgs.vimUtils.buildVimPlugin {
        pname = "yaml";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "/https://tangled.org/cuducos.me/yaml.nvim/";
            name = "yaml";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "/https://tangled.org/cuducos.me/yaml.nvim/";
    };
    strict = pkgs.vimUtils.buildVimPlugin {
        pname = "strict";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//emileferreira/nvim-strict/";
            name = "strict";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//emileferreira/nvim-strict/";
    };
    code_runner = pkgs.vimUtils.buildVimPlugin {
        pname = "code_runner";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//CRAG666/code_runner.nvim/";
            name = "code_runner";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//CRAG666/code_runner.nvim/";
    };
    yabs = pkgs.vimUtils.buildVimPlugin {
        pname = "yabs";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//pianocomposer321/officer.nvim/";
            name = "yabs";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//pianocomposer321/officer.nvim/";
    };
    jaq-nvim = pkgs.vimUtils.buildVimPlugin {
        pname = "jaq-nvim";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//is0n/jaq-nvim/";
            name = "jaq-nvim";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//is0n/jaq-nvim/";
    };
    moonicipal = pkgs.vimUtils.buildVimPlugin {
        pname = "moonicipal";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//idanarye/nvim-moonicipal/";
            name = "moonicipal";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//idanarye/nvim-moonicipal/";
    };
    telemake = pkgs.vimUtils.buildVimPlugin {
        pname = "telemake";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//ChSotiriou/nvim-telemake/";
            name = "telemake";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//ChSotiriou/nvim-telemake/";
    };
    equals = pkgs.vimUtils.buildVimPlugin {
        pname = "equals";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//liborw/equals/";
            name = "equals";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//liborw/equals/";
    };
    telescope-xc = pkgs.vimUtils.buildVimPlugin {
        pname = "telescope-xc";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//joerdav/telescope-xc.nvim/";
            name = "telescope-xc";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//joerdav/telescope-xc.nvim/";
    };
    resin = pkgs.vimUtils.buildVimPlugin {
        pname = "resin";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//fdschmidt93/resin.nvim/";
            name = "resin";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//fdschmidt93/resin.nvim/";
    };
    repl = pkgs.vimUtils.buildVimPlugin {
        pname = "repl";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//pappasam/nvim-repl/";
            name = "repl";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//pappasam/nvim-repl/";
    };
    yarepl = pkgs.vimUtils.buildVimPlugin {
        pname = "yarepl";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//milanglacier/yarepl.nvim/";
            name = "yarepl";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//milanglacier/yarepl.nvim/";
    };
    channelot = pkgs.vimUtils.buildVimPlugin {
        pname = "channelot";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//idanarye/nvim-channelot/";
            name = "channelot";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//idanarye/nvim-channelot/";
    };
    cmdbuf = pkgs.vimUtils.buildVimPlugin {
        pname = "cmdbuf";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//notomo/cmdbuf.nvim/";
            name = "cmdbuf";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//notomo/cmdbuf.nvim/";
    };
    mypy = pkgs.vimUtils.buildVimPlugin {
        pname = "mypy";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//feakuru/mypy.nvim/";
            name = "mypy";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//feakuru/mypy.nvim/";
    };
    Launch = pkgs.vimUtils.buildVimPlugin {
        pname = "Launch";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Beloin/Launch.nvim/";
            name = "Launch";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Beloin/Launch.nvim/";
    };
    tracebundler = pkgs.vimUtils.buildVimPlugin {
        pname = "tracebundler";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//notomo/tracebundler.nvim/";
            name = "tracebundler";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//notomo/tracebundler.nvim/";
    };
    termim = pkgs.vimUtils.buildVimPlugin {
        pname = "termim";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//2KAbhishek/termim.nvim/";
            name = "termim";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//2KAbhishek/termim.nvim/";
    };
    neaterm = pkgs.vimUtils.buildVimPlugin {
        pname = "neaterm";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Dan7h3x/neaterm.nvim/";
            name = "neaterm";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Dan7h3x/neaterm.nvim/";
    };
    neomux = pkgs.vimUtils.buildVimPlugin {
        pname = "neomux";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//nikvdp/neomux/";
            name = "neomux";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//nikvdp/neomux/";
    };
    project = pkgs.vimUtils.buildVimPlugin {
        pname = "project";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Zeioth/project.nvim/";
            name = "project";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Zeioth/project.nvim/";
    };
    monorepos = pkgs.vimUtils.buildVimPlugin {
        pname = "monorepos";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//sajjathossain/nvim-monorepos/";
            name = "monorepos";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//sajjathossain/nvim-monorepos/";
    };
    projector = pkgs.vimUtils.buildVimPlugin {
        pname = "projector";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//smolovk/projector.nvim/";
            name = "projector";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//smolovk/projector.nvim/";
    };
    forgit = pkgs.vimUtils.buildVimPlugin {
        pname = "forgit";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//ray-x/forgit.nvim/";
            name = "forgit";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//ray-x/forgit.nvim/";
    };
    jujutsu = pkgs.vimUtils.buildVimPlugin {
        pname = "jujutsu";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//yannvanhalewyn/jujutsu.nvim/";
            name = "jujutsu";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//yannvanhalewyn/jujutsu.nvim/";
    };
    jiejie = pkgs.vimUtils.buildVimPlugin {
        pname = "jiejie";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//jceb/jiejie.nvim/";
            name = "jiejie";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//jceb/jiejie.nvim/";
    };
    g-worktree = pkgs.vimUtils.buildVimPlugin {
        pname = "g-worktree";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Mohanbarman/g-worktree.nvim/";
            name = "g-worktree";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Mohanbarman/g-worktree.nvim/";
    };
    gitlab-nvim = pkgs.vimUtils.buildVimPlugin {
        pname = "gitlab-nvim";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//harrisoncramer/gitlab.nvim/";
            name = "gitlab-nvim";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//harrisoncramer/gitlab.nvim/";
    };
    octohub = pkgs.vimUtils.buildVimPlugin {
        pname = "octohub";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//2KAbhishek/octohub.nvim/";
            name = "octohub";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//2KAbhishek/octohub.nvim/";
    };
    dashboard = pkgs.vimUtils.buildVimPlugin {
        pname = "dashboard";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//MeanderingProgrammer/dashboard.nvim/";
            name = "dashboard";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//MeanderingProgrammer/dashboard.nvim/";
    };
    modes = pkgs.vimUtils.buildVimPlugin {
        pname = "modes";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//mvllow/modes.nvim/";
            name = "modes";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//mvllow/modes.nvim/";
    };
    lvim-ui-config = pkgs.vimUtils.buildVimPlugin {
        pname = "lvim-ui-config";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//lvim-tech/lvim-ui-config/";
            name = "lvim-ui-config";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//lvim-tech/lvim-ui-config/";
    };
    bye-nerdfont = pkgs.vimUtils.buildVimPlugin {
        pname = "bye-nerdfont";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//dullmode/bye-nerdfont.nvim/";
            name = "bye-nerdfont";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//dullmode/bye-nerdfont.nvim/";
    };
    reactive = pkgs.vimUtils.buildVimPlugin {
        pname = "reactive";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//rasulomaroff/reactive.nvim/";
            name = "reactive";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//rasulomaroff/reactive.nvim/";
    };
    fsplash = pkgs.vimUtils.buildVimPlugin {
        pname = "fsplash";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//jovanlanik/fsplash.nvim/";
            name = "fsplash";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//jovanlanik/fsplash.nvim/";
    };
    sunglasses = pkgs.vimUtils.buildVimPlugin {
        pname = "sunglasses";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//miversen33/sunglasses.nvim/";
            name = "sunglasses";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//miversen33/sunglasses.nvim/";
    };
    runtimetable = pkgs.vimUtils.buildVimPlugin {
        pname = "runtimetable";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//notomo/runtimetable.nvim/";
            name = "runtimetable";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//notomo/runtimetable.nvim/";
    };
    web-tools = pkgs.vimUtils.buildVimPlugin {
        pname = "web-tools";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//ray-x/web-tools.nvim/";
            name = "web-tools";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//ray-x/web-tools.nvim/";
    };
    Calendar = pkgs.vimUtils.buildVimPlugin {
        pname = "Calendar";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//ds1sqe/Calendar.nvim/";
            name = "Calendar";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//ds1sqe/Calendar.nvim/";
    };
    http-codes = pkgs.vimUtils.buildVimPlugin {
        pname = "http-codes";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//barrettruth/http-codes.nvim/";
            name = "http-codes";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//barrettruth/http-codes.nvim/";
    };
    auto-pandoc = pkgs.vimUtils.buildVimPlugin {
        pname = "auto-pandoc";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//jghauser/auto-pandoc.nvim/";
            name = "auto-pandoc";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//jghauser/auto-pandoc.nvim/";
    };
    vale = pkgs.vimUtils.buildVimPlugin {
        pname = "vale";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//marcelofern/vale.nvim/";
            name = "vale";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//marcelofern/vale.nvim/";
    };
    present = pkgs.vimUtils.buildVimPlugin {
        pname = "present";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Chaitanyabsprip/present.nvim/";
            name = "present";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Chaitanyabsprip/present.nvim/";
    };
    flashcards = pkgs.vimUtils.buildVimPlugin {
        pname = "flashcards";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//alex-laycalvert/flashcards.nvim/";
            name = "flashcards";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//alex-laycalvert/flashcards.nvim/";
    };
    license = pkgs.vimUtils.buildVimPlugin {
        pname = "license";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//KronsyC/nvim-license/";
            name = "license";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//KronsyC/nvim-license/";
    };
    live-server = pkgs.vimUtils.buildVimPlugin {
        pname = "live-server";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//barrett-ruth/live-server.nvim/";
            name = "live-server";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//barrett-ruth/live-server.nvim/";
    };
    nvim-mail-merge = pkgs.vimUtils.buildVimPlugin {
        pname = "nvim-mail-merge";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//martineausimon/nvim-mail-merge/";
            name = "nvim-mail-merge";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//martineausimon/nvim-mail-merge/";
    };
    better-digraphs = pkgs.vimUtils.buildVimPlugin {
        pname = "better-digraphs";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//protex/better-digraphs.nvim/";
            name = "better-digraphs";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//protex/better-digraphs.nvim/";
    };
    qalc = pkgs.vimUtils.buildVimPlugin {
        pname = "qalc";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Apeiros-46B/qalc.nvim/";
            name = "qalc";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Apeiros-46B/qalc.nvim/";
    };
    tldr = pkgs.vimUtils.buildVimPlugin {
        pname = "tldr";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//acuteenvy/tldr.nvim/";
            name = "tldr";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//acuteenvy/tldr.nvim/";
    };
    pre-commit = pkgs.vimUtils.buildVimPlugin {
        pname = "pre-commit";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Ttibsi/pre-commit.nvim/";
            name = "pre-commit";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Ttibsi/pre-commit.nvim/";
    };
    endpoint-previewer = pkgs.vimUtils.buildVimPlugin {
        pname = "endpoint-previewer";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//tlj/endpoint-previewer.nvim/";
            name = "endpoint-previewer";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//tlj/endpoint-previewer.nvim/";
    };
    fsread = pkgs.vimUtils.buildVimPlugin {
        pname = "fsread";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//nullchilly/fsread.nvim/";
            name = "fsread";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//nullchilly/fsread.nvim/";
    };
    feed = pkgs.vimUtils.buildVimPlugin {
        pname = "feed";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//neo451/feed.nvim/";
            name = "feed";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//neo451/feed.nvim/";
    };
    nerdy = pkgs.vimUtils.buildVimPlugin {
        pname = "nerdy";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//2KAbhishek/nerdy.nvim/";
            name = "nerdy";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//2KAbhishek/nerdy.nvim/";
    };
    interlaced = pkgs.vimUtils.buildVimPlugin {
        pname = "interlaced";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//tanloong/interlaced.nvim/";
            name = "interlaced";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//tanloong/interlaced.nvim/";
    };
    texmagic = pkgs.vimUtils.buildVimPlugin {
        pname = "texmagic";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//jakewvincent/texmagic.nvim/";
            name = "texmagic";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//jakewvincent/texmagic.nvim/";
    };
    drop = pkgs.vimUtils.buildVimPlugin {
        pname = "drop";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//folke/drop.nvim/";
            name = "drop";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//folke/drop.nvim/";
    };
    regex-vars = pkgs.vimUtils.buildVimPlugin {
        pname = "regex-vars";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//jake-stewart/regex-vars.nvim/";
            name = "regex-vars";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//jake-stewart/regex-vars.nvim/";
    };
    regexplainer = pkgs.vimUtils.buildVimPlugin {
        pname = "regexplainer";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//bennypowers/nvim-regexplainer/";
            name = "regexplainer";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//bennypowers/nvim-regexplainer/";
    };
    Hypersonic = pkgs.vimUtils.buildVimPlugin {
        pname = "Hypersonic";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//tomiis4/Hypersonic.nvim/";
            name = "Hypersonic";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//tomiis4/Hypersonic.nvim/";
    };
    structlog = pkgs.vimUtils.buildVimPlugin {
        pname = "structlog";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Tastyep/structlog.nvim/";
            name = "structlog";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Tastyep/structlog.nvim/";
    };
    color-picker = pkgs.vimUtils.buildVimPlugin {
        pname = "color-picker";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//ziontee113/color-picker.nvim/";
            name = "color-picker";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//ziontee113/color-picker.nvim/";
    };
    export-colorscheme = pkgs.vimUtils.buildVimPlugin {
        pname = "export-colorscheme";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//jpe90/export-colorscheme.nvim/";
            name = "export-colorscheme";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//jpe90/export-colorscheme.nvim/";
    };
    kreative = pkgs.vimUtils.buildVimPlugin {
        pname = "kreative";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//katawful/kreative/";
            name = "kreative";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//katawful/kreative/";
    };
    text-to-colorscheme = pkgs.vimUtils.buildVimPlugin {
        pname = "text-to-colorscheme";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//svermeulen/text-to-colorscheme/";
            name = "text-to-colorscheme";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//svermeulen/text-to-colorscheme/";
    };
    easycolor = pkgs.vimUtils.buildVimPlugin {
        pname = "easycolor";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//neph-iap/easycolor.nvim/";
            name = "easycolor";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//neph-iap/easycolor.nvim/";
    };
    paint = pkgs.vimUtils.buildVimPlugin {
        pname = "paint";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//folke/paint.nvim/";
            name = "paint";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//folke/paint.nvim/";
    };
    kubels = pkgs.vimUtils.buildVimPlugin {
        pname = "kubels";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//elasticrash/kubels.nvim/";
            name = "kubels";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//elasticrash/kubels.nvim/";
    };
    kubernetes = pkgs.vimUtils.buildVimPlugin {
        pname = "kubernetes";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//diogo464/kubernetes.nvim/";
            name = "kubernetes";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//diogo464/kubernetes.nvim/";
    };
    kpops = pkgs.vimUtils.buildVimPlugin {
        pname = "kpops";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//disrupted/kpops.nvim/";
            name = "kpops";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//disrupted/kpops.nvim/";
    };
    k8vim = pkgs.vimUtils.buildVimPlugin {
        pname = "k8vim";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//alonso-montero/k8vim.nvim/";
            name = "k8vim";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//alonso-montero/k8vim.nvim/";
    };
    kubectl = pkgs.vimUtils.buildVimPlugin {
        pname = "kubectl";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//michaelPotter/kubectl.nvim/";
            name = "kubectl";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//michaelPotter/kubectl.nvim/";
    };
    vim-ai = pkgs.vimUtils.buildVimPlugin {
        pname = "vim-ai";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//madox2/vim-ai/";
            name = "vim-ai";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//madox2/vim-ai/";
    };
    metrics = pkgs.vimUtils.buildVimPlugin {
        pname = "metrics";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//mgerb/metrics.nvim/";
            name = "metrics";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//mgerb/metrics.nvim/";
    };
    orgmode = pkgs.vimUtils.buildVimPlugin {
        pname = "orgmode";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//nvim-orgmode/orgmode/";
            name = "orgmode";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//nvim-orgmode/orgmode/";
    };
    twig = pkgs.vimUtils.buildVimPlugin {
        pname = "twig";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//hugginsio/twig.nvim/";
            name = "twig";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//hugginsio/twig.nvim/";
    };
    neorg-taskwarrior = pkgs.vimUtils.buildVimPlugin {
        pname = "neorg-taskwarrior";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//skbolton/neorg-taskwarrior/";
            name = "neorg-taskwarrior";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//skbolton/neorg-taskwarrior/";
    };
    daily-focus = pkgs.vimUtils.buildVimPlugin {
        pname = "daily-focus";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//steveclarke/daily-focus.nvim/";
            name = "daily-focus";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//steveclarke/daily-focus.nvim/";
    };
    nomodoro = pkgs.vimUtils.buildVimPlugin {
        pname = "nomodoro";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//dbinagi/nomodoro/";
            name = "nomodoro";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//dbinagi/nomodoro/";
    };
    pommodoro-clock = pkgs.vimUtils.buildVimPlugin {
        pname = "pommodoro-clock";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//jackMort/pommodoro-clock.nvim/";
            name = "pommodoro-clock";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//jackMort/pommodoro-clock.nvim/";
    };
    timew = pkgs.vimUtils.buildVimPlugin {
        pname = "timew";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//eliasCVII/timew.nvim/";
            name = "timew";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//eliasCVII/timew.nvim/";
    };
    pomodoro = pkgs.vimUtils.buildVimPlugin {
        pname = "pomodoro";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//wthollingsworth/pomodoro.nvim/";
            name = "pomodoro";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//wthollingsworth/pomodoro.nvim/";
    };
    tdo = pkgs.vimUtils.buildVimPlugin {
        pname = "tdo";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//2KAbhishek/tdo.nvim/";
            name = "tdo";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//2KAbhishek/tdo.nvim/";
    };
    tktodo = pkgs.vimUtils.buildVimPlugin {
        pname = "tktodo";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//tarting/tktodo.nvim/";
            name = "tktodo";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//tarting/tktodo.nvim/";
    };
    zettelkasten = pkgs.vimUtils.buildVimPlugin {
        pname = "zettelkasten";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Furkanzmc/zettelkasten.nvim/";
            name = "zettelkasten";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Furkanzmc/zettelkasten.nvim/";
    };
    sche = pkgs.vimUtils.buildVimPlugin {
        pname = "sche";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Cassin01/sche.nvim/";
            name = "sche";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Cassin01/sche.nvim/";
    };
    flote = pkgs.vimUtils.buildVimPlugin {
        pname = "flote";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//JellyApple102/flote.nvim/";
            name = "flote";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//JellyApple102/flote.nvim/";
    };
    quicknote = pkgs.vimUtils.buildVimPlugin {
        pname = "quicknote";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//RutaTang/quicknote.nvim/";
            name = "quicknote";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//RutaTang/quicknote.nvim/";
    };
    scratch-buffer = pkgs.vimUtils.buildVimPlugin {
        pname = "scratch-buffer";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//miguelcrespo/scratch-buffer.nvim/";
            name = "scratch-buffer";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//miguelcrespo/scratch-buffer.nvim/";
    };
    edit-list = pkgs.vimUtils.buildVimPlugin {
        pname = "edit-list";
        version = "PLACEHOLDER";
        src = builtins.fetchGit {
            url = "https://github.com//Sharonex/edit-list.nvim/";
            name = "edit-list";
            rev = "PLACEHOLD_REV";
            hash = "PLACEHOLDER_HASH";
        };
        meta.homepage = "https://github.com//Sharonex/edit-list.nvim/";
    };
}; in {
    # config to go here
}