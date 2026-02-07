# home.nix
let
  in {
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
  
}

*/