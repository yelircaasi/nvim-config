```nix
{
  description = "nvim plugins bundled in a derivation using linkFarm";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      pluginA = pkgs.stdenv.mkDerivation {
        name = "plugin-a";
        src = pkgs.emptyDirectory;
        installPhase = ''
          mkdir -p $out/plugin $out/lua
          echo 'vim.notify("plugin-a loaded")' > $out/plugin/plugin_a.lua
          echo 'return {}' > $out/lua/plugin_a.lua
        '';
      };

      pluginB = pkgs.stdenv.mkDerivation {
        name = "plugin-b";
        src = pkgs.emptyDirectory;
        installPhase = ''
          mkdir -p $out/plugin $out/lua
          echo 'vim.notify("plugin-b loaded")' > $out/plugin/plugin_b.lua
          echo 'return {}' > $out/lua/plugin_b.lua
        '';
      };

      # bundle

      pluginList = [ pluginA pluginB ];

      nvimPlugins = pkgs.linkFarm "nvim-plugins"
        (map (p: { name = p.name; path = p; }) pluginList);

    in
    {
      packages.${system} = {
        inherit pluginA pluginB nvimPlugins;
        default = nvimPlugins;
      };
    };
}
```

A few things worth noting:

- `pkgs.emptyDirectory` is the neatest way to provide a no-op `src` for a plugin I'm building from scratch in `installPhase`. No need for a `dontUnpack` dance.
- Each plugin gets its own store path with a proper `plugin/` and `lua/` layout, -> realistic stubs.
- The bundle is the `default` package, so `nix build` from the flake root gives you the `linkFarm` result. I can inspect it with something like:

```bash
nix build
ls -la result/               # output:  plugin-a/  plugin-b/
ls result/plugin-a/plugin/   # output:  plugin_a.lua
```

- Individual plugins are also exposed as named packages, so `nix build .#pluginA` works for debugging.