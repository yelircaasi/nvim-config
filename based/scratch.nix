# home.nix
let
  myTreesitter = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
  myPlugins = with pkgs.vimPlugins; [
    oil-nvim
    blink-cmp
    luasnip
    rustaceanvim
    myTreesitter
  ];

  idLookup = {}; # for plugins lacking p.src.owner and p.src.repo

  toLuaTable = plugins: 
    let
      getPluginId = p: 
        if (p ? src && p.src ? owner && p.src ? repo) then
          "${p.src.owner}/${p.src.repo}"
        else
          idLookup.${p.pname};

      lines = map (p: ''  ["${getPluginId p}"] = { path = "${p}" },'') plugins;
    in
    "return {\n" + (builtins.concatStringsSep "\n" lines) + "\n}\n";
in {
  home.file.".config/nvim/lua/nix_plugins.lua".text = toLuaTable myPlugins;
}

# old:

/* 

let
  myPlugins = with pkgs.vimPlugins; [
    oil-nvim
    blink-cmp
    luasnip
    rustaceanvim
  ];

  toLuaTable = plugins: 
    let
      # Extraction Logic:
      # If it's from GitHub, we get "owner/repo".
      # Otherwise, we fall back to the package name.
      getPluginId = p: 
        if (p ? src && p.src ? owner && p.src ? repo) then
          "${p.src.owner}/${p.src.repo}"
        else 
          p.pname;

      lines = map (p: "  [\"${getPluginId p}\"] = { path = \"${p}\" },") plugins;
    in
    "return {\n" + (builtins.concatStringsSep "\n" lines) + "\n}";
in {
  home.file.".config/nvim/lua/nix_plugins.lua".text = toLuaTable myPlugins;
  home.
}

*/